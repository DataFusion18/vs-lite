% GNU Octave version (IVA, 2.2.2019)

crns=[0.58, 1.447, 0.439, 1.376, 0.722, 1.782, 0.493, 1.334, 1.148, 1.326, 1.182, 1.337, 1.674, 1.483, 1.258, 0.471, 1.438, 1.312, 1.51, 1.882, 1.271, 0.884, 0.328, 1.389, 1.015, 1.399, 1.321, 1.412, 1.84, 1.076, 0.483, 0.172, 1.062, 0.805, 1.326, 0.573, 0.617, 1.412, 0.638, 1.037, 0.839, 0.921, 0.718, 0.35, 0.403, 1.427, 0.959, 1.787, 0.478, 0.418, 0.191, 1.253, 1.39, 1.09, 0.374, 0.532, 1.846, 0.394, 1.145, 1.019, 0.272, 1.018, 0.829, 0.481, 0.256, 1.483, 1.454];
mods=[0.044, 1.742, 0.265, 1.429, 0.498, 1.212, 0.57, 1.22, 1.576, 1.352, 2.073, 1.812, 1.504, 1.539, 1.045, 0.147, 1.463, 1.727, 1.088, 0.328, 0.391, 0.278, 0.213, 1.895, 0.813, 1.086, 1.422, 1.783, 2.188, 0.877, 0.053, 0.318, 0.89, 1.034, 0.868, 0.235, 0.922, 0.902, 0.608, 1.306, 1.017, 1.277, 0.931, 0.112, 1.372, 1.394, 0.268, 1.549, 0.451, 0.194, 0.319, 2.364, 1.483, 0.789, 0.059, 0.271, 1.986, 0.303, 1.557, 1.132, 0.104, 1.931, 1.493, 0.167, 0.657, 1.73, 1.374];

% https://stackoverflow.com/questions/49261322/compute-mean-directional-accuracy-with-r
function mda = meanDirAcc(Actual, Forecast, lag=1) 
    mda = mean(sign(diff(Actual, lag=lag))==sign(diff(Forecast, lag=lag)));
end
%meanDirAcc(crns, mods)

% Compute Mean Directional Accuracy. Calculate synchronicity of vectors.
% https://en.wikipedia.org/wiki/Mean_Directional_Accuracy
function res = MDA(actual, predicted)
    sp = sign(predicted(2:end) - predicted(1:end-1));
    sa = sign(actual(2:end) - actual(1:end-1));
    
    res = mean(sp == sa);
end 
%MDA(crns, mods)

function r = rmse(prediction,estimate)
% generalized function from Felix Heder http://www.mathworks.com/matlabcentral/fileexchange/21383-rmse/content/rmse.m
% Function to calculate root mean square error from a prediction vector or matrix 
% and the corresponding estimates.
% Usage: r = rmse(data,estimate)
% Note: predictions and estimates have to be of same size or estimate can be one
% number
% Example: r = rmse(randn(100,100),randn(100,100)) or r = rmse(randn(100,100),0)
  if numel(estimate) == 1 && numel(prediction) > 1
      % delete records with NaNs in data first
      I = ~isnan(prediction);
  else
      % delete records with NaNs in both datasets first
      I = ~isnan(prediction) & ~isnan(estimate); 
      estimate = estimate(I);    
  end
  prediction = prediction(I);
  r = sqrt(mean((prediction(:)-estimate(:)).^2));
end

function [r2 rmse] = rsquare(y,f,varargin)
% Compute coefficient of determination of data fit model and RMSE
%
% [r2 rmse] = rsquare(y,f)
% [r2 rmse] = rsquare(y,f,c)
%
% RSQUARE computes the coefficient of determination (R-square) value from
% actual data Y and model data F. The code uses a general version of 
% R-square, based on comparing the variability of the estimation errors 
% with the variability of the original values. RSQUARE also outputs the
% root mean squared error (RMSE) for the user's convenience.
%
% Note: RSQUARE ignores comparisons involving NaN values.
% 
% INPUTS
%   Y       : Actual data
%   F       : Model fit
%
% OPTION
%   C       : Constant term in model
%             R-square may be a questionable measure of fit when no
%             constant term is included in the model.
%   [DEFAULT] TRUE : Use traditional R-square computation
%            FALSE : Uses alternate R-square computation for model
%                    without constant term [R2 = 1 - NORM(Y-F)/NORM(Y)]
%
% OUTPUT 
%   R2      : Coefficient of determination
%   RMSE    : Root mean squared error
%
% EXAMPLE
%   x = 0:0.1:10;
%   y = 2.*x + 1 + randn(size(x));
%   p = polyfit(x,y,1);
%   f = polyval(p,x);
%   [r2 rmse] = rsquare(y,f);
%   figure; plot(x,y,'b-');
%   hold on; plot(x,f,'r-');
%   title(strcat(['R2 = ' num2str(r2) '; RMSE = ' num2str(rmse)]))
%   
% Jered R Wells
% 11/17/11
% jered [dot] wells [at] duke [dot] edu
%
% v1.2 (02/14/2012)
%
% Thanks to John D'Errico for useful comments and insight which has helped
% to improve this code. His code POLYFITN was consulted in the inclusion of
% the C-option (REF. File ID: #34765).
  if isempty(varargin); c = true; 
  elseif length(varargin)>1; error 'Too many input arguments';
  elseif ~islogical(varargin{1}); error 'C must be logical (TRUE||FALSE)'
  else c = varargin{1}; 
  end
  % Compare inputs
  if ~all(size(y)==size(f)); error 'Y and F must be the same size'; end
  % Check for NaN
  tmp = ~or(isnan(y),isnan(f));
  y = y(tmp);
  f = f(tmp);
  if c; r2 = max(0,1 - sum((y(:)-f(:)).^2)/sum((y(:)-mean(y(:))).^2));
  else r2 = 1 - sum((y(:)-f(:)).^2)/sum((y(:)).^2);
      if r2<0
      % http://web.maths.unsw.edu.au/~adelle/Garvan/Assays/GoodnessOfFit.html
          warning('Consider adding a constant term to your model') %#ok<WNTAG>
          r2 = 0;
      end
  end
  rmse = sqrt(mean((y(:) - f(:)).^2));
end

function R2 = calculateR2(z,z_est)
% calcuateR2 Cacluate R-squared
% R2 = calcuateR2(z,z_est) takes two inputs - The observed data x and its
% estimation z_est (may be from a regression or other model), and then
% compute the R-squared value a measure of goodness of fit. R2 = 0
% corresponds to the worst fit, whereas R2 = 1 corresponds to the best fit.
% 
% Copyright @ Md Shoaibur Rahman (shaoibur@bcm.edu)
  r = z-z_est;
  normr = norm(r);
  SSE = normr.^2;
  SST = norm(z-mean(z))^2;
  R2 = 1 - SSE/SST;
end
