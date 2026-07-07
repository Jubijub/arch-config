import logging
from typing import Any

from textual.app import App, ComposeResult
from textual.containers import Container
from textual.screen import Screen
from textual.widgets import (
    Button,
    DataTable,
    Footer,
    Header,
    Input,
    Label,
    MarkdownViewer,
    ProgressBar,
    TextArea,
)
from textual import work

from .command import set_sudo_password
from .result import StepResult
from .steps import ManualStep


class LogHandler(logging.Handler):
    def __init__(self, app: "InstallerApp", log_widget: TextArea):
        super().__init__()
        self._app = app
        self._log_widget = log_widget

    def emit(self, record: logging.LogRecord) -> None:
        msg = self.format(record)
        self._app.call_from_thread(self._append, msg)

    def _append(self, msg: str) -> None:
        end = self._log_widget.document.end
        self._log_widget.insert(msg + "\n", location=end)


class PasswordScreen(Screen[str]):
    CSS = """
    PasswordScreen { align: center middle; }
    #password-container {
        width: 60;
        height: auto;
        border: solid $accent;
        padding: 2 4;
    }
    #password-container Label { width: 100%; text-align: center; margin-bottom: 1; }
    #password-container Input { margin-bottom: 1; }
    #start { width: 100%; }
    """

    BINDINGS = [("q", "quit", "Quit")]

    def compose(self) -> ComposeResult:
        with Container(id="password-container"):
            yield Label("Arch Linux Configurator")
            yield Label("Enter root password to begin installation:")
            yield Input(id="password", placeholder="Root password...", password=True)
            yield Button("Start Installation", id="start", variant="primary")
        yield Footer()

    def on_button_pressed(self) -> None:
        self._submit()

    def on_input_submitted(self) -> None:
        self._submit()

    def _submit(self) -> None:
        password = self.query_one("#password", Input).value
        self.dismiss(password)


class InstallerApp(App):
    CSS = """
    DataTable { height: auto; margin: 1 2; }
    #manual-steps { height: auto; max-height: 35%; margin: 0 2; border: solid $accent; }
    TextArea { height: 1fr; margin: 0 2; border: solid $primary; }
    ProgressBar { margin: 1 2; }
    """

    BINDINGS = [("q", "quit", "Quit")]

    def __init__(self, steps: list[Any]):
        super().__init__()
        self._steps = steps
        self._executable_steps = [s for s in steps if hasattr(s, "execute")]
        manual_steps = [s for s in steps if isinstance(s, ManualStep)]
        if manual_steps:
            self._manual_markdown = (
                "# Manual Steps Required After Installation\n\n"
                + "\n".join(s.to_markdown() for s in manual_steps)
            )
        else:
            self._manual_markdown = ""

    def compose(self) -> ComposeResult:
        yield Header()
        yield DataTable()
        if self._manual_markdown:
            yield MarkdownViewer(
                self._manual_markdown,
                show_table_of_contents=False,
                id="manual-steps",
            )
        yield TextArea(read_only=True)
        yield ProgressBar(total=len(self._executable_steps), show_eta=False)
        yield Footer()

    def on_mount(self) -> None:
        table = self.query_one(DataTable)
        table.add_column("Type", key="type")
        table.add_column("Step", key="step")
        table.add_column("Status", key="status")

        for step in self._executable_steps:
            table.add_row(
                step.step_type(), step.display_name(), "[yellow]Pending[/yellow]", key=step.row_key()
            )

        log = self.query_one(TextArea)
        logging.getLogger().addHandler(LogHandler(self, log))

        self.push_screen(PasswordScreen(), callback=self._on_password_entered)

    def _on_password_entered(self, password: str | None) -> None:
        set_sudo_password(password or "")
        self.run_steps()

    @work(thread=True)
    def run_steps(self) -> None:
        table = self.query_one(DataTable)
        progress = self.query_one(ProgressBar)
        for step in self._steps:
            if not hasattr(step, "execute"):
                continue

            self.call_from_thread(
                table.update_cell, step.row_key(), "status", "[cyan]Running...[/cyan]"
            )
            result = step.execute()

            if result == StepResult.SUCCESS:
                status = "[green]✓ Done[/green]"
            elif result == StepResult.NO_CHANGE:
                status = "[blue]Already done[/blue]"
            else:
                status = "[red]✗ Failed[/red]"

            self.call_from_thread(table.update_cell, step.row_key(), "status", status)
            self.call_from_thread(progress.advance, 1)
