%% get_SATCAT.m
% By Philip Hoddinott
% This code gets SATCAT from NORARD Query via post requests. 
% This code was based off of the following code: https://github.com/jgte/matlab-sgp4/blob/master/get_tle.m
%VarStore
%load('UserPass.mat') % load in username and password
%username = 'exampleUser';
%password='examplePass';
%timeOutVal=30;
function postOutput = examplePostRequest(username,password,timeOutVal)
VarStore
load('UserPass.mat') % load in username and password
baseURL='https://www.space-track.org/'; % base URL
logURL=[baseURL,'ajaxauth/login']; % login URL
querySatcatURL=[baseURL,'basicspacedata/query/class/tle/format/tle/', 'NORAD_CAT_ID/25544/orderby/EPOCH%20desc/limit/1']; % query URL

post={'identity',username, 'password', password, 'query', querySatcatURL}; % create post request

postOutput=urlread(logURL,'Post',post,'Timeout',timeOutVal); % runs and gets the output of the post request
end 
%{
newStr = strsplit(outStr,["\n"]); % split string by line break
for i=1:length(newStr) % split string by commas
    all_TLE(i,:) = strsplit(newStr(i),','); 
end


[m,n] = size(all_TLE); % get size of matrix
%% Remove " marks
for i=1:m % remove the " marks
    for j=1:n
        all_TLE(i,j)=strip(all_TLE(i,j),'left','"');
        all_TLE(i,j)=strip(all_TLE(i,j),'right','"');
    end
end

%%  find where the last decayed item is and remove it 
decay_loc=8;

for i=1:length(all_TLE(1,:)) % find the columm decay is located in, it should be in 8
    if all_TLE(1,i)=="DECAY"
        decay_loc = i;  % save decay loc
    end
end


decayEnd=m+10;
for i=2:length(newStr) % find the columm decay is located in, it should be in 8
    if all_TLE(i,decay_loc)~=[""] && decayEnd==m+10
        decayEnd=i-1; % get the last location where there is no yet decay
    end
end
all_TLE=all_TLE(1:decayEnd,:); % trim to only have debris that has not yet decayed


all_TLES=sortrows(all_TLE(2:end,:),2); % sort rows by NORAD ID
all_TLE=[all_TLE(1,:);all_TLES]; % save the sorted row by NORAD ID

%% save to a file
strNam = ['mat_files/SATCAT_',num2str(launchYear),'.mat'];
save(strNam,'all_TLE','decayEnd');
%}