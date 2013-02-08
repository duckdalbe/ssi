$:.unshift File.expand_path("../lib", __FILE__)
require "ssi/version"

Gem::Specification.new do |s|
  s.name        = 'ssi'
  s.version     = SSI::VERSION
  s.summary     = "A script which interpolates server-side includes for HTML files"
  s.description = "A script which interpolates server-side includes for HTML files"
  s.authors     = ["Brian Wong"]
  s.email       = 'bwong114@gmail.com'
  s.files       = Dir['lib/ssi.rb'] + Dir['lib/ssi/*.rb'] + Dir['lib/ssi/handlers/*.rb'] + Dir["bin/ssi"]
  s.executables << 'ssi'
  s.homepage    = 'https://github.com/bwong114/ssi'
end
