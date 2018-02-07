function smoothened=smooth(data,width,dim,window,smoothbeginend)
%function smoothened=smooth(data,width,dim,window,smoothbeginend)
%smoothes data with a window of specified width [default: 3 or length of win], in direction of dimension dim [default: longest dim],
%with a specified window [default: gausswindow(width)], and the option to preserve smoothing from flattening beginnings/end [default: 0 = off]
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
vector=false;
ds=size(data);

if(~exist('width','var')||isempty(width))
    if(exist('win','var')&& ~isempty(win))
        width=length(win);
    else
        width=3;
    end
end;
if(~exist('dim','var')||isempty(dim))
    if(min(size(data))==1)%vector
        dim=find(size(data)==max(size(data)));
        vector=true;
    else%matrix
        dim=find(size(data)==max(size(data)));
    end
end;
if(~exist('window','var')||isempty(window))
    window=gausswindow(width);
end;
if(~exist('smoothbeginend','var')||isempty(smoothbeginend))
    smoothbeginend=0;
end;
if(width==1)
    smoothened=data;
    return;
end

%normalize window
window=window./sum(window);
if(vector && dim==2)%tilted vector
    if(smoothbeginend)
        data=[ones(1,width)*data(1),data,ones(1,width)*data(end)];
    end
    smoothened=(conv2(data',window,'same'))';
    if(smoothbeginend)
        smoothened=smoothened(width+1:end-width);
    end
elseif(vector)%matching vector
    if(smoothbeginend)
        data=[ones(width,1)*data(1);data;ones(width,1)*data(end)];
    end
    smoothened=(conv2(data,window,'same'));
    if(smoothbeginend)
        smoothened=smoothened(width+1:end-width);
    end
else%matrix
    smoothened=zeros(size(data));
    for s=1:size(data,3-dim)
        if(dim==1)
            if(smoothbeginend),dat=[ones(width,1)*data(1,s);data(:,s);ones(width,1)*data(end,s)];
            else dat=data(:,s);end
            sm=smooth(dat,width);
            if(smoothbeginend), smoothened(:,s)=sm(width+1:end-width);
            else smoothened(:,s)=sm;end
        else
            if(smoothbeginend),dat=[ones(1,width)*data(s,1),data(s,:),ones(1,width)*data(s,end)];
            else dat=data(s,:);end
            sm=smooth(dat,width);
            if(smoothbeginend), smoothened(s,:)=sm(width+1:end-width);
            else smoothened(s,:)=sm;end
        end
     end
end