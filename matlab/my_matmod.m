function X = matmod(Mexp,coef,const_flag)
% mod = matmod(Mexp,coef,const_flag)
% The function MATMOD computes the model matrix from the matrix
% of experiments Mexp and the coefficient vector Coef.
%
% A constant term is added if const=1. const is also used
% for moving the colomn in the case of constant term.
% A line of the coef vector is contituted by the number 
% the colomn of the Mexp which should be multiplied to
% built to the model matrix
%
%
% coef : vector of model coefficients
% Mexp : matrix of experiments
% mod  : matrix of model
%
% example:
% x=fact_mat(2)  or  x=fullfact([2 2])
% coef=[1 0;2 0;1 2]
% M=matmod(x,coef,1)
%
% ------------------------- JMF-LESO-EPFL ------------------------------- 

% new version in 2013: replace 'max(find())' by 'find(coef(i,:),1,'last')
%
% modified by Basil Huber to support designs where a factor does not appear
% in the linear terms, but in quadratic or interaction terms

Mcoef = size(coef,2);
Ncoef = size(coef,1);
Nexp= size(Mexp,1);


% add a 1-colomn for constant coefficient
if (const_flag==1),
    X = ones(Nexp, Ncoef+1);
else
    X = ones(Nexp, Ncoef);
    const_flag=0;
end


% add on column per coefficient        
for i = 1:Ncoef,
    for k = 1:Mcoef
        if(coef(i,k) > 0)
            % perform the column multiplication
			X(:,i+const_flag) = X(:,i+const_flag).* Mexp(:,coef(i,k));
        end
    end
end