clear; clc; close all;

projectRoot = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(projectRoot, 'src')));

fprintf('RIS-V2V beam-domain channel simulation\n');
fprintf('Project root: %s\n', projectRoot);
fprintf('Running RIS-V2V, FAS-UAV, and maritime RIS-FAS project models.\n');

run(fullfile(projectRoot, 'run_benchmarks.m'));
run(fullfile(projectRoot, 'run_extensions.m'));
if exist(fullfile(projectRoot, 'run_fas_uav.m'), 'file')
    run(fullfile(projectRoot, 'run_fas_uav.m'));
end
if exist(fullfile(projectRoot, 'run_fas_ship.m'), 'file')
    run(fullfile(projectRoot, 'run_fas_ship.m'));
end
run(fullfile(projectRoot, 'scripts', 'run_smoke_checks.m'));

fprintf('\nAll experiments finished. Figures: %s\n', fullfile(projectRoot, 'results', 'figures'));
fprintf('Data files: %s\n', fullfile(projectRoot, 'results', 'data'));
