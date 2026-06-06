function H_G = generate_gbsm_channel_matrix(cfg)
%GENERATE_GBSM_CHANNEL_MATRIX Compact RIS-V2V array-domain channel demo.
%
% This extension is for capacity and sparsity visualization. It is not an
% exact replica of the original STF-CF code.
rng(cfg.randomSeed, 'twister');

P = cfg.antenna.P;
Q = cfg.antenna.Q;
lambda = cfg.lambda;

txPos = array_positions(P, cfg.antenna.delta_T);
rxPos = array_positions(Q, cfg.antenna.delta_R);

thetaLos = pi / 5;
phiLos = pi / 7;
aTLos = steering_from_position(txPos, thetaLos, lambda);
aRLos = steering_from_position(rxPos, phiLos, lambda);
H_vlos = aRLos * aTLos';

H_nlos = zeros(Q, P);
numPaths = cfg.cluster.L;
for ell = 1:numPaths
    thetaT = cfg.cluster.mu_AAoA + cfg.cluster.sigma_AAoA * randn();
    thetaR = cfg.cluster.mu_EAoA + cfg.cluster.sigma_EAoA * randn();
    gain = (randn() + 1i * randn()) / sqrt(2 * numPaths);
    aT = steering_from_position(txPos, thetaT, lambda);
    aR = steering_from_position(rxPos, thetaR, lambda);
    H_nlos = H_nlos + gain * (aR * aT');
end

K = max(cfg.geometry.K, 0);
H_G = sqrt(K / (K + 1)) * H_vlos + sqrt(1 / (K + 1)) * H_nlos;
H_G = H_G / max(norm(H_G, 'fro'), eps) * sqrt(P * Q);
end

function pos = array_positions(N, spacing)
idx = (0:N-1) - (N - 1) / 2;
pos = idx(:) * spacing;
end

function a = steering_from_position(pos, angle, lambda)
a = exp(1i * 2 * pi / lambda * pos * sin(angle));
a = a / sqrt(numel(pos));
end
