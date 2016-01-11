require 'pixie/state'
require 'pixie/color'
require 'pixie/unit'
require 'pixie/element'
require 'pixie/track'
require 'pixie/dsl/basic'

require 'pixie/sequences/static'
require 'pixie/sequences/worm'
require 'pixie/sequences/strobe'

require 'pixie/modifiers/fade_out'
require 'pixie/modifiers/fade_in'
require 'pixie/modifiers/pulsate'

module Pixie
  class Universe

    def initialize(show_path = nil)
      if show_path && File.directory?(show_path)
        dsl = DSL::Basic.new(self)
        ['units', 'elements', 'tracks'].each do |type|
          ["#{type}.rb", "#{type}/*.rb"].each do |match|
            Dir[File.join(show_path, match)].each do |file|
              dsl.instance_eval(File.read(file), file)
            end
          end
        end
      end
    end

    def define(&block)
      dsl = DSL::Basic.new(self)
      dsl.instance_eval(&block)
      dsl
    end

    def units
      @units ||= {}
    end

    def elements
      @elements ||= {}
    end

    def tracks
      @tracks ||= {}
    end

    def all_off
      units.values.each do |unit|
        last_element = self.elements.values.select { |e| e.unit == unit.id }.map(&:leds).flatten.sort.last
        led_states = (last_element + 1).times.map { Color[0,0,0].to_bytes }
        unit.send_udp_packet(led_states.join)
      end
    end

    def play_track(name)
      self.all_off
      track = tracks[name]
      return false unless track

      running_sequences = {}
      running_modifiers = {}
      frame_contents = {}
      previous_states = {}
      additional_instructions = []
      last_frame_time = Time.now
      $start_time = Time.now.to_f
      current_frame = 0
      last_instruction_found_at = nil
      loop do
        begin
          STDIN.read_nonblock(10)
          puts "\e[32mCurrent Time: #{Time.now.to_f - $start_time}\e[0m"
        rescue IO::WaitReadable
        end

        time_now = Time.now.to_f
        instructions = []
        track.instructions.sort_by { |k,v| k }.each do |key, inst|
          if key < time_now - $start_time && (last_instruction_found_at.nil? || key > last_instruction_found_at)
            instructions += inst
            last_instruction_found_at = key
          end
        end

        (instructions + additional_instructions).each do |instruction|
          puts "\e[34m#{(Time.now.to_f - $start_time).round(4)}...#{current_frame}\e[0m   #{instruction}"
          case instruction[:action]
          when :run
            element   = self.elements[instruction[:on]]
            if running_sequences[element] && instruction[:continue]
              start_frame = running_sequences[element].current_frame
            else
              start_frame = 0
            end
            element_unit = self.units[element.unit]
            previous_states[element] = element.leds.each_with_object({}) do |led_id, hash|
              hash[led_id] = frame_contents[element_unit] ? frame_contents[element_unit][led_id] : nil
            end
            running_sequences[element] = instruction[:sequence].new(element, start_frame, instruction)
          when :modify
            element = self.elements[instruction[:on]]
            running_modifiers[element] = instruction[:modifier].new(element, 0, instruction)
          when :stop
            element = self.elements[instruction[:element]]
            running_sequences.delete(element)
          when :clear
            element = self.elements[instruction[:element]]
            if unit = self.units[element.unit]
              element.leds.each do |led_id|
                frame_contents[unit][led_id] = nil
              end
            end
          when :finish
            all_off
            Process.exit
          when :start_music
            track.start_music
          when :stop_music
            track.stop_music
          end
        end
        additional_instructions = []

        self.units.each do |_, unit|
          frame_contents[unit] ||= []

          running_sequences.each do |element, sequence|
            sequence_frame = sequence.get_current_frame_safely(previous_states[element])
            unless sequence_frame
              if sequence.repeat?
                sequence.repeat!
                sequence_frame = sequence.get_current_frame_safely(previous_states[element])
              else
                running_sequences.delete(element)
                break
              end
            end

            if modifier = running_modifiers[element]
              modified_frame = modifier.get_current_frame_safely(sequence_frame)
              unless modified_frame
                if modifier.repeat?
                  modifier.repeat!
                  modified_frame = modifier.get_current_frame_safely(sequence_frame)
                else
                  running_modifiers.delete(element)
                end
              end
              if modifier.last_frame? && modifier.instruction[:after]
                additional_instructions += modifier.instruction[:after]
              end

              modifier.increment_current_frame
              if modified_frame
                sequence_frame = modified_frame
              end
            end

            if sequence.last_frame? && sequence.instruction[:after]
              additional_instructions += sequence.instruction[:after]
            end

            sequence.increment_current_frame
            previous_states[element].merge(sequence_frame).each do |led_id, color|
              frame_contents[unit][led_id] = color
            end
          end

          led_states = frame_contents[unit].map do |color|
            color ? color.to_color.to_bytes : "\0\0\0"
          end

          unit.send_udp_packet(led_states.join)

          loop do
            break if Time.now - last_frame_time >= 1.0 / track.frame_rate
          end
          last_frame_time = Time.now
          current_frame += 1
        end
      end

    end

  end
end
