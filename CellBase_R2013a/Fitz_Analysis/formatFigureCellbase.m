function formatFigureCellbase(h)
    if nargin < 2
        h = gcf;
    end
    
    scrsz = get(groot, 'ScreenSize');

    screenPosition = [50 50 scrsz(3) / 2  scrsz(4) / 2] * 1.1;

    
    ax = findobj(h, 'Type', 'Axes');
    set(ax, 'TickDir', 'out', 'LineWidth', 1, 'FontSize', 12, 'FontName', 'Calibri', 'Box', 'off');
%     set(gcf, 'Units', units, 'PaperUnits', units);
    set(gcf, 'Position', screenPosition);
