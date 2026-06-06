function cfg = default_ris_v2v_config()
%DEFAULT_RIS_V2V_CONFIG Default parameters for RIS-aided V2V channel demos.
%
% The defaults follow the scale and notation of the cited RIS-V2V model.

cfg.c = 3e8;
cfg.fc = 5e9;
cfg.lambda = cfg.c / cfg.fc;
cfg.j = 1i;

cfg.motion.vT = 10;
cfg.motion.vR = 10;
cfg.motion.eta_azi_T = pi / 2;
cfg.motion.eta_ver_T = 0;
cfg.motion.eta_azi_R = pi / 2;
cfg.motion.t = 2;

cfg.antenna.P = 30;
cfg.antenna.Q = 40;
cfg.antenna.p = 1;
cfg.antenna.pPrime = 1;
cfg.antenna.q = 1;
cfg.antenna.qPrime = 1;
cfg.antenna.delta_T = cfg.lambda / 2;
cfg.antenna.delta_R = cfg.lambda / 2;
cfg.antenna.psi_azi_T = pi / 3;
cfg.antenna.psi_ver_T = pi / 4;
cfg.antenna.psi_azi_R = pi / 3;
cfg.antenna.psi_ver_R = pi / 4;

cfg.ris.x = 80;
cfg.ris.y = 30;
cfg.ris.z = 20;
cfg.ris.Mx = 30;
cfg.ris.Mz = 30;
cfg.ris.dmx = cfg.lambda / 4;
cfg.ris.dmz = cfg.lambda / 4;
cfg.ris.chi = 1;
cfg.ris.phase = 1;

cfg.cluster.L = 20;
cfg.cluster.xi_R_n_0 = 200;
cfg.cluster.mu_AAoA = 2 * pi / 3;
cfg.cluster.sigma_AAoA = 10 / 180 * pi;
cfg.cluster.mu_EAoA = pi / 6;
cfg.cluster.sigma_EAoA = 5 / 180 * pi;

cfg.geometry.H0 = 0;
cfg.geometry.D0 = 100;
cfg.geometry.K = 1;

cfg.axis.delta_q = 0:1:59;
cfg.axis.delta_t = 0:0.0004:0.04;
cfg.axis.delta_f_MHz = 0:0.15:30;

cfg.output.figureDir = fullfile(project_root(), 'results', 'figures');
cfg.output.dataDir = fullfile(project_root(), 'results', 'data');
cfg.randomSeed = 20260605;
end
