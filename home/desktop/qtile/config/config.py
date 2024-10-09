import os
import subprocess

from libqtile import bar, hook
from libqtile.backend.wayland import InputConfig
from libqtile.config import DropDown, Group, Match, ScratchPad, Screen
from libqtile.utils import guess_terminal
from myqtile.keys import init_keys, init_mouse
from myqtile.widgets import init_widgets
from qtile_extras import layout

info = "#54B4D3"
success = "#14A44D"
primary = "#3B71CA"
danger = "#DC4C64"
warning = "#E4A11B"
secondary = "#2E3440"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.Popen([home])


@hook.subscribe.client_new
def dialogs(window):
    if not hasattr(window, "window"):
        return
    if window.window.get_wm_type() == "dialog" or window.window.get_wm_transient_for():
        window.floating = True
        window.focus()


mod = "mod4"

terminal = guess_terminal()

layouts = [
    layout.Bsp(
        margin=5,
        border_focus="#B48EAD",
        border_on_single=True,
    )
]

groups = [
    Group("1"),
    Group("2"),
    Group("3"),
    Group("4"),
    Group("5"),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
]

scratchpad = ScratchPad(
    "0",
    [
        DropDown(
            "btop",
            f"{terminal} btop",
            width=0.9,
            height=0.9,
            opacity=0.9,
            on_focus_lost_hide=False,
        ),
        DropDown(
            "htop",
            f"{terminal} htop",
            width=0.8,
            height=0.7,
            opacity=0.9,
            on_focus_lost_hide=False,
        ),
        DropDown(
            "spotify",
            "spotify",
            width=0.75,
            height=0.8,
            opacity=0.95,
            on_focus_lost_hide=False,
        ),
        DropDown(
            "nemo",
            "nemo",
            width=0.75,
            height=0.8,
            opacity=0.95,
            on_focus_lost_hide=False,
        ),
        DropDown(
            terminal,
            terminal,
            width=0.75,
            height=0.8,
            opacity=0.95,
            on_focus_lost_hide=False,
        ),
        DropDown(
            "telegram",
            "telegram-desktop",
            width=0.75,
            height=0.8,
            opacity=0.95,
            on_focus_lost_hide=False,
        ),
        DropDown(
            "pavucontrol",
            "pavucontrol",
            width=0.75,
            height=0.8,
            opacity=0.95,
            on_focus_lost_hide=False,
        ),
        DropDown(
            "ncdu",
            "foot ncdu",
            width=0.75,
            height=0.8,
            opacity=0.95,
            on_focus_lost_hide=False,
        ),
    ],
    label="ScratchPad",
    single=True,
)

groups.append(scratchpad)

keys = init_keys(mod, terminal, groups)

mouse = init_mouse(mod)

widget_defaults = dict(font="RobotoMono Nerd Font", fontsize=14, padding_x=5, background=secondary)

extension_defaults = widget_defaults.copy()

bar_widgets = init_widgets()

screens = [
    Screen(
        bottom=bar.Bar(
            bar_widgets,
            30,
        ),
        wallpaper="/home/art/Pictures/wallpapers/1.png",
        wallpaper_mode="fill",
    ),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class=".blueman-manager-wrapped"),  # GPG key password entry
        Match(title="Google Password Manager"),
        Match(wm_class="org.qbittorrent.qBittorrent"),
        Match(func=lambda c: c.has_fixed_ratio()),
        # pycharm #
        Match(title="Confirm Exit"),
        Match(title="Push Commits"),
        Match(title="<no name>", wm_class="jetbrains-pycharm"),
        Match(wm_class="JetBrains Toolbox"),
        Match(title="meet.google.com is sharing a window."),
        Match(title="<no name>"),
        # end pycharm #
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:keyboard": InputConfig(kb_layout="us,ru", kb_options="grp:caps_toggle"),
}

wmname = "LG3D"
