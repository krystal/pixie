module Pixie
  class Color

    def initialize(red, green, blue)
      @red, @green, @blue = red.to_i, green.to_i, blue.to_i
    end

    def self.[](red, green, blue)
      self.new(red, green, blue)
    end

    def brightness(percentage)
      Color[
        (percentage / 100.0) * @red,
        (percentage / 100.0) * @green,
        (percentage / 100.0) * @blue
      ]
    end

    def brightness!(percentage)
      @red = (percentage / 100.0) * @red
      @green = (percentage / 100.0) * @green
      @blue = (percentage / 100.0) * @blue
    end

    def to_color
      self
    end

    def to_bytes
      [@red, @green, @blue].pack('ccc')
    end

  end
end
