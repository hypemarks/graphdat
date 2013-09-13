module Graphdat
	class Agent

		def self.send_heartbeat
            socket = UNIXSocket.new("/tmp/gd.agent.sock")
            data = [0,0,0,0].pack("N*")
            socket.send data, 0
            data
        end

        def self.send_package(msg = nil)
            data = msg.to_msgpack
            len= data.to_s.length
            l = [len].pack('N*')
            if @socket.nil? == true
                @socket = UNIXSocket.new("/tmp/gd.agent.sock")
            end
            @socket.send l, 0
            @socket.send data, 0
            # @socket.close
            msg
            rescue 
                'Graphdat Not Installed'
        end
	end
   


end