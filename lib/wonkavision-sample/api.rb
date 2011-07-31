require "goliath"
require "wonkavision-sample/api_utils"
require "time"

module Wonkavision::Sample
  class Query < Goliath::API
   
    def execute_query(env)
      aggregation = "Wonkavision::Sample::#{env.params[:aggregation]}".constantize
      query = ApiUtils.query_from_params(env.params)

      aggregation.execute_query(query)
    end            
                        
    def response(env)
      cellset = execute_query(env).serializable_hash
      [200, {}, cellset]
    end
  end

  class Facts < Goliath::API

    def facts_for(env)
      aggregation = "Wonkavision::Sample::#{env.params[:aggregation]}".constantize
      filters, options = ApiUtils.facts_query_from_params(env.params)
      facts_data = aggregation.facts_for(filters, options)
      response = {
        :facts_class => aggregation.facts.name.split("::").pop,
        :data => facts_data
      }
      if facts_data.kind_of?(Wonkavision::Analytics::Paginated)
        response[:pagination] = facts_data.to_h
      end
      response
    end

    def response(env)
      [200, {}, facts_for(env)]
    end

  end

  class Api < Goliath::API
    use Goliath::Rack::Tracer
    use Goliath::Rack::DefaultMimeType
    use Goliath::Rack::Render, ['json']
    use Goliath::Rack::Heartbeat
    use Goliath::Rack::Params

    get '/query/:aggregation' do
      run Query.new
    end

    get '/facts/:aggregation' do
      run Facts.new
    end

    get '/admin/facts/:facts/purge' do
      run Proc.new { |env|
        facts = "Wonkavision::Sample::#{env.params[:facts]}".constantize
        purge_snapshots = !!env.params[:purge_snapshots]
        facts.purge!(purge_snapshots)
        [200, {}, ["#{facts.name} have been purged master"]]
      }    
    end 

    get '/admin/facts/:facts/snapshots/:snapshot/take/:snapshot_time' do
      run Proc.new { |env| 
        facts = "Wonkavision::Sample::#{env.params[:facts]}".constantize
        snap = facts.snapshots[env.params[:snapshot].to_sym]
        time = Time.parse(env.params[:snapshot_time])

        [400, {}, ["#{snapshot} does not appear to be a valid snapshot"]] unless snap
        snap.take! time
        [200, {}, ["The requested snapshot has been initiated"]]
      }
    end

    get '/*glob' do
      run Proc.new { |env| [404,{},"Not Found"] }
    end

  end
end