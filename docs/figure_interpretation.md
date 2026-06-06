# Figure Interpretation

## Spatial CCF Baseline

Figure path:

```text
results/figures/spatial_ccf_model_baseline.png
```

Purpose:

This figure compares spatial cross-correlation functions of NLoS,
RIS-assisted VLoS, and Rician-combined links under GBSM and BDCM descriptions.

Interpretation:

The spatial CCF result shows how link composition and beam-domain
transformation affect spatial correlation properties in RIS-aided V2V channels.

## Temporal ACF Baseline

Figure path:

```text
results/figures/temporal_acf_model_baseline.png
```

Purpose:

This figure compares temporal auto-correlation functions under V2V mobility and
RIS-assisted propagation.

Interpretation:

The temporal ACF result shows how mobility and RIS-assisted propagation affect
channel non-stationarity over time.

## Frequency FCF Baseline

Figure path:

```text
results/figures/frequency_fcf_model_baseline.png
```

Purpose:

This baseline compares the frequency-correlation behavior of NLoS, RIS-assisted
VLoS, and combined links in the array and beam domains.

Interpretation:

The frequency FCF result shows how the channel response decorrelates across
frequency separation.

## RIS Size Sweep Extension

Figure path:

```text
results/figures/ris_parameter_sweep_temporal_acf_extension.png
```

Interpretation:

This extension isolates the RIS-assisted VLoS component and shows how RIS array
size changes the temporal correlation trend in the compact geometry model.

## RIS Spacing Sweep Extension

Figure path:

```text
results/figures/ris_spacing_sweep_temporal_acf_extension.png
```

Interpretation:

This extension shows how RIS element spacing changes the effective aperture and
therefore the temporal correlation behavior.

## Motion State Sweep Extension

Figure path:

```text
results/figures/motion_state_sweep_temporal_acf_extension.png
```

Interpretation:

This extension compares mobility states and shows that faster or differently
oriented motion can accelerate temporal decorrelation.

## Channel Capacity Extension

Figure path:

```text
results/figures/ris_v2v/channel_capacity_gbsm_bdcm_extension.png
```

Interpretation:

This extension computes MIMO capacity from a compact array-domain RIS-V2V demo
channel and its DFT beam-domain counterpart. Because the transform is unitary,
the two curves should coincide up to numerical precision. The figure is a
capacity-invariance sanity check, not a beam-domain capacity-gain claim.

## BDCM Sparsity Extension

Figure path:

```text
results/figures/ris_v2v/channel_matrix_sparsity_gbsm_bdcm_extension.png
```

Interpretation:

This heatmap compares the array-domain channel magnitude and the corresponding
beam-domain representation, highlighting how beam-domain transformation can
expose sparse or concentrated channel structure. The matching MAT file includes
top-K energy concentration, threshold sparsity ratios, and energy-capture beam
counts.

## Complexity Comparison Extension

Figure path:

```text
results/figures/ris_v2v/complexity_comparison_extension.png
```

Interpretation:

This extension compares real-operation counts using the per-CIR formulas from
the RIS-V2V paper Sec. V-E / Eq. (48). Full GBSM and full BDCM use the same
`P*Q` coefficient count. The third curve applies the measured beam coefficient
count required for 95% energy capture, showing that the complexity benefit
comes from beam-domain sparsity rather than from mixing counting conventions.

## FAS-UAV Modeling Error

Figure path:

```text
results/figures/fas_uav/fas_uav_modeling_error.png
```

Interpretation:

This result follows the FAS-UAV paper's Eq. (14), using element-wise normalized
absolute error between unnormalized FAS and ULA CIRs with the same number of
receiving elements. Channel normalization is reserved for the Eq. (15) capacity
experiments.

## FAS-UAV Capacity Versus Active Ports and FAS Size

Figure path:

```text
results/figures/fas_uav/fas_uav_capacity_vs_ports_w.png
```

Interpretation:

This result shows how the number of active FAS ports and physical FAS size
jointly affect channel capacity. Scatterer environments are reused across W and
Qsub cases within each Monte Carlo realization for fair curve comparison.

## FAS-UAV Capacity Versus Active Ports and Motion State

Figure path:

```text
results/figures/fas_uav/fas_uav_capacity_vs_ports_motion.png
```

Interpretation:

This result compares capacity curves under different UAV speed and observation
time settings. Scatterer environments are reused across motion states within
each Monte Carlo realization, so curve differences are driven by motion
parameters rather than different random channels.

## FAS Versus ULA Capacity

Figure path:

```text
results/figures/fas_uav/fas_uav_capacity_fas_vs_ula.png
```

Interpretation:

This result compares ULA and FAS configurations with different port spacing and
active-port ratios as antenna length increases. ULA uses `lambda/2`, FAS1 uses
`lambda/3`, and FAS2 uses `lambda/4`.
