function [continuity,returns,combined]=calcMovementContinuity(movements,returndirection,plotit)
%function [continuity,returns,combined]=getMovementContinuity(movements,returndirection,plotit)
%input:
%   movements: matrix defining movements along a dimension (trial x time)
%   returndirection: direction (1 >0, -1 <0) of movement that indicates backwards movement of mouse (default 1)
%   plotit: plot movements and data (default: off)
%output:
%   continuity: correlation of straight line with real movements
%   returns: relative number of backwards movements
%   combined: combined measure of movement quality (1-returns)*continuity
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

if(~exist('plotit','var')||isempty(plotit))
    plotit=false;
end
if(~exist('returndirection','var')||isempty(returndirection))
    returndirection=1;
end

theline=linspace(mean(movements(:,1),1),mean(movements(:,end),1),size(movements,2));
correl=zeros(size(movements,1),1);
for t=1:size(movements,1)
    c=corrcoef(movements(t,:),theline);
    correl(t)=c(1,2);
end
continuity=mean(correl);
if(sign(returndirection)==1)
    returns=mean(any(diff(movements,1,2)>0,2));
else
    returns=mean(any(diff(movements,1,2)<0,2));
end
combined=(1-returns)*continuity;

if(plotit)
    gca;hold on
    plot(movements');
    plot(theline,'.-k');
    title(out('C: ',roundFloat(continuity,2),' R:',roundFloat(returns,2),' Q:',roundFloat(combined,2)));
end