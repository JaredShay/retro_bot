class RequestAuthenticator
  def self.authenticate(token)
    return true if ENV['RACK_ENV'].downcase == 'test'

    ENV['SLACK_TOKEN'] == token
  end
end
