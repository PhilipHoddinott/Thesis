%% Function to check TLE
% This function checks the TLEs I have against the TLEs I wanted to have.
% It is part of my attempt to dealwith the repeating TLEs, I am dealing
% with this by varying the number of TLEs I grab

close all;
tle_stor_current=[];
end_c_T=decayEnd; % 4800
for ik=1:length(tleA)-1
    tle_stor_temp=tle_stor_Main{ik};
    tle_stor_current=[tle_stor_current;tle_stor_temp(2:tle_inc+1,:)];
end
% tleU=unique(tle_stor_current(:,:),'rows');
[C,ia,ic]=unique(tle_stor_current(:,1),'rows');
tleUP = tle_stor_current(ia,:);

for i=1:length(tleUP)
    tleCheck1(i,:)=[relDeb(i)-tleUP(i,1),relDeb(i),tleUP(i,:)];
end
figure(1)

plot(1:6388,tleCheck1(:,1))
grid on

relDebCheck=relDeb;
tle_to_get=[];
conck=1;
for i =1:length(relDebCheck) % gets the TLES that have still not been got
    if i>length(tleUP)
        fprintf('end now\n');
    elseif relDebCheck(i)~=tleUP(i,1)
        tle_to_get(conck,1)=relDebCheck(i);
        tle_to_get(conck,2)=i;
        rowIn=[relDebCheck(i),conck,conck,conck,conck,conck,conck,conck,conck,conck,conck];
%rowIn=[];%[relDebCheck(i),conck,conck,conck,conck,conck,conck,conck,conck,conck,conck];
        temp = [tleUP(1:i-1,:);rowIn];
        tempBot=tleUP(i:end,:);
        tleUP=[temp;tempBot];       
        conck=conck+1;
    end
end


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
%{
float_length=length(tle_final);
for i=1:float_length
    %if tle_final(i,2)==tle_final(i,3)
    if i>length(tle_final)
 break;
elseif tle_final(i,3)<100
        fprintf('i=%d\n',i);
        tle_final(i,:)=[];
        float_length=length(tle_final);
    end
end
%}
tle_final(:,1)=[];
float_length=length(tle_final);
philip=1;
i=1;
while philip<4
    float_length=length(tle_final);
    if i>float_length
        philip=5;
    elseif tle_final(i,2)<100
        fprintf('i=%d\n',i);
        tle_final(i,:)=[];
        float_length=length(tle_final);
    end
    i=i+1;
    float_length=length(tle_final);
    if i>float_length
        philip=5;
    end
end
    
philip=1;
i=1;
while philip<4
    float_length=length(tle_final);
    if i>float_length
        philip=5;
    elseif tle_final(i,2)<100
        fprintf('i=%d\n',i);
        tle_final(i,:)=[];
        float_length=length(tle_final);
    end
    i=i+1;
    float_length=length(tle_final);
    if i>float_length
        philip=5;
    end
end
%% For some reason it gets rid of them best with two. IDK


    