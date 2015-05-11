task :default => :spec

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new
rescue LoadError
  # heroku doesn't have rspec
end
