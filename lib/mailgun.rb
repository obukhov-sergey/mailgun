require "rest-client"
require "json"
require "multimap"

require "mailgun/mailgun_error"
require "mailgun/base"
require "mailgun/route"
require "mailgun/mailbox"
require "mailgun/log"
require "mailgun/bounce"
require "mailgun/mail"

def Mailgun(options={})
  Mailgun::Base.new(options)
end
