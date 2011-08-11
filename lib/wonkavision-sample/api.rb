require "goliath"
require "wonkavision/api/helper"
require "time"

module Wonkavision::Sample

  class Api < Goliath::API
    use Goliath::Rack::Tracer
    use Goliath::Rack::DefaultMimeType
    use Goliath::Rack::Render, ['json']
    use Goliath::Rack::Heartbeat
    use Goliath::Rack::Params

    def self.helper
      Wonkavision::Api::Helper.new("Wonkavision::Sample")
    end

    get '/query/:aggregation' do
      run Proc.new { |env|
        cellset = Api.helper.execute_query(env.params)
        [200, {}, cellset]
      }
    end

    get '/facts/:aggregation' do
      run Proc.new { |env|
        facts = Api.helper.facts_for(env.params)
        [200, {}, facts]
      }
    end

    get '/admin/facts/:facts/purge' do
      run Proc.new { |env|
        Api.helper.purge(env.params)
        [200, {}, ["Ok"]]
      }
    end 

    get '/admin/facts/:facts/snapshots/:snapshot/take/:snapshot_time' do
      run Proc.new { |env| 
        Api.helper.take_snapshot(env.params)
        [200, {}, ["Ok"]]
      }
    end

    get '/admin/facts/:facts/snapshots/:snapshot/calculate_stats/:snapshot_time' do
      run Proc.new { |env| 
        Api.helper.calculate_statistics(env.params)
        [200, {}, ["Ok"]]
      }
    end

    get '/*glob' do
      run Proc.new { |env| [404,{},"Not Found"] }
    end

  end
end