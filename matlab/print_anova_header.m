function fileID = print_anova_header(filename)
    fileID = fopen(['../Latex/tables/' filename],'w');
    %fprintf(fileID,'\\begin{tabular}{l r r r r r r r r}\n');
    %fprintf(fileID,'Model & $\\text{SS}_\\text{eff}$ & $\\text{SS}_\\text{res}$ & $\\text{df}_\\text{eff}$ & $\\text{df}_\\text{res}$ & $\\text{MS}_\\text{eff}$ & $\\text{MS}_\\text{res}$ & $F$  &  $p$\\\\\\hline\n');
    
    fprintf(fileID,'\\begin{tabular}{l l r r r r r}\n');
    fprintf(fileID,'Resp & Src & $\\text{SS}$ & $\\text{df}$ & $\\text{MS}$ & $F$  &  $p$\\\\\\hline\n');