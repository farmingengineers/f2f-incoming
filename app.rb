require "sinatra/base"

require_relative "lib/f2f-incoming/queuer"

class F2fIncomingApp < Sinatra::Base
  hook_path = ENV["WEBHOOK_SECRET_PATH"] || "incoming"

  get "/#{hook_path}" do
    F2fIncoming::Queuer.enqueue!(params)
    head 201
  end

  get "/*" do
    redirect "http://www.farmtoforkmarket.org/", 301
  end
end
