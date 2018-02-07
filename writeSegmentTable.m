function writeSegmentTable(segments)
%function writeSegmentTable(segments)
%converts the information on significant temporal segments derived by
%plotStatLines to a ; separated table
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


for b=1:length(segments)
    out('Beta;Segment;Start;End;Length');
    for s=1:size(segments{b},1)
        out(b,';',s,';',roundFloat(segments{b}(s,1),3),';',roundFloat(segments{b}(s,2),3),';',roundFloat(segments{b}(s,2)-segments{b}(s,1),3));
    end
    
end