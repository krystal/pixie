module Pixie
  module Sequences
    class Abstract

      attr_reader :element
      attr_reader :instruction
      attr_accessor :current_frame

      def initialize(element, start_frame, instruction)
        @element = element
        @current_frame = start_frame
        @instruction = instruction
        @repeat_count = 1
      end

      def current_frame
        if instruction[:reverse]
          if total_number_of_frames
             total_number_of_frames - @current_frame - 1
          else
            raise "Reversing not supported as sequence does not support #total_number_of_frames"
          end
        else
          @current_frame
        end
      end

      def options
        @instruction[:options] || {}
      end

      def get_current_frame(current_states)
        nil
      end

      def get_current_frame_safely(current_states)
        if total_number_of_frames.is_a?(Integer) && @current_frame >= total_number_of_frames
          return nil
        end

        if frame = get_current_frame(current_states)
          frame.keep_if do |led_id, color|
            element.leds.include?(led_id)
          end
        else
          nil
        end
      end

      def last_frame?
        if total_number_of_frames.is_a?(Integer)
          !repeat? && @current_frame == total_number_of_frames - 1
        else
          false
        end
      end

      def increment_current_frame
        @current_frame += 1
      end

      def repeat?
        if @instruction[:repeat].is_a?(Integer)
          @repeat_count < @instruction[:repeat]
        elsif @instruction[:repeat]
          true
        else
          false
        end
      end

      def repeat!
        @current_frame = 0
        @repeat_count += 1
      end

      def reversed?
        instruction[:reverse]
      end

      def total_number_of_frames
        nil
      end

    end
  end
end
