function [var_clean,outliers]=AM_rm_outlier(var,howmuch)
%Remove outliers defined as a treshold above or below 
%the mean plus/minus x standard deviations
%var: variable
%howmuch is the std multiplier. 
%Check your data before and after to verify you are not getting rid of "true" data
%Natalia Restrepo Coupe
%Tucson, Arizona, 2016

flag_transpose = 0;
[a,b] = size(var);
if b>a 
    var = var'; flag_transpose = 1; a = b;  
end

a = length(var);       
mean_var = nanmean(var(~isnan(var))); % Data mean
std_var  = nanstd(var(~isnan(var))); % Data standard deviation
outliers = zeros(a,1);
outliers(abs(var - mean_var) > abs(howmuch*std_var))=1;
var_clean = var;
var_clean(outliers==1) = NaN;

if flag_transpose == 1 
    var_clean = var_clean';
end
% var_clean=AM_fill(var_clean);
