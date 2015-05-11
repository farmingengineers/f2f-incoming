require "sinatra/base"

require "json"

require_relative "lib/f2f-incoming/receive_postmark_mail"

class F2fIncomingApp < Sinatra::Base
  set :hook_path, ENV["WEBHOOK_SECRET_PATH"] || "incoming"

  post "/#{hook_path}" do
    F2fIncoming::ReceivePostmarkMail.receive(request)
    halt 201
  end

  get "/*" do
    redirect "http://www.farmtoforkmarket.org/", 301
  end
end
