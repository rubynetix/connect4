class GameStats
  attr_accessor :stats

  def initialize(stats={})
    @stats = stats
  end

  def update(*)
    raise NotImplementedError
  end

  def clear
    raise NotImplementedError
  end
end
