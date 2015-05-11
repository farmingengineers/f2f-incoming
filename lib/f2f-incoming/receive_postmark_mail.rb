require_relative "command"
require_relative "postmark_mail"
require_relative "queuer"

module F2fIncoming
  class ReceivePostmarkMail
    include Command

    def receive(request)
      request.body.rewind
      payload = JSON.parse(request.body.read)
      raw_mail = F2fIncoming::PostmarkMail.new(payload)
      F2fIncoming::Queuer.enqueue_conversion(raw_mail)
    end
  end
end
