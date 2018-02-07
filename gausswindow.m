function w=gausswindow(thelength,thewidth)
%function w=gausswindow(thelength,thewidth)
%creates a gaussian window for filtering or other purposes
%inputs:
%	thelength: number of elements
%	thewidth: the width of the gaussian within the length. Note: a larger value of thewidth produces a more narrow gaussian
%output: the gaussian window
%
% Author: Stefan Scherbaum, University of Dresden, 2011
%
% Copyright (C) 2011 Stefan Scherbaum, stefan.scherbaum@psychologie.tu-dresden.de
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
%
if(nargin<2)
    thewidth=2.5;
end
thelength=thelength-1;
x=-thelength/2:thelength/2;
w=exp(-1/2*((thewidth*x./(thelength/2)).^2));