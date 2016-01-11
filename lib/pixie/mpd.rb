require 'ruby-mpd'

module Pixie
  def self.mpd
    @mpd ||= begin
      mpd = ::MPD.new('localhost', 6600, :callbacks => true)
      mpd.connect
      mpd
    end
  end
end
