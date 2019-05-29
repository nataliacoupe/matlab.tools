function [week_avg,week_count,week_sum,week_min,week_max,week_std,weekloc,...
    var_cycle_out,var_cycle_out_dateloc] =...
    AM_week2cycle_rs(var,dateloc,tresh_daily,tresh_nhours,tresh_anomaly)
% %Function calculates 16 days average for daily flux or meteorological variables
% %It does so in similar way that MODIS products are deliver, each year=week 1
% %Natalia Restrepo June 19, 2007 Arizona
warning off all
% %..........................................................................
% %Requires the following info
% %var:           hourly measurements
% %dateloc:       YYY,MM,DD time vector
% %tresh_daily:   minumum number of hours per day
% %tresh_nhours:  minimum number of points per hour to obtain the average
% %tresh_anomaly: outlier definition for the hour
% %..........................................................................
[Y,M,D,HR,~,~] = datevec(dateloc);
% %Remove few values if by UTM you are calculating Jan 1
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

year   = (Y(1):1:Y(end))';       numyear = length(year);
HRtime = unique(HR);             numhour = length(HRtime);

weekloc=[];
for ik=1:numyear
    Yweekloc = ((datenum(year(ik),1,1)):16:(datenum(year(ik),12,31)))';
    weekloc  = ([weekloc;Yweekloc]);
end
numweek = length(weekloc);

% % %Define vectors
week_sum = NaN(numweek,1);          week_count = NaN(numweek,1);
week_std = NaN(numweek,1);          week_avg   = NaN(numweek,1);
week_min = NaN(numweek,1);          week_max   = NaN(numweek,1);
var_cycle = NaN(numhour,1);         var_cycle_count = NaN(numhour,1);
var_vec   = var;                    hour_vec    = HR;
% % %daily precipitation and snow fall values

% color_mtx = jet(18);

% figure('color','white');        title ('Gs_dry(mm/ s^-^1)');
hour = (datenum(0,0,0,0:23,0,0))';
var_cycle_out = NaN(numweek.*24,1);     var_cycle_out_dateloc = NaN(numweek.*24,1);
for ik=1:numweek
    %     yearcount = ik-((floor((ik-1)/23)*23));
    weekcount = (ik*24)-23;
    var_cycle_out_dateloc(weekcount:weekcount+23) = weekloc(ik)+hour;
    %     subplot(6,4,yearcount);
    ij = weekloc(ik);               ip = weekloc(ik)+16;
    var_vec((dateloc<=ij)|(dateloc>ip))  = [];
    hour_vec((dateloc<=ij)|(dateloc>ip)) = [];
    var_vec = AM_rm_outlier(var_vec,tresh_anomaly);
    if ~isempty(var_vec(~isnan(var_vec)))
        var_vec = AM_fill(var_vec);
        for ip=1:numhour
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
        var_cycle = ix(numhour+1:numhour*2);
        var_cycle(isinf(var_cycle)) = NaN;
        
        var_cycle_out(weekcount:weekcount+23) = var_cycle;
        
        if (length(var_cycle(~isnan(var_cycle)))>=tresh_daily)
            week_avg(ik) = nanmean(var_cycle);
            week_std(ik) = std(var_cycle);
            week_sum(ik) = sum(var_cycle);
            week_min(ik) = min(var_cycle);
            week_max(ik) = max(var_cycle);
        end
    end
    %     plot(0:23,var_cycle,'color',color_mtx((floor((ik-1)/23))+1,:)); hold on;
    %     plot(0:23,(var_cycle*0)+week_avg(ik),':','color',color_mtx((floor((ik-1)/23))+1,:));
    %     axis([0 23 0 15]); %     xlim([0 23]);
    var_vec   = var;        	hour_vec        = HR;
    var_cycle = NaN(numhour,1);       var_cycle_count = NaN(numhour,1);
end
