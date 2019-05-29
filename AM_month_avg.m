% Finds the annual monthly average -a composit of 12 points
function [var_avg,var_std,var_count] = AM_month_avg(var,dateloc)

[~,Mvar,~]= datevec(dateloc);
var_avg=NaN(12,1);      var_std=NaN(12,1);      var_count=NaN(12,1);      

var_tmp=var;
for ik=1:12
    var_tmp=var;
    var_tmp((Mvar~=ik)|(isnan(var)))=[];
    var_avg(ik)=nanmean(var_tmp);
    var_std(ik)=nanstd(var_tmp);
    var_count(ik)=max(size(var_tmp));
end
