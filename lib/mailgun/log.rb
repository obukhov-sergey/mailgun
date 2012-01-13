module Mailgun
  class Log

    def initialize(mailgun)
      @mailgun = mailgun
    end

    def list(domain, limit=100, skip=0)
      Mailgun.submit(:get, log_url(domain),
                     :limit => limit,
                     :skip => skip)["items"] || []
    end

    private

    def log_url(domain)
      "#{@mailgun.base_url}/#{domain}/log"
    end
  end
end
