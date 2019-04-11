require 'test/unit'

class Helper < Test::Unit::TestCase
  TEST_ITER = 10
  MIN_SIZE = 4
  MAX_SIZE = 10

  def setup; end

  def teardown; end

  def sink_stdout(&block)
    $stdout = File.new( '/dev/null', 'w' )
    block.call
    $stdout = @orig_stdout
  end
end