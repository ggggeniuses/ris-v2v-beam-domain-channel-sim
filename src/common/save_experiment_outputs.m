function save_experiment_outputs(fig, cfg, stem, data)
%SAVE_EXPERIMENT_OUTPUTS Save a figure as FIG/PNG and matching MAT data.
ensure_output_dirs(cfg);
figPath = fullfile(cfg.output.figureDir, [stem, '.fig']);
pngPath = fullfile(cfg.output.figureDir, [stem, '.png']);
matPath = fullfile(cfg.output.dataDir, [stem, '.mat']);

delete_if_exists(figPath);
delete_if_exists(pngPath);
delete_if_exists(matPath);

savefig(fig, figPath);
exportgraphics(fig, pngPath, 'Resolution', 300);
data = sanitize_saved_config(data);
save(matPath, '-struct', 'data');
fprintf('Saved %s\n', pngPath);
end

function delete_if_exists(path)
if exist(path, 'file')
    delete(path);
end
end

function data = sanitize_saved_config(data)
if ~isfield(data, 'cfg') || ~isfield(data.cfg, 'output')
    return;
end
root = project_root();
fields = {'figureDir', 'dataDir'};
for k = 1:numel(fields)
    field = fields{k};
    if isfield(data.cfg.output, field)
        value = data.cfg.output.(field);
        prefix = [root, filesep];
        if startsWith(value, prefix)
            data.cfg.output.(field) = value(numel(prefix) + 1:end);
        end
    end
end
end
