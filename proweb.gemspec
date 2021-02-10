# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

require "proweb/version"

Gem::Specification.new do |s|
  s.name        = "proweb"
  s.version     = Proweb::VERSION
  s.authors     = ["Moritz Schepp"]
  s.email       = ["moritz.schepp@gmail.com"]
  s.homepage    = ""
  s.summary     = "An exporter for proweb projects"
  s.description = "Transfers the MSSQL database to mysql and provides specific
    classes for data extraction
  "
  
  s.add_dependency "sequel"
  s.add_dependency "sqlite3", '1.3.13'
  s.add_dependency "mysql2"
  s.add_dependency "tiny_tds"
  s.add_dependency "activerecord-sqlserver-adapter"
  s.add_dependency "activerecord", "~> 6.1.1"
  s.add_dependency "httpclient"
  s.add_dependency "spreadsheet"
  s.add_dependency "pry"
  s.add_dependency 'progressbar'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
