projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
ensure_output_dirs(cfg);
result = compute_frequency_fcf(cfg);
assert_no_invalid_values(result, 'RIS-V2V frequency FCF baseline');

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(result.axis);
plot_paper_curve(result.axis, result.nlos_gbsm, 1, markerIdx);
plot_paper_curve(result.axis, result.nlos_bdcm, 2, markerIdx);
plot_paper_curve(result.axis, result.vlos_gbsm, 3, markerIdx);
plot_paper_curve(result.axis, result.vlos_bdcm, 4, markerIdx);
plot_paper_curve(result.axis, result.combined_gbsm, 5, markerIdx);
plot_paper_curve(result.axis, result.combined_bdcm, 6, markerIdx);
axis([0, 10, 0, 1]);
xlabel('Frequency difference, $\Delta f$, [MHz]', 'Interpreter', 'latex');
ylabel('Normalized FCFs', 'Interpreter', 'latex');
lgd = legend({'NLoS, GBSM', 'NLoS, BDCM', 'VLoS, GBSM', 'VLoS, BDCM', ...
    'NLoS + VLoS, GBSM', 'NLoS + VLoS, BDCM'}, ...
    'Interpreter', 'latex', 'FontSize', 10, 'Location', 'northeast');
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'result', result, ...
    'note', 'Project model baseline for RIS-V2V frequency correlation.');
save_experiment_outputs(fig, cfg, 'frequency_fcf_model_baseline', data);
