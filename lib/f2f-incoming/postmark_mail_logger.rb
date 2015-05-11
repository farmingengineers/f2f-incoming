require "scrolls"

module F2fIncoming
  class PostmarkMailLogger
    def initialize(scrolls: Scrolls)
      @scrolls = scrolls
    end

    def log(mail)
      @scrolls.log :datum => "mail-message",
        :message_id => mail.message_id,
        :date => mail.raw_date,
        :from => mail.from,
        :subject => mail.subject,
        :spam_score => mail.spam_score
    end
  end
end
