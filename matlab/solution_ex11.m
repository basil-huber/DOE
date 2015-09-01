%% exo 7

% 14 diferent experiments are planned for the Menchoutkin experience

% 	sI	sR     Amines
experiments = [
-0.07	-0.18  % tBu	
-0.05	-0.23  % Et	
-0.04	-0.25  % Me	
 0	     0     % H	
 0.05	-0.21  % Vinilo	
 0.06	-1.75  % NMe2	
 0.1	-0.3   % Phenyl	
 0.26	-0.86  % NHCoMe	
 0.555	-1.78  % Ome	
 0.28	 0.16  % CoMe	
 0.3	 0.14  % CO2Me	
 0.44	-0.3   % Br	
 0.46	-0.36  % Cl	
 0.56	 0.13 ]; % CN 

%% 1-Standardize the experiment
[Nexp,Nvar] = size(experiments);

% calculate the min and max
maxexp = max(experiments);
minexp = min(experiments);

% calculate the min and max
midrange = (maxexp - minexp)/2;
center = (maxexp + minexp)/2;

% compute the standardized matrix

experiments_std = (experiments-repmat(center,Nexp,1)) ./ repmat(midrange,Nexp,1);

figure(1)

% plot of the experience data
subplot(121)
plot(experiments(:,1),experiments(:,2),'ro','MarkerSize',10)
pbaspect([1 1 1])
grid on
title('Original points','FontWeight','bold','FontSize',16)
xlabel('Induction sensitivity')
ylabel('Resonance sensitivity')

subplot(122)
plot(experiments_std(:,1),experiments_std(:,2),'bo','MarkerSize',10)
pbaspect([1 1 1])
grid on
title('Standardized points','FontWeight','bold','FontSize',16)
xlabel('Xi')
ylabel('Xr')


%% 2- built matrix model for the linear model, linear with interactions and
% second degree model

% coefficients of the model
coef=[1 0;2 0;1 2;1 1; 2 2];

% model matrices
model_linear = matmod(experiments_std,coef(1:2,:),1);
model_interaction = matmod(experiments_std,coef(1:3,:),1);
model_quadratic = matmod(experiments_std,coef,1);

%% 3- compute the dispersion matrix, the correlation matric, the VIF, the
% variance function for the 3 models and analyse your results
% dispersion matrices

disp_linear = inv(model_linear'* model_linear);
disp_interaction = inv(model_interaction'* model_interaction);
disp_quadratic = inv(model_quadratic'* model_quadratic);

% bar chart of the dispertion matrix
figure(2)
subplot(221)
bar3(disp_linear,'r')
pbaspect([4 4 1])
labels={'ao';'a1';'a2'};
set(gca, 'XTickLabel',labels,'YTickLabel',labels)
title('Linear','FontWeight','bold','FontSize',16)

subplot(222)
bar3(disp_interaction,'b')
pbaspect([4 4 1])
labels={'ao';'a1';'a2';'a12'};
set(gca, 'XTickLabel',labels,'YTickLabel',labels)
title('With interactions','FontWeight','bold','FontSize',16)

subplot(223)
bar3(disp_quadratic,'b')
pbaspect([4 4 1])
labels={'ao';'a1';'a2';'a12';'a11';'a22'};
set(gca, 'XTickLabel',labels,'YTickLabel',labels)
title('Quadratic','FontWeight','bold','FontSize',16)

%%  Results of the experiments

results = [
12	% tBu
11	% Et
12	% Me
11	% H
13	% Vinilo
11	% NMe2
12	% Phenyl
100	% NHCoMe
112	% Ome
11	% CoMe
13	% CO2Me
11	% Br
11	% Cl
11];	% CN 

%% 4- fit the results on the 3 models 

effect_linear = disp_linear * (model_linear' * results);
effect_interaction = disp_interaction * (model_interaction' * results);
effect_quadratic = disp_quadratic * (model_quadratic' * results);

% compute the residues
residue_linear = results - (model_linear * effect_linear);
residue_interaction = results - (model_interaction * effect_interaction);
residue_quadratic = results - (model_quadratic * effect_quadratic);

% compute the experimental variances
sigma_sq_linear = residue_linear' * residue_linear;
sigma_sq_interaction = residue_interaction' * residue_interaction;
sigma_sq_quadratic = residue_quadratic' * residue_quadratic;

% 90% bilateral Confidence interval estimation
alfa= .90 + (1-.90)/2;
CI_linear = tinv(alfa,Nexp-2)*sqrt(diag(disp_linear)*sigma_sq_linear);
CI_interaction = tinv(alfa,Nexp-2)*sqrt(diag(disp_interaction)*sigma_sq_interaction);
CI_quadratic = tinv(alfa,Nexp-2)*sqrt(diag(disp_quadratic)*sigma_sq_quadratic);

%% bar chart of the effects and CI

figure(3)
subplot(311)
errorbar(effect_linear,CI_linear,'dr',...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63])
xlim([0 6.5])
grid on
labels={'ao';'a1';'a2';'a12';'a11';'a22'};
set(gca, 'XTickLabel',labels)
title('Linear effects and 90% confidence intervals','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai')

subplot(312)
errorbar(effect_interaction,CI_interaction,'dr',...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63])
xlim([0 6.5])
grid on
set(gca, 'XTickLabel',labels)
title('Interaction effects and 90% confidence intervals','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai')

subplot(313)
errorbar(effect_quadratic,CI_quadratic,'dr',...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63])
xlim([0 6.5])
grid on
set(gca, 'XTickLabel',labels)
title('quadratic effects and 90% confidence intervals','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai/ao')

%% bar chart of the relative effects
figure(4)
subplot(311)
bar(effect_linear/effect_linear(1),'r')
xlim([0 6.5])
labels={'ao';'a1';'a2';'a12';'a11';'a22'};
set(gca, 'XTickLabel',labels)
title('Linear effect','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai/ao')

subplot(312)
bar(effect_interaction/effect_interaction(1),'r')
xlim([0 6.5])
set(gca, 'XTickLabel',labels)
title('Interaction effect','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai/ao')

subplot(313)
bar(effect_quadratic/effect_quadratic(1),'r')
xlim([0 6.5])
set(gca, 'XTickLabel',labels)
title('Linear effect','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai/ao')

%% bar chart of the residuals
figure(5)
subplot(311)
bar(residue_linear,'g')
title('Residuals for the linear model','FontWeight','bold','FontSize',16)
xlabel('Runs')
ylabel('Residuals')

subplot(312)
bar(residue_interaction,'g')
title('Residuals for the model with interactions','FontWeight','bold','FontSize',16)
xlabel('Runs')
ylabel('Residuals')

subplot(313)
bar(residue_quadratic,'g')
title('Residuals for the quadratic model','FontWeight','bold','FontSize',16)
xlabel('Runs')
ylabel('Residuals')


%% plot of the function as surface response

% linear model
xx = -1:.25:1; % define step on the axis
[XX,YY] = meshgrid(xx); % built the grid

surface_lin = effect_linear(1)+ effect_linear(2)*XX+ effect_linear(3)*YY;
surface_interaction = effect_interaction(1)+ effect_interaction(2)*XX +...
    effect_interaction(3)*YY + effect_interaction(3)* XX .*YY;
surface_quadratic = effect_quadratic(1)+ effect_quadratic(2)*XX +...
    effect_quadratic(3)*YY + effect_quadratic(3)* XX .*YY ...
    + effect_quadratic(4)* XX .*XX + effect_quadratic(4)* YY .*YY;

% surface plot
figure(6)
subplot(3,1,1)
surf(xx,xx,surface_lin)
pbaspect([3 3 1])
title('Linear function','FontWeight','bold','FontSize',16)
xlabel('x')
ylabel('y')
zlabel('R')

hold on
plot3(experiments_std(:,1),experiments_std(:,2),results,'o',...
    'MarkerSize',8,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r')
hold off

subplot(3,1,2)
surf(xx,xx,surface_interaction)
pbaspect([3 3 1])
title('Linear function with interactions','FontWeight','bold','FontSize',16)
xlabel('x')
ylabel('y')
zlabel('R')

hold on
plot3(experiments_std(:,1),experiments_std(:,2),results,'o',...
    'MarkerSize',8,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r')
hold off

subplot(3,1,3)
surf(xx,xx,surface_quadratic)
pbaspect([3 3 1])
title('2nd degree function','FontWeight','bold','FontSize',16)
xlabel('x')
ylabel('y')
zlabel('R')

hold on
plot3(experiments_std(:,1),experiments_std(:,2),results,'o',...
    'MarkerSize',8,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r')
hold off

%% measurement vs model
figure(7)

plot(results,model_linear*effect_linear,'*r',...
    results,model_interaction*effect_interaction,'og',...
    results,model_quadratic*effect_quadratic,'vb')
grid
title('measurements vs model','FontWeight','bold','FontSize',16)
xlabel('x')
ylabel('y')
legend('linear','interaction','quadratic')

%% Elimination loop for the linear model with interactions

Xnew = model_interaction;

determinant = zeros(1,8);

for j=1:8,
    [Xnew,S_sorted,I,determinant(j)]=detselect(Xnew,model_interaction,1);

    disp_new = inv(Xnew'*Xnew); % compute the matrix of dispersion
    xx = -1:.2:1; % define step on the axis
    [XX,YY] = meshgrid(xx); % built the grid
    XXX = reshape(XX,11*11,1);
    YYY = reshape(YY,11*11,1);
    fxy = matmod([XXX YYY],coef(1:3,:),1); % compute the model coordinates

    % compute the variance value for each point of the space
    var_col = zeros(1,121); % Pre-allocate
    
        for i=1:121,
           
             var_col(i) = fxy(i,:)* disp_new *(fxy(i,:))'; 
            
        end

    var_mat = reshape(var_col,11,11);

    figure(8)
    subplot(3,3,j)
    surf(xx,xx,1./var_mat)

    hold on
    plot(Xnew(:,2),Xnew(:,3),'or') % place experimental points
    hold off
    axis([-1 1 -1 1 0 12])
    title('Information function','FontWeight','bold','FontSize',16)
    xlabel('x')
    ylabel('y')
    zlabel('I(Y)/sigma')

    figure(9)
    subplot(3,3,j)
    surf(xx,xx,var_mat)

    hold on
    plot(Xnew(:,2),Xnew(:,3),'or') % place experimental points
    hold off
    axis([-1 1 -1 1 0 2])
    title('Variance function','FontWeight','bold','FontSize',16)
    xlabel('x')
    ylabel('y')
    zlabel('var(Y)/sigma')
    
    
   void=input('press enter to continue');
end

figure(8)
subplot(339)
bar(determinant)
title('Determinant Evolution ','FontWeight','bold','FontSize',16)
xlabel('Number of eliminated experiments')
ylabel('Det inv(X''X)')

%% 6- perform an ANOVA analysis of the 3 models
disp('ANOVA linear model')
[~,~,~,~,~,p_linear]= anova_fact(experiments_std,results,coef(1:2,:),1);
disp('ANOVA linear model with interactions')
[~,~,~,~,~,p_interaction]= anova_fact(experiments_std,results,coef(1:3,:),1);
disp('ANOVA segond degree model')
[~,~,~,~,~,p_quadratic]= anova_fact(experiments_std,results,coef,1);
 
% bar chart of the probabilities
figure(10)
subplot(311)
bar(p_linear,'g')
xlim([0 6.5])
ylim([0 0.15])
labels={'ao';'a1';'a2';'a12';'a11';'a22'};
set(gca, 'XTickLabel',labels)
title('p values for the linear model','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('p')

subplot(312)
bar(p_interaction,'g')
xlim([0 6.5])
ylim([0 0.15])
set(gca, 'XTickLabel',labels)
title('p values for the model with interactions','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('p')

subplot(313)
bar(p_quadratic,'g')
xlim([0 6.5])
ylim([0 0.15])
set(gca, 'XTickLabel',labels)
title('p values for the quadratic model','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('p')




