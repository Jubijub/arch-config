import pytest
import os
import tempfile
from unittest.mock import patch, MagicMock
from ..pacman import is_installed, install, clone, init

class TestPackageManagement:
    
    @patch('subprocess.run')
    def test_is_installed_single_package_found(self, mock_run):
        """Test checking if a single package is installed - found"""
        mock_run.return_value = MagicMock(stdout="local/wget 1.21.3-1", returncode=0)
        assert is_installed("wget") == True
    
    @patch('subprocess.run')
    def test_is_installed_single_package_not_found(self, mock_run):
        """Test checking if a single package is installed - not found"""
        mock_run.return_value = MagicMock(stdout="", returncode=0)
        assert is_installed("nonexistent") == False
    
    @patch('subprocess.run')
    def test_is_installed_multiple_packages_all_found(self, mock_run):
        """Test checking multiple packages - all found"""
        mock_run.side_effect = [
            MagicMock(stdout="local/wget 1.21.3-1", returncode=0),
            MagicMock(stdout="local/curl 7.88.1-1", returncode=0)
        ]
        assert is_installed("wget curl") == True
    
    @patch('subprocess.run')
    def test_is_installed_multiple_packages_one_missing(self, mock_run):
        """Test checking multiple packages - one missing"""
        mock_run.side_effect = [
            MagicMock(stdout="local/wget 1.21.3-1", returncode=0),
            MagicMock(stdout="", returncode=0)
        ]
        assert is_installed("wget nonexistent") == False
    
    @patch('arch_configurator.pacman.run')
    @patch('arch_configurator.pacman.is_installed')
    def test_install_new_package(self, mock_is_installed, mock_run):
        """Test installing a new package"""
        mock_is_installed.return_value = False
        mock_run.return_value = MagicMock(returncode=0)
        
        install("test-package")
        
        mock_run.assert_called_once_with("pacman -S test-package --noconfirm", as_root=True)
    
    @patch('arch_configurator.pacman.run')
    @patch('arch_configurator.pacman.is_installed')
    def test_install_already_installed_package(self, mock_is_installed, mock_run):
        """Test installing an already installed package"""
        mock_is_installed.return_value = True
        
        install("test-package")
        
        mock_run.assert_not_called()
    
    @patch('arch_configurator.pacman.run')
    @patch('arch_configurator.pacman.is_installed')
    def test_install_multiple_packages(self, mock_is_installed, mock_run):
        """Test installing multiple packages"""
        # First package not installed, second is installed
        mock_is_installed.side_effect = [False, True]
        mock_run.return_value = MagicMock(returncode=0)
        
        install("package1 package2")
        
        mock_run.assert_called_once_with("pacman -S package1 --noconfirm", as_root=True)
    
    @patch('arch_configurator.pacman.run')
    @patch('arch_configurator.pacman.make_directory')
    @patch('arch_configurator.pacman.cd')
    def test_clone_repository(self, mock_cd, mock_mkdir, mock_run):
        """Test cloning a git repository"""
        mock_run.return_value = MagicMock(returncode=0)
        
        clone("https://github.com/test/repo.git", "~/test-downloads")
        
        mock_mkdir.assert_called_once()
        mock_cd.assert_called_once()
        mock_run.assert_called_once_with("git clone https://github.com/test/repo.git", as_root=False)
    
    def test_is_installed_real_packages(self):
        """Test checking if basic system packages are installed"""
        # These packages should always be present on any Arch system
        assert is_installed("filesystem") == True
        assert is_installed("glibc") == True
        assert is_installed("bash") == True
        
        # Test with a package that definitely doesn't exist
        assert is_installed("nonexistent-package-12345") == False