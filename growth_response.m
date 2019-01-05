%(IVA, 2.12.2018)
% Calculate growth response functions
function gr = growth_response(x, a, b)
    if x < a
        gr = 0.;
    elseif x >= a && x <= b
        gr = (x - a) / (b - a);
    elseif x >= b
        gr = 1.;
    end
end
