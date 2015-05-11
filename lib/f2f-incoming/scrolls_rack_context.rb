require "scrolls"

module F2fIncoming
  class ScrollsRackContext
    Scrolls.init \
      stream: STDOUT

    def initialize(app)
      @app = app
    end

    def call(env)
      Scrolls.context(log_context(env)) do
        @app.call(env)
      end
    end

    private

    def log_context(env)
      {
        :request_id => env["HTTP_X_REQUEST_ID"],
      }
    end
  end
end
