{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
    inputs.pre-commit-hooks-nix.flakeModule
  ];

  perSystem =
    { pkgs, config, ... }:
    {
      devshells.default = {
        devshell = {
          name = "mem-manager";
          motd = ''
            {14}{bold}❄️ Welcome to the mem-manager devshell ❄️{reset}
            $(type -p menu &>/dev/null && menu)
            $(type -p update-pre-commit-hooks &>/dev/null && update-pre-commit-hooks)
          '';
        };
        packages = with pkgs; [
          config.treefmt.build.wrapper
          reuse
          rustc
          rustfmt
          cargo
          clippy
          pkgs.stdenv.cc
        ];
        commands = [
          {
            name = "update-pre-commit-hooks";
            command = config.pre-commit.installationScript;
            category = "tools";
            help = "update git pre-commit hooks";
          }
        ];
      };
      pre-commit.settings = {
        hooks.treefmt.enable = true;
        hooks.treefmt.package = config.treefmt.build.wrapper;
      };
    };
}
