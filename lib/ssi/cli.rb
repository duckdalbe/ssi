#!/usr/bin/env ruby

require 'rubygems'
require 'optparse'
require 'ssi'
require 'ssi/version'
autoload :Console_logger, "ssi/console_logger"
autoload :FileUtils, "fileutils"

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
          opts.banner = "Usage: ", $PROGRAM_NAME, " [options] filename [filename] [...]"

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

        (puts optparse.help; exit 1) if ARGV.empty?
        ARGV.each do |fdname|
          @logger.debug("Reading file '#{fdname}'") if options[:verbose]
          dir_path = File::dirname(File::expand_path(fdname))
          @logger.debug("Path:'#{dir_path}'") if options[:verbose]
          ssi_obj = SSI.new(options)
          content = ssi_obj.ssi(dir_path, File.read(fdname))
          if options[:inplace]
            #File.copy(fdname, fdname + options[:extension]) if options[:extension]
            FileUtils.cp(fdname, fdname + options[:extension]) if (options[:extension] != '')
            File.open(fdname, 'w') do |fd|
              fd.write(content)
            end
          else
            puts content
          end
        end
      end
    end
  end
end
