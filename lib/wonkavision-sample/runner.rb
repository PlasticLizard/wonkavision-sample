require 'optparse'
require 'log4r'

module Wonkavision::Sample

  class Runner
    
    attr_reader :options
    attr_reader :run_api
    attr_reader :run_worker
    attr_reader :run_console
    attr_accessor :verbose
    attr_accessor :log_stdout
    attr_accessor :log_dir

    def initialize(argv)
      options_parser.parse!(ARGV.dup)
      Wonkavision::Sample.env = @options.delete(:env)
      
      @run_api = @options.delete(:run_api)
      @run_worker = @options.delete(:run_worker)
      @run_console = @options.delete(:run_console)

      if @run_api
        require "wonkavision-sample/api"
        @api = Wonkavision::Sample::Api.new

        argv = prepare_goliath_args
        
        @api_runner = Goliath::Runner.new(argv, @api)
        @api_runner.app = Goliath::Rack::Builder.build(@api.class, @api)
        @api_runner.options[:config] = File.join( Wonkavision::Sample::CONFIG_DIR, "api.rb" )
        
        #@api_runner.load_plugins @api.plugins
      end

      if @run_worker
        require "wonkavision-sample/worker"
        @worker_options = options
      end

      if @run_console
        require "wonkavision-sample/console"
        @console_options = options
      end
    end

    def prepare_goliath_args
      argv = []
      argv << '-e' << Wonkavision::Sample.env.to_s
      argv << '--config' << File.join( Wonkavision::Sample::CONFIG_DIR, "api.rb")
      switches = '-'
      switches << 's' if @options[:log_stdout]
      switches << 'v' if @options[:verbose]
      argv << switches unless switches == '-'
      argv << '-a' << @options[:address] if @options[:address]
      argv << '-p' << @options[:port] if @options[:port]
      argv << '-l' << File.join(@options[:log_dir], "rpm_analytics_api") if @options[:log_dir]
      argv
    end

    # Create the options parser
    #
    # @return [OptionParser] Creates the options parser for the runner with the default options
    def options_parser
      @options ||= {
       :env => :development,
       #:config => File.join( Wonkavision::Sample::CONFIG_DIR, "worker.rb" )
      }

      @options_parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: rpm_analytics_worker [options]"

        opts.separator ""
        opts.separator "Server options:"
        
        opts.on('-e', '--environment NAME', "Set the execution environment (prod, dev or test) (default: #{@options[:env]})") { |val| @options[:env] = val }
        opts.on('-l', '--log FILE', "Log to file (default: off)") { |file| @options[:log_dir] = file }
        opts.on('-s', '--stdout', "Log to stdout (default: #{@options[:log_stdout]})") { |v| @options[:log_stdout] = v }
        opts.on('-v', '--verbose', "Enable verbose logging (default: #{@options[:verbose]})") { |v| @options[:verbose] = v }
        opts.on('-c', '--console', 'Start a wonkavision console. Other requested services (worker or api) will not run until the console exits.') { |c| @options[:run_console] = c }
        opts.on('-f', '--api', "Run the API web front end (default: #{!!@options[:run_api]}") { |v| @options[:run_api] = v }
        opts.on('-w', '--worker', "Run an analytics worker (default: #{!!@options[:run_worker]}") { |v| @options[:run_worker] = v }
        opts.on('-a', '--address HOST', "Bind to HOST address (default: #{@options[:address]})") { |addr| @options[:address] = addr }
        opts.on('-p', '--port PORT', "Use PORT (default: #{@options[:port]})") { |port| @options[:port] = port.to_i }
        opts.on('-h', '--help', 'Display help message') { show_options(opts) }
      end

    end

    def run
      run_console if @run_console
      return unless @run_worker or @run_api

      log = setup_logger
      EM.synchrony do
        run_worker(log) if @run_worker
        run_api if @run_api
      end
    end

    private

    def show_options(opts)
      puts opts

      at_exit { exit! }
      exit
    end

    # Sets up the logging for the runner
    # @return [Logger] The logger object
     def setup_logger
       log = Log4r::Logger.new('rpm_analytics_worker')

       log_format = Log4r::PatternFormatter.new(:pattern => "[#{Process.pid}:%l] %d :: %m")
       setup_file_logger(log, log_format) if options[:log_dir]
       setup_stdout_logger(log, log_format) if options[:log_stdout]

       log.level = options[:verbose] ? Log4r::DEBUG : Log4r::INFO
       log
     end

     # Setup file logging
     #
     # @param log [Logger] The logger to add file logging too
     # @param log_format [Log4r::Formatter] The log format to use
     # @return [Nil]
     def setup_file_logger(log, log_format)
       log_file = File.join(options[:log_dir], 'rpm_analytics_worker')
       FileUtils.mkdir_p(File.dirname(log_file))

       log.add(Log4r::FileOutputter.new('fileOutput', {:filename => log_file,
                                                       :trunc => false,
                                                       :formatter => log_format}))
     end

     # Setup stdout logging
     #
     # @param log [Logger] The logger to add stdout logging too
     # @param log_format [Log4r::Formatter] The log format to use
     # @return [Nil]
     def setup_stdout_logger(log, log_format)
       log.add(Log4r::StdoutOutputter.new('console', :formatter => log_format))
     end

    def run_console
      console = Wonkavision::Sample::Console.new
      console.options = @console_options
      console.start
    end

    # Run the server
    #
    # @return [Nil]
    def run_worker(log)
     worker = Wonkavision::Sample::Worker.new
     worker.logger = log
     worker.options = @worker_options
     worker.start
    end

    def run_api
      @api_runner.run
    end

  end
end