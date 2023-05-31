function[var_fill] = AM_fill(var)
%Fill time series using the nearest values
%Natalia Restrepo-Coupe
%Tucson AZ (Grand Canyon State) October 18, 2006
%..........................................................................
%..........................................................................
var_fill = var;
if length(var) > 4
    flag_transpose = 0;
    [a,b] = size(var);
    if b>a
        var = var'; flag_transpose = 1;
    end
    
    var = [var(end-1:end);var;var(1:2)];       var_fill=var;
    a=length(var);
    
    for x=2:a-1
        if (isnan(var_fill(x))); var_fill(x)=(var(x-1)+var(x+1))./2; end;
    end
    for x=3:a-2
        if (isnan(var_fill(x))); var_fill(x)=(var(x-2)+var(x+2))./2; end;
    end
    
    var_fill = var_fill(3:end-2);
    
    if flag_transpose == 1
        var_fill = var_fill';
    end
end
% if max(size(var_fill(~isnan(var_fill))))>3;
%     if isnan(var_fill(1)); var_fill(1)=var_fill(2); end;
%     if isnan(var_fill(end)); var_fill(end)=var_fill(end-1); end;
%     if isnan(var_fill(1)); var_fill(1)=var_fill(3); end;
%     if isnan(var_fill(end)); var_fill(end)=var_fill(end-2); end;
% end;
% x=49; for x=49:a-48;
%     if (isnan(var_fill(x))); var_fill(x)=(var(x-24)+var(x+24))./2; end;
%     if (isnan(var_fill(x))); var_fill(x)=(var(x-48)+var(x+48))./2; end;
% end;

