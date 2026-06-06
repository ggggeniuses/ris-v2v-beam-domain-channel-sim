# Theory Notes

## Problem Background

RIS-aided V2V communication channels are highly dynamic because vehicles move,
scatterers change relative geometry, and RIS-reflected paths introduce an
additional controllable propagation component. The referenced paper builds a
three-dimensional non-stationary channel model and then derives a beam-domain
channel model (BDCM) through DFT-based beamforming.

## Link Components

The channel contains two main parts:

```text
h(t, tau) = sqrt(1/(K+1)) h_NLoS(t, tau)
          + sqrt(K/(K+1)) h_VLoS(t, tau)
```

- `h_NLoS`: cluster-scattering component.
- `h_VLoS`: virtual LoS component reflected by RIS.
- `K`: Rician factor controlling the relative power of VLoS and NLoS links.

## GBSM and BDCM

GBSM describes the channel from geometric propagation relationships. It is
direct and physically interpretable, but can be computationally expensive for
large arrays and RIS surfaces.

BDCM maps the channel into the beam domain. The beam-domain representation
captures the same propagation statistics while exposing sparsity and reducing
modeling complexity.

## Statistical Characteristics

This project focuses on three channel statistics:

- Spatial CCF: correlation across antenna or beam indexes.
- Temporal ACF: correlation across time difference under mobility.
- Frequency FCF: correlation across frequency difference.

The project implements these statistics with reusable numerical functions.
Extension experiments use the same configuration and plotting infrastructure
to explore RIS and motion parameters.
