require 'pixie/sequences/abstract'

module Pixie
  module Sequences
    class Strobe < Abstract

      def get_current_frame(current_state)
        element.leds.each_with_object({}) do |led_id, hash|
          hash[led_id] = current_frame < speed ? options[:color] || State[:on] : State[:off]
        end
      end

      def total_number_of_frames
        speed * 2
      end

      private

      def speed
        options[:speed] || 2
      end

    end
  end
end
