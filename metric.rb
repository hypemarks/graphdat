module Graphdat
  require 'socket'

   class Metric
      @temp = {} # used when begin and end statements are used.
      @context_list = []
      @start_time = 0
      @path 
      @msg = {}

      def initialize 
              @path = ''
              @msg = {}
              @temp = {}
              @context_list = []
              @msg[:source] = 'HTTP'
              @msg[:type] = 'Sample'
              @msg[:host] =  Socket.gethostname
              @msg[:route] = 'GET /'
              @msg[:cputime] = 60
              @msg[:timestamp] = Time.now.to_f*1000
              @start_time = Time.now.to_f
              self.begin ''
      end



      def run
              self.end ''
              @end_time = Time.now.to_f
              responsetime = @end_time - @start_time
              ints = responsetime*1000
              @msg[:responsetime] = ints
              @msg[:context] = @context_list.reverse
              Graphdat::Agent.send_package @msg
      end


      # for adding the metrics to the context list when you have the response time
      def measure key,value
              @context= {}
              @path = "#{key}"      
              @context[:callcount] = 1
              @context[:firsttimestampoffset] = Time.now.to_f*1000 - value
              @context[:name] = @path
              @context[:responsetime] = value
              @context_list << @context
      end

      # for instrumentation
      def begin key
              if @path == '/'
                @path = @path+"#{key}"
              else
                @path = @path+"/#{key}"
              end
              @temp["#{key}:start"] = Time.now.to_f
              @temp["#{key}:path"] = @path
              @temp
      end

      def end key
              @context= {}
              key_start = @temp["#{key}:start"]
              path = @temp["#{key}:path"]
              firsttimestampoffset = key_start - @start_time
              responsetime  = Time.now.to_f - key_start
              name = key
              @context[:callcount] = 1
              @context[:cputime] = 49.634
              @context[:firsttimestampoffset] = firsttimestampoffset*1000
              @context[:name] = path
              @context[:responsetime] = responsetime*1000
              @context_list << @context
      end

   end
end