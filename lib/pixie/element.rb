require 'pixie/unit'

module Pixie
  class Element

    attr_accessor :id
    attr_accessor :unit
    attr_accessor :pin
    attr_accessor :leds

    def initialize(id)
      @id = id
    end

    def led_count
      leds.size
    end

  end
end
