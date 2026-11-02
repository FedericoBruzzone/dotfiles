# Clang review rules

Applies to `clang/`. Clang follows the LLVM coding standards, so also apply `references/llvm.md` for anything not listed here.

## Code style (Clang hacking guide)
- Follow the LLVM coding standards and match the surrounding Clang code.
- `cstdio` is forbidden. Use `llvm::errs()` for debugging. Library code supports `raw_ostream` interfaces.
- Layering: the Parser polls tokens and calls Sema through opaque types (`ExprResult`, `StmtResult`). Sema builds and inspects the AST. The AST is immutable after construction, apart from redeclaration links, lookup tables, and template instantiation updates. Avoid adding setters.
- AST nodes stay faithful to the source. Do not desugar when you can wrap.
- Use type helper methods (`isPointerType()`) instead of `isa<PointerType>()` when typedefs should be ignored. Semantic checks use canonical types.
- AST error recovery: apply a fix-it only when confident, otherwise mark the node invalid. Avoid dropping nodes.

## Diagnostics (Internals Manual)
- Message wording: starts lowercase, no trailing period (a trailing `?` is fine). Proper nouns and acronyms keep their case (Clang, C++17, GCC).
- Single quotes around syntactic constructs and flags. No contractions. Prefer a semicolon to a second sentence.
- Say what is wrong, not what the code does. Avoid standards jargon that new users do not know.
- Use `%select{a|b}N` and `%s0` or `%plural` for variants and plurals. Never pass English strings as arguments, since that blocks localization.
- IDs are prefixed `err_`, `warn_`, `ext_`, `note_` where sensible. Pick severity deliberately: `ExtWarn` for extensions that are likely wrong or surprising, `Extension` otherwise.
- Entries go in the right `clang/Basic/Diagnostic*Kinds.td`. A `NOTE` attaches to a previous diagnostic and cannot be remapped.
- Fix-it hints: on errors and warnings only when very likely correct and recoverable. A warning fix-it must not change meaning. Uncertain fixes go on a note.

## TableGen (Clang `.td`)
- Diagnostics: see above.
- Command-line options live in `Options.td`. Prefer marshalling annotations (`MarshallingInfoFlag`, `MarshallingInfoString`, and so on) over hand-written parse and generate code in `CompilerInvocation`. Declare the matching member in the options header.
- Attributes in `Attr.td`: read the "How to add an attribute" section of the Internals Manual and check that the new attribute follows it. This file does not restate those rules.

## Tests (Clang hacking guide, Internals Manual)
- Tests live in `clang/test/`, organized by area (`Sema`, `SemaCXX`, `CodeGen`, and so on). The hacking guide names only a few of these directories and gives no rule for choosing between them, for unit versus lit tests, or for extending versus adding files. Follow the neighboring tests and the SKILL.md test placement section.
- Compiler options sit in `RUN:` lines at the top of the file.
- Diagnostics are tested with `-verify` and `// expected-error{{...}}`, `expected-warning`, `expected-note`.
- CodeGen tests use FileCheck. Use `update_cc_test_checks.py` where the directory already does.
- Changes touching libc++ interactions may need regexes that work across versions.
- Run with `llvm-lit clang/test/Sema/<file>` or `ninja check-clang`.

## Sources
- Hacking on Clang: https://clang.llvm.org/hacking.html
- Internals Manual: https://clang.llvm.org/docs/InternalsManual.html
- Clang doxygen: https://clang.llvm.org/doxygen
