import os
import subprocess

from libqtile import hook
from libqtile.log_utils import logger
from libqtile.utils import send_notification

logger.warning("hooks loaded")


def is_wayland():
    return os.environ.get("WAYLAND_DISPLAY") is not None


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

        cmds = [
            [
                "dbus-update-activation-environment",
                "--systemd",
                "WAYLAND_DISPLAY",
                "XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP",
            ],
            ["systemctl", "--user", "stop", "pipewire", "wireplumber", "xdg-desktop-portal", "xdg-desktop-portal-wlr"],
            ["systemctl", "--user", "start", "wireplumber"],
            ["wl-paste", "--type", "text", "--watch", "cliphist", "store"],
            ["wl-paste", "--type", "image", "--watch", "cliphist", "store"],
            ["nix-shell", "-p", "kanshi", "--run", "kanshi"],
        ]
    else:
        update_env_with = {}
        cmds = [
            # ["xrandr", "--output", "HDMI-0", "--scale", "1.25x1.25", "--panning", "3840x2160"],
        ]

    os.environ |= update_env_with
    for cmd in cmds:
        subprocess.Popen(cmd)


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


def restart_cmd(process_name, *args):
    if is_running(process_name):
        subprocess.run(["pkill", "-SIGTERM", process_name])

    try:
        subprocess.Popen([process_name, *args])
        send_notification(title="succesfully started", message=f"{process_name} {' '.join(args)}")  # eliminate...
    except subprocess.SubprocessError:
        send_notification(title="Restart cmd failed", message=f"{process_name} {' '.join(args)}")


@hook.subscribe.startup
def on_restart():
    if is_wayland():
        pass
    else:
        restart_cmd("dunst")
