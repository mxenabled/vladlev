require 'rubygems'
require 'rubygems/package_task'
require 'bundler/gem_tasks'
require 'rake/clean'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

spec = Gem::Specification.load('levee.gemspec')

Gem::PackageTask.new(spec) do |pkg|
end

if RUBY_PLATFORM =~ /java/
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new('levenshtein', spec)
else
  require 'rake/extensiontask'
  Rake::ExtensionTask.new('levenshtein', spec)
end

task :default => :spec
