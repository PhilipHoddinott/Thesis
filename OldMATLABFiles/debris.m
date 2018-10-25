classdef debris
    %DEBRIS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      name
      CatNum % Catalog Number
      EpochTime % Epoch time YYDDD.DDDDDDDD
      Inc % Inclination (deg)
      RAAN % RA of ascending node: (deg)
      ecc % Eccentricity
      w % Arg of Perigee (deg)
      M % Mean anomaly (deg)
      n % Mean motion (rev/day)
      T %= 86400/n; % Period of rev s/rev
      a %= ((T/(2*pi))^2*398.6e12)^(1/3); % Semi-major axis (meters)
      b %= a*sqrt(1-ecc^2); % Semi-minor axis (meters)
    end
    
    methods
        %{
        function obj = debris(inputArg1,inputArg2)
            %DEBRIS Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        %}
    end
        
end

