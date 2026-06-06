fprintf('  test_fas_ship...\n');

cfg = default_fas_ship_config();
assert(isstruct(cfg));

risPositions = build_ris_positions(cfg, cfg.ris_locations(1, :));
assert(isequal(size(risPositions), [cfg.Mx * cfg.Mz, 3]));
assert(all(isfinite(risPositions(:))));

ports = build_ship_fas_ports(cfg, cfg.ship_position);
assert(isequal(size(ports), [cfg.Q_total, 3]));
assert(all(isfinite(ports(:))));

geometry = build_maritime_geometry(cfg, 'D0', cfg.reference_distance);
assert(all(geometry.scatterers(:, 3) >= 0.5 & ...
    geometry.scatterers(:, 3) <= 3));
assert(isfinite(compute_ris_path_response(cfg, geometry)));
assert(isfinite(compute_cluster_path_response(cfg, geometry)));

acf = compute_maritime_acf(cfg, 'D0', cfg.reference_distance, ...
    'K', 3, 'ris_center', cfg.ris_locations(1, :));
assert(all(isfinite(acf)));
assert(abs(acf(1) - 1) < 1e-12);
assert(all(acf >= 0 & acf <= 1));

result = compute_fas_selection_gain(cfg);
assert(numel(result.Qsub_list) == numel(result.capacity_mean));
assert(all(isfinite(result.capacity_mean)));
assert(all(diff(result.capacity_mean) >= -1e-12));

fprintf('  test_fas_ship passed.\n');
