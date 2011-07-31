require "wonkavision-sample/amqp_pub"

config['amqp'] = {
  :broker => {
    :host => "localhost",
    :port => 5672
  },  
  :exchange => "wv.broadcast.#{Wonkavision::Sample.env}",
  :queue => "wv.analytics.inbox.#{Wonkavision::Sample.env}",
  :durable => true, 
  :prefetch => 50
}

environment(:development) do
end

environment(:test) do
end


pool = EventMachine::Synchrony::ConnectionPool.new(size: 20) do
  Wonkavision::Analytics::Persistence::EMMongo.connect(config['mongo'])
end
Wonkavision::Analytics::Persistence::EMMongo.connection = pool

config['amqp_pub'] = Wonkavision::Sample::AmqpPub.new(config['amqp'])
Wonkavision.event_coordinator.job_queue = config['amqp_pub']

