function [day_avg,day_sum,day_count,day_std,dayloc,day_min,day_max,...
    day_time_min,day_time_max] = AM_day(var,dateloc,leap)
%Function calculates daily averages for flux or meteorological variables
%Natalia Restrepo June 17, 2006 Arizona
% var=par;
% leap ==0 do not delete Feb 29
warning off all
if isempty(leap); leap=0; end
%.......................................................................... 
%Requires the following info
%dateloc: date vector (Y,M,D,HR,MI,SS)
%leap==1 remove leap day
%.......................................................................... 
X=[dateloc,var];   Y=sortrows(X,1);     var=Y(:,2);   dateloc=Y(:,1);
[Y,M,D] = datevec(dateloc);
%Remove few values if by UTM you are calculating Jan 1
while ((M(end)==1)&&(D(end)==1))
    dateloc(end)=[];
    var(end)=[];
    [Y,M,D] = datevec(dateloc);
end
while ((M(1)==12)&&(D(1)==31))
    dateloc(1)=[];
    var(1)=[];
    [Y,M,D] = datevec(dateloc);
end

dayloc = ((datenum(Y(1),M(1),D(1))):1:(datenum(Y(end),M(end),D(end))))';
if leap==1
    [~,Mday,Dday]=datevec(dayloc);
    dayloc((Mday==2)&(Dday==29))=[];
end
dateday = datenum(Y,M,D);

a = length(var);
c = length(dayloc);

%Define vectors
day_sum=NaN(c,1);	day_avg=NaN(c,1);	day_count=NaN(c,1);     day_std=NaN(c,1);
day_max=NaN(c,1);	day_min=NaN(c,1);	day_time_max=NaN(c,1);  day_time_min=NaN(c,1);
%daily precipitation and snow fall values

for ik=1:c
    ind=find(dateday==dayloc(ik));
    var_day=var(ind);               dateloc_day=dateloc(ind);
    var_day(isnan(var_day))=[];     dateloc_day(isnan(var_day))=[];
    [~,~,~,HRvar_day,~,~]=datevec(dateloc_day);
    if ~isempty(var_day)
        day_count(ik) = length(var_day);
        day_avg(ik)   = nanmean(var_day);
        day_sum(ik)   = nansum(var_day);
        day_std(ik)   = nanstd(var_day);
        day_max(ik)   = nanmax(var_day);
        day_min(ik)   = nanmin(var_day);
        im = find(var_day==nanmin(var_day));  day_time_min(ik) = nanmin(HRvar_day(im));
        im = find(var_day==nanmax(var_day));  day_time_max(ik) = nanmax(HRvar_day(im));
    end
end

%..........................................................................
% figure('color','white')
% subplot(3,1,1);
% plot(var_day_avg,'d','Color',[0.4,0.4,0.4],'MarkerEdgeColor',[ 0.545 0.608 0.110 ],...
%     'MarkerFaceColor',[ 0.792 0.918 0.082 ],'MarkerSize',4);
% ylabel('name');
% set(gca,'XTick',0:30.42:c); axis tight;
% set(gca,'XTickLabel',{'Jan','','','Apr','','','Jul','','','Oct','',''});

% pack;