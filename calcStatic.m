function [auc,maxdev,auclins]=calcStatic(datax,datay)
%function [auc,maxdev,auclins]=calcStatic(datax,datay)
%calculates two standard measures to quantify the deflection of mouse movements
% Inputs:
%		datax: movements on the x-axis (trials x time)
%		datay: movements on the y-axis (trials x time)%
% Output:
%		auc: the area under the curve (summed deviation of movement and a straight line from movement start to end)
%		maxdev: maximum deviation from the straight line
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

if(isvector(datax))
    datax=datax(:)';
end
if(isvector(datay))
    datay=datay(:)';
end
if(isempty(datax))
    auc=nan;
    return;
end

auclins=zeros(size(datax));
maxdev=zeros(size(datax,1),1);
auc=zeros(size(datax,1),1);
for t=1:size(datax,1)
        x=datax(t,:);
        y=datay(t,:);
        auclins(t,:)=...
             distancePointLine([x',y'],[x(1),y(1),x(end)-x(1),y(end)-y(1)]);
        maxdev(t)=max(auclins(t,:));
        auc(t)=mean(auclins(t,:));
end


