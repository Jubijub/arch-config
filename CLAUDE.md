# CLAUDE.md

## Project Purpose

1. Create a python library `./arch_install_scripts/arch_configurator` that can perform atomic actions like download a config file, install a package, initialize a systemd service. Those functions should be idempotent, so calling them enables an end state that is predictible. For instance, asking a package should install the package if missing, or do nothing if it's there.
2. Automate an Arch Linux configuration starting from an Arch installed via:
- Standard Arch setup
- Arch setup using `archinstall`
- WSL installation within Windows, using `wsl --install archlinux`
Those scripts can be built using the `Textual` python package which provides a nice TUI interface to build scripts.

The goal is to automate what is currently a tedious set of manual steps documented in my [wiki](https://github.com/Jubijub/arch-config/wiki).

## Architecture

### Explaination of the various directories under the root folder
- `arch_install_scripts`: contains both old bash scripts, and the new scripts we will build.
- `arch_install_scripts\arch_configurator` : the python library we will also build to facilitate the execution of atomic actions.
- `arch_install_scripts\legacy_scripts` : outdated, can be used as a source of inspiration. DO NOT MODIFY.
- **main.py**: an automation script (we could imagine building several for various setups, or find a way to make it modular). 

## Architecture Principles

### Python Implementation
- Uses subprocess leveraging system binaries for system operations (pacman, wget, mkdir)
- Textual framework ( https://github.com/Textualize/textual ) for interactive configuration selection and UI
- Environment variables for sensitive data (ROOT_PASSWORD)
- Logging-based feedback for installation progress, including both text logs, and log messages on the screen as part of the TUI.

### Package Management Layer
- The `arch_configurator` module should provide the helper functions.
- The `main.py` shoudl provide the UI, and the actual install script leveraging `arch_configurator`
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
- avoid mocking in test, functions should be test by calling them, and examining their output as much as possible.
- use test fixtures if you need to create test objects