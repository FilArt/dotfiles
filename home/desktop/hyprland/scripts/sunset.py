#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 python3Packages.click

import click
import os
import subprocess

TEMP_FILE = "/tmp/.temp"
DEFAULT_TEMP = 7000
TEMP_LOW = 1000
TEMP_HIGH = 10000
TEMP_STEP = 1000

def read_current_temp():
    """Читает текущую температуру из временного файла."""
    if os.path.exists(TEMP_FILE):
        with open(TEMP_FILE, "r") as f:
            return int(f.read().strip())
    return DEFAULT_TEMP


def write_current_temp(temp):
    """Записывает текущую температуру в файл."""
    with open(TEMP_FILE, "w") as f:
        f.write(str(temp))

def restart_hyprsunset(temp):
    """Перезапускает hyprsunset с заданной температурой."""
    subprocess.run(["pkill", "-x", "hyprsunset"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.Popen(["hyprsunset", "--temperature", str(temp)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


@click.command()
@click.argument("action", type=click.Choice(["up", "down", "readonly"], case_sensitive=False))
def main(action):
    """Основная логика переключения температур."""
    current_temp = read_current_temp()
    temp = None
    if action == "up":
        if current_temp < TEMP_HIGH:
            temp = min(current_temp + TEMP_STEP, TEMP_HIGH)

    elif action == "down":
        if current_temp > TEMP_LOW:
            temp = max(current_temp - TEMP_STEP, TEMP_LOW)
   
    if temp:
        write_current_temp(temp)
        restart_hyprsunset(temp)
   
    print(current_temp)

if __name__ == "__main__":
    main()
