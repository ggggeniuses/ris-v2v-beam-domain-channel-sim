projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_fas_uav_config();
ensure_output_dirs(cfg);

W_scan = 2:2:20;
capacity_ula = zeros(size(W_scan));
capacity_fas1_full = zeros(size(W_scan));
capacity_fas1_partial = zeros(size(W_scan));
capacity_fas2_full = zeros(size(W_scan));
capacity_fas2_partial = zeros(size(W_scan));

cfg.snr_db = 16;
for iw = 1:numel(W_scan)
    Wlambda = W_scan(iw);
    cases = make_cases(cfg, Wlambda);
    Csum = zeros(1, numel(cases));

    for mc = 1:cfg.num_realizations
        cfgEnv = cfg;
        cfgEnv.random_seed = cfg.random_seed + 3000 * iw + mc;
        env = generate_fas_uav_environment(cfgEnv);

        for ic = 1:numel(cases)
            cfgK = cfg;
            cfgK.Q = size(cases(ic).ports, 1);
            cfgK.Qsub = cases(ic).Qsub;
            cfgK.port_positions = cases(ic).ports;
            active_ports = select_active_ports(cfgK.Q, cfgK.Qsub, 'uniform');
            H = generate_fas_uav_channel(cfgK, active_ports, env);
            Csum(ic) = Csum(ic) + compute_fas_capacity(H, cfgK.snr_db, cfgK.P);
        end
    end

    Cavg = Csum / cfg.num_realizations;
    capacity_ula(iw) = Cavg(1);
    capacity_fas1_full(iw) = Cavg(2);
    capacity_fas1_partial(iw) = Cavg(3);
    capacity_fas2_full(iw) = Cavg(4);
    capacity_fas2_partial(iw) = Cavg(5);
end
capacity = [capacity_ula(:), capacity_fas1_partial(:), capacity_fas1_full(:), ...
    capacity_fas2_partial(:), capacity_fas2_full(:)];
assert_numeric_finite(capacity, 'FAS-UAV FAS vs ULA capacity');

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(W_scan);
labels = {'ULA', 'FAS1, $Q_{sub}=2Q/3$', 'FAS1, $Q_{sub}=Q$', ...
    'FAS2, $Q_{sub}=Q/3$', 'FAS2, $Q_{sub}=Q$'};
for k = 1:numel(labels)
    plot_paper_curve(W_scan, capacity(:, k), k, markerIdx, 'DisplayName', labels{k});
end
xlabel('Antenna length, $W$ [$\lambda$]', 'Interpreter', 'latex');
ylabel('Channel capacity [bit/s/Hz]', 'Interpreter', 'latex');
lgd = legend('Location', 'northwest', 'Interpreter', 'latex', 'FontSize', 9);
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'W_scan', W_scan, 'capacity', capacity, 'labels', {labels});
data.note = ['FAS-UAV module. FAS1 uses port spacing lambda/3, FAS2 uses ', ...
    'lambda/4, and ULA uses lambda/2; ', ...
    'each W point reuses common random scatterers across compared cases.'];
save_experiment_outputs(fig, cfg, 'fas_uav_capacity_fas_vs_ula', data);

function cases = make_cases(cfg, Wlambda)
cases(1) = make_case(cfg, Wlambda, 1/2, 1, 'ULA');
cases(2) = make_case(cfg, Wlambda, 1/3, 1, 'FAS1 full');
cases(3) = make_case(cfg, Wlambda, 1/3, 2/3, 'FAS1 partial');
cases(4) = make_case(cfg, Wlambda, 1/4, 1, 'FAS2 full');
cases(5) = make_case(cfg, Wlambda, 1/4, 1/3, 'FAS2 partial');
end

function s = make_case(cfg, Wlambda, spacing_lambda, active_ratio, label)
W = Wlambda * cfg.lambda;
spacing = spacing_lambda * cfg.lambda;
Q = max(2, floor(W / spacing) + 1);
rx_center = [cfg.D0, 0, 0];
rx_dir = [cos(cfg.thetaR) * cos(cfg.psiR), cos(cfg.thetaR) * sin(cfg.psiR), sin(cfg.thetaR)];
idx = ((1:Q) - (Q + 1) / 2).';
s.ports = rx_center + idx * spacing * rx_dir;
s.Qsub = max(2, round(active_ratio * Q));
s.label = label;
end
