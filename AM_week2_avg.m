function [week_avg,week_count,week_std,week_min,week_max,week_vec] = AM_week2_avg(var,dateloc)
%Bi-weekly values all years from a bi-weekly time series
%Natalia Restrepo
%Tucson, AZ, July 5, 2007
warning off all
%..........................................................................
%..........................................................................
week_avg=NaN(23,1);     week_count=NaN(23,1);	week_std=NaN(23,1);
week_min=NaN(23,1);     week_max=NaN(23,1);

[Y,~,~]=datevec(dateloc);
JD=dateloc-datenum(Y,1,1)+1;
week=(1:16:365)';

for in=1:length(week)
    ind=find((JD==week(in))&(~isnan(var)));
    week_avg(in)=nanmean(var(ind));
    week_std(in)=nanstd(var(ind));
    week_count(in)=length(ind);
    if length(ind)>1
        week_min(in)=nanmin(var(ind));
        week_max(in)=nanmax(var(ind));
    else
        week_min(in)=week_avg(in);
        week_max(in)=week_avg(in);
    end;
end;
week_vec=datenum(0,1,1):16:datenum(0,12,31);