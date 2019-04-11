require_relative 'player'
require_relative 'computer_player'
require_relative 'remote_player'


class PlayerFactory
  PLAYER_1 = 0
  PLAYER_2 = 1

  class << self

    def player1(game_type, name)
      Player.new(name, game_type.p1_counters)
    end

    def player2(game_type, name)
      Player.new(name, game_type.p2_counters)
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

    def remote_player(game_type, p, name, local_user, game_id, client)
      if p == PLAYER_1
        RemotePlayer.new(name, local_user, game_type.p1_counters, game_id, 'w2', client)
      else
        RemotePlayer.new(name, local_user, game_type.p2_counters, game_id, 'w1', client)
      end
    end
  end
end
