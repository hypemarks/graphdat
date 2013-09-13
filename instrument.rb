ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
	if @metric.nil? == false
		if payload[:name] != "SCHEMA"
	        duration = (finish - start) * 1000
	        @metric.measure(payload[:sql],duration)
        end
    end
        
 end


ActiveSupport::Notifications.subscribe('start_processing.action_controller') do |name,start,finish,id,payload|
			@metric = Graphdat::Metric.new
end

ActiveSupport::Notifications.subscribe('process_action.action_controller') do |name,start,finish,id,payload|
			@metric.run
end
		

