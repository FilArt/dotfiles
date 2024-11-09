import asyncio
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

    else:
        update_env_with = {}
    os.environ |= update_env_with


@hook.subscribe.startup
async def on_reload():
    cmds = []
    if is_wayland():
        cmds.extend(
            [
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP",
                "systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr",
                "systemctl --user start wireplumber swaync kanshi &",
                "pkill wl-paste",
                "wl-paste --type text --watch cliphist store &",
                "wl-paste --type image --watch cliphist store &",
            ]
        )
    else:
        cmds.extend(
            [
                ["dunst"],
                ["autorandr"],
            ]
        )

    for cmd in cmds:
        process = subprocess.Popen(cmd, shell=True)
        process.wait(2)


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


async def run_cmd_with_log(cmd: str) -> None:
    proc = await asyncio.create_subprocess_shell(cmd, stderr=asyncio.subprocess.PIPE, stdout=asyncio.subprocess.PIPE)

    stdout, stderr = await proc.communicate()
    if stdout:
        logger.warning(f"[stdout][{cmd}]\n{stdout.decode()}")
    if stderr:
        logger.warning(f"[stderr][{cmd}]\n{stderr.decode()}")
