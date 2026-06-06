projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
cfg.output.figureDir = fullfile(projectRoot, 'results', 'figures', 'ris_v2v');
cfg.output.dataDir = fullfile(projectRoot, 'results', 'data', 'ris_v2v');
ensure_output_dirs(cfg);

snr_db = -10:2:10;
H_G = generate_gbsm_channel_matrix(cfg);
H_B = generate_bdcm_channel_matrix(H_G);

capacity_gbsm = compute_channel_capacity(H_G, snr_db, cfg.antenna.P);
capacity_bdcm = compute_channel_capacity(H_B, snr_db, cfg.antenna.P);
assert_numeric_finite(capacity_gbsm, 'GBSM capacity extension');
assert_numeric_finite(capacity_bdcm, 'BDCM capacity extension');
capacity_gap = max(abs(capacity_gbsm - capacity_bdcm));
if capacity_gap > 1e-10
    error('Capacity invariance check failed. Max gap: %.3g', capacity_gap);
end

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(snr_db);
plot_paper_curve(snr_db, capacity_gbsm, 1, markerIdx, ...
    'DisplayName', 'GBSM array-domain channel');
plot_paper_curve(snr_db, capacity_bdcm, 2, markerIdx, ...
    'DisplayName', 'BDCM beam-domain channel');
xlabel('SNR [dB]', 'Interpreter', 'latex');
ylabel('Channel capacity [bit/s/Hz]', 'Interpreter', 'latex');
lgd = legend('Location', 'northwest', 'Interpreter', 'latex', 'FontSize', 10);
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'snr_db', snr_db, 'H_G', H_G, 'H_B', H_B, ...
    'capacity_gbsm', capacity_gbsm, 'capacity_bdcm', capacity_bdcm, ...
    'capacity_gap', capacity_gap);
data.note = ['Extension experiment. Because the BDCM matrix is produced by ', ...
    'unitary DFT transforms, ideal MIMO capacity is invariant up to numerical ', ...
    'precision. This is a sanity check, not a BDCM capacity-gain claim.'];
save_experiment_outputs(fig, cfg, 'channel_capacity_gbsm_bdcm_extension', data);
