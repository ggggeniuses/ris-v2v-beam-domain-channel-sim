function metrics = compute_sparsity_metrics(H, topKList, thresholds, energyTargets)
%COMPUTE_SPARSITY_METRICS Quantify beam-domain energy concentration.
if nargin < 2 || isempty(topKList)
    topKList = [1, 4, 8, 16];
end
if nargin < 3 || isempty(thresholds)
    thresholds = [0.01, 0.05, 0.10];
end
if nargin < 4 || isempty(energyTargets)
    energyTargets = [0.90, 0.95, 0.99];
end

power = abs(H(:)).^2;
total = sum(power);
if total <= eps
    error('Cannot compute sparsity metrics for a zero channel.');
end
sortedPower = sort(power, 'descend');
cumulative = cumsum(sortedPower) / total;
normalizedMagnitude = abs(H(:)) / max(abs(H(:)));

topEnergy = zeros(size(topKList));
for k = 1:numel(topKList)
    kk = min(max(round(topKList(k)), 1), numel(sortedPower));
    topEnergy(k) = sum(sortedPower(1:kk)) / total;
end

sparsityRatio = zeros(size(thresholds));
for k = 1:numel(thresholds)
    sparsityRatio(k) = mean(normalizedMagnitude >= thresholds(k));
end

beamsForEnergy = zeros(size(energyTargets));
for k = 1:numel(energyTargets)
    idx = find(cumulative >= energyTargets(k), 1, 'first');
    beamsForEnergy(k) = idx;
end

metrics = struct();
metrics.topKList = topKList;
metrics.topEnergy = topEnergy;
metrics.thresholds = thresholds;
metrics.sparsityRatio = sparsityRatio;
metrics.energyTargets = energyTargets;
metrics.beamsForEnergy = beamsForEnergy;
metrics.totalCoefficients = numel(power);
end
