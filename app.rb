require "sinatra/base"

require_relative "lib/f2f-incoming/postmark_receiver"
require_relative "lib/f2f-incoming/queuer"

class F2fIncomingApp < Sinatra::Base
  hook_path = ENV["WEBHOOK_SECRET_PATH"] || "incoming"

  post "/#{hook_path}" do
    request.body.rewind
    payload = JSON.parse(request.body.read)
    raw_mail = F2fIncoming::PostmarkReceiver.extract_raw(payload)
    F2fIncoming::Queuer.enqueue_conversion(raw_mail)
    head 201
  end

  get "/*" do
    redirect "http://www.farmtoforkmarket.org/", 301
  end
end
