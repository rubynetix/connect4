require_relative 'player'
require_relative 'computer_player'
require_relative 'remote_player'


class PlayerFactory
  PLAYER_1 = 0
  PLAYER_2 = 1

  class << self
    def player(game_type, p, name)
      if p == PLAYER_1
        Player.new(name, game_type.p1_counters)
      else
        Player.new(name, game_type.p2_counters)
      end
    end

    def computer_player(game_type, p, name, algorithm)
      if p == PLAYER_1
        bot = ComputerPlayer.new(name,
                                 game_type.p1_counters,
                                 game_type.p1_win,
                                 game_type.p2_counters)
      else
        bot = ComputerPlayer.new(name,
                                 game_type.p2_counters,
                                 game_type.p2_win,
                                 game_type.p1_counters)
      end
      bot.algorithm = algorithm
      bot
    end

    def remote_player(game_type, p, name, game_id, client)
      if p == PLAYER_1
        RemotePlayer.new(name, game_type.p1_counters, game_id, client)
      else
        RemotePlayer.new(name, game_type.p2_counters, game_id, client)
      end
    end

  end
end
