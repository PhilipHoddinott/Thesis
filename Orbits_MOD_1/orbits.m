function [] = orbits(action);
% This function plots an Earth orbit based on
% the following orbtial elements:
% perigee = altitude at perigee (miles)
% apogee = altitude at apogee (miles)
% i = inclination of orbital plane to equatorial plane (degrees)
% Omega = argument of ascending node (degrees)
% omega = argument of periapsis (degrees)
%
% Written with Matlab 5.3 by: 
% Michael Hanchak  (mhanchak AT yahoo DOT com) 
% Dayton, Ohio 
% August 9, 2001
%
% Reference Text:
% Fundamentals of Astrodynamics
% Published by Dover Press, 1971
%
% Users of this function assume all risk in using the calculations
% contained within. This function is not to be distributed without 
% the author's full consent.
%
% For best results, requires "coast.mat" and "topo.mat"

% standard switchyard programming logic
if nargin == 0;
   action = 'build';
end

% Earth radius (miles)
rad = 6378136/1000/1.6;
rad = (6378136/1000)*0.621371;
colors = [.6 .7 .8];
colors2 = 'k';
switch action
   
   % build GUI
case 'build'
   
   %strings = {'w','W','i','Apogee','Perigee'};
   strings = {'w','W','i','Apogee','Perigee','numOrb'};
   tags = {'o','O','i','alt_a','alt_p','numOrb'};
   values = {'45','45','30','345','115','10'};
   strings2 = {'Plot Debris','Plot Orbit','Clear Orbits','Center Earth',...
         'Zoom All','Flyby','Help','Toggle Earth','Quit'};
   callbacks = {'orbits(''plot_deb'')','orbits(''plot'')','orbits(''clear'')',...
         'camva(15);view(120,30);camlookat(findobj(''tag'',''earth''));',...
         'camva(15);camlookat','orbits(''flyby'')','help orbits',...
         'orbits(''earth'')','close(gcf)'};
   
   if isempty(findobj('tag','orbits'))
      www = figure('tag','orbits');%,'units','normalized','outerposition',[0 0 1 1]);
   else
      www = findobj('tag','orbits');
      figure(www);
      clf
   end
   set(www,'position',[25   75   600   500],'color',colors2);
   set(gcf, 'Position', get(0, 'Screensize'));
   %ylim=get(gca,'ylim')
   %xlim=get(gca,'xlim')
   %text(xlim(1),ylim(2),'yourtext')

   for kk = 1:length(strings)
      ppp = uicontrol('Units','pixels','Position',[2 (20*(kk-1)+16) 50 20],...
         'String',strings{kk},'style','text','backgroundcolor',colors2,...
         'foregroundcolor','w','fontsize',9);
      uicontrol('Units','pixels','Position',[55 (20*(kk-1)+16) 50 20],...
         'tag',tags{kk},'style','edit','string',values{kk},'backgroundcolor',[1 1 1]);
      if kk <=2
         set(ppp,'fontname','symbol','fontsize',12);
      end
   end
   str2Pos=375;
   for kk =1:length(strings2)
       
      uicontrol('Units','pixels','Position',[10 (25*(kk-1)+str2Pos) 70 22],...
         'string',strings2{kk},'callback',callbacks{kk},'backgroundcolor',colors);
   end
  %{ 
   uicontrol('Style', 'popup',...
           'String', {'Zoom All','Flyby','Help','Toggle Earth'},...
           'Position', [20 340 100 50],...
           'Callback',{'camva(15);camlookat','orbits(''flyby'')','help orbits','orbits(''earth'')'})
    %} 
   
   
   string3 = {'w','W','i','Apogee','Perigee'};
   tags1 = {'o_1','O_1','i_1','alt_a_1','alt_p_1'};
   tags2 = {'o_2','O_2','i_2','alt_a_2','alt_p_2'};
   %values1 = {'0','40','40','340','110'};
   %values2 = {'360','45','60','345','115'};
   values1 = {'a','a','40','a','a'};
   values2 = {'a','a','60','a','a'};
   %'units','normalized',
   ps1=1350;
   ps2=ps1+53;
   ps3=ps2+53;
   for kk = 1:length(string3)
      ppp = uicontrol('position',[ps1 (20*(kk-1)+16) 50 20],'units','normalized',...
         'String',string3{kk},'style','text','backgroundcolor',colors2,...
         'foregroundcolor','w','fontsize',9);
      uicontrol('position',[ps2 (20*(kk-1)+16) 50 20],'units','normalized',...
         'tag',tags1{kk},'style','edit','string',values1{kk},'backgroundcolor',[1 1 1]);
       uicontrol('position',[ps3 (20*(kk-1)+16) 50 20],'units','normalized',...
         'tag',tags2{kk},'style','edit','string',values2{kk},'backgroundcolor',[1 1 1]);
      if kk <=2
         set(ppp,'fontname','symbol','fontsize',12);
      end
   end
   
    uicontrol('Units','pixels','Position',[1403 160 70 22],...
         'string','Plot From To','callback','orbits(''plot_from_to_2'')','backgroundcolor',colors);
   uicontrol('position',[1403 120 150 25],'units','normalized',...
      'string',['From              To'],...
      'style','text','backgroundcolor',colors2,'fontsize',8,...
      'HorizontalAlignment','left','foregroundcolor','w');
  
    uicontrol('position',[1403 220 150 40],'units','normalized',...
    'string',['Plot Orbits between values (leave blank for all)'],...
    'style','text','backgroundcolor',colors2,'fontsize',8,...
    'HorizontalAlignment','left','foregroundcolor','w');
   
   fP = get(www, 'Position');
   %{
    for kk = 1:length(string3)
      ppp = uicontrol('Units','pixels','Position',[ps1 (20*(kk-1)+16) 50 20],...
         'String',string3{kk},'style','text','backgroundcolor',colors2,...
         'foregroundcolor','w','fontsize',9);
      uicontrol('Units','pixels','Position',[ps2 (20*(kk-1)+16) 50 20],...
         'tag',tags{kk},'style','edit','string',values{kk},'backgroundcolor',[1 1 1]);
      if kk <=2
         set(ppp,'fontname','symbol','fontsize',12);
      end
   end
   %}
       
   %{
   cbkp={'orbits(''flyby'')','help orbits','orbits(''earth'')'};
     uicontrol('Style', 'popup',...
           'String', {'Flyby','Help','Toggle Earth'},...
           'Position', [20 340 100 50],...
           'Callback',cbkp)
      %} 
       
         % strings2 = {'plot_to_from','Plot Debris','Plot Orbit','Clear Orbits','Center Earth',...
         %'Zoom All','Flyby','Help','Toggle Earth','Quit'};
  % callbacks = {'orbits(''plot_to_from'')','orbits(''plot_deb'')','orbits(''plot'')','orbits(''clear'')',...
  %       'camva(15);view(120,30);camlookat(findobj(''tag'',''earth''));',...
  %       'camva(15);camlookat','orbits(''flyby'')','help orbits',...
  %       'orbits(''earth'')','close(gcf)'};
   %uicontrol('Units','pixels','Position',[10 370 100 80],...
   uicontrol('position',[10 780 120 80],'units','normalized',...
      'string',['Left click and drag Earth for dynamic viewing.',...
         ' Right click for zooming. Double-Click to center. '],...
      'style','text','backgroundcolor',colors2,'fontsize',8,...
      'HorizontalAlignment','left','foregroundcolor','w');
   axes('position',[.2 .05 .75 .9],'units','normalized')
   axis equal
   axis off
   axis vis3d
   hold on

   % Plot reference frame axes
   h1 = plot([0 rad+500],[0 0],'r-');
   h2 = plot([0 0],[0 rad+500],'g-');
   h3 = plot3([0 0],[0 0],[0 rad+500],'color',[0 0 .8]);
   set([h1 h2 h3],'linewidth',4);
   
   view(120,30);
   camva(15);
   rot3d;
   data.simple = 1;
   data.handles = [];
   data.earthhandle = [];
   set(gcf,'userdata',data);
   
   orbits('earth') % call routine to draw earth
   camlookat(findobj('tag','earth'));
   
case 'earth'   
      % determine level of graphics
  
   data = get(gcf,'userdata');   
   simple = data.simple;
   delete(data.earthhandle);
   data.earthhandle = [];
   % Plot the earth (texture map or simple)
   if simple == 0 & ~isempty(which('topo.mat'))
      
      [X,Y,Z] = sphere(50);
      load topo
      topo = [topo(:,181:360) topo(:,1:180)];
      mat.dull.AmbientStrength = 0.4;
      mat.dull.DiffuseStrength = .6;
      mat.dull.SpecularColorReflectance = .5;
      mat.dull.backfacelighting = 'reverselit';
      mat.dull.SpecularExponent = 20;
      mat.dull.SpecularStrength = .8;
      data.earthhandle(1) = surface(rad*X,rad*Y,rad*Z, ...
         mat.dull, ...
         'FaceColor','texturemap',...
         'EdgeColor','none',...
         'FaceLighting','phong',...
         'Cdata',topo,'tag','earth');   
      colormap(topomap1)
      data.earthhandle(2) = light('position',rad*[10 10 10]);
      %light('position',rad*[-10 -10 -10], 'color', [.6 .2 .2]);
      %set(gcf,'renderer','opengl');
      data.simple = 1;
   else
      
      [X,Y,Z] = sphere(24);
      data.earthhandle(1) = mesh(rad*X,rad*Y,rad*Z);
      %set(data.earthhandle,'tag','earth','facecolor',[.6 .7 .9],'edgecolor',[1 1 1]);
		set(data.earthhandle(1),'tag','earth','facecolor',[0 0 1],'edgecolor',[.3 .3 1]);
      if ~isempty(which('coast.mat'))
         
         load coast
         ncst = ncst *pi/180;
         all =zeros(length(ncst),3);
         for j = 1:length(ncst)
            theta = ncst(j,1);
            phi = ncst(j,2);
            all(j,:) = [cos(theta)*cos(phi),...
                  sin(theta)*cos(phi),...
                  -sin(phi)];
         end
         
         data.earthhandle(2) = plot3(rad*all(:,1),rad*all(:,2),-rad*all(:,3));
         set(data.earthhandle(2),'color',[0 .9 0]);
         
      end
      data.simple = 0;
   end
   
   
   set(gcf,'userdata',data);

%%%%% REmove this case
case 'plot_to_from'

    %load('tle_RANN.mat', 'tle_high')
    load('tle_INC.mat', 'tle_INC')
    tle_arr=tle_INC;
    lowT = str2num(get(findobj('tag','to'),'string'))
    highF = str2num(get(findobj('tag','from'),'string'))
    for i = 1:length(tle_arr(:,3))
        if tle_arr(i,3)<lowT
            lowV=i
            break;
        end
    end
    for i = 1:length(tle_arr(:,3))
        if tle_arr(i,3)<highF
            highV=i
            break;
        end
    end
    deg2rad = pi/180;
    for countP=highV:lowV%lowV:highV
        philip(tle_arr,countP,highV,rad)
        %{
        inc =  tle_arr(countP,3);
        alt_p=(tle_arr(countP,11)-6378136)*0.000621371192;
        alt_a=(tle_arr(countP,10)-6378136)*0.000621371192;
        Omega=tle_arr(countP,4)
        omega=tle_arr(countP,6);
        fprintf('Finished orbit %d of %d\n',countP,highV);

        data = get(gcf,'userdata');
        handles = data.handles;

   % check for correctness of input data
       if alt_p > alt_a
          error1 = errordlg('Perigee must be smaller than apogee');
          waitfor(error1);
       else

          % Orbital elements
          a = (alt_p + alt_a + 2*rad)/2;
          c = a - alt_p - rad;
          e = c/a;
          p = a*(1 - e^2);

          th = linspace(0,2*pi,200);
          r = p./(1 + e*cos(th));
          xx = r.*cos(th);
          yy = r.*sin(th);

          Omega = Omega*deg2rad;
          inc = inc*deg2rad; 
          omega = omega*deg2rad; 

          % Coordinate Transformations
          ZZ = [cos(Omega) -sin(Omega) 0;
             sin(Omega) cos(Omega) 0;
             0 0 1];
          XX = [1 0 0;
             0 cos(inc) -sin(inc);
             0 sin(inc) cos(inc)];
          ZZ2 = [cos(omega) -sin(omega) 0;
             sin(omega) cos(omega) 0;
             0 0 1];

          % actual plot
          vec = ZZ*XX*ZZ2*[xx;yy;zeros(1,length(xx))];
          h1 = plot3(vec(1,:),vec(2,:),vec(3,:));
          set([h1],'linewidth',1,'color',[1 1 1]);

          % line of ascending node
          vec1 = ZZ*[rad+600;0;0];
          h2 = plot([0 vec1(1)],[0 vec1(2)],'r-');
          % line of periapsis
          vec2 = ZZ*XX*ZZ2*[rad+600;0;0];
          h3 = plot3([0 vec2(1)],[0 vec2(2)],[0 vec2(3)],'color',...
             [1 1 0]);
          % line of inclination
          vec3 = ZZ*XX*[0;0;rad+600];
          h4 = plot3([0 vec3(1)],[0 vec3(2)],[0 vec3(3)],...
             'color',[0 0 .8]);
          set([h2 h3 h4],'linewidth',2);

          data.handles = [data.handles h1 h2 h3 h4];
          %data.handles = [data.handles h1 ];%h2 h3 h4];
          set(gcf,'userdata',data);
          %camlookat;
       end
       % plot orbits
        %}
    end
        
        
% end plot to from
      
case 'plot_from_to_2'
    load('tle_1960.mat', 'tle_final');
    tle_arr=tle_final;
    initLen=length(tle_arr(:,1));
    
    alt_p_1_a = get(findobj('tag','alt_p_1'),'string');
    alt_p_1 = str2num(alt_p_1_a);
    alt_p_1=alt_p_1+6378136/1000;
    
    alt_a_1_a = get(findobj('tag','alt_a_1'),'string');
    alt_a_1 = str2num(alt_a_1_a);
    alt_a_1=alt_a_1+6378136/1000;
    
    inc_1_a = get(findobj('tag','i_1'),'string');
    inc_1 = str2num(inc_1_a);
    
    Omega_1_a = get(findobj('tag','O_1'),'string');
    Omega_1 = str2num(Omega_1_a);
    
    omega_1_a = get(findobj('tag','o_1'),'string');
    omega_1 = str2num(omega_1_a);
    
  
    removeA=[];
    if alt_p_1_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,11)<alt_p_1
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end
    
    removeA=[];
    if alt_a_1_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,10)<alt_a_1
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end

    removeA=[];
    if inc_1_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,3)<inc_1
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end
   
    
    if Omega_1_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,4)<Omega_1
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end
    
     if omega_1_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,6)<omega_1
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
     end
    
    alt_p_2_a = get(findobj('tag','alt_p_2'),'string');
    alt_p_2 = str2num(alt_p_2_a);
    alt_p_2=alt_p_2+6378136/1000;
    
    
    alt_a_2_a = get(findobj('tag','alt_a_2'),'string');
    alt_a_2 = str2num(alt_a_2_a);
    alt_a_2=alt_a_2+6378136/1000;
    
    inc_2_a = get(findobj('tag','i_2'),'string');
    inc_2 = str2num(inc_2_a);
    
    Omega_2_a = get(findobj('tag','O_2'),'string');
    Omega_2 = str2num(Omega_2_a);
    
    omega_2_a = get(findobj('tag','o_2'),'string');
    omega_2 = str2num(omega_2_a);
    
    
    
    removeA=[];
    if alt_p_2_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,11)>alt_p_2
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end
    
    removeA=[];
    if alt_a_2_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,10)>alt_a_2
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end
    
   removeA=[];
    if inc_2_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,3)>inc_2
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end
    
    removeA=[];
    if Omega_2_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,4)>Omega_2
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end    

    removeA=[];
    if omega_2_a~='a'
        for i =1:length(tle_arr(:,1))
            if tle_arr(i,6)>omega_2
                removeA=[removeA,i];                
            end
        end
        tle_arr(removeA,:)=[];
    end   
    
    save('check.mat','tle_arr','inc_1','inc_2','tle_final','alt_p_2');
    c=clock;
    cyear=c(1); cmonth=c(2); cday =c(3); chour=c(4); cmin=c(5); csec=c(6);
    fprintf('Operation performed on ');
    fprintf('%d/%d/%d, at %d:%d:%.3f\n',cday,cmonth,cyear,chour,cmin,csec);
    fprintf('Debris bounds (blank means no data entered):\n');
    fprintf('Perigee (km): %.3f - %.3f\n',alt_p_1,alt_p_2);
    fprintf('Apogee (km): %.3f - %.3f\n',alt_a_1,alt_a_2);
    fprintf('Inclination (deg): %.3f - %.3f\n',inc_1,inc_2);
    fprintf('Longitude of the ascending node  (deg): %.3f - %.3f\n',Omega_1,Omega_2);
    fprintf('Argument of periapsis (deg): %.3f - %.3f\n',omega_1,omega_2);
    fprintf('Out of %d debris, %d debris found within bounds\n',initLen,length(tle_arr(:,1)));
    
    
    
    
    
   deg2rad = pi/180;
   highV=length(tle_arr(:,1));
   for countP=1:length(tle_arr(:,1))
       %countP
       %vp1=length(tle_arr(:,1))
       %philip(tle_arr,countP,vp1,rad)
       
        deg2rad = pi/180;
        inc =  tle_arr(countP,3);
        alt_p=(tle_arr(countP,11)-6378136)*0.000621371192;
        alt_a=(tle_arr(countP,10)-6378136)*0.000621371192;
        Omega=tle_arr(countP,4);
        omega=tle_arr(countP,6);
        %fprintf('Finished orbit %d of %d\n',countP,highV);

        data = get(gcf,'userdata');
        handles = data.handles;

   % check for correctness of input data
       if alt_p > alt_a
          error1 = errordlg('Perigee must be smaller than apogee');
          waitfor(error1);
       else

          % Orbital elements
          a = (alt_p + alt_a + 2*rad)/2;
          c = a - alt_p - rad;
          e = c/a;
          p = a*(1 - e^2);

          th = linspace(0,2*pi,200);
          r = p./(1 + e*cos(th));
          xx = r.*cos(th);
          yy = r.*sin(th);

          Omega = Omega*deg2rad;
          inc = inc*deg2rad;
          omega = omega*deg2rad; 

          % Coordinate Transformations
          ZZ = [cos(Omega) -sin(Omega) 0;
             sin(Omega) cos(Omega) 0;
             0 0 1];
          XX = [1 0 0;
             0 cos(inc) -sin(inc);
             0 sin(inc) cos(inc)];
          ZZ2 = [cos(omega) -sin(omega) 0;
             sin(omega) cos(omega) 0;
             0 0 1];

          % actual plot
          vec = ZZ*XX*ZZ2*[xx;yy;zeros(1,length(xx))];
          h1 = plot3(vec(1,:),vec(2,:),vec(3,:));
          set([h1],'linewidth',1,'color',[1 1 1]);

          % line of ascending node
          vec1 = ZZ*[rad+600;0;0];
          h2 = plot([0 vec1(1)],[0 vec1(2)],'r-');
          % line of periapsis
          vec2 = ZZ*XX*ZZ2*[rad+600;0;0];
          h3 = plot3([0 vec2(1)],[0 vec2(2)],[0 vec2(3)],'color',...
             [1 1 0]);
          % line of inclination
          vec3 = ZZ*XX*[0;0;rad+600];
          h4 = plot3([0 vec3(1)],[0 vec3(2)],[0 vec3(3)],...
             'color',[0 0 .8]);
          set([h2 h3 h4],'linewidth',2);

          data.handles = [data.handles h1 h2 h3 h4];
          %data.handles = [data.handles h1 ];%h2 h3 h4];
          set(gcf,'userdata',data);
          %camlookat;
       end
       %
   end


%{
load('TLE_1990.mat', 'tle_final')
   deg2rad = pi/180;
   for countP=1:500
    inc =  tle_final(countP,3)
    alt_p=tle_final(countP,11)*0.000621371192;
    alt_a=tle_final(countP,10)*0.000621371192;
    Omega=tle_final(countP,4)
    omega=tle_final(countP,6)
%}
    %{
   data = get(gcf,'userdata');
   handles = data.handles;
   

   % check for correctness of input data
   if alt_p > alt_a
      error1 = errordlg('Perigee must be smaller than apogee');
      waitfor(error1);
   else
      
      % Orbital elements
      a = (alt_p + alt_a + 2*rad)/2;
      c = a - alt_p - rad;
      e = c/a;
      p = a*(1 - e^2);
      
      th = linspace(0,2*pi,200);
      r = p./(1 + e*cos(th));
      xx = r.*cos(th);
      yy = r.*sin(th);
      
      Omega = Omega*deg2rad;
      inc = inc*deg2rad; 
      omega = omega*deg2rad; 
      
      % Coordinate Transformations
      ZZ = [cos(Omega) -sin(Omega) 0;
         sin(Omega) cos(Omega) 0;
         0 0 1];
      XX = [1 0 0;
         0 cos(inc) -sin(inc);
         0 sin(inc) cos(inc)];
      ZZ2 = [cos(omega) -sin(omega) 0;
         sin(omega) cos(omega) 0;
         0 0 1];
      
      % actual plot
      vec = ZZ*XX*ZZ2*[xx;yy;zeros(1,length(xx))];
      h1 = plot3(vec(1,:),vec(2,:),vec(3,:));
      set([h1],'linewidth',1,'color',[1 1 1]);
      
      % line of ascending node
      vec1 = ZZ*[rad+600;0;0];
      h2 = plot([0 vec1(1)],[0 vec1(2)],'r-');
      % line of periapsis
      vec2 = ZZ*XX*ZZ2*[rad+600;0;0];
      h3 = plot3([0 vec2(1)],[0 vec2(2)],[0 vec2(3)],'color',...
         [1 1 0]);
      % line of inclination
      vec3 = ZZ*XX*[0;0;rad+600];
      h4 = plot3([0 vec3(1)],[0 vec3(2)],[0 vec3(3)],...
         'color',[0 0 .8]);
      set([h2 h3 h4],'linewidth',2);
      
      data.handles = [data.handles h1 h2 h3 h4];
      %data.handles = [data.handles h1 ];%h2 h3 h4];
      set(gcf,'userdata',data);
      %camlookat;
   end
   % plot orbits
    %}
  


case 'plot_deb'

%load('tle_low2high.mat', 'tle_low')
%load('tle_high2low.mat', 'tle_high')
load('tle_RANN.mat', 'tle_high')
tle_arr=tle_high;
numOrb = str2num(get(findobj('tag','numOrb'),'string'));
   deg2rad = pi/180;
   for countP=1:numOrb
    inc =  tle_arr(countP,3);
    alt_p=(tle_arr(countP,11)-6378136)*0.000621371192;
    alt_a=(tle_arr(countP,10)-6378136)*0.000621371192;
    Omega=tle_arr(countP,4);
    omega=tle_arr(countP,6);
    fprintf('Finished orbit %d of %d\n',countP,numOrb);

%{
load('TLE_1990.mat', 'tle_final')
   deg2rad = pi/180;
   for countP=1:500
    inc =  tle_final(countP,3)
    alt_p=tle_final(countP,11)*0.000621371192;
    alt_a=tle_final(countP,10)*0.000621371192;
    Omega=tle_final(countP,4)
    omega=tle_final(countP,6)
%}
   data = get(gcf,'userdata');
   handles = data.handles;
   
   % get orbital elements from GUI
   %alt_p = str2num(get(findobj('tag','alt_p'),'string'));
   %alt_a = str2num(get(findobj('tag','alt_a'),'string'));
   %inc = str2num(get(findobj('tag','i'),'string'));
   %Omega = str2num(get(findobj('tag','O'),'string'));
   %omega = str2num(get(findobj('tag','o'),'string'));
   
   % check for correctness of input data
   if alt_p > alt_a
      error1 = errordlg('Perigee must be smaller than apogee');
      waitfor(error1);
   else
      
      % Orbital elements
      a = (alt_p + alt_a + 2*rad)/2;
      c = a - alt_p - rad;
      e = c/a;
      p = a*(1 - e^2);
      
      th = linspace(0,2*pi,200);
      r = p./(1 + e*cos(th));
      xx = r.*cos(th);
      yy = r.*sin(th);
      
      Omega = Omega*deg2rad;
      inc = inc*deg2rad; 
      omega = omega*deg2rad; 
      
      % Coordinate Transformations
      ZZ = [cos(Omega) -sin(Omega) 0;
         sin(Omega) cos(Omega) 0;
         0 0 1];
      XX = [1 0 0;
         0 cos(inc) -sin(inc);
         0 sin(inc) cos(inc)];
      ZZ2 = [cos(omega) -sin(omega) 0;
         sin(omega) cos(omega) 0;
         0 0 1];
      
      % actual plot
      vec = ZZ*XX*ZZ2*[xx;yy;zeros(1,length(xx))];
      h1 = plot3(vec(1,:),vec(2,:),vec(3,:));
      set([h1],'linewidth',1,'color',[1 1 1]);
      
      % line of ascending node
      vec1 = ZZ*[rad+600;0;0];
      h2 = plot([0 vec1(1)],[0 vec1(2)],'r-');
      % line of periapsis
      vec2 = ZZ*XX*ZZ2*[rad+600;0;0];
      h3 = plot3([0 vec2(1)],[0 vec2(2)],[0 vec2(3)],'color',...
         [1 1 0]);
      % line of inclination
      vec3 = ZZ*XX*[0;0;rad+600];
      h4 = plot3([0 vec3(1)],[0 vec3(2)],[0 vec3(3)],...
         'color',[0 0 .8]);
      set([h2 h3 h4],'linewidth',2);
      
      data.handles = [data.handles h1 h2 h3 h4];
      %data.handles = [data.handles h1 ];%h2 h3 h4];
      set(gcf,'userdata',data);
      %camlookat;
   end
   % plot orbits
  end
case 'plot'
   deg2rad = pi/180;
   
   data = get(gcf,'userdata');
   handles = data.handles;
   
   % get orbital elements from GUI
   alt_p = str2num(get(findobj('tag','alt_p'),'string'));
   alt_a = str2num(get(findobj('tag','alt_a'),'string'));
   inc = str2num(get(findobj('tag','i'),'string'));
   Omega = str2num(get(findobj('tag','O'),'string'));
   omega = str2num(get(findobj('tag','o'),'string'));
   
   % check for correctness of input data
   if alt_p > alt_a
      error1 = errordlg('Perigee must be smaller than apogee');
      waitfor(error1);
   else
      
      % Orbital elements
      a = (alt_p + alt_a + 2*rad)/2;
      c = a - alt_p - rad;
      e = c/a;
      p = a*(1 - e^2);
      
      th = linspace(0,2*pi,200);
      r = p./(1 + e*cos(th));
      xx = r.*cos(th);
      yy = r.*sin(th);
      
      Omega = Omega*deg2rad;
      inc = inc*deg2rad; 
      omega = omega*deg2rad; 
      
      % Coordinate Transformations
      ZZ = [cos(Omega) -sin(Omega) 0;
         sin(Omega) cos(Omega) 0;
         0 0 1];
      XX = [1 0 0;
         0 cos(inc) -sin(inc);
         0 sin(inc) cos(inc)];
      ZZ2 = [cos(omega) -sin(omega) 0;
         sin(omega) cos(omega) 0;
         0 0 1];
      
      % actual plot
      vec = ZZ*XX*ZZ2*[xx;yy;zeros(1,length(xx))];
      h1 = plot3(vec(1,:),vec(2,:),vec(3,:));
      set([h1],'linewidth',1,'color',[1 1 1]);
      
      % line of ascending node
      vec1 = ZZ*[rad+600;0;0];
      h2 = plot([0 vec1(1)],[0 vec1(2)],'r-');
      % line of periapsis
      vec2 = ZZ*XX*ZZ2*[rad+600;0;0];
      h3 = plot3([0 vec2(1)],[0 vec2(2)],[0 vec2(3)],'color',...
         [1 1 0]);
      % line of inclination
      vec3 = ZZ*XX*[0;0;rad+600];
      h4 = plot3([0 vec3(1)],[0 vec3(2)],[0 vec3(3)],...
         'color',[0 0 .8]);
      set([h2 h3 h4],'linewidth',2);
      
      data.handles = [data.handles h1 h2 h3 h4];
      set(gcf,'userdata',data);
      %camlookat;
   end
   
case 'clear'
   data = get(gcf,'userdata');
   handles = data.handles;
   for rr = 1:length(handles)
      if ishandle(handles(rr))
         delete(handles(rr));
      end
   end
   data.handles = [];
   set(gcf,'userdata',data);
   
case 'flyby'
   camlookat(findobj('tag','earth'));
   camva(15);
   camup([0 0 1]);
   for x = -300000:1000:60000
      campos([x,30000,30000])
      drawnow
   end
   
   % here are the recursive callbacks for the rotation of the axes
case 'rot'
   rot3d('rot');
case 'down'
   rot3d('down');
case 'up'
   rot3d('up');
case 'zoom'
   rot3d('zoom');
   
end

% this function below allows for dynamics "click and drag"
%  rotation of the plot.

function philip(tle_arr,countP,highV,rad)
        
        deg2rad = pi/180;
        inc =  tle_arr(countP,3);
        alt_p=(tle_arr(countP,11)-6378136)*0.000621371192;
        alt_a=(tle_arr(countP,10)-6378136)*0.000621371192;
        Omega=tle_arr(countP,4);
        omega=tle_arr(countP,6);
        fprintf('Finished orbit %d of %d\n',countP,highV);

        data = get(gcf,'userdata');
        handles = data.handles;

   % check for correctness of input data
       if alt_p > alt_a
          error1 = errordlg('Perigee must be smaller than apogee');
          waitfor(error1);
       else

          % Orbital elements
          a = (alt_p + alt_a + 2*rad)/2;
          c = a - alt_p - rad;
          e = c/a;
          p = a*(1 - e^2);

          th = linspace(0,2*pi,200);
          r = p./(1 + e*cos(th));
          xx = r.*cos(th);
          yy = r.*sin(th);

          Omega = Omega*deg2rad;
          inc = inc*deg2rad;
          omega = omega*deg2rad; 

          % Coordinate Transformations
          ZZ = [cos(Omega) -sin(Omega) 0;
             sin(Omega) cos(Omega) 0;
             0 0 1];
          XX = [1 0 0;
             0 cos(inc) -sin(inc);
             0 sin(inc) cos(inc)];
          ZZ2 = [cos(omega) -sin(omega) 0;
             sin(omega) cos(omega) 0;
             0 0 1];

          % actual plot
          vec = ZZ*XX*ZZ2*[xx;yy;zeros(1,length(xx))];
          h1 = plot3(vec(1,:),vec(2,:),vec(3,:));
          set([h1],'linewidth',1,'color',[1 1 1]);

          % line of ascending node
          vec1 = ZZ*[rad+600;0;0];
          h2 = plot([0 vec1(1)],[0 vec1(2)],'r-');
          % line of periapsis
          vec2 = ZZ*XX*ZZ2*[rad+600;0;0];
          h3 = plot3([0 vec2(1)],[0 vec2(2)],[0 vec2(3)],'color',...
             [1 1 0]);
          % line of inclination
          vec3 = ZZ*XX*[0;0;rad+600];
          h4 = plot3([0 vec3(1)],[0 vec3(2)],[0 vec3(3)],...
             'color',[0 0 .8]);
          set([h2 h3 h4],'linewidth',2);

          data.handles = [data.handles h1 h2 h3 h4];
          %data.handles = [data.handles h1 ];%h2 h3 h4];
          set(gcf,'userdata',data);
          %camlookat;
       end
       % plot orbits
    
% end plot to from
      
function rot3d(huh)

if nargin<1
   set(gcf,'WindowButtonDownFcn','orbits(''down'')');
   set(gcf,'WindowButtonUpFcn','orbits(''up'')');
   set(gcf,'WindowButtonMotionFcn','');
else
   
   switch huh
   case 'down'
      if strcmp(get(gcf,'SelectionType'),'normal')
         set(gcf,'WindowButtonMotionFcn','orbits(''rot'')');
      elseif strcmp(get(gcf,'SelectionType'),'alt')
         set(gcf,'WindowButtonMotionFcn','orbits(''zoom'')');
      elseif strcmp(get(gcf,'SelectionType'),'open') %center point
         temp1 = get(gca,'currentpoint');
         temp1 = (temp1(1,:) + temp1(2,:))/2; % average points
         %newvec = temp1 - campos
         %oldvec = camtarget-campos
         %dir = cross(oldvec,newvec)
         %ang = atan2(norm(dir),dot(oldvec,newvec))+2
         %campan(-ang,0,'data',dir);
         camtarget([temp1]);
      end
      rdata.oldpt = get(0,'PointerLocation');
      set(gca,'userdata',rdata);
   case 'up'
      set(gcf,'WindowButtonMotionFcn','');
   case 'rot'
      rdata = get(gca,'userdata');
      oldpt = rdata.oldpt;
      newpt = get(0,'PointerLocation');
      dx = (newpt(1) - oldpt(1))*.5;
      dy = (newpt(2) - oldpt(2))*.5;
      
      %direction = [0 0 1];
      %coordsys  = 'camera';
      %pos  = get(gca,'cameraposition' );
      %targ = get(gca,'cameratarget'   );
      %dar  = get(gca,'dataaspectratio');
      %up   = get(gca,'cameraupvector' );
      %[newPos newUp] = camrotate(pos,targ,dar,up,-dx,-dy,coordsys,direction);
      %set(gca,'cameraposition', newPos, 'cameraupvector', newUp);
      
      camorbit(gca,-dx,-dy,'camera');
      
      rdata.oldpt = newpt;
      set(gca,'userdata',rdata);
   case 'zoom'
      rdata = get(gca,'userdata');
      oldpt = rdata.oldpt;
      newpt = get(0,'PointerLocation');
      dy = (newpt(2) - oldpt(2))/abs(oldpt(2));
      camzoom(gca,1+dy)
      rdata.oldpt = newpt;
      set(gca,'userdata',rdata)
   end
   
end
