from enum import Enum, auto


class StepResult(Enum):
    SUCCESS = auto()
    NO_CHANGE = auto()
    ERROR = auto()
