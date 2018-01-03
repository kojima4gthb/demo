require "spec_helper"

describe NoticeMailer do
  describe "sendmail_confirm" do
    let(:mail) { NoticeMailer.sendmail_confirm }

    it "renders the headers" do
      mail.subject.should eq("Sendmail confirm")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
