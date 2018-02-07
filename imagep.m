function [h,plane,xticks,xticklabels,yticks,yticklabels]=imagep(data,xscale,yscale,xlim,logscale,smoothit,drawline)
%function [h,plane,xticks,xticklabels,yticks,yticklabels]=imagep(data,xscale,yscale,xlim,logscale,smoothit,drawline)
%plots a heatmap for one dimensional trajectory data
%inputs:
%  data=if matrix-->trials or vps x time; if cell: data{1}=matrix with data, data{2} factor for probability calculation (e.g. nbr of trials)
%  xscale:resolution on x-axis;[]=>from data,[n]=>n points
%  yscale:resolution on y-axis;[]=>from data,[n]=>n bins,[n1,n2,n3...]=>bin boarders
%  xlim: range of data to plot [start,end];
%  logscale: logarithmic transformation of propabilities (0/1)
%  smoothit: smoothing factor of plot (before log transformation) (0/width of smoothing window)
%  drawline: draw line of mean data on top: 0=> no line, [w] line of width w, [w,c1,c2,c3] line of width w and color [c1,c2,c3]
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

if(iscell(data))
    probfac=data{2};
    data=data{1};
else
    probfac=size(data,1);
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
    xlim=[1, size(data,2)];
elseif(length(xlim)==1)
    xlim=[1,xlim];
end
data=data(:,xlim(1):xlim(2));

%scales for plotting data, corrected by xlim
if(~exist('yscale','var')||isempty(yscale))    
    yscale=30;
    ybins=linspace(min(data(:)),max(data(:)),yscale+1);
elseif(length(yscale)==1)
    ybins=linspace(min(data(:)),max(data(:)),yscale+1);
else
    ybins=yscale;
    yscale=length(ybins)-1;
end
if(~exist('xscale','var')||isempty(xscale))
    xscale=size(data,2);
end




idata=zeros(size(data,1),xscale);
%first, interpolate data on x-axis
if(xscale~=size(data,2))
    for t=1:size(data,1)
        idata(t,:)=interp1(1:size(data,2),data(t,:),linspace(1,size(data,2),xscale));
    end
else
    idata=data;
end
%second, bin data  on y-axis
bdata=ones(size(data,1),xscale);
idata(idata<ybins(1))=ybins(1);
idata(idata>ybins(end))=ybins(end);
for b=1:length(ybins)-1
   bdata(idata>ybins(b) & idata<=ybins(b+1))=b;
end
%third, count for each timeslice trials in each bin
plane=zeros(yscale,xscale);
for x=1:xscale
    for y=1:yscale
        %plane(y,x)=sum(bdata(:,x)==y)/size(data,1);
        plane(y,x)=sum(bdata(:,x)==y)/probfac;
    end
end

%smooth image, if wanted
if(smoothit)
    warning('smoothing data => probability data will be modified by this procedure!')
    plane=smooth(plane,smoothit,1,[],1);
end

%transform scale, if wanted
if(logscale)
    lplane=plane;
    %lplane(lplane~=0)=normScore(log10(plane(plane~=0)),[],min(plane(plane(:)~=0)),max(plane(plane(:)~=0)));
    lplane=log10(lplane);
    plane=lplane;
    %normScore(log(normScore(plane,[],0.001,1)),[],min(plane(plane(:)~=0)),max(plane(:)));
end

%draw image
h=gcf;
imagesc(plane);
set(gca,'YDir','normal');

%draw mean line
if(drawline)
    hold on;
    drawyscale=[find(ybins(1:end-1)<=min(idata(:)) & ybins(2:end)>min(idata(:)) ),find(ybins(1:end-1)<max(idata(:)) & ybins(2:end)>=max(idata(:)) )];
    %plot(normScore(idata,[],drawyscale(1)-1,drawyscale(2))');
    plot(mean(normScore(idata,[],drawyscale(1)-1,drawyscale(2)),1),'LineWidth',drawline,'Color',linecolor);
end


%labels
xticks=linspace(0,xscale,11);
set(gca,'XTick',xticks);
xticklabels=roundMin(linspace(0,size(data,2),11));
set(gca,'XTickLabel',xticklabels);

yticks=linspace(0,length(ybins)-1,11);
set(gca,'YTick',yticks);
yticklabels=roundMin(ybins(round(linspace(1,length(ybins),11))));
set(gca,'YTickLabel',yticklabels);

%title
if(logscale)
    title('distribution of traces (log scale)')
else
    title('distribution of traces');
end