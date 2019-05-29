function [month_avg,month_sum,month_count,month_vec,month_min,month_max,month_std]...
    = AM_month(var,dateloc)
%Function calculates monthly averages for flux or meteorological variables
%Natalia Restrepo June 17, 2006 Arizona
% var=nee_night_ustar;
% Y=Y_night_ustar
% M=M_night_ustar
% dateloc=dateloc_night_ustar
warning off all
%..........................................................................
%Requires the following info
%D: day vector
%dateloc: date vector (Y,M,D,HR,MI,SS)
%      it will take first and last day of time series
%.......................................................................... 
[Y,M,D] = datevec(dateloc);
%Remove few values if by UTM you are calculating Jan 1
while ((M(end)==1)&(D(end)==1))
    dateloc(end)=[];
    var(end)=[];
    [Y,M,D] = datevec(dateloc);
end
while ((M(1)==12)&(D(1)==31))
    dateloc(1)=[];
    var(1)=[];
    [Y,M,D] = datevec(dateloc);
end

dayloc = (datenum(Y(1),M(1),1):1:datenum(Y(end),M(end),1))';
[Yday,Mday,Dday] = datevec(dayloc);
month_vec = dayloc;                                 month_vec(Dday~=1) = [];
c = length(month_vec);
[Ymonth,Mmonth,~] = datevec(month_vec);
dateloc_month     = datenum(Y,M,1);

%Define vectors
a = length(month_vec);
month_sum = NaN(a,1);   month_count = NaN(a,1);     month_avg = NaN(a,1);
month_min = NaN(a,1);   month_max = NaN(a,1);       month_std = NaN(a,1);

%daily precipitation and snow fall values
for ip=1:a
    var_month=var;
    var_month(dateloc_month~=month_vec(ip))=[];
    var_month(isnan(var_month))=[];
    month_sum(ip) = nansum(var_month);
    month_count(ip) = nanmax(size(var_month));
    month_avg(ip) = nanmean(var_month);
    month_std(ip) = nanstd(var_month);
    if length(var_month(~isnan(var_month)))>1
        month_min(ip) = nanmin(var_month);
        month_max(ip) = nanmax(var_month);
    end
end

[a,b]=size(month_vec);
if b>a
    month_vec=month_vec';
end