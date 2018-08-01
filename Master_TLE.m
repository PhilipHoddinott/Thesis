%% Master Program
% By Philip Hoddinott
%% Setup
close all; clear all; clc; % clear workspace

get_SATCAT_tog =0; % toggle for get_SATCAT 1 = run, 0 = don't run
get_Multiple_TLE_from_Id_tog =0;
readTLE_txt_tog=0;
check_TLE_Edit_TLE_tog=0;
%% get data
VarStore % run var store for stored variables, ugly but it works


%% check for existing data
strNam = ['TLE_',num2str(launchYear),'.mat']; % get strNam
%if exist(strNam, 'file') == 2
try 
    load(strNam, 'tle_final','dateCreated'); % load in file
    cTime =datetime;
    if cTime>(dateCreated+calweeks(1)) % 
        fprintf('The file %s, was created within the last week\n',strNam);
        get_SATCAT_tog =0; % toggle for get_SATCAT 1 = run, 0 = don't run
        get_Multiple_TLE_from_Id_tog =0;
        readTLE_txt_tog=0;
        check_TLE_Edit_TLE_tog=0;
    else
        fprintf('File is one week out of date, auto running program\n');
        get_SATCAT_tog =1; % toggle for get_SATCAT 1 = run, 0 = don't run
        get_Multiple_TLE_from_Id_tog =1;
        readTLE_txt_tog=1;
        check_TLE_Edit_TLE_tog=1;
    end


catch
    switch ME.identifier
        case 'MATLAB:load:couldNotReadFile'
            warning('File does not exist, auto running program\n');
        case 'MATLAB:UndefinedFunction'
            warning('dateCreated not found, auto running program\n');
                    
    end
   
    get_SATCAT_tog =1; % toggle for get_SATCAT 1 = run, 0 = don't run
    get_Multiple_TLE_from_Id_tog =1;
    readTLE_txt_tog=1;
    check_TLE_Edit_TLE_tog=1;
end
    
    


%% func get_SATCAT
% Function to get a .mat file from the SATCAT

if get_SATCAT_tog==1 % if the satcat file is out of date, run this
    get_SATCAT % get SATCAT, comment out if already run
    fprintf('get_SATCAT.m has finished running\n'); % output SATCAT has run
else % if the satcat file is recent then no nead to run get_SATCAT
    strNamMat = ['SATCAT_',num2str(launchYear),'.mat'];
    load(strNamMat); % load mat of SATCAT
    %decayEnd=length(all_TLE(:,1));
    fprintf('get_SATCAT.m was not run\n'); % output SATCAT was not run
end

relDeb=str2num(char(all_TLE(2:decayEnd,2))); % get NORAD CAT ID

%% func get_Multiple_TLE_from_Id
% Function to get tle txt files from the norat_cat_ids in the SATCAT
VarStore % run var store for stored variables, ugly but it works

if get_Multiple_TLE_from_Id_tog==1
   get_TLE_from_Id
   fprintf('get_Multiple_TLE_from_Id.m has finished running\n');
else
    fprintf('get_Multiple_TLE_from_Id.m was not run\n');
end

%% Func readTLE_txt
% function to parse the txt files into a usable TLE, stored in a matrix
if readTLE_txt_tog==1
    readTLE_txt
    fprintf('readTLE_txt.m has finished running\n');
else
    fprintf('readTLE_txt.m was not run\n');
end

%% Func check_TLE_edit_TLE
% function to neatly sort TLEs, remove duplicates, and list TLEs that were
% not given

if check_TLE_Edit_TLE_tog==1
    check_TLE_Edit_TLE
    fprintf('check_TLE_Edit_TLE.m has finished running\n');
else
    fprintf('check_TLE_Edit_TLE.m was not run\n');
end



close all; clear all; % clear out everything
VarStore % run var store for stored variables, ugly but it works
strNam = ['TLE_',num2str(launchYear),'.mat']; % get strNam

load(strNam, 'tle_final')

tle_low=sortrows(tle_final(:,:),11);
save('Orbits_MOD_1/tle_low2high.mat','tle_low');

% Note that these files could be made functions in MATLAB. For debuggin
% purposes they currently are not 

tle_view=tle_final;
tle_view_temp=["norad_cat_id","Epoch time","Inclination (deg)","RAAN (deg)","Eccentricity (deg)","Arg of perigee(deg)","Mean anomaly (deg)","Mean motion (rev/day)","Period of rev (s/rev)","Semi-major axis (meter)","Semi-minor axis (meter)"];

tle_veiw = [tle_view_temp;tle_view]; % useful for looking at numbers

strNam = ['TLE_',num2str(launchYear),'.mat']; % get strNam
if exist(strNam, 'file') == 2
    load(strNam, 'tle_final'); % load in file
    tle_latest=sortrows(tle_final(:,:),2); % sort by last epoch
    c=clock;
    %cyear=clock(1); cmonth=clock(2); cday =clock(3); chour=clock(4); cmin=clock(5); csec=clock(6);
    cyear=c(1); cmonth=c(2); cday =c(3); chour=c(4); cmin=c(5); csec=c(6);
    tleY=mod(tle_latest(:,2),cyear)
    
    
    
end
