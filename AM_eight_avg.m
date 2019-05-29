function [eight_avg,eight_count,eight_std,eight_min,eight_max,eight_vec] = AM_eight_incomplete_avg(var1,date)

g=max(size(var1))./46;
eight_avg=NaN(46,1);    eight_count=eight_avg;  eight_std=eight_avg;
eight_min=eight_avg;    eight_max=eight_avg;
for n=1:46
    k=[];
    for m=1:g
        k=[k;(n+(46*(m-1)))];
    end;
    x=var1(k);  x(isnan(x))=[];
    eight_avg(n,1)=nanmean(x);
    eight_count(n,1)=max(size(x));
    eight_std(n,1)=nanstd(x);
    if max(size(x))>1
        eight_min(n,1)=nanmin(x);
        eight_max(n,1)=nanmax(x);
    elseif min(size(x))==1
        eight_min(n,1)=x;
        eight_max(n,1)=x;
    end;
end;
eight_vec=datenum(0,1,1):8:datenum(0,12,31);