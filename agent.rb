module Graphdat
	class Agent

		def self.send_heartbeat
            data = [0,0,0,0].pack("N*")
            len= data.length
            l = [len].pack('N*')
            @socket.send l, 0
            @socket.send data, 0
            return len
        end

        def self.send_package(msg = nil)
            data = msg.to_msgpack
            len= data.to_s.length
            l = [len].pack('N*')
            @socket.send l, 0
            response = @socket.send data, 0
            @last_sent_data = Time.now.to_i
            msg
            rescue 
                Rails.logger.error 'Graphdat Not Installed'
        end

        def self.start
            @socket = UNIXSocket.new("/tmp/gd.agent.sock")
            @last_sent_data = Time.now.to_i
            Thread.new do 
                while 1 do
                    sleep 1
                    time_elapsed = (Time.now.to_i - @last_sent_data)
                    if time_elapsed < 30
                        sleep_time = 30 - time_elapsed
                        Rails.logger.info 'Sleeping Time' + Process.uid.to_s
                    else
                        @last_sent_data = Time.now.to_i
                        self.send_heartbeat
                    end
                end 
            end
            rescue 
                Rails.logger.error 'Graphdat Not Installed'
        end
	end
   


end