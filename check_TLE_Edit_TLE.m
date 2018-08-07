%% Function to check TLE
% This function checks the TLEs I have against the TLEs I wanted to have.
% It is part of my attempt to dealwith the repeating TLEs, I am dealing
% with this by varying the number of TLEs I grab

close all;
tle_stor_current=[];

for ik=1:length(tleA)-1 % save all tles to one array
    tle_stor_temp=tle_stor_Main{ik};
    tle_stor_current=[tle_stor_current;tle_stor_temp(2:tle_inc+1,:)];
end

[C,ia,ic]=unique(tle_stor_current(:,1),'rows'); % sort by row by norard cat id
tleUP_1 = tle_stor_current(ia,:);

tleUP=tleUP_1;
tle_final=tleUP_1;

%%%%%%%%%%%%%%%%% 
%% TO DO
 removeA=[];
    if inc_2_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,3)>inc_2
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end
    %% PUT THAT IN FOR REMOVING ROWS YOU FUCK
    %%%%%%%%%%%%%%%%%%%%%%%%%%
%{
relDebCheck=relDeb;
tle_to_get=[]; conck=1;
for i =1:length(relDebCheck) % gets the TLES that have still not been got
    if i>length(tleUP)
        fprintf('end now\n');
    elseif relDebCheck(i)~=tleUP(i,1)
        tle_to_get(conck,1)=relDebCheck(i);
        tle_to_get(conck,2)=i;
        rowIn=[relDebCheck(i),conck,conck,conck,conck,conck,conck,conck,conck,conck,conck]; % adjuss where duplicates are
        temp = [tleUP(1:i-1,:);rowIn];
        tempBot=tleUP(i:end,:);
        tleUP=[temp;tempBot];       
        conck=conck+1;
    end
end

% un comment for plots that show all the tles are matching

for i=1:length(tleUP)
    tleCheck1(i,:)=[relDeb(i)-tleUP(i,1),relDeb(i),tleUP(i,:)];
end

figure(1)

plot(1:length(tleCheck1(:,1)),tleCheck1(:,1))
grid on

figure(7)
hold on
plot(1:length(tleUP),tleUP(:,1),'-o')
plot(1:length(tleUP),relDebCheck(1:length(tleUP)),'-x')
grid on

for ip=1:length(tleUP)
    diff4(ip)=abs(tleUP(ip,1)-relDebCheck(ip));
end
figure(8)
plot(1:ip,diff4)
grid on


for i=1:length(relDebCheck)-1
    tleCompCheck(i,:)=[relDebCheck(i),tleUP(i,:)];
end
 fprintf('prepare for fina\n');
tile_pre_final=tleCompCheck;
tle_final=tleCompCheck;

tle_final(:,1)=[];
float_length=length(tle_final);

for dup=1:3 % removes the duplicate lines
    iDup=1;
    i=1;
    while iDup<4
        float_length=length(tle_final);
        if i>float_length
            iDup=5;
        elseif tle_final(i,2)<100
            % fprintf('i=%d\n',i); % prints out duplicates
            tle_final(i,:)=[];
            float_length=length(tle_final);
        end
        i=i+1;
        float_length=length(tle_final);
        if i>float_length
            iDup=5;
        end
    end
end
    %}

%% For some reason it gets rid of them best with two. IDK


strNam = ['mat_files/TLE_',num2str(launchYear),'.mat']; % save the TLE as a .mat
dateCreated=datetime;
save(strNam,'tle_final','dateCreated');


    