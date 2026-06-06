projectRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_fas_uav_config();
ensure_output_dirs(cfg);

Qsub_list = [2, 4, 8, 16];
spacing_list = linspace(0.1, 4, 40);
modeling_error = zeros(numel(spacing_list), numel(Qsub_list));

for mc = 1:cfg.num_realizations
    cfgEnv = cfg;
    cfgEnv.random_seed = cfg.random_seed + mc;
    env = generate_fas_uav_environment(cfgEnv);

    for iq = 1:numel(Qsub_list)
        for is = 1:numel(spacing_list)
            cfgF = cfg;
            cfgF.Qsub = Qsub_list(iq);
            cfgF.deltaR = spacing_list(is) * cfg.lambda;
            cfgF.normalize_channel = false;
            active_ports = select_active_ports(cfgF.Q, cfgF.Qsub, 'uniform');
            H_fas = generate_fas_uav_channel(cfgF, active_ports, env);

            cfgU = cfgF;
            cfgU.Q = cfgF.Qsub;
            cfgU.Qsub = cfgF.Qsub;
            cfgU.deltaR = cfgF.deltaR;
            H_ula = generate_fas_uav_channel(cfgU, 1:cfgU.Qsub, env);

            modeling_error(is, iq) = modeling_error(is, iq) + compute_modeling_error(H_fas, H_ula);
        end
    end
end
modeling_error = modeling_error / cfg.num_realizations;
assert_numeric_finite(modeling_error, 'FAS-UAV modeling error');

fig = create_paper_figure();
hold on;
markerIdx = paper_marker_indices(spacing_list);
for iq = 1:numel(Qsub_list)
    plot_paper_curve(spacing_list, modeling_error(:, iq), iq, markerIdx, ...
        'DisplayName', sprintf('$Q_{sub}=%d$', Qsub_list(iq)));
end
xlabel('FAS port spacing [$\lambda$]', 'Interpreter', 'latex');
ylabel('Normalized modeling error [dB]', 'Interpreter', 'latex');
lgd = legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 10);
format_paper_legend(lgd);
apply_plot_style(gca);

data = struct('cfg', cfg, 'Qsub_list', Qsub_list, 'spacing_list', spacing_list, ...
    'modeling_error', modeling_error);
data.note = ['FAS-UAV module. Modeling error follows paper Eq. (14): ', ...
    'element-wise normalized absolute difference between unnormalized FAS ', ...
    'and ULA CIRs with the same number of active receiving elements.'];
save_experiment_outputs(fig, cfg, 'fas_uav_modeling_error', data);
