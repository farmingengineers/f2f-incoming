task :default => :spec

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new
rescue LoadError
  # heroku doesn't have rspec
end

task :hookurl do
  puts "Hook URL is http://convert-newsletters.farmtoforkmarket.org/#{ENV["WEBHOOK_SECRET_PATH"] || "incoming"}"
end
