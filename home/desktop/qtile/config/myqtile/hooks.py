import os
import subprocess

from libqtile import hook
from libqtile.log_utils import logger


@hook.subscribe.startup_once
def autostart():
    update_env_with = {
        "XDG_CURRENT_DESKTOP": "qtile",
    }
    if is_wayland():
        update_env_with |= {
            "QT_QPA_PLATFORM": "wayland",
            "SDL_VIDEODRIVER": "wayland",
            "CLUTTER_BACKEND": "wayland",
            "QT_AUTO_SCREEN_SCALE_FACTOR": "1",
            "QT_WAYLAND_DISABLE_WINDOWDECORATION": "1",
            "GDK_BACKEND": "wayland",
        }

    os.environ |= update_env_with

    cmds = []
    if is_wayland():
        cmds.extend(
            [
                """
                if [ "$(wlr-randr | grep Scale | cut -d: -f2 | xargs)" != "2.000000" ]; then
                    wlr-randr --output HDMI-A-1 --scale 2 --adaptive-sync enabled
                fi
                """,
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP",
                "systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr",
                "systemctl --user start wireplumber swaync &",
                "pkill wl-paste",
                "wl-paste --type text --watch cliphist store &",
                "wl-paste --type image --watch cliphist store &",
            ]
        )
    else:
        cmds.extend(
            [
                "nix-shell -p xorg.xset --run 'xset s off'",
                "dunst",
                "autorandr",
            ]
        )

    for cmd in cmds:
        # qtile.spawn(cmd)
        process = subprocess.Popen(cmd, shell=True)
        try:
            process.wait(2)
        except subprocess.TimeoutExpired as e:
            logger.exception(e)


@hook.subscribe.client_new
def dialogs(window):
    if not hasattr(window, "window"):
        return
    if window.window.get_wm_type() == "dialog" or window.window.get_wm_transient_for():
        window.floating = True
        window.focus()


def is_running(process_name):
    try:
        subprocess.check_output(["pidof", process_name])
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False


def is_wayland() -> bool:
    return os.environ.get("WAYLAND_DISPLAY") is not None
