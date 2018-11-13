function [state] = state_from_mcoe(a,ecc,inc,omasc,omper,anom,tag)
tag='mea';
%STATE_FROM_MCOE Summary of this function goes here
%   Detailed explanation goes here
%--------------------------------------------------------------------------
% inputs:
%     a     semi-major axis [m]
%     ecc   eccentricity
%     inc   inclination [deg]
%     omasc right-ascension of the ascending node [deg]
%     omper argument of perigee [deg]
%     anom  time since perigee [s] or true/mean/eccentric anomaly [deg]
%     tag   string-tag: 'time', 'true' (default), 'mean' or 'eccentric'
% 
% output:
%     Y     state vector (position[m], velocity[m/s])
%
%--------------------------------------------------------------------------
%function Y = kep2cart(a,ecc,inc,omasc,omper,anom,tag)
anom = anom(:);
if (nargin < 7)
    tag = 'true';
end
tag = lower(tag(1:3));
GM  = 3.986004418e14;
n   = sqrt(GM./a.^3);
if strcmp(tag,'tim')
    M = n.*anom;
    E = kepler(M,ecc,1e-10);
elseif strcmp(tag,'tru')
    f = anom/180*pi;
    E = atan2(sqrt(1-ecc.^2).*sin(f),ecc+cos(f));
elseif strcmp(tag,'ecc')
    E = anom/180*pi;
elseif strcmp(tag,'mea')
    E = kepler(anom/180*pi,ecc,1e-10);
else
    error('Undefined anomaly-type TAG.')
end
pos = [a.*(cos(E)-ecc), a.*sqrt(1-ecc.^2).*sin(E), zeros(size(anom))];
vel = [-sin(E), sqrt(1-ecc.^2).*cos(E), zeros(size(anom))];
vel = vel .* ( (n.*a./(1-ecc.*cos(E)))*[1 1 1] );
pos = rot(pos,-omper,3);
pos = rot(pos,-inc,1);
pos = rot(pos,-omasc,3);
vel = rot(vel,-omper,3);
vel = rot(vel,-inc,1);
vel = rot(vel,-omasc,3);
state = [pos,vel]';

%--------------------------------------------------------------------------
% inputs:
%     mm  - mean anomaly [rad]	- matrix
%     ecc - eccentricity        - matrix
%     tol - tolerance level (def: 1e-10)
% 
% outputs:
%     ee  - eccentric anomaly [rad]
%     itr - number of iterations (optional)
%
%--------------------------------------------------------------------------
function [ee,itr] = kepler(mm,ecc,tol)
if (nargin<3)
    tol = 1e-10;
end
if ( isempty(tol) )
    error('TOL should be scalar')
end
if ( any(ecc(:) >= 1) || any(ecc(:) < 0) )
   error('Non-valid eccentricity')
end
maxitr = 20;
mm    = rem(mm,2*pi);
eeold = mm;
eenew = eeold + ecc.*sin(eeold);
itr   = 0;
while ( any(any(abs(eenew-eeold)>tol)) && (itr<maxitr) )
    itr   = itr + 1;
    eeold = eenew;
    fold  = (eeold-ecc.*sin(eeold)-mm);
    fpold = (1-ecc.*cos(eeold));
    eenew = eeold - fold./fpold;
end
if ( (itr == maxitr) && (any(any(abs(eenew-eeold)>tol))) )
   error('KEPLER didn''t achieve convergence within 20 iterations')
else
   ee = eenew;
end
end
function xout = rot(xin,alfa,i)
[r,c] = size(xin);
if ( (r ~= 3) && (c ~= 3) )
    error('XIN should be Nx3 or 3xN matrix')
elseif c == 3
    dotransp = 0;
else
    xin = xin';
    dotransp = 1;
end 
nx = size(xin,1);
na = length(alfa);
if ( (na == 1) && (nx > 1) )
    alfa = alfa*ones(nx,1);
elseif ( (na > 1) && (nx == 1) )
    xin = xin(ones(na,1),:);
elseif na ~= nx
    error('ALFA and XIN don''t match')
end
c = cos(alfa(:)/180*pi);
s = sin(alfa(:)/180*pi);
x = xin(:,1);
y = xin(:,2);
z = xin(:,3);
if (i == 1)
    xout = [    x    ,  c.*y+s.*z, -s.*y+c.*z];
elseif (i == 2)
    xout = [c.*x-s.*z,     y     ,  s.*x+c.*z];
elseif (i == 3)
    xout = [c.*x+s.*y, -s.*x+c.*y,     z     ];
else
    error('Choose axis I = 1, 2, or 3')
end
if (dotransp)
    xout = xout';
end
end
%--------------------------------------------------------------------------
%  Input:
%    angle       angle of rotation [rad]
%
%  Output:
%    rotmat      rotation matrix
%
% Last modified:   2018/01/27   M. Mahooti
%--------------------------------------------------------------------------
function rotmat = R_z(angle)
C = cos(angle);
S = sin(angle);
rotmat = zeros(3,3);
rotmat(1,1) =    C; rotmat(1,2) = S; rotmat(1,3) = 0;
rotmat(2,1) = -1*S; rotmat(2,2) = C; rotmat(2,3) = 0;
rotmat(3,1) =    0; rotmat(3,2) = 0; rotmat(3,3) = 1;
end
end


