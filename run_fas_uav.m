clearvars -except projectRoot; close all;

if ~exist('projectRoot', 'var') || isempty(projectRoot)
    projectRoot = fileparts(mfilename('fullpath'));
end
addpath(genpath(fullfile(projectRoot, 'src')));
addpath(genpath(fullfile(projectRoot, 'scripts')));

fprintf('\n[3/3] Running FAS-UAV module...\n');
run(fullfile(projectRoot, 'scripts', 'fas_uav', 'run_modeling_error.m'));
run(fullfile(projectRoot, 'scripts', 'fas_uav', 'run_capacity_vs_ports_w.m'));
run(fullfile(projectRoot, 'scripts', 'fas_uav', 'run_capacity_vs_ports_motion.m'));
run(fullfile(projectRoot, 'scripts', 'fas_uav', 'run_capacity_fas_vs_ula.m'));
fprintf('FAS-UAV module completed.\n');
