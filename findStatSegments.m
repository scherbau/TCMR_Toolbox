function [segments,segmentsraw,segmentstats]=findStatSegments(betas,alpha)
%function findStatSegments(betas,consecutive,alpha)
% Detects statistically significant segments in the results of TCMRegression
% Inputs:
%   betas: the betas from TCMRegression (regressor x time x subject)
%   alpha: alpha level for significance testing of each time point (ttest against 0)
%
%Outputs:
%   segments: cell array of segment start and end times, with one cell for each beta
%   segmentsraw: matrix (beta  x time) of true/false result of ttest of each time point
%   segmentstats: matrix (beta  x time) of tvalues from ttest of each time point
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
if(~exist('alpha','var') || isempty(alpha))
    alpha=0.05;
end

%% detect segments
thestd=nan(size(betas,1),size(betas,2));
segmentstats=nan(size(betas,1),size(betas,2));
for b=1:size(betas,1)
    [thestd(b,:),~,~,tstats]=ttest(squeeze(betas(b,:,:))',0,alpha,'right');                
    segmentstats(b,:)=tstats.tstat;        
    segments{b}=detectSegments(thestd(b,:));
end
segmentsraw=thestd;
warning('on');


end