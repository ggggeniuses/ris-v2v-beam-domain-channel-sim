function fig = plot_correlation_result(result, xLabelText, yLabelText, legendLabels, axisLimits)
%PLOT_CORRELATION_RESULT Plot NLoS/VLoS/combined GBSM and BDCM curves.
fig = create_paper_figure();
hold on;

markerIdx = paper_marker_indices(result.axis);
plot_paper_curve(result.axis, result.nlos_gbsm, 1, markerIdx);
plot_paper_curve(result.axis, result.nlos_bdcm, 2, markerIdx);
plot_paper_curve(result.axis, result.vlos_gbsm, 3, markerIdx);
plot_paper_curve(result.axis, result.vlos_bdcm, 4, markerIdx);
plot_paper_curve(result.axis, result.combined_gbsm, 5, markerIdx);
plot_paper_curve(result.axis, result.combined_bdcm, 6, markerIdx);

xlabel(xLabelText, 'Interpreter', 'latex');
ylabel(yLabelText, 'Interpreter', 'latex');
if nargin >= 5 && ~isempty(axisLimits)
    axis(axisLimits);
end
lgd = legend(legendLabels, 'Location', 'northeast', ...
    'Interpreter', 'latex', 'FontSize', 9);
format_paper_legend(lgd);
apply_plot_style(gca);
end
