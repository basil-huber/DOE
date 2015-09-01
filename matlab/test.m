close all
X = e.E_norm(:,[1 2 3])
y = e.resp(1).Y

model = fitlm(X,y,'RobustOpts','off')

plot(model)

coeffs =   [  1 0 0;     % linear coeffs
              2 0 0];
XX = matmod(X, coeffs,1);
D = inv(XX'*XX);

effect_linear = D * (XX' * y)
m(1).resp(1).effects


D - m(4).D
XX - m(4).X




r = sqrt(sum((y - (XX * effect_linear)).^2))


r2 = sqrt(sum((y - (XX * [1.5671 ])).^2))