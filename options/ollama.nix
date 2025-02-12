{ ... }:
let
  enableAI = true;
in
{
  services.ollama = {
    enable = enableAI;
    loadModels = [ "deepseek-r1:1.5b" ];
    acceleration = "cuda";
  };
  services.open-webui.enable = enableAI;
}
