require 'pixie/color'

module Pixie
  class State < Color

    def self.[](code)
      case code
      when :on      then  self.new(255,255,255)
      when :red     then  self.new(255,0,0)
      when :green   then  self.new(0,255,0)
      when :blue    then  self.new(0,0,255)
      when :off     then  self.new(0,0,0)
      else                self.new(0,0,0)
      end
    end

  end
end
