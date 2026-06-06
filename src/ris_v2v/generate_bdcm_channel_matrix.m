function H_B = generate_bdcm_channel_matrix(H_G)
%GENERATE_BDCM_CHANNEL_MATRIX Transform array-domain channel into beam domain.
[Q, P] = size(H_G);
U = dft_beamforming_matrix(P);
V = dft_beamforming_matrix(Q);
H_B = V' * H_G * conj(U);
end
