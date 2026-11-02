# LLVM core review rules

Applies to `llvm/` and is the fallback for every other subproject. Rules below come from the pages listed under Sources.

## Code style
- Types start uppercase (`TextFileReader`). Functions are verb phrases in camelCase starting lowercase (`openFile`). Variables are nouns in camelCase starting uppercase (`Leader`). Enumerators carry the enum prefix (`VK_Argument`). Follow the local file when it predates this rule.
- `auto` only when it improves readability. Avoid "almost always auto". Use `auto &` and `auto *` in range loops to avoid copies.
- Early returns and `continue` to cut nesting.
- No braces on simple single-statement bodies, but use them when the if/else chain is otherwise braced or the body has comments.
- File-local functions and variables are `static`. Anonymous namespaces only for class declarations, kept small.
- Include order: main module header (`.cpp` only), local headers, LLVM project headers, system headers. Sorted within each group.
- Include as little as possible: forward declare in headers, headers are self-contained.
- Comments: `///` for Doxygen, `//` for the rest. First sentence is the abstract. Reference parameters with `\p`. Do not duplicate docs between header and implementation. Comments explain why.
- Prefer LLVM support types: `DenseMap` over `std::map`, `SmallVector` over `std::vector`, `raw_ostream` over iostream.
- Forbidden: `#include <iostream>`, `using namespace std`, static constructors, `dynamic_cast`, exceptions, RTTI. Use `isa/cast/dyn_cast`.
- `assert` carries a message. `llvm_unreachable` instead of `assert(0)`. Assert-only variables are `[[maybe_unused]]`.
- Namespace closers are commented (`} // namespace llvm`), except an obvious outermost one in a header.
- 80 columns. Docs use one sentence per line.

## TableGen (`.td` in llvm/)
- Use `true` and `false` for booleans only, not as 1 and 0.
- Prefer `multiclass` and `defm` over parallel hand-written classes. Prefer top-level `let` over repeating field assignments. Remember that top-level `let` does not override fields set in the class or record itself.
- Do not introduce the deprecated `field` keyword.
- Use `assert` in `.td` to enforce record invariants instead of checking in every backend.
- The language reference gives little style guidance. Follow neighboring files for layout and naming.

## Tests
- Every bug fix and every new feature has a test. A bug fix test fails without the fix.
- Tests have `RUN:` lines and use FileCheck on the tool output. Grep in `RUN` lines is deprecated.
- Minimal inputs: reduce with `llvm-reduce`, drop needless metadata and attributes, avoid unnamed values (`%0`), use meaningful names, omit target triple and datalayout when possible.
- Run only the passes under test (`opt -S -passes=instcombine`), not `-O3`, outside PhaseOrdering tests.
- Use `opt ... < %s` so the `ModuleID` does not depend on the path. Avoid platform-specific content unless that is the point.
- Autogenerate checks with `update_test_checks.py`, `update_llc_test_checks.py`, or `update_cc_test_checks.py`. Hand-written checks need `NOTE: Do not autogenerate`.
- `CHECK-DAG` only where order really is free.
- Put new tests in existing files when they fit. The guide says to put related tests into a single file and to prefer adding cases to an existing file over creating a new one.
- Target-specific tests go in the target directory (for example `test/CodeGen/ARM`). Tests that need a backend use a `lit.local.cfg` that skips unsupported targets, instead of `REQUIRES:` lines in each file.
- Large extra inputs go in `Inputs/`. Small extra files use `split-file`.
- Test type: unit tests are for the support library and generic data structures. Regression tests are for transformations and analyses on the IR. `test-suite` holds whole programs for benchmarking and end-to-end checks. Analyses are tested through a printer pass and FileCheck.
- Scope: outside PhaseOrdering tests, run a minimal set of passes. Avoid end-to-end clang pipelines unless integration is what is tested.
- Baselines: commit the test with baseline check lines first. NFC baseline patches may be pushed without pre-commit review.
- Comment what the test covers and reference the issue. Avoid UB, `undef`, and `poison` unless tested on purpose.
- Prefer a baseline NFC commit with the current output, then the functional change showing the diff in checks.
- `REQUIRES` needs all conditions true, `UNSUPPORTED` disables on any. Use `XFAIL` for expected failures.

## Sources
- Coding standards: https://llvm.org/docs/CodingStandards.html
- Testing guide: https://llvm.org/docs/TestingGuide.html
- TableGen language reference: https://llvm.org/docs/TableGen/ProgRef.html
- TableGen backends: https://llvm.org/docs/TableGen/BackEnds.html
- Developer policy: https://llvm.org/docs/DeveloperPolicy.html
