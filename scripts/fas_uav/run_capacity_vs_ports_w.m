projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_fas_uav_config();
ensure_output_dirs(cfg);

Qsub_list = 2:2:20;
W_list = [2, 6, 10, 20];
capacity = zeros(numel(Qsub_list), numel(W_list));

cfg.snr_db = 20;
for mc = 1:cfg.num_realizations
    cfgEnv = cfg;
    cfgEnv.random_seed = cfg.random_seed + mc;
    env = generate_fas_uav_environment(cfgEnv);

    for iw = 1:numel(W_list)
    for iq = 1:numel(Qsub_list)
            cfgK = cfg;
            cfgK.W = W_list(iw);
            cfgK.Qsub = Qsub_list(iq);
            active_ports = select_active_ports(cfgK.Q, cfgK.Qsub, 'uniform');
            H = generate_fas_uav_channel(cfgK, active_ports, env);
            capacity(iq, iw) = capacity(iq, iw) + compute_fas_capacity(H, cfgK.snr_db, cfgK.P);
    end
    end
end
capacity = capacity / cfg.num_realizations;
assert_numeric_finite(capacity, 'FAS-UAV capacity vs W');

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(Qsub_list);
for iw = 1:numel(W_list)
    plot_paper_curve(Qsub_list, capacity(:, iw), iw, markerIdx, ...
        'DisplayName', sprintf('$W=%d\\lambda$', W_list(iw)));
end
xlabel('Number of active ports, $Q_{\mathrm{sub}}$', 'Interpreter', 'latex');
ylabel('Channel capacity [bit/s/Hz]', 'Interpreter', 'latex');
lgd = legend('Location', 'northwest', 'Interpreter', 'latex', 'FontSize', 10);
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'Qsub_list', Qsub_list, 'W_list', W_list, 'capacity', capacity);
data.note = ['FAS-UAV module. Capacity follows the normalized log-det ', ...
    'workflow in paper Eq. (15), with common random scatterer environments ', ...
    'reused across W and Qsub within each Monte Carlo realization.'];
save_experiment_outputs(fig, cfg, 'fas_uav_capacity_vs_ports_w', data);
