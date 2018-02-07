function [betas,intercept,vifs]=TCMRegression(data,regressors,smoothing,plotlevel)
%function [betas,intercept,vifs,fitbetas,fitparams,fitvalue]=TCMR(data,regressors,smoothing,gaussfit,parameterbounds,plotlevel)
%Performs time continuous multiple regression, usually applied to mouse
%trajectories, to identify the time profiles of influences (columns of regressors) that were varied
%across trials (lines of data and lines of regressors). Smoothing allows
%to introduce temporal correlation between time points (comparable to FMRI GLM analyses).
%See Scherbaum, S., Dshemuchadse, M., Fischer, R., & Goschke, T. (2010). How decisions evolve: The temporal dynamics of action selection. Cognition, 115(3), 407–416.
%inputs:
%   data: signals to be anlayzed: matrix trial x time. This data will be
%         normalized to [-1,1] across all time points and trials
%   regressors: predictor matrix trial x predictor
%   smoothing: width in pixels for gaussian smooting of signal before applying regression
%   plotlevel: 0 = no output
%              1 = plot variance inflation factors in current subplot (can be used for
%              consecutive calls to get overview of regression validity)
%              2 = plot complete overview of data, predictor matrix, VIF, resulting betas and gaussian fits in current figure
%outputs:
%   betas: results of regression, matrix regressor x time
%   intercept: the intercept from regression analysis 1 x time
%   vifs: variance inflation factor for each regressor indicating multicollinearity (should be below 5)
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


%plotlevel: 0 = no plot, 1 = VIF, 2 = full information
if(~exist('plotlevel','var')||isempty(plotlevel))
    if(nargout==0)
        plotlevel=2;
    else
        plotlevel=1;
    end
end

%smoothing, default 0 (off)
if(~exist('smoothing','var')||isempty(smoothing))
    smoothing =0;
end

%prepare variables
betas=zeros(size(regressors,2)+1,size(data,2));

intercept=ones(size(data,1),1);
regressors=[intercept,regressors];    

%smooth data
if(smoothing>0)
    regdata=smooth(data,smoothing,2,[],1);
else
    regdata=data;
end
regdata=normScore(regdata,[],-1,1);

%plot all basic data properties
vifs=VIF(regressors(:,2:end));
if(plotlevel==2)
    gcf;
    subplot(4,2,[1,3])
    imagesc(regressors(:,2:end));
    ylabel('trial');xlabel('regressor')        
    subplot(4,2,[2,4])
    imagesc(regdata);colormap('gray')
    ylabel('trial');xlabel('time')
    subplot(4,2,5)
    bar(vifs);
    xlim([0.5,size(regressors,2)-0.5]);
    line(xlim,[5,5],'Color','r');                
    ylabel('VIF');xlabel('regressor')
    subplot(4,2,6)
    imagesc(abs(corrcoef(regressors(:,2:end))));        
    ylabel('regressor');xlabel('regressor');
    colormap('Jet')
    colorbar;
elseif(plotlevel==1)
    gca;
    bar(vifs);
    xlim([0.5,size(regressors,2)-0.5]);
    line(xlim,[5,5],'Color','r');    
    ylabel('VIF');
end

%perform regression over time
for t=1:size(regdata,2)
    %calc regression
    betas(:,t)=regressors\regdata(:,t);
end        
intercept=betas(1,:);
betas=betas(2:end,:);

%plot resulting betas
cols=getColorLines(size(betas,1));
if(plotlevel==2)
    clear s;
    subplot(4,2,[7,8]);hold on
    for b=1:size(betas,1)
        plot(betas(b,:),cols(b,:));
    end        
    xlabel('time')
    ylabel('\beta weights')
end


