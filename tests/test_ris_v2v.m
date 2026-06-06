fprintf('  test_ris_v2v...\n');

cfg = default_ris_v2v_config();
H_G = generate_gbsm_channel_matrix(cfg);
H_B = generate_bdcm_channel_matrix(H_G);
snr_db = -5:5:10;
C_G = compute_channel_capacity(H_G, snr_db, cfg.antenna.P);
C_B = compute_channel_capacity(H_B, snr_db, cfg.antenna.P);

assert(all(size(H_G) == [cfg.antenna.Q, cfg.antenna.P]), 'Unexpected GBSM channel dimensions.');
assert(all(size(H_B) == size(H_G)), 'Unexpected BDCM channel dimensions.');
assert(max(abs(C_G - C_B)) < 1e-10, 'Unitary BDCM transform must preserve ideal capacity.');
assert(all(C_G >= 0) && all(C_B >= 0), 'Capacity must be non-negative.');

metrics = compute_sparsity_metrics(H_B);
assert(numel(metrics.beamsForEnergy) == numel(metrics.energyTargets), 'Missing energy-capture metrics.');
assert(all(metrics.beamsForEnergy >= 1), 'Energy-capture beam counts must be positive.');
assert(all(metrics.sparsityRatio >= 0 & metrics.sparsityRatio <= 1), 'Sparsity ratios must be in [0, 1].');

[cg, cb, roDetails] = compute_complexity_ro(cfg.antenna.P, cfg.antenna.Q, cfg.ris.Mx, cfg.ris.Mz, cfg.cluster.L);
expectedCg = cfg.ris.Mx * cfg.ris.Mz + cfg.cluster.L + 149;
expectedCb = cfg.ris.Mx * cfg.ris.Mz + cfg.cluster.L + ...
    2 * cfg.antenna.P + 2 * cfg.antenna.Q + 143;
assert(cg == expectedCg && cb == expectedCb, 'Complexity counts must match the paper per-CIR formulas.');
assert(cb > cg, 'The DFT beam-domain CIR has extra per-coefficient operations before sparsity is applied.');
assert(isfield(roDetails, 'gbsm_vlos_per_pair') && isfield(roDetails, 'bdcm_vlos_per_beam_pair'), ...
    'Complexity details must include source formula components.');

fprintf('  test_ris_v2v passed.\n');
