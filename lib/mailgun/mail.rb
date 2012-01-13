module Mailgun
  class Mail

    KEYS = {
      # o: params
      "at" => "o:deliverytime",
      "deliverytime" => "o:deliverytime",
      "dkim" => "o:dkim",
      "testmode" => "o:testmode",
      "test_mode" => "o:testmode",
      "track" => "o:tracking",
      "track_clicks" => "o:tracking-clicks",
      "track_opens" => "o:tracking-opens",
      # allow plural for some params
      "attachments" => :attachment,
      "tags" => :tag
    }

    def initialize(mailgun)
      @mailgun = mailgun
    end

    def send_email(domain, params)
      data = prepare_data(params)
      Mailgun.submit(:post, mail_url(domain), data)["id"]
    end

    private

    def prepare_data(params)
      data = ::Multimap.new
      params.each do |key, value|
        key = KEYS[key.to_s] || key
        if value.kind_of?(Array)
          value.each do |val|
            data[key] = val
          end
        else
          data[key] = value
        end
      end
      data
    end

    def mail_url(domain, mime=false)
      "#{@mailgun.base_url}/#{domain}/messages#{'.mime' if mime}"
    end
  end
end
