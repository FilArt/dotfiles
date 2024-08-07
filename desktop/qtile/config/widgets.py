import os
import random
import signal
import string
import subprocess

from libqtile.lazy import lazy
from libqtile.utils import send_notification
from libqtile.widget import base
from qtile_extras import widget
from qtile_extras.popup.menu import PopupGridLayout, PopupText
from qtile_extras.widget import modify
from qtile_extras.widget.decorations import BorderDecoration


def noty(**kwargs) -> int:
    noty_id = send_notification(**kwargs)
    lazy.widget["notys"].force_update()
    # qtile.widgets_map["notys"].force_update()
    return noty_id


@lazy.function
def wallpaper(qtile):
    wp_dir = os.path.expanduser("~/Pictures/wallpapers/")
    wallpapers = os.listdir(wp_dir)
    next_wp = random.choice(wallpapers)
    qtile.current_screen.set_wallpaper(os.path.join(wp_dir, next_wp), mode="fill")


bottom_border = BorderDecoration(
    border_width=[0, 0, 2, 0],
    colour="#EBCB8B",
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
            "-c",
            "h264_vaapi",
            "-d",
            "/dev/dri/renderD128",
            "--output",
            self.selected_screen,
        ]
        print(" ".join(cmd))
        self.pid = self.qtile.spawn(cmd, shell=True)
        self._last_noty_id = self._noty(f"Recording starte, pid: {self.pid}")

    def _off(self):
        os.kill(self.pid, signal.SIGTERM)
        self.foreground = "#ffffff"
        self.update(self.RECORDER_OFF)
        self._noty("Recording stopped")
        self._last_noty_id = None
        self.pid = None

    def _noty(self, msg: str):
        return noty(title="wf-recorder", message=msg, timeout=2, id_=self._last_noty_id)


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
            mouse_callbacks={"Button1": lazy.group["0"].dropdown_toggle("btop")},
            decorations=[bottom_border],
        ),
        spacer,
        widget.DF(fmt="󰋊 {}", visible_on_warn=False, decorations=[bottom_border]),
        spacer,
        widget.Volume(
            fmt="  {}",
            mouse_callbacks={"Button3": lazy.group["0"].dropdown_toggle("pavucontrol")},
            decorations=[bottom_border],
        ),
        spacer,
        widget.WiFiIcon(interface="wlp45s0", decorations=[bottom_border]),
        spacer,
        widget.StatusNotifier(decorations=[bottom_border]),
        widget.TextBox(
            text=" ",
            padding=5,
            width=26,
            mouse_callbacks={
                "Button1": lazy.spawn("qtile cmd-obj -o widget statusnotifier -f eval -a 'host.items = []'")
            },
            decorations=[bottom_border],
        ),
        spacer,
        widget.Clock(
            format="%H:%M:%S",
            decorations=[bottom_border],
        ),
        spacer,
        widget.Clock(
            format="%d/%m/%Y %a",
            mouse_callbacks={"Button1": lazy.spawn("gsimplecal")},
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
