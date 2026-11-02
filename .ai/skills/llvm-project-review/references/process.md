# Contribution process (all subprojects)

## Commits and PRs
- A PR starts as one self-contained commit. GitHub uses the first line, truncated to 72 characters, as the PR title. The PR title and description become the squashed commit message, so check them as commit text.
- Commit message: title, blank line, body. Title is short and starts with a subsystem tag in brackets (for example `[SCEV]`, `[mlir][arith]`, `[clang][Sema]`). Body explains the why and context. Related commits are cited by hash.
- Link issues with `Fixes #N`.
- Do not tag usernames in commit messages, since cherry-picks spam them. Use `Co-authored-by:` for multiple authors.
- No "contributed by" notes in source files. Authorship lives in version control.
- One purpose per change. Separate formatting and whitespace changes from functional ones. Label NFC changes clearly.
- Large work is split into stacked PRs, either `users/<username>/` branches or separate PRs with explicit "Depends on" notes. Each merges as one squashed commit.
- Base on a recent `main`.

## Direction and policy (Developer Policy)
Facts to cite in the "Direction and design" part of a review.
- Major changes to how LLVM works or major new extensions: the policy recommends building consensus with the community before investing significant effort. Suggest an RFC on Discourse when a PR looks major and shows no sign of discussion.
- New targets need an RFC and community approval before patches. A target needs at least one maintainer and an active community. Experimental targets are not built by default. An official target must have been stable in tree for at least three months.
- New monorepo projects go through the RFC process and need community approval. They must follow the whole policy, including license, coding standards, and code of conduct. Incubator projects live in separate repositories.
- Large work is developed incrementally in tree, not in long-lived branches. It is split into small, independently reviewable patches, with consensus on the end goal first. Each patch is either standalone or part of a planned series.
- Newly enabled passes need a maintainer, evidence of real-world benefit, compile-time mitigation, and correctness validation.
- Compatibility: textual IR is not backwards compatible. Bitcode from LLVM 3.0 onward must stay loadable. The C API is best effort. IR changes must be reflected in `test/Bitcode/compatibility.ll`.
- Removing a feature or making a potentially breaking change needs a "Potentially Breaking Changes" release note and a Discourse announcement with the `potentially-breaking` label.
- Maintainers and code owners review and mediate disagreements. When a disagreement is unresolved, a lead maintainer is the escalation point.

## Quality and docs
- New code follows the coding standards, builds cleanly on at least one platform, and passes premerge checks.
- Tests are required for fixed bugs and new features. See the project reference for conventions.
- User-facing changes (command-line, diagnostics, bug fixes, optimizations, API changes) go in the release notes. Breaking changes get a "Potentially Breaking Changes" entry with examples.
- Do not rely on external links as the only context. The commit message stands on its own.

## Review etiquette (for PR review mode)
- State whether each comment is required or optional ("please change" versus "consider").
- Ask for a split when a patch mixes review streams. Ask for refactors and extra tests up front to cut round trips.
- Approval wording: LGTM means ready to commit. Conditional approval and "LGTM, but please wait for @expert" are legitimate.
- Authors should answer or acknowledge every comment and re-request review after updating.
- Non-trivial patches wait at least 24 hours before merge so other time zones can look.

## Reverts
- The project prefers "revert to green" over fixing forward. A revert needs a reproducible failure and the commit message says why.

## AI-assisted contributions
- The author reads and understands everything submitted and can answer questions about it. The PR description is written by the author.
- Substantial tool-generated content is labeled, for example with an `Assisted-by:` trailer in the commit message or PR description.
- Autonomous agents acting in project spaces are not allowed, and review tools must not post without human verification.

## Sources
- Developer policy: https://llvm.org/docs/DeveloperPolicy.html
- GitHub workflow: https://llvm.org/docs/GitHub.html
- Code review policy: https://llvm.org/docs/CodeReview.html
- AI tool use policy: https://llvm.org/docs/AIToolPolicy.html
- Contributing overview: https://llvm.org/docs/Contributing.html
