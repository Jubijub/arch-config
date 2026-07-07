import logging
import subprocess
import os

logger = logging.getLogger(__name__)

_sudo_password: str = ""


def set_sudo_password(password: str) -> None:
    global _sudo_password
    _sudo_password = password


def cache_sudo_credentials() -> bool:
    """Validate the stored password and cache sudo credentials for the session."""
    if not _sudo_password:
        logger.error("Sudo password is not set.")
        return False

    result = subprocess.run('sudo -S -v', shell=True, capture_output=True, text=True, input=_sudo_password + '\n')

    if result.returncode != 0:
        if 'incorrect password' in result.stderr.lower():
            logger.error("Incorrect sudo password supplied.")
        else:
            logger.error("Failed to cache sudo credentials: %s", result.stderr)
        return False

    logger.info("Sudo credentials cached successfully.")
    return True


def run(command: str, as_root: bool = False) -> subprocess.CompletedProcess:
    """Execute an arbitrary command, as root or not"""
    stdin_input = None

    if as_root and os.geteuid() != 0:
        if not _sudo_password:
            logger.error("Sudo password is not set. Cannot run as root.")
            return subprocess.CompletedProcess(command, returncode=1, stdout='', stderr='Sudo password not set')
        command = f"sudo -S {command}"
        stdin_input = _sudo_password + '\n'

    logger.info("Executing: %s", command)
    result = subprocess.run(command, shell=True, capture_output=True, text=True, input=stdin_input)

    if result.returncode != 0:
        if 'incorrect password' in result.stderr.lower():
            logger.error("Incorrect sudo password supplied.")
        else:
            logger.error("Command failed with return code %d: %s", result.returncode, result.stderr)
    else:
        logger.debug("Command succeeded: %s", result.stdout)

    return result
