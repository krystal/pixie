require 'socket'

module Pixie
  class Unit

    attr_accessor :id
    attr_accessor :ip_address
    attr_accessor :port

    def initialize(id)
      @id = id
    end

    def udp_socket
      @udp_socket ||= UDPSocket.new
    end

    def send_udp_packet(packet)
      udp_socket.send(packet, 0, self.ip_address, self.port)
    end

  end
end
