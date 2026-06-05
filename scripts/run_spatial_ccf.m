projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));
addpath(vendor_stf_cf_path('CCF'));

cfg = default_ris_v2v_config();
ensure_output_dirs(cfg);

j = sqrt(-1);
lambda = cfg.lambda;
v_T = 10;
v_R = 10;
eta_azi_T = pi/2;
eta_ver_T = 0;
eta_azi_R = pi/2;

P = 30;
Q = 100;
p = 1;
p_p = 1;
q = 1;
delta_T = lambda/2;
delta_R = lambda/2;
psi_azi_T = pi/3;
psi_ver_T = pi/4;
psi_azi_R = pi/3;
psi_ver_R = pi/4;

x_m_sub = 80;
y_m_sub = 30;
z_m_sub = 20;
chi_m_sub = 1;
varphi_m_sud = 1;

xi_R_n_0 = 200;
mu_AAoA = 2*pi/3;
sigma_AAoA = 10/180*pi;
mu_EAoA = pi/6;
sigma_EAoA = 5/180*pi;

H_0 = 0;
D_0 = 100;
K = 1;
t = 2;
tt = 0;
delta_q = 0:1:59;

rho_CCF_NLoS_cluster_GBSM = rho_CCF_cluster_GBSM(j, lambda, v_T, v_R, eta_ver_T, eta_azi_T, ...
    eta_azi_R, t, tt, xi_R_n_0, D_0, H_0, P, Q, p, q, p_p, delta_q, ...
    delta_T, delta_R, mu_AAoA, sigma_AAoA, mu_EAoA, sigma_EAoA, ...
    psi_ver_T, psi_azi_T, psi_ver_R, psi_azi_R);

rho_CCF_VLoS_RIS_GBSM = rho_CCF_RIS_GBSM(j, lambda, v_T, v_R, eta_ver_T, eta_azi_T, eta_azi_R, delta_T, ...
    delta_R, t, tt, x_m_sub, y_m_sub, z_m_sub, D_0, H_0, P, Q, p, q, p_p, delta_q, ...
    psi_ver_T, psi_azi_T, psi_ver_R, psi_azi_R, chi_m_sub, varphi_m_sud);

rho_CCF_cluster_RIS_GBSM = (1)/(K+1)*rho_CCF_NLoS_cluster_GBSM + (K)/(K+1)*rho_CCF_VLoS_RIS_GBSM;

rho_CCF_NLoS_cluster_BDCM = rho_CCF_cluster_BDCM(j, lambda, v_T, v_R, eta_ver_T, eta_azi_T, ...
    eta_azi_R, t, tt, xi_R_n_0, D_0, H_0, P, Q, p, q, p_p, delta_q, ...
    delta_T, delta_R, mu_AAoA, sigma_AAoA, mu_EAoA, sigma_EAoA, ...
    psi_ver_T, psi_azi_T, psi_ver_R, psi_azi_R);

rho_CCF_VLoS_RIS_BDCM = rho_CCF_RIS_BDCM(j, lambda, v_T, v_R, eta_ver_T, eta_azi_T, eta_azi_R, delta_T, ...
    delta_R, t, tt, x_m_sub, y_m_sub, z_m_sub, D_0, H_0, P, Q, p, q, p_p, delta_q, ...
    psi_ver_T, psi_azi_T, psi_ver_R, psi_azi_R, chi_m_sub, varphi_m_sud);

rho_CCF_cluster_RIS_BDCM = (1)/(K+1)*rho_CCF_NLoS_cluster_BDCM + (K)/(K+1)*rho_CCF_VLoS_RIS_BDCM;

fig = create_paper_figure(); hold on;
markerIdx = paper_marker_indices(delta_q);
plot_paper_curve(delta_q, abs(rho_CCF_NLoS_cluster_GBSM), 1, markerIdx);
plot_paper_curve(delta_q, abs(rho_CCF_NLoS_cluster_BDCM), 2, markerIdx);
plot_paper_curve(delta_q, abs(rho_CCF_VLoS_RIS_GBSM), 3, markerIdx);
plot_paper_curve(delta_q, abs(rho_CCF_VLoS_RIS_BDCM), 4, markerIdx);
plot_paper_curve(delta_q, abs(rho_CCF_cluster_RIS_GBSM), 5, markerIdx);
plot_paper_curve(delta_q, abs(rho_CCF_cluster_RIS_BDCM), 6, markerIdx);
axis([0 30 0 1]);
xlabel('Antenna index or beam index', 'Interpreter', 'latex');
ylabel('Spatial CCFs', 'Interpreter', 'latex');
lgd = legend({'NLoS, GBSM', 'NLoS, BDCM', 'VLoS, GBSM', 'VLoS, BDCM', ...
    'NLoS + VLoS, GBSM', 'NLoS + VLoS, BDCM'}, 'Interpreter', 'latex', 'FontSize', 10, 'Location', 'northeast');
format_paper_legend(lgd);
apply_plot_style(gca);

result = struct('axis', delta_q, ...
    'nlos_gbsm', abs(rho_CCF_NLoS_cluster_GBSM), ...
    'nlos_bdcm', abs(rho_CCF_NLoS_cluster_BDCM), ...
    'vlos_gbsm', abs(rho_CCF_VLoS_RIS_GBSM), ...
    'vlos_bdcm', abs(rho_CCF_VLoS_RIS_BDCM), ...
    'combined_gbsm', abs(rho_CCF_cluster_RIS_GBSM), ...
    'combined_bdcm', abs(rho_CCF_cluster_RIS_BDCM));
data = struct('cfg', cfg, 'result', result, 'source', 'vendor/original_stf_cf/CCF/CCF_GBSM_BDCM');
save_experiment_outputs(fig, cfg, 'spatial_ccf_gbsm_bdcm_strict', data);
