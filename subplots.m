function s=subplots(datanbr,nbr)
%function s=subplots(datanbr,nbr)
%opens a subplot nbr and calculates the number of lines and columns according to the maximum number of planned subplots datanbr
% --> a simple proxy for subplot
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


x=ceil(sqrt(datanbr));
y=ceil(datanbr/x);
%if(x*y>=datanbr*2),y=y-1;end%correct for spurious errors
s=subplot(x,y,nbr);

%opens a rectangular array of [datanbr] subplots, adressing the current subplot nbr
