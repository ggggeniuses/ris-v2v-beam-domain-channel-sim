projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
cfg.axis.delta_t = 0:0.001:0.2;
ensure_output_dirs(cfg);

risSizes = [8, 16, 32, 64];
curves = zeros(numel(cfg.axis.delta_t), numel(risSizes));

for k = 1:numel(risSizes)
    cfgK = cfg;
    cfgK.ris.Mx = risSizes(k);
    cfgK.ris.Mz = risSizes(k);
    resultK = compute_temporal_acf(cfgK);
    assert_no_invalid_values(resultK, sprintf('RIS sweep M=%d', risSizes(k)));
    curves(:, k) = resultK.vlos_bdcm(:);
end

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(cfg.axis.delta_t);
for k = 1:numel(risSizes)
    plot_paper_curve(cfg.axis.delta_t, curves(:, k), k, markerIdx, ...
        'DisplayName', sprintf('$M_x=M_z=%d$', risSizes(k)));
end
xlabel('Time difference, $\Delta t$, [s]', 'Interpreter', 'latex');
ylabel('Temporal ACFs', 'Interpreter', 'latex');
xlim([0, 0.2]);
ylim([0.84, 1.01]);
lgd = legend('Location', 'northeast', 'Interpreter', 'latex', 'FontSize', 10);
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'risSizes', risSizes, 'delta_t', cfg.axis.delta_t, 'curves', curves);
data.note = ['Project RIS-array geometry sweep. The plotted curves isolate ', ...
    'the RIS-assisted VLoS component to make the aperture effect visible.'];
save_experiment_outputs(fig, cfg, 'ris_parameter_sweep_temporal_acf_extension', data);
