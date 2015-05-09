module F2fIncoming
  class Queuer
    # Public: Enqueue a job from a postmark mail hook.
    #
    # Raises if there is an error, otherwise queues a job.
    def self.enqueue!(request_params)
      new.enqueue(request_params)
    end

    # Internal.
    def enqueue(request_params)
      # todo - test drive this
    end
  end
end
