require_relative 'observable'
require_relative '../views/windows/game_menu_window'
require_relative '../../client/views/windows/online_game_menu_window'

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

  def load_game
    @app.ui.display_window(C4::GameWindow.class_variable_get(:@@wid))
  end

  def load_menu
    @app.ui.display_window(C4::GameMenuWindow.class_variable_get(:@@wid))
  end

  def load_stats
    puts "############### LOADING STATISTICS... ###############\n"
    raise NotImplementedError
  end

  def load_online_menu
    @app.ui.display_window(C4::OnlineGameMenuWindow.class_variable_get(:@@wid))
  end

  def method_missing(m, *args, &block)
    @app.ui.active_window.send(m, *args, &block)
  end

  def shutdown
    @app.unregister(self)
  end
end
