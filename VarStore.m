launchYear=1980;
numberTLE = 1100; % number of satilies TLEs to get
tle_inc=200; % the number of TLEs in a text file, will fiddle with to see if i can deal with repeates
%tle_inc=200; % the number of TLEs in a text file, will fiddle with to see if i can deal with repeates
tle_folder = 'tle_text_files_'; tle_folder=[tle_folder,'LY_',num2str(launchYear),'_',num2str(tle_inc)];

%timeOutVal=150; % time till time out for url read
timeOutVal=150; % time till time out for url read
%decayEnd=6425;

