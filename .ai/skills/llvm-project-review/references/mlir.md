# MLIR review rules

Applies to `mlir/`. MLIR follows the LLVM coding standards with the exceptions below, so also apply `references/llvm.md` for anything not listed here.

## Code style (Developer Guide, Style Guide section)
- Functions and variables use `camelBack`. This differs from LLVM, where variables start uppercase.
- C++ comments are `///` Doxygen style for top-level and class member definitions, public or not.
- Non-nullable output arguments are passed by non-const reference. IR units (`Region`, `Block`, `Operation`) follow their own conventions.
- Formatting is clean under the root `.clang-format` (`git clang-format origin/main`).
- Avoid recursion if some IR input can overflow the stack. Recursion is tolerated only for IR nesting (regions) and type nesting (composite types).
- Commit messages follow normal git conventions. See `references/process.md`.

## Passes (Developer Guide)
- Passes assume verifier-valid input and must produce verifier-valid output. A pass that emits invalid IR has a bug.
- No crash or assertion on verifier-valid IR. If a pass needs extra invariants, it checks them. An optimization pass should do nothing when they are absent.
- Pass names and options carry the dialect prefix (`-affine-tile` with `-affine-tile-size`).
- Use pass options, not `cl::opt`, so pipelines stay serializable.
- Declare `dependentDialects` for every dialect the pass creates ops from, by overriding `getDependentDialects()`. Dialects must be loaded before multithreaded execution.
- Pass Infrastructure doc:
  - A pass must not inspect sibling ops or their children, and must not modify the parent, ancestors, or their blocks. Other threads may be working there.
  - No mutable state kept across `runOnOperation()` calls and no global statics. Instances are copied per thread and may not run on every op. One-time setup such as compiled patterns goes in `initialize(MLIRContext *)`.
  - Passes are copy-constructible, and a pass with options still has valid default and copy constructors.
  - `Passes.td`: give the anchor op (`Pass<"arg", "ModuleOp">`) or use an op-agnostic or `InterfacePass`, add `summary` and `description`, and declare `dependentDialects`, `options`, and `statistics` there. Boilerplate comes from `gen-pass-decls` and `gen-pass-def`.
  - Call `signalPassFailure()` when a transformation fails or an invariant breaks. The pipeline then stops.
  - Reusable pipelines are registered with `PassPipelineRegistration`.

## Verifiers and diagnostics (Developer Guide, Diagnostics doc)
- Verify only local aspects of an op. Do not follow def-use chains. Do not look at operand producers or result users.
- A verifier fires only on definitively broken invariants, never on "possibly invalid" IR, because a failure aborts compilation.
- Undefined behavior is not a verifier concern when detecting it needs non-local information. Example: `tensor.dim %A, %ten` with `%ten` a constant 10 and an out-of-bounds index is UB, but the same IR can appear after `arith.addi` of two constants is folded. If that were invalid, the folder would be turning valid IR into invalid IR, which is a folder bug. The same applies to inlining and other transformations. Flag any verifier that looks through operands or results to reject such cases.
- Use `hasVerifier` for op-level checks and `hasRegionVerifier` only when nested ops must be inspected.
- Report errors through the error severity, not custom printing.
- Op errors use `op->emitOpError()`, which prefixes the op name. Other cases use `emitError`, `emitWarning`, or `emitRemark`.
- Notes are attached to a parent diagnostic with `attachNote()`, never emitted alone.
- Message text is lowercase, has no trailing period, and is short. Values and names are streamed into the diagnostic.
- Tests check messages with `expected-(error|note|remark|warning)`, using `@+1`, `@-1`, `@above`, or `@below` for position and the `-re` suffix for regex.

## Rewrite patterns (Pattern Rewriting doc)
- All IR mutation, including creation, goes through the `PatternRewriter`. Use `eraseOp`, `replaceOp`, `replaceOpWithNewOp`, or `modifyOpInPlace`. Never mutate ops directly.
- No mutation before the match is known to succeed.
- The root op must be updated in place, replaced, or erased. `matchAndRewrite` returns success if and only if the IR changed.
- Use `notifyMatchFailure` with a reason.
- Specify the root op name when possible. Use `MatchAnyOpTypeTag` explicitly for any-op patterns.
- A pattern that applies to its own output calls `setHasBoundedRewriteRecursion()`.
- Patterns map verifiable IR to verifiable IR. Temporary invalid states are acceptable only across split patterns.

## Folding and canonicalization (Canonicalization doc)
- `fold` creates no ops and no new SSA values. It replaces only the root op, returns existing values or attributes, and may mutate in place.
- Anything needing new ops is a `RewritePattern` in `getCanonicalizationPatterns`.
- Repeated application converges. Cyclic rewrites are bugs.
- Canonicalizations are cheap, keep information recoverable, avoid IR size explosion, and are never relied on for correctness.
- Expensive analyses and cost models belong in other passes.

## Dialect conversion (Dialect Conversion doc)
- The conversion target marks each op legal, dynamically legal, or illegal. Check that the mode matches the intent: partial leaves unconverted ops, full fails if any remain, analysis changes nothing.
- A `ConversionPattern` reads operands from the adaptor, never from the matched op, since adapted operands carry the converted types.
- Mutation goes only through `ConversionPatternRewriter`. Rollback mode delays replacements and erasures, so do not assume a replaced op is gone right away.
- A `TypeConverter` defines source and target materializations whenever converted types survive in the output. Both 1:1 and 1:N conversions go through `addConversion`.
- Region block signatures are converted explicitly (`convertRegionTypes` or `applySignatureConversion`). Entry block signatures usually need a custom `SignatureConversion`.
- Block replacement is not supported.

## TableGen: ODS (Defining Operations doc)
- Documentation sits at the start of the op definition. `summary` is a one-liner, capitalized, without trailing punctuation. `description` is Markdown.
- Prefer declarative `assemblyFormat` over custom parser and printer. The format covers `attr-dict`, all operands, regions, successors, types, and properties.
- Name every argument so getters are generated. Use `$stride`, not positional access.
- Properties for inline storage, attributes for context-stored values. Default-valued attributes go last in the argument list.
- Multiple variadic operands need `SameVariadicOperandSize` or `AttrSizedOperandSegments`.
- Set `hasFolder`, `hasCanonicalizer`, or `hasCanonicalizeMethod` only when the matching code exists.
- Traits and interfaces are third parameter of `Op` and must match real behavior.
- Class names drop the dialect prefix at the first underscore (`TF_AddOp` becomes `AddOp`).

## TableGen: dialects, attributes, types (Defining Dialects docs)
- The `Dialect` definition lives apart from its ops, attributes, and types, not in the same `.td` file. It has `summary` and `description`, a `cppNamespace` using full paths, and `dependentDialects` for every dialect it builds components from.
- Every dialect implements `initialize()` and registers ops, attributes, and types there with the generated includes.
- `hasConstantMaterializer` needs a real `materializeConstant` that returns `nullptr` on failure. Discardable attributes are verified with `hasOperationAttrVerify`, `hasRegionArgAttrVerify`, or `hasRegionResultAttrVerify`.
- `extraClassDeclaration` is for long-tail code and does not replace a missing infrastructure feature.
- Attributes and types: give a `mnemonic` and `summary` and `description`. Use declarative `assemblyFormat` unless `hasCustomAssemblyFormat` is truly needed.
- Parameters that hold arrays or strings use `ArrayRefParameter` or an allocating `AttrParameter` or `TypeParameter`, otherwise storage can dangle.
- Invariants on parameters use `genVerifyDecl`, and `getChecked` is the failable builder. Custom storage classes define `KeyTy`, `operator==`, `construct`, and hashing.
- Attribute `.h.inc` and `.cpp.inc` targets need explicit `mlir_tablegen` lines in CMake. Types come through `add_mlir_dialect`.

## Interfaces and traits (Interfaces and Traits docs)
- Dialect interfaces are for cross-dialect transformations (inlining, for example). Attribute, op, and type interfaces are for behavior tied to one object. Pick accordingly.
- Interface concept and model classes hold no non-static data.
- External models are registered (`attachInterface`) before the interface is queried. Apply an external model only to interfaces or types you own. `declarePromisedInterface` in dialect initialization turns a missing registration into an explicit error.
- In ODS, `defaultImplementation` lands in the trait class and `methodBody` in the model. `extraClassDeclaration` is not visible in default implementations.
- Treat each trait as a promise the verifier may not check. `Commutative` means `X op Y == Y op X`. `IsolatedFromAbove` means regions capture no outside SSA values. `ElementwiseMappable` forbids broadcasting. `Terminator` and `HasParent` affect where the op may sit. Verify the op really satisfies each one.

## Symbols (Symbols and Symbol Tables doc)
- A symbol op implements `SymbolOpInterface` (usually via `SymbolName` with `sym_name`), has a name unique within its `SymbolTable`, produces no SSA results, and implements `isDeclaration()`.
- Containers use the `SymbolTable` trait. Symbol declarations cannot be public.
- References use `SymbolRefAttr`, not SSA operands. Ops that reference symbols implement `SymbolUserOpInterface` so uses are verified.
- Rename or remove symbols with `replaceAllSymbolUses` and check `symbolKnownUseEmpty` first, instead of editing names by hand.

## Tests (MLIR Testing Guide)
- Tests live under `mlir/test/`, mirroring `mlir/include/mlir/` (`Dialect/`, `Transforms/`, `Conversion/`). Dialect tests go in the dialect's directory, for example `test/Dialect/Arith/`.
- Every commit includes a test of some form. Prefer lit tests with FileCheck over C++ unit tests (`mlir/unittests`, googletest) when possible.
- Integration tests are organized by dialect, for example `test/Integration/Dialect/Vector`.
- The guide does not set file names or say when to extend an existing file. Follow the target directory's current split of files, as the SKILL.md test placement section asks.
- Self-contained and minimal. Match only what matters, with regex and substitution blocks (`%[[VAR:.*]]`). Avoid diff-style checks.
- `-split-input-file` for independent cases in one file.
- Diagnostics: `-verify-diagnostics` with `// expected-error {{...}}` and `expected-error@+1`. Invalid IR goes in `invalid.mlir`.
- Round-trip tests for new syntax.
- Use the test dialect to exercise infrastructure without real dialect semantics.
- Integration tests (JIT with `mlir-cpu-runner`) are for pipelines that are hard to check otherwise. They need `MLIR_INCLUDE_INTEGRATION_TESTS=ON`.

## Read when touched
No rules are extracted for these. When the diff changes one of these areas, fetch the page and review against it.

| Diff touches | Read |
|--------------|------|
| Bufferization passes or dialect | https://mlir.llvm.org/docs/Bufferization/ |
| Buffer deallocation | https://mlir.llvm.org/docs/OwnershipBasedBufferDeallocation/ |
| DRR patterns (`Pat<>` in `.td`) | https://mlir.llvm.org/docs/DeclarativeRewrites/ |
| PDLL or PDL patterns | https://mlir.llvm.org/docs/PDLL/ |
| Data layout entries or interfaces | https://mlir.llvm.org/docs/DataLayout/ |
| Bytecode reader or writer | https://mlir.llvm.org/docs/BytecodeFormat/ |
| Remarks or action tracing | https://mlir.llvm.org/docs/Remarks/ and https://mlir.llvm.org/docs/ActionTracing/ |
| LLVM IR translation or LLVM dialect | https://mlir.llvm.org/docs/TargetLLVMIR/ |
| C API (`mlir/include/mlir-c`) | https://mlir.llvm.org/docs/CAPI/ |
| Python bindings (`mlir/python`) | https://mlir.llvm.org/docs/Bindings/Python/ |
| IR syntax in tests or docs | https://mlir.llvm.org/docs/LangRef/ |
| User-visible changes | https://mlir.llvm.org/docs/ReleaseNotes/ |

## Sources
- Developer Guide (style, passes, verifiers): https://mlir.llvm.org/getting_started/DeveloperGuide/
- Testing Guide: https://mlir.llvm.org/getting_started/TestingGuide/
- Defining dialects: https://mlir.llvm.org/docs/DefiningDialects/
- Defining operations (ODS): https://mlir.llvm.org/docs/DefiningDialects/Operations/
- Defining attributes and types: https://mlir.llvm.org/docs/DefiningDialects/AttributesAndTypes/
- Pattern rewriting: https://mlir.llvm.org/docs/PatternRewriter/
- Canonicalization: https://mlir.llvm.org/docs/Canonicalization/
- Dialect conversion: https://mlir.llvm.org/docs/DialectConversion/
- Pass infrastructure: https://mlir.llvm.org/docs/PassManagement/
- Diagnostics: https://mlir.llvm.org/docs/Diagnostics/
- Interfaces: https://mlir.llvm.org/docs/Interfaces/
- Traits: https://mlir.llvm.org/docs/Traits/
- Symbols and symbol tables: https://mlir.llvm.org/docs/SymbolsAndSymbolTables/
