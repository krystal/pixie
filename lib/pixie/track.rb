require 'pixie/dsl/track'
require 'pixie/mpd'

module Pixie
  class Track

    attr_accessor :id
    attr_accessor :instructions
    attr_accessor :length
    attr_accessor :frame_rate
    attr_accessor :music_file

    def initialize(id)
      @id = id
      @instructions = {}
    end

    def self.dsl
      DSL::Track
    end

    def start_music
      set_start_time = false
      Pixie.mpd.on :elapsed do |elapsed|
        puts elapsed
        #unless set_start_time
          $start_time = Time.now.to_f - elapsed
          set_start_time = true
          #puts "Reset start time based on music position... #{$start_time}"
        #end
      end
      Pixie.mpd.clear
      Pixie.mpd.add self.music_file
      Pixie.mpd.play
    end

    def stop_music
      Pixie.mpd.stop
    end

  end
end
