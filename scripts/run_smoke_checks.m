projectRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(projectRoot, 'src')));

cfg = default_ris_v2v_config();
requiredData = { ...
    'spatial_ccf_model_baseline.mat', ...
    'temporal_acf_model_baseline.mat', ...
    'frequency_fcf_model_baseline.mat', ...
    'ris_parameter_sweep_temporal_acf_extension.mat', ...
    'ris_spacing_sweep_temporal_acf_extension.mat', ...
    'motion_state_sweep_temporal_acf_extension.mat'};

requiredRisV2vData = { ...
    'channel_capacity_gbsm_bdcm_extension.mat', ...
    'channel_matrix_sparsity_gbsm_bdcm_extension.mat', ...
    'complexity_comparison_extension.mat'};

requiredFasUavData = { ...
    'fas_uav_modeling_error.mat', ...
    'fas_uav_capacity_vs_ports_w.mat', ...
    'fas_uav_capacity_vs_ports_motion.mat', ...
    'fas_uav_capacity_fas_vs_ula.mat'};

fprintf('\nRunning smoke checks...\n');
for k = 1:numel(requiredData)
    matPath = fullfile(cfg.output.dataDir, requiredData{k});
    if ~exist(matPath, 'file')
        error('Missing expected data output: %s', matPath);
    end
    s = load(matPath);
    if isfield(s, 'result')
        assert_result_struct(s.result, requiredData{k});
    elseif isfield(s, 'curves')
        if isempty(s.curves) || any(~isfinite(s.curves(:)))
            error('Invalid extension curves in %s', requiredData{k});
        end
    else
        error('Unexpected output shape in %s', requiredData{k});
    end
end
for k = 1:numel(requiredRisV2vData)
    matPath = fullfile(cfg.output.dataDir, 'ris_v2v', requiredRisV2vData{k});
    if ~exist(matPath, 'file')
        error('Missing expected RIS-V2V data output: %s', matPath);
    end
    s = load(matPath);
    assert_no_invalid_numeric_fields(s, requiredRisV2vData{k});
end
for k = 1:numel(requiredFasUavData)
    matPath = fullfile(cfg.output.dataDir, 'fas_uav', requiredFasUavData{k});
    if ~exist(matPath, 'file')
        error('Missing expected FAS-UAV data output: %s', matPath);
    end
    s = load(matPath);
    assert_no_invalid_numeric_fields(s, requiredFasUavData{k});
end
fprintf('Smoke checks passed.\n');

function assert_result_struct(result, label)
if contains(label, 'frequency_fcf')
    fields = {'nlos_gbsm', 'vlos_gbsm', 'combined_gbsm'};
else
    fields = {'nlos_gbsm', 'nlos_bdcm', 'vlos_gbsm', 'vlos_bdcm', 'combined_gbsm', 'combined_bdcm'};
end
for i = 1:numel(fields)
    if ~isfield(result, fields{i})
        error('%s missing field %s', label, fields{i});
    end
    values = result.(fields{i});
    if isempty(values) || any(~isfinite(values(:)))
        error('%s field %s is empty or invalid', label, fields{i});
    end
end
end

function assert_no_invalid_numeric_fields(s, label)
fields = fieldnames(s);
for i = 1:numel(fields)
    values = s.(fields{i});
    if isnumeric(values) && ~isempty(values) && any(~isfinite(values(:)))
        error('%s field %s contains NaN or Inf.', label, fields{i});
    end
end
end
