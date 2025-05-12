{ pkgs, lib, config, ... }:
{
  services.xremap = {
    enable = true;
    withHypr = true;
     config = {
      modmap = [
        {
          name = "main-remaps";
          remap = {
            "CapsLock" = { held = "Super_L"; alone = "Esc"; alone_timeout_millis = 200; };
          };
        }
      ];
    };   
  };
}
