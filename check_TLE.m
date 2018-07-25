%% Function to check TLE
% This function checks the TLEs I have against the TLEs I wanted to have.
% It is part of my attempt to dealwith the repeating TLEs, I am dealing
% with this by varying the number of TLEs I grab
lne = 2:decayEnd;
figure(1)
hold on
plot(lne(1:tle_inc),relDeb(1:tle_inc),'-x')
plot(lne(1:tle_inc), tle_stor_1_500(2:tle_inc+1,1),'-o')

for i=1:tle_inc
    diff(i)=tle_stor_1_500(i+1,1)-relDeb(i);
end
figure(2)
plot(lne(1:leee),diff)
grid on
stDiff = tle_inc-10;
for i=stDiff:tle_inc
    fprintf('%d, ',relDeb(i));
end
fprintf('\n');
for i=stDiff+1:tle_inc+1
    fprintf('%d, ',tle_stor_1_500(i,1));
end
fprintf('\n');
for i=stDiff:tle_inc
    fprintf('%d, ',diff(i));
end
fprintf('\n');
%relDeb(492:500)
%tle_stor_1_500(493:501,1)
