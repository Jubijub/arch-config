# Global notes

Applies on every machine. Deployed by chezmoi from `dotfiles/private_dot_claude/CLAUDE.md`
in the arch-config repo -- edit it there, not in `~/.claude/`.

## git: commits and remotes need a hardware key

Commits are signed with a FIDO2 key resident on a YubiKey, and the git remotes
authenticate with the same key. Every signature and every network call needs a
PIN and a physical touch on the key.

This *does* work from a non-interactive shell, as long as `SSH_ASKPASS` points at
`~/.local/bin/ssh-askpass` and `SSH_ASKPASS_REQUIRE=force` is set. ssh then asks
for the PIN in a graphical dialog rather than on a terminal it does not have.
Both are set for Claude Code sessions in `~/.claude/settings.json`, and the
helper is deployed by chezmoi. The touch is still required and still physical,
so nothing is signed or pushed without a deliberate tap on the key.

If a git command fails with `agent refused operation` or
`Permission denied (publickey)`, that environment is missing or the helper is not
deployed. Run `chezmoi apply`, check `~/.claude/settings.json`, and in the
meantime fall back to preparing the work and handing over a command to paste:

    git -C <repo> commit -F <message-file>
    git -C <repo> pull --rebase && git -C <repo> push

Never suggest `ssh-add`. The agent is meant to stay empty. ssh reading the key
file directly can prompt through the askpass helper, but once the key is loaded
into the agent ssh delegates signing to it, the agent has no way to prompt, and
it refuses -- which breaks git in the user's own terminal too, not just here.

Note also that `origin/*` refs may be stale if no fetch has run this session.
Check the branch state rather than assuming anything is ahead or behind.
