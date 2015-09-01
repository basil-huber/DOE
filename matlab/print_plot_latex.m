function print_plot_latex(filename)
    matlab2tikz(['../Latex/images/' filename],'width','\figW', 'height','\figH','showInfo', false,'extraAxisOptions',{'xlabel shift={-4pt}','ylabel shift={-5pt}'});
end