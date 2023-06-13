local highlights = {
  IlluminatedWord = { bg = "#6e738d" },
  IlluminatedCurWord = { bg = "#6e738d" },
  IlluminatedWordText = { bg = "#6e738d" },
  IlluminatedWordRead = { bg = "#6e738d" },
  IlluminatedWordWrite = { bg = "#6e738d" },
}

for group, value in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, value)
end
