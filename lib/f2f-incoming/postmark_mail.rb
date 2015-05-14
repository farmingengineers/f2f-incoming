require "cgi"

module F2fIncoming
  class PostmarkMail
    def initialize(data)
      @data = data
    end

    def message_id
      @data["MessageID"]
    end

    def from
      @data["From"]
    end

    def raw_date
      @data["Date"]
    end

    def date
      Time.parse raw_date
    end

    def subject
      @data["Subject"]
    end

    def spam_score
      @data["Headers"].each do |header|
        if header["Name"] == "X-Spam-Score"
          return header["Value"]
        end
      end
      nil
    end

    def html
      @data["HtmlBody"]
    end

    def html_part
      Part.new(html)
    end

    class Part
      def initialize(decoded)
        @decoded = decoded
      end
      def body
        Body.new(@decoded)
      end
    end
    class Body
      def initialize(decoded)
        @decoded = decoded
      end
      attr_reader :decoded
    end
  end
end
