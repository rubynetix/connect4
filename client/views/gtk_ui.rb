require_relative 'observable'
require_relative 'windows/offline_game_menu_window'
require_relative 'windows/online_game_menu_window'
require_relative 'windows/online_game_window'
require_relative '../views/windows/app_window_id'

# Wrapper class that knows about the GTK windows involved
# in the presenting the application and presents a UI
# interface consistent with our previous UI class' interface
class GtkUI
  include PassthroughObservable

  def initialize(app)
    @app = app
    # Listen for any events in the GTK application and bubble
    # them up the observable chain to listening controllers
    @app.register(self)
  end

  def load_offline_game
    @app.ui.display_window(AppWindowId::OFFLINE_GAME_WINDOW)
  end

  def load_menu
    @app.ui.display_window(AppWindowId::OFFLINE_GAME_MENU_WINDOW)
  end

  def load_stats(user_stats)
    user_stats.each {|stat| @app.stats_window.add_user_stat(stat)}
  end

  def load_users(users)
    @app.online_menu_window.load_users(users)
  end

  def load_online_menu
    @app.ui.display_window(AppWindowId::ONLINE_GAME_MENU_WINDOW)
  end

  def load_online_game
    @app.ui.display_window(AppWindowId::ONLINE_GAME_WINDOW)
  end

  def load_current_games(games)
    @app.online_menu_window.clear_games_list
    games.each {|game| @app.online_menu_window.add_current_game(game)}
  end

  def method_missing(m, *args, &block)
    @app.ui.active_window.send(m, *args, &block)
  end

  def display_error(msg)
    @app.queue {@app.ui.display_error(msg)}
  end

  def shutdown
    @app.unregister(self)
  end
end
