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

    def ssi_include(kvs)
      SSI.info("call include: #{kvs.inspect}")
      include_content = ''
      kvs.each do |type,filelist|
        filelist.each do |fdname| 
          if (fdname[0,1] == '/')
            fdname.gsub!(/^\//,'')
            include_content << File.read(File::expand_path(fdname, @options[:root_dir]))
          else
            include_content << File.read(File::expand_path(fdname, @options[:fd_dir_path]))
          end
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
    def ssi(content)
      
      SSI.info("parsing content")
      outmap = {}

      content.scan(/(<!--#(.*)-->)/) do|m|
        outmap[m.first] = {}
        outmap[m.first][:ssi] = m.last.strip # store for processing later
      end

      outmap.each do|k,v|
        cmd, kvs = ssi_parser(v[:ssi])
        content.sub!(k,send(SSICommands[cmd.to_sym],kvs))
      end

      puts content
      content
    end
  end
end
