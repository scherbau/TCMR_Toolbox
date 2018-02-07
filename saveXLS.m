function saveXLS(filename, headers, data)
%function saveXLS(filename, headers, data)
%Exports a matrix of data (observations x variables) to Excel file format, including column headers
%Inputs:
%	filename
%	headers: cellarray of strings with columnnames (length(headers) must be equals to size(data,2)!)
%	data: the matrix of data. Each column carries one variable as designated in headers
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

if(length(headers)~=size(data,2))
    error('header and data must have same length!')
end
if(length(headers)>256)
    error('too many columns - excel can only handle 256 columns!')
end
%generate range
seclet=char(64+mod(length(headers)-1,26)+1);
firstlet=floor((length(headers)-1)/26);
if(firstlet==0)
    firstlet='';
else
    firstlet=char(64+firstlet);
end

range1=['A1:',firstlet,seclet,'1'];
range2=['A2:',firstlet,seclet,num2str(size(data,1)+1)];

xlswrite(filename,headers,range1);
xlswrite(filename,data,range2);

