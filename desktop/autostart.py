#!/usr/bin/env python3

import asyncio


commands = [
    "systemctl --user import-environment WAYLAND_DISPLAY",
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    "pkill wpaperd; wpaperd",
    'sleep 1 && way-displays > "/tmp/way-displays.log" 2 >&1',
]


async def run(cmd):
    await asyncio.create_subprocess_shell(cmd)


async def main():
    tasks = [asyncio.create_task(run(cmd)) for cmd in commands]
    await asyncio.gather(*tasks)


if __name__ == "__main__":
    asyncio.run(main())
