module SSI
  class Config
    class << self
      def load(file_list)
        @config = {}
        file_list.each do |cfg_file|
            cfg_file = File.expand_path(cfg_file)
            @config.merge!(YAML.load(File.read(cfg_file))) if File.exist?(cfg_file)
        end
        @config
      end

      def load_handlers
        @config['ssi']['queues'].keys.each do |queue|
          (SSI.warn("Queue '#{queue}' is not configured with a handler");next) if @config['ssi']['queues'][queue]['handlers'].nil?
          handlers = @config['ssi']['queues'][queue]['handlers'].keys
          handlers.each { |handler| require "ssi/handlers/#{handler.downcase}" }
        end
      end

      def [](key)
        @config[key]
      end

    end
  end
end
