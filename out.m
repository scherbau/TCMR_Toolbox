function string=out(varargin)
%function string=out(varargin)
%extended output function allowing several rows to output and automatic conversion of numbers to char
%e.g. out('Hallo Nr.',2) prints "Hallo Nr.2"
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


%find max nbr of lines
ml=1;
for i=1:length(varargin)
    if(size(varargin{i},1)>ml)
        ml=size(varargin{i},1);
    end
end

%build output vector
vec=[];
for l=1:ml
    vec=[vec,char(13)];
    for i=1:length(varargin)
        if(size(varargin{i},1)<l)
            try
                text=varargin{i}(1,:);
            catch
                text='';
            end
        else
            text=varargin{i}(l,:);
        end
        if(isnumeric(text))
            text=num2str(text);
        elseif(islogical(text))
            text=num2str(text);
        end
        vec=[vec,text];
    end    
end

%print output
if(nargout)
        string=vec(2:end);
else
    try   
        fprintf([vec]);
    catch
    end
end
% function out(text)
% %simple output function
% try
%     fprintf(['\n',text]);
% catch
% end