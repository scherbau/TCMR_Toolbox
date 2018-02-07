function signal=normLength(signal,thelength,interpolate)
%function signal=normLength(signal,thelength,interpolate)
%interpolate or fillup/cut a vector to specific length 
%signal=vector or matrix(trial x time) 
%thelength: length of data (default:100)
%norming procedure:
% 0 => fillup with NaNs; [0,f] => fillup with f; if f==inf, fill up with last value in signal
% 1 => indicates interpolation (default); 


% Author: Stefan Scherbaum, University of Dresden, 2011
%
% Copyright (C) 2011 Stefan Scherbaum, stefan.scherbaum@tu-dresden.de
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


if(~exist('interpolate','var')||isempty(interpolate))
    interpolate=1;
elseif(length(interpolate)==1)
    fillup=NaN;
    takemax=0;
elseif(length(interpolate)==2)
    fillup=interpolate(2);
    fillup2=interpolate(2);
    interpolate=interpolate(1);
    if(isinf(fillup))
        takemax=1;
    else
        takemax=0;
    end
else
    fillup=interpolate(2);
    fillup2=interpolate(3);
    interpolate=interpolate(1);    
end 

if(~exist('thelength','var')||isempty(thelength))
    thelength=100;
end 

if(interpolate==1)
    if(~isvector(signal))%if matrix
        signal=interp1(signal',linspace(1,size(signal,2),thelength))';
    else%if vector
        if(size(signal,1)>1),signal=signal';mirror=1;else mirror=0;end%turn vector if necessary
        signal=interp1(signal,linspace(1,size(signal,2),thelength));
        if(mirror);signal=signal';end%turn vector back if necessary
    end
else%if cut/fillup
    if(~isvector(signal))%if matrix
        if(size(signal,2)<thelength)%if fillup needed
            if(~takemax)
                signal(:,end+1:thelength)=fillup;
            else
                signal(:,end+1:thelength)=repmat(signal(:,end),1,length(size(signal,2)+1:thelength));
            end                        
        else
            signal=signal(:,1:thelength);
        end
    else%if vector
        if(length(signal)<thelength)%if fillup needed
            if(~takemax)
                signal(end+1:thelength)=fillup;
            else
                signal(end+1:thelength)=signal(end);
            end            
        else%if signal must be cut
            signal=signal(1:thelength);
        end
    end
end