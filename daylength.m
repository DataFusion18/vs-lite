function [D]=daylength(L)
%{  
This function plots the Daylength (hours) for a year-round due to Latitude input. 
Input: Latitude [degrees] 
Output: Year daylength vector

Based on: 
W. Forsythe, E. Rykiel, R. Stahl, H. Wu and R. Schoolfield, "A model comparison for daylength as a function of latitude and day of year", Ecological Modelling, vol. 80, no. 1, pp. 87-95, 1995.  
%}
for J=1:365
    %CBM Model
    theta=0.2163108+2*atan(0.9671396*tan(0.00860*(J-186))); %revolution angle from day of the year
    P = asin(0.39795*cos(theta)); %sun declination angle 
    %daylength (plus twilight)- 
    p=0.8333; %sunrise/sunset is when the top of the sun is apparently even with horizon
    D(J) = 24 - (24/pi) * acos((sin(p*pi/180)+sin(L*pi/180)*sin(P))/(cos(L*pi/180)*cos(P))); 
end
end

%!demo "d1";
%! D=daylength(60); plot(D,'LineWidth',2); xlabel('Day of Year');  ylabel('Hours')
%! grid on;  title('Day Length','FontWeight','Bold')
    
% http://herbert.gandraxa.com/img/lod_fig02.jpg

