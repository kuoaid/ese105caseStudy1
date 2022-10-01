%1. load files
%2. run kmeans to get a column of groups (todo: design the kmeans)
%3. concatenate group with cnty_covid or cnty_census(better)
%note down additional work that we may need

[idx,C] = kmeans(CNTY_COVID, 10, 'Replicates', 10);

figure
silhouette(CNTY_COVID, idx);
title('Edit me');

% put two vectors together to be a table
%k2 = titles((idx5 == 2),:);
%s2 = s((idx5 == 2),:);
%ks2 = [k2,s2];
%sks2 = sortrows(ks2,2);