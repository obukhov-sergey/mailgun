require "spec_helper"

describe Mailgun::Log do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})
  end

  describe "list logs" do
    before :each do
      sample_response = "{\"items\": []}"
      @sample_domain = "bar.com"
      RestClient.should_receive(:get)
        .with("#{@mailgun.logs.send(:log_url, @sample_domain)}",
              :limit=>100, :skip=>0)
        .and_return(sample_response)
    end

    it "should make a GET request with the right params" do
      @mailgun.logs.list @sample_domain
    end

    it "should respond with an Array" do
      @mailgun.logs.list(@sample_domain).should be_kind_of(Array)
    end
  end
end
