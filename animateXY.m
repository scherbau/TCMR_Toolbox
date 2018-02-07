function themovie=animateXY(xdata,ydata,framerate,mov)
%function themovie=animateXY(xdata,ydata,framerate,mov)
% animate x vs. y movements timestep by timestep
% Inputs:
%   xdata: trial x time matrix of x-coordinates
%   ydata: trial x time matrix of y-coordinates
%	framerate: the number of timesteps plotted per second
%	mov: boolean indicating whether a movie should be captured for later replay (movie function) or export (e.g. as avi)
% Output:
%	themovie: if mov=true, themovie is a struct array containing the images captured by getframe for each timestep
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
if(~exist('mov','var')||isempty(mov))
    mov=false;
    themovie=[];
end

f=gcf;
hold off

p=plot(xdata(:,1),ydata(:,1),'k.','MarkerSize',1);
hold on
xlim([min(xdata(:)),max(xdata(:))]);
ylim([min(ydata(:)),max(ydata(:))]);
drawnow
xlabel('X-axis')
ylabel('Y-axis')

if(mov)
    themovie(1)=getframe(f);
end
for t=2:1:size(xdata,2)
    pause(1/framerate);
    plot(xdata(:,t),ydata(:,t),'k.','MarkerSize',1);
    drawnow
    if(mov)
        themovie(t)=getframe(f);
    end
end