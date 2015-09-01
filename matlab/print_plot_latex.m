function print_plot_latex(filename)
    matlab2tikz(filename,'width','\figW', 'height','\figH','showInfo', false,'extraAxisOptions','xlabel shift={-4pt}');
end