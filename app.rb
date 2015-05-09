require "sinatra/base"

class F2fIncomingApp < Sinatra::Base
  hook_path = ENV["WEBHOOK_SECRET_PATH"] || "incoming"

  get "/#{hook_path}" do
    ":metal:\n"
  end

  get "/*" do
    redirect "http://www.farmtoforkmarket.org/", 301
  end
end
