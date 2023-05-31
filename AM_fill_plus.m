function[var_fill] = AM_fill_plus(var)
%Plot and check: Every month the daily cycle and the time series of main
%meteorological and flux data
%Natalia Restrepo-Coupe, based on previous Scott Saleska plots
%Tucson AZ (Grand Canyon State) October 18, 2006
%..........................................................................
%..........................................................................
flag_transpose = 0;
[a,b] = size(var);
if b>a
    var = var'; flag_transpose = 1; a = b;
end

if a>3
    var = [var(end-3:end);var;var(1:4)];       var_fill=var;
    a=length(var);
    
    for ix=2:a-1
        if (isnan(var_fill(ix))); var_fill(ix)=(var_fill(ix-1)+var_fill(ix+1))./2; end
    end
    for ix=3:a-3
        if (isnan(var_fill(ix))); var_fill(ix)=(var_fill(ix-2)+var_fill(ix+2))./2; end
    end
    for ix=4:a-4
        if (isnan(var_fill(ix))); var_fill(ix)=(var_fill(ix-1)+var_fill(ix+1))./2; end
        if (isnan(var_fill(ix))); var_fill(ix)=(var_fill(ix-2)+var_fill(ix+2))./2; end
        if (isnan(var_fill(ix))); var_fill(ix)=(var_fill(ix-3)+var_fill(ix+3))./2; end
    end
    var_fill = var_fill(5:end-4);
else                %if lenght is <3
    var_fill = AM_fill(var);
end


if flag_transpose == 1
    var_fill = var_fill';
end
