% GNU Octave version (IVA, 2.2.2019)

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
