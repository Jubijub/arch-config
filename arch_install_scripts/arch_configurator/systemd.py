import logging
from .command import run

logger = logging.getLogger(__name__)

def enable_service(service_name: str, as_root: bool = True) -> None:
    """Enable a systemd service"""
    command = f"systemctl enable {service_name}"
    result = run(command, as_root=as_root)
    
    if result.returncode == 0:
        logger.info("Service %s enabled successfully", service_name)
    else:
        logger.error("Failed to enable service %s: %s", service_name, result.stderr)

def enable_and_start_service(service_name: str, as_root: bool = True) -> None:
    """Enable and start a systemd service"""
    # Enable the service first
    enable_service(service_name, as_root=as_root)
    
    # Then start it
    command = f"systemctl start {service_name}"
    result = run(command, as_root=as_root)
    
    if result.returncode == 0:
        logger.info("Service %s started successfully", service_name)
    else:
        logger.error("Failed to start service %s: %s", service_name, result.stderr)