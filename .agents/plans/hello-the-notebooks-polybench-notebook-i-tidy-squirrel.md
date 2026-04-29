# Plan: Polish polybench_notebook.ipynb for top-tier paper

## Context
The notebook is functionally correct but needs cosmetic/readability fixes for publication quality. Four independent issues to address in `notebooks/polybench_notebook.ipynb`.

---

## Issue 1 — Legend once, not in every figure

**Approach:** Programmatically comment out all `ax.legend(...)` calls (23 cells: 14, 16, 18, 20, 26, 28, 30, 32, 34, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 67, 69) by loading the notebook JSON, doing a string substitution on each cell's source lines, and saving.

**New standalone legend cell** (insert near the end of the notebook, after the last figure cell):
```python
def plot_standalone_legend():
    """Standalone figure containing only the shared benchmark legend."""
    handles, labels = [], []
    for bm in benchmarks:
        h, = plt.plot([], [],
                      color=bench_colors[bm], linestyle=bench_ls[bm],
                      marker=bench_markers[bm], linewidth=1.2, markersize=4,
                      label=benchmark_short(bm))
        handles.append(h)
        labels.append(benchmark_short(bm))
    fig_leg = plt.figure(figsize=(FIG_W * 2, 0.6 * ((len(benchmarks) + 5) // 6)))
    fig_leg.legend(handles, labels, loc="center",
                   ncol=min(len(benchmarks), 6), framealpha=0.9, fontsize=8)
    plt.tight_layout()
    save_fig(fig_leg, "legend_benchmarks")
    return fig_leg

_ = plot_standalone_legend()
```

**Critical file:** `notebooks/polybench_notebook.ipynb` — cells 14, 16, 18, 20, 26, 28, 30, 32, 34, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 67, 69 (all `ax.legend(...)` lines).

---

## Issue 2 — Pass names: show only the last pass added

**Approach:** Rewrite `shorten_pass()` in Cell 2. The cumulative pipeline string is like:
`function<eager-inv>(pass-A, pass-B, ..., pass-N)` or `cgscc(devirt<4>)(pass-A,...,pass-N)`.
We need to extract the last top-level comma-separated item from inside the outermost `(...)`.

Add a private helper and rewrite `shorten_pass`:

```python
def _split_top_level(s: str, sep: str = ",") -> list[str]:
    """Split s by sep, ignoring separators inside <>, (), []."""
    parts, current, depth = [], [], 0
    for ch in s:
        if ch in "(<[":
            depth += 1; current.append(ch)
        elif ch in ")>]":
            depth -= 1; current.append(ch)
        elif ch == sep and depth == 0:
            parts.append("".join(current).strip()); current = []
        else:
            current.append(ch)
    if current:
        parts.append("".join(current).strip())
    return parts

def shorten_pass(name: str) -> str:
    """Return only the last pass added in a cumulative LLVM pipeline string."""
    if pd.isna(name) or name in ("O0", "O0 (baseline)", ""):
        return name if not pd.isna(name) else ""
    if name[-1] != ")":
        return name  # bare pass name
    # Walk backwards to find the matching opening paren of the last argument list
    depth, start = 0, -1
    for i in range(len(name) - 1, -1, -1):
        if name[i] == ")":   depth += 1
        elif name[i] == "(": depth -= 1
        if depth == 0:       start = i; break
    if start == -1:
        return name
    inner = name[start + 1:-1]
    parts = _split_top_level(inner)
    last = parts[-1].strip() if parts else name
    # Strip parameters:  foo<params> or foo(inner) -> foo
    return re.split(r"[<(]", last)[0].strip() or last
```

**Critical file:** `notebooks/polybench_notebook.ipynb` — Cell 2 (`shorten_pass` function body).

---

## Issue 3 — Benchmark names: show only the leaf name

**Approach:** Change `benchmark_short()` in Cell 2 to return only the last underscore-delimited segment, so `polybench_run_linear_algebra_kernels_atax` → `atax`.

```python
def benchmark_short(bid: str) -> str:
    """Return the leaf benchmark name (e.g. 'atax' from 'polybench_..._atax')."""
    return bid.split("_")[-1]
```

**Critical file:** `notebooks/polybench_notebook.ipynb` — Cell 2 (`benchmark_short` function body).

---

## Issue 4 — Fewer orange triangles in Figure 2b (median plot)

**Approach:** In Cell 8, add a relative-percentage column so that only regressions > 1% relative increase are considered significant:

```python
_prev = df_all.groupby("benchmark_id")["runtime_median_seconds"].shift(1)
df_all["pct_change_runtime_median"] = df_all["delta_prev_runtime_median_seconds"] / _prev
df_all["is_significant_regression_median"] = df_all["pct_change_runtime_median"] > 0.01
```

In `plot_evolution_median` (Cell 16), replace:
```python
reg = sub[sub["is_regression_median"] == True]
```
with:
```python
reg = sub[sub["is_significant_regression_median"] == True]
```

**Critical files:**
- Cell 8 — add `pct_change_runtime_median` and `is_significant_regression_median` columns
- Cell 16 (`plot_evolution_median`) — use `is_significant_regression_median`

---

## Implementation strategy

All edits are done by reading the notebook JSON with Python (`json.load`), mutating the `cells[i]["source"]` lists, and writing back with `json.dump` (indent=1, `ensure_ascii=False`). This avoids fragile per-line grep-and-replace on a complex JSON file.

Order of edits:
1. Cell 2 — replace `shorten_pass` and `benchmark_short` bodies; add `_split_top_level`
2. Cell 8 — append relative-delta columns
3. Cell 16 — use `is_significant_regression_median`
4. All 23 legend cells — comment out `ax.legend(...)` lines
5. Append new standalone-legend code cell at the end of the notebook

## Verification

After implementation, re-run the notebook top-to-bottom:
- All figures should render without legends
- Pass labels on x-axes/hover should show only the leaf pass name (e.g. `callsite-splitting`)
- Benchmark labels should show only the leaf name (e.g. `atax`, `gemm`)
- Figure 2b should have significantly fewer orange triangles (only regressions ≥ 1%)
- The new legend cell produces `legend_benchmarks.pdf` with all benchmarks labeled cleanly
