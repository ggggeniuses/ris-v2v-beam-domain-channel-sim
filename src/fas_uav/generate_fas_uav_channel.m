function H = generate_fas_uav_channel(cfg, active_ports, env)
%GENERATE_FAS_UAV_CHANNEL Compact LoS+NLoS FAS-UAV dynamic channel.
%
% This project wrapper follows the geometry, Rician combination, spherical
% phase and Doppler phase used by the FAS-UAV model. Capacity
% experiments use Frobenius normalization; modeling-error experiments can
% disable it through cfg.normalize_channel.
if nargin < 2 || isempty(active_ports)
    active_ports = select_active_ports(cfg.Q, cfg.Qsub, 'uniform');
end
if nargin < 3 || isempty(env)
    env = generate_fas_uav_environment(cfg);
end

lambda = cfg.lambda;
k0 = 2 * pi / lambda;
P = cfg.P;

tx_center0 = [0, 0, cfg.H0];
rx_center = [cfg.D0, 0, 0];
move_dir = [cos(cfg.etaT) * cos(cfg.gammaT), ...
    cos(cfg.etaT) * sin(cfg.gammaT), sin(cfg.etaT)];
tx_center = tx_center0 - cfg.vT * cfg.t * move_dir;

tx_dir = [cos(cfg.thetaT) * cos(cfg.psiT), ...
    cos(cfg.thetaT) * sin(cfg.psiT), sin(cfg.thetaT)];
kp = (P - 2 * (1:P) + 1) / 2;
tx_pos = tx_center + (kp(:) * cfg.deltaT) * tx_dir;

port_all = fas_port_positions(cfg, rx_center);
active_ports = active_ports(active_ports >= 1 & active_ports <= size(port_all, 1));
ports = port_all(active_ports, :);
Qsub = size(ports, 1);

H_los = complex(zeros(Qsub, P));
for q = 1:Qsub
    port_vec = ports(q, :) - tx_center;
    [az, el] = vec2azel(port_vec);
    doppler_phase = k0 * cfg.vT * cfg.t * ...
        (cos(el) * cos(cfg.etaT) * cos(az - cfg.gammaT) + sin(el) * sin(cfg.etaT));
    for p = 1:P
        dist = norm(ports(q, :) - tx_pos(p, :));
        H_los(q, p) = exp(1i * (-k0 * dist + doppler_phase));
    end
end

H_nlos = complex(zeros(Qsub, P));
num_paths = env.num_clusters * env.rays_per_cluster;
for lc = 1:env.num_clusters
    scatters = env.clusters(lc).scatters;
    phases = env.clusters(lc).phases;

    for n = 1:size(scatters, 1)
        scatter = scatters(n, :);
        [az_t, el_t] = vec2azel(scatter - tx_center);
        doppler_phase = k0 * cfg.vT * cfg.t * ...
            (cos(el_t) * cos(cfg.etaT) * cos(az_t - cfg.gammaT) + sin(el_t) * sin(cfg.etaT));
        for q = 1:Qsub
            d2 = norm(ports(q, :) - scatter);
            for p = 1:P
                d1 = norm(scatter - tx_pos(p, :));
                H_nlos(q, p) = H_nlos(q, p) + ...
                    exp(1i * (phases(n) - k0 * (d1 + d2) + doppler_phase));
            end
        end
    end
end
H_nlos = H_nlos / sqrt(max(num_paths, 1));

K = max(cfg.K, 0);
H = sqrt(K / (K + 1)) * H_los + sqrt(1 / (K + 1)) * H_nlos;
normalizeChannel = ~isfield(cfg, 'normalize_channel') || cfg.normalize_channel;
if normalizeChannel
    nf = norm(H, 'fro');
    if nf > 0
        H = H * sqrt(P * Qsub) / nf;
    end
end
end

function ports = fas_port_positions(cfg, rx_center)
if isfield(cfg, 'port_positions') && ~isempty(cfg.port_positions)
    ports = cfg.port_positions;
    return;
end

rx_dir = [cos(cfg.thetaR) * cos(cfg.psiR), ...
    cos(cfg.thetaR) * sin(cfg.psiR), sin(cfg.thetaR)];
if isfield(cfg, 'deltaR') && ~isempty(cfg.deltaR)
    deltaR = cfg.deltaR;
else
    deltaR = cfg.W * cfg.lambda / max(cfg.Q - 1, 1);
end
idx = ((1:cfg.Q) - (cfg.Q + 1) / 2).';
ports = rx_center + idx * deltaR * rx_dir;
end

function [az, el] = vec2azel(v)
[az, el] = fas_vec2azel(v);
end
