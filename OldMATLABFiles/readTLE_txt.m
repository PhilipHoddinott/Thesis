%% Function to read TLEs from text files
% Credit to:
% Brett Pantalone
% North Carolina State University
% Department of Electrical and Computer Engineering
% Optical Sensing Laboratory
% mailto:bapantal@ncsu.edu
% http://research.ece.ncsu.edu/osl/
% Need to check how to cite github

tleA = 1:tle_inc:decayEnd;
tleA=[tleA,decayEnd];

numArrays = length(tleA)-1;
tle_stor_Main = cell(numArrays,1);

for ik = 1: length(tleA)-1 % Loop through TLE folder
    
    if tleA(ik+1)==decayEnd % get file name
        file = [tle_folder,'/tle_',num2str(ik),'_',num2str(tleA(ik)),'_',num2str(tleA(ik+1)),'.txt'];
    else
        file = [tle_folder,'/tle_',num2str(ik),'_',num2str(tleA(ik)),'_',num2str(tleA(ik+1)-1),'.txt'];
    end
    catalog = [];

    fd = fopen(file,'r');
    if fd < 0, fd = fopen([file '.tle'],'r'); end
    assert(fd > 0,['Can''t open file ' file ' for reading.'])

    j = 0;

    A0='unknown';
    A1 = fgetl(fd);
    A2 = fgetl(fd);

    while ischar(A2)
        j = j + 1;
        satnum = str2num(A1(3:7));
        if isempty(catalog) || ismember(satnum, catalog)   
            assert(chksum(A1), 'Checksum failure on line 1')
            assert(chksum(A2), 'Checksum failure on line 2')

            Incl = str2num(A2(9:16));
            Omega = str2num(A2(18:25));
            ecc = str2num(['.' A2(27:33)]);
            w = str2num(A2(35:42));      
            M = str2num(A2(44:51));      
            n = str2num(A2(53:63));      
            T = 86400/n;      
            a = ((T/(2*pi))^2*398.6e12)^(1/3);      
            b = a*sqrt(1-ecc^2);     
            % uncomment for display
            %{ 
            fprintf('%s\n', repmat('-',1,50));
            fprintf('Satellite: %s\n', A0);
            fprintf('Catalog Number: %d\n', satnum);
            fprintf('Epoch time: %s\n', A1(19:32)) % YYDDD.DDDDDDDD
            fprintf('Inclination: %f deg\n', Incl)
            fprintf('RA of ascending node: %f deg\n', Omega)
            fprintf('Eccentricity: %f\n', ecc);
            fprintf('Arg of perigee: %f deg\n', w);
            fprintf('Mean anomaly: %f deg\n', M);
            fprintf('Mean motion: %f rev/day\n', n);
            fprintf('Period of rev: %.0f s/rev\n', T);
            fprintf('Semi-major axis: %.0f meters\n', a);
            fprintf('Semi-minor axis: %.0f meters\n', b);
            %}

            tle_stor(j+1,1)=satnum;
            tle_stor(j+1,2)=str2num(A1(19:32));
            tle_stor(j+1,3)=Incl;
            tle_stor(j+1,4)=Omega;
            tle_stor(j+1,5)=ecc;
            tle_stor(j+1,6)=w;
            tle_stor(j+1,7)=M;
            tle_stor(j+1,8)=n;
            tle_stor(j+1,9)=T;
            tle_stor(j+1,10)=a;
            tle_stor(j+1,11)=b;
        end

        A1 = fgetl(fd);
        A2 = fgetl(fd);
    end

    fclose(fd);
    tle_stor_Main{ik}=tle_stor(:,:);
end


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
