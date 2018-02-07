function writePeakTable(peaks)
%function writePeakTable(segments)
%converts the information on peak strength and timing derived by
%plotStatPeaks to a ; separated table
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
for b=1:length(peaks)
        out('Beta;Peak time;Peak strength');
        out(b,';',roundFloat(peaks(b).time,3),' (',roundFloat(peaks(b).timeSTE,3),')',...
            ';',roundFloat(peaks(b).value,3),' (',roundFloat(peaks(b).valueSTE,3),')');    
end