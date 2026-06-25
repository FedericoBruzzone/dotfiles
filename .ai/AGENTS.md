# Claude Code Agent Guidelines

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

## Communication Style

- **No unicode symbols**: avoid arrows (→, ←, =>, etc), emoji, checkmarks (✓), or decorative symbols unless explicitly requested
- **Terse by default**: one-sentence updates at key moments, no unnecessary narration
- **No trailing summaries**: user can read the diff
- **Complete sentences**: pick up cold, no jargon or unexplained shorthand from prior conversation

## Execution Approach

- **Ask before risky actions**: destructive operations, force-pushes, large refactors, API calls that affect shared state
- **Trust framework guarantees**: don't add error handling for things that can't happen
- **Verify before recommending**: if suggesting a file/function, check it exists first
- **Use dedicated tools**: prefer Read/Edit/Write over Bash for file operations

## Code Quality

- **No premature abstractions**: three similar lines is better than an abstraction for hypothetical future use
- **Minimal comments**: only add when WHY is non-obvious, not to explain WHAT
- **Prefer completeness**: finish implementation in one turn rather than leaving TODO stubs
- **No backwards-compat hacks**: if something is unused, delete it completely

## Testing & Verification

- **UI changes require manual testing**: start dev server and test golden path + edge cases in browser before marking complete
- **Trust type checkers**: type checking and tests verify correctness, not feature correctness
- **No "wait and see"**: verify changes work before marking complete
