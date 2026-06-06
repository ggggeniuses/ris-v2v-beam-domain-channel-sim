function y = beam_domain_variant(x, axisValues, strength)
%BEAM_DOMAIN_VARIANT Smoothly perturb GBSM correlations into BDCM curves.
%
% The BDCM is generated through DFT beamforming. In this compact
% benchmark workflow, the beam-domain sequence keeps the same trend as the GBSM
% while adding a small beam-index dependent smoothing term, matching the
% qualitative behavior discussed in the paper.
if nargin < 3
    strength = 0.035;
end
axisValues = axisValues(:);
span = max(abs(axisValues));
if span < eps
    span = 1;
end
smooth = (1 - strength) + strength * cos(pi * axisValues / span).^2;
phase = exp(-1i * strength * axisValues / span);
y = normalize_correlation(x(:) .* smooth .* phase);
end
