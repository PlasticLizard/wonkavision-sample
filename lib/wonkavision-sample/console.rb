require "wonkavision-sample/config"
require "pry"

module Wonkavision
  module Sample
    class Console

      attr_accessor :options, :config

      def initialize(options = {}) 
        @options = options
        @config = Wonkavision::Sample::Config.new
      end

      def start
        load_config(options[:config])
        my_prompt = [ proc { |obj, *| "Wonkavision (#{obj})> " },
           proc { |obj, *| "Wonkavision (#{obj})* "} ]

        # Start a Pry session using the prompt defined in my_prompt
        Pry.start(TOPLEVEL_BINDING, :prompt => my_prompt)
      end

      # Loads a configuration file
      #
      # @param file [String] The file to load, if not set will use the basename of $0
      # @return [Nil]
      def load_config(file = nil)
        file ||= "#{config_dir}/console.rb"
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