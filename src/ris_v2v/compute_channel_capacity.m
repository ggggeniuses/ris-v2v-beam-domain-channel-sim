function C = compute_channel_capacity(H, snr_db, P)
%COMPUTE_CHANNEL_CAPACITY MIMO capacity from channel singular values.
if nargin < 3 || isempty(P)
    P = size(H, 2);
end

snr_linear = 10.^(snr_db ./ 10);
gram = H * H';
eigvals = real(eig((gram + gram') / 2));
eigvals = max(eigvals, 0);

C = zeros(size(snr_linear));
for k = 1:numel(snr_linear)
    C(k) = sum(log2(1 + snr_linear(k) / P * eigvals));
end
end
