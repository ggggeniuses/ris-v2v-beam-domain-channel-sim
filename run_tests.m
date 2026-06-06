clear; clc; close all;

projectRoot = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(projectRoot, 'src')));
addpath(genpath(fullfile(projectRoot, 'tests')));

fprintf('Running project validation tests...\n');
run(fullfile(projectRoot, 'tests', 'test_common.m'));
run(fullfile(projectRoot, 'tests', 'test_ris_v2v.m'));
run(fullfile(projectRoot, 'tests', 'test_fas_uav.m'));
run(fullfile(projectRoot, 'tests', 'test_output_manifest.m'));
fprintf('All validation tests passed.\n');
