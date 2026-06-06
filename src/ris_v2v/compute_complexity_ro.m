function [complexity_gbsm, complexity_bdcm, details] = compute_complexity_ro(P, Q, Mx, Mz, LN)
%COMPUTE_COMPLEXITY_RO Real-operation comparison from RIS-V2V Eq. (48).
%
% Source formulas in Sec. V-E:
%   C_G,VLoS = Mx*Mz + 75
%   C_G,NLoS = LN + 74
%   C_B,VLoS = Mx*Mz + P + Q + 72
%   C_B,NLoS = LN + P + Q + 71
%
% Both outputs use the same per-CIR counting basis. Full-matrix and
% sparsity-aware totals are constructed by the calling experiment.
if nargin < 5
    LN = 20;
end

M = Mx * Mz;

gbsm_vlos_per_pair = M + 75;
gbsm_nlos_per_pair = LN + 74;
bdcm_vlos_per_beam_pair = M + P + Q + 72;
bdcm_nlos_per_beam_pair = LN + P + Q + 71;

complexity_gbsm = gbsm_vlos_per_pair + gbsm_nlos_per_pair;
complexity_bdcm = bdcm_vlos_per_beam_pair + bdcm_nlos_per_beam_pair;

details = struct();
details.source = 'RIS-V2V paper Sec. V-E, Eq. (48) and following RO counts';
details.M = M;
details.numPairs = P .* Q;
details.gbsm_vlos_per_pair = gbsm_vlos_per_pair;
details.gbsm_nlos_per_pair = gbsm_nlos_per_pair;
details.bdcm_vlos_per_beam_pair = bdcm_vlos_per_beam_pair;
details.bdcm_nlos_per_beam_pair = bdcm_nlos_per_beam_pair;
details.total_convention = 'Both returned values are per-CIR real-operation counts.';
end
