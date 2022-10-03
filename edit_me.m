%1. load files
%2. run kmeans to get a column of groups (todo: design the kmeans)
%3. concatenate group with cnty_covid or cnty_census(better)
%note down additional work that we may need
clear();
load('COVIDbyCounty.mat');
%%


%this is where you process the raw data. NEVER sort this or add rows with
%data that could be meaningless/containminating to a kmeans function.
% speed = diff(CNTY_COVID')';
% accel = [zeros(225,2) diff(speed')'];

%the following step does the sorting and the kmeans on the processed data.
%if you ever change the dataset (linear transformation, etc), reassign the
%variable processed to point to your newly processed data here:

processed = [divisionLabels CNTY_COVID];%change accel to your new data name.

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

%now doing the training set.

% Since CNTY_CENSUS was given from the largerst population to the lowest in
% each geographical division, we decided to take the 1st, 26th, 51th... as
% the starting centroids for itteration (a total of 9) for geographical
% representation.
%%
% start = [CNTY_COVID(1,:); CNTY_COVID(26,:); CNTY_COVID(51,:); CNTY_COVID(76,:); CNTY_COVID(101,:); CNTY_COVID(126,:); CNTY_COVID(151,:); CNTY_COVID(176,:); CNTY_COVID(201,:)];
% 
% [trained_idx,centroids] = kmeans(training, 18, 'start', start);
% 
centroids_table = [];
for index = (1:9)
    current_data = training(training(:,1)==index,:);
    [current_idx, current_cs] = kmeans(current_data,2);
    centroids_table = [centroids_table; current_cs];
end

centroids = centroids_table(:,2:end);

% idx_trained_data = [trained_idx,training];
% sorted_trained_data = sortrows(idx_trained_data,1);

%%test is carried out from here.
%%
testing_data = testing_data(:,2:end);
test_nearest = [];
min_test_nearest = [];

for index = 1:45
    for index2 = 1:18
        test_nearest(index,index2) = norm(testing_data(index,:)-centroids(index2,:));
    end
    min_test_nearest(index,1) = find( test_nearest(index,:)==min(test_nearest(index,:)));
    min_test_nearest(index,2) = min(test_nearest(index,:));
end





