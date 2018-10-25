%% PickUP_TLE
%
%% function that will grab the remaning TLEs, save them, parse them, and add them on to the current master file


load('UserPass.mat') % load in username and password
fnName = [tle_folder,'/tle_pickUP.txt'];
strTLE_PU='/';
for i=1:length(tle_to_get)
    strTLE_PU=[strTLE_PU,num2str(tle_to_get(i,1))];
    if i==length(tle_to_get)
        strTLE_PU=[strTLE_PU,'/'];
    else
        strTLE_PU=[strTLE_PU,','];
    end
end
strTLE_PU=[strTLE_PU,'orderby/ORDINAL%20asc/limit/',num2str(length(tle_to_get)),'/format/tle/metadata/false']; 

URL='https://www.space-track.org/ajaxauth/login';

post={... % Create Post (rember to referance the github)
  'identity',username,...
  'password',password,...
  'query',[...
    'https://www.space-track.org/basicspacedata/query/class/tle_latest/NORAD_CAT_ID',...
    strTLE_PU
  ]...
};

outPUTLE=urlread(URL,'Post',post,'Timeout',timeOutVal); % gets the output
outPUStr=convertCharsToStrings(outPUTLE); % coverts output to string

%% Function to save TLE string as txt

fid = fopen(fnName,'wt');
fprintf(fid, '%s', outPUStr);
fclose(fid); % prints to txt file

% gets rid of white space, from this link 
% https://www.mathworks.com/matlabcentral/answers/284560-text-file-modification-remove-blank-line
filecontent = fileread(fnName);
newcontent = regexprep(filecontent, {'\r', '\n\n+', '\n'}, {'', '\n', '\r\n'});
fid = fopen(fnName, 'w');
fwrite(fid, newcontent);
fclose(fid);