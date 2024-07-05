from libqtile.log_utils import logger

import random
from libqtile.backend.wayland import InputConfig

import os
import subprocess
from libqtile.config import Group, ScratchPad, DropDown, Match

from libqtile import bar, layout, hook
from libqtile.config import Click, Drag, Key, Screen
from qtile_extras import widget
from libqtile.lazy import lazy

from libqtile.widget import backlight

from qtile_extras.widget.decorations import BorderDecoration
from libqtile.utils import guess_terminal


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/home-manager/desktop/autostart.sh")
    subprocess.Popen([home])


mod = "mod4"
terminal = guess_terminal()

nord0 = "#2E3440"
nord1 = "#3B4252"
nord2 = "#434C5E"
nord3 = "#4C566A"
nord4 = "#D8DEE9"
nord5 = "#E5E9F0"
nord6 = "#ECEFF4"
nord7 = "#8FBCBB"
nord8 = "#88C0D0"
nord9 = "#81A1C1"
nord10 = "#5E81AC"
nord11 = "#BF616A"
nord12 = "#D08770"
nord13 = "#EBCB8B"
nord14 = "#A3BE8C"
nord15 = "#B48EAD"
background = nord0
foreground = nord4
red = nord11
green = nord14
yellow = nord13
blue = nord9
magenta = nord15
cyan = nord8
orange = nord12
white = nord4
bright_white = nord6
black = nord0
bright_black = nord3

layouts = [layout.Bsp()]

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
    ],
    label="ScratchPad",
    single=True,
)

groups.append(scratchpad)

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod, "shift"], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "d", lazy.spawn("fuzzel")),
    Key([mod], "s", lazy.group["0"].dropdown_toggle("spotify")),
    Key([mod], "e", lazy.group["0"].dropdown_toggle("nemo")),
    Key([mod], "t", lazy.group["0"].dropdown_toggle(terminal)),
    Key(
        [mod],
        "v",
        lazy.spawn('sh -c "pkill wofi; cliphist list | wofi --dmenu --prompt clip | cliphist decode | wl-copy"'),
    ),
    Key([], "XF86MonBrightnessUp", lazy.widget["backlight"].change_backlight(backlight.ChangeDirection.UP)),
    Key([], "XF86MonBrightnessDown", lazy.widget["backlight"].change_backlight(backlight.ChangeDirection.DOWN)),
    Key([], "XF86AudioLowerVolume", lazy.widget["pulsevolume"].decrease_vol()),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.widget["pulsevolume"].increase_vol(),
        lazy.spawn(
            """
            dunstify "Volume: " -h int:value:50 -t 2000
            """
        ),
    ),
    Key([], "Print", lazy.spawn('grim -g "$(slurp)" - | swappy -f -', shell=True)),
]
for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

decor = [
    BorderDecoration(
        colour=nord2,
        border_width=[1, 1, 1, 1],
    ),
]

widget_defaults = dict(font="RobotoMono Nerd Font", fontsize=14, padding=3, decorations=decor)
extension_defaults = widget_defaults.copy()

widget_decor = {}

groupbox = widget.GroupBox2(
    rules=[
        widget.groupbox2.GroupBoxRule().when(
            screen=widget.groupbox2.ScreenRule.NONE, focused=False, occupied=False, urgent=False
        ),
        widget.groupbox2.GroupBoxRule().when(
            screen=widget.groupbox2.ScreenRule.NONE, focused=False, occupied=True, urgent=False
        ),
        widget.groupbox2.GroupBoxRule(text_colour="bbff00").when(occupied=True),
        widget.groupbox2.GroupBoxRule(line_colour="00ff00").when(focused=True),
        widget.groupbox2.GroupBoxRule(line_colour="ffffff").when(
            screen=widget.groupbox2.ScreenRule.OTHER, focused=False, occupied=False, urgent=False
        ),
    ]
)

chord = widget.Chord(
    chords_colors={
        "launch": ("#ff0000", "#ffffff"),
    },
    name_transform=lambda name: name.upper(),
)

memory = widget.Memory(
    measure_mem="G",
    format="󰍛 {MemUsed:.0f}{mm}/{MemTotal:.0f}{mm} ({MemPercent}%)",
    mouse_callbacks={"Button1": lazy.group["0"].dropdown_toggle("htop")},
    # background="#600060",
)

battery = widget.Battery(
    format="{char} {percent:2.0%}",
    charge_char="",
    discharge_char="",
    empty_char="",
    full_char="",
    not_charging_char="",
    update_interval=10,
)


def get_notys():
    return subprocess.run(["swaync-client", "-c"], capture_output=True).stdout.decode()


@lazy.function
def wallpaper(qtile):
    wp_dir = os.path.expanduser("~/Pictures/wallpapers/")
    wallpapers = os.listdir(wp_dir)
    next_wp = random.choice(wallpapers)
    logger.warning(next_wp)
    qtile.current_screen.set_wallpaper(os.path.join(wp_dir, next_wp), mode="fill")


bar_widgets = [
    # widget.CurrentLayout(),
    groupbox,
    widget.TaskList(rounded=True, stretch=True),
    chord,
    memory,
    widget.DF(fmt="󰋊 {}", visible_on_warn=False),
    widget.Volume(fmt="  {}"),
    widget.WiFiIcon(interface="wlp45s0"),
    widget.StatusNotifier(),
    widget.Clock(
        format="%H:%M:%S",
        **widget_decor,
    ),
    widget.Clock(
        format="%d/%m/%Y %a",
        mouse_callbacks={"Button1": lazy.spawn("bfcal")},
        **widget_decor,
    ),
    widget.TextBox(
        fmt="󰹑 ",
        mouse_callbacks={"Button1": lazy.spawn('grim -g "$(slurp)" - | swappy -f -', shell=True)},
        padding=5,
    ),
    battery,
    widget.GenPollText(
        func=get_notys,
        fmt="{}  ",
        mouse_callbacks={"Button1": lazy.spawn("swaync-client -t")},
        update_interval=10,
    ),
    widget.TextBox(mouse_callbacks={"Button1": wallpaper}),
]

screens = [
    Screen(
        bottom=bar.Bar(
            bar_widgets,
            30,
            margin=0,
            background="#2E3440.5",
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
    ]
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
