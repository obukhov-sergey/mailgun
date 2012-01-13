module Mailgun
  class Bounce

    def initialize(mailgun)
      @mailgun = mailgun
    end

    def list(domain, limit=100, skip=0)
      Mailgun.submit(:get, bounce_url(domain),
                     :limit => limit,
                     :skip => skip)["items"] || []
    end

    def find(domain, address)
      Mailgun.submit(:get, bounce_url(domain, address))["bounce"]
    end

    def destroy(domain, address)
      Mailgun.submit(:delete, bounce_url(domain, address))["id"]
    end

    private

    def bounce_url(domain, address=nil )
      "#{@mailgun.base_url}/#{domain}/bounces#{'/' + address if address}"
    end
  end
end
