module SSI
  module Util
    module_function

    def config_files
      cfg_file_paths = ['/etc/ssi/config.yml']
      if ENV['HOME']
        cfg_file_paths << '~/.ssi/config.yml'
      end
      cfg_file_paths
    end

    def get_timestamp_utc
      Time.now.utc
    end

  end
end
