function print_anova_latex(E, result, coeffs, fileID, resp_name, suffix)
     [~,SS,DL,MS,F,p]= anova_doe(E, result, coeffs,1);
     
     %fileID = fopen(filename,'a');
     %fileID = 1;
     % print header
     %fprintf(fileID,'%10s\t & %-8s\t & %-8s\t & %-8s\t & %-8s\t & %-8s \\\\\\hline\n','Source','SS','df','MS','F','p')
     
    % print data
    fprintf(fileID,'%10s\t & $%10s%10s\t$ & %-3.4g\t & %-3.4g\t & %-3.4g\t & %-3.4g\t & %-3.2g\\\\\n', resp_name, '\alpha', suffix , SS(1),DL(1),MS(1),F(1),p(1));
    fprintf(fileID,'%10s\t & $%10s%10s\t$ & %-3.4g\t & %-3.4g\t & %-3.4g \\\\ \n','','R' ,suffix ,SS(2),DL(2),MS(2));
    %fprintf(1,'%10s\t  %-6.3g\t  %-6.3g\n\n','Mesure',SS(3),DL(3));

     
     %fprintf(fileID,'%10s\t & %-6.2g\t & %-6.2g\t & %-6.2g\t & %-6.2g\t & %-6.2g & %-6.2g\t & %-6.2g\t & %-6.2g\t\\\\\n',modelname,SS(1), SS(2), DL(1), DL(2), MS(1), MS(2), F(1),p(1));