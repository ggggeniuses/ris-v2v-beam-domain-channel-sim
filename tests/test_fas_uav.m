fprintf('  test_fas_uav...\n');

cfg = default_fas_uav_config();
cfg.num_realizations = 1;
cfg.Qsub = 6;

ports = select_active_ports(cfg.Q, cfg.Qsub, 'uniform');
assert(numel(ports) == cfg.Qsub, 'Active port count mismatch.');
assert(numel(unique(ports)) == cfg.Qsub, 'Active ports must be unique.');
assert(all(ports >= 1 & ports <= cfg.Q), 'Active ports must lie inside the candidate grid.');

cfg.random_seed = 42;
env1 = generate_fas_uav_environment(cfg);
H1 = generate_fas_uav_channel(cfg, ports, env1);
env2 = generate_fas_uav_environment(cfg);
H2 = generate_fas_uav_channel(cfg, ports, env2);
assert_close(H1, H2, 1e-12, 'Fixed seed must produce deterministic FAS-UAV channels.');
assert(all(size(H1) == [cfg.Qsub, cfg.P]), 'Unexpected FAS-UAV channel dimensions.');
assert(abs(norm(H1, 'fro') - sqrt(cfg.P * cfg.Qsub)) < 1e-10, ...
    'Capacity channel must use Frobenius normalization.');

cfg.normalize_channel = false;
Hraw = generate_fas_uav_channel(cfg, ports, env1);
assert(abs(norm(Hraw, 'fro') - sqrt(cfg.P * cfg.Qsub)) > 1e-6, ...
    'Raw-CIR mode must not apply capacity normalization.');

C = compute_fas_capacity(H1, cfg.snr_db, cfg.P);
assert(isfinite(C) && C >= 0, 'FAS capacity must be finite and non-negative.');

expected = 10 * log10(4);
actual = compute_modeling_error(2 * ones(2, 2), ones(2, 2));
assert(abs(actual - expected) < 1e-12, 'Modeling error must follow Eq. (14) element-wise normalization.');

fprintf('  test_fas_uav passed.\n');

function assert_close(actual, expected, tol, message)
if max(abs(actual(:) - expected(:))) > tol
    error(message);
end
end
