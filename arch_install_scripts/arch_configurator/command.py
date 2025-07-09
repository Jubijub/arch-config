import logging
import subprocess
import os

logger = logging.getLogger(__name__)

def run(command: str, as_root: bool = False) -> subprocess.CompletedProcess:
    """Execute an arbitrary command, as root or not"""
    if as_root:
        # Check if we need to use sudo or if we're already root
        if os.geteuid() != 0:
            command = f"sudo {command}"
    
    logger.info("Executing: %s", command)
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    
    if result.returncode != 0:
        logger.error("Command failed with return code %d: %s", result.returncode, result.stderr)
    else:
        logger.debug("Command succeeded: %s", result.stdout)
    
    return result