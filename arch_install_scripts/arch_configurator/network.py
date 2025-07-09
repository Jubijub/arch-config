import logging
import subprocess

logger = logging.getLogger(__name__)

def verify_connectivity(host: str, ipv6: bool = False) -> bool:
    """Verify network connectivity to a host using ping"""
    ping_cmd = "ping -6" if ipv6 else "ping"
    command = f"{ping_cmd} -c 3 {host}"
    
    logger.info("Testing connectivity to %s (IPv%s)", host, "6" if ipv6 else "4")
    
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True, timeout=30)
        
        if result.returncode == 0:
            logger.info("Successfully reached %s", host)
            return True
        else:
            logger.warning("Failed to reach %s: %s", host, result.stderr)
            return False
            
    except subprocess.TimeoutExpired:
        logger.error("Ping to %s timed out", host)
        return False
    except Exception as e:
        logger.error("Error pinging %s: %s", host, str(e))
        return False