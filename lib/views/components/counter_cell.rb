require 'gtk3'
require_relative '../observable'

class CounterCell
  include Observable

  def initialize(row, col, width, height, css)
    @observers = []

    @overlay = Gtk::Overlay.new
    @overlay.visible = true

    @button = Gtk::Button.new
    @button.set_size_request(width, height)
    @button.visible = true
    @button.style_context.add_provider(css)
    @button.signal_connect "clicked" do
      notify_all([row, col])
    end
    @overlay.add_child(@button)

    @image = Gtk::Image.new
    @image.visible = false
    @overlay.add_overlay(@image)
    @overlay.set_overlay_pass_through(@image, true)
  end

  def widget
    @overlay
  end

  def set_counter(counter)
    if !counter.empty?
      @image.set_file(counter.sprite)
      @image.visible = true
    else
      clear
    end
  end

  def clear
    @image.visible = false
  end

private

  def load_image(path)
    Gtk::Image.new(:file => path)
  end

end