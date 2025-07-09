import pytest
from unittest.mock import patch, MagicMock
import subprocess
from ..network import verify_connectivity

class TestNetworkManagement:
    
    def test_verify_connectivity_google_ipv4(self):
        """Test actual IPv4 connectivity to Google"""
        result = verify_connectivity("www.google.com", ipv6=False)
        assert result == True
    
    def test_verify_connectivity_google_ipv6(self):
        """Test actual IPv6 connectivity to Google"""
        result = verify_connectivity("www.google.com", ipv6=True)
        assert result == True
    
    @patch('subprocess.run')
    def test_verify_connectivity_failure(self, mock_run):
        """Test failed connectivity check with invalid host"""
        mock_run.return_value = MagicMock(returncode=1, stderr="Name or service not known")
        
        result = verify_connectivity("invalid.invalid.invalid")
        
        assert result == False
    
    @patch('subprocess.run')
    def test_verify_connectivity_timeout(self, mock_run):
        """Test connectivity check timeout"""
        mock_run.side_effect = subprocess.TimeoutExpired("ping", 30)
        
        result = verify_connectivity("www.google.com")
        
        assert result == False
    
    @patch('subprocess.run')
    def test_verify_connectivity_exception(self, mock_run):
        """Test connectivity check with unexpected exception"""
        mock_run.side_effect = Exception("Unexpected error")
        
        result = verify_connectivity("www.google.com")
        
        assert result == False