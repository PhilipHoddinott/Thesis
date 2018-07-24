%% Gets SATCAT from NORARD Query
% based off this code: 
% https://github.com/jgte/matlab-sgp4/blob/master/get_tle.m

load('UserPass.mat') % load in username and password

URL='https://www.space-track.org/ajaxauth/login';

post={... % Create Post (rember to referance the github)
  'identity',username,...
  'password',password,...
  'query',[...
    'https://www.space-track.org/basicspacedata/query/class/satcat/OBJECT_TYPE/debris/',...
    'RCS_SIZE/small/LAUNCH_YEAR/>',num2str(launchYear),'/'...
    'orderby/DECAY asc/format/csv/metadata/false',...
  ]...
};


out=urlread(URL,'Post',post,'Timeout',50); % gets the output
outStr=convertCharsToStrings(out); % coverts output to string


newStr = strsplit(outStr,["\n"]); % split string by line break
for i=1:length(newStr) % split string by commas
    all_TLE(i,:) = strsplit(newStr(i),','); 
end

[m,n] = size(all_TLE); % get size of matrix

for i=1:m % remove the " marks
    for j=1:n
        all_TLE(i,j)=strip(all_TLE(i,j),'left','"');
        all_TLE(i,j)=strip(all_TLE(i,j),'right','"');
    end
end

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
all_TLE(1,1:8) % check it worked
all_TLE(decayEnd,1:8)

all_TLES=sortrows(all_TLE(2:end,:),2); % sort rows
all_TLE=[all_TLE(1,:);all_TLES]; % save the sorted row by NORAD ID


strNam = ['SATCAT_',num2str(launchYear),'.mat'];
save(strNam,'all_TLE','decayEnd');