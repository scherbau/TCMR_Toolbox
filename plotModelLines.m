function plotModelLines(parameters,cutoffstrength,colors,linestyle)
%function plotModelLines(parameters,cutoffs,colors,linestyle)
% adds marker lines above a graph (e.g. by plotRegression) indicating the gaussian paramaters extracted by fitRegression
% Inputs:
%   parameters: the fitted paramaters from fitRegression
%   cutoffstrength: scalar or vector with cutoff values (for each regressor) specifying the strength at which the influence is plotted bold 
%   colors: vector of chars indicating the colors in which the lines will
%   be plotted (default is the same default as plotRegression)
%   linestyle: matrix with linestyles for each line of parameters in which
%   the lines will be plotted (default is the same default as plotRegression)
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
    colors=repmat('brgcmyk',1,ceil(size(parameters,1)/7));
end

if(~exist('linestyle','var') || isempty(linestyle))
    linestyle=repmat(['- ';'-.';'--';': '],ceil(size(parameters,1)/4),1);
elseif(size(linestyle,1)==1)
    linestyle=repmat(linestyle,size(parameters,1),1);    
end

if(~exist('cutoffstrength','var')||isempty(cutoffstrength))
    cutoffstrength=0;
end

if(isscalar(cutoffstrength))
    cutoffstrength=repmat(cutoffstrength,1,size(parameters,1));
end

g=gca;
xl=xlim;
datarange=ylim;
datamin=datarange(1);
datamax=datarange(2);
datarange=diff(datarange);
ylim([datamin-datarange*0.17,datamax+datarange*0.17])

%create extra axis for plotting
gp=get(g,'Position');
a=axes('position',[gp(1) gp(2)+gp(4)-gp(4)/10 gp(3) gp(4)/10],'XTick',[],'YTick',[],'box','off');   
ylim([0,size(parameters,1)+1]);
xlim(xl);
line(xl,[0,0],'Color',[0,0,0]);



for p=1:size(parameters,1)        
    themean=mean(parameters(p,1,:),3);
    thestd=mean(parameters(p,2,:),3)*1.96;
    thestrength=mean(parameters(p,3,:),3);
    if(thestrength>cutoffstrength(p))
        linewidth=2;
    else
        linewidth=1;
    end
    l=line([themean-thestd,themean+thestd],[p,p],'LineStyle',linestyle(p,:),'Color',colors(p),'LineWidth',linewidth);
    hasbehavior(l,'legend',false);
    l=line([themean-thestd,themean-thestd],[p-0.4,p+0.4],'Color',colors(p),'LineWidth',linewidth);
    hasbehavior(l,'legend',false);
    l=line([themean+thestd,themean+thestd],[p-0.4,p+0.4],'Color',colors(p),'LineWidth',linewidth);
    hasbehavior(l,'legend',false);

end
set(gcf,'CurrentAxes',g);
linkaxes([g,a],'x');