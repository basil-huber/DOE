xlimits = [1 13]; % a
ylimits = [8 14]; % lattice
zlimits = [5 13]; % b

x2 = 2*(3-xlimits(1))/(xlimits(2) - xlimits(1)) - 1;
x1 = 2*(5-xlimits(1))/(xlimits(2) - xlimits(1)) - 1;
x3 = 2*(9-xlimits(1))/(xlimits(2) - xlimits(1)) - 1;

dBB = bbdesign(3,'center',1);

indexes = find(dBB(:,1)>dBB(:,3));
dBB2 = dBB;

dBB3 = dBB(dBB(:,1)<=dBB(:,3),:);

dBB2(indexes(1),1) = x3;
dBB2(indexes(2),1) = x3;
dBB2(indexes(3),1) = x1;
dBB2(indexes(4),1) = x2;
dBB2(indexes(5),1) = x2;

dBB2(dBB2(:,1) == 0 & dBB2(:,2) == 0 & dBB2(:,3) == 0,:) = [((2/3)^2+2/3*2+2^2)/(3*(2/3+2))-1 0 -2/3*(2*2/3+2)/(2/3+2)+1];

sq1 = [1 1 1
    1 1 -1
    1 -1 -1
    1 -1 1
    1 1 1];
sq2 = [1 1 1
    -1 1 1    
    -1 -1 1
    1 -1 1
    1 1 1];

sq3 = [-1 1 1
    -1 1 -1
    -1 -1 -1
    -1 -1 1
    -1 1 1];

sq4 = [1 1 -1
    -1 1 -1    
    -1 -1 -1
    1 -1 -1
    1 1 -1];

sq5 = [x1 -1 -1
    x1 1 -1
    1 1 1
    1 -1 1
    x1 -1 -1];

figure(1)
hold on
plot3(dBB2(:,1),dBB2(:,2),dBB2(:,3),'bo','MarkerSize',12)
plot3(dBB(:,1),dBB(:,2),dBB(:,3),'r*','MarkerSize',12)
plot3(dBB3(:,1),dBB3(:,2),dBB3(:,3),'cs','MarkerSize',12)
plot3(sq1(:,1),sq1(:,2),sq1(:,3),'g')
plot3(sq2(:,1),sq2(:,2),sq2(:,3),'g')
plot3(sq3(:,1),sq3(:,2),sq3(:,3),'g')
plot3(sq4(:,1),sq4(:,2),sq4(:,3),'g')
plot3(sq5(:,1),sq5(:,2),sq5(:,3),'g')
xlabel('x')
ylabel('y')
zlabel('z')
axis([-1.2 1.2 -1.2 1.2 -1.2 1.2])
hold off

%% Variance function
variance_function(dBB)
variance_function(dBB2)
variance_function(dBB3)

%% Standardize to normal variable

RealVar = dBB2;

RealVar(:,1)=(dBB2(:,1)+1)/2*(xlimits(2)-xlimits(1))+xlimits(1);
RealVar(:,2)=(dBB2(:,2)+1)/2*(ylimits(2)-ylimits(1))+ylimits(1);
RealVar(:,3)=(dBB2(:,3)+1)/2*(zlimits(2)-zlimits(1))+zlimits(1);

matrixMinMax = [min(RealVar);max(RealVar)];

display(RealVar)


