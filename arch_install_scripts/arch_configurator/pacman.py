import logging
import os
import subprocess
from .command import run
from .files import make_directory, cd
from .result import StepResult

logger = logging.getLogger(__name__)


def init() -> None:
    """Install minimum set of tools for script execution"""
    base_packages = "wget curl git python python-pip"
    install(base_packages)
    
    # Install paru AUR helper if not already installed
    if not is_installed("paru"):
        logger.info("Installing paru AUR helper...")
        run("cd /tmp && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si --noconfirm", as_root=False)
    
    # Install textual for TUI
    run("pip install textual", as_root=False)

def is_installed(package_name_list: str) -> bool:
    """Check if package(s) are installed. Accepts space-separated package names."""
    packages = package_name_list.strip().split()

    official = subprocess.run('paru -Qs', shell=True, capture_output=True, text=True)
    installed = {
        line.split('/')[1].split()[0]
        for line in official.stdout.splitlines()
        if line.startswith('local/')
    }

    aur = subprocess.run('paru -Qm', shell=True, capture_output=True, text=True)
    installed |= {line.split()[0] for line in aur.stdout.splitlines() if line}

    for package_name in packages:
        if package_name not in installed:
            logger.debug("No package found for %s.", package_name)
            return False
        logger.debug("Package found for %s.", package_name)

    return True

def install(package_name_list: str) -> StepResult:
    """Install packages silently via paru. Accepts space-separated package names."""
    packages = package_name_list.strip().split()
    packages_to_install = []

    for package in packages:
        if not is_installed(package):
            packages_to_install.append(package)
        else:
            logger.info("%s is already installed.", package)

    if not packages_to_install:
        return StepResult.NO_CHANGE

    package_string = " ".join(packages_to_install)
    cmd = f"paru -S {package_string} --noconfirm"
    result = run(cmd)
    if result.returncode != 0:
        logger.error("An error occurred while installing %s", package_string)
        return StepResult.ERROR

    logger.info("%s installed successfully.", package_string)
    return StepResult.SUCCESS

def clone(repository: str, base_folder: str = "~/Downloads") -> None:
    """Clone git repository to base folder"""
    expanded_folder = os.path.expanduser(base_folder)
    
    make_directory(expanded_folder)
    cd(expanded_folder)
    run(f"git clone {repository}", as_root=False)



