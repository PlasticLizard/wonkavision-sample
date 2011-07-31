module Wonkavision
  module Sample
    class AmqpPub
      
      attr_accessor :config, :broker_config, :exchange_name, :exchange_type
      attr_reader :connection, :channel, :exchange

      def initialize(config)
        @config = config
        @broker_config = config[:broker] || {:host => "localhost", :port => 5672}
        @exchange_name = config[:exchange] || "wv_analytics_exchange_#{Wonkavision::Sample.env}"
        @exchange_type = config[:exchange_type] || :topic
      end
      
      def start
        @started = true
        EM.run do
          @connection = AMQP.connect(@broker_config)
          @channel = AMQP::Channel.new(@connection)
          @exchange = channel.send(@exchange_type, @exchange_name, :durable => true)
        end
      end

      def publish(event_path, event_data)
        start unless @started
        EM.next_tick do
          event_data = Yajl::Encoder.encode(event_data) unless event_data.is_a?(String)
          exchange.publish event_data, :routing_key => event_path, :persistent => true, :immediate => true, :mandatory => true
        end
      end
        
    end
  end
end