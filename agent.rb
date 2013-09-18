module Graphdat
	class Agent

		def self.send_heartbeat
            data = [0,0,0,0].pack("N*")
            @socket.send data, 0
            data
        end

        def self.send_package(msg = nil)
            data = msg.to_msgpack
            len= data.to_s.length
            l = [len].pack('N*')
            @socket.send l, 0
            response = @socket.send data, 0
            msg
            rescue 
                Rails.logger.error 'Graphdat Not Installed'
        end

        def self.start
            @socket = UNIXSocket.new("/tmp/gd.agent.sock")
            Thread.new do 
                while 1 do
                    sleep 3
                    self.send_heartbeat
                end 
            end
            rescue 
                Rails.logger.error 'Graphdat Not Installed'
        end
	end
   


end