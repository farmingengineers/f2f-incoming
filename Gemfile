source "https://rubygems.org/"

ruby "2.2.0"

group :web do
  gem "sinatra"

  gem "activesupport"
  gem "json"
end

group :worker do
  # These are used by the conversion script
  gem "mail"
  gem "nokogiri"
end

group :production do
  gem "thin"
end

group :development do
  gem "shotgun"
end

group :test do
  gem "rake"
  gem "rspec"
end
