%% Function to read TLEs from text files
% Credit to:
% Brett Pantalone
% North Carolina State University
% Department of Electrical and Computer Engineering
% Optical Sensing Laboratory
% mailto:bapantal@ncsu.edu
% http://research.ece.ncsu.edu/osl/
% Need to check how to cite github

% Modified to save TLEs
% after i get one working I will get it to loop through multiple TLEs

    file = fnName;
 catalog = [];

  fd = fopen(file,'r');
  if fd < 0, fd = fopen([file '.tle'],'r'); end
  assert(fd > 0,['Can''t open file ' file ' for reading.'])

  j = 0;
%  A0 = fgetl(fd);
A0='unknown';
  A1 = fgetl(fd);
  A2 = fgetl(fd);

  while ischar(A2)
    j = j + 1;
    satnum = str2num(A1(3:7));
    if isempty(catalog) || ismember(satnum, catalog)
      %fprintf('%s\n', repmat('-',1,50));
      %fprintf('Satellite: %s\n', A0)
      assert(chksum(A1), 'Checksum failure on line 1')
      assert(chksum(A2), 'Checksum failure on line 2')
      %fprintf('Catalog Number: %d\n', satnum)
      %fprintf('Epoch time: %s\n', A1(19:32)) % YYDDD.DDDDDDDD
      Incl = str2num(A2(9:16));
      %fprintf('Inclination: %f deg\n', Incl)
      Omega = str2num(A2(18:25));
      %fprintf('RA of ascending node: %f deg\n', Omega)
      ecc = str2num(['.' A2(27:33)]);
      %fprintf('Eccentricity: %f\n', ecc)
      w = str2num(A2(35:42));
      %fprintf('Arg of perigee: %f deg\n', w)
      M = str2num(A2(44:51));
      %fprintf('Mean anomaly: %f deg\n', M)
      n = str2num(A2(53:63));
      %fprintf('Mean motion: %f rev/day\n', n)
      T = 86400/n;
      %fprintf('Period of rev: %.0f s/rev\n', T)
      a = ((T/(2*pi))^2*398.6e12)^(1/3);
      %fprintf('Semi-major axis: %.0f meters\n', a)
      b = a*sqrt(1-ecc^2);
      %fprintf('Semi-minor axis: %.0f meters\n', b)
      
      %tle_stor_1_500(n+1,:)=[satnum,str2num(A1(19:32)),Incl,Omega,ecc,w,M,n,T,a,b];
      
      tle_stor_PU(j+1,1)=satnum;
      tle_stor_PU(j+1,2)=str2num(A1(19:32));
      tle_stor_PU(j+1,3)=Incl;
      tle_stor_PU(j+1,4)=Omega;
      tle_stor_PU(j+1,5)=ecc;
      tle_stor_PU(j+1,6)=w;
      tle_stor_PU(j+1,7)=M;
      tle_stor_PU(j+1,8)=n;
      tle_stor_PU(j+1,9)=T;
      tle_stor_PU(j+1,10)=a;
      tle_stor_PU(j+1,11)=b;
      disp(tle_stor_PU);
    end

   % A0 = fgetl(fd);
    A1 = fgetl(fd);
    A2 = fgetl(fd);
     disp(tle_stor_PU);
  end

  fclose(fd);
 
  %tle_stor_Main{ik}=tle_stor_PU(:,:);

%end

%%
% Checksum (Modulo 10)
% Letters, blanks, periods, plus signs = 0; minus signs = 1
function result = chksum(str)
  result = false; c = 0;
  
  for k = 1:68
    if str(k) > '0' && str(k) <= '9'
      c = c + str(k) - 48;
    elseif str(k) == '-'
      c = c + 1;
    end
  end

  if mod(c,10) == str(69) - 48
    result = true;
  end
  
end
