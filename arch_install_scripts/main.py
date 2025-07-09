import logging

from textual.app import App, ComposeResult
from textual.widgets import Footer, Header, SelectionList
from textual.widgets.selection_list import Selection
from arch_configurator.pacman import is_installed, install, make_directory, download, ensure_base_tools

logger = logging.getLogger(__name__)

class ArchConfiguration(App[None]):

    def compose(self) -> ComposeResult:
        yield Header()
        yield SelectionList[int](
            Selection("Option 1", 0, True),
            Selection("Option 2", 1, True),
            Selection("Option 3", 2),
        )
        yield Footer()
    
    def on_mount(self) -> None:
        self.query_one(SelectionList).border_title = "What do you want to configure ?"



if __name__ == "__main__":
    # print(is_installed("TROLOLOKL"))
    ensure_base_tools()
    install("eza")
    install("bat")
    install("fd")
    install("fzf")
    install("ripgrep")
    install("btop")
    download("https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme", "$(bat --config-dir)/themes")
