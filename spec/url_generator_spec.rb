require "spec_helper"
require "f2f-incoming/url_generator"

describe F2fIncoming::UrlGenerator do
  it { expect(subject.generate("_posts/2015-06-18-strawberries-eggs-breads-meats-greens-and-more.html\r\n")).to eq("http://www.farmtoforkmarket.org/newsletters/2015/06/18/strawberries-eggs-breads-meats-greens-and-more.html") }
  it { expect(subject.generate("\r\n")).to be_nil }
end
