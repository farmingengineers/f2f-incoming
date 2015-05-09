require_relative "command"

module F2fIncoming
  class Queuer
    include Command

    # Public: Enqueue an email for conversion.
    def enqueue_conversion(raw_mail)
      # todo - test drive this
    end
  end
end
