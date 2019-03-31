require_relative 'observable'

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

  def load_menu
    @app.ui.game_window.show_menu
  end

  def load_game
    @app.ui.game_window.show_game
  end

  def draw_gameboard(gb)
    @app.ui.game_window.draw_gameboard(gb)
  end

  def method_missing(m, *args, &block)
  end

  def shutdown
    @app.unregister(self)
  end
end