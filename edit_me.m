%1. load files
%2. run kmeans to get a column of groups (todo: design the kmeans)
%3. concatenate group with cnty_covid or cnty_census(better)
%note down additional work that we may need
clear();
load('COVIDbyCounty.mat');
%%


%this is where you process the raw data. NEVER sort this or add rows with
%data that could be meaningless/containminating to a kmeans function.
speed = diff(CNTY_COVID')';
accel = [zeros(225,2) diff(speed')'];

%the following step does the sorting and the kmeans on the processed data.
%if you ever change the dataset (linear transformation, etc), reassign the
%variable processed to point to your newly processed data here:

processed = accel;%change accel to your new data name.

%now

[m,n] = size(processed) ;
P = 0.80 ;
split_idx = randperm(m);
training = processed(split_idx(1:round(P*m)),:); 

%the testing data is concatenated with all the known data attributes to aid
%future testing.
data_with_characteristics = [array2table(divisionLabels) CNTY_CENSUS array2table(processed)];
testing_data = processed(split_idx(round(P*m)+1:end),:);
testing_table = data_with_characteristics(split_idx(round(P*m)+1:end),:);


[trained_idx,centroids] = kmeans(training, 9, 'Replicates', 20);

idx_trained_data = [trained_idx,training];
sorted_trained_data = sortrows(idx_trained_data,1);