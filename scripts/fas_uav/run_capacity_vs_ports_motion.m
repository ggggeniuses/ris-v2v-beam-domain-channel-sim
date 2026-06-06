projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_fas_uav_config();
ensure_output_dirs(cfg);

Qsub_list = 2:2:20;
motion_cases = { ...
    struct('vT', 1, 't', 1, 'label', '$v_T=1$ m/s, $t=1$ s'), ...
    struct('vT', 1, 't', 2, 'label', '$v_T=1$ m/s, $t=2$ s'), ...
    struct('vT', 3, 't', 1, 'label', '$v_T=3$ m/s, $t=1$ s'), ...
    struct('vT', 3, 't', 2, 'label', '$v_T=3$ m/s, $t=2$ s')};
capacity = zeros(numel(Qsub_list), numel(motion_cases));

cfg.snr_db = 15;
for mc = 1:cfg.num_realizations
    cfgEnv = cfg;
    cfgEnv.random_seed = cfg.random_seed + mc;
    env = generate_fas_uav_environment(cfgEnv);

    for im = 1:numel(motion_cases)
        for iq = 1:numel(Qsub_list)
            cfgK = cfg;
            cfgK.W = 10;
            cfgK.Qsub = Qsub_list(iq);
            cfgK.vT = motion_cases{im}.vT;
            cfgK.t = motion_cases{im}.t;
            active_ports = select_active_ports(cfgK.Q, cfgK.Qsub, 'uniform');
            H = generate_fas_uav_channel(cfgK, active_ports, env);
            capacity(iq, im) = capacity(iq, im) + compute_fas_capacity(H, cfgK.snr_db, cfgK.P);
        end
    end
end
capacity = capacity / cfg.num_realizations;
assert_numeric_finite(capacity, 'FAS-UAV capacity vs motion');

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(Qsub_list);
for im = 1:numel(motion_cases)
    plot_paper_curve(Qsub_list, capacity(:, im), im, markerIdx, ...
        'DisplayName', motion_cases{im}.label);
end
xlabel('Number of active ports, $Q_{\mathrm{sub}}$', 'Interpreter', 'latex');
ylabel('Channel capacity [bit/s/Hz]', 'Interpreter', 'latex');
lgd = legend('Location', 'southeast', 'Interpreter', 'latex', 'FontSize', 10);
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'Qsub_list', Qsub_list, 'motion_cases', {motion_cases}, ...
    'capacity', capacity);
data.note = ['FAS-UAV module with common random scatterers reused across ', ...
    'the compared motion states.'];
save_experiment_outputs(fig, cfg, 'fas_uav_capacity_vs_ports_motion', data);
