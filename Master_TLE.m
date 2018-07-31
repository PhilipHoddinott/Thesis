%% Master Program
% By Philip Hoddinott
%% Setup
close all; clear all; clc; % clear workspace

get_SATCAT_tog =0; % toggle for get_SATCAT 1 = run, 0 = don't run
get_Multiple_TLE_from_Id_tog =0;
%% get data
VarStore % run var store for stored variables, ugly but it works
%% func get_SATCAT
% Function to get a .mat file from the SATCAT

if get_SATCAT_tog==1
    get_SATCAT % get SATCAT, comment out if already run
else
    strNamMat = ['SATCAT_',num2str(launchYear),'.mat'];
    load(strNamMat); % load mat of SATCAT
end
fprintf('get_SATCAT.m has finished running\n');
relDeb=str2num(char(all_TLE(2:decayEnd,2))); % get NORAD CAT ID

%% func get_Multiple_TLE_from_Id
% Function to get tle txt files from the norat_cat_ids in the SATCAT
VarStore % run var store for stored variables, ugly but it works

if get_Multiple_TLE_from_Id_tog==1
    load('UserPass.mat') % load in username and password
    mkdir(tle_folder)% tle_text_files % note this will give a warning if folder already exists
    tleA = 1:tle_inc:decayEnd;
    tleA=[tleA,decayEnd];
    
    jStart =1; % starting value
    %Connection timed out.
    
    try

        for j = jStart:length(tleA)-1%1:length(tleA)-1
            get_Multiple_TLE_from_Id % returns 'outStr' String of TLE
        end
    catch ME
        fprintf('Something happened\n');
        jStart=j;
       switch ME.identifier
           case 'MATLAB:Connection timed out'
               warning('connection timed out, trying again\n');
               fprintf('Connection time out occured\n');
               jStart=j;
               for j = jStart:length(tleA)-1%1:length(tleA)-1
                    get_Multiple_TLE_from_Id % returns 'outStr' String of TLE
               end
       end
       rethrow(ME)
    end
end

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


%close all; clear all; % clear out everything
VarStore % run var store for stored variables, ugly but it works
strNam = ['TLE_',num2str(launchYear),'.mat']; % get strNam

load(strNam, 'tle_final')

tle_low=sortrows(tle_final(:,:),11);
save('Orbits_MOD_1/tle_low2high.mat','tle_low');

% Note that these files could be made functions in MATLAB. For debuggin
% purposes they currently are not 


