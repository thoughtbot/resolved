require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:rspec)

desc "Run CI"
task default: [:rspec, :standard]
