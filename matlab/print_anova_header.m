function fileID = print_anova_header(filename)
    fileID = fopen(['../Latex/tables/' filename],'w');
    %fprintf(fileID,'\\begin{tabular}{l r r r r r r r r}\n');
    %fprintf(fileID,'Model & $\\text{SS}_\\text{eff}$ & $\\text{SS}_\\text{res}$ & $\\text{df}_\\text{eff}$ & $\\text{df}_\\text{res}$ & $\\text{MS}_\\text{eff}$ & $\\text{MS}_\\text{res}$ & $F$  &  $p$\\\\\\hline\n');
    
    col_width = 8;
    %@{\\hspace{%dpt}}
    fprintf(fileID,'\\begin{tabular}{@{} l @{\\hspace{%dpt}} l @{\\hspace{%dpt}} r @{\\hspace{%dpt}} r @{\\hspace{%dpt}} r @{\\hspace{%dpt}} r r @{}}\n',col_width, col_width, col_width, col_width, col_width);%, col_width, col_width, col_width, col_width ,col_width, col_width, col_width/2);
    fprintf(fileID,'Resp & Src & $\\text{SS}$ & $\\text{df}$ & $\\text{MS}$ & $F$  &  $p$\\\\\\hline\n');