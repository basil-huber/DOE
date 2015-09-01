% Read from file

filepath = '150805_Flocking_simu/Results/';

maxvhc = 50;
c1Extract = 40;
c2Extract = 75;

total = [];
for i = 1:13
    if i == 1
        dExtract = 80000;
        aExtract = 100;
        bExtract = 900;
    elseif i == 2
        dExtract = 140000;
        aExtract = 100;
        bExtract = 900;
    elseif i == 3
        dExtract = 80000;
        aExtract = 900;
        bExtract = 900;
    elseif i == 4
        dExtract = 140000;
        aExtract = 900;
        bExtract = 900;
    elseif i == 5
        dExtract = 110000;
        aExtract = 100;
        bExtract = 500;
    elseif i == 6
        dExtract = 110000;
        aExtract = 100;
        bExtract = 1300;
    elseif i == 7
        dExtract = 110000;
        aExtract = 500;
        bExtract = 500;
    elseif i == 8
        dExtract = 110000;
        aExtract = 1300;
        bExtract = 1300;
    elseif i == 9
        dExtract = 80000;
        aExtract = 300;
        bExtract = 500;
    elseif i == 10
        dExtract = 80000;
        aExtract = 700;
        bExtract = 1300;
    elseif i == 11
        dExtract = 140000;
        aExtract = 300;
        bExtract = 500;
    elseif i == 12
        dExtract = 110000;
        aExtract = 533;
        bExtract = 966;
    elseif i == 13
        dExtract = 140000;
        aExtract = 700;
        bExtract = 1300;
    end
    
    total(i).d = dExtract/100;
    total(i).a = aExtract/100;
    total(i).b = bExtract/100;
    total(i).c1 = c1Extract/100;
    total(i).c2 = c2Extract/100;
    
    fileid = fopen([filepath 'Stats_' int2str(maxvhc) '_' int2str(dExtract) '_' int2str(aExtract) '_' int2str(bExtract) '_' int2str(c1Extract) '_' int2str(c2Extract) '.txt']);
    text = textscan(fileid,'%f');
    if(size(text{:,:}))
        total(i).B = dlmread([filepath 'Stats_' int2str(maxvhc) '_' int2str(dExtract) '_' int2str(aExtract) '_' int2str(bExtract) '_' int2str(c1Extract) '_' int2str(c2Extract) '.txt'], '\t', [0 0 0 6]);
        total(i).jerk_final = dlmread([filepath 'Stats_' int2str(maxvhc) '_' int2str(dExtract) '_' int2str(aExtract) '_' int2str(bExtract) '_' int2str(c1Extract) '_' int2str(c2Extract) '.txt'], '\t', [1 0 1 0]);
        total(i).timeArrival = dlmread([filepath 'Stats_' int2str(maxvhc) '_' int2str(dExtract) '_' int2str(aExtract) '_' int2str(bExtract) '_' int2str(c1Extract) '_' int2str(c2Extract) '.txt'], '\t', [2 0 2 0]);
        total(i).minDist = dlmread([filepath 'Stats_' int2str(maxvhc) '_' int2str(dExtract) '_' int2str(aExtract) '_' int2str(bExtract) '_' int2str(c1Extract) '_' int2str(c2Extract) '.txt'], '\t', 3, 0 );
    end
    fclose('all');
    
    
end

baseline = [];
fileid = fopen([filepath 'Stats_1_140000_700_1300_40_75.txt']);
text = textscan(fileid,'%f');
if(size(text{:,:}))
    baseline.B = dlmread([filepath 'Stats_1_140000_700_1300_40_75.txt'], '\t');
end
fclose('all');

%%
stat = [];
for i = 1:size(total,2)
    B = total(i).B;
    
    stat(i).simuStop = B(1,1);
    stat(i).alt_prob = B(1,2);
    stat(i).elapsed_time = B(1,3);
    stat(i).total_jerk = B(1,4);
    stat(i).number_collisions = B(1,5);
    stat(i).number_near_miss = B(1,6);
    stat(i).min_distance = B(1,7);
    stat(i).jerk = total(i).jerk_final;
    stat(i).arrival_time = total(i).timeArrival;
    stat(i).min_distance = total(i).minDist;
end

B = baseline.B;
statBaseline = [];
statBaseline.simuStop = B(1,1);
statBaseline.alt_prob = B(1,2);
statBaseline.elapsed_time = B(1,3);
statBaseline.total_jerk = B(1,4);
statBaseline.number_collisions = B(1,5);
statBaseline.number_near_miss = B(1,6);
statBaseline.min_distance = B(1,7);
statBaseline.jerk = B(2,1);
statBaseline.arrival_time = B(3,1);
statBaseline.min_distance = B(4,:);

d=cell2mat({total(:).d});
a=cell2mat({total(:).a});
b=cell2mat({total(:).b});
%% Matrix form

number_of_collisions = cell2mat({stat(:).number_collisions})';

meanArrivalTime = zeros(size(stat,2),1);
for i = 1:size(stat,2)
    meanArrivalTime(i) = mean(stat(i).arrival_time);
end
meanArrivalTime = meanArrivalTime / statBaseline.arrival_time ;

meanJerk = zeros(size(stat,2),1);
for i = 1:size(stat,2)
    meanJerk(i) = mean(stat(i).jerk);
end
meanJerk = meanJerk / statBaseline.jerk;

d = cell2mat({total(:).d})';
a = cell2mat({total(:).a})';
b = cell2mat({total(:).b})';

matrixExperiments = [a b d meanArrivalTime meanJerk];

%%
figure
plot(1:13,number_of_collisions)
figure
plot(1:13,meanArrivalTime,'r')
figure
plot(1:13,meanJerk,'g')


%%

v_cruise = 1388;
for i = 1:10
    v_cruise = v_cruise +  139;
    display(v_cruise)
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

alimits = [min(a) max(a)];
dlimits = [min(d) max(d)];
blimits = [min(b) max(b)];

aNorm = 2*(a-min(alimits))/(alimits(2) - alimits(1))-1;
dNorm = 2*(d-min(dlimits))/(dlimits(2) - dlimits(1))-1;
bNorm = 2*(b-min(blimits))/(blimits(2) - blimits(1))-1;


RealVar(:,1)=(dBB2(:,1)+1)/2*(xlimits(2)-xlimits(1))+xlimits(1);

%%
figure
hold on
plot3(dBB2(:,1),dBB2(:,2),dBB2(:,3),'bo','MarkerSize',12)
plot3(aNorm,dNorm,bNorm,'r*','MarkerSize',12)
%plot3(dBB(:,1),dBB(:,2),dBB(:,3),'r*','MarkerSize',12)
plot3(sq1(:,1),sq1(:,2),sq1(:,3),'g')
plot3(sq2(:,1),sq2(:,2),sq2(:,3),'g')
plot3(sq3(:,1),sq3(:,2),sq3(:,3),'g')
plot3(sq4(:,1),sq4(:,2),sq4(:,3),'g')
plot3(sq5(:,1),sq5(:,2),sq5(:,3),'g')
xlabel('a')
ylabel('d')
zlabel('b')
axis([-1.2 1.2 -1.2 1.2 -1.2 1.2])
hold off


e = struct();
e.E_nat = matrixExperiments(:,1:3);
e.param(1).name = 'a';
e.param(2).name = 'b';
e.param(3).name = 'd';
e.N = size(e.E_nat,1);
e.resp(1).Y = meanArrivalTime;
e.resp(1).name = 'arrival time';
e.resp(2).Y = meanJerk;
e.resp(2).name = 'jerk';
save('experiment.mat','e')