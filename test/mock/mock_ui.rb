require_relative '../../lib/views/observable'

class MockUI
  include Observable

  def initialize
    @observers = []
  end

end