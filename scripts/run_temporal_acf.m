projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
ensure_output_dirs(cfg);
result = compute_temporal_acf(cfg);
assert_no_invalid_values(result, 'RIS-V2V temporal ACF baseline');

fig = plot_correlation_result(result, ...
    'Time difference, $\Delta t$, [s]', 'Temporal ACFs', ...
    {'NLoS, GBSM', 'NLoS, BDCM', 'VLoS, GBSM', 'VLoS, BDCM', ...
    'NLoS + VLoS, GBSM', 'NLoS + VLoS, BDCM'}, [0, 0.02, 0.94, 1]);

data = struct('cfg', cfg, 'result', result, ...
    'note', 'Project model baseline for RIS-V2V temporal correlation.');
save_experiment_outputs(fig, cfg, 'temporal_acf_model_baseline', data);
