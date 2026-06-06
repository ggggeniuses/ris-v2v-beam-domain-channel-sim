# Run Guide

## Complete Workflow

```matlab
run_all
run_tests
```

`run_all` generates the RIS-V2V correlation baselines, RIS-V2V extension
experiments, FAS-UAV experiments, and smoke-check outputs.

## RIS-V2V Baselines

```matlab
run_benchmarks
```

Generated outputs:

- `spatial_ccf_model_baseline`
- `temporal_acf_model_baseline`
- `frequency_fcf_model_baseline`

Each experiment saves a PNG figure and MAT data file. The baseline scripts call
the self-contained functions under `src/ccf`, `src/acf`, and `src/fcf`.

## RIS-V2V Extensions

```matlab
run_extensions
```

This includes RIS size and spacing sweeps, mobility analysis, capacity
invariance, beam-domain sparsity, and sparsity-aware complexity accounting.

## FAS-UAV

```matlab
run_fas_uav
```

Set `FAS_UAV_PROFILE` to `quick`, `calibration`, or `final`. The corresponding
Monte Carlo counts are 4, 30, and 300.

## Validation

```matlab
run_tests
```

Tests cover deterministic generation, matrix dimensions, DFT unitarity,
capacity invariance, modeling-error behavior, sparsity metrics, complexity
formulas, and output integrity.
