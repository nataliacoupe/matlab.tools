% Finds the annual daily average -a composit of 365 points var_avg
% Normalizes the annual daily time series and then computes the all-year
% composite var_avg_normal, useful for finding the timing of max, min.
function [var_avg,var_std,var_count,var_min,var_max,var_avg_normal] =...
    AM_day_avg(var,dateloc)

[Yvar,~,~]= datevec(dateloc);
JDvar = dateloc - datenum(Yvar,1,1) + 1;
year  = unique(Yvar);
var_avg = NaN(365,1);       var_std = NaN(365,1);	var_count      = NaN(365,1);
var_min = NaN(365,1);       var_max = NaN(365,1);   var_avg_normal = NaN(365,1);

for ik = 1:365
    ind = find((JDvar==ik)&(~isnan(var)));
    if ind>0
        var_tmp = var(ind);
        var_avg(ik) = nanmean(var_tmp);
        var_std(ik) = nanstd(var_tmp);
        var_min(ik) = nanmin(var_tmp);
        var_max(ik) = nanmax(var_tmp);
        var_count(ik) = max(size(var_tmp));
    end;
end;

var_tmp=var;
for ik = 1:length(year)
    var_year = var_tmp(Yvar==year(ik));
    var_year = AM_rm_outlier(var_year,3);
    if length(var_year) > 300
        ix = (var_year-nanmin(var_year))./(nanmax(var_year)-nanmin(var_year));
        var_tmp(Yvar==year(ik)) = ix;
    else
        var_tmp(Yvar==year(ik)) = NaN.*var_tmp(Yvar==year(ik));
    end;
end;

for ik = 1:365
    var_year = var_tmp;
    var_year((JDvar~=ik)|(isnan(var_year))) = [];
    var_avg_normal(ik) = nanmean(var_year);
end;
