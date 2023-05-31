function [var_flag,var_spikefree] = AM_spike_detection(var,z)

%Spike detection method based on Papale et al 2006 
%Natalia Restrepo
%University of Arizona January 25, 2010
% .........................................................................
ind = find(isnan(var));
ind1 = ind-1;        ind1(ind1==0) = [];               var(ind1) = NaN;
ind2 = ind+1;        ind2(ind2>length(var)) = [];      var(ind2) = NaN;

var_i = var(2:end-1);
var_iplus1 = [var(3:end)];    var_iminus1 = [var(1:end-2)];
var_diff = (var_i-var_iminus1)-(var_iplus1-var_i);
var_diff = [0;var_diff;0];

%value is flagged if 
Md  = median(var_diff(~isnan(var_diff)));
MAD = median(abs(var_diff(~isnan(var_diff))-Md));

% z is threshold value If missing z = 4 More conservative values are z = 5.5 & 7
if isempty(z)    
    z = 4;    
end
var_flag = var.*0;
var_flag(var_diff>(Md+(z.*MAD./0.6745))) = 1;
var_flag(var_diff<(Md-(z.*MAD./0.6745))) = 1;

var_spikefree = var;
var_spikefree(var_flag == 1) = NaN;
