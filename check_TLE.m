%% Function to check TLE
% This function checks the TLEs I have against the TLEs I wanted to have.
% It is part of my attempt to dealwith the repeating TLEs, I am dealing
% with this by varying the number of TLEs I grab
close all;
tle_stor_current=[];
end_c_T=decayEnd-1; % 4800

for ik=1:length(tleA)-1
    tle_stor_temp=tle_stor_Main{ik};
    tle_stor_current=[tle_stor_current;tle_stor_temp(2:tle_inc+1,1)];
end
%end_c_T=length(tle_stor_current);
%diff(:)=tle_stor_current(:,1)-relDeb(1:end_c_T,1);
diff(:)=tle_stor_current(1:decayEnd-1,1)-relDeb(:,1);
lne = 1:end_c_T;
figure(1)
hold on
plot(lne,relDeb(1:end_c_T),'-x')
plot(lne, tle_stor_current(1:decayEnd-1,1),'-o')
grid on
figure(2)
hold on
plot(lne,diff,'-x')
grid on
pk=1;
for i=1:1200%length(diff)
    if abs(diff(i))>0
        fprintf('problem %d:\n',pk);
        for j=1:5
        fprintf('rd: %d, tl: %d, i = %d\n',relDeb(i+j-3),tle_stor_current(i+j-3),(i+j-3));
        end
        fprintf('\n');
        pk=pk+1;
    end
end

    

%{
for ik=1:3%12 % till i fix this
    tle_stor_current=tle_stor_Main{ik};
    
    lne = 2:decayEnd;
    f1=(2*(ik-1))+1; % figure names
    f2=(2*(ik-1))+2; % figure names
    figure(f1)
    hold on
    plot(lne(1:tle_inc),relDeb(tleA(ik):tleA(ik+1)-1),'-x')
    plot(lne(1:tle_inc), tle_stor_current(2:tle_inc+1,1),'-o')
    grid on

    stDiff = tleA(ik+1)-10;
    diff(:)=tle_stor_current(1:tle_inc,1)-relDeb((tle_inc*(ik-1))+1:tle_inc*(ik));
    %for i=1:tle_inc-1
    %    diff(i)=tle_stor_current(i+1,1)-relDeb(i);
    %end
    
    figure(f2)
    plot(lne(tleA(ik):tleA(ik+1)-1),diff)
    grid on
    
    for i=stDiff:tleA(ik+1)
        fprintf('%d, ',relDeb(i));
    end
    fprintf('\n');
    for i=stDiff+1:tle_inc+1
        fprintf('%d, ',tle_stor_current(i,1));
    end
    fprintf('\n');
    for i=1:tle_inc
        fprintf('%d, ',diff(i));
    end
    fprintf('\n');
    %relDeb(492:500)
    %tle_stor_1_500(493:501,1)
end
%}