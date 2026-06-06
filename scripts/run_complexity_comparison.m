projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
cfg.output.figureDir = fullfile(projectRoot, 'results', 'figures', 'ris_v2v');
cfg.output.dataDir = fullfile(projectRoot, 'results', 'data', 'ris_v2v');
ensure_output_dirs(cfg);

Q_list = 10:10:100;
P = cfg.antenna.P;
Mx = cfg.ris.Mx;
Mz = cfg.ris.Mz;
LN = cfg.cluster.L;

complexity_gbsm_full = zeros(size(Q_list));
complexity_bdcm_full = zeros(size(Q_list));
complexity_bdcm_sparse95 = zeros(size(Q_list));
retained_beam_pairs_95 = zeros(size(Q_list));
complexity_details = cell(size(Q_list));
for k = 1:numel(Q_list)
    [gbsmPerCir, bdcmPerCir, complexity_details{k}] = ...
        compute_complexity_ro(P, Q_list(k), Mx, Mz, LN);

    cfgQ = cfg;
    cfgQ.antenna.Q = Q_list(k);
    H_B = generate_bdcm_channel_matrix(generate_gbsm_channel_matrix(cfgQ));
    sparsity = compute_sparsity_metrics(H_B);
    targetIndex = find(abs(sparsity.energyTargets - 0.95) < 1e-12, 1);
    retained_beam_pairs_95(k) = sparsity.beamsForEnergy(targetIndex);

    numPairs = P * Q_list(k);
    complexity_gbsm_full(k) = numPairs * gbsmPerCir;
    complexity_bdcm_full(k) = numPairs * bdcmPerCir;
    complexity_bdcm_sparse95(k) = retained_beam_pairs_95(k) * bdcmPerCir;
    complexity_details{k}.sparsity = sparsity;
end
assert_numeric_finite(complexity_gbsm_full, 'GBSM complexity extension');
assert_numeric_finite(complexity_bdcm_full, 'full BDCM complexity extension');
assert_numeric_finite(complexity_bdcm_sparse95, 'sparse BDCM complexity extension');

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(Q_list);
semilogy(Q_list, complexity_gbsm_full, '-o', 'LineWidth', 1.6, 'MarkerIndices', markerIdx, ...
    'DisplayName', 'Full GBSM');
semilogy(Q_list, complexity_bdcm_full, '--s', 'LineWidth', 1.6, 'MarkerIndices', markerIdx, ...
    'DisplayName', 'Full BDCM');
semilogy(Q_list, complexity_bdcm_sparse95, '-.^', 'LineWidth', 1.6, 'MarkerIndices', markerIdx, ...
    'DisplayName', 'Sparse BDCM (95\% energy)');
set(gca, 'YScale', 'log');
xlabel('Number of receiving antenna elements, $Q$', 'Interpreter', 'latex');
ylabel('Number of real operations', 'Interpreter', 'latex');
lgd = legend('Location', 'northwest', 'Interpreter', 'latex', 'FontSize', 10);
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'Q_list', Q_list, 'P', P, 'Mx', Mx, 'Mz', Mz, ...
    'LN', LN, 'complexity_gbsm_full', complexity_gbsm_full, ...
    'complexity_bdcm_full', complexity_bdcm_full, ...
    'complexity_bdcm_sparse95', complexity_bdcm_sparse95, ...
    'retained_beam_pairs_95', retained_beam_pairs_95, ...
    'complexity_details', {complexity_details});
data.note = ['Extension experiment using the RIS-V2V paper Sec. V-E / Eq. (48) ', ...
    'per-CIR real-operation counts. Full models use P*Q coefficients. The ', ...
    'sparse BDCM curve retains the measured number of coefficients required ', ...
    'to capture 95% of beam-domain energy in the compact demonstration channel.'];
save_experiment_outputs(fig, cfg, 'complexity_comparison_extension', data);
