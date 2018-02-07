function [fitbetas,fitparams,fitvalue]=fitRegression(betas,parameterbounds,plotlevel)
%function [betas,intercept,vifs,fitbetas,fitparams,fitvalue]=TCMR(data,regressors,smoothing,gaussfit,parameterbounds,plotlevel)
%Fits gauss curves to betas extracted by TCMR to extract parameters peak time,
%peak width and peak strength. Peaks in betas are expected to be positive.
%inputs:
%   betas = beta weights extracted from TCMRegression, matrix beta x time x subject
%   paramaterbounds: either matrix with lower & upper parameter boulds gaussian fitting
%                   parameterbounds:[lower_peaktime,lower_peakwidth,lower_peakstrength;
%                                    upper_peaktime,upper_peakwidth,upper_peakstrength]
%                   or: String 'default' for default parameter bounds: peaktime [1,signallength], peakwidth [0.05*signallength,signallength], peakstrength [min(betas(:))/1.5,max(betas(:))*1.5]  
%                              'estimate' to estimate parameter bounds from data
%   plotlevel: 0 = no output
%              1 = plot aggregated fitted curves for all subjects
%              2 = plot fitted curves of each subject
%outputs:
%   fitbetas: the model betas from gaussian fitting, matrix regressor x time
%   fitparams: the parameters from gaussian fitting for each regressor: beta x parameter (peak time, peak width (std), peak strength)
%   fitvalue: R square calculated by mean squared error from gausian fitting procedure normalized to overall variance for each beta
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


%plotlevel: 0 = no plot, 1 = aggregated fitted curves, 2 = single subject curves
if(~exist('plotlevel','var')||isempty(plotlevel))
    if(nargout==0)
        plotlevel=2;
    else
        plotlevel=1;
    end
end


%parameterbounds:[lower_peaktime,lower_peakwidth,lower_peakstrength;upper_peaktime,upper_peakwidth,upper_peakstrength]
%use default bounds of no bounds given
if(~exist('parameterbounds','var') || isempty(parameterbounds) || strcmp(parameterbounds,'default'))    
    parameterbounds=[1,size(betas,2)/20,min(abs(betas(:)))/1.5;...
             size(betas,2),size(betas,2),max(betas(:))*1.5];
    parameterbounds=repmat(parameterbounds,[1,1,size(betas,1)]);
    out('Using default parameter bounds.');
elseif(strcmp(parameterbounds,'estimate'))%estimate from data: peak time and strength
    parameterbounds=[];
    
    for b=1:size(betas,1)
        [maxpeak,maxidx]=max(mean(betas(b,:,:),3));
        [peakparams]=fminsearchbnd(@fitGauss,[maxidx,size(betas,2)/2,maxpeak],[maxidx,2,maxpeak],[maxidx,size(betas,2),maxpeak],[],mean(betas(b,:,:),3));
        maxpeakstd=std(betas(b,maxidx,:));

                                %peaktime               peakstd            %peakstrength
        parameterbounds(:,:,b)=[maxidx-peakparams(2)*0.675,peakparams(2)*0.675,maxpeak-maxpeakstd*2.57;...
                                maxidx+peakparams(2)*0.675,peakparams(2)/0.675,maxpeak+maxpeakstd*2.57];       

    end
elseif(any(size(parameterbounds)~=[2,3,size(betas,1)]))
    warning(out('Parameter bounds must be a matrix of size(2,3,',size(betas,1),'), but is of size ',size(parameterbounds),'. Using standard parameter bounds instead.'));
    parameterbounds=[1,size(betas,2)/20,0;...
             size(betas,2),size(betas,2),max(betas(:))*4];
    parameterbounds=repmat(parameterbounds,[1,4,size(betas,1)]);
end



fitbetas=zeros(size(betas));
fitparams=zeros(size(betas,1),3,size(betas,3));
fitvalue=zeros(size(betas,1),1,size(betas,3));
if(plotlevel),gcf;end
for p=1:size(betas,3)
           
    %perform fitting per beta
    for b=1:size(betas,1)
        startparams=parameterbounds(:,:,b);
        thedata=betas(b,:,p);        

        [fitparams(b,:,p),fitvalue(b,p)]=fminsearchbnd(@fitGauss,mean(startparams,1),startparams(1,:),startparams(2,:),[],thedata);
        [~,fitbetas(b,:,p)]=fitGauss(fitparams(b,:,p),1:size(betas,2));
        
        %calc Rsquare for the size of the fitted gaussian
        Rsquareidx=max(round(fitparams(b,1,p)-fitparams(b,2,p)*2.57),1):min(round(fitparams(b,1,p)+fitparams(b,2,p)*2.57),size(betas,2));                
        fitvalue(b,p)=abs(corr(squeeze(fitbetas(b,Rsquareidx,p))',squeeze(thedata(Rsquareidx))'));
    end
    
    %plot fitting results
    if(plotlevel==2)
        subplots(size(betas,3),p);hold on
        markers='*os^vx';markers=repmat(markers,1,ceil(size(betas,1)/length(markers)));
        legs={};
        for b=1:size(betas,1)
            scatter(betas(b,:,p),fitbetas(b,:,p));
            legs{b}=out('beta ',b,' - fit:',fitvalue(b,p));
        end
        legend(legs);
    end
end

if(plotlevel==1)
    gcf;
    subplot(1,2,1)
    plotRegression(betas);
    xlabel('time');ylabel('\beta weights')
    title('data')
    subplot(1,2,2)
    plotRegression(fitbetas);
    xlabel('time');ylabel('model \beta weights')
    title(out('model'));
end
