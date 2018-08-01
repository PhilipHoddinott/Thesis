%% Handles getMultiple_TLE_from_ID
% This function acts as the "handler for getMultiple_TLE_from_ID"

load('UserPass.mat') % load in username and password
if exist(tle_folder)~=7 % if the folder does not exist it will make it
    mkdir(tle_folder)% tle_text_files % note this will give a warning if folder already exists
end
tleA = 1:tle_inc:decayEnd;
tleA=[tleA,decayEnd];

jStart =1; % starting value, will get reset if the connection times out
jEnd=length(tleA)-1;
while j~=jEnd % ensures that try catch keeps running untill it has gone all the way though
    try
        for j = jStart:jEnd % try normal loop
            get_Multiple_TLE_from_Id % returns 'outStr' String of TLE
        end

    catch ME      % time out catch
       switch ME.identifier
            case 'MATLAB:urlread:Timeout'
               warning('connection timed out at j = %d, trying again',j);
               jStart=j;
               for j = jStart:jEnd % rerun loop
                    get_Multiple_TLE_from_Id % creates text file of tles
               end
       end
    end
end
