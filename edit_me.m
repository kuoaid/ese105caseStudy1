%1. load files
%2. run kmeans to get a column of groups (todo: design the kmeans)
%3. concatenate group with cnty_covid or cnty_census(better)
%note down additional work that we may need
clear();
load('COVIDbyCounty.mat');
%%



% figure
% silhouette(CNTY_COVID, idx);

%%
speed = diff(CNTY_COVID')';
accel = [zeros(225,2) diff(speed')'];

[m,n] = size(accel) ;
P = 0.80 ;
split_idx = randperm(m)  ;
training = accel(split_idx(1:round(P*m)),:); 
testing = accel(split_idx(round(P*m)+1:end),:);

[trained_idx,centroids] = kmeans(training, 9, 'Replicates', 20);

idx_accel = [trained_idx,training];
sorted_accel = sortrows(idx_accel,1);