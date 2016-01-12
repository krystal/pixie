module Pixie
  module DSL
    class Track

      def initialize(track)
        @track = track
      end

      def parse(block)
        instance_eval(&block)
      end

      def at(frame_number, &block)
        parsed_array = AtSpec.new
        parsed_array.instance_eval(&block)
        @track.instructions[frame_number] = parsed_array.array
      end

      def frame_rate(rate)
        @track.frame_rate = rate
      end

      def length(frames)
        @track.length = frames
      end

      def seconds(s)
        s * @track.frame_rate
      end

      def music_file(name)
        @track.music_file = name
      end

      class AtSpec
        attr_reader :array
        def initialize
          @array = []
        end

        def run(sequence, options = {}, &after)
          @array << options.merge({:action => :run, :sequence => sequence_to_klass(sequence), :after => add_after(&after)})
        end

        def stop(element_name)
          @array << {:action => :stop, :element => element_name}
        end

        def finish
          @array << {:action => :finish}
        end

        def start_music
          @array << {:action => :start_music}
        end

        def stop_music
          @array << {:action => :stop_music}
        end

        def clear(element_name)
          @array << {:action => :clear, :element => element_name}
        end

        def modify(modifier, options = {}, &after)
          @array << options.merge({:action => :modify, :modifier => modifier_to_klass(modifier), :after => add_after(&after)})
        end

        private

        def add_after(&block)
          if block_given?
            sub_spec = self.class.new
            sub_spec.instance_eval(&block)
            sub_spec.array
          end
        end

        def sequence_to_klass(name)
          if name.is_a?(Symbol)
            Pixie::Sequences.const_get(name.to_s)
          else
            name
          end
        end

        def modifier_to_klass(name)
          if name.is_a?(Symbol)
            Pixie::Modifiers.const_get(name.to_s)
          else
            name
          end
        end

      end

    end
  end
end
