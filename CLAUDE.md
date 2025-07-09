# CLAUDE.md

## Project Purpose

Automated Arch Linux installation system for multiple deployment scenarios:
- Standalone OS installation on workstations/laptops  
- WSL installation within Windows
- Detailed procedures documented in ../arch-config.wiki/

## Architecture

### Current State: Migration from Shell to Python
- **Legacy**: Shell scripts (1_pre_install.sh → 5_desktop environment.sh) in ./arch_install_scripts/
- **Target**: Python-based automation using Textual TUI

### arch_install_scripts/ Structure
- **main.py**: Textual TUI application entry point, it will also be the install script itself that covers all the workstations/laptop and WSL specificities.
- **arch_configurator/ **: Python package that will contain helper functions to perform a scripted installation
- **pyproject.toml**: Python 3.13+ project configuration with uv dependency management

### Legacy hyprland_config/
Archived configuration files organized by filesystem hierarchy that are part of the manual install procedure (for large files, it was easier to download a ready made file than to manually edit it.) This should become irrelevant once we have fully scripted the installation.

## Development Commands

```bash
# Development environment
uv sync

# Run the Python installer
python main.py

# Legacy shell scripts (being replaced)
./1_pre_install.sh  # Disk partitioning, mounting
./2_bootloader_installation.sh  # Bootloader setup  
./3_post_installation.sh  # Post-install config
./4a_zsh.sh  # Shell configuration
./5_desktop environment.sh  # Desktop environment
```

## Architecture Principles

### Python Implementation
- Uses subprocess for system operations (pacman, wget, mkdir)
- Textual framework for interactive configuration selection and UI
- Environment variables for sensitive data (ROOT_PASSWORD)
- Logging-based feedback for installation progress

### Package Management Layer
- The `arch_configurator` module should provide the following helper functions.
- The `main.py` shoudl provide the UI, and the actual install script.
Small example of the script. It's a series of call to helper functions, to perform the tasks: 
```python
    ensure_base_tools()
    install("eza")
    install("bat")
    install("fd")
    install("fzf")
    install("ripgrep btop")
    download("https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme", "$(bat --config-dir)/themes")
```
- The install script will require actions performed as the user, and actions performed as root, so this should be supported by the helper functions. 
- the root password can be passed as an environment variable
- some commands will prompt the user, this should be passed back to the user so they can interact with those comments (eg: pacman or paru may sometimes ask which package should provide a particular functionality.)
- some commands require shell execution, for instance the `bat` tool config folder is obtained via `$(bat --config-dir)/themes` : the helpers should support this.
- the package management layer should have its own tests within the package `arch_install_scripts\arch_configurator`
- the script part `main.py` should have its own separated tests located in `arch_install_scripts`

## Code Style
- Only comment non-trivial operations
- Modify only: `./arch_install_scripts/`, `./main.py`, `./pyproject.toml`