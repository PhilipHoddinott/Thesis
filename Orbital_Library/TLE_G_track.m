clear all; close all; 
strLoc='C:\Users\Philip\Documents\GitHub\Thesis\mat_files\';


strNam=[strLoc,'TLE_2000.mat'];
load(strNam,'dateCreated','tle_final')
% Inputs:  o Kepler - A vector of length 6 containing all of the keplerian
%                    orbital elements [a,ecc,inc,Omega,w,nu] in km and radians
%          o GMSTo  - The Greenwich Mean Siderial Time at the given initial position
%                     in radians.
%          o Tf     - The length of time to plot the groundtrack in seconds
%          o fig    - The figure number on which to plot the groundtrack [OPTIONAL]
%          o dT     - Timesteps for groundtrack, defaults to 60 seconds [OPTIONAL]
%          o s      - String for customizing the plot (example: '--b*').
%                     See, help plot, for more information [OPTIONAL]
%          o mu     - Gravitational constant of Earth. Defaults to
%                     3998600.4415 km^3/s^2 [OPTIONAL]
%
% Outputs: o H      - The figure handle
year=(tle_final(i,2)-mod(tle_final(i,2),1000))/1000;


    year  = year(dateCreated);  month = month(dateCreated);  day   = day(dateCreated);
    hour  = hour(dateCreated);    min   = minute(dateCreated); sec   = second(dateCreated);
    n=length(tle_final(:,1));
figure(1)
hold on
n=10;
for i=1:n
%    for i =210:227

    tle=tle_final(i,:);
    a=tle(10);
    ecc=tle(5);
    inc=tle(3);
    Omega=tle(4);
    w=tle(6);
    nu=tle(7);
    Kepler=[a,ecc,inc,Omega,w,nu];
    Tf=60*60;
    dT=90;


    long  = -73.99;
    %Julian day

    UT = hour + min/60 + sec/3600;
    J0 = 367*year - floor(7/4*(year + floor((month+9)/12))) ...
        + floor(275*month/9) + day + 1721013.5;
    JD = J0 + UT/24;              % Julian Day
    fprintf('Julian day = %6.4f [days] \n',JD);
    %Julian day = 2456394.3413 [days]
    %JC is Julian centuries between the Julian day J0 and J2000(2,451,545.0) Greenwich sidereal time at 0 hr UT can be calculated by this equation [Seidelmann,1992]

    JC = (J0 - 2451545.0)/36525;
    
    GST0 = 100.4606184 + 36000.77004*JC + 0.000387933*JC^2 - 2.583e-8*JC^3; %[deg]
    GST0 = mod(GST0, 360);  % GST0 range [0..360]
    GMSTo=GST0*pi/180;
    
    
    
    
    %fprintf('Greenwich sidereal time at 0 hr UT %6.4f [deg]\n',GST0);
    JD=tle_final(i,2);
    JD0 = NaN(size(JD));
JDmin = floor(JD)-.5;
JDmax = floor(JD)+.5;
JD0(JD > JDmin) = JDmin(JD > JDmin);
JD0(JD > JDmax) = JDmax(JD > JDmax);
H = (JD-JD0).*24;       %Time in hours past previous midnight
D = JD - 2451545.0;     %Compute the number of days since J2000
D0 = JD0 - 2451545.0;   %Compute the number of days since J2000
T = D./36525;           %Compute the number of centuries since J2000
%Calculate GMST in hours (0h to 24h) ... then convert to degrees
GMST = mod(6.697374558 + 0.06570982441908.*D0  + 1.00273790935.*H + ...
    0.000026.*(T.^2),24).*15;
GMST=GMST*pi/180;
GMSTo=GMST;
    
    fig=1;
    mu=3998600.4415;% km^3/s^2;
    s='--b*';
    [h] = Groundtrack(Kepler,GMSTo,Tf,fig,dT,s,mu)
end