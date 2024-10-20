import json
import subprocess
from libqtile.log_utils import logger
from rofi import Rofi

rofi_default_args = ["-i"]

def change_audio_sink(qtile, *, rofi = None):
    r = rofi or Rofi()
    proc = subprocess.Popen("pactl -f json list sinks".split(" "), stdout=subprocess.PIPE)
    try:
        out, err = proc.communicate(timeout=1)
    except TimeoutError as toe:
        proc.kill()
        logger.error("Issue when running pactl : \n{}".format(err))
        r.error(str(toe))
    data = json.loads(out)
    index, _ = r.select("Select audio output", [item["description"] for item in data])
    
    if index >= 0:
        selection = data[index]
        try:
            cmd = "pactl set-default-sink {}".format(selection["name"])
            subprocess.Popen(cmd.split(" "))
            # r.status("Audio output set to {}.".format(sel["description"]))
        except Exception as ex:
            logger.error("Issue when setting the new default sink \n{}".format(str(ex)))
            r.error(str(ex))
