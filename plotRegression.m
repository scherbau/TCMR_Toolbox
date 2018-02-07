function plotRegression(betas,colors,linestyle)
%function plotRegression(data,colors,linestyle)
%plots mean results from TCMR for each beta across subjects with shaded area indicating standard errors
%inputs:
%   betas = data from TCMR, matrix beta x time x subject
%   colors = colorstring for different betas
%   linestyle = matrix of linestyles for all betas, e.g. ['- ';'--']
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

%% check default values

if(~exist('colors','var') || isempty(colors))
    colors=repmat('brgcmyk',1,ceil(size(betas,1)/7));
end

if(~exist('linestyle','var') || isempty(linestyle))
    linestyle=repmat(['- ';'-.';'--';': '],ceil(size(betas,1)/4),1);
elseif(size(linestyle,1)==1)
    linestyle=repmat(linestyle,size(betas,1),1);    
end

gca;hold on;
for b=1:size(betas)
    if(size(betas,3)==1)
        plot(betas(b,:),[colors(b),linestyle(b,:)]);
    else      
        errorArea(mean(betas(b,:,:),3),ste(betas(b,:,:),3),[colors(b),linestyle(b,:)]);
    end
end
marky
