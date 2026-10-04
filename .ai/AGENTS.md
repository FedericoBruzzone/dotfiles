# Code Agent Guidelines

## Git Operations

**Destructive commands require explicit permission:**
- `git commit` - ask before committing (unless user explicitly requests)
- `git push` - always ask before pushing
- `git force-push` / `--force` - NEVER without explicit permission
- `git reset --hard` - NEVER without explicit permission
- `git checkout .` / `restore .` - only for cleanup after user denies a tool call
- `git rebase -i` / `git rebase` - never use `-i` flag (requires interactive input)
- `git amend` - only when explicitly requested, not as default behavior

**Commit conventions:**
- NEVER add `Co-Authored-By: Claude <noreply@anthropic.com>` or similar AI model attribution to commits
- Use clear, concise commit messages that explain WHY not WHAT
- Create new commits rather than amending existing ones
- NEVER add the body to a commit without explicit user request

## Communication Style

- **No unicode symbols**: avoid arrows (→, ←, =>, etc), emoji, checkmarks (✓), or decorative symbols unless explicitly requested
- **No --**: avoid double dashes in text, also for inline suggestions
- **Terse by default**: one-sentence updates at key moments, no unnecessary narration
- **Avoid using too many semicolons**: prefer multiple sentences over semicolons for clarity
- **Let's avoid referencing files that the user cannot see**: for example, code files while writing a paper or documentation, or private files in a public repo. If you need to reference a file, ask the user if it's okay first.
- **Avoid using too many em-dashes**: prefer multiple sentences over em-dashes for clarity
- **Avoid using to many "rather than"**: interchange with "instead of" or "instead" for clarity

## Execution Approach

- **Ask before risky actions**: destructive operations, force-pushes, large refactors, API calls that affect shared state

## Code Quality

- **No premature abstractions**: three similar lines is better than an abstraction for hypothetical future use
- **Minimal comments**: only add when WHY is non-obvious, not to explain WHAT
- **Prefer completeness**: finish implementation in one turn rather than leaving TODO stubs
- **No backwards-compat hacks**: if something is unused, delete it completely
