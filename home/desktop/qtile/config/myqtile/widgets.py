import os
import random
import signal
import string
import subprocess
from itertools import cycle

from libqtile.lazy import lazy
from libqtile.log_utils import logger
from libqtile.utils import send_notification
from libqtile.widget import base
from qtile_extras import widget
from qtile_extras.popup.menu import PopupGridLayout, PopupText
from qtile_extras.widget import modify
from qtile_extras.widget.decorations import BorderDecoration

WP_DIR = os.path.expanduser("~/Pictures/wallpapers/")
_wallpapers = cycle(os.listdir(WP_DIR))


def noty(**kwargs) -> int:
    noty_id = send_notification(**kwargs)
    lazy.widget["notys"].force_update()
    # qtile.widgets_map["notys"].force_update()
    return noty_id


@lazy.function
def wallpaper(qtile):
    next_wp = next(_wallpapers)
    noty(title="wallpaper", message=next_wp)
    qtile.current_screen.set_wallpaper(os.path.join(WP_DIR, next_wp), mode="fill")


border_colour = "#5946B1"
border_width = 2
border_decor = BorderDecoration(
    border_width=[border_width, border_width, border_width, border_width],
    colour=border_colour,
    group=True,
)


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
        self.add_callbacks({"Button1": self.on_click})
        self.pid = None
        self.selected_screen = None
        self._last_noty_id = None

    def on_click(self):
        if self.is_recording:
            self._off()
            return
        monitors = subprocess.check_output("xrandr --listmonitors | cut -d' ' -f6", shell=True, text=True).split()
        if len(monitors) == 1:
            self.callback(monitors[0])()
            return

        controls = []
        for col, monitor in enumerate(monitors):
            control = PopupText(
                text=monitor,
                row=0,
                col=col,
                h_align="center",
                background="#5DADE2",
                mouse_callbacks={"Button1": self.callback(monitor)},
            )
            controls.append(control)

        layout = PopupGridLayout(
            self.qtile,
            controls=controls,
            rows=1,
            cols=2,
            height=40,
        )
        layout.show(centered=True)

    def callback(self, screen_idx: int):
        self.selected_screen = screen_idx
        return self.start

    @property
    def is_recording(self) -> bool:
        return bool(self.pid)

    def start(self):
        self.foreground = "#ff0000"
        self.update(self.RECORDER_ON)
        name = "".join(random.choices(string.ascii_lowercase + string.digits, k=10))
        cmd = [
            "wf-recorder",
            "--geometry",
            '"$(slurp)"',
            "-f",
            os.path.expanduser(f"~/Videos/{name}.mkv"),
            "--output",
            self.selected_screen,
        ]
        # logger.warning(" ".join(cmd))
        self.pid = self.qtile.spawn(cmd, shell=True)
        self._last_noty_id = self._noty(f"Recording started, pid: {self.pid}")

    def _off(self):
        os.kill(self.pid, signal.SIGKILL)
        self.foreground = "#ffffff"
        self.update(self.RECORDER_OFF)
        self._noty("Recording stopped")
        self._last_noty_id = None
        self.pid = None

    def _noty(self, msg: str):
        return noty(title="wf-recorder", message=msg, timeout=2, id_=self._last_noty_id)


class MicrophoneWidget(widget.Volume):
    def __init__(self):
        super().__init__(
            name="micro",
            fmt=" {}",
            channel="Capture",
            mouse_callbacks={"Button1": lazy.spawn("wpctl set-mute @DEFAULT_SOURCE@ toggle")},
            decorations=[border_decor],
        )

    # when microphone is unplugged builtin widget uses output device as input device, bruh
    # this implementation checks for "card 2" which is usually a microphone, but ofc not 100% sure
    def calculate_length(self):
        if not self._micro_is_present():
            return 0
        return super().calculate_length()

    def _micro_is_present(self) -> bool:
        output = subprocess.check_output("arecord -l", shell=True, text=True)
        return "card 2" in output


def get_wifi_interface() -> str:
    try:
        return subprocess.check_output("ls /sys/class/ieee80211/*/device/net/", shell=True, text=True).strip()
    except Exception as e:
        logger.exception(e)
    return ""


spacer = widget.Spacer(length=5, background="#ffffff.0")


def init_widgets():
    return [
        # widget.CurrentLayout(),
        widget.GroupBox(
            width=340,
            active="#81A1C1",
            inactive="#4C566A",
            block_highlight_text_color="#FFFFFF",
            highlight_method="line",
            highlight_color="#3B4252",
            this_current_screen_border="#81A1C1",
            urgent_alert_method="line",
            urgent_border="#BF616A",
            decorations=[border_decor],
        ),
        spacer,
        widget.TaskList(
            rounded=True,
            stretch=True,
            highlight_method="block",
            padding=2,
            margin=2.5,
            title_width_method="uniform",
            decorations=[border_decor],
        ),
        spacer,
        widget.Memory(
            measure_mem="G",
            format="󰍛 {MemUsed:.0f}{mm}/{MemTotal:.0f}{mm} ({MemPercent}%)",
            mouse_callbacks={
                "Button1": lazy.group["0"].dropdown_toggle("btop"),
                "Button3": lazy.group["0"].dropdown_toggle("htop"),
            },
            decorations=[border_decor],
        ),
        spacer,
        widget.DF(
            fmt="󰋊 {}",
            visible_on_warn=False,
            decorations=[border_decor],
            mouse_callbacks={
                "Button1": lazy.group["0"].dropdown_toggle("ncdu"),
            },
        ),
        spacer,
        widget.Volume(
            fmt="  {}",
            mouse_callbacks={"Button3": lazy.group["0"].dropdown_toggle("pavucontrol")},
            decorations=[border_decor],
        ),
        MicrophoneWidget(),
        spacer,
        widget.WiFiIcon(interface=get_wifi_interface(), decorations=[border_decor], padding_y=7),
        spacer,
        widget.StatusNotifier(decorations=[border_decor]),
        spacer,
        widget.Clock(
            format="%H:%M:%S",
            decorations=[border_decor],
        ),
        spacer,
        widget.Clock(
            format="%d/%m/%Y %a",
            mouse_callbacks={"Button1": lazy.spawn("gsimplecal")},
            decorations=[border_decor],
        ),
        spacer,
        widget.TextBox(
            fmt="",
            mouse_callbacks={"Button1": lazy.spawn('grim -g "$(slurp)" - | swappy -f -', shell=True)},
            padding=5,
            width=26,
            decorations=[border_decor],
        ),
        spacer,
        modify(RecorderWidget, padding=5, width=46, decorations=[border_decor]),
        # spacer,
        # widget.UPowerWidget(decorations=[bottom_border]),
        spacer,
        modify(NotysWidget, decorations=[border_decor]),
        spacer,
        widget.TextBox(
            fmt=" ",
            mouse_callbacks={"Button1": wallpaper},
            padding=5,
            width=26,
            decorations=[border_decor],
        ),
    ]
