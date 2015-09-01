%clear
close all

addpath('../Lisa')
addpath('150805_Flocking_simu')
Experiment_design
%flocking_data_extraction
%E = dBB2;

% ----------------------------
%   Map between natural and normed coordinates
% ----------------------------

E_nat = matrixExperiments(:,[2 1 3]);
N = size(E_nat,1)
offset = ones(N,1)*(-(max(E_nat) + min(E_nat))/2)
scale = ones(N,1)*(2./(max(E_nat) - min(E_nat)))
E_rec = (E_nat+offset).*scale

figure(1)
hold on
plot3(E_rec(:,1),E_rec(:,2),E_rec(:,3),'m+','MarkerSize',12)
variance_function(E_rec)



coeffs =   [  1 0 0    % linear coeffs
              2 0 0;
              3 0 0;
              1 2 0;   % linear interactions
              1 3 0;
              2 3 0;
              1 2 3;
              1 1 0;   % quadratic interactions
              2 2 0;
              3 3 0];

% ---------------------
%    Model matrices
% ---------------------
X1 =       matmod(E_rec, coeffs(1:3,:),1);        % linear model w\   interactions
X1_int =  matmod(E_rec, coeffs(1:7,:),1);    % linear model with interactions
X2 =       matmod(E_rec, coeffs(1:10,:),1);        % quadratic model w\ interactions





% dispersion matrix
d1 = inv(X1'*X1);
d1_int = inv(X1_int'*X1_int);
d2 = inv(X2'*X2);

% half effects on yerk
alpha1 = d1 * (X1'*meanJerk);
alpha1_int = d1_int * (X1_int'*meanJerk);
alpha2 = d2 * (X2'*meanJerk);

% residue
r1 = meanJerk - (X1*alpha1);
r1./meanJerk
r1_int = meanJerk - (X1_int*alpha1_int);
r1_int./meanJerk
r2 = meanJerk - (X2*alpha2);
r2./meanJerk

% experimental variance
sigma1 = r1'*r1
sigma1_int = r1_int'*r1_int
sigma2 = r2'*r2

% 90% bilateral Confidence interval estimation
alpha_ci = .90 + (1-.90)/2;
CI1 = tinv(alpha_ci,N-2)*sqrt(diag(d1)*sigma1);
CI1_int = tinv(alpha_ci,N-2)*sqrt(diag(d1_int)*sigma1_int);
CI2 = tinv(alpha_ci,N-2)*sqrt(diag(d2)*sigma2);


figure(3)
subplot(311)
errorbar(alpha1,CI1,'dr',...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63])
set(gca,'XTick',[0:length(alpha2)]);
xlim([0 length(alpha2)+0.5])
grid on
labels={'';'ao';'a1';'a2';'a3;';'a12';'a13';'a23';'a122';'a11';'a22';'a33'};
set(gca, 'XTickLabel',labels)
title('Linear effects and 90% confidence intervals','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai')

subplot(312)
errorbar(alpha1_int,CI1_int,'dr',...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63])
set(gca,'XTick',[0:length(alpha2)]);
xlim([0 length(alpha2)+0.5])
grid on
set(gca, 'XTickLabel',labels)
title('Interaction effects and 90% confidence intervals','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai')

subplot(313)
errorbar(alpha2,CI2,'dr',...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',[.49 1 .63])
set(gca,'XTick',[0:length(alpha2)]);
xlim([0 length(alpha2)+0.5])
grid on
set(gca, 'XTickLabel',labels)
title('quadratic effects and 90% confidence intervals','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai/ao')

%% bar chart of the relative effects
figure(4)
subplot(311)
bar(alpha1/alpha1(1),'r')
xlim([0 6.5])
labels={'ao';'a1';'a2';'a12';'a11';'a22'};
set(gca, 'XTickLabel',labels)
title('Linear effect','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai/ao')

subplot(312)
bar(alpha1/alpha1(1),'r')
xlim([0 6.5])
set(gca, 'XTickLabel',labels)
title('Interaction effect','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai/ao')

subplot(313)
bar(alpha1/alpha1(1),'r')
xlim([0 6.5])
set(gca, 'XTickLabel',labels)
title('Linear effect','FontWeight','bold','FontSize',16)
xlabel('Coefficients')
ylabel('ai/ao')
