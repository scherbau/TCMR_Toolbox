function [vifs,vifsok]=VIF(regressors)
%Variance inflation factor, indexing multicolinaerity/correlation of regressors in multiple regression analysis.
%As a rule of thumb, VIF should be < 5 to exclude multicolinearity.
%(see http://en.wikipedia.org/wiki/Variance_inflation_factor).
%Input:
%   regressors: regressors to calculate VIF for: 2D matrix (samples x regressors)
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
%
constant=ones(size(regressors,1),1);
vifs=NaN(1,size(regressors,2));
vifsok=NaN(1,size(regressors,2));
warning('off')
for r=1:size(regressors,2)
    theregressors=regressors(:,[setdiff(1:size(regressors,2),r)]);    
    [~,~,~,~,stats]=regress(regressors(:,r),[constant,theregressors]);
    rsquare(r)=stats(1);
    vifs(r)=1/(1-rsquare(r));
    vifsok(r)=vifs(r)<5;
end
warning('on')

if(nargout==0)
    gca;
    bar(vifs);ylim([0,6]);line(xlim,[5,5],'Color','r');
end