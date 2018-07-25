%% Master Program
% By Philip Hoddinott
%% Setup
close all; clear all; clc; % clear workspace
%% get data
VarStore % run var store for stored variables, ugly but it works
%% func 
%get_SATCAT % get SATCAT, comment out if already run
%clear all; % clear those variables, comment of already run
VarStore % run var store for stored variables, ugly but it works

strNamMat = ['SATCAT_',num2str(launchYear),'.mat'];
load(strNamMat); % load mat of SATCAT

relDeb=str2num(char(all_TLE(2:decayEnd,2))); % get NORAD CAT ID

%% func
VarStore % run var store for stored variables, ugly but it works
%get_Multiple_TLE_from_Id % returns 'outStr' String of TLE
%% func % THIS FUNC NO LONGER USED
%save_TLE % Saves TLEs as txt file
% this is probally un nesssisary, as I could just combind this to 
%file = 'tle_1_1_500.txt';
%file =['tle_1_1_',num2str(tle_inc),'.txt'];
%file = [tle_folder,'/',file];
fprintf('readTLE_txt\n');
readTLE_txt

%check_TLE
fprintf('check_TLE_Edit_TLE\n');
check_TLE_Edit_TLE

fprintf('pickUP_TLE\n');
pickUP_TLE

fprintf('readTLE_PU_txt\n');
readTLE_PU_txt

fprintf('append_TLE\n');
append_TLE
%% TO DO
% Make the funcitons more atnomus, call loops inside the master program
% like the get_TLE stuff



