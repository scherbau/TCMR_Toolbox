function [h,plane,xticks,xticklabels,yticks,yticklabels]=imagep2d(datax,datay,xscale,yscale,xlim,ylim,logscale,smoothit,drawline,interpolate)
%function [h,plane,xticks,xticklabels,yticks,yticklabels]=imagep2d(datax,datay,xscale,yscale,xlim,ylim,logscale,smoothit,drawline,interpolate)
%plots a heatmap for two dimensional trajectory data
%inputs:
%  datax=if matrix-->trials or vps x time; if cell: datax{1}=matrix with data, data{2} factor for probability calculation (e.g. nbr of trials)
%  datay=trials or vps x time
%  xscale:resolution on x-axis;[]=>from data,[n]=>n bins,[n1,n2,n3...]=>bin boarders
%  yscale:resolution on y-axis;[]=>from data,[n]=>n bins,[n1,n2,n3...]=>bin boarders
%  xlim: range of data to plot [start,end];
%  ylim: range of data to plot [start,end];
%  logscale: logarithmic transformation of propabilities (0/1)
%  smoothit: smoothing factor of plot (before log transformation) (0/width of smoothing window)
%  drawline: draw line of mean data on top: 0=> no line, [w] line of width w, [w,c1,c2,c3] line of width w and color [c1,c2,c3]
%  interpolate: increase resolution by interpolating data:[0]=> original data, [n]=>interpolate datax and datay ny factor n more steps
%
%output:
%  h: handle to the image plot
%  plane: the image that is plotted
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

if(iscell(datax))
    probfac=datax{2};
    datax=datax{1};
else
    probfac=numel(datax);
end

if(size(datax,2)==1 || size(datay,2)==1)
    error('data must have format [trials,time] --> only 1 timepoint found')
end
if(~exist('interpolate','var')||isempty(interpolate))
    interpolate=0;
end
if(~exist('logscale','var')||isempty(logscale))
    logscale=0;
end
if(~exist('smoothit','var')||isempty(smoothit))
    smoothit=0;
end
if(~exist('drawline','var')||isempty(drawline))
    drawline=0;
    linecolor=[1,1,1];
elseif(length(drawline)==4)
    linecolor=drawline(2:4);
    drawline=drawline(1);
else
    linecolor=[1,1,1];
    drawline=drawline(1);    
end

if(~exist('xlim','var')||isempty(xlim))
    xlim=[1, size(datax,2)];
end
datax=datax(:,xlim(1):xlim(2));
if(~exist('ylim','var')||isempty(ylim))
    ylim=[1, size(datay,2)];
end
datay=datay(:,ylim(1):ylim(2));

%scales for plotting data, corrected by xlim
if(~exist('yscale','var')||isempty(yscale))    
    yscale=30;
    ybins=linspace(min(datay(:)),max(datay(:)),yscale+1);
elseif(length(yscale)==1)
    ybins=linspace(min(datay(:)),max(datay(:)),yscale+1);
else
    ybins=yscale;
    yscale=length(ybins)-1;
end
if(~exist('xscale','var')||isempty(xscale))    
    xscale=30;
    xbins=linspace(min(datax(:)),max(datax(:)),xscale+1);
elseif(length(xscale)==1)
    xbins=linspace(min(datax(:)),max(datax(:)),xscale+1);
else
    xbins=xscale;
    xscale=length(xbins)-1;
end

if(interpolate)
    idatax=zeros(size(datax,1),size(datax,2).*interpolate);
    idatay=zeros(size(datay,1),size(datay,2).*interpolate);
    %first, interpolate data on x-axis
    warning('off')
    for t=1:size(datax,1)
            idatax(t,:)=interp1(1:size(datax,2),datax(t,:),linspace(1,size(datax,2),size(datax,2).*interpolate));
            idatay(t,:)=interp1(1:size(datay,2),datay(t,:),linspace(1,size(datay,2),size(datay,2).*interpolate));
    end
    warning('on')
    datax=idatax;
    datay=idatay;
    clear idatax idatay;
    probfac=probfac*interpolate;
end

%move data outside bin ranges into bin ranges
datax(datax<xbins(1))=xbins(1);
datax(datax>xbins(end))=xbins(end);
datay(datay<ybins(1))=ybins(1);
datay(datay>ybins(end))=ybins(end);


%first, bin datax
bdatax=ones(size(datax));
for b=1:length(xbins)-1
   bdatax(datax>xbins(b) & datax<=xbins(b+1))=b;
end

%second, bin datay
bdatay=ones(size(datay));
for b=1:length(ybins)-1
   bdatay(datay>ybins(b) & datay<=ybins(b+1))=b;
end

%third, count for each timeslice trials in each bin
%old code, replaced for performance issues
% plane=zeros(yscale,xscale);
% counter=0;
% for x=unique(bdatax(:))'
%     counter=counter+1;
%     showSteps(counter,1)
%     for y=unique(bdatay(:))'
%         plane(y,x)=sum(bdatay(:)==y & bdatax(:)==x);
%     end
% end
% plane=plane/size(datax,1);

%third, count for each timeslice trials in each bin
plane=zeros(yscale,xscale);
for tr=1:size(bdatay,1)
    for t=1:size(bdatay,2)
        plane(bdatay(tr,t),bdatax(tr,t))=plane(bdatay(tr,t),bdatax(tr,t))+1;
    end
end

%correct by number of data elements or user specified correction
plane=plane/probfac;

%smooth image, if wanted
if(smoothit)
    warning('smoothing data => probability data will be modified by this procedure!')
    plane=smooth(plane,smoothit,1,[],1);
    plane=smooth(plane,smoothit,2,[],1);
end

%transform scale, if wanted
if(logscale)
    lplane=log10(plane);
    plane=lplane;
end

%draw image aligned to bin centers
gcf;
h=imagesc(mean([xbins(1:end-1);xbins(2:end)],1),mean([ybins(1:end-1);ybins(2:end)],1),plane);
set(gca,'YDir','normal');

%draw mean line
if(drawline)
    hold on;
    plot(mean(datax,1),mean(datay,1),'LineWidth',drawline,'Color',linecolor);
end

%xticks
if(length(xbins)>11)
    xt=interp1(1:length(xbins),xbins,linspace(1,length(xbins),11));    
else
    xt=xbins;
end
set(gca,'XTick',xt);
%yticks
if(length(ybins)>11)
    yt=interp1(1:length(ybins),ybins,linspace(1,length(ybins),11));    
else
    yt=xbins;
end
set(gca,'YTick',yt);
    
%OLD CODE; baed on using imagesc(plane) without x and y coordinates
%draw mean line
% if(drawline)
%     hold on;
%     drawyscale=[find(ybins(1:end-1)<=min(datay(:)) & ybins(2:end)>min(datay(:)) ),find(ybins(1:end-1)<max(datay(:)) & ybins(2:end)>=max(datay(:)) )];
%     drawxscale=[find(xbins(1:end-1)<=min(datax(:)) & xbins(2:end)>min(datax(:)) ),find(xbins(1:end-1)<max(datax(:)) & xbins(2:end)>=max(datax(:)) )];
%     %plot(normScore(idata,[],drawyscale(1)-1,drawyscale(2))');
%     plot(mean(normScore(datax,[],drawxscale(1)-1,drawxscale(2)),1),mean(normScore(datay,[],drawyscale(1)-1,drawyscale(2)),1),'LineWidth',drawline,'Color',linecolor);
% end
%labels
% xticks=linspace(0,length(xbins)-1,11);
% set(gca,'XTick',xticks);
% xticklabels=roundMin(xbins(round(linspace(1,length(xbins),11))));
% set(gca,'XTickLabel',xticklabels);
% 
% yticks=linspace(0,length(ybins)-1,11);
% set(gca,'YTick',yticks);
% yticklabels=roundMin(ybins(round(linspace(1,length(ybins),11))));
% set(gca,'YTickLabel',yticklabels);


%title
if(logscale)
    title('distribution of traces (log scale)')
else
    title('distribution of traces');
end





