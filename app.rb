require "sinatra/base"

class F2fIncomingApp < Sinatra::Base
  get "/*" do
    redirect "http://www.farmtoforkmarket.org/", 301
  end
end
