require_relative 'ui_event'

class ServerConnectEvent < UIEvent
  attr_reader :username, :server_url

  def initialize(username, server_url)
    super UIEvent::SERVER_CONN
    @username = username
    @server_url = server_url
  end
end
