function hours = day_length(day, latitude)
%This calculates the number of hours (hours) 
%Inputs:
% day - day of the year, counted starting with the day of the December solstice in the first year of a Great Year.
% datitude - latitude in degrees, North is positive, South is negative
%
%Calculations are per Herbert Glarner's formulae which do not take into account refraction, twilight, size of the sun, etc. 
% http://herbert.gandraxa.com/length_of_day.xml
%
%Copyright (c) 2015, Travis Wiens. All rights reserved.
  if nargin<2
    error("was expected day_length(day, latitude)");
  endif
  
  Axis=23.439*pi/180;
  j=pi/182.625;%constant (radians)
  m=1-tan(latitude*pi/180).*tan(Axis*cos(j*day));
  m(m>2)=2;%saturate value for artic
  m(m<0)=0;
  b=acos(1-m)/pi;%fraction of the day the sun is up
  hours=b*24;%hours of sunlight
endfunction 

%!test "len70lat";
%! 
%! 

% http://herbert.gandraxa.com/img/lod_fig02.jpg
% https://stackoverflow.com/questions/43519040/how-to-code-a-slider-in-octave-to-have-interactive-plot