%% append_TLE

% function that will put in the TLEs that were missing into the main file


%tle_stor_PU
tleUPP=tleUP;
for i=1:length(tle_stor_PU) % replace the lines
    norCat=tle_stor_PU(i,1);
    for i=1:length(tleUPP)
        if tleUPP(i,1)==norCat
            tleUPP(i,:)=tle_stor_PU(i,:);
        end
    end
end

    