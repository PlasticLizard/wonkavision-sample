root_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
ENV['BUNDLE_GEMFILE'] = File.join root_dir, "Gemfile"

require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
require 'wonkavision'
require "yajl"

module Wonkavision
  module Sample
    ROOT_DIR   = File.expand_path(File.join(File.dirname(__FILE__), ".."))
    LIB_DIR    = File.join ROOT_DIR, "lib", "wonkavision-sample"
    APP_DIR    = File.join ROOT_DIR, "app"
    CONFIG_DIR = File.join ROOT_DIR, "config"

    def self.env
      @env ||= :development
    end
    
    def self.env=(env)
      @env = env.to_sym
    end
    
    def self.ensure_val(val,default)
      val.blank? ? default : val
    end

    def self.test?
      env == :test
    end
  end
end


["facts","aggregations", "maps"].each do |dirname|
    Dir[File.join(Wonkavision::Sample::APP_DIR, dirname, "**/*.rb")].each {|lib| require lib }
end

$:.unshift File.join Wonkavision::Sample::ROOT_DIR, "lib"

