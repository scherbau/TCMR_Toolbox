function g = gauss_curve(range_x, mu, sigma)
%function g = gauss_curve(range_x, mu, sigma)
%creates a gaussian peaking at mu, with a width of sigma
%range_x = the points for which to return the gaussian function values
%mu = the center of the gaussian
%sigma = the width of the gaussian
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


g = exp(-0.5 * ((range_x-mu)/sigma).^2);
