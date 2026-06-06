fprintf('  test_output_manifest...\n');

cfg = default_ris_v2v_config();
risRoot = cfg.output.dataDir;
risV2vRoot = fullfile(risRoot, 'ris_v2v');
fasRoot = fullfile(risRoot, 'fas_uav');

required = { ...
    fullfile(risRoot, 'spatial_ccf_model_baseline.mat'), ...
    fullfile(risRoot, 'temporal_acf_model_baseline.mat'), ...
    fullfile(risRoot, 'frequency_fcf_model_baseline.mat'), ...
    fullfile(risV2vRoot, 'channel_capacity_gbsm_bdcm_extension.mat'), ...
    fullfile(risV2vRoot, 'channel_matrix_sparsity_gbsm_bdcm_extension.mat'), ...
    fullfile(fasRoot, 'fas_uav_modeling_error.mat'), ...
    fullfile(fasRoot, 'fas_uav_capacity_vs_ports_w.mat'), ...
    fullfile(fasRoot, 'fas_uav_capacity_vs_ports_motion.mat'), ...
    fullfile(fasRoot, 'fas_uav_capacity_fas_vs_ula.mat')};

for k = 1:numel(required)
    if ~exist(required{k}, 'file')
        error('Missing expected output file: %s', required{k});
    end
    saved = load(required{k}, 'cfg');
    if isfield(saved, 'cfg') && isfield(saved.cfg, 'output')
        paths = {saved.cfg.output.figureDir, saved.cfg.output.dataDir};
        assert(all(cellfun(@(p) ~is_absolute_path(p), paths)), ...
            'Saved MAT configuration must use repository-relative output paths.');
    end
end

requiredFigures = { ...
    fullfile(cfg.output.figureDir, 'spatial_ccf_model_baseline.png'), ...
    fullfile(cfg.output.figureDir, 'temporal_acf_model_baseline.png'), ...
    fullfile(cfg.output.figureDir, 'frequency_fcf_model_baseline.png')};
for k = 1:numel(requiredFigures)
    info = dir(requiredFigures{k});
    if isempty(info) || info.bytes < 20000
        error('Missing or suspiciously small figure: %s', requiredFigures{k});
    end
end

cap = load(fullfile(risV2vRoot, 'channel_capacity_gbsm_bdcm_extension.mat'));
assert(isfield(cap, 'capacity_gap') && cap.capacity_gap < 1e-10, ...
    'RIS capacity output must include a passing capacity-invariance gap.');

sparse = load(fullfile(risV2vRoot, 'channel_matrix_sparsity_gbsm_bdcm_extension.mat'));
assert(isfield(sparse, 'sparsity_beam') && isfield(sparse, 'sparsity_array'), ...
    'Sparsity output must include quantitative sparsity metrics.');

complexity = load(fullfile(risV2vRoot, 'complexity_comparison_extension.mat'));
assert(isfield(complexity, 'complexity_details') && ~isempty(complexity.complexity_details), ...
    'Complexity output must include source formula details.');

fas = load(fullfile(fasRoot, 'fas_uav_modeling_error.mat'));
assert(isfield(fas, 'modeling_error') && all(isfinite(fas.modeling_error(:))), ...
    'FAS modeling-error output must include finite curve data.');

fprintf('  test_output_manifest passed.\n');

function tf = is_absolute_path(pathValue)
tf = startsWith(pathValue, filesep) || ...
    (~isempty(regexp(pathValue, '^[A-Za-z]:[\\/]', 'once')));
end
