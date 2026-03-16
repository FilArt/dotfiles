{
  config,
  pkgs,
  ...
}: {
  imports = import ./programs;

  programs.autofirma = {
    enable = true;
    firefoxIntegration.enable = true;
  };

  # The FNMT certificate configurator
  programs.configuradorfnmt = {
    enable = true;
    firefoxIntegration.enable = true;
  };

  # Firefox configured to work with AutoFirma
  programs.firefox = {
    enable = true;
    policies.SecurityDevices = {
      "OpenSC PKCS#11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    };
  };
}
