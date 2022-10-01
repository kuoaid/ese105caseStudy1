%1. load files
%2. run kmeans to get a column of groups (todo: design the kmeans)
%3. concatenate group with cnty_covid or cnty_census(better)
%note down additional work that we may need

load('COVIDbyCounty.mat');

[idx,C] = kmeans(CNTY_COVID, 9, 'Replicates', 20);

figure
silhouette(CNTY_COVID, idx);
title('Edit me');

%%
CNTY_COVID_d = diff(CNTY_COVID')';
CNTY_COVID_dd = diff(CNTY_COVID_d')';




%%
% put two vectors together to be a table
%k2 = titles((idx5 == 2),:);
%s2 = s((idx5 == 2),:);
%ks2 = [k2,s2];
%sks2 = sortrows(ks2,2);

Region_1 = CNTY_COVID(1:25,:);
Region_2 = CNTY_COVID(26:50,:);
Region_3 = CNTY_COVID(51:75,:);
Region_4 = CNTY_COVID(76:100,:);
Region_5 = CNTY_COVID(101:125,:);
Region_6 = CNTY_COVID(126:150,:);
Region_7 = CNTY_COVID(151:175,:);
Region_8 = CNTY_COVID(176:200,:);
Region_9 = CNTY_COVID(201:225,:);

New_England = Region_1;
Middle_Atlantic = Region_2;
East_North_Central = Region_3;
West_North_Central = Region_4;
South_Atlantic = Region_5;
East_South_Central = Region_6;
West_South_Central = Region_7;
Mountain = Region_8;
Pacific = Region_9;

index_1_storage = zeros(225, 1);
x = 1;
for index = 1:225
    if idx(index) == 1
        index_1_storage(x, 1) = index;
        x = x+1;
    end
end    

% Centriod_1 = 

