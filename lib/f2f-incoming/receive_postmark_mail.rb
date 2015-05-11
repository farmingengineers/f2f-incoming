require_relative "command"
require_relative "postmark_mail_logger"
require_relative "postmark_mail"
require_relative "queuer"

module F2fIncoming
  class ReceivePostmarkMail
    include Command

    def initialize(mail_logger: PostmarkMailLogger.new)
      @mail_logger = mail_logger
    end

    def receive(request)
      request.body.rewind
      payload = JSON.parse(request.body.read)
      raw_mail = F2fIncoming::PostmarkMail.new(payload)
      @mail_logger.log(raw_mail)
      F2fIncoming::Queuer.enqueue_conversion(raw_mail)
    end
  end
end
