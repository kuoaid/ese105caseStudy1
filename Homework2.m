%% Homework 2: COVID-19 case data in St. Louis and Missouri
% *ESE 105* 
%
% 40 pts. total: 20 for programming and correct responses, 10 for
% programming style, 10 for presentation
%
% *Name: Kuo Wang*
%
% *Hours it took to complete assignment: FILL IN HERE*

%% Instructions
% Unzip all files within |Homework2.zip| to a single folder on your
% computer. Run the |Homework2.m| script. There are 3 parts in this
% assignment. Follow the instructions inside the "TODO: *****" labels below 
% to complete each part: either write code or write your response to the
% question. For example:

% TODO: *************************************************************
% (Replace this comment with code)
% (Add response here)
% *******************************************************************

%%%
%
% *To turn in your assignment:*
%
% * Run the command |publish('Homework2.m','pdf')| in the _Command Window_
% to generate a PDF of your solution |Homework2.pdf|. If the PDF does not
% contain your plots, then run the command |publish('Homework2.m','doc')|
% in the _Command Window_ instead.
% * Submit _both_ the code (|.m| file) and the published output (|.pdf|
% file or |.doc| file) to Canvas.
%
close all;  % comment out this line if you don't want MATLAB to erase all figure windows

%% Part 1: Import and filter COVID-19 data
%%%
% The New York Times is
% <https://www.nytimes.com/interactive/2020/us/coronavirus-us-cases.html
% continuously releasing data files> with _cumulative_ cases in the United
% States, at the state and county level, over time. The data help provide
% the public, researchers, scientists, etc. better understand the outbreak.
% Their data are available at their
% <https://github.com/nytimes/covid-19-data GitHub repository>. We will
% import county-level data contained in |counties.csv|. The data are in a
% tabular format:
%
%   date,county,state,fips,cases,deaths
%   2020-01-21,Snohomish,Washington,53061,1,0
%   ...
%
% We will store these data in a special MATLAB data type called a
% <https://www.mathworks.com/help/matlab/tables.html table>.

% *******************************************************************
% Comment out this code block if you've already downloaded
% 'us-counties.csv' from GitHub and have |COVID_allUS| in your workspace.
% You can speed up your code by avoiding re-downloading the large US
% dataset from GitHub each time you run it.

% read and save data from nytimes github repository into a table
% |COVID_allUS|
myreadtable = @(filename)readtable(filename,'HeaderLines',0, ...
    'Format','%D%s%s%u%u%u','Delimiter',',','MultipleDelimsAsOne',1);
options = weboptions('ContentReader',myreadtable);
COVID_allUS = webread('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-2020.csv',options);
temp2021 = webread('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-2021.csv',options);
temp2022 = webread('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-2022.csv',options);
COVID_allUS = [COVID_allUS; temp2021; temp2022];
clear temp2021 temp2022;
% *******************************************************************
%%
%%%
% In this assignment, we will analyze the COVID-19 cases over time within
% St. Louis city, St. Louis county, the St. Louis metropolitan area without
% St. Louis city and St. Louis county (13 counties), and the rest of
% Missouri. St. Louis city and St. Louis county are separate political
% entities and geographic areas, and WashU straddles their border:
% 
% <<../St_Louis_MSA_2020.png>>
%
% <https://www.census.gov/geographies/reference-maps/2020/geo/cbsa.html>
%
% For the purposes of this assignment, we will use the
% <https://www.census.gov/data/datasets/time-series/demo/popest/2020s-counties-total.html
% 2021 resident population estimate> from the US Census Bureau.
%
% * St. Louis city population: 293,310
% * St. Louis county population: 997,187
% * St. Louis metropolitan population (without St. Louis city and county):
% 1,518,802
% * Remaining MO population: 4,036,603

%%%
% *(1 pt.)* Our first task is to store the population data above in several
% MATLAB variables named: 
%
%   STLcityPop, STLcntyPop, STLmetroPop, MOremainingPop
%
% Create these variables such that they represent the population of each
% region in _units of 100,000 people_, i.e., store 2.93310 in |STLcityPop|.

STLcityPop = 293310;
STLcntyPop = 997183;
STLmetroPop = 1518802;
MoremainingPop = 4036603;

%%%
% Next, we need to find and isolate the subset of data that we're
% interested in. The data use
% <https://en.wikipedia.org/wiki/Federal_Information_Processing_Standards
% Federal Information Processing Standards (FIPS)> to identify each
% geographic region. The FIPS code consists of a 2-digit state identifier
% and a 3-digit county identifier appended together as 5 digits.
%
% *FIPS codes*
%
% * St. Louis city: 29510
% * St. Louis county: 29189
% * St. Louis metropolitan area (without St. Louis city and county): St.
% Charles, Jefferson, Franklin, Warren and Lincoln counties in Missouri and
% Monroe, Madison, St. Clair, Jersey, Calhoun, Macoupin, Bond, and Clinton
% counties in Illinois. The relevant FIPS codes are: 29183, 29099, 29071,
% 29219, 29113, 17133, 17119, 17163, 17083, 17013, 17117, 17005, and 17027.
% * Use all remaining Missouri counties for the "remaining Missouri" case
% counts.

%%%
% *(2 pts.)* Use logical indexing to create five new tables representing
% COVID data from each geographic region we wish to analyze. To make the
% data uniform, only keep data recorded on or after March 18, 2020. Store
% these data in new tables with the names:
%
%   COVID_STLcity, COVID_STLcnty, COVID_STLmetro, COVID_remainMO
%
% A very convenient tool for this is
% <https://blogs.mathworks.com/loren/2013/02/20/logical-indexing-multiple-conditions/
% logical indexing>. That is, we can create a column vector filled with
% |true| entries corresponding to rows of interest and |false| entries
% corresponding to rows that we wish to ignore.
%
% _Hint:_ The following operations and functions could be useful:
% <https://www.mathworks.com/help/matlab/logical-operations.html logical
% operations>, <https://www.mathworks.com/help/matlab/ref/datetime.html
% datetime()>, <https://www.mathworks.com/help/matlab/ref/contains.html
% contains()>.

cutoffDate = datetime(2022,3,18);


COVID_STLcity = COVID_allUS(COVID_allUS{:,"fips"}==29510,:);

COVID_STLcity(COVID_STLcity.date<cutoffDate,:)=[];


COVID_STLcnty = COVID_allUS(COVID_allUS{:,"fips"}==29189,:);

COVID_STLcnty(COVID_STLcnty.date<cutoffDate,:)=[];


predicate_STLmetro = COVID_allUS{:,"fips"}==29183| ...
    COVID_allUS{:,"fips"}==29099| ...
    COVID_allUS{:,"fips"}==29071| ...
    COVID_allUS{:,"fips"}==29219| ...
    COVID_allUS{:,"fips"}==29113| ...
    COVID_allUS{:,"fips"}==17133| ...
    COVID_allUS{:,"fips"}==17119| ...
    COVID_allUS{:,"fips"}==17163| ...
    COVID_allUS{:,"fips"}==17083| ...
    COVID_allUS{:,"fips"}==17013| ...
    COVID_allUS{:,"fips"}==17117| ...
    COVID_allUS{:,"fips"}==17005| ...
    COVID_allUS{:,"fips"}==17027;

COVID_STLmetro = COVID_allUS(predicate_STLmetro,:);

COVID_STLmetro(COVID_STLmetro.date<cutoffDate,:)=[];


predicate_inMO = COVID_allUS{:,"fips"}>=29000&COVID_allUS{:,"fips"}<=29999;

COVID_remainMO = COVID_allUS( ...
    predicate_inMO& ...
    not(predicate_STLmetro)& ...
    not(COVID_allUS{:,"fips"}==29510)& ...
    not(COVID_allUS{:,"fips"}==29189),:);

COVID_remainMO(COVID_remainMO.date<cutoffDate,:)=[];

%%%
% *(2 pts.)* We now need to compute the total number of cases for each
% multi-county geographic area, since this data isn't directly provided in
% the dataset. Case data from multiple counties on a single day needs to be
% grouped together; i.e., for the St. Louis metropolitan area, we need to
% sum the total cases from St. Charles county, Jefferson county, Franklin
% county, etc. for _each day_: March 18, March 19, March 20, etc. While
% this task would be extremely onerous in a standard programming language,
% MATLAB has convenient tools for identifying groups of data and applying a
% single operation to each group.
%
% Task: Use |findgroups()|, |splitapply()|, and |sum()| to compute the
% total number of cumulative cases in the St. Louis metropolitan area and
% the remaining counties of Missouri on each day within the dataset. Save
% these data in:
%
%   COVID_STLmetro_cases, COVID_remainMO_cases
%
% _Hint:_ The following operations and functions could be useful:
% <https://www.mathworks.com/help/matlab/ref/findgroups.html findgroups()>,
% <https://www.mathworks.com/help/matlab/ref/splitapply.html splitapply()>,
% <https://www.mathworks.com/help/matlab/ref/sum.html sum()>.

[STLMetroGrouping,metroDates] = findgroups(COVID_STLmetro{:,"date"});

COVID_STLmetro_cases = table(metroDates, ...
    splitapply(@sum,COVID_STLmetro{:,"cases"},STLMetroGrouping));


[remainMOGrouping,remainMODates] = findgroups(COVID_remainMO{:,"date"});

COVID_remainMO_cases = table(remainMODates,splitapply(@sum,COVID_remainMO{:,"cases"},remainMOGrouping));

%%%
% *(1 pt.)* Plot the cumulative cases in each geographic region as a
% function of date. Be sure to use unique line colors/styles for each
% region, label your axes, and include a legend.

figure;
plot(COVID_STLmetro_cases{:,"metroDates"},COVID_STLmetro_cases{:,"Var2"});
hold on 
plot(COVID_remainMO_cases{:,"remainMODates"},COVID_remainMO_cases{:,"Var2"});
xlabel("date");
ylabel("cases");
grid("on");
legend("St. louis Metro","Remaining MO", 'Location','northwest');
hold off

%%%
% *(1 pt.) 1. Is it reasonable to compare these data to one another? What
% should we do to the data in order to properly compare the prevalance of
% COVID cases between geographic regions?*
%
% TODO: *************************************************************
% No, because the population of the whole state is different from the
% population of metro STL. We should calculate a per capita average
% no. of cases to judge prevalence.
% *******************************************************************

%%%
% *(1 pt.)* Plot the cumulative cases in each geographic region per 100k
% population as a function of date. Be sure to use unique line
% colors/styles for each region, label your axes, and include a legend.

figure;
title("Cumulative cases");
plot(COVID_STLmetro_cases{:,"metroDates"}, ...
    COVID_STLmetro_cases{:,"Var2"}/STLmetroPop*100000);
hold on 
plot(COVID_remainMO_cases{:,"remainMODates"}, ...
    COVID_remainMO_cases{:,"Var2"}/MoremainingPop*100000);
xlabel("date");
ylabel("cases/100k capita");
grid("on");
legend("St. louis Metro cases/100k capita","Remaining MO cases/100k capita", 'Location','northwest');
hold off
%%%
% *(1 pt.) 2. Which of the geographic regions has the largest cumulative
% number of COVID cases per population density?*
%
% TODO: *************************************************************
% St. Louis Metro has the larger cumulative
% number of COVID cases per population density.
% *******************************************************************

%% Part 2: Trends in new COVID cases
% We now turn to analyzing the rate of _new_ cases reported each day. This
% data is easy to compute from a cumulative case vector |cases| by
% constructing a new |caseRate| vector, where
%
% $caseRate = (cases(2)-cases(1), cases(3)-cases(2), \cdots,
% cases(N)-cases(N-1))^T.$
%

%%%
% *(1 pt.)* Compute the new case rate per day per 100k population for each
% geographic area, and store the results in the vectors
%
%   COVID_STLcity_caseRate, COVID_STLcnty_caseRate,
%   COVID_STLmetro_caseRate, COVID_remainMO_caseRate
%
% _Hint:_ The <https://www.mathworks.com/help/matlab/ref/diff.html diff()>
% function could be useful.

[COVID_STLcity_Grouping,COVID_STLcity_Dates] = findgroups(COVID_STLcity{:,"date"});

cityRates = splitapply(@sum, ...
    COVID_STLcity{:,"cases"}, ...
    COVID_STLcity_Grouping)*100000/STLcityPop;

COVID_STLcity_caseRate = table(COVID_STLcity_Dates(2:end), ...
    diff(cityRates));


metroRates = splitapply(@sum, ...
    COVID_STLmetro{:,"cases"},STLMetroGrouping)*100000/STLmetroPop;

COVID_STLmetro_caseRate  = table(metroDates(2:end),diff(metroRates));


[COVID_STLcntyGrouping,COVID_STLcntyDates] = findgroups(COVID_STLcnty{:,"date"});
cntyRates = splitapply(@sum,COVID_STLcnty{:,"cases"}, ...
    COVID_STLcntyGrouping)*100000/STLcntyPop;

COVID_STLcnty_caseRate = table(COVID_STLcntyDates(2:end), ...
    diff(cntyRates));


remainRates = splitapply(@sum,COVID_remainMO{:,"cases"}, ...
    remainMOGrouping)*100000/MoremainingPop;

COVID_remainMO_caseRate= table(remainMODates(2:end), ...
    diff(remainRates));

% 
% COVID_remainMO_caseRate
%%%
% *(1 pt.)* Plot the new cases per day in each geographic region per 100k
% population as a function of date. Be sure to use unique line
% colors/styles for each region, label your axes, and include a legend.

figure;
title("New cases per day per 100k population");
plot(COVID_STLcity_caseRate{:,"Var1"},COVID_STLcity_caseRate{:,"Var2"});
hold on 
plot(COVID_STLmetro_caseRate{:,"Var1"},COVID_STLmetro_caseRate{:,"Var2"});
plot(COVID_STLcnty_caseRate{:,"Var1"},COVID_STLcnty_caseRate{:,"Var2"});
plot(COVID_remainMO_caseRate{:,"Var1"},COVID_remainMO_caseRate{:,"Var2"});
xlabel("date");
ylabel("new cases per 100k population");
grid("on");
legend("St. Louis city","St. Louis Metro", ...
    "St.Louis County","Remaining MO", ...
    'Location','northwest');
hold off

%%%
% *(1 pt.) 3. Examine carefully the new case data you just plotted, using
% the
% <https://www.mathworks.com/help/matlab/creating_plots/interactively-explore-plotted-data.html#mw_1470cca9-7ee0-4cad-8f3b-15106490660d
% zoom and data tip tools>. Is it easy for health officials to determine
% how effective their policies are in curbing the spread of COVID-19? If
% not, what noise effect(s) do you notice that could be filtered or removed
% from the data? Be specific.*
%
% Response: I think it is somewhat difficult to test policy results from the data,
% because there are many periodically occuring, large, yet short-lived
% spikes that can throw off an examiner when first reported. I think some
% sort of "smoothing" through averaging can help; or, the
% data points that make up those spikes can be somewhat weighed less.

%%%
% *(1 pt.)* Use the MATLAB function
% <https://www.mathworks.com/help/matlab/ref/movmean.html movmean()> to
% smooth the case rate data using a sliding window. Choose a window length
% that adequately smooths the data without destroying meaningful trends in
% the data. Store the results in the vectors
%
%   COVID_STLcity_caseRateSmooth, COVID_STLcnty_caseRateSmooth,
%   COVID_STLmetro_caseRateSmooth, COVID_remainMO_caseRateSmooth
%
%%
smoothingFactor = 25;

STLCityMovMean=movmean(COVID_STLcity_caseRate{:,"Var2"}, ...
    smoothingFactor);
STLCntyMovMean=movmean(COVID_STLcnty_caseRate{:,"Var2"}, ...
    smoothingFactor);
STLmetroMovMean=movmean(COVID_STLmetro_caseRate{:,"Var2"}, ...
    smoothingFactor);
remainMOMovMean=movmean(COVID_remainMO_caseRate{:,"Var2"}, ...
    smoothingFactor);

COVID_STLcity_caseRateSmooth = table(COVID_STLcity_caseRate{:,"Var1"}, ...
    STLCityMovMean);
COVID_STLcnty_caseRateSmooth = table(COVID_STLcnty_caseRate{:,"Var1"}, ...
    STLCntyMovMean);
COVID_STLmetro_caseRateSmooth = table(COVID_STLmetro_caseRate{:,"Var1"}, ...
    STLmetroMovMean);
COVID_remainMO_caseRateSmooth = table(COVID_remainMO_caseRate{:,"Var1"}, ...
    remainMOMovMean);

% *(1 pt.)* Plot the smoothed version of the new cases data as a function
% of date. Be sure to use unique line colors/styles for each region, label
% your axes, and include a legend.

figure;
plot(COVID_STLcity_caseRateSmooth{:,"Var1"},COVID_STLcity_caseRateSmooth{:,"Var2"});
hold on 
title("New Case Data, Smoothed");
plot(COVID_STLcnty_caseRateSmooth{:,"Var1"},COVID_STLcnty_caseRateSmooth{:,"Var2"});
plot(COVID_STLmetro_caseRateSmooth{:,"Var1"},COVID_STLmetro_caseRateSmooth{:,"Var2"});
plot(COVID_remainMO_caseRateSmooth{:,"Var1"},COVID_remainMO_caseRateSmooth{:,"Var2"});
xlabel("date");
ylabel("new cases per 100k population");
grid("on");
legend("St. Louis city","St. Louis Metro","St.Louis County","Remaining MO", 'Location','northwest');
hold off

%%%
% *(1 pt.) 4. Use 1-2 sentences to describe why you choose your window
% length value. Be specific.*
%
% TODO: *************************************************************
% I chose 25. I tried 1, 5, 10, 20, 25, 50, 100. I think 25 can rid the 
% variances to show the trends that 50+ length values can show, without
% sacrificing as much detail.
% *******************************************************************

%%%
% *(2 pts.) 5. Examining the smoothed data, identify the number of "waves"
% in cases that the St. Louis area has experienced during the pandemic.
% When did these waves occur? Don't ignore the small waves! Briefly
% speculate on the factors that contributed to the two largest spikes in
% COVID cases.*
%
% TODO: *************************************************************
% The big wave peaked at around July 4th. This could be due to the increase
% in public gatherings for Independence Day.
% The smaller waves appear to have consistent periods of 7 days. The troves
% tend to occur on Thursday to Sunday, and the peaks occur on Monday to
% Wednesday. I surmise that this is due to two factors: one, more testing
% facicilities are open during the week than during the weekends,
% so more testing are done and more data is reported. Two, people may
% contract COVID during the weekend public gatherings, to get tested
% after showing symptoms or as required by work on subsequent weekdays.
% *******************************************************************


%% Part 3: Correlations between geographic areas
% We now compare the case rates between geographic regions to see how they
% vary with one another: do they rise and fall together, or are their
% values completely unrelated? For this section, use the _smoothed_ case
% rate data you computed from Part 2 above.

%%%
% *(1 pt.)* Use the MATLAB function |corrcoef()| to compute the
% correlation coefficients between all of the |caseRateSmooth| data. Store
% these coefficients in the variable |coeffs|.
%
% Using the |categorical()| function, create a vector |places| that stores
% the names of each geographic region. This is needed for the bar plot
% later. Be sure the ordering of the names you use here match the ordering
% of the data you used for |corrcoef()|.
%
% _Hint:_ The following MATLAB functions may be helpful:
% <https://www.mathworks.com/help/matlab/ref/corrcoef.html corrcoef()>,
% <https://www.mathworks.com/help/matlab/ref/categorical.html
% categorical()>

% COVID_STLcity_caseRateSmooth
% COVID_STLcnty_caseRateSmooth
% COVID_STLmetro_caseRateSmooth
% COVID_remainMO_caseRateSmooth

% city_cnty = corrcoef(COVID_STLcity_caseRateSmooth{:,"Var2"}, ...
%     COVID_STLcnty_caseRateSmooth{:,"Var2"});
% 
% city_metro = corrcoef(COVID_STLcity_caseRateSmooth{:,"Var2"}, ...
%     COVID_STLmetro_caseRateSmooth{:,"Var2"});
% 
% city_mo = corrcoef(COVID_STLcity_caseRateSmooth{:,"Var2"}, ...
%     COVID_remainMO_caseRateSmooth{:,"Var2"});
% 
% cnty_metro = corrcoef(COVID_STLcnty_caseRateSmooth{:,"Var2"}, ...
%     COVID_STLmetro_caseRateSmooth{:,"Var2"});
% 
% cnty_mo = corrcoef(COVID_STLcnty_caseRateSmooth{:,"Var2"}, ...
%     COVID_remainMO_caseRateSmooth{:,"Var2"});
% 
% metro_mo = corrcoef(COVID_STLmetro_caseRateSmooth{:,"Var2"}, ...
%     COVID_remainMO_caseRateSmooth{:,"Var2"});

% coeffs = city_cnty(1,2);
% coeffs = [coeffs;city_metro(1,2)];
% coeffs = [coeffs;city_mo(1,2)];
% coeffs = [coeffs;cnty_metro(1,2)];
% coeffs = [coeffs;cnty_mo(1,2)];
% coeffs = [coeffs;metro_mo(1,2)];

coeffs = corrcoef([COVID_STLcity_caseRateSmooth{:,"Var2"}, ...
    COVID_STLcnty_caseRateSmooth{:,"Var2"}, ...
    COVID_STLmetro_caseRateSmooth{:,"Var2"}, ...
    COVID_remainMO_caseRateSmooth{:,"Var2"}]);
categories = categorical({'STLcity';'STLcnty';'STLmetro';'remainMO'});

%%%
% *(1 pt.)* Using the |bar()| function, plot the _specific row_ of the
% |coeffs| variable that represents the correlation coefficient of each
% geographic region with the _case rates in St. Louis city_. Be sure to
% label the x axis with geographic names. Include a y-axis label too.

figure;
bar(categories,coeffs);
hold on;
title("Correlation Coefficients");
ylabel("corrolation coefficient");
legend("STLcity","STLcnty","STLmetro","remainMO");
hold off;

%%%
% *(1 pt.) 6. Examining your plot, which region has the highest correlation
% with the cases in St. Louis city? Which region has the lowest
% correlation? Why do you think these regions are highly and uncorrelated?*
%
% TODO: *************************************************************
% Metro is the highest correlated, because it is very geographically and
% socially integrated with the city region.
% The rest of MO is the lowest correlated, because it is minimally
% integrated with the city in terms of geography and society. This is
% esprcially true for the far away counties of MO.
% *******************************************************************

%%%
% *(1 pt.)* As a scatter plot, plot the St. Louis city case rate on the x
% axis and the case rates for the two regions you gave in question 6 along
% the y axis. Be sure to label the axes appropriately, and include a figure
% legend. Check that the correlation coefficients are consistent with the
% trends shown here.

remainMO_metro_caseRate = [COVID_remainMO_caseRate{:,"Var2"} COVID_STLmetro_caseRate{:,"Var2"}];

figure;
scatter(COVID_STLcity_caseRate{:,"Var2"}, remainMO_metro_caseRate);
title("St. Louis City case rates vs. Rest of MO rates, Metro rates")
legend("city and rest of MO","city and metro");
xlabel("city case rate");
ylabel("metro and remaining MO case rates");

% The city vs rest of MO points are much more scattered. that trend reflects 
% the much lower correlation coefficient.


