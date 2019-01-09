function gr = growth_response(x, a=1, b=21)
% Calculate growth response functions
% (IVA, 9.12.2018)
  if (nargin == 0)
    error ("not enough input arguments");
  endif
  if a > b
    error ("a > b");
  endif
  if isscalar(x) && isscalar(a) && isscalar(b)
    if x < a
        gr = 0.;
    elseif x >= a && x <= b
        gr = (x - a) / (b - a);
    elseif x >= b
        gr = 1.;
    endif
  else
    error ("growth_response(x, a, b)");
  end
endfunction

%!test "range1";
%! gr = growth_response(-10);
%! assert(gr, 0);
%!test "range2";
%! gr = growth_response(100);
%! assert(gr, 1);
%!test "range3";
%! gr = growth_response(2,1,3);
%! assert(gr, 0.5);

%!demo "ex1";
%! V=-2:0.1:24; A=arrayfun(@growth_response, V); plot(V,A);
