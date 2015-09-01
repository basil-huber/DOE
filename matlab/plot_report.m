close all
clc
colorList = {'r', 'g', 'b', 'm', 'c', 'y', 'k','r', 'g', 'b', 'm', 'c', 'y', 'k'};
addpath('matlab2tikz')
%% -----------------------------------------
%        print effects
% ----------------------------------------
if(0)
    y_lim_effects = [-3 3];
    i = 1;
    j = 1;

    labels_a = {'$a_0$', '$a_1$', '$a_2$', '$a_3$', '$a_{12}$', '$a_{13}$', '$a_{23}$', '$a_{11}$', '$a_{22}$', '$a_{33}$'};
    labels_b = {'$b_0$', '$b_1$', '$b_2$', '$b_3$', '$b_{12}$', '$b_{13}$', '$b_{23}$', '$b_{11}$', '$b_{22}$', '$b_{33}$'};

    width1 = 0.5;
    bar([1:m(i).coeff_count],m(i).resp(j).effects/m(i).resp(j).effects(1),width1,'FaceColor',[0.2,0.2,0.5])
    hold on
    bar([1 3 4],m(4).resp(j).effects/m(i).resp(j).effects(1),width1/2,'FaceColor',[0,0.7,0.7])
            set(gca,'XTick',[1:m(i).coeff_count]);
            set(gca, 'XTickLabel',labels_a)
            %title(strcat(m(i).name,' effect'),'FontWeight','bold','FontSize',16)
            xlabel('coefficients')
            ylabel('a_i/a_0')
    print_plot_latex('effects_linear_time.tex')

    figure
    j = 2;
    bar([1:m(i).coeff_count],m(i).resp(j).effects/m(i).resp(j).effects(1),width1,'FaceColor',[0.2,0.2,0.5])
    hold on
    bar([1 3 4],m(4).resp(j).effects/m(i).resp(j).effects(1),width1/2,'FaceColor',[0,0.7,0.7])
            set(gca,'XTick',[1:m(i).coeff_count]);
            set(gca, 'XTickLabel',labels_b)
            %title(strcat(m(i).name,' effect'),'FontWeight','bold','FontSize',16)
            xlabel('coefficients')
            ylabel('b_i/b_0')
    print_plot_latex('effects_linear_jerk.tex');


    i = 2;
    j = 1;
    figure
    bar([1:m(i).coeff_count],m(i).resp(j).effects/m(i).resp(j).effects(1),width1,'FaceColor',[0.2,0.2,0.5])
    hold on
    bar([1 3 4 7],m(5).resp(j).effects/m(5).resp(j).effects(1),width1/2,'FaceColor',[0,0.7,0.7])
            set(gca,'XTick',[1:m(i).coeff_count]);
            set(gca, 'XTickLabel',labels_a)
            %title(strcat(m(i).name,' effect'),'FontWeight','bold','FontSize',16)
            xlabel('coefficients')
            ylabel('a_i/a_0')
    print_plot_latex('effects_linear_interactions_time.tex');

    i = 2;
    j = 2;
    figure
    bar([1:m(i).coeff_count],m(i).resp(j).effects/m(i).resp(j).effects(1),width1,'FaceColor',[0.2,0.2,0.5])
    hold on
    bar([1 3 4],m(4).resp(j).effects/m(4).resp(j).effects(1),width1/2,'FaceColor',[0,0.7,0.7])
            set(gca,'XTick',[1:m(i).coeff_count]);
            set(gca, 'XTickLabel',labels_b)
            %title(strcat(m(i).name,' effect'),'FontWeight','bold','FontSize',16)
            xlabel('coefficients')
            ylabel('b_i/b_0')
    print_plot_latex('effects_linear_interactions_jerk.tex');

    i = 3;
    j = 1;
    figure
    bar([1:m(i).coeff_count],m(i).resp(j).effects/m(i).resp(j).effects(1),width1,'FaceColor',[0.2,0.2,0.5])
            set(gca,'XTick',[0:m(i).coeff_count]);
    hold on
    bar([1:5 7:10],m(6).resp(j).effects/m(6).resp(j).effects(1),width1/2,'FaceColor',[0,0.7,0.7])
            set(gca,'XTick',[1:m(i).coeff_count]);
            set(gca, 'XTickLabel',labels_a)
            %title(strcat(m(i).name,' effect'),'FontWeight','bold','FontSize',16)
            xlabel('coefficients')
            ylabel('a_i/a_0')
    print_plot_latex('effects_quadr_time.tex');

    i = 3;
    j = 2;
    figure
    bar([1:m(i).coeff_count],m(i).resp(j).effects/m(i).resp(j).effects(1),width1,'FaceColor',[0.2,0.2,0.5])
            set(gca,'XTick',[1:m(i).coeff_count]);
    hold on
    bar([1:5 8:10],m(7).resp(j).effects/m(7).resp(j).effects(1),width1/2,'FaceColor',[0,0.7,0.7])
            set(gca,'XTick',[0:m(i).coeff_count]);
            set(gca, 'XTickLabel',labels_b)
            %title(strcat(m(i).name,' effect'),'FontWeight','bold','FontSize',16)
            xlabel('coefficients')
            ylabel('b_i/b_0')
    print_plot_latex('effects_quadr_jerk.tex');
end
%% ----------------------
% create ANOVA tables
% ----------------------
disp('linear model: travel time')
fid = print_anova_header('anova_linear.tex');
print_anova_latex(e.E_norm, e.resp(1).Y, m(1).coeffs, fid, 'Time', '')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');
print_anova_latex(e.E_norm(:,[2 3]), e.resp(1).Y, [1 0;2 0], fid, 'Time', '^1'); % 
disp('linear model: jerk')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');
print_anova_latex(e.E_norm, e.resp(2).Y, m(1).coeffs, fid, 'Jerk','')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');
print_anova_latex(e.E_norm(:,[2 3]), e.resp(2).Y, [1 0;2 0], fid, 'Jerk', '^1');


disp('linear model with interactions: travel time');
fid = print_anova_header('anova_linear_interactions.tex');
print_anova_latex(e.E_norm, e.resp(1).Y, m(2).coeffs, fid, 'Time', '')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');
print_anova_latex(e.E_norm, e.resp(1).Y, [1 0; 2 0; 1 2], fid, 'Time','^1')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');
print_anova_latex(e.E_norm, e.resp(2).Y, m(2).coeffs, fid, 'Jerk', '')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');

disp('quadratic model: travel time')
fid = print_anova_header('anova_quadratic.tex');
print_anova_latex(e.E_norm, e.resp(1).Y, m(3).coeffs, fid, 'Time', '')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');
print_anova_latex(e.E_norm, e.resp(1).Y, [  1 0 0; 2 0 0; 3 0 0; 1 2 0; 2 3 0; 1 1 0; 2 2 0; 3 3 0], fid, 'Time','^1')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');
print_anova_latex(e.E_norm, e.resp(2).Y, m(3).coeffs, fid, 'Jerk', '')
fprintf(fid,'\\arrayrulecolor{gray}\\hline\n');
print_anova_latex(e.E_norm, e.resp(2).Y, [  1 0 0; 2 0 0; 3 0 0; 1 2 0; 2 3 0; 1 1 0; 2 2 0; 3 3 0], fid, 'Jerk','^1')

%% ----------------------
% plot data and interpolation for conclusion
% linear model without parameter A for
% ----------------------

if(0)
    plot_interpolation(m(4), e, 1)
    ylim([0 3])
    print_plot_latex('fitLin_time.tex');

    plot_interpolation(m(4), e, 2)
    print_plot_latex('fitLin_jerk.tex');
end
return
%% ----------------------
% plot data and interpolation
% ----------------------

figure
title('Travel time')
xlabel('x_1 (Parameter A)')
ylabel('x_2 (Parameter B)')
zlabel('travel time')
hold on

p1 = 1;
p2 = 2;
p3 = 3;
legend_str = cell(length(e.param(p3).unique),1);
% plot experimental values

for j = 1:length(e.param(p3).unique)
    x3 = e.param(p3).unique(j);     % value of the 3rd parameter
    indi = e.E_norm(:,p3) == x3;     % find all experiments with 3rd parameter == x3
    plot3(e.E_nat(indi,p1), e.E_nat(indi,p2), e.resp(1).Y(indi), [colorList{j} '*'],'MarkerSize',5);
    legend_str{j} = [ e.param(p3).name ' = '  num2str(x3)];
    hold on
end

for j = 1:length(e.param(p3).unique)
    x3 = e.param(p3).unique(j);     % value of the 3rd parameter
    indi = e.E_norm(:,p3) == x3;     % find all experiments with 3rd parameter == x3
    plot3(e.E_nat(indi,p1), e.E_nat(indi,p2), e.resp(2).Y(indi), [colorList{j} 'o'],'MarkerSize',5);
    legend_str{j} = [ e.param(p3).name ' = '  num2str(x3)];
    hold on
end
legend(legend_str)
x11 = min(e.E_nat(:,1));
x12 = max(e.E_nat(:,1));
x21 = min(e.E_nat(:,2));
x22 = max(e.E_nat(:,2));
plot3([x11; x11; x12; x12; x11],[x21; x22; x22; x21; x21],zeros(5,1))
grid on
%pause
%print -depsc epsFig

%close all
figure
plot_interpolation(m(1), e, 1)
pause
print_plot_latex('interpol_lin1.tex');
figure
plot_interpolation(m(1), e, 2)
print -depsc interpol_lin1
pause
print -depsc interpol_lin2