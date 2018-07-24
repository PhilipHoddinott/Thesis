%% Master Program
% By Philip Hoddinott
%% Setup
close all; clear all; clc; % clear workspace
%% get data
VarStore % run var store for stored variables, ugly but it works
get_SATCAT % get SATCAT, comment out if already run
clear all; % clear those variables, comment of already run
VarStore % run var store for stored variables, ugly but it works

strNamMat = ['SATCAT_',num2str(launchYear),'.mat'];
load(strNamMat); % load mat of SATCAT

relDeb=str2num(char(all_TLE(2:decayEnd,2)));
relDeb=sort(relDeb); % Sort by NORAD CAT ID

get_TLE_from_Id % returns 'outStr' String of TLE

save_TLE % Saves TLEs as txt file

