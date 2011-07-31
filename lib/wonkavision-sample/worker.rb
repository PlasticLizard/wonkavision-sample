require "wonkavision-sample/config"
require "amqp"

module Wonkavision
  module Sample
    class Worker

      attr_accessor :uri, :options, :config, :logger
      
      def initialize(options = {}) 
        @options = options
        @config = Wonkavision::Sample::Config.new
      end

      def start
        EM.synchrony do
        
          trap("INT")  { EM.stop }
          trap("TERM") { EM.stop }

          load_config(options[:config])

          broker_config = config.amqp[:broker] || {:host => "localhost", :port => 5672}
          exchange_name = config.amqp[:exchange] || "wv_analytics_exchange_#{Wonkavision::Sample.env}"
          exchange_type = config.amqp[:exchange_type] || :topic
          queue_name    = config.amqp[:queue] || "wv_analytics_queue_#{Wonkavision::Sample.env}"
          durable       = config.amqp[:durable] || true
          prefetch      = config.amqp[:prefetch].to_i || 20

          AMQP.connect(broker_config) do |connection|
            channel = AMQP::Channel.new(connection, AMQP::Channel.next_channel_id, :prefetch => prefetch)
            exchange = channel.send(exchange_type, exchange_name, :durable => true)
            
            channel.queue(queue_name, :durable => true) do |queue|
              queue.bind(exchange, :routing_key => "#").subscribe(:ack => true) do |header, payload|
                if payload
                  begin
                    event_path = header.routing_key
                    message = decode payload
                    
                    Fiber.new do
                      Wonkavision.event_coordinator.receive_event(event_path, message)
                      header.ack
                      print "."
                    end.resume
                  rescue Exception => ex
                    logger.error "Received #{event_path}:#{payload.inspect}"
                    logger.error "Failed:#{ex.to_s}"
                    handle_error(ex)
                  end

                end
              end
            end
          end

          logger.info "Wonkavision Sample Worker reporting for duty in #{Wonkavision::Sample.env} mode"
          logger.info "Connected to #{broker_config.inspect}"
          logger.info "Exchange: #{exchange_name} (#{exchange_type})"
          logger.info "Queue: #{queue_name}"
                  

        end
      end

      def handle_error(ex)
        #raise ex
      end

      def decode(payload)
        Yajl::Parser.new.parse(payload)
      end

      # Loads a configuration file
      #
      # @param file [String] The file to load, if not set will use the basename of $0
      # @return [Nil]
      def load_config(file = nil)
        file ||= "#{config_dir}/worker.rb"
        return unless File.exists?(file)

        eval(IO.read(file))
      end

      # Retrieves the configuration directory for the server
      #
      # @return [String] THe full path to the config directory
      def config_dir
        Wonkavision::Sample::CONFIG_DIR
      end

      # Import callback for configuration files
      # This will trigger a call to load_config with the provided name concatenated to the config_dir
      #
      # @param name [String] The name of the file in config_dir to load
      # @return [Nil]
      def import(name)
        file = "#{config_dir}/#{name}.rb"
        load_config(file)
      end

      # The environment block handling for configuration files
      #
      # @param type [String|Array] The environment(s) to load the config block for
      # @param blk [Block] The configuration data to load
      # @return [Nil]
      def environment(type, &blk)
        types = [type].flatten.collect { |t| t.to_sym }
        blk.call if types.include?(Wonkavision::Sample.env.to_sym)
      end
        
    end
  end
end