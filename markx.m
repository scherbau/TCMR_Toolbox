function markx(xval,col)
%function markx(xval,col)
%draws a line across the whole ylim to mark xval on the x-axis (in color col, default = grey)
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

if(~exist('xval','var'))
    xval=0;
end
if(~exist('col','var'))
    col=[0.5,0.5,0.5];
end
line([xval,xval],ylim,'Color',col);