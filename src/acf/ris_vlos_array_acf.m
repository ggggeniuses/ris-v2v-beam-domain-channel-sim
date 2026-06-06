function rho = ris_vlos_array_acf(cfg, delta_t)
%RIS_VLOS_ARRAY_ACF Geometry-based RIS VLoS temporal correlation.
%
% This compact extension model uses RIS element coordinates and the change of
% Tx/Rx look directions over time. It is intentionally separate from the
% vendor STF-CF benchmark functions, whose RIS loops use fixed sub-array
% coordinates and therefore cannot expose RIS-size or spacing sweeps.

delta_t = delta_t(:);
lambda = cfg.lambda;
k0 = 2 * pi / lambda;

[mx, mz] = meshgrid(1:cfg.ris.Mx, 1:cfg.ris.Mz);
xOffset = (mx(:) - (cfg.ris.Mx + 1) / 2) * cfg.ris.dmx;
zOffset = (mz(:) - (cfg.ris.Mz + 1) / 2) * cfg.ris.dmz;
elementOffset = [xOffset, zeros(size(xOffset)), zOffset];

t0 = cfg.motion.t;
reference = ris_steering(cfg, t0, elementOffset, k0);

rho = zeros(size(delta_t));
for k = 1:numel(delta_t)
    current = ris_steering(cfg, t0 + delta_t(k), elementOffset, k0);
    rho(k) = mean(reference .* conj(current));
end

rho = normalize_correlation(rho);
end

function steering = ris_steering(cfg, t, elementOffset, k0)
risPosition = [cfg.ris.x, cfg.ris.y, cfg.ris.z];
txPosition = tx_position(cfg, t);
rxPosition = rx_position(cfg, t);

uTx = unit_vector(txPosition - risPosition);
uRx = unit_vector(rxPosition - risPosition);
phaseSlope = uTx + uRx;

steering = exp(1i * k0 * (elementOffset * phaseSlope(:)));
end

function position = tx_position(cfg, t)
velocity = velocity_vector(cfg.motion.vT, cfg.motion.eta_azi_T, cfg.motion.eta_ver_T);
position = [0, 0, cfg.geometry.H0] + t * velocity;
end

function position = rx_position(cfg, t)
velocity = velocity_vector(cfg.motion.vR, cfg.motion.eta_azi_R, 0);
position = [cfg.geometry.D0, 0, 0] + t * velocity;
end

function velocity = velocity_vector(speed, azimuth, elevation)
velocity = speed * [cos(elevation) * cos(azimuth), ...
                    cos(elevation) * sin(azimuth), ...
                    sin(elevation)];
end

function u = unit_vector(v)
normValue = norm(v);
if normValue == 0
    u = [0, 0, 0];
else
    u = v ./ normValue;
end
end
