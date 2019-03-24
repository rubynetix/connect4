require_relative '../../lib/views/observable'

class MockUI
  include Observable

  def initialize
    @observers = []
  end

  # Mock all unknown calls as doing nothing by default
  def method_missing(m, *args, &block)
  end

end