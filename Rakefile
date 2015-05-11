task :default => :spec

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new
rescue LoadError
  # heroku doesn't have rspec
end

task :hookurl do
  require_relative "app"
  puts "Hook URL is http://convert-newsletters.farmtoforkmarket.org/#{F2fIncomingApp.hook_path}"
end
