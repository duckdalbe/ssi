#!/usr/bin/env ruby

require 'rubygems'
#require 'subcommand'
require 'optparse'
require 'ssi'
require 'ssi/version'
autoload :Console_logger, "ssi/console_logger"

module SSI
  class CLI
    class << self
      COL_WIDTH = 40

      def ask_confirm(question)
        print question
        answer = $stdin.gets.chomp
        accepted_confirms = ['y','yes']
        accepted_confirms.include?(answer.downcase)
      end

      def run
        @logger = Console_logger
        options = {}
        optparse = OptionParser.new do |opts|
          options[:root_dir] = '.'
          opts.banner = "Usage: ", $PROGRAM_NAME, " [options] filename"

          opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
            options[:verbose] = v
          end

          opts.on("-d", "--root-dir [DIR]", "The directory considered to be the document root") do |d|
            options[:root_dir] = d
          end

          opts.on("-i", "--inplace [EXTENSION]",
                  "Edit ARGV files in place",
                  "  (make backup if EXTENSION supplied)") do |ext|
            options[:inplace] = true
            options[:extension] = ext || ''
            options[:extension].sub!(/\A\.?(?=.)/, ".")  # Ensure extension begins with dot.
          end

          opts.on_tail("-h", "--help", "Show this message") do
            puts opts
            exit
          end

          opts.on_tail("--version", "Show version") do
            puts VERSION
            exit
          end
        end

        optparse.parse!

        p options
        p ARGV

        (puts optparse.help; exit 1) if ARGV.empty?
        ARGV.each do |fdname|
          @logger.info("Reading file '#{fdname}'")
          options[:fd_dir_path] = File::dirname(File::expand_path(fdname))
          @logger.info("Path: #{options[:fd_dir_path]}")
          ssi_obj = SSI.new(options)
          ssi_obj.ssi(File.read(fdname))
        end
#            nodename = ARGV.shift
#            if ARGV.empty?
#              yaml_data = $stdin.read
#            else
#              yaml_file = ARGV.shift
#              yaml_data = File.new(yaml_file).read
      end
    end
  end
end
