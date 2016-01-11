require 'pixie/modifiers/abstract'

module Pixie
  module Modifiers
    class FadeIn < Abstract

      def get_current_frame(current_states)
        brightness = (current_frame + 1) / speed.to_f
        brightness = brightness ** 2
        current_states.each_with_object({}) do |(led_id, state), hash|
          hash[led_id] = state.brightness(brightness * 100)
        end
      end

      def total_number_of_frames
        speed
      end

      private

      def speed
        options[:speed] || 120
      end

    end
  end
end
