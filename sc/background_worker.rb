# Used to run a given task every 60 seconds. 
class ScoutRails::BackgroundWorker
  # in seconds, time between when the worker thread wakes up and runs.
  PERIOD = 60
  
  def initialize
    @keep_running = true
  end
  
  def stop
    @keep_running = false
  end
  
  # Runs the task passed to +start+ once.
  def run_once
    @task.call if @task
  end
  
  # Starts running the passed block every 60 seconds (starting now).
  def start(&block)
    @task = block
    begin
      ScoutRails::Agent.instance.logger.debug "Starting Background Worker, running every #{PERIOD} seconds"
      next_time = Time.now
      while @keep_running do
        now = Time.now
        while now < next_time
          sleep_time = next_time - now
          sleep(sleep_time) if sleep_time > 0
          now = Time.now
        end
        @task.call
        while next_time <= now
          next_time += PERIOD
        end
      end
    rescue
      ScoutRails::Agent.instance.logger.debug "Background Worker Exception!!!!!!!"
      ScoutRails::Agent.instance.logger.debug $!.message
      ScoutRails::Agent.instance.logger.debug $!.backtrace
    end
  end
end