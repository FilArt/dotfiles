import os
import random
import signal
import string
import subprocess

from libqtile.widget import base
from libqtile import bar, hook
from libqtile.backend.wayland import InputConfig
from libqtile.config import Click, Drag, DropDown, Group, Key, Match, ScratchPad, Screen
from libqtile.lazy import lazy
from libqtile.log_utils import logger
from libqtile.utils import guess_terminal, send_notification
from libqtile.widget import backlight
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration

from qtile_extras.widget import modify
from qtile_extras import layout


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

layouts = [
    layout.Bsp(
        margin=5,
        border_focus=nord15,
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
    Key([mod], "d", lazy.spawn("rofi -show drun -show-icons", shell=True)),
    Key([mod], "s", lazy.group["0"].dropdown_toggle("spotify")),
    Key([mod], "e", lazy.group["0"].dropdown_toggle("nemo")),
    Key([mod], "c", lazy.spawn("swaync-client -t")),
    Key([mod], "t", lazy.group["0"].dropdown_toggle(terminal)),
    Key(
        [mod],
        "v",
        lazy.spawn("cliphist list | rofi -dmenu | cliphist decode | wl-copy", shell=True),
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
    # Key([], "Print", lazy.spawn('grim -g "$(slurp)" - | swappy -f -', shell=True)),
    Key(
        [],
        "Print",
        lazy.spawn(
            """
            grim -g "$(slurp -o -r -c '#ff0000ff')" - | \
            satty --filename - \
            --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
            """,
            shell=True,
        ),
    ),
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
        border_width=[0, 0, 2, 0],
    ),
]

widget_defaults = dict(font="RobotoMono Nerd Font", fontsize=14, padding_x=5)  # , decorations=decor)
extension_defaults = widget_defaults.copy()


@lazy.function
def wallpaper(qtile):
    wp_dir = os.path.expanduser("~/Pictures/wallpapers/")
    wallpapers = os.listdir(wp_dir)
    next_wp = random.choice(wallpapers)
    qtile.current_screen.set_wallpaper(os.path.join(wp_dir, next_wp), mode="fill")


def noty(**kwargs) -> int:
    noty_id = send_notification(**kwargs, urgent=True)
    lazy.widget["notys"].force_update()
    logger.warning(vars(lazy.widget["notys"].force_update()))
    # qtile.widgets_map["notys"].force_update()
    return noty_id


class NotysWidget(base.InLoopPollText):
    def __init__(self, **kwargs):
        super().__init__(
            name="notys",
            fmt="{}  ",
            update_interval=5,
            mouse_callbacks={"Button1": self.show_notys},
            **kwargs,
        )

    def show_notys(self):
        pass
        # subprocess.run(["swaync-client", "-t"])

    def poll(self):
        return subprocess.run(["swaync-client", "-c", "-sw"], capture_output=True).stdout.decode() or "0"


class RecorderWidget(base._TextBox):
    RECORDER_OFF = "   "
    RECORDER_ON = "   "

    def __init__(self, **config):
        super().__init__("recorder", **config)
        self.text = self.RECORDER_OFF
        self.add_callbacks({"Button1": self.toggle_recording})
        self.pid = None
        self._last_noty_id = None

    def toggle_recording(self):
        recorder_pid = subprocess.run(["pgrep", "wf-recorder"], capture_output=True, text=True).stdout.strip()
        if recorder_pid and recorder_pid.isdigit():
            self.pid = int(recorder_pid)
        else:
            self.pid = 0

        if recorder_pid:
            self._off()
        else:
            self._on()

    def _on(self):
        self.foreground = "#ff0000"
        self.update(self.RECORDER_ON)
        name = "".join(random.choices(string.ascii_lowercase + string.digits, k=10))
        #:wgeometry = os.popen("slurp").read().strip().split(" ")
        cmd = [
            "wf-recorder",
            "-g",
            "$(slurp)",
            "-f",
            os.path.expanduser(f"~/Videos/{name}.mkv"),
            "-c",
            "h264_vaapi",
            "-d",
            "/dev/dri/renderD128",
        ]
        self.pid = self.qtile.spawn(cmd)
        # self.pid = int(subprocess.run(cmd, capture_output=True, text=True).stdout.strip())
        self._last_noty_id = self._noty(f"Recording starte, pid: {self.pid}")

    def _off(self):
        os.kill(self.pid, signal.SIGTERM)
        self.foreground = "#ffffff"
        self.update(self.RECORDER_OFF)
        self._noty("Recording stopped")
        self._last_noty_id = None

    def _noty(self, msg: str):
        return noty(title="wf-recorder", message=msg, timeout=2, id_=self._last_noty_id)


bottom_border = BorderDecoration(
    border_width=[0, 0, 2, 0],
    colour=nord13,
)

spacer = widget.Spacer(length=5, background="#ffffff.0")

bar_widgets = [
    # widget.CurrentLayout(),
    widget.GroupBox(
        active="#81A1C1",
        inactive="#4C566A",
        block_highlight_text_color="#FFFFFF",
        highlight_method="line",
        highlight_color="#3B4252",
        this_current_screen_border="#81A1C1",
        urgent_alert_method="line",
        urgent_border="#BF616A",
        decorations=[bottom_border],
    ),
    spacer,
    widget.TaskList(
        rounded=True,
        stretch=True,
        highlight_method="block",
        padding=2,
        margin=2.5,
        title_width_method="uniform",
        decorations=[bottom_border],
    ),
    spacer,
    widget.Memory(
        measure_mem="G",
        format="󰍛 {MemUsed:.0f}{mm}/{MemTotal:.0f}{mm} ({MemPercent}%)",
        mouse_callbacks={"Button1": lazy.group["0"].dropdown_toggle("htop")},
        decorations=[bottom_border],
    ),
    spacer,
    widget.DF(fmt="󰋊 {}", visible_on_warn=False, decorations=[bottom_border]),
    spacer,
    widget.Volume(fmt="  {}", decorations=[bottom_border]),
    spacer,
    widget.WiFiIcon(interface="wlp45s0", decorations=[bottom_border]),
    spacer,
    widget.StatusNotifier(decorations=[bottom_border]),
    spacer,
    widget.Clock(
        format="%H:%M:%S",
        decorations=[bottom_border],
    ),
    spacer,
    widget.Clock(
        format="%d/%m/%Y %a",
        mouse_callbacks={"Button1": lazy.spawn("bfcal")},
        decorations=[bottom_border],
    ),
    spacer,
    widget.TextBox(
        fmt="",
        mouse_callbacks={"Button1": lazy.spawn('grim -g "$(slurp)" - | swappy -f -', shell=True)},
        padding=5,
        width=26,
        decorations=[bottom_border],
    ),
    spacer,
    modify(RecorderWidget, padding=5, width=46, decorations=[bottom_border]),
    spacer,
    widget.UPowerWidget(decorations=[bottom_border]),
    spacer,
    modify(NotysWidget, decorations=[bottom_border]),
    spacer,
    widget.TextBox(
        fmt=" ",
        mouse_callbacks={"Button1": wallpaper},
        padding=5,
        width=26,
        decorations=[bottom_border],
    ),
]

screens = [
    Screen(
        bottom=bar.Bar(
            bar_widgets,
            30,
            margin=[2, 0, 2, 0],
            background="#2E3440",
        ),
        wallpaper="/home/art/Pictures/wallpapers/1.png",
        wallpaper_mode="fill",
    ),
    Screen(),
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
