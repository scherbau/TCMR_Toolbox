function [x_warp,y_warp,angle_warp,velocity_warp,dev_warp,angle_stimlock,velocity_stimlock,dev_stimlock]=calcTrajectories(x_stimlock,y_stimlock,warplength,sf)
%function [x_warp,y_warp,angle_warp,velocity_warp,dev_warp,angle_stimlock,velocity_stimlock,dev_stimlock]=calcTrajectories(x_stimlock,y_stimlock,warplength)
%Calculates all derivations from raw mouse movement for further analysis
%Inputs:
%	x_stimlock: stimulus locked raw movements on the x-axis (trial x time). To allow for movements of differentlength within the matrix, fillup this matrix with nans 
%	y_stimlock: stimulus locked raw movements on the y-axis (trial x time).  
%	warplength: the length to which each raw movement will be stretched/compressed (default warplength = 100)
%   sf: sampling rate in samples per second (used for calculating velocity;
%                   default: sf = 125 which is standard USB sampling rate)
%Outputs:
%   x_warp: time normalized movements on x-axis
%   y_warp: time normalized movements on y-axis
%   angle_warp: time normalized angle of movement (radians) relative to Y-Axis
%   velocity_warp: speed of movement in pixels/second
%   dev_warp: deviation from a straight line from movement start to end
%   *_stimlock: the same as above for raw movements, filled up with nan for
%   equal length in matrix
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

if(isvector(x_stimlock))
    x_stimlock=x_stimlock(:)';
end
if(isvector(y_stimlock))
    y_stimlock=y_stimlock(:)';
end
%assume 100 time slices as standard length for warping
if(~exist('warplength','var')||isempty(warplength))
    warplength=100;
end
%assume standard sampling rate
if(~exist('sf','var')||isempty(sf))
    sf=125;
end

angle_stimlock=nan(size(x_stimlock));
velocity_stimlock=nan(size(x_stimlock));
dev_stimlock=nan(size(x_stimlock));

x_warp=zeros(size(x_stimlock,1),warplength);
y_warp=zeros(size(x_stimlock,1),warplength);
angle_warp=zeros(size(x_stimlock,1),warplength);
velocity_warp=zeros(size(x_stimlock,1),warplength);
dev_warp=zeros(size(x_stimlock,1),warplength);

for t=1:size(x_stimlock,1)
        x=x_stimlock(t,~isnan(x_stimlock(t,:)));
        y=y_stimlock(t,~isnan(y_stimlock(t,:)));                    
        nans=nan(1,sum(isnan(x_stimlock(t,:))));
        dev=distancePointLine([x',y'],[x(1),y(1),x(end)-x(1),y(end)-y(1)]);
        dev_stimlock(t,:)=[dev',nans];
        
        x_diff=diff(x);
        y_diff=diff(y);
        velocity=sqrt(x_diff.^2+y_diff.^2)*sf/1000;
        velocity_stimlock(t,:)=[normLength(velocity,length(x),1),nans];  
        %correct angle for sign(y_diff) to avoid jumps in angle at pi/2
        y_diff_correct=sign(y_diff);
        y_diff_correct(y_diff_correct==0)=1;
        theangle=atan(x_diff./y_diff).*sign(y_diff_correct);
        theangle(isnan(theangle))=sign(x_diff(isnan(theangle)))*(pi/2);
        angle_stimlock(t,:)=[normLength(theangle,length(x),1),nans];
        
        x_warp(t,:)=normLength(x,warplength,true);
        y_warp(t,:)=normLength(y,warplength,true);
        dev_warp(t,:)=normLength(dev,warplength,true);                
        
        %recalculate angle and velocity for the case that stimlock data was
        %totally oversampled.
        x_diff=diff(x_warp(t,:));
        y_diff=diff(y_warp(t,:));
        trialduration=length(x)/sf*1000;%duration of whole trial in ms
        sliceduration=trialduration/warplength;%duration of one slice
        velocity=sqrt(x_diff.^2+y_diff.^2)*1000/sliceduration;
        velocity_warp(t,:)=normLength(velocity,warplength,true);  
        %correct angle for sign(y_diff) to avoid jumps in angle at pi/2
        y_diff_correct=sign(y_diff);
        y_diff_correct(y_diff_correct==0)=1;
        theangle=atan(x_diff./y_diff).*sign(y_diff_correct);
        theangle(isnan(theangle))=sign(x_diff(isnan(theangle)))*(pi/2);
        angle_warp(t,:)=normLength(theangle,warplength,true);
        %velocity_warp(t,:)=normLength(velocity,warplength,true);        
        %angle_warp(t,:)=normLength(theangle,warplength,true);                
		
end


