require "spec_helper"

describe Mailgun::Mail do
  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})
  end

  describe "send emails" do
    before :each do
      @sample_domain = "example.com"
      @url = "#{@mailgun.mail.send(:mail_url, @sample_domain)}"
      @sample_response = '{"id": "123"}'
    end

    it "should make a POST request with the right params" do
      file1, file2 = stub("File"), stub("File")
      data = ::Multimap.new
      data[:to] = "bob@example.com"
      data[:to] = "mary@example.com"
      data[:from] = "tom@example.com"
      data[:cc] = "support@example.com"
      data[:bcc] = "admin@example.com"
      data[:subject] = "Hello"
      data[:text] = "Hi there!"
      data[:html] = "<html>Hi</html>"
      data[:tag] = "tag1"
      data[:tag] = "tag2"
      data[:attachment] = file1
      data[:attachment] = file2
      data["o:deliverytime"] = "Fri, 25 Oct 2011 23:10:10 -0000"
      data["o:dkim"] = true
      data["o:tracking"] = true
      data["o:tracking-opens"] = true
      data["o:tracking-clicks"] = false
      data["o:testmode"] = true
      data["h:X-My-Header"] = "a custom mime header"
      data["v:my-var"] = '{"my_message_id": 123}'

      RestClient.should_receive(:post)
        .with(@url, data)
        .and_return(@sample_response)

      @mailgun.mail.send_email @sample_domain,
      :to => ["bob@example.com", "mary@example.com"],
      :from => "tom@example.com",
      :cc => "support@example.com",
      :bcc => "admin@example.com",
      :subject => "Hello",
      :text => "Hi there!",
      :html => "<html>Hi</html>",
      :tags => ["tag1", "tag2"],
      :attachments => [file1, file2],
      :at => "Fri, 25 Oct 2011 23:10:10 -0000",
      :dkim => true,
      :track => true,
      :track_opens => true,
      :track_clicks => false,
      :testmode => true,
      "h:X-My-Header" => "a custom mime header",
      "v:my-var" => '{"my_message_id": 123}'
    end
  end

  describe "prepare data" do
    it "should convert array params into multimap values" do
      data = ::Multimap.new
      data[:tag] = "tag1"
      data[:tag] = "tag2"
      @mailgun.mail.send(:prepare_data, {:tag => ["tag1", "tag2"]})
        .should == data
    end

    it "should allow plural key versions for :tag and :attachment" do
      file = stub("File")
      data = ::Multimap.new
      data[:tag] = "tag1"
      data[:attachment] = file
      @mailgun.mail.send(:prepare_data, {:tags => "tag1", :attachments => file})
        .should == data
    end

    it "should accept both string and symbols as keys shortcuts" do
      data = ::Multimap.new
      data["o:testmode"] = true
      @mailgun.mail.send(:prepare_data, {:testmode => true})
        .should == data
      @mailgun.mail.send(:prepare_data, {"testmode" => true})
        .should == data
    end

    it "should convert shortcuts to proper parameters names" do
      params = {}
      data = ::Multimap.new
      Mailgun::Mail::KEYS.each do |k, v|
        params[k] = k
        data[v] = k
      end
      @mailgun.mail.send(:prepare_data, params).should == data
    end
  end
end
