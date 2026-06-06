fprintf('  test_common...\n');

F = dft_beamforming_matrix(8);
assert_close(F' * F, eye(8), 1e-12, 'DFT matrix must be unitary.');
assert_close(F * F', eye(8), 1e-12, 'DFT matrix inverse must be unitary.');

fprintf('  test_common passed.\n');

function assert_close(actual, expected, tol, message)
if max(abs(actual(:) - expected(:))) > tol
    error(message);
end
end
