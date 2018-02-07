function plotPeaks(peaks,alpha,colors)
%function plotPeaks(peaks,alpha,colors)
% adds peak markers as detect by findStatPeaks to the plot produced by plotRegression based on the results of TCMRegression
% Inputs:
%   peaks: the peaks struct from findStatPeaks
%   alpha: alpha level for significance testing (ttest against 0 for 'individual', jackknife correct ttest for 'jackknife')
%   colors: vector of chars indicating the colors in which the lines will be plotted (default is the same default as plotRegression)
%
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


if(~exist('colors','var') || isempty(colors))
    colors=repmat('brgcmyk',1,ceil(length(peaks)/7));
end

if(~exist('alpha','var') || isempty(alpha))
    alpha=0.05;
end


%% plot peaks

%get lighter color for std, but not brighter than 1 
colors=getColorValues(colors);
stdcolors=min(colors+0.4,ones(size(colors)));

for b=1:length(peaks)    
    %plot data
    plot(peaks(b).time,peaks(b).value,'Color',stdcolors(b,:),'Marker','.');
    
    p=patch([peaks(b).time-peaks(b).timeSTE,peaks(b).time,peaks(b).time+peaks(b).timeSTE,peaks(b).time],...
        [peaks(b).value,peaks(b).value+peaks(b).valueSTE,peaks(b).value,peaks(b).value-peaks(b).valueSTE],stdcolors(b,:),'EdgeColor',stdcolors(b,:),'FaceColor','none');
    hasbehavior(p,'legend',false);
    %plot significance
    if(peaks(b).sig<alpha)
        yl=range(ylim)*0.05;
        text(peaks(b).time,peaks(b).value+peaks(b).valueSTE+yl,'*','Color',stdcolors(b,:),'FontSize',12,'HorizontalAlignment','center');            
    end        
end