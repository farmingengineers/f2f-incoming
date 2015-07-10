module F2fIncoming
  class UrlGenerator
    def generate(line)
      filename = File.basename(line.strip)
      year, month, day, slug = filename.split('-', 4)
      return nil if year.nil?
      "http://www.farmtoforkmarket.org/newsletters/#{year}/#{month}/#{day}/#{slug}"
    end
  end
end
