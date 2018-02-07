function [peaks,peakvalues,peaktimes,peakvaluessig]=findStatPeaks(betas,detectionmethod)
%function findStatPeaks(betas,detectionmethod)
% detects peaks in the results of TCMRegression
% Inputs:
%   betas: the betas from TCMRegression (regressor x time x subject)
%   detectionmethod:'individual' detects peak of each beta for each subject in betas
%                   'jackknife' detects peak of each beta via jackknifing across subjects
%                   'mean' detects peak of each beta on the average of all subjects 
%
%Outputs:
%   peaks: array of structs from peakdetection. The struct contains for each line of betas the fields:
%       value: the peak height
%       time: the peak time
%       sig: the p-value of significance testing against 0
%       valueSTE: standarderror of value (correct for jackKnifing if necessary)
%       timeSTE: standarderror of time (correct for jackKnifing if necessary)
%   peakvalues, peaktimes, peakvaluessig: the raw values for each line of betas for each subject
%               if 'individual' or for each jackknifed subject if
%               'jackknife'(use jackKnifeSte, jackKnifeStats, and jackKnifeStats2 
%               to plot standard errors and perform ttests on these raw data)
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



if(~exist('detectionmethod','var') || isempty(detectionmethod))
    detectionmethod='jackknife';
end

if(strcmp(detectionmethod,'jackknife'))
    peakdetect=2;
elseif(strcmp(detectionmethod,'mean'))
    peakdetect=1;
elseif(strcmp(detectionmethod,'individual'))
    peakdetect=3;
else
    error(out('Unknown detection method "',detectionmethod,'". Valid methods are "mean","jackknife","individual"'));
end

%% find peaks
%method of detection: 1=by mean, 2=mean of individual peaks, 3=mean of jackknife, 4=mean of bootstrap
for b=1:size(betas,1)     
    if(peakdetect==1)%peak by mean         
        [~,peakmaxtime]=max(mean(betas(b,:,:),3));
        peakmaxval=squeeze(betas(b,peakmaxtime,:));
        peakmaxtime=repmat(peakmaxtime,size(betas,3),1);        
        [~,maxpeakvalsig]=ttest(peakmaxval);
    elseif(peakdetect==2)%peak by jackknifing
        [peakmaxval,peakmaxtime]=max(jackknife(@mean,squeeze(betas(b,:,:))')',[],1);
        [~,maxpeakvalsig]=jackKnifeStats(peakmaxval);
    elseif(peakdetect==3)%peak by individual peaks
        [peakmaxval,peakmaxtime]=max(squeeze(betas(b,:,:)),[],1);
        [~,maxpeakvalsig]=ttest(peakmaxval);        
    end
    peakvalues{b}=peakmaxval;
    peaktimes{b}=peakmaxtime;
    peakvaluessig{b}=maxpeakvalsig;
    
    if(peakdetect==2)
        thestev{b}=jackKnifeSte(peakvalues{b});
        thestet{b}=jackKnifeSte(peaktimes{b});            
    else            
        thestev{b}=ste(peakvalues{b});
        thestet{b}=ste(peaktimes{b});
    end
    peaks(b).value=mean(peakvalues{b});
    peaks(b).time=mean(peaktimes{b});
    peaks(b).sig=peakvaluessig{b};
    peaks(b).valueSTE=thestev{b};
    peaks(b).timeSTE=thestet{b};        
end

