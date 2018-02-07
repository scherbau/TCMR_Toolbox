function values=getColorValues(c)
%function values=getColorValues(c)
%converts color char names to rgb triples (if c contains chars - else it simply returns c)
%ignores all unknown chars and can hence be used to extract color values from marker strings

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
if(isa(c,'char'))
    counter=0;
    for cs=1:length(c)
        cmap=[0,0,0,0,1,1,1,1;0,0,1,1,0,0,1,1;0,1,0,1,0,1,0,1];
        colors='kbgcrmyw';
        if(~isempty(find(colors==c(cs))))%only if a valid color value, otherwise ignore (can be used to extract color from marker strings)
            counter=counter+1;
            values(counter,:)=(cmap(:,find(colors==c(cs))))';
        end
    end
else
    values=c;
end