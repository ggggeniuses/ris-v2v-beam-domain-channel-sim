function cfg = default_fas_uav_config()
%DEFAULT_FAS_UAV_CONFIG Default parameters for FAS-UAV channel experiments.
cfg.fc = 5e9;
cfg.c = 3e8;
cfg.lambda = cfg.c / cfg.fc;

cfg.H0 = 20;
cfg.D0 = 50;

cfg.P = 4;
cfg.Q = 20;
cfg.deltaT = cfg.lambda / 2;

cfg.psiT = pi / 2;
cfg.thetaT = pi / 3;
cfg.psiR = 0;
cfg.thetaR = 0;

cfg.vT = 3;
cfg.etaT = pi / 3;
cfg.gammaT = pi / 3;
cfg.t = 2;

cfg.snr_db = 20;
cfg.K = 1;
cfg.W = 10;
cfg.Qsub = 10;
cfg.normalize_channel = true;

cfg.num_clusters = 6;
cfg.rays_per_cluster = 10;
cfg.kappa = 8;
cfg.scatter_radius = 35;
cfg.random_seed = 20260605;

profile = lower(strtrim(getenv('FAS_UAV_PROFILE')));
if isempty(profile)
    profile = 'quick';
end
cfg.profile = profile;
switch profile
    case 'final'
        cfg.num_realizations = 300;
    case 'calibration'
        cfg.num_realizations = 30;
    otherwise
        cfg.profile = 'quick';
        cfg.num_realizations = 4;
end

cfg.output.figureDir = fullfile(project_root(), 'results', 'figures', 'fas_uav');
cfg.output.dataDir = fullfile(project_root(), 'results', 'data', 'fas_uav');
end
