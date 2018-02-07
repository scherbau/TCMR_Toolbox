function writeParameterTable(fitparams,fitvalues)
%function writeParameterTable(fitparams,fitvalues)
%converts the information on gauss curve paramaters derived by
%fitRegression to a ; separated table
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

for b=1:size(fitparams,1)
        out('Beta;Peak time;Peak SD;Peak strength;R square');
        out(b,';',roundFloat(mean(fitparams(b,1,:)),3),' (',roundFloat(ste(fitparams(b,1,:)),3),')',...
              ';',roundFloat(mean(fitparams(b,2,:)),3),' (',roundFloat(ste(fitparams(b,2,:)),3),')',...
              ';',roundFloat(mean(fitparams(b,3,:)),3),' (',roundFloat(ste(fitparams(b,3,:)),3),')',...
              ';',roundFloat(mean(fitvalues(b,1,:)),3),' (',roundFloat(ste(fitvalues(b,1,:)),3),')'...
        );
    
end