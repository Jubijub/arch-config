import logging
from datetime import datetime
from pathlib import Path

from .command import cache_sudo_credentials
from .pacman import init

log_file = Path("/tmp") / f"arch-install_{datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.log"

logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[logging.FileHandler(log_file)],
)

cache_sudo_credentials()
init()
