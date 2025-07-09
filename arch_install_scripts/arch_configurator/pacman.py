import logging
import os
import re
import subprocess
from .command import run
from .files import make_directory, cd

logger = logging.getLogger(__name__)

def init() -> None:
    """Install minimum set of tools for script execution"""
    base_packages = "wget curl git python python-pip"
    install(base_packages, as_root=True)
    
    # Install paru AUR helper if not already installed
    if not is_installed("paru"):
        logger.info("Installing paru AUR helper...")
        run("cd /tmp && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si --noconfirm", as_root=False)
    
    # Install textual for TUI
    run("pip install textual", as_root=False)

def is_installed(package_name_list: str) -> bool:
    """Check if package(s) are installed. Accepts space-separated package names."""
    packages = package_name_list.strip().split()
    
    for package_name in packages:
        result = subprocess.run(f'pacman -Qs {package_name}', shell=True, capture_output=True, text=True)
        if not result.stdout:
            logger.debug("No package found for %s.", package_name)
            return False
        found = re.search(rf"^local\/{re.escape(package_name)}\s", result.stdout, re.MULTILINE)
        if not found:
            logger.debug("No package found for %s.", package_name)
            return False
        else:
            logger.debug("Package found for %s: '%s'.", package_name, found.group(0))
    
    return True

def install(package_name_list: str, as_root: bool = True) -> None:
    """Install packages silently via pacman. Accepts space-separated package names."""
    packages = package_name_list.strip().split()
    packages_to_install = []
    
    for package in packages:
        if not is_installed(package):
            packages_to_install.append(package)
        else:
            logger.info("%s is already installed.", package)
    
    if packages_to_install:
        package_string = " ".join(packages_to_install)
        cmd = f"pacman -S {package_string} --noconfirm"
        result = run(cmd, as_root=as_root)
        if result.returncode != 0:
            logger.error("An error occurred while installing %s", package_string)
        else:
            logger.info("%s installed successfully.", package_string)

def clone(repository: str, base_folder: str = "~/Downloads") -> None:
    """Clone git repository to base folder"""
    expanded_folder = os.path.expanduser(base_folder)
    
    make_directory(expanded_folder)
    cd(expanded_folder)
    run(f"git clone {repository}", as_root=False)



