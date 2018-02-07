function pl=errorArea(varargin)
%function errorArea(varargin)
%Similar to errorbar, but instead of bars, it plots errors as a shaded area around data
% errorArea(data, err) plots data and a shaded area defined by err around
% each line from data
% 
% errorArea(data, err, marker) plots data and a shaded area defined by err around
% each line from data. Lines are plotted in the color and with the markers
% as specified in marker
%
% errorArea(xpos,data, err) plots data versus xpos and a shaded area defined by err around
% each line from data
% 
% errorArea(xpos,data, err, marker) plots data versus xpos and a shaded area defined by err around
% each line from data. Lines are plotted in the color and with the markers
% as specified in marker
% 
% pl=errorArea(...) returns a handle to the plot Object produced by errorArea
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

if(length(varargin)==1)
    error('Too view arguments - at least 2 arguments necessary')
elseif(length(varargin)==2)%data + err
    data=varargin{1};
    xpos=1:length(data);
    err=varargin{2};   
    marker='b-';
elseif(length(varargin)==3)%xpos + data + err or data + err + marker
    if(ischar(varargin{3}))%with marker        
        data=varargin{1};
        xpos=1:length(data);
        err=varargin{2};   
        marker=varargin{3};
    else%with xpos
        xpos=varargin{1};
        data=varargin{2};
        err=varargin{3};   
        marker='b-';        
    end
elseif(length(varargin)==4)%xpos + data + err +marker
        xpos=varargin{1};
        data=varargin{2};
        err=varargin{3};   
        marker=varargin{4};        
else    
    error('Too many arguments - only 2-4 arguments allowed');
end
    
if(length(data)~=length(xpos) || length(err)~=length(xpos))
    error('data arguments must have same length')
end

gcf;
h=ishold;
hold on;
%plot data
pl=plot(xpos,data,marker);

colors=getColorValues(marker);%extract color from marker string
colors=min(colors+0.4,ones(size(colors)));%make color a bit brighter
%plot error
p=patch([xpos,xpos(end:-1:1)],[data-err,data(end:-1:1)+err(end:-1:1)],colors,'FaceAlpha',0.3,'EdgeColor','none');
%deactivate legend entry
hasbehavior(p,'legend',false);

if(~h)
    hold off;
end