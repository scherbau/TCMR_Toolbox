function [collines,colors,linetypes]=getColorLines(numcols)
%function [collines,colors,linetypes]=getColorLines(numcols)
%returns a number of marker codes
%Input: numcols = is the number of color lines requested
%Output:
%	collines: matrix of chars (line+color markers), with one line for each line-color combination
%	colors: only the color markers
%	linetypes: only the linetype markers
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
colors=repmat(['r';'g';'b';'c';'m';'y';'k'],ceil(numcols/7),1);
linetypes=repmat([repmat('- ',7,1);repmat('--',7,1);repmat('.-',7,1)],ceil(numcols/21),1);
colors=colors(1:numcols);
linetypes=linetypes(1:numcols,:);
collines=[colors,linetypes];