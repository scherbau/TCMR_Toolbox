function matrix=addToMatrix(matrix,vector,index)
%function matrix=addToMatrix(matrix,vector,index)
%Adds vector as a line into existing matrix at line specified by index
%if length(vector)>size(matrix,2), the vector ist cut
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
if(all(size(vector)>1))
    error('the input parameter vector must be a column or row vector, not a matrix');
end

if(index>size(matrix,1))
    error('the input parameter index must be within size(matrix,1)')
end

vector=vector(:)';

if(length(vector)>size(matrix,2))
    vector(1:size(matrix,2));
end

matrix(index,1:length(vector))=vector;
