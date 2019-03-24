require 'gtk3'
require_relative 'observable'
require_relative 'game_window'

class UI
  include Observable

  def initialize(width: 300, height: 300)
    @ui_jobs = Queue.new
    @ui_thread = Thread.new do
      while true
        ui, action = @ui_jobs.deq
        action.call(ui)
      end
    end

    @observers = []

    @game_window = GameWindow.new
    @game_window.build
    @game_window.register(self)
  end

  def set_turn(player)
    on_ui_thread do
      @game_window.set_turn(player)
    end
  end

  def draw_gameboard(gb)
    on_ui_thread do
      @game_window.draw_game(gb)
    end
  end

  def shutdown
    @ui_thread.kill
  end

  def notify(event)
    notify_all(event)
  end

private

  def on_ui_thread(&block)
    @ui_jobs.enq([self, block])
  end

end
