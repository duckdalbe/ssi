module SSI
  module Console_logger
    autoload :Util, "ssi/util"

    class << self
      def info(msg)
        STDOUT.puts("INFO: %s: %s" % [Util.get_timestamp_utc.to_s, msg])
      end
      def warn(msg)
        STDERR.puts("WARN: %s: %s" % [Util.get_timestamp_utc.to_s, msg])
      end

      def debug(msg)
        STDERR.puts("DEBUG: %s: %s" % [Util.get_timestamp_utc.to_s, msg])
      end
    end
  end
end
