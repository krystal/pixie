require 'pixie/sequences/abstract'

module Pixie
  module Sequences
    class Static < Abstract

      def get_current_frame(current_state)
        if current_frame == 0
          element.leds.each_with_object({}) do |led_id, hash|
            hash[led_id] = options[:color] || State[:on]
          end
        else
          nil
        end
      end

      def total_number_of_frames
        1
      end

    end
  end
end
