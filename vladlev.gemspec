# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'vladlev/version'

Gem::Specification.new do |s|
  s.name         = 'vladlev'
  s.version      = Vladlev::VERSION
  s.summary      = 'Levenshtein matching algorithm for ruby using C'
  s.description  = 'Levenshtein matching algorithm for ruby using C with an FFI extension'
  s.authors      = ["Brian Stien"]
  s.email        = 'dev@moneydesktop.com'
  s.homepage     = 'https://github.com/mxenabled/vladlev'
  
  if defined?(JRUBY_VERSION)
    s.platform = 'java'
  else
    s.extensions   = ['ext/levenshtein/extconf.rb']
    s.add_runtime_dependency 'ffi'
  end

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'geminabox'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rake-compiler'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths - ["lib"]
end
