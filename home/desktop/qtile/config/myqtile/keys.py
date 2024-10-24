from libqtile.config import Click, Drag, Group, Key
from libqtile.lazy import lazy
from libqtile.widget import backlight

capture_screen = lazy.spawn(
    """
        grim -g "$(slurp -o -r -c '#ff0000ff')" - | \
        satty --filename - \
        --output-filename /home/art/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
    """,
    shell=True,
)


def init_keys(mod: str, terminal: str, groups: list[Group]):
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
        Key([mod, "control"], "1", lazy.window.toscreen(0)),
        Key([mod, "control"], "2", lazy.window.toscreen(1)),
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
        Key([mod], "d", lazy.spawn('bash -c "rofi -show drun -show-icons" &> /tmp/rofi_menu.log', shell=True)),
        Key([mod], "s", lazy.group["0"].dropdown_toggle("spotify")),
        Key([mod], "e", lazy.group["0"].dropdown_toggle("nemo")),
        Key([mod], "c", lazy.spawn("swaync-client -t")),
        Key([mod], "t", lazy.group["0"].dropdown_toggle(terminal)),
        Key([mod], "w", lazy.group["0"].dropdown_toggle("telegram")),
        Key(
            [mod],
            "v",
            lazy.spawn("cliphist list | rofi -dmenu | cliphist decode | wl-copy", shell=True),
        ),
        Key([], "XF86MonBrightnessUp", lazy.widget["backlight"].change_backlight(backlight.ChangeDirection.UP)),
        Key(
            [],
            "XF86MonBrightnessDown",
            lazy.widget["backlight"].change_backlight(backlight.ChangeDirection.DOWN),
        ),
        Key([], "XF86AudioLowerVolume", lazy.widget["volume"].decrease_vol()),
        Key([], "XF86AudioRaiseVolume", lazy.widget["volume"].increase_vol()),
        Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_SINK@ toggle")),
        Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
        Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
        Key([], "Print", capture_screen),
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
    return keys


def init_mouse(mod):
    return [
        Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
        Click([mod], "Button2", lazy.window.bring_to_front()),
    ]
