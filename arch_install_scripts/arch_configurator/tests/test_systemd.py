import pytest
from unittest.mock import patch, MagicMock
from ..systemd import enable_service, enable_and_start_service

class TestSystemdManagement:
    """
    Note: These tests focus on command construction and error handling
    rather than actual systemd operations which would require root access
    """
    
    @patch('arch_configurator.systemd.run')
    def test_enable_service_command_construction(self, mock_run):
        """Test that enable_service constructs the correct command"""
        mock_run.return_value = MagicMock(returncode=0)
        
        enable_service("test-service", as_root=True)
        
        mock_run.assert_called_once_with("systemctl enable test-service", as_root=True)
    
    @patch('arch_configurator.systemd.run')
    def test_enable_service_user_mode(self, mock_run):
        """Test that user mode passes as_root=False correctly"""
        mock_run.return_value = MagicMock(returncode=0)
        
        enable_service("user-service", as_root=False)
        
        mock_run.assert_called_once_with("systemctl enable user-service", as_root=False)
    
    @patch('arch_configurator.systemd.run')
    def test_enable_and_start_service_calls_both_operations(self, mock_run):
        """Test that enable_and_start_service makes both enable and start calls"""
        mock_run.return_value = MagicMock(returncode=0)
        
        enable_and_start_service("test-service")
        
        assert mock_run.call_count == 2
        calls = [call[0][0] for call in mock_run.call_args_list]
        assert "systemctl enable test-service" in calls
        assert "systemctl start test-service" in calls