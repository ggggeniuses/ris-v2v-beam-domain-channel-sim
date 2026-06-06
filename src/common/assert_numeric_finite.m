function assert_numeric_finite(value, label)
%ASSERT_NUMERIC_FINITE Check that a numeric array is nonempty and finite.
if isempty(value)
    error('%s is empty.', label);
end
if ~isnumeric(value)
    error('%s must be numeric.', label);
end
if any(~isfinite(value(:)))
    error('%s contains NaN or Inf.', label);
end
end
