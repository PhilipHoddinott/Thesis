%% Master Program
% By Philip Hoddinott
%% Setup
close all; clear all; clc; % clear workspace
%% get data
VarStore % run var store for stored variables, ugly but it works
%% func get_SATCAT
% Function to get a .mat file from the SATCAT
%%%%%%%%%%%%%%%%%%%%%%%%% Uncomment to run
%get_SATCAT % get SATCAT, comment out if already run

strNamMat = ['SATCAT_',num2str(launchYear),'.mat'];
load(strNamMat); % load mat of SATCAT

relDeb=str2num(char(all_TLE(2:decayEnd,2))); % get NORAD CAT ID

%% func get_Multiple_TLE_from_Id
% Function to get tle txt files from the norat_cat_ids in the SATCAT
VarStore % run var store for stored variables, ugly but it works
%%%%%%%%%%%%%%%%%%%%%%%%% Uncomment to run
%get_Multiple_TLE_from_Id % returns 'outStr' String of TLE

%% Func readTLE_txt
% function to parse the txt files into a usable TLE, stored in a matrix
fprintf('readTLE_txt\n');
readTLE_txt

%% Func check_TLE_edit_TLE
% function to neatly sort TLEs, remove duplicates, and list TLEs that were
% not given
fprintf('check_TLE_Edit_TLE\n');
check_TLE_Edit_TLE

strNam = ['TLE_',num2str(launchYear),'.mat']; % save the TLE as a .mat
save(strNam,'tle_final');


close all; clear all; % clear out everything
VarStore % run var store for stored variables, ugly but it works
strNam = ['TLE_',num2str(launchYear),'.mat']; % get strNam

load(strNam, 'tle_final')


