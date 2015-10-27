# The RequestAuthenticator is responsible for ensuring a request is made from a
# reputable source. All requests made in the 'test' env are considered valid.
class RequestAuthenticator
  def self.authenticate(token)
    return true if ENV['RACK_ENV'].downcase == 'test'

    ENV['SLACK_TOKEN'] == token
  end
end
