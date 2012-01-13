require "spec_helper"

describe Mailgun::Route do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})
    @sample_domain = "example.com"
    @sample_address = "foo@bar.com"
  end

  describe "list bounces" do
    before :each do
      sample_response = "{\"items\": []}"
      RestClient.should_receive(:get)
        .with("#{@mailgun.bounces.send(:bounce_url, @sample_domain)}",
              :limit=>100, :skip=>0)
        .and_return(sample_response)
    end

    it "should make a GET request with the right params" do
      @mailgun.bounces.list @sample_domain
    end

    it "should respond with an Array" do
      @mailgun.bounces.list(@sample_domain).should be_kind_of(Array)
    end
  end

  describe "get bounce for specific address" do
    it "should make a GET request with the right params" do
      RestClient.should_receive(:get)
        .with("#{@mailgun.bounces.send(:bounce_url, @sample_domain, @sample_address)}", {})
        .and_return("{\"address\": \"#{@sample_address}\"}")
      @mailgun.bounces.find @sample_domain, @sample_address
    end

    it "should return nil if no resource has been found" do
      RestClient.should_receive(:get)
        .with("#{@mailgun.bounces.send(:bounce_url, @sample_domain, @sample_address)}", {})
        .and_return("{\"message\": \"Address not found in bounces table\"}")
      result = @mailgun.bounces.find @sample_domain, @sample_address
      result.should be_nil
    end
  end

  describe "delete bounce event" do
    it "should make a DELETE request with the right params" do
      RestClient.should_receive(:delete)
        .with("#{@mailgun.bounces.send(:bounce_url, @sample_domain, @sample_address)}", {})
        .and_return("{\"address\": \"#{@sample_address}\"}")
      @mailgun.bounces.destroy @sample_domain, @sample_address
    end

    it "should return nil if no resource has been found" do
      RestClient.should_receive(:delete)
        .with("#{@mailgun.bounces.send(:bounce_url, @sample_domain, @sample_address)}", {})
        .and_return("{\"message\": \"Address not found in bounces table\"}")
      @mailgun.bounces.destroy @sample_domain, @sample_address
    end
  end
end
