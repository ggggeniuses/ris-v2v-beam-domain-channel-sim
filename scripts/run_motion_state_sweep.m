projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
cfg.axis.delta_t = 0:0.0005:0.08;
ensure_output_dirs(cfg);

motionStates = [ ...
    5, 5, pi/2, pi/2; ...
    10, 10, pi/2, -pi/2; ...
    20, 10, pi/3, pi/2; ...
    30, 20, 0, pi/2];
labels = {'slow same direction', 'opposite lanes', 'oblique Tx motion', 'high-speed crossing'};
curves = zeros(numel(cfg.axis.delta_t), size(motionStates, 1));

for k = 1:size(motionStates, 1)
    cfgK = cfg;
    cfgK.motion.vT = motionStates(k, 1);
    cfgK.motion.vR = motionStates(k, 2);
    cfgK.motion.eta_azi_T = motionStates(k, 3);
    cfgK.motion.eta_azi_R = motionStates(k, 4);
    resultK = compute_temporal_acf(cfgK);
    assert_no_invalid_values(resultK, sprintf('motion sweep %d', k));
    curves(:, k) = resultK.combined_bdcm(:);
end

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(cfg.axis.delta_t);
for k = 1:size(motionStates, 1)
    plot_paper_curve(cfg.axis.delta_t, curves(:, k), k, markerIdx, ...
        'DisplayName', labels{k});
end
xlabel('Time difference, $\Delta t$, [s]', 'Interpreter', 'latex');
ylabel('Temporal ACFs', 'Interpreter', 'latex');
xlim([0, 0.08]);
ylim([0, 1.03]);
lgd = legend('Location', 'northeast', 'Interpreter', 'none', 'FontSize', 10);
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'motionStates', motionStates, 'delta_t', cfg.axis.delta_t, ...
    'curves', curves, 'note', ['Extension experiment using the project compact model. ', ...
    'It studies qualitative mobility impact across representative V2V states.']);
save_experiment_outputs(fig, cfg, 'motion_state_sweep_temporal_acf_extension', data);
