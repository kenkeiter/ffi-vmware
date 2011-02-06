require 'rake'
require 'rspec/core/rake_task'

namespace :test do
  desc "Run all specs."
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/*_spec.rb'
    t.verbose = false
  end

  RSpec::Core::RakeTask.new(:coverage) do |t|
    t.rcov = true
    t.rcov_opts =  %q[--exclude "spec"]
    t.verbose = true
  end
end
