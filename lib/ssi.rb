require 'rubygems'

module SSI
  class SSI
    autoload :Console_logger, "ssi/console_logger"

    @logger = Console_logger

    SSICommands = {
      :include => 'ssi_include',
    }

    attr_reader :options

    class << self
      def info(msg); @logger.info(msg); end
      def warn(msg); @logger.warn(msg); end
      def debug(msg); @logger.debug(msg); end

    end

    def initialize(options = {})
      @options = options
    end

    def ssi_include(dir_path, kvs)
      include_content = ''
      kvs.each do |type,filelist|
        filelist.each do |fdname| 
          if (fdname[0,1] == '/')
            fdname.gsub!(/^\//,'')
            file_path = File::expand_path(fdname, @options[:root_dir])
          else
            file_path = File::expand_path(fdname, dir_path)
          end
          new_dir_path = File::dirname(file_path)
          SSI.debug("Including content from #{file_path}") if @options[:verbose]
          include_content << ssi(new_dir_path, File.read(file_path))
        end
      end
      include_content
    end

    def ssi_parser(ssi)
      cmd, attr_val_pairs_str = ssi.split
      kvs = {}
      attr_val_pairs_str.split().each do |ks|
        attrib, val = ks.split('=')
        kvs[attrib.to_sym] ||= []
        kvs[attrib.to_sym] << val.gsub(/^"|"$/,'')
      end
      [cmd, kvs]
    end

    #
    # scan for ssi commands
    #
    def ssi(dir_path, content)
      outmap = {}

      content.scan(/(<!--#(.*)-->)/) do|m|
        outmap[m.first] = {}
        outmap[m.first][:ssi] = m.last.strip # store for processing later
      end

      outmap.each do|k,v|
        cmd, kvs = ssi_parser(v[:ssi])
        content.sub!(k,send(SSICommands[cmd.to_sym], dir_path, kvs))
      end

      content
    end
  end
end
