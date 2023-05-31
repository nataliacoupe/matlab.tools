function [eight_avg,eight_count,eight_sum,eight_min,eight_max,eight_std,eightloc,...
    eight_se]=  AM_eightday_rs(var,dateloc)
%Function calculates 8 days average for daily flux or meteorological variables
%It does so in similar way that MODIS products are deliver, each year=eight 1
%Natalia Restrepo June 19, 2007 Arizona
warning off all
% .........................................................................
%Requires the following info
%var: daily measurements
%dateloc=YYY,MM,DD time vector
%2 eights defined as 8 days
% .........................................................................
[Y,M,D,HR,~,~] = datevec(dateloc);
%Remove few values if by UTM you are calculating Jan 1
while ((M(end)==1)&&(D(end)==1))
    dateloc(end)=[];
    var(end)=[];
    [Y,M,D,HR,~,~] = datevec(dateloc);
end
while ((M(1)==12)&&(D(1)==31))
    dateloc(1)=[];
    var(1)=[];
    [Y,M,D,HR,~,~] = datevec(dateloc);
end

% .........................................................................
[Yday,~,~] = datevec(dateloc);
year = (Yday(1):1:Yday(end))'; 
e = length(year);
eightloc = [];
for im=1:e
    Yeightloc = ((datenum(year(im),1,1,0,0,0)):8:(datenum(year(im),12,31,23,30,0)))';
    eightloc = ([eightloc;Yeightloc]); 
end

% .........................................................................
c = length(eightloc);

%Define vectors
eight_sum = NaN(c,1);
eight_count = NaN(c,1);
eight_std = NaN(c,1);
eight_avg = NaN(c,1);
eight_min = NaN(c,1);
eight_max = NaN(c,1);
eight_se = NaN(c,1);

eight=var;
%daily precipitation and snow fall values
for im=1:c
    j   = eightloc(im);     k = eightloc(im)+8;
    ind = find((dateloc<j)|(dateloc>=k)|(isnan(var)));
    eight(ind)=[];
    count = length(eight);
    eight_count(im) = count;
    if count>0
        eight_avg(im) = nanmean (eight);
        eight_std(im) = nanstd (eight);
        eight_sum(im) = nansum (eight);
        eight_min(im) = nanmin (eight);
        eight_max(im) = nanmax (eight);
        eight_se(im)  = eight_std(im)/sqrt(eight_count(im));
    end
    eight = var;
end
