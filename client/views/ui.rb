require 'gtk3'
require_relative 'observable'
require_relative 'game_window'

class UI
  include PassthroughObservable

  def initialize(width: 300, height: 300)
    @ui_jobs = Queue.new
    @ui_thread = Thread.new do
      while true
        ui, action = @ui_jobs.deq
        action.call(ui)
      end
    end

    @game_window = GameWindow.new
    @game_window.build
    @game_window.register(self)

    @new_window = @game_window
  end

  def load_menu
    on_ui_thread do
      @game_window.show_menu
    end
  end

  def load_game
    on_ui_thread do
      @game_window.show_game
    end
  end

  def method_missing(m, *args, &block)
    # Delegate calls to active window on UI thread
    on_ui_thread do
      @new_window.send(m, *args, &block)
    end
  end

  def shutdown
    @ui_thread.kill
  end

private

  def on_ui_thread(&block)
    @ui_jobs.enq([self, block])
  end

end
