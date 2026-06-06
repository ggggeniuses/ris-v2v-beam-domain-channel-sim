function F = dft_beamforming_matrix(N)
%DFT_BEAMFORMING_MATRIX Unit-norm DFT-like beamforming matrix.
if nargin < 1 || N <= 0 || N ~= round(N)
    error('N must be a positive integer.');
end

n = 0:N-1;
k = 0:N-1;
F = exp(-1i * 2 * pi / N * (n.' * k)) / sqrt(N);
end
