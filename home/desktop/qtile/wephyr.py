#!/usr/bin/env python
#
# The Wayland backend's equivalent to the xephyr script
#
# The QTILE_XEPHYR environmental variable is set to 2 in this script, which can
# be used by configs to detect when they are run via this script.
#

import os
import re
import signal
import subprocess
import sys
import time
from pathlib import Path

_qtile_path = subprocess.check_output("which qtile", shell=True, text=True).strip()

BASE_DIR = (Path(_qtile_path) / "../..").resolve()

sys.path.insert(0, str(BASE_DIR))


scriptpath = Path(
    subprocess.run(["which", "qtile"], capture_output=True).stdout.decode().strip().replace("/qtile", "/.qtile-wrapped")
)
imports_line = scriptpath.read_text().split("\n")[2]
paths = eval(re.findall("\s\[.*\]", imports_line)[0])
sys.path.extend(paths)


# flake8: noqa
from libqtile.utils import get_cache_dir, guess_terminal

CACHE_DIR = Path(get_cache_dir())
QTILE = BASE_DIR / "bin" / "qtile"


# This script can be configured with environmental variables and arguments:
outputs = os.environ.get("OUTPUTS", 1)
app = os.environ.get("APP", guess_terminal()) or "kitty"
log_level = os.environ.get("LOG_LEVEL", "INFO")

cmd = [QTILE.as_posix(), "start", "-b", "wayland", "-l", log_level]
cmd.extend(sys.argv[1:])


# Find the display that the app needs
display = os.environ.get("WAYLAND_DISPLAY", "")
if display:
    display = display[:-1] + str(int(display[-1]) + 1)
else:
    display = "wayland-0"

os.environ["QTILE_XEPHYR"] = "2"
os.environ["WLR_X11_OUTPUTS"] = str(outputs)
os.environ["WLR_WL_OUTPUTS"] = str(outputs)

proc = subprocess.Popen(cmd)

time.sleep(1)
os.environ["WAYLAND_DISPLAY"] = display
app_proc = subprocess.Popen(app)


# Suppress KeyboardInterrupt messages
def noop(signal, frame):
    pass


signal.signal(signal.SIGINT, noop)

proc.wait()
