require 'test-unit'
require_relative '../server/server_error'

class HandlerTestHelper < Test::Unit::TestCase

  def assert_res_exception(res, exception)
    assert_true(res.key?(:exception))
    assert_true(Marshal.load(res[:exception]).is_a?(exception))
  end

  def db_users(*users)
    users.map { |u| { username: u } }
  end

  # Source: https://stackoverflow.com/questions/47508829/validate-uuid-string-in-ruby-rails
  def assert_uuid(uuid)
    uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    assert_true(uuid_regex.match?(uuid.to_s.downcase))
  end
end
