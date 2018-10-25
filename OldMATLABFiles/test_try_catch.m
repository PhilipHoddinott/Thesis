clear all;
%{
strN='tleNON.mat';
str1='TLE_1980.mat';
try
    %load(strN);
    load(str1,'datecreated');
    a=datecreated;
    i=1;
catch ME
    i=0;
    switch ME.identifier
        case 'MATLAB:load:couldNotReadFile'
            i=4;
    end
    
end
%}

%{

strNam = ['TLE_',num2str(launchYear),'.mat']; % get strNam
%if exist(strNam, 'file') == 2
try 
    load(strNam, 'tle_final','dateCreated'); % load in file
    cTime =datetime;
    if cTime>(dateCreated+calweeks(1)) % 
        fprintf('The file %s, was created within the last week\n',strNam);
    end


catch
    warning('Warning tle file has no creation date, auto running program\n');
    get_SATCAT_tog =1; % toggle for get_SATCAT 1 = run, 0 = don't run
    get_Multiple_TLE_from_Id_tog =1;
    readTLE_txt_tog=1;
    check_TLE_Edit_TLE_tog=1;
end
%}
%{
try
    a = notaFunction(5,6);
catch ME
    switch ME.identifier
        case 'MATLAB:UndefinedFunction'
            warning('Function is undefined.  Assigning a value of NaN.');
            a = NaN;
        case 'MATLAB:scriptNotAFunction'
            warning(['Attempting to execute script as function. '...
                'Running script and assigning output a value of 0.']);
            notaFunction;
            a = 0;
        otherwise
            rethrow(ME)
    end
end
%}

VarStore
try 
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


    out=urlread(URL,'Post',post,'Timeout',1); % gets the output
catch ME
    switch ME.identifier
        case 'MATLAB:urlread:Timeout'
            %warning(['MATLAB timed out\n']);
            warning(['MATLAB timed out\n']);
    end
        
    fprintf('hi\n');
end
    