function data=normScore(data,dim,lowbound,highbound)
%function data=normScore(data,dim,lowbound,highbound)
%transforms data into values between [lowbound (def:0) and highbound (def:1)]
%works on all matrices for no dim or dim=0 (normalization for all elements)
%works on 2D matrices for dim=1|2; (normalization for all elements of each row or column)
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

if(~exist('dim','var') || isempty(dim))
    dim=0;
end

if(~exist('lowbound','var') || isempty(lowbound))
    lowbound=0;
end

if(~exist('highbound','var') || isempty(highbound))
    highbound=1;
end

%% normalize to 0-1
if(length(unique(data(:)))<2)%if only 1 kind of value, no normalization possible --> normalize to 1
    data=ones(size(data));
else%else, really normalize to 0-1
    if(dim==0)%vector or matrix with no dim argument
        data=data-min(data(:));
        data=data/max(data(:));
    else%matrix
        if(numel(size(data))>2)
            error('normScore with dim argument only works on 2D matrices and vectors');
        end
        iter=size(data,3-dim);
        for i=1:iter
            if(dim==1)
                cdata=data(:,i);
            else
                cdata=data(i,:);
            end
            cdata=cdata(:);
            cdata=normScore(cdata);
            if(dim==1)
                data(:,i)=cdata;
            else
                data(i,:)=cdata';
            end        
        end
    end
end
%% renormalize to bounds
data=data*(highbound-lowbound)+lowbound;    