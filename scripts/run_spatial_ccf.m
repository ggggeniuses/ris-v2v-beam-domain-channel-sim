projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
ensure_output_dirs(cfg);
result = compute_spatial_ccf(cfg);
assert_no_invalid_values(result, 'RIS-V2V spatial CCF baseline');

fig = plot_correlation_result(result, ...
    'Antenna index or beam index', 'Spatial CCFs', ...
    {'NLoS, GBSM', 'NLoS, BDCM', 'VLoS, GBSM', 'VLoS, BDCM', ...
    'NLoS + VLoS, GBSM', 'NLoS + VLoS, BDCM'}, [0, 30, 0, 1]);

data = struct('cfg', cfg, 'result', result, ...
    'note', 'Project model baseline for RIS-V2V spatial correlation.');
save_experiment_outputs(fig, cfg, 'spatial_ccf_model_baseline', data);
