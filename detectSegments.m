function segments=detectSegments(vec)
%function function segments=detectSegments(vec)
%Finds continuous segments of ones in a vector
%Inputs:
%	vec: the vector of zeros and ones
%Output: 
%	segments: matrix with lines for each new segments of ones. In each line, the first value is the starting index of the segment and the second column the end index
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

segments=[];
insegment=false;
for t=1:length(vec)
    if(vec(t)==1 && ~insegment)
        insegment=true;
        segments(end+1,:)=[t,-1];
    elseif(vec(t)==0 && insegment)
        insegment=false;
        segments(end,2)=t-1;
    end
end
if(~isempty(segments) && segments(end,2)==-1)
    segments(end,2)=t;
end
