function [h,pvalue,tvalue,df]=jackKnifeStats(data,alpha)
%function [h,pvalue,tvalue,df]=jackKnifeStats(data,alpha)
%calculates a jackknife corrected ttest on jackknifed data 
%(see Miller, J., Patterson, T., & Ulrich, R. (2001). Jackknife-based method for measuring LRP onset latency differences. 
%Psychophysiology, 35(1), 99–115.)
% Inputs:
%   data: vector containing the jackknifed data
%   alpha: the alpha level for statistical testing (default:0.05)
% Outputs:
%	h: indicates the rejection of the null hypothesis that the mean of data is zero
%	p: the jackknifed p-value
%	t: the jackknifed t-statistics
%	df: the jackknifed degrees of freedom
%
% Author: Stefan Scherbaum, University of Dresden, 2017
%
% Copyright (C) 2017 Stefan Scherbaum, stefan.scherbaum@tu-dresden.de
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% Revision 1.0 schtefan

if(~exist('alpha','var'))
    alpha=0.05;
end
datase=jackKnifeSte(data);
if(datase~=0)
    tvalue=mean(data)./datase;
else
    tvalue=mean(data);
end
%get p value from t distribution
pvalue=tpdf(tvalue,length(data)-1);
h=pvalue<alpha;
df=length(data)-1;