function datase=jackKnifeSte(data,dim)
%function datase=jackKnifeSte(data,dim)
%calculates the standard error of the mean for jackknifed data 
%(see Miller, J., Patterson, T., & Ulrich, R. (2001). Jackknife-based method for measuring LRP onset latency differences. 
%Psychophysiology, 35(1), 99–115.)
% Inputs:
%   data: the vector containing the jackknifed data
% Outputs:
%	datase: the jackknifed standard error
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

if(~exist('dim','var')||isempty(dim))
    datase=sqrt( ((length(data)-1)/length(data)) * sum((data-mean(data)).^2));
else
    if(dim==1)
        datase=sqrt( ((size(data,dim)-1)/size(data,dim)) * sum((data-repmat(mean(data,dim),size(data,1),1)).^2,dim));
    else
        datase=sqrt( ((size(data,dim)-1)/size(data,dim)) * sum((data-repmat(mean(data,dim),1,size(data,2))).^2,dim));
    end
end
%datase=datase./sqrt(length(data));