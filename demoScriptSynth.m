% DemoScript for TCMR Toolbox by Stefan Scherbaum (C) 2017
% generates artificial mouse tracking data for a simulated Simon task with individual differences and then analyzes these data via
% TCMR Toolbox
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

%% generate data, similar to empirical data from Scherbaum et al. 2010, Cognition

clear 
numvp=80;%number of subjects. Half of them will be task one, the other half task 2
numtr=200;
    

%the noise within subjects across time
wnoise=5;

%the individual differences (equally distribited)
%timing of location
randvalues=linspace(-10,10,numvp);
diff_location_time=randvalues(randperm(length(randvalues)));
%strength of location
randvalues=linspace(-0.3,1.7,numvp);%randn(numvp,1)*0.5+1;
diff_location_strength=randvalues(randperm(length(randvalues)));
%strength of adaptation
randvalues=linspace(-0.3,1.7,numvp);%randn(numvp,1)*0.5+1;
diff_adaptation_strength=randvalues(randperm(length(randvalues)));

%generate dataset for each subject and save in struct
for p=1:numvp
    
    pdata(p).location_time=diff_location_time(p);
    pdata(p).location_strength=diff_location_strength(p);
    pdata(p).adaptation_strength=diff_adaptation_strength(p);
    
    %prototype movement curves for the different influences in the two tasks
    
    %influence of previous response
    gw=gauss_curve(1:100,10,10);gw=gw/max(gw);
    n1response=repmat(gw*10,numtr,1);
    
    %influence of response
    gw=gauss_curve(1:100,135,25);gw=gw/max(gw);
    responsemov=repmat((gw*700),numtr,1);
    
    %influence of interference information
    gw=gauss_curve(1:100,70+diff_location_time(p),20);gw=gw/max(gw)*diff_location_strength(p);
    location=repmat((gw*70),numtr,1);
    
    %influence of conflict adaptation
    gw=gauss_curve(1:100,80,30);gw=gw/max(gw)*diff_adaptation_strength(p);
    adaptation=repmat((gw*20),numtr,1);    
    
    %generate a sequence with 4 different trials (not balanced for experimental puroposes!)
    sequence=randi(7,1,numtr)+1;% generateSequence(4,5,1);
    %code trial properties
    stimuli=[1,2,3,4,1,2,3,4;
             1,1,1,1,2,2,2,2];
    congruency=...
            [1,1,0,0,0,0,1,1];
    response=[1,1,1,1,2,2,2,2];


    task=(p>numvp/2)+1;%assume the first half of subjects to be task one, the other half task 2
    
    %code properties of each trial
    pdata(p).response=response(sequence)';
    pdata(p).n1response=[pdata(p).response(end);pdata(p).response(1:end-1)];
    pdata(p).congruent=congruency(sequence)';
    pdata(p).n1congruent=[pdata(p).congruent(end);pdata(p).congruent(1:end-1)];
    
    %created properties as influences on movement prototypes 
    wr=pdata(p).response;
    wn1=repmat(normScore(pdata(p).n1response==pdata(p).response,[],-1,1),1,100);
    wloc=repmat(normScore(pdata(p).congruent,[],-1,1),1,100);
    wadapt=repmat(normScore(pdata(p).congruent==pdata(p).n1congruent,[],-1,1),1,100);

    %save trial properties for analysis
    pdata(p).influence_response=responsemov(1,:);
    pdata(p).influence_location=location(1,:);
    pdata(p).influence_adaptation=adaptation(1,:);
    pdata(p).influence_n1response=n1response(1,:);
    
    %create movement as a linear combination of trial properties and
    %influences curves
    movement=responsemov+wn1.*n1response+wloc.*location+wadapt.*adaptation+smooth(randn(numtr,100)*wnoise,20,2,[],1);
    movement=movement-repmat(movement(:,1),1,100);%correct for same starting point
    pdata(p).y_stimlock=repmat(linspace(-980,1,100),numtr,1);
    pdata(p).x_stimlock=movement;%-repmat(movement(:,1),1,100);        
        
    pdata(p).valid=true(size(pdata(p).response));
end

%% Plot trajectories and angles per condition and area under the curve/mean deviation
clear traj_* a_*
for p=1:length(pdata)
    %normalize sample timing using correctSampleTiming - not necessary since artificial data
    
    %calculate all trajectory data from the raw XY Movments
    [pdata(p).x_warp,pdata(p).y_warp,pdata(p).angle_warp,pdata(p).velocity_warp,pdata(p).deviation_warp]=calcTrajectories(pdata(p).x_stimlock,pdata(p).y_stimlock,100);
    
    %calculate static data from raw trajectories
    [pdata(p).auc,pdata(p).maxdev]=calcStatic(pdata(p).x_stimlock,pdata(p).y_stimlock);
    
    
    %calc mean x movements, angles and AUC for each subject and condition
    map=pdata(p).congruent==1 & pdata(p).n1congruent==1;
    traj_cc(p,:)=mean(pdata(p).x_stimlock(map,:),1);
    a_cc(p,:)=mean(pdata(p).angle_warp(map,:),1);
    auc_cc(p,:)=mean(pdata(p).auc(map));
    map=pdata(p).congruent~=1 & pdata(p).n1congruent~=1;
    traj_ii(p,:)=mean(pdata(p).x_stimlock(map,:),1);
    a_ii(p,:)=mean(pdata(p).angle_warp(map,:),1);
    auc_ii(p,:)=mean(pdata(p).auc(map));
    map=pdata(p).congruent~=1 & pdata(p).n1congruent==1;
    traj_ci(p,:)=mean(pdata(p).x_stimlock(map,:),1);
    a_ci(p,:)=mean(pdata(p).angle_warp(map,:),1);
    auc_ci(p,:)=mean(pdata(p).auc(map));
    map=pdata(p).congruent==1 & pdata(p).n1congruent~=1;
    traj_ic(p,:)=mean(pdata(p).x_stimlock(map,:),1);
    a_ic(p,:)=mean(pdata(p).angle_warp(map,:),1);
    auc_ic(p,:)=mean(pdata(p).auc(map));        
end

%plot mean deviation
figure;hold on
errorbar([mean(auc_cc),mean(auc_ic)],[ste(auc_cc),ste(auc_ic)],'bs-')
errorbar([mean(auc_ci),mean(auc_ic)],[ste(auc_cc),ste(auc_ii)],'ro-')
set(gca,'XTick',1:2);    
set(gca,'XTickLabel','congruent|incongruent');
xlabel('trial N-1')
legend('congruent','incongruent');
ylabel('Mean deviation (px)')

% plot x movements
figure
errorArea(mean(traj_ci,1),ste(traj_ci,1),'r')
errorArea(mean(traj_ii,1),ste(traj_ii,1),'m')
errorArea(mean(traj_cc,1),ste(traj_cc,1),'b')
errorArea(mean(traj_ic,1),ste(traj_ic,1),'c')
ylabel('X Position (pixels)');xlabel('time slice')

% plot movement angles
figure
errorArea(mean(a_ci,1),ste(a_ci,1),'r')
errorArea(mean(a_ii,1),ste(a_ii,1),'m')
errorArea(mean(a_cc,1),ste(a_cc,1),'b')
errorArea(mean(a_ic,1),ste(a_ic,1),'c')
ylabel('Movement angle (radians)');xlabel('time slice')
legend('congruent - incongruent','incongruent - incongruent','congruent - congruent','incongruent - congruent')

%% draw heatmaps for an overview of data
%pool all data
allcongs=vertcat(pdata.congruent);
allx=vertcat(pdata.x_warp);
ally=vertcat(pdata.y_warp);

%plot the 2D heatmaps
figure
subplot(1,2,1)
imagep2d(allx(allcongs==1,:),ally(allcongs==1,:),-100:10:700,-980:10:0,[],[],1,0,1);
title('congruent')
subplot(1,2,2)
imagep2d(allx(allcongs~=1,:),ally(allcongs~=1,:),-100:10:700,-980:10:0,[],[],1,0,1);
title('incongruent')
colormap('hot')
%% Analyze using TCMR

%perform regression analysis
figure
clear betas
for v=1:length(pdata)      
    
    %create regressors of each subject, normalized to [-1,1]
    map=pdata(v).valid;
    response=normScore(-pdata(v).response(map),0,-1,1);%response
    congs=normScore(pdata(v).congruent(map),0,-1,1).*sign(response);%interference, considering the response
    n1response=normScore(-pdata(v).n1response(map),0,-1,1);%previous response
    pdata(v).n1switch=pdata(v).n1congruent~=pdata(v).congruent;
    n1switch=0.5-pdata(v).n1switch(map);n1switch=normScore(n1switch.*sign(response),0,-1,1);%conflict adaptation considerung the response
    
    %build regressor matrix
    regressors=[response,n1response,congs,n1switch];    
    
    %the generated data have mirrored responses --> all response go to the
    %right --> remirror movements so that response  1 = left, response 2 =
    %right
    regdata=pdata(v).angle_warp(map,:).*repmat(response,1,size(pdata(v).angle_warp,2));
    
    %open subplot for VIF of each subject
    subplots(length(pdata),v); 
    
    %% perform TCMR
    betas(:,:,v)=TCMRegression(regdata,regressors,10,1);
    
end

%% Perform gauss fit for each condition with automatically estimated parameter
figure
[fitbetas,fitparams,fitvalue]=fitRegression(betas,'estimate',1);

%% plot grand averages for betas and fitted betas
figure;clear s
s(1)=subplot(1,2,1)
plotRegression(betas);
[segments1]=findStatSegments(betas,0.01);
plotSegmentLines(segments1,10);
[peaks1]=findStatPeaks(betas,'jackknife');
plotPeaks(peaks1,0.05);
xlabel('time slice');ylabel('\beta weight')
title('Task 1')
legend({'response','responseN-1','interference','congruency sequence'})
s(2)=subplot(1,2,2)
plotRegression(fitbetas);
plotModelLines(fitparams,0.01);
xlabel('time slice');ylabel('fitted \beta weight')
title('Task 1 gauss fit')
linkaxes(s)


%% analyze correlations

%plot box plot to inspect range of each parameter from gauss fitting
labels={'response','responseN-1','interference','congruency sequence'};
params={'time','SD','strength'}
figure;clear s
for r=1:size(fitparams,2)
    s(r)=subplot(1,size(fitparams,2),r)
    boxplot(squeeze(fitparams(:,r,:))')
    
    title(params{r})
    set(gca,'XTick',1:size(fitparams,1));
    
    set(gca,'XTickLabel',labels);
    
end

%plot scatter plots to inspect correlations between the paramters of
%generated data and the parameters extracted by gauss fitting
figure
subplot(1,3,1)
scatter(vertcat(pdata.location_time),squeeze(fitparams(3,1,:)))
title(sprintf('interference timing - r = %2.2f',corr(vertcat(pdata.location_time),squeeze(fitparams(3,1,:)))));
xlabel('generated');ylabel('fitted')
subplot(1,3,2)
scatter(vertcat(pdata.location_strength),squeeze(fitparams(3,3,:)))
title(sprintf('interference strength - r = %2.2f',corr(vertcat(pdata.location_strength),squeeze(fitparams(3,3,:)))));
xlabel('generated');ylabel('fitted')
subplot(1,3,3)
scatter(vertcat(pdata.adaptation_strength),squeeze(fitparams(4,3,:)))
title(sprintf('adaptation strength - r = %2.2f',corr(vertcat(pdata.adaptation_strength),squeeze(fitparams(4,3,:)))));
xlabel('generated');ylabel('fitted')
