function plotSegmentLines(segments,consecutive,colors,linestyle)
%function plotSegmentLines(segments,consecutive,colors,linestyle)
% Adds segment markers to the plot produced by plotRegression based on the
% results of TCMRegression and findStatSegments
% Lines above the plot indicate which time points are significantly
% different from zero
% Inputs:
%   segments: the segments from findStatSegments (cell array)
%   consecutive: number of consecutive time points that need to be
%     different from zero to be accepted as significant segment (compensation
%     for multiple testing of each time point). For 100 time points, this
%     should be about 10.
%     (see e.g. Scherbaum, S., Gottschalk, C., Dshemuchadse, M., & Fischer, %   R. (2015). Frontiers in Cognition, 6, 934)
%   colors: vector of chars indicating the colors in which the lines will
%   be plotted (default is the same default as plotRegression)
%   linestyle: matrix with linestyles for each line of parameters in which
%   the lines will be plotted (default is the same default as plotRegression)
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
    colors=repmat('brgcmyk',1,ceil(length(segments)/7));
end

if(~exist('linestyle','var') || isempty(linestyle))
    linestyle=repmat(['- ';'-.';'--';': '],ceil(length(segments)/4),1);
elseif(size(linestyle,1)==1)
    linestyle=repmat(linestyle,length(segments),1);    
end
if(~exist('consecutive','var') || isempty(consecutive))
    consecutive=0;
end

%rearrange space for extra axis
g=gca;
xl=xlim;
ylims=ylim;
datamax=ylims(2);
datamin=ylims(1);
datarange=datamax-datamin;
ylim([datamin-datarange*0.17,datamax+datarange*0.17])
%create extra axis for plotting
gp=get(g,'Position');
a=axes('position',[gp(1) gp(2)+gp(4)-gp(4)/10 gp(3) gp(4)/10],'XTick',[],'YTick',[],'box','off') ;   
ylim([0,length(segments)+1]);
xlim(xl);
line(xl,[0,0],'Color',[0,0,0]);
    
    
for b=1:length(segments)
    for s=1:size(segments{b},1)
        if(consecutive>0 && (segments{b}(s,2)-segments{b}(s,1))>=consecutive)%check, for significant segments to be plotted bold
            linewidth=2;
        elseif(consecutive>0 && (segments{b}(s,2)-segments{b}(s,1))<consecutive)
            linewidth=0;
        elseif(consecutive==0)
            linewidth=1;
        end
        if(linewidth>0)
            thelinestyle=setdiff(linestyle(b,:),'+o*xsd^v<>ph');
            l=line(mean(segments{b}(s,:,:),3),[b,b],'LineStyle',thelinestyle,'Color',colors(b),'LineWidth',linewidth);
            hasbehavior(l,'legend',false);
            l=line([segments{b}(s,1),segments{b}(s,1)],[b-0.4,b+0.4],'Color',colors(b),'LineWidth',linewidth);
            hasbehavior(l,'legend',false);
            l=line([segments{b}(s,2),segments{b}(s,2)],[b-0.4,b+0.4],'Color',colors(b),'LineWidth',linewidth);
            hasbehavior(l,'legend',false);
            
        end
    end
end
set(gcf,'CurrentAxes',g);
linkaxes([g,a],'x');

end