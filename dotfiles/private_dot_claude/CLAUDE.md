# Global notes

Applies on every machine. Deployed by chezmoi from `dotfiles/dot_claude/CLAUDE.md`
in the arch-config repo -- edit it there, not in `~/.claude/`.

## git: do not run commit, pull, push or fetch

Commits are signed with a FIDO2 key resident on a YubiKey, and the git remotes
authenticate with that same key. Every signature and every network call needs a
physical touch on the key, which cannot be prompted for from a non-interactive
shell. It fails with `agent refused operation` or `Permission denied (publickey)`.

Do everything up to the point of signing, then hand me a command to paste:

- Stage the files and write the commit message to a file, then give me
  `git -C <repo> commit -F <message-file>`.
- For network operations, give me
  `git -C <repo> pull --rebase && git -C <repo> push`.

Never suggest `ssh-add`. The agent is meant to stay empty: ssh reading the key
file directly can prompt for the touch on my terminal, but once the key is loaded
into the agent, ssh delegates signing to it, the agent cannot prompt, and it
refuses -- which breaks git in my terminal too, not just in yours.

Also note that `origin/*` refs may be stale, since you cannot fetch. Check the
branch state with me before concluding anything is ahead or behind.
