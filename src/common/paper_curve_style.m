function style = paper_curve_style(index)
%PAPER_CURVE_STYLE Multi-color line styles for paper-style comparison plots.
colors = [ ...
    0.00, 0.00, 0.00;  % black
    0.88, 0.10, 0.10;  % red
    0.00, 0.26, 0.72;  % blue
    0.23, 0.62, 0.20;  % green
    0.55, 0.14, 0.78;  % purple
    0.92, 0.45, 0.05]; % orange
lineStyles = {'-', '-', '--', '-.', ':', '--'};
markers = {'x', '*', 's', '>', 'd', 'o'};

k = mod(index - 1, size(colors, 1)) + 1;
style.color = colors(k, :);
style.lineStyle = lineStyles{k};
style.marker = markers{k};
end
