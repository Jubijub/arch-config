import pytest
import os
import tempfile
import shutil
from unittest.mock import patch, MagicMock
from ..files import make_directory, cd, uncomment_line, add_options, download

class TestFilesManagement:
    
    def test_make_directory_in_tmp(self):
        """Test directory creation in /tmp (safe operation)"""
        test_dir = "/tmp/test_arch_config_dir"
        
        # Clean up if exists
        if os.path.exists(test_dir):
            shutil.rmtree(test_dir)
        
        make_directory(test_dir)
        assert os.path.exists(test_dir)
        assert os.path.isdir(test_dir)
        
        # Clean up
        shutil.rmtree(test_dir)
    
    def test_make_directory_nested_in_tmp(self):
        """Test nested directory creation in /tmp"""
        test_dir = "/tmp/test_arch_config/nested/deep"
        base_dir = "/tmp/test_arch_config"
        
        # Clean up if exists
        if os.path.exists(base_dir):
            shutil.rmtree(base_dir)
        
        make_directory(test_dir)
        assert os.path.exists(test_dir)
        assert os.path.isdir(test_dir)
        
        # Clean up
        shutil.rmtree(base_dir)
    
    def test_cd_to_existing_directory(self):
        """Test changing to existing directory"""
        original_cwd = os.getcwd()
        test_dir = "/tmp/test_cd"
        
        # Clean up and create
        if os.path.exists(test_dir):
            shutil.rmtree(test_dir)
        os.makedirs(test_dir)
        
        cd(test_dir)
        assert os.getcwd() == test_dir
        
        # Clean up
        os.chdir(original_cwd)
        shutil.rmtree(test_dir)
    
    def test_cd_to_nonexistent_directory(self):
        """Test changing to non-existent directory (should create it)"""
        original_cwd = os.getcwd()
        test_dir = "/tmp/test_cd_nonexistent"
        
        # Clean up if exists
        if os.path.exists(test_dir):
            shutil.rmtree(test_dir)
        
        cd(test_dir)
        assert os.path.exists(test_dir)
        assert os.getcwd() == test_dir
        
        # Clean up
        os.chdir(original_cwd)
        shutil.rmtree(test_dir)
    
    def test_uncomment_line(self):
        """Test uncommenting lines in a file"""
        with tempfile.NamedTemporaryFile(mode='w+', delete=False) as tf:
            tf.write("# This is a comment\n")
            tf.write("#Color\n")
            tf.write("Normal line\n")
            tf.write("  #  Indented comment\n")
            temp_file = tf.name
        
        try:
            uncomment_line(temp_file, "Color")
            
            with open(temp_file, 'r') as f:
                content = f.read()
            
            lines = content.split('\n')
            assert "Color" in lines[1]  # Should be uncommented
            assert not lines[1].startswith('#')
            assert lines[0].startswith('#')  # Other comments should remain
            
        finally:
            os.unlink(temp_file)
    
    def test_add_options_empty_parentheses(self):
        """Test adding options to empty parentheses"""
        with tempfile.NamedTemporaryFile(mode='w+', delete=False) as tf:
            tf.write("MODULES=()\n")
            tf.write("OTHER_SETTING=value\n")
            temp_file = tf.name
        
        try:
            add_options(temp_file, "MODULES", "nvidia nvidia_modeset")
            
            with open(temp_file, 'r') as f:
                content = f.read()
            
            lines = content.split('\n')
            assert "MODULES=(nvidia nvidia_modeset)" in lines[0]
            
        finally:
            os.unlink(temp_file)
    
    def test_add_options_existing_content(self):
        """Test adding options to parentheses with existing content"""
        with tempfile.NamedTemporaryFile(mode='w+', delete=False) as tf:
            tf.write("MODULES=(ext4 xfs)\n")
            temp_file = tf.name
        
        try:
            add_options(temp_file, "MODULES", "nvidia")
            
            with open(temp_file, 'r') as f:
                content = f.read()
            
            lines = content.split('\n')
            assert "nvidia" in lines[0]
            assert "ext4 xfs" in lines[0]
            
        finally:
            os.unlink(temp_file)
    
    @patch('arch_configurator.files.run')
    def test_download_mock_destructive_operations(self, mock_run):
        """Test download function with mocked operations"""
        mock_run.return_value = MagicMock(returncode=0, stdout="/tmp/test")
        
        # Mock the directory creation and download
        with patch('arch_configurator.files.make_directory') as mock_mkdir:
            download("https://example.com/file.txt", "/tmp/test", "renamed.txt")
            
            mock_mkdir.assert_called_once()
            # Check that wget was called with correct parameters
            mock_run.assert_called()
            call_args = mock_run.call_args[0][0]  # Get the command string
            assert "wget" in call_args
            assert "-O" in call_args
            assert "renamed.txt" in call_args