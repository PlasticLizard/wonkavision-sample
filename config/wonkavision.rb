require "wonkavision/analytics/persistence/em_mongo"

Wonkavision::Analytics.default_store = :em_mongo_store

import "mongo"

pool = EventMachine::Synchrony::ConnectionPool.new(size: 20) do
  Wonkavision::Analytics::Persistence::EMMongo.connect(config['mongo'])
end
Wonkavision::Analytics::Persistence::EMMongo.connection = pool
Wonkavision::Analytics::Persistence::EMMongo.ensure_indexes
Wonkavision::Analytics::Persistence::EMMongo.safe = true