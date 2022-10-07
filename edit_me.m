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

% used_data = CNTY_COVID.^2;
% This actually decreases accuracy a lot.
used_data = CNTY_COVID;
processed = [divisionLabels used_data];%change accel to your new data name.

%now

[m,n] = size(processed) ;
P = 0.80 ;
split_idx = randperm(m);
training = processed(split_idx(1:round(P*m)),:); 

%the testing data is concatenated with all the known data attributes to aid
%future testing.
data_with_characteristics = [array2table(divisionLabels) CNTY_CENSUS array2table(processed)];
testing_data = processed(split_idx(round(P*m)+1:end),:);

%now doing the training set.

% Since CNTY_CENSUS was given from the largerst population to the lowest in
% each geographical division, we decided to take the 1st, 26th, 51th... as
% the starting centroids for itteration (a total of 9) for geographical
% representation.

centroids_table = [];
for index = (1:9)
    current_data = training(training(:,1)==index,:);
    [current_idx, current_cs] = kmeans(current_data,2); %2 groups per division
    centroids_table = [centroids_table; current_cs];
end

%centroids_table_new = [];
%for index = (1:18)
%    if(mod(index,2)==0)
%        centroids_table_new(index,:) = centroids_table(index-1,:);
%    else
%        centroids_table_new(index,:) = centroids_table(index,:);
%    end
%end

%centroids = centroids_table_new(:,2:end);

% The centroids_table is a method that use two centroids per group, which
% will give a higher rate of accuracy comparing with the
% centroids_table_new, which use one centroid per group. The codes for
% centroids_table_new are commented above.

centroids = centroids_table(:,2:end);

% idx_trained_data = [trained_idx,training];
% sorted_trained_data = sortrows(idx_trained_data,1);

%%test is carried out from here.
%%
data_tested = testing_data;
expected_divisions = data_tested(:,1);
data_tested = data_tested(:,2:end);
test_nearest = zeros(45,18,'uint32');
min_test_nearest = [];



for index = (1:45)
    for index2 = (1:18)
        test_nearest(index,index2) = norm(data_tested(index,:)-centroids(index2,:));%put all distances into a table called test_nearest
    end
    found_index = find( test_nearest(index,:)==min(test_nearest(index,:)));%find the closest and choose it as current point's centroid
    actual_index = -1;
    if(mod(found_index(1),2)==0)
        actual_index = found_index/2;
    else
        actual_index = (found_index(1)+1)/2;
    end
    min_test_nearest(index,1) = actual_index;
    min_test_nearest(index,2) = min(test_nearest(index,:));
end

result = [expected_divisions min_test_nearest];

match = 0;
dataSize = 45;
for index = (1:45)
    if(result(index,1)==result(index,2))
        match = match+1;
    end
end

rate = match/dataSize;





