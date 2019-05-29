function [month_avg,month_count,month_sum,month_min,month_max,month_std,monthloc,...
     var_cycle_out,var_cycle_out_dateloc]  =...
    AM_month2cycle(var,dateloc,tresh_daily,tresh_nhours,tresh_anomaly)
%var: daily measurements
%dateloc:       YYY,MM,DD time vector
%calculates the monthly values using the mean daily cycle
%tresh_daily:    number of daily hours
%tresh_nhours:   number of measurements per hour
%tresh_anomaly: rejected values

%..........................................................................
X = [dateloc,var];   Y = sortrows(X,1);     var = Y(:,2);   dateloc = Y(:,1);
[Y,M,D,HR,~,~]  =  datevec(dateloc);
%Remove few values if by UTM you are calculating Jan 1
while ((M(end)==1)&(D(end)==1))
    dateloc(end) = [];
    var(end)     = [];
    [Y,M,D,HR,~,~]  =  datevec(dateloc);
end
while ((M(1)==12)&(D(1)==31))
    dateloc(1) = [];
    var(1)     = [];
    [Y,M,D,HR,~,~]  =  datevec(dateloc);
end

year = (Y(1):1:Y(end))';          e = length(year);
HRtime = unique(HR);              b = length(HRtime);

dayloc = (datenum(Y(1),M(1),1):1:datenum(Y(end),M(end),1))';
[Yday,Mday,Dday] = datevec(dayloc);
monthloc = dayloc;                monthloc(Dday~=1) = [];
c = length(monthloc);
[Ymonth,Mmonth,~] = datevec(monthloc);

%Define vectors
month_sum  =  NaN(c,1);           month_count  =  NaN(c,1);
month_std  =  NaN(c,1);           month_avg  =  NaN(c,1);
month_min  =  NaN(c,1);           month_max  =  NaN(c,1);
var_cycle  =  NaN(b,1);           var_cycle_count  =  NaN(b,1);     
var_cycle_out         = [];       var_cycle_out_dateloc = [];
var_vec  =  var;                  hour_vec  =  HR;
%daily precipitation and snow fall values
for ik = 1:c
    ij = monthloc(ik); ip = monthloc(ik)+(eomday(Ymonth(ik),Mmonth(ik)));
    var_vec((dateloc<=ij)|(dateloc>ip)) = [];
    hour_vec((dateloc<=ij)|(dateloc>ip)) = [];
    var_vec = AM_rm_outlier(var_vec,3);
    var_vec = AM_fill(var_vec);
    if ~isempty(var_vec(~isnan(var_vec)))
        for ip  = 1:b
            ind = find(hour_vec == HRtime(ip));
            if length(ind) >= tresh_nhours
                ix = var_vec(ind);
                ix = AM_rm_outlier(ix,tresh_anomaly);
                var_cycle(ip) = nanmean(ix);
                var_cycle_count(ip) = length(ind(~isnan(ind)));    
                var_cycle_dateloc(ip) = ij;
            end
        end
        var_cycle(var_cycle_count<tresh_nhours) = NaN;
        ix = [var_cycle;var_cycle;var_cycle];
        ix = AM_fill(ix);
        var_cycle = ix(b+1:b*2);
        if (length(var_cycle(~isnan(var_cycle))) >= tresh_daily)
            month_avg(ik) = nanmean(var_cycle);
            month_std(ik) = std(var_cycle);
            month_sum(ik) = sum(var_cycle);
            month_min(ik) = min(var_cycle);
            month_max(ik) = max(var_cycle);
        end
    end
    var_cycle_out = [var_cycle_out;var_cycle];     
    var_cycle_out_dateloc  = [var_cycle_out_dateloc;monthloc(ik)+(datenum(0,0,0,0:23,0,0))'];    
    var_vec    = var;         hour_vec = HR;
    var_cycle  =  NaN(b,1);   var_cycle_count  =  NaN(b,1);
end