#!/home/art/.config/home-manager/hm-python/.venv/bin/python

import subprocess

import click

TEMP_FILE = "/tmp/.temp"


def recording_on():
    cmd = "pgrep -x wf-recorder"
    return subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0


def start_recording():
    cmd = """wf-recorder --geometry "$(slurp)" -f ~/Videos/"$(date +'%Y-%m-%d_%H-%M-%S')".mkv"""
    subprocess.run(cmd, shell=True)


def stop_recording():
    cmd = "pkill wf-recorder"
    subprocess.run(cmd, shell=True)


@click.command()
@click.argument("action", type=click.Choice(["readonly", "on-click"], case_sensitive=False))
def main(action):
    print(action)
    recording = recording_on()

    if recording:
        print("󰑋")
    else:
        print("󰨜")

    if action == "on-click":
        if recording:
            stop_recording()
        else:
            start_recording()


if __name__ == "__main__":
    main()
