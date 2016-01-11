require 'pixie/state'
require 'pixie/color'
require 'pixie/unit'
require 'pixie/element'
require 'pixie/track'
require 'pixie/run'
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

    def run(track_name)
      if track = tracks[track_name.to_sym]
        Run.new(self, track)
      else
        nil
      end
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

  end
end
