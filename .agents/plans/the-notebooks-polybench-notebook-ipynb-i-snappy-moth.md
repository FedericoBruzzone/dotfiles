# Plan: Close coverage gaps and add ICSE-quality figures to `polybench_notebook.ipynb`

## Context

The notebook currently produces ~21 polished figures, but the underlying CSVs in [polybench-artifact/results/](polybench-artifact/results/) expose **~208 columns per benchmark in `main_*.csv`** (plus extra detail in `runtime_metrics_*.csv`, `compile_metrics_*.csv`, and `profile_metrics_*.csv`). A column-by-column comparison shows that several metrics that were *measured* are not visualized — notably the full cache hierarchy, backend stalls, memory footprint, IR structural counts, the `effect_size_vs_O0` / per-metric `pvalue_vs_O0` family, and the per-PolyBench-category dimension. The user is preparing this material for an ICSE-class submission and wants both (1) full coverage of the recorded data and (2) a curated set of publication-quality figures.

The pipeline is **LLVM `-O3`** (the `O1_custom_<idx>` variant naming is legacy; baseline is `O0`, every other variant adds one more pass from the discovered `-O3` schedule). Data is already loaded into `df` and `df_custom` in [notebooks/polybench_notebook.ipynb](notebooks/polybench_notebook.ipynb) cell 4–8, so all new figures can reuse that frame plus the existing `CB_PALETTE` and academic-style `rcParams`.

All edits are appended to the existing notebook (no new file), grouped under three new top-level markdown sections so the existing figure numbering is preserved.

---

## Part A — Coverage gaps (one section, ~10 figures)

New markdown section: **"Part 8 · Extended Metric Coverage"**, appended after Figure 21.

For each gap, reuse the existing pattern: line-with-CI95-fill keyed on `pass_index`, faceted by `benchmark_id` when useful. Aggregations use median across benchmarks (already the notebook's convention).

| # | Title | Plot type | CSV columns (from `main_*.csv` unless noted) |
|---|---|---|---|
| 22 | Cache hierarchy evolution | 3-panel line+CI95 | `profile_d1_misses`, `profile_ll_misses`, `profile_l1_i_misses` (+ their `_ci95_*`) |
| 23 | Backend vs frontend stalls | Stacked area | `profile_stalls_frontend`, `profile_stalls_backend` |
| 24 | Memory footprint over the pipeline | Line+CI95 | `profile_max_rss` (+ `profile_page_faults` on twin axis) |
| 25 | Branch-miss rate (not just count) | Line+CI95 | `profile_branch_miss_rate`, `profile_cache_references` |
| 26 | IR structural composition | Stacked-area / 4-panel | `ir_basic_block_count`, `ir_phi_node_count`, `ir_globals_count`, `ir_call_site_count` |
| 27 | `text_section_size` vs `binary_size_bytes` | Scatter w/ y=x guide | `text_section_size`, `binary_size_bytes` |
| 28 | `opt_wall_seconds` share of `compile_time_wall_seconds` | Stacked bar / ratio line | `opt_wall_seconds`, `compile_time_wall_seconds` |
| 29 | Per-metric **vs-O0** effect-size heatmap | Heatmap (rows = metrics, cols = pass groups) | `effect_size_vs_O0_profile_*` (15 metrics) |
| 30 | Per-metric **vs-O0** −log10(p-value) heatmap | Heatmap | `pvalue_vs_O0_profile_*` (15 metrics) |
| 31 | Multi-metric delta heatmap (`delta_vs_O0_*`) | Heatmap | All `delta_vs_O0_profile_*` columns |

**Reuses:** `df_custom`, the existing helpers that compute median-across-benchmarks, `CB_PALETTE`, the `_save_fig` pattern already in the notebook.

---

## Part B — ICSE-quality publication figures (one section, 8 figures)

New markdown section: **"Part 9 · Publication Figures (ICSE)"**, with each figure in its own subsection and a brief paper-style caption (1-2 sentences) explaining what to read off it.

### B1. Pareto frontiers (Fig P1)
Three side-by-side panels: runtime ↔ {compile time, binary size, energy}. Points = variants aggregated across benchmarks (median speedup, median cost). Non-dominated front highlighted with a connecting line; baseline `O0` and final `-O3` annotated. **Why ICSE-worthy:** lets reviewers see the *trade-off shape* — exactly the framing reviewers expect for a "should we add pass X" claim.
- Columns: `runtime_median_seconds`, `compile_time_wall_seconds`, `binary_size_bytes`, `profile_energy_joules`.
- Implement non-dominated front with a simple O(n²) sweep; no scipy dependency.

### B2. Volcano plot per pass (Fig P2)
Scatter: x = `effect_size_vs_prev` (Cohen's d), y = −log10(`pvalue_vs_prev`). One dot per (benchmark, pass), sized by |Δ runtime|. Quadrant lines at d = ±0.5 and p = 0.05. Color by sign of effect (improvement vs regression). **Why ICSE-worthy:** standard quadrant view that separates statistically significant from practically meaningful — directly answers "which passes actually matter."
- Columns: `effect_size_vs_prev`, `pvalue_vs_prev`, `delta_prev_runtime_median_seconds`.

### B3. ECDF of per-benchmark speedup (Fig P3)
Empirical CDF of `speedup_vs_O0` across the 30 benchmarks at each of three checkpoints (e.g., final variant, midpoint, top-quartile pass). Inset: Dolan–Moré-style performance profile. **Why ICSE-worthy:** a single figure that summarizes *how broadly* the optimization helps, not just on average.
- Columns: `speedup_vs_O0` (already in `main_*.csv`).

### B4. Critical Difference diagram (Fig P4)
For a chosen set of "interesting" pass-groups (e.g., baseline, every-10th cumulative checkpoint, final), rank each across the 30 benchmarks and run a Friedman + Nemenyi post-hoc test. Plot the standard CD diagram (ranked groups on a horizontal axis with a CD bar). **Why ICSE-worthy:** Demšar's CD diagram is the canonical way empirical SE papers compare configurations across benchmarks.
- Implementation: hand-rolled Friedman χ² + Nemenyi q-table (no scipy dependency hard-coded; values can be inlined for k ≤ 10).

### B5. Hierarchically-clustered benchmark × pass heatmap (Fig P5)
Pivot `delta_prev_runtime_median_seconds` (or normalized speedup) into benchmark × pass matrix. Apply hierarchical clustering on rows (benchmarks) and columns (passes). Show dendrograms. **Why ICSE-worthy:** reveals *families of passes* that affect the same benchmarks similarly — strong narrative material.
- Use `scipy.cluster.hierarchy` (already standard) or fall back to a pure-numpy single-linkage if unavailable.

### B6. Per-category small-multiples (Fig P6)
6-panel grid (datamining, linear_algebra_blas, …_kernels, …_solvers, medley, stencils). Each panel: speedup-vs-O0 evolution with CI95 fill, color-coded by benchmark within the category. **Why ICSE-worthy:** lets reviewers see whether conclusions generalize across PolyBench's structural categories — a common reviewer ask.
- Categories derived from `benchmark_id` prefix; helper `_category(bench_id)` to add to the existing dataframe in cell 6.

### B7. Roofline-style compute-vs-memory diagnosis (Fig P7)
Scatter: x = `profile_d1_misses` / `profile_instructions` (memory pressure), y = `profile_ipc` (compute throughput). Points = (benchmark, pass-checkpoint). Arrows from `O0` → final variant per benchmark. Quadrants labeled "compute-bound improvement", "memory-bound improvement", etc. **Why ICSE-worthy:** classifies *what kind of speedup* the pipeline delivers — a structural insight reviewers love.
- Columns: `profile_d1_misses`, `profile_instructions`, `profile_ipc`.

### B8. Raw-run violin distributions (Fig P8)
For a small set of representative benchmarks (e.g., one per category, picked by largest speedup), parse `raw_seconds_json` from `runtime_metrics_*.csv` and produce a violin plot of the raw run distribution at every 10th variant. **Why ICSE-worthy:** moves beyond mean ± CI to show distribution shape (skew, multimodality) — reviewers increasingly demand this.
- Requires loading `runtime_metrics_*.csv` (currently not loaded). Add a helper `_load_runtime_metrics()` near cell 4. Use `json.loads` on the column.

---

## Critical files

- [notebooks/polybench_notebook.ipynb](notebooks/polybench_notebook.ipynb) — append two new sections (Part 8 + Part 9). All new code inserted as new cells at the end. No existing cell is modified except cell 6 (add `category` column to `df` and `df_custom`).
- [notebooks/polybench_figures/](notebooks/polybench_figures/) — new figures auto-saved here using the notebook's existing `_save_fig` helper, with filenames `fig22_…` through `fig31_…` and `figP1_…` through `figP8_…`.

## Reused conventions (do not reinvent)

- `CB_PALETTE` (color-blind palette already defined in cell 2).
- Academic `rcParams` block (cell 2).
- `df_custom` (already filters out `pass_index < 0` baseline).
- The CI95 `fill_between` idiom from Figure 2.
- The pivot+heatmap idiom from Figures 10/10b.
- The horizontal-bar ranking idiom from Figure 20.
- `_save_fig(fig, "figXX_name")` (defined in cell 3).

## Verification

1. **Run the notebook end-to-end** (`jupyter nbconvert --to notebook --execute polybench_notebook.ipynb --output /tmp/out.ipynb`) and confirm no cell errors. Existing figures must still render identically (additions are appended, no upstream cells modified except the `category` column addition).
2. **Spot-check the gap figures** — for figures 22, 26, 29 verify a non-trivial signal exists (i.e., the metric varies across pass_index). Compare against the underlying CSV values for one benchmark (e.g., `polybench_stencils_jacobi_2d`).
3. **Spot-check Part 9 figures**:
   - Pareto front (P1) must contain `O0` and at least one near-final variant.
   - Volcano plot (P2) must show points in all four quadrants (or document that none cross the threshold).
   - CD diagram (P4) — sanity-check Friedman p-value < 0.05; manual rank check on 2 benchmarks.
   - Roofline (P7) — verify O0 → final arrows are non-degenerate.
4. **Visual review** at print scale (figsize already set per academic style). Each new figure must be legible at single-column width (≈3.5 in) and double-column (≈7 in).
5. **Saved files** — confirm all new figures land in [notebooks/polybench_figures/](notebooks/polybench_figures/) as both `.pdf` and `.png` (the existing `_save_fig` already writes both).
