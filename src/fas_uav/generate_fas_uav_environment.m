function env = generate_fas_uav_environment(cfg)
%GENERATE_FAS_UAV_ENVIRONMENT Draw reusable FAS-UAV scatterer parameters.
%
% One environment can be reused across W, Qsub, and motion cases inside a
% Monte Carlo realization, giving fair common-random-number comparisons.
rng(cfg.random_seed, 'twister');

tx_center0 = [0, 0, cfg.H0];
rx_center = [cfg.D0, 0, 0];
[mu_az, mu_el] = fas_vec2azel(rx_center - tx_center0);

env.seed = cfg.random_seed;
env.tx_center0 = tx_center0;
env.rx_center = rx_center;
env.num_clusters = cfg.num_clusters;
env.rays_per_cluster = cfg.rays_per_cluster;
env.scatter_radius = cfg.scatter_radius;
env.clusters = struct('center', {}, 'scatters', {}, 'phases', {});

for lc = 1:cfg.num_clusters
    center = (tx_center0 + rx_center) / 2 + 5 * randn(1, 3);
    az = fas_vmrand(mu_az, cfg.kappa, cfg.rays_per_cluster);
    el = fas_vmrand(mu_el, cfg.kappa, cfg.rays_per_cluster);
    scatters = [center(1) + cfg.scatter_radius * cos(el) .* cos(az), ...
        center(2) + cfg.scatter_radius * cos(el) .* sin(az), ...
        center(3) + cfg.scatter_radius * sin(el)];
    phases = (2 * rand(cfg.rays_per_cluster, 1) - 1) * pi;

    env.clusters(lc).center = center;
    env.clusters(lc).scatters = scatters;
    env.clusters(lc).phases = phases;
end
end
