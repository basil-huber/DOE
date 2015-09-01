%clear
close all

addpath('../../Lisa')

%% setup experiment structure

% load experiment structure
load('experiment.mat')

% normalize parameters
offset = repmat(-(max(e.E_nat) + min(e.E_nat))/2, e.N, 1);
scale = repmat(2./(max(e.E_nat) - min(e.E_nat)), e.N, 1);
e.E_norm = (e.E_nat+offset).*scale;    % normalized matrix of experiments

% add sorted list of normalized parameters
e.param(1).unique = sort(unique(e.E_norm(:,1)));
e.param(2).unique = sort(unique(e.E_norm(:,2)));
e.param(3).unique = sort(unique(e.E_norm(:,3)));

% form of experiment structure e:
% e.E_nat:      Matrix of experiments (not normalized)
% e.E_norm:     Matrix of experiments (normalized)
% e.N:          Number of experiments
% e.resp(1):    Response mean arrivalTime (.Y and .name)
% e.resp(2):    Response mean jerk (.Y and .name)
% e.param(1):   parameter d  (.name and .unique)
% e.param(2):   parameter a  (.name and .unique)
% e.param(3):   parameter b  (.name and .unique)

%% setup models

coeffs =   [  1 0 0    % linear coeffs
              2 0 0;
              3 0 0;
              1 2 0;   % linear interactions
              1 3 0;
              2 3 0;
              %1 2 3;
              1 1 0;   % quadratic interactions
              2 2 0;
              3 3 0];
          
m_resp = struct('effects', 0, 'r', 0, 'sigma', 0, 'CI', 0);
m = struct('coeffs',0, 'coeff_count', 0, 'param_list', 0, 'X',0,'D',0,'name', '', 'resp', m_resp);
m(1) = setup_model(m(1), coeffs(1:3,:), e, 'Linear');    % linear model w\   interactions
m(2) = setup_model(m(1), coeffs(1:6,:), e, 'Interactions');    % linear model with interactions
m(3) = setup_model(m(1), coeffs(1:end,:), e, 'Quadratic');   % quadratic model w\ interactions


% form of model structure m:
% m(i).name:        Name of the model
% m(i).coeffs:      Coefficient matrix
% m(i).coeff_count: Number of coefficients (including constant)
% m(i).param_list:  Indices of considered params (with resp. to e.param)
% m(i).X:           Matrix of the model
% m(i).D:           Dispertion matrix
% m(i).resp(j):     result of the analysis for the jth response
% m(i).resp(j).effects(k):     effects of each parameter k
% m(i).resp(j).r(k):           residue for each experiment k
% m(i).resp(j).sigma(k):       standard deviation for each parameter k
% m(i).resp(j).CI(k):          interval of confidence for each parameter k

%% add remove factor 1
disp('here')
coeffs =   [  2 0;     % linear coeffs
              3 0];
m(4) = setup_model(m(1), coeffs, e, 'Linear mod');    % linear model w\   interactions
disp('fertig')
coeffs =   [  2 0 0;     % linear coeffs
              3 0 0;
              2 3 0];    % linear interactions
m(5) = setup_model(m(1), coeffs, e, 'Interactions mod');    % linear model with interactions

coeffs =   [  1 0 0    % linear coeffs
              2 0 0;
              3 0 0;
              1 2 0;   % linear interactions
              %1 3 0;
              2 3 0;
              %1 2 3;
              1 1 0;   % quadratic interactions
              2 2 0;
              3 3 0];
m(6) = setup_model(m(1), coeffs, e, 'Quadratic mod');    % quadratic model with linear interactions

coeffs =   [  1 0 0    % linear coeffs
              2 0 0;
              3 0 0;
              1 2 0;   % linear interactions
              %1 3 0;
              %2 3 0;
              %1 2 3;
              1 1 0;   % quadratic interactions
              2 2 0;
              3 3 0];
m(7) = setup_model(m(1), coeffs, e, 'Quadratic mod');    % quadratic model with linear interactions

%% analyze experiments

j = 1


% hack for testing
% ii = 1
% alpha_ref = rand(size(m(ii).X,2),1);
% e.resp(j).Y = m(ii).X * alpha_ref;
% e.resp(j).Y = e.resp(j).Y .* (ones(e.N,1) + 100 *rand(e.N,1));


for i = 1:length(m)
    m(i) = analyze_experiment(m(i), e);
end

%% plotting





% -------------------------------------------------
%  Plot effects (bar plot and plot with error bars)
% -------------------------------------------------

plot_effects(m(1:3), e, j);

plot_effects(m(4:6), e, j);


for i = 1:1
    [E,SS,DL,MS,F,p]= anova_doe(e.E_norm,e.resp(j).Y,m(i).coeffs,1);
end

 %[E,SS,DL,MS,F,p]= anova_doe(e.E_norm(:,[1 2]),e.resp(1).Y,[1 0; 2 0],1);
 %[E,SS,DL,MS,F,p]= anova_doe(e.E_norm(:,[1 2]),e.resp(2).Y,[1 0; 2 0],1);

% figure(1)
% for jj = 1:3
%     subplot(3,1,jj)
%     hold on
%     plot([1:length(alpha_ref)], alpha_ref, 'r*')
% end

for i = 1:3%length(m)
    plot_interpolation(m(i), e, j)
end
