#!/usr/bin/env python3
"""Copy the last command and its output to the clipboard.

Kitty has a built-in action for copying only the output
(``copy_last_command_output``), but nothing for copying the command *and*
its output together, so this small custom kitten does exactly that.

It works by reading kitty's shell-integration state for the window the
shortcut was pressed in:

* ``last_cmd_cmdline``  -> the command that was just run in this window
* ``cmd_output(...)``   -> the text that command produced

Requires kitty shell integration, which is enabled by default and
auto-injected into fish/bash/zsh when they run inside kitty.

Wire it up in ``kitty.conf``:

    map ctrl+shift+y kitten copy_cmd_output.py

Optional per-binding arguments (space separated):

    --prompt <ch>   prefix the command with a prompt character, e.g. --prompt $
    --no-cmd        only copy the output, not the command line
"""

from typing import List

from kitty.boss import Boss


def main(args: List[str]) -> None:
    # No terminal UI needed -- all the work happens in handle_result(),
    # which runs inside the kitty process with full access to windows.
    pass


from kittens.tui.handler import result_handler  # noqa: E402


@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    from kitty.clipboard import set_clipboard_string
    from kitty.window import CommandOutput

    prompt_char = ''
    if '--prompt' in args:
        i = args.index('--prompt')
        if i + 1 < len(args):
            prompt_char = args[i + 1]
    include_cmd = '--no-cmd' not in args

    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return

    # The command that was last run in *this* window (set by shell integration).
    cmdline = getattr(w, 'last_cmd_cmdline', '') or ''

    # Use CommandOutput.last_run (not last_non_empty) so the output always
    # matches cmdline above, even when the last command produced no output.
    output = w.cmd_output(CommandOutput.last_run, as_ansi=False, add_wrap_markers=False)

    parts: List[str] = []
    if include_cmd and cmdline:
        parts.append(f'{prompt_char} {cmdline}' if prompt_char else cmdline)
    if output:
        parts.append(output.rstrip('\n'))

    text = '\n'.join(parts)
    if text:
        set_clipboard_string(text)
