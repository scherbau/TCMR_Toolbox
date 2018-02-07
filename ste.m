function theste=ste(data,dim)
% function theste=ste(data,dim)
% calculates the standard error, analogue to std
% Input:
%	data: vector or matrix of data
%	dim: defines if ste of matrix data is calculated for each row (=1,default) or column (=2)
% *********************
%
% Author: Stefan Scherbaum, University of Dresden, 2011
%
% Copyright (C) 2011 Stefan Scherbaum, stefan.scherbaum@tu-dresden.de
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

%find dimension to work on
if(~exist('dim','var')||isempty(dim))
    dim = find(size(data) ~= 1, 1);
    if isempty(dim)
        dim = 1;
    end
end
thestd=std(data,0,dim);
elements=size(data);
theste=thestd/sqrt(elements(dim));