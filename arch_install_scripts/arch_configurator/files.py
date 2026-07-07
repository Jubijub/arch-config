import logging
import os
import re
import shutil
from .command import run
from .result import StepResult


def github_tree_to_raw(url: str) -> str:
    """Convert a GitHub tree URL to a raw.githubusercontent.com URL."""
    return re.sub(
        r'https://github\.com/([^/]+)/([^/]+)/tree/(.+)',
        r'https://raw.githubusercontent.com/\1/\2/\3',
        url,
    )

logger = logging.getLogger(__name__)

def download(url: str, target_directory: str, overriden_filename: str = None) -> StepResult:
    """Fetch files with wget to specified directories"""
    expanded_target = os.path.expanduser(target_directory)

    # Handle shell expansion like $(bat --config-dir)
    if '$(' in expanded_target:
        result = run(f'echo "{expanded_target}"', as_root=False)
        if result.returncode == 0:
            expanded_target = result.stdout.strip()

    filename = overriden_filename or os.path.basename(url)
    full_path = os.path.join(expanded_target, filename)

    if os.path.exists(full_path):
        logger.info("File already exists, skipping: %s", full_path)
        return StepResult.NO_CHANGE

    make_directory(expanded_target)

    try:
        if overriden_filename:
            result = run(f'wget -O "{full_path}" "{url}"', as_root=os.access(expanded_target, os.W_OK) == False)
        else:
            result = run(f'wget -P "{expanded_target}" "{url}"', as_root=os.access(expanded_target, os.W_OK) == False)

        if result.returncode != 0:
            logger.error("An error occurred while downloading %s", url)
            return StepResult.ERROR
        else:
            logger.info("Downloaded %s successfully", url)
            return StepResult.SUCCESS
    except Exception as e:
        logger.error("Download failed: %s", str(e))
        return StepResult.ERROR

def make_directory(path: str) -> None:
    """Create directory structures with mkdir -p behavior"""
    expanded_path = os.path.expanduser(path)
    
    try:
        # Try to create without sudo first
        os.makedirs(expanded_path, exist_ok=True)
        logger.info("Created directory: %s", expanded_path)
    except PermissionError:
        # Need root access
        result = run(f'mkdir -p "{expanded_path}"', as_root=True)
        if result.returncode != 0:
            logger.error("An error occurred while creating %s", expanded_path)
        else:
            logger.info("Created directory with sudo: %s", expanded_path)

def cd(path: str) -> None:
    """Change to directory, creating it if it doesn't exist"""
    expanded_path = os.path.expanduser(path)
    
    if not os.path.exists(expanded_path):
        make_directory(expanded_path)
    
    try:
        os.chdir(expanded_path)
        logger.info("Changed directory to: %s", expanded_path)
    except Exception as e:
        logger.error("Failed to change directory to %s: %s", expanded_path, str(e))

def uncomment_line(file: str, line_pattern: str, comment_char: str = '#') -> None:
    """Uncomment lines matching regex pattern in a file"""
    expanded_file = os.path.expanduser(file)
    
    try:
        with open(expanded_file, 'r') as f:
            content = f.read()
        
        # Find and uncomment lines matching the pattern
        lines = content.split('\n')
        modified = False
        
        for i, line in enumerate(lines):
            if re.search(line_pattern, line) and line.strip().startswith(comment_char):
                # Remove the comment character and any following whitespace
                uncommented = re.sub(f'^\\s*{re.escape(comment_char)}\\s*', '', line)
                lines[i] = uncommented
                modified = True
                logger.info("Uncommented line: %s -> %s", line.strip(), uncommented)
        
        if modified:
            new_content = '\n'.join(lines)
            # Check if we need sudo to write
            need_sudo = not os.access(expanded_file, os.W_OK)
            
            if need_sudo:
                # Write to temp file then move with sudo
                temp_file = f"/tmp/{os.path.basename(expanded_file)}.tmp"
                with open(temp_file, 'w') as f:
                    f.write(new_content)
                result = run(f'cp "{temp_file}" "{expanded_file}"', as_root=True)
                os.remove(temp_file)
                if result.returncode != 0:
                    logger.error("Failed to write file %s", expanded_file)
            else:
                with open(expanded_file, 'w') as f:
                    f.write(new_content)
            
            logger.info("Updated file: %s", expanded_file)
        else:
            logger.info("No lines to uncomment in %s", expanded_file)
            
    except Exception as e:
        logger.error("Failed to process file %s: %s", expanded_file, str(e))

def add_options(file: str, line_pattern: str, options: str) -> None:
    """Add options inside parentheses for lines matching pattern"""
    expanded_file = os.path.expanduser(file)
    
    try:
        with open(expanded_file, 'r') as f:
            content = f.read()
        
        lines = content.split('\n')
        modified = False
        
        for i, line in enumerate(lines):
            if re.search(line_pattern, line):
                # Find parentheses and add options inside
                if '()' in line:
                    lines[i] = line.replace('()', f'({options})')
                    modified = True
                    logger.info("Modified line: %s -> %s", line.strip(), lines[i])
                elif '(' in line and ')' in line:
                    # Add to existing options
                    pattern = r'(\([^)]*)\)'
                    replacement = rf'\1 {options})'
                    lines[i] = re.sub(pattern, replacement, line)
                    modified = True
                    logger.info("Modified line: %s -> %s", line.strip(), lines[i])
        
        if modified:
            new_content = '\n'.join(lines)
            need_sudo = not os.access(expanded_file, os.W_OK)
            
            if need_sudo:
                temp_file = f"/tmp/{os.path.basename(expanded_file)}.tmp"
                with open(temp_file, 'w') as f:
                    f.write(new_content)
                result = run(f'cp "{temp_file}" "{expanded_file}"', as_root=True)
                os.remove(temp_file)
                if result.returncode != 0:
                    logger.error("Failed to write file %s", expanded_file)
            else:
                with open(expanded_file, 'w') as f:
                    f.write(new_content)
            
            logger.info("Updated file: %s", expanded_file)
        else:
            logger.info("No matching lines found in %s", expanded_file)
            
    except Exception as e:
        logger.error("Failed to process file %s: %s", expanded_file, str(e))