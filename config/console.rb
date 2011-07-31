require "wonkavision/analytics/persistence/mongo"

import "mongo"

Wonkavision::Analytics.default_store = :mongo_store
Wonkavision::Analytics::Persistence::Mongo.connect(config['mongo'])
Wonkavision::Analytics::Persistence::Mongo.ensure_indexes
Wonkavision::Analytics::Persistence::Mongo.safe = true