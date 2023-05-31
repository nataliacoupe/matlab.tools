function [eight_avg,eight_count,eight_sum,eight_min,eight_max,eight_std,eightloc] =...
    AM_eight2cycle_rs(var,dateloc,tresh_daily,tresh_nhours,tresh_anomaly)
%Function calculates 8 days average for daily flux or meteorological variables
%It does so in similar way that MODIS products are deliver, each year=eight 1
%Natalia Restrepo June 19, 2007 Arizona
warning off all
%..........................................................................
%Requires the following info
%var: daily measurements
%dateloc=YYY,MM,DD time vector
%..........................................................................
[Y,M,D,HR,~,~] = datevec(dateloc);
%Remove few values if by UTM you are calculating Jan 1
while ((M(end)==1)&&(D(end)==1))
    dateloc(end) = [];
    var(end)     = [];
    [Y,M,D,HR,~,~] = datevec(dateloc);
end
while ((M(1)==12)&&(D(1)==31))
    dateloc(1) = [];
    var(1)     = [];
    [Y,M,D,HR,~,~] = datevec(dateloc);
end

year   = (Y(1):1:Y(end))';       e = length(year);
HRtime = unique(HR);             b = length(HRtime);

eightloc=[];
for ik=1:e
    Yeightloc = ((datenum(year(ik),1,1)):8:(datenum(year(ik),12,31)))';
    eightloc  = ([eightloc;Yeightloc]);
end
c=length(eightloc);

%Define vectors
eight_sum = NaN(c,1);        eight_count = NaN(c,1);
eight_std = NaN(c,1);        eight_avg   = NaN(c,1);
eight_min = NaN(c,1);        eight_max   = NaN(c,1);
var_cycle = NaN(b,1);        var_cycle_count = NaN(b,1);
var_vec   = var;             hour_vec    = HR;
%daily precipitation and snow fall values
for ik=1:c
    ij = eightloc(ik);    ip = eightloc(ik)+8;
    var_vec((dateloc<=ij)|(dateloc>ip))  = [];
    hour_vec((dateloc<=ij)|(dateloc>ip)) = [];
    var_vec = AM_rm_outlier(var_vec,3);
    if ~isempty(var_vec(~isnan(var_vec)))
        var_vec = AM_fill(var_vec);
        for ip=1:b
            ind = find(hour_vec==HRtime(ip));
            if length(ind) >= tresh_nhours
                ix = var_vec(ind);
                ix = AM_rm_outlier(ix,tresh_anomaly);
                var_cycle(ip)       = nanmean(ix);
                var_cycle_count(ip) = length(ind(~isnan(ind)));
            end
        end
        var_cycle(var_cycle_count<tresh_nhours) = NaN;
        ix = [var_cycle;var_cycle;var_cycle];
        ix = AM_fill(ix);
        var_cycle = ix(b+1:b*2);
        var_cycle(isinf(var_cycle)) = NaN;
        if (length(var_cycle(~isnan(var_cycle)))>=tresh_daily)
            eight_avg(ik) = nanmean(var_cycle);
            eight_std(ik) = std(var_cycle);
            eight_sum(ik) = sum(var_cycle);
            eight_min(ik) = min(var_cycle);
            eight_max(ik) = max(var_cycle);
        end
    end
    var_vec   = var;        	hour_vec        = HR;
    var_cycle = NaN(b,1);       var_cycle_count = NaN(b,1);
end
