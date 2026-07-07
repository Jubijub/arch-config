import pytest
import os
import tempfile
from unittest.mock import patch, MagicMock
from ..command import run, set_sudo_password

class TestCommandExecution:
    
    def test_run_simple_command(self):
        """Test running a simple safe command"""
        result = run("echo 'test'", as_root=False)
        
        assert result.returncode == 0
        assert "test" in result.stdout
    
    def test_run_command_with_output(self):
        """Test command that produces output"""
        result = run("ls /tmp", as_root=False)
        
        assert result.returncode == 0
        assert isinstance(result.stdout, str)
    
    def test_run_failing_command(self):
        """Test command that fails"""
        result = run("false", as_root=False)  # 'false' command always returns 1
        
        assert result.returncode == 1
    
    def test_run_with_file_operations(self):
        """Test command that creates a file in /tmp"""
        test_file = "/tmp/test_arch_config_command"
        
        # Clean up if exists
        if os.path.exists(test_file):
            os.remove(test_file)
        
        result = run(f"touch {test_file}", as_root=False)
        
        assert result.returncode == 0
        assert os.path.exists(test_file)
        
        # Clean up
        os.remove(test_file)
    
    @patch('os.geteuid')
    def test_run_as_root_when_not_root(self, mock_geteuid):
        """Test that sudo is invoked when as_root=True and not already root"""
        mock_geteuid.return_value = 1000  # Not root
        set_sudo_password('testpassword')

        result = run("echo test", as_root=True)

        # sudo was attempted — failure is expected with a wrong test password,
        # but we must not have hit the "password not set" early exit
        assert result.stderr != 'Sudo password not set'

        set_sudo_password('')
    
    @patch('os.geteuid')
    def test_run_as_root_when_already_root(self, mock_geteuid):
        """Test that sudo is not prepended when already root"""
        mock_geteuid.return_value = 0  # Already root
        
        with patch('subprocess.run') as mock_subprocess:
            mock_subprocess.return_value = MagicMock(returncode=0, stdout="", stderr="")
            
            run("echo test", as_root=True)
            
            # Check that sudo was not prepended
            call_args = mock_subprocess.call_args[0][0]
            assert not call_args.startswith("sudo ")