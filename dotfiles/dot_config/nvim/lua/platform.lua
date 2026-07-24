-- Tiny platform probe. On Arch the LSP servers come from pacman/uv (already on
-- PATH), so Mason is skipped. On other systems (Windows, Debian at work) there is
-- no /etc/arch-release, so Mason is used to install the servers instead.
return {
    is_arch = vim.uv.fs_stat("/etc/arch-release") ~= nil,
}
