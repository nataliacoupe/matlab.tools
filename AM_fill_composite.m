function [var_fill,var_model_final] = AM_fill_composite(var,dateloc,composite)
%FORCED fill, 1) previous and later times
%2) year-month-cycle fills for average value same hour same month same year
%3) month-cycle fills for average value same hour same month all years
%4) moving trimester-cycle fills for average value same hour previous and next month all years
%5) year-cycle fills for average value same hour all years all months
%6) composite 12 = month, 23 = week, 46 = eight,  24 = hourly, 365 = daily
% Natalia Restrepo-Coupe, based on previous Scott Saleska plots
% Tucson AZ (Grand Canyon State) October 18, 2006
%..........................................................................
%..........................................................................
%..........................................................................
%Time vectors
%..........................................................................
%..........................................................................
[Y,M,D]    = datevec(dateloc);
month_year_cycle  = (datenum(Y(1),M(1),D(1)):datenum(0,0,0,1,0,0):datenum(Y(end),M(end),D(end)))';
[~,~,Dcycle_year] = datevec(month_year_cycle);      ind=find((Dcycle_year~=1));
% month_year_cycle(ind) = [];

% [Ycycle_year,Mcycle_year,~,HRcycle_year,~,~] = datevec(month_year_cycle);

%% Fill if sourounded by data..............................................
var = [var(end-composite+1:end);var;var(1:composite)];
var_fill = AM_fill(var);

if length(dateloc)==composite
    dateloc = [dateloc(end-composite+1:end)-365;dateloc;dateloc(1:composite)+365];
    dateloc = dateloc + 365;
else
    dateloc = [dateloc(end-composite+1:end)-365;dateloc;dateloc(1:composite)+365];
end
[Y,M,D,HR,~,~]    = datevec(dateloc);               JD = dateloc - datenum(Y,1,0,HR,0,0);
a = length(var); 
%..........................................................................
%..........................................................................
%Year Modatelocnth Hour cycle
%..........................................................................
%..........................................................................
if (composite == 12)
    [var_cycle_year,var_cycle_std] = AM_month_avg(var,dateloc);
elseif (composite == 23)    M(M==13) = 1;
    [var_cycle_year,~,var_cycle_std] = AM_week2_avg(var,dateloc);
    M = 1+round(JD./16);    M(M==24) = 1;
elseif (composite == 46)
    [var_cycle_year,~,var_cycle_std] = AM_eight_avg(var,dateloc);
    M = 1+round(JD./8);     M(M==47) = 1;
end

%Filling the grid
var_model = NaN(a,1);                     var_model_std = NaN(a,1);
for ind=1:a
    var_model(ind)     = var_cycle_year(M(ind));
    var_model_std(ind) = var_cycle_std(M(ind));
end

var_model = AM_rm_outlier(var_model,3);   var_model_std = AM_rm_outlier(var_model_std,3);
var_model_final = var_model;

%..........................................................................
%..........................................................................
%% Month Hour cycle (all years)
%..........................................................................
%..........................................................................
% % % [var_cycle,var_cycle_count] = AM_day_cycle(var,dateloc,6,18);
% % % var_cycle = AM_fill(var_cycle);
% % % %Filling the grid month cycle
% % % for ind=1:a
% % %     if (isnan(var_model(ind)))
% % %         var_model(ind) = var_cycle(M(ind),HR(ind)+1);
% % %     end;
% % % end;
% % %
% % % var_model = AM_rm_outlier(var_model,3);
% % % var_model_final(isnan(var_model_final)) = var_model(isnan(var_model_final));

% % % %..........................................................................
% % % %..........................................................................
% % % %Tri-month Hour cycle (all years)
% % % %..........................................................................
% % % %..........................................................................
% % % [var_cycle,var_cycle_count]=AM_day_cycle(var,dateloc,6,18);
% % % % ROW: Nov, Dec, Jan-Dec, Jan, Feb total 16 rows
% % % x=[var_cycle(11:12,:);var_cycle;var_cycle(1:2,:)];
% % % % COL: 22:00 , 23:00, 1:00-23:00, 1:00, 2:00 total 28 cols
% % % x=[x(:,end-1:end),x,x(:,1:2)];
% % % for ind=1:16; x(ind,:)=AM_fill(x(ind,:));   end;
% % % for ind=1:28; x(:,ind)=AM_fill(x(:,ind));   end;
% % % var_cycle=x(3:14,3:26);
% % %
% % % %Filling the grid month cycle
% % % for ind=1:a
% % %     if (isnan(var_model(ind)))
% % %         var_model(ind)=var_cycle(M(ind),HR(ind)+1);
% % %     end;
% % % end;
% % %
% % % var_model = AM_rm_outlier(var_model,3);
% % % var_model_final(isnan(var_model_final)) = var_model(isnan(var_model_final));
% % %
% % % %..........................................................................
% % % %..........................................................................
% % % %Hour cycle (all years all months)
% % % %..........................................................................
% % % %..........................................................................
% % % [~,~,~,~,var_cycle] = AM_day_cycle(var,dateloc,6,18);
% % % %Filling the grid month cycle
% % % for ind=1:a
% % %     if (isnan(var_model(ind)))
% % %         var_model(ind)=var_cycle(HR(ind)+1);
% % %     end;
% % % end;
% % %
% % % var_model = AM_rm_outlier(var_model,3);
% % % var_model_final(isnan(var_model_final)) = var_model(isnan(var_model_final));
% % %
%% Fill if sourounded by data..............................................
% var_fill_cycle(isnan(var)) = var_model_final(isnan(var));

for ix=2:a-1
    if (isnan(var(ix)))&(~isnan(var(ix-1)))&(~isnan(var(ix+1)))
        var_fill(ix)=var_model_final(ix);
    end
end
for ix=3:a-2
    if (isnan(var(ix)))&(~isnan(var(ix-2)))&(~isnan(var(ix+2)))
        var_fill(ix)=var_model_final(ix);
    end
end

var_fill = var_fill(composite+1:end-composite);
var_model_final = var_model_final(composite+1:end-composite);