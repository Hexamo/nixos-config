{
  config,
  lib,
  vars,
  ...
}:

{
  options = {
    feature.term.kitty.enable = lib.mkEnableOption "Enables the terminal Kitty" // {
      default = true;
    };
  };

  config = lib.mkIf config.feature.term.kitty.enable {
    programs.kitty = {
      enable = true;
      themeFile = "kanagawa";
      font = {
        name = "IosevkaTerm Nerd Font Mono";
        size = 12;
      };
      keybindings = {
        "alt+shift++" = "send_key alt+?";
      };
      shellIntegration = {
        enableZshIntegration = true;
        mode = "enabled";
      };
      settings = {
        background_opacity = 0.9;
        cursor_trail = 1;
        hide_window_decorations = true;
        window_border_width = 0;
        draw_minimal_borders = true;
        shell_integration = false;
        wheel_scroll_multiplier = 5.0;
        input_delay = 3;
        allow_remote_control = true;
        listen_on = "unix:@mykitty";
      };
    };
  };
}
