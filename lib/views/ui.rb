require 'gtk3'
require_relative 'observable'

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
  end

  def draw_bitmap(x, y, bitmap)
    on_ui_thread do |ui|
      ui.draw_bitmap_impl(x, y, bitmap)
    end
  end

  def shutdown
    @ui_thread.kill
  end

private

  def on_ui_thread(&block)
    @ui_jobs.enq([self, block])
  end

  def draw_bitmap_impl(x, y, bitmap)
    puts "hello world!"
  end
end
