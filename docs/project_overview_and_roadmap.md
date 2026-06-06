# Project Overview and Roadmap

## Positioning

This repository is a MATLAB engineering platform for dynamic channel modeling,
propagation statistics, and capacity analysis in reconfigurable wireless
systems. It currently covers RIS-enabled V2V and FAS-assisted UAV links.

## Implemented

### RIS-V2V

- Spatial, temporal, and frequency correlation baselines.
- RIS size, RIS spacing, and vehicle-motion sweeps.
- Array/beam-domain capacity invariance.
- Beam-domain sparsity metrics.
- Full-model and sparsity-aware complexity accounting.

### FAS-UAV

- Dynamic LoS/NLoS channel generation.
- Active-port selection.
- Modeling-error analysis.
- Aperture and motion-state capacity analysis.
- FAS and ULA capacity comparison.
- Reproducible Monte Carlo profiles.

## Engineering Structure

- `src/`: reusable model and metric functions.
- `scripts/`: experiment definitions.
- `tests/`: numerical and output validation.
- `results/`: generated figures and MAT data.
- `docs/`: theory, interpretation, and run guidance.

## Next Development

1. Add automated MATLAB CI on a self-hosted or licensed runner.
2. Add parameter files for repeatable experiment presets.
3. Export summary metrics to CSV for easier comparison.
4. Add channel-estimation or learning-based prediction as a separate module.
5. Explore a joint RIS-FAS air-ground scenario without changing the validated
   behavior of the current modules.

## Suggested GitHub Metadata

Description:

```text
MATLAB simulator for RIS/FAS-enabled dynamic wireless channels, covering RIS-V2V statistics and FAS-UAV capacity analysis.
```

Topics:

```text
matlab wireless-communications channel-modeling ris fluid-antenna-system
v2v uav-communications beam-domain gbsm bdcm 6g
```
