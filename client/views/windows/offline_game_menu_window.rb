require_relative '../../../client/views/events/window_change_event'
require_relative '../../../client/views/observable'
require_relative 'main_menu_window'
require_relative 'widget_window'

module C4
  class OfflineGameMenuWindow < Gtk::Box
    include PassthroughObservable
    include WidgetWindow

    @@wid = "game_menu"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/offline_game_menu_window.ui")

        bind_template_child("connect4_radio_btn")
        bind_template_child("connect4_btn_widget")
        bind_template_child("toot_otto_radio_btn")
        bind_template_child("toot_otto_btn_widget")
        bind_template_child("pvp_btn")
        bind_template_child("pvc_btn")
        bind_template_child("pvc_btn_hard")
        bind_template_child("start_btn")
        bind_template_child("back_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)

      init_menu
    end

    def window_help
      "Select a game type and opponent using the provided buttons."
    end

    private

    def init_menu
      # Menu options
      @menu_c4 = connect4_radio_btn
      @menu_c4.mode = false
      @menu_to = toot_otto_radio_btn
      @menu_to.mode = false
      @menu_pvp = pvp_btn
      @menu_pvp.mode = false
      @menu_pvc = pvc_btn
      @menu_pvc.mode = false
      @menu_pvc_hard = pvc_btn_hard
      @menu_pvc_hard.mode = false
      @menu_start = start_btn
      @back_btn = back_btn

      # Styled radio buttons
      c4_btn = connect4_btn_widget
      c4_btn.pack_start(load_image(RedCounter.instance.icon))
      c4_btn.pack_start(load_image(YellowCounter.instance.icon))

      to_btn = toot_otto_btn_widget
      to_btn.pack_start(load_image(TCounter.instance.icon))
      to_btn.pack_start(load_image(OCounter.instance.icon))

      # Event signals
      @menu_start.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::START))}
      @menu_c4.signal_connect("clicked") {handle_radio_click}
      @menu_to.signal_connect("clicked") {handle_radio_click}
      @menu_pvp.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::PVP))}
      @menu_pvc.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::PVC_EASY))}
      @menu_pvc_hard.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::PVC_HARD))}
      @back_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(MainMenuWindow.class_variable_get(:@@wid), @@wid))}
    end

    def handle_radio_click
      if @menu_c4.active?
        notify_all(MenuClickEvent.new(MenuClickEvent::CONNECT4))
      elsif @menu_to.active?
        notify_all(MenuClickEvent.new(MenuClickEvent::TOOT_OTTO))
      end
    end

    def load_image(path)
      img = Gtk::Image.new(:file => path)
      img.visible = true
      img
    end
  end
end
