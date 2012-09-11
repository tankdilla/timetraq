require "spec_helper"

describe UserDigestNotifier do
  describe "weekly_progress_report" do
    let(:mail) { UserDigestNotifier.weekly_progress_report }

    it "renders the headers" do
      mail.subject.should eq("Weekly progress report")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
