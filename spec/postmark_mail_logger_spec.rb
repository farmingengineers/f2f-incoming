require "spec_helper"

require "f2f-incoming/postmark_mail"
require "f2f-incoming/postmark_mail_logger"

describe F2fIncoming::PostmarkMailLogger do
  subject { described_class.new scrolls: scrolls }

  let(:scrolls) { class_double(Scrolls).tap { |x| allow(x).to receive(:log) } }

  let(:mail) { instance_double(F2fIncoming::PostmarkMail, {
    :message_id => "message-id",
    :from => "from@farmtoforkmarket.org",
    :raw_date => "Sat, 9 May 2015 17:31:33 -0400",
    :subject => "Test subject",
    :spam_score => "-0.1",
  }) }

  before { subject.log(mail) }

  it do
    expect(scrolls).to have_received(:log).with({
      :datum => "mail-message",
      :message_id => "message-id",
      :from => "from@farmtoforkmarket.org",
      :date => "Sat, 9 May 2015 17:31:33 -0400",
      :subject => "Test subject",
      :spam_score => "-0.1",
    })
  end
end
