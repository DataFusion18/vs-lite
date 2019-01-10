function growth = gompertz_response(x,a=2,b=0.1)
% Gompertz growth curve
% a = scalar temperature threshold below which growth response to temperature is zero (in deg. C)
% b = parameter reflecting the shape of the Gompertz curve which influences the growth rate of y as a function of x  
% (IVA, 10.12.2018)
  As = 1;  % asymptote (optimal growth)
  growth = max(0, As * exp(-exp(b * e * (a - x)/As + 1)));
endfunction

%!demo "ex1";
%! V=-2:0.1:54; A=arrayfun(@gompertz_response, V); plot(V,A);
