function print_anova_latex(E, result, coeffs, filename)
     [~,SS,DL,MS,F,p]= anova_doe(E, result, coeffs,1);
     
     fileID = fopen(filename,'w');
     %fileID = 1;
     % print header
     fprintf(fileID,'%10s\t & %-8s\t & %-8s\t & %-8s\t & %-8s\t & %-8s \\\\\\hline\n','Source','SS','df','MS','F','p')
     
     % print data
     fprintf(fileID,'%10s\t & %-6.3g\t & %-6.3g\t & %-6.3g\t & %-6.3g\t & %-6.3g\\\\\n','Constant',SS(1),DL(1),MS(1),F(1),p(1));
     fprintf(fileID,'%10s\t & %-6.3g\t & %-6.3g\t & %-6.3g \n','Residue',SS(2),DL(2),MS(2));
    %fprintf(1,'%10s\t  %-6.3g\t  %-6.3g\n\n','Mesure',SS(3),DL(3));
