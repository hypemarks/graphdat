ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
	if @metric.nil? == false
		if payload[:name] != "SCHEMA"
	        duration = (finish - start) * 1000
	        @ar = @ar + duration 
	        # if duration > 3000
	        # 	@metric.measure(payload[:sql],duration)
        	# end
        end
    end        
 end

ActiveSupport::Notifications.subscribe('start_processing.action_controller') do |name,start,finish,id,payload|
			@ar = 0
			@metric = Graphdat::Metric.new
end

ActiveSupport::Notifications.subscribe('process_action.action_controller') do |name,start,finish,id,payload|
	        @metric.measure('Active Record',@ar)
			@metric.run
end
		
PhusionPassenger.on_event(:starting_worker_process) do |forked|
		Graphdat::Agent.start 
end
