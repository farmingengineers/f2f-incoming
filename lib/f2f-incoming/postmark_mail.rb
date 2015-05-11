require "cgi"

module F2fIncoming
  class PostmarkMail
    def initialize(data)
      @data = data
    end

    def html
      CGI.unescapeHTML @data["HtmlBody"]
    end
  end
end
