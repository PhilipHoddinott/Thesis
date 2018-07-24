%% Function to save TLE string as txt

fnName = ['tle_',num2str(numberTLE),'.txt'];
fid = fopen(fnName,'wt');
fprintf(fid, '%s', outStr);
fclose(fid); % prints to txt file

% gets rid of white space, from this link 
% https://www.mathworks.com/matlabcentral/answers/284560-text-file-modification-remove-blank-line
filecontent = fileread(fnName);
newcontent = regexprep(filecontent, {'\r', '\n\n+', '\n'}, {'', '\n', '\r\n'});
fid = fopen(fnName, 'w');
fwrite(fid, newcontent);
fclose(fid);


