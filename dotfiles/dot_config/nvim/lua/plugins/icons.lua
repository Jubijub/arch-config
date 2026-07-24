-- mini.icons replaces nvim-web-devicons. The mock makes plugins that still ask
-- for `nvim-web-devicons` (lualine, telescope) transparently use mini.icons.
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
