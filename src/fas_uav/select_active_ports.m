function active_ports = select_active_ports(Q, Qsub, mode)
%SELECT_ACTIVE_PORTS Choose active FAS ports from a full candidate grid.
if nargin < 3 || isempty(mode)
    mode = 'uniform';
end
Qsub = min(max(round(Qsub), 1), Q);

switch lower(mode)
    case {'uniform', 'symmetric'}
        active_ports = unique(round(linspace(1, Q, Qsub)));
    case 'center'
        center = (Q + 1) / 2;
        active_ports = unique(round(linspace(center - (Qsub - 1) / 2, ...
            center + (Qsub - 1) / 2, Qsub)));
        active_ports = max(1, min(Q, active_ports));
    case 'random'
        active_ports = sort(randperm(Q, Qsub));
    otherwise
        error('Unknown active-port mode: %s', mode);
end

if numel(active_ports) ~= Qsub
    active_ports = unique(round(linspace(1, Q, Qsub)));
end
active_ports = active_ports(:).';
end
