require "spec_helper"
require "json"
require "active_support/time_with_zone"

require "f2f-incoming/postmark_mail"

describe F2fIncoming::PostmarkMail do
  subject { described_class.new(test_hook) }

  it { expect(subject.message_id).to eq("73e6d360-66eb-11e1-8e72-a8904824019b") }
  it { expect(subject.date).to eq(indiana.local(2015, 5, 9, 17, 31, 33)) }
  it { expect(subject.subject).to eq("Test subject") }
  it { expect(subject.html).to eq(%Q{<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml"}) }
  it { expect(subject.html_part.body.decoded).to eq(%Q{<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml"}) }
  it { expect(subject.from).to eq("support@postmarkapp.com") }
  it { expect(subject.raw_date).to eq("Sat, 9 May 2015 17:31:33 -0400") }
  it { expect(subject.spam_score).to be_nil }

  context "with a spam score" do
    let(:test_hook) { super().merge("Headers" => [{"Name" => "X-Spam-Score", "Value" => "-0.1"}]) }

    it { expect(subject.spam_score).to eq("-0.1") }
  end

  let(:indiana) { ActiveSupport::TimeZone["America/Indiana/Indianapolis"] }

  let(:test_hook) { JSON.load(test_json) }
  let(:test_json) { <<TEST }
{
  "FromName": "Postmarkapp Support",
  "From": "support@postmarkapp.com",
  "FromFull": {
    "Email": "support@postmarkapp.com",
    "Name": "Postmarkapp Support",
    "MailboxHash": ""
  },
  "To": "\\"Firstname Lastname\\" <mailbox+SampleHash@inbound.postmarkapp.com>",
  "ToFull": [
    {
      "Email": "mailbox+SampleHash@inbound.postmarkapp.com",
      "Name": "Firstname Lastname",
      "MailboxHash": "SampleHash"
    }
  ],
  "Cc": "\\"First Cc\\" <firstcc@postmarkapp.com>, secondCc@postmarkapp.com",
  "CcFull": [
    {
      "Email": "firstcc@postmarkapp.com",
      "Name": "First Cc",
      "MailboxHash": ""
    },
    {
      "Email": "secondCc@postmarkapp.com",
      "Name": "",
      "MailboxHash": ""
    }
  ],
  "Bcc": "\\"First Bcc\\" <firstbcc@postmarkapp.com>, secondbcc@postmarkapp.com",
  "BccFull": [
    {
      "Email": "firstbcc@postmarkapp.com",
      "Name": "First Bcc",
      "MailboxHash": ""
    },
    {
      "Email": "secondbcc@postmarkapp.com",
      "Name": "",
      "MailboxHash": ""
    }
  ],
  "OriginalRecipient": "mailbox+SampleHash@inbound.postmarkapp.com",
  "Subject": "Test subject",
  "MessageID": "73e6d360-66eb-11e1-8e72-a8904824019b",
  "ReplyTo": "replyto@postmarkapp.com",
  "MailboxHash": "SampleHash",
  "Date": "Sat, 9 May 2015 17:31:33 -0400",
  "TextBody": "This is a test text body.",
  "HtmlBody": "<html lang=\\"en\\" xml:lang=\\"en\\" xmlns=\\"http:\\/\\/www.w3.org\\/1999\\/xhtml\\"",
  "StrippedTextReply": "This is the reply text",
  "Tag": "TestTag",
  "Headers": [
    {
      "Name": "X-Header-Test",
      "Value": ""
    }
  ],
  "Attachments": [
    {
      "Name": "test.txt",
      "Content": "VGhpcyBpcyBhdHRhY2htZW50IGNvbnRlbnRzLCBiYXNlLTY0IGVuY29kZWQu",
      "ContentType": "text/plain",
      "ContentLength": 45
    }
  ]
}
TEST
end
