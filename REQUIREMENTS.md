# List of helper functions
Those functions shouold live in `./arch_configurator` package. We should group them logically (eg: `pacman.py` could contain all scripts related to package management, like `init()`, `is_installed()`)

## Package management
Should live in `./arch_configurator/pacman.py`
- `init()`: should install the minimum set of tools so that the script can run on a fresh install (wget, curl, paru) as well as install the required python and python packages (like `textual`)
- `is_installed(packageNameList:str)`: Check if an ArchLinux package (or a space separated list of package, as a string) is installed
- `install()`: Install packages silently, via pacman with --noconfirm.
- `clone(repository, base_folder='~/Downloads')` : should `cd` to the base_folder, and perform `git clone <repository>`

## Files management
- `download(url, target_directory, overriden_filename)`: Fetch files with wget to specified directories. Should handle the case where root access is required to write in the directory. Should allow to change the name of the file.
- `make_directory(path)`: Create directory structures. Should create the missing folders (like `mkdir -p` does). Should handle the case where root access is required to create the directory
- `cd(path)`: cd to that directory. Should create the directory if it doesn't exist, using `make_directory(path)`
- `uncomment_line(file:str, line_pattern:str, comment_char='#')` : with the `file` path provided, opens the file and uncomment the line that matches the regex pattern given with `line_pattern`, by removing the comment character provided with `comment_char`. For exemple, `uncomment_line('/etc/pacman.conf', '#Color', '#') should uncomment the line `#Color` so that it appears as `Color` in the file.
- `add_options(file:str, line_pattern:str, options:str)`: with the `file` path provided, opens the file, locate the line, and add options inside the parenthesis. This would for instance allow a call `add_options('/etc/mkinitcpio.conf', 'MODULES=()', 'nvidia nvidia_modeset nvidia_uvm nvidia_drm')` to open the file `/etc/mkinitcpio.conf`, locate the `MODULES` option line, and modify it to make it read `MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)`

## Network management
- `verify_connectivity(host, ip_v6:bool)`: should use `ping` to verify that the host can be reached. Should provide a flag to use IP V6 instead.

## SystemD management
- `enable_service(service_name:str, as_root:bool)`: should enable the systemd service named `service_name` via `sudo systemctl enable <service_name>`
- `enable_and_start_service(service_name:str, as_root:bool)`: should run the systemd service named `service_name` via `sudo systemctl start <service_name>`

## Command management
- `run(command, as_root:bool)` : shoudl execute an arbitrary command, as root or not