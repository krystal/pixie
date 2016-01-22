module Pixie
  class Run

    def initialize(universe, track)
      @universe = universe
      @track = track

      @running_sequences = {}
      @running_modifiers = {}
      @frame_contents = {}
      @previous_states = {}
      @additional_instructions = []
      @current_frame = 0
      @last_instruction_found_at = nil
    end

    def go
      @last_frame_time = Time.now
      @start_time = Time.now.to_f
      @universe.all_off
      loop do
        capture_enter_for_current_time
        @time_now = Time.now.to_f
        handle_instructions
        @universe.units.each do |_,unit|
          set_frame_for_unit(unit)
          send_frame_to_unit(unit)
        end
        loop do
          break if Time.now - @last_frame_time >= 1.0 / @track.frame_rate
        end
        @last_frame_time = Time.now
        @current_frame += 1
      end
    end

    private

    def capture_enter_for_current_time
      begin
        STDIN.read_nonblock(10)
        puts "\e[32mCurrent Time: #{Time.now.to_f - @start_time}\e[0m"
      rescue IO::WaitReadable
      end
    end

    def get_current_instructions
      instructions = []
      @track.instructions.sort_by { |k,v| k }.each do |key, inst|
        if key < @time_now - @start_time && (@last_instruction_found_at.nil? || key > @last_instruction_found_at)
          instructions += inst
          @last_instruction_found_at = key
        end
      end
      instructions
    end

    def handle_instructions
      (get_current_instructions + @additional_instructions).each do |instruction|
        puts instruction.inspect
        puts "\e[34m#{(Time.now.to_f - @start_time).round(4)}...#{@current_frame}\e[0m   #{instruction}"
        case instruction[:action]
        when :run
          element = @universe.elements[instruction[:on]]
          if @running_sequences[element] && instruction[:continue]
            start_frame = @running_sequences[element].current_frame
          else
            start_frame = 0
          end
          element_unit = @universe.units[element.unit]
          @previous_states[element] = element.leds.each_with_object({}) do |led_id, hash|
            hash[led_id] = @frame_contents[element_unit] ? @frame_contents[element_unit][led_id] : nil
          end
          @running_sequences[element] = instruction[:sequence].new(element, start_frame, instruction)
        when :modify
          element = @universe.elements[instruction[:on]]
          @running_modifiers[element] = instruction[:modifier].new(element, 0, instruction)
        when :stop
          element = @universe.elements[instruction[:element]]
          @running_sequences.delete(element)
        when :clear
          element = @universe.elements[instruction[:element]]
          if unit = @universe.units[element.unit]
            element.leds.each do |led_id|
              @frame_contents[unit][led_id] = nil
            end
          end
        when :finish
          @universe.all_off
          Process.exit
        when :start_music
          @track.start_music
        when :stop_music
          @track.stop_music
        end
      end
      @additional_instructions = []
    end

    def set_frame_for_unit(unit)
      @frame_contents[unit] ||= []
      @running_sequences.each do |element, sequence|
        next unless element.unit == unit.id
        sequence_frame = sequence.get_current_frame_safely(@previous_states[element])
        unless sequence_frame
          if sequence.repeat?
            sequence.repeat!
            sequence_frame = sequence.get_current_frame_safely(@previous_states[element])
          else
            @running_sequences.delete(element)
            break
          end
        end

        if modifier = @running_modifiers[element]
          modified_frame = modifier.get_current_frame_safely(sequence_frame)
          unless modified_frame
            if modifier.repeat?
              modifier.repeat!
              modified_frame = modifier.get_current_frame_safely(sequence_frame)
            else
              @running_modifiers.delete(element)
            end
          end
          if modifier.last_frame? && modifier.instruction[:after]
            @additional_instructions += modifier.instruction[:after]
          end

          modifier.increment_current_frame
          if modified_frame
            sequence_frame = modified_frame
          end
        end

        if sequence.last_frame? && sequence.instruction[:after]
          @additional_instructions += sequence.instruction[:after]
        end

        sequence.increment_current_frame
        @previous_states[element].merge(sequence_frame).each do |led_id, color|
          @frame_contents[unit][led_id] = color
        end
      end
    end

    def send_frame_to_unit(unit)
      led_states = @frame_contents[unit].map do |color|
        color ? color.to_color.to_bytes : "\0\0\0"
      end
      unit.send_udp_packet(led_states.join)
    end

  end
end
