{ pkgs, lib, config, inputs, ... }:

{
  dotenv.disableHint = true;

  # https://devenv.sh/basics/
  env.GREET = "Mattermost";

  # https://devenv.sh/packages/
  packages = [
    pkgs.gnumake
    pkgs.sudo
    pkgs.tailscale
    pkgs.docker
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts = {
    hello.exec = ''
      echo Mattermost | ${pkgs.figlet}/bin/figlet -f slant | ${pkgs.lolcat}/bin/lolcat
    '';
    up.exec = ''
      sudo tailscale funnel --bg --tcp $(grep '^HTTPS_PORT' .env | awk -F= '{print $2}') tcp://localhost:$(grep '^HTTPS_PORT' .env | awk -F= '{print $2}')
      sudo tailscale funnel --bg --tcp $(grep '^CALLS_PORT' .env | awk -F= '{print $2}') tcp://localhost:$(grep '^CALLS_PORT' .env | awk -F= '{print $2}')
      docker compose up -d
    '';
    down.exec = ''
      docker compose down
      sudo tailscale funnel --bg --tcp $(grep '^HTTPS_PORT' .env | awk -F= '{print $2}') tcp://localhost:$(grep '^HTTPS_PORT' .env | awk -F= '{print $2}') off
      sudo tailscale funnel --bg --tcp $(grep '^CALLS_PORT' .env | awk -F= '{print $2}') tcp://localhost:$(grep '^CALLS_PORT' .env | awk -F= '{print $2}') off
    '';
    logs.exec = ''
      docker logs -f mattermost-mattermost-1
    '';
    shell.exec = ''
      docker compose exec -it mattermost /bin/bash
    '';
    certbot-shell.exec = ''
      docker compose exec -it certbot sh
    '';
    pull.exec = ''
      docker compose pull
    '';
    restart.exec = ''
      pull
      down
      up
    '';
  };

  enterShell = ''
    hello
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep --color=auto "${pkgs.git.version}"
  # '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
