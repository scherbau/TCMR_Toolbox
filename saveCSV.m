function saveCSV(filename, headers, data)
%function saveCSV(filename, headers, data)
%Exports a matrix of data (observations x variables) to CSV file format (; separated), including column headers
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

if(~isempty(headers) && ~(length(headers)==1 || length(headers)==size(data,2)))
    error('header and data must have same length!')
end

if(~isempty(headers))
    if(length(headers)==1)%potentially a string to be parsed (seperated by commas)
        if((sum(headers{1}==',')+1)==size(data,2))
            headerstring=strrep(headers{1},',',';');
        else
            error('Parsing of header failed: number of elements seperated by '','' must match size(data,2)')
        end
    else
        headerstring=[];
        for h=1:length(headers)
            headerstring=[headerstring,headers{h},';'];
        end
        headerstring(end)=[];
    end
    dlmwrite(filename,headerstring,'delimiter','')
    dlmwrite(filename,data,'delimiter',';','precision','%f','-append');
else
    dlmwrite(filename,[1:size(data,2);data],'delimiter',';','precision','%f');
end

