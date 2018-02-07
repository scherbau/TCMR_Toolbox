function [h,pvalue,tvalue,df,groupse]=jackKnifeStats2(data1, data2,alpha)
%function [h,pvalue,tvalue,df]=jackKnifeStats(data,alpha)
%calculates a jackknife corrected ttest on jackknifed data for the difference between independent samples 
%(see Miller, J., Patterson, T., & Ulrich, R. (2001). Jackknife-based method for measuring LRP onset latency differences. 
%Psychophysiology, 35(1), 99–115.)
% Inputs:
%   data1: vector containing the jackknifed data of sample 1
%   data2: vector containing the jackknifed data of sample 2
%   alpha: the alpha level for statistical testing (default:0.05)
% Outputs:
%	h: indicates the rejection of the null hypothesis that the mean of data is zero
%	p: the jackknifed p-value
%	t: the jackknifed t-statistics
%	df: the jackknifed degrees of freedom
%	groupse: the standard error of the group
%
% Author: Diana Vogel & Stefan Scherbaum, University of Dresden, 2017
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
% Revision 0.9 nadia

if(~exist('alpha','var'))
    alpha=0.05;
end
datase1=jackKnifeSte(data1);
datase2=jackKnifeSte(data2);
groupse=sqrt(datase1.^2+datase2.^2);
if(groupse~=0)
    tvalue=(mean(data1)-mean(data2))./groupse;
else
    tvalue=mean(data1)-mean(data2);
end
%get p value from t distribution
pvalue=tpdf(tvalue,length(data1)+length(data2)-2);
h=pvalue<alpha;
df=length(data1)+length(data2)-2;
