require 'pixie/sequences/abstract'

module Pixie
  module Sequences
    class Worm < Abstract

      def get_current_frame(current_state)
        Hash.new.tap do |frame|
          number_of_worms.times do |wn|
            worm_color = usable_worm_colors[wn]
            worm_start = ((worm_length + gap_between_worms) * -wn) + current_frame
            if worm_start >= 0
              frame[leds[worm_start]] = worm_color
            end

            worm_length.times do |m|
              index = worm_start - m - 1
              # If there's a physical LED for the item behind the dot. May not exist
              # if the initial dot is at the beginning of the strip.
              if index >= 0 && led = leds[index]
                # Turn the brightness down appropriate as the length gets longer
                frame[led] = options[:fade_tail] == false ? worm_color : worm_color.brightness(100.0 / (m+1))
              end
            end
          end
        end
      end

      def total_number_of_frames
        ((worm_length + gap_between_worms) * number_of_worms) + element.led_count
      end

      private

      def color
        @color ||= options[:color] || Color[255, 255, 255]
      end

      def worm_length
        @worm_length ||= options[:worm_length] || 5
      end

      def number_of_worms
        @number_of_worms ||= options[:number_of_worms] || 1
      end

      def gap_between_worms
        @gap_between_worms ||= options[:gap_between_worms] || 10
      end

      def worm_colors
        @worm_colors ||= options[:worm_colors] || [color]
      end

      def usable_worm_colors
        @usable_worm_colors ||= number_of_worms.times.map do |i|
          options[:randomize_color] ? worm_colors.shuffle.first : worm_colors[i % worm_colors.size]
        end
      end

      def leds
        @leds ||= begin
          options[:mirror] ? element.leds.reverse : element.leds
        end
      end

      def background_color
        options[:background_color] || State[:off]
      end

    end
  end
end
