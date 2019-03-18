require_relative 'helper'

class GameStatsTest < Helper

  def rand_stats
    raise NotImplementedError
    GameStats.new {}
  end

  def tst_clear
    gs = rand_stats
    size = gs.stats.size

    gs.clear

    # Postconditions
    begin
      assert_equal 0, gs.stats.size, 'Clear must remove all game stats'
    end
  end

  def tst_update
    gs = rand_stats
    old_stats = gs.stats.dup

    gs.update

    # Postconditions
    begin
      assert_false old_stats != gs.stats, 'Update must change game stats'
    end
  end
end