function Delta = compute_modeling_error(H_fas, H_ula)
%COMPUTE_MODELING_ERROR Element-wise normalized absolute error from Eq. (14).
if ~isequal(size(H_fas), size(H_ula))
    error('H_fas and H_ula must have the same size.');
end
element_error = abs(H_fas - H_ula) ./ max(abs(H_ula), eps);
Delta = 10 * log10(max(sum(element_error(:)), eps));
end
