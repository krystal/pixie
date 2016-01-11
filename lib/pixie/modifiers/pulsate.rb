require 'pixie/modifiers/abstract'

module Pixie
  module Modifiers
    class Pulsate < Abstract

      def get_current_frame(current_states)

        if reversed?
          if current_frame < speed
            brightness = (speed - (current_frame % speed + 1)) / speed.to_f
          else
            brightness = (current_frame % speed + 1) / speed.to_f
          end
        else
          if current_frame < speed
            brightness = (current_frame % speed + 1) / speed.to_f
          else
            brightness = (speed - (current_frame % speed + 1)) / speed.to_f
          end
        end


        brightness = brightness ** 2
        current_states.each_with_object({}) do |(led_id, state), hash|
          hash[led_id] = state.brightness(brightness * 100)
        end
      end

      def total_number_of_frames
        speed * 2
      end

      private

      def speed
        options[:speed] || 120
      end

    end
  end
end
