% DemoScript for TCMR Toolbox by Stefan Scherbaum (C) 2017
% Reads a subset of the data from Scherbaum et al., Cognition, 2010, study
% 1 and analyzes it using TCMR Toolbox
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

%% load data
clear 
for p=1:10
    out('Loading log ',p);
    load(out('./log',p,'.mat'));
    pstruct=catTrialLog(trials,{'response','congruency','rt'});%extract basic data from each trial struct into matrices
    pstruct.trials=trials;%add trial struct for further processing
    pdata(p)=pstruct;
end

%% perform preprocessing
sf=95;%sampling was at 95 Hz
warp_samples=100;%100 time slices for time normalized trajectories;
stimlock_samples=ceil(sf*2.5);%2.5 seconds max response time, 95 samples per second --> maximum samples planned for stimulus locked trajetories - rest is filled with nan
screen_width=1280;%width of screen in the experiment

for p=1:length(pdata)
    out('Preprocessing dataset ',p,'...');
    %initialize matrices for stimulus locked raw data 
    pdata(p).x_stimlock=nan(length(pdata(p).trials),stimlock_samples);
    pdata(p).t_stimlock=nan(length(pdata(p).trials),stimlock_samples);
    pdata(p).y_stimlock=nan(length(pdata(p).trials),stimlock_samples);
        
    %perform preprocessing on each trials
    for tr=1:length(pdata(p).trials)
        %correct sample timing errors
        [x,y,t]=correctSampleTiming(pdata(p).trials(tr).x,pdata(p).trials(tr).y,pdata(p).trials(tr).t);
        %mirror right responses to left
        if(pdata(p).response(tr)==2)
            x=screen_width-x;
        end
        %align x coordinates to zero as start point
        x=x-x(1);
        
        %add data to raw data matrices
        pdata(p).x_stimlock(tr,:)=normLength(x,stimlock_samples,0);
        pdata(p).y_stimlock(tr,:)=normLength(y,stimlock_samples,0);
        pdata(p).t_stimlock(tr,:)=normLength(t,stimlock_samples,0);
    end
     
    %extract all dynamic data from stimulus locked raw data
    [pdata(p).x_warp,pdata(p).y_warp,pdata(p).angle_warp,pdata(p).velocity_warp,...
     pdata(p).dev_warp,pdata(p).angle_stimlock,pdata(p).velocity_stimlock,pdata(p).dev_stimlock]...
        =calcTrajectories(pdata(p).x_stimlock,pdata(p).y_stimlock,warp_samples,sf);
    [pdata(p).meandev,pdata(p).maxdev]=calcStatic(pdata(p).x_warp,pdata(p).y_warp);
end

%% inspect data

% plot data by condition
%aggregate data
clear cx ix
for p=1:length(pdata)
    cx(p,:)=nanmean(pdata(p).x_warp(pdata(p).congruency==1,:));
    ix(p,:)=nanmean(pdata(p).x_warp(pdata(p).congruency==2,:));
end

%plot mean movements
figure;hold on
errorArea(mean(cx),ste(cx),'b');errorArea(mean(ix),ste(ix),'r');
legend('congruent','incongruent');xlabel('time slice');ylabel('X Coordinate (px)');

%check movement quality: how straight is each movement and how many movements show returns (y direction should be increasing constantly (=1)
for p=1:length(pdata)
    [cont(p,:),returns(p,:)]=calcMovementContinuity(pdata(p).y_warp,1);
end
figure
boxplot([cont,returns])
set(gca,'XTick',1:2);set(gca,'XTickLabels','continuity|returns')
title('Consistency of movements')

% plot heatmap of pooled trial per condition
%pool all trials
allx=vertcat(pdata.x_warp);
ally=vertcat(pdata.y_warp);
allvel=vertcat(pdata.velocity_warp);
allcong=vertcat(pdata.congruency);

%plot heatmaps of conditions
figure;colormap('hot')
subplot(1,2,1);
imagep2d(allx(allcong==1,:),-ally(allcong==1,:),-640:20:640,-1024:20:0,[],[],1);
title('congruent')
subplot(1,2,2);
imagep2d(allx(allcong==2,:),-ally(allcong==2,:),-640:20:640,-1024:20:0,[],[],1);
title('incongruent')

% plot heatmap of velocity (=consistency of movement)
figure;colormap('hot')
imagep(allvel,[],[],[],1)
title('velocity (px/ms)')



%% perform TCMR
clear betas
figure
for p=1:length(pdata)  
    
    %calc regressors of each participant
    congs=pdata(p).congruency;%congruency
    n1response=pdata(p).response~=[0;pdata(p).response(1:end-1)];%response repetition bias
    
    %concatenate regressors and normalize each to [-1,1]
    regressors=normalizeRegressors([n1response,congs]);    
    %define data for TCMR
    regdata=pdata(p).angle_warp;
    
    %catch plotted information from TCMR
    subplots(length(pdata),p); 
    
    betas(:,:,p)=TCMRegression(regdata,regressors,10);    
end

%% determine some process parameters diretly from data
peaks=findStatPeaks(betas,'jackknife');
segments=findStatSegments(betas,0.05);

%% perform fitting
figure
[fitbetas,fitparams,fitvalues]=fitRegression(betas,'estimate',1);

%% save parameters for statistical analyis in external software (e.g. JASP)
saveCSV('fit_parameters.csv',{'n1response_time','n1response_width',...
                              'n1response_strength','cong_time','cong_width','cong_strength'},...
        [squeeze(fitparams(1,:,:))',squeeze(fitparams(2,:,:))']);

%% write table with data to commandline
writeParameterTable(fitparams,fitvalues);
writePeakTable(peaks);
writeSegmentTable(segments);

%% plot results summary for TCMR and fitting results
figure;clear s
s(1)=subplot(1,2,1);
plotRegression(betas);
plotSegmentLines(segments,10);
plotPeaks(peaks,0.05);
xlabel('time slice');ylabel('\beta weight')
title('Real betas')
s(2)=subplot(1,2,2);
plotRegression(fitbetas);
plotModelLines(fitparams,0.1);
xlabel('time slice');ylabel('\beta weight')
title('Fitted betas')
legend({'responseN-1','location','congruency sequence'})
linkaxes(s)

