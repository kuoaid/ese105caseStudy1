%1. load files
%2. run kmeans to get a column of groups (todo: design the kmeans)
%3. concatenate group with cnty_covid or cnty_census(better)
%note down additional work that we may need

load('COVIDbyCounty.mat');

[idx,centroids] = kmeans(CNTY_COVID, 9, 'Replicates', 20);

idxAsTable = array2table(idx);
idxAsTable.Properties.VariableNames(1) = "kmeans_group";

census_kmeans = [idxAsTable CNTY_CENSUS];

figure
silhouette(CNTY_COVID, idx);

%%
CNTY_COVID_d = diff(CNTY_COVID')';
CNTY_COVID_dd = diff(CNTY_COVID_d')';
% CNTY_COVID_dd = A .* CNTY_COVID (use for loop to go one row at a time)
idx_CNTY_COVID_dd = [idx,CNTY_COVID_dd];
sidx_CNTY_COVID_dd = sortrows(idx_CNTY_COVID_dd,1);


