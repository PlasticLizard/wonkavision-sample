require 'spec_helper'
require 'wonkavision-sample/api'

describe Wonkavision::Sample::Api do
  include Goliath::TestHelper

  let(:err) { Proc.new { |e| fail "API request failed:#{e.inspect}" } }

  before :each do
    @config = File.join Wonkavision::Sample::CONFIG_DIR, "api.rb"
  end
  
  it 'responds to query requests' do
    with_api(Wonkavision::Sample::Api, :config => @config) do
      get_request({:path => "/query/Aggregation"}, err) do |c|
        c.response_header.status.should == 200  
      end
    end
  end

  it "responds to facts requests" do
    with_api(Wonkavision::Sample::Api, :config => @config) do
      get_request({:path => "/facts/Aggregation"}, err) do |c|
        c.response_header.status.should == 200
      end
    end
  end

  it "returns 404 if the path doesn't match a route" do
    with_api(Wonkavision::Sample::Api, :config => @config) do
      get_request({:path => "/crapola"}, err) do |c|
        c.response_header.status.should == 404
      end
    end
  end
end