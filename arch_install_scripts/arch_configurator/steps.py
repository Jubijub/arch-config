import os
from dataclasses import dataclass

from .files import download, github_tree_to_raw
from .pacman import install
from .result import StepResult

DOTFILES_BASE_URL = "https://github.com/Jubijub/arch-config/tree/master/dotfiles"
_RAW_BASE_URL = github_tree_to_raw(DOTFILES_BASE_URL)


@dataclass
class InstallStep:
    package: str
    name: str | None = None

    def step_type(self) -> str:
        return "Install"

    def display_name(self) -> str:
        return self.name or self.package

    def row_key(self) -> str:
        return self.package

    def execute(self) -> StepResult:
        return install(self.package)


@dataclass
class DotfileStep:
    repo_path: str
    name: str | None = None

    def step_type(self) -> str:
        return "Dotfile"

    def display_name(self) -> str:
        return self.name or os.path.basename(self.repo_path)

    def row_key(self) -> str:
        return self.repo_path

    def execute(self) -> StepResult:
        local_dir = os.path.dirname("/" + self.repo_path)
        raw_url = f"{_RAW_BASE_URL}/{self.repo_path}"
        return download(raw_url, local_dir)


@dataclass
class ManualStep:
    title: str
    instruction: str  # markdown content

    def display_name(self) -> str:
        return self.title

    def to_markdown(self) -> str:
        return f"## {self.title}\n\n{self.instruction}\n"


Step = InstallStep | DotfileStep | ManualStep
