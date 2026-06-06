projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
cfg.output.figureDir = fullfile(projectRoot, 'results', 'figures', 'ris_v2v');
cfg.output.dataDir = fullfile(projectRoot, 'results', 'data', 'ris_v2v');
ensure_output_dirs(cfg);

H_G = generate_gbsm_channel_matrix(cfg);
H_B = generate_bdcm_channel_matrix(H_G);
assert_numeric_finite(abs(H_G), 'GBSM sparsity extension');
assert_numeric_finite(abs(H_B), 'BDCM sparsity extension');
sparsity_array = compute_sparsity_metrics(H_G);
sparsity_beam = compute_sparsity_metrics(H_B);

fig = create_paper_figure();
tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile;
imagesc(abs(H_G));
axis tight;
colorbar;
title('Array-domain GBSM', 'Interpreter', 'latex');
xlabel('Tx antenna index', 'Interpreter', 'latex');
ylabel('Rx antenna index', 'Interpreter', 'latex');
apply_plot_style(gca);

nexttile;
imagesc(abs(H_B));
axis tight;
colorbar;
title('Beam-domain BDCM', 'Interpreter', 'latex');
xlabel('Tx beam index', 'Interpreter', 'latex');
ylabel('Rx beam index', 'Interpreter', 'latex');
apply_plot_style(gca);

data = struct('cfg', cfg, 'H_G', H_G, 'H_B', H_B, ...
    'abs_H_G', abs(H_G), 'abs_H_B', abs(H_B), ...
    'sparsity_array', sparsity_array, 'sparsity_beam', sparsity_beam);
data.note = ['Extension experiment. The heatmaps compare the compact ', ...
    'array-domain demonstration channel and its DFT beam-domain transform. ', ...
    'The MAT output includes energy-concentration and threshold sparsity metrics.'];
save_experiment_outputs(fig, cfg, 'channel_matrix_sparsity_gbsm_bdcm_extension', data);
