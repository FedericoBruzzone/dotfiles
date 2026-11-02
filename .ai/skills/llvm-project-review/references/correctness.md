# Correctness review

Read this for any change that alters behavior: transformations, folds, canonicalizations, lowerings, rewrite patterns, new ops or flags, and bug fixes. Style and process are covered elsewhere. This file is about finding real bugs.

## Method
- Do not accept "looks right". For each transformation, state the before and after, then try to construct a concrete input where the after is not a valid replacement for the before. Report the input.
- Check the edges: empty and zero-sized values, a single element, the maximum and minimum of each type, overflow, signedness, bit width, NaN and infinities, vectors and splats, dynamic versus static shapes, rank 0, `index` versus fixed-width integers, values with several uses, and code in unreachable blocks.
- Check that the precondition the code relies on is actually checked in the code, not only assumed in the author's head. Look for the negative case: does a test show the transform does not apply when the precondition fails?
- Prefer a proof over an argument. For LLVM IR transformations, ask for an Alive2 proof, as the InstCombine guide does.
- Mark each finding with its confidence (see SKILL.md). A counterexample you built makes a finding `verified`. A plausible reading of the code is `likely`. A feeling is `suspected`.

## Refinement (LangRef)
- A transformation is valid when the new code's behavior is contained in the original's. It must not introduce poison or undefined behavior where the original had none, remove a safety property, or change which branches run unless the original had UB.
- UB, poison, and `undef` are different. Poison propagates through operations, and using it in control flow or as certain operands is immediate UB. `undef` is an arbitrary value that may differ per use and does not propagate. `freeze` stops poison.
- Poison-generating flags (`nsw`, `nuw`, `exact`, `inbounds`, `nneg`, `disjoint`, fast-math flags) turn a condition into poison. When rewriting an instruction, check which flags may be kept on the new one. A flag kept without justification is a miscompile risk. The InstCombine guide says to favor propagating flags that are hard to recover and to call `dropPoisonGeneratingFlags()` when unsure.
- Fast-math: test and reason about specific flags (`nnan`, `nsz`, `reassoc`), not the umbrella `fast`.
- Attributes and metadata: ABI attributes cannot be dropped and must match at declaration and call site. Optimization attributes such as `noalias` and `dereferenceable` may be dropped, but only when that is safe for the transformation. Metadata is preserved unless the transformation provably keeps its guarantees.
- Memory: volatile accesses are not reordered or removed. `noalias` constrains which pointers may access the memory during the call, so check it before reordering loads and stores. Relaxed atomics give no ordering with other accesses to the same location.

## Optimization patches (InstCombine contributor guide)
These apply to any IR transformation.
- Transformations are target independent. No target-specific cost modeling in InstCombine.
- Canonicalization may not be an optimization by itself. It is still justified when it reduces the cases other transforms must handle.
- Tests: one negative test per unsatisfied precondition, a multi-use test showing the instruction count does not grow, vector tests with splats, commuted operands unless a constant is always canonicalized to one side, and a precommitted baseline.
- Use `m_OneUse` when profitability needs the original instructions to disappear.
- Create instructions with `IRBuilder`. Replace and erase through the worklist-aware APIs (`replaceInstUsesWith`, `eraseInstFromFunction`) and not through `eraseFromParent()` directly.
- A transform with no real-world use has negative value for the project.

## LLVM pitfalls (Programmer's Manual)
- Non-determinism: iteration order of containers keyed by pointer, and of hash containers such as `DenseMap` and `StringMap`, is not stable between runs. If the order affects output, use `MapVector`, `SetVector`, or sort. Output that changes between runs breaks tests and reproducibility.
- Lifetime: do not store `StringRef`, `Twine`, or `ArrayRef` unless the storage they point to outlives them. Store `std::string` or `SmallString` copies.
- Iterator invalidation: `SmallVector` invalidates iterators at and after an insertion or erasure, `DenseMap` on rehash. Do not modify a container while iterating it.
- Mutation during traversal: use `llvm::make_early_inc_range` when erasing while iterating, and collect uses before `replaceAllUsesWith` when iterating a use list.
- Casting: use `dyn_cast` instead of `isa` followed by `cast`. `cast` asserts on mismatch and `dyn_cast` returns null, so check the result. Use `dyn_cast_if_present` or `isa_and_present` only when null is a valid input.
- Containers: `SmallVector` for usually-small sequences, `SmallPtrSet` for pointer membership, `DenseMap` when order does not matter, `StringMap` for string keys.
- `STATISTIC` instead of manual counters. Debug-only code goes under `LLVM_DEBUG`, which compiles out without assertions.

## MLIR
- The verifier rules, the fold and canonicalization rules, and the rewriter rules are in `references/mlir.md`. A fold or pattern that turns valid IR into invalid IR is a bug in the fold or pattern.
- Apply the same method: build a counterexample with `mlir-opt` using dynamic shapes, rank 0, unusual types, and ops with several uses, and say whether you ran it.

## Sources
- Language reference: https://llvm.org/docs/LangRef.html
- Programmer's Manual: https://llvm.org/docs/ProgrammersManual.html
- InstCombine contributor guide: https://llvm.org/docs/InstCombineContributorGuide.html
- Alive2: https://github.com/AliveToolkit/alive2
