require 'rspec'
require 'rspec/core/rake_task'

desc "Run the specs under spec/models"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/*_spec.rb'
end

namespace :spec do
  desc "Clean spec cache"
  task :clean do
    rm Dir["tmp/spec/*"]
  end
end
