---
name: commit-message
description: Writes Git commit messages. Use when you commit code, when you change a commit message during a rebase, or when the user asks for a commit message for the staged files.
allowed-tools: Read, Grep, Glob, Bash
---

Write one commit message for the staged changes (`git diff --staged`).

## Which format to use

The repository format has priority. Use the user format below only for the parts that the repository does not set.

The repository sets a format when one of these is true:

- A written rule exists, for example in `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, or a commitlint config.
- The recent history shows one clear format: `git log --no-merges --format=%s -20`.

If the repository sets only some parts, use the repository rule for those parts and the user format for the other parts. Example: the repository asks for unicode emoji and says nothing about the body.

## User format

```
<gitmoji shortcode> (<scope>): <subject>
```

- Type: a [gitmoji](https://gitmoji.dev/), written as its shortcode, for example `:bug:`. Do not write the unicode character.
- Scope: always include it, in parentheses.
- Subject: lowercase and imperative.
- Body: only when the subject cannot give the reason for the change.

```
:arrow_up: (Deno): update dependencies
```

```
:lipstick: (Button): add secondary button style
```

```
:bug: (NavBar): fix animation on moving between pages

There was a weird behavior where the navigation bar would grow and shrink
rapidly while it was figuring out the scroll location and length.
```

## Output

Write one message. Do not give options. When the user asks for a message, print only the message. When you commit, use the message directly.
