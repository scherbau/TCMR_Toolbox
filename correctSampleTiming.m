function [x_stimlock,y_stimlock,t_stimlock]=correctSampleTiming(x_stimlock,y_stimlock,t_stimlock)
%function [x_stimlock,y_stimlock,t_stimlock]=correctSampleTiming(x_stimlock,y_stimlock,t_stimlock)
%Correct sampling timings variance to constant sample intervals by linear interpolation
%Inputs:
%	x_stimlock: stimulus locked raw movements on the x-axis (trial x time). To allow for movements of differentlength within the matrix, fillup this matrix with nans 
%	y_stimlock: stimulus locked raw movements on the y-axis (trial x time)
%	t_stimlock: stimulus locked absolute sample times (trial x time)  
%Output: the corrected movements
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

if(isvector(x_stimlock))
    x_stimlock=x_stimlock(:)';
end
if(isvector(y_stimlock))
    y_stimlock=y_stimlock(:)';
end
if(isvector(t_stimlock))
    t_stimlock=t_stimlock(:)';
end

for t=1:size(x_stimlock,1)
    x=x_stimlock(t,~isnan(x_stimlock(t,:)));
    y=y_stimlock(t,~isnan(y_stimlock(t,:)));                    
    ti=t_stimlock(t,~isnan(t_stimlock(t,:)));                    
    
	nans=nan(1,sum(isnan(x_stimlock(t,:))));

    x_stimlock(t,:)=[interp1(ti,x,linspace(ti(t,1),ti(t,end),length(ti))),nans];
    y_stimlock(t,:)=[interp1(ti,y,linspace(ti(t,1),ti(t,end),length(ti))),nans];
    t_stimlock(t,:)=[linspace(ti(1),ti(end),length(t)),nans]; 
end