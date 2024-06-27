#!/usr/bin/env python3

import asyncio


commands = [
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    "pkill wpaperd; wpaperd",
]


async def run(cmd):
    await asyncio.create_subprocess_shell(cmd)


async def main():
    tasks = [asyncio.create_task(run(cmd)) for cmd in commands]
    await asyncio.gather(*tasks)


if __name__ == "__main__":
    asyncio.run(main())
