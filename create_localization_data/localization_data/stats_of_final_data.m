% what does the final data say
clc
clear all
close all

load final_data

sz = size(final_data);

for i = 1:sz(1,1)
    sa = 0;
   for j = 1:(sz(1,2)-1)
       if (final_data(i,j) == 0 || final_data(i,j) == 1111)
           sa = sa+1;
       end
   end
   sa_re_ga(i,1) = sa;
end

%sa_re_ga = 36*ones(sz(1,1),1,1) - sa_re_ga;
for i = 1:sz(1,1)
    if (sa_re_ga(i,1) == 1) 
    sa_re_ga(i,1) = 0;
    elseif (sa_re_ga(i,1) == 7)
        sa_re_ga(i,1) = 6;
    elseif (sa_re_ga(i,1) == 13)
        sa_re_ga(i,1) = 12;
    elseif (sa_re_ga(i,1) == 19)
        sa_re_ga(i,1) = 18;
    elseif (sa_re_ga(i,1) == 25)
        sa_re_ga(i,1) = 24;
    end
end

sa_re_ga = 36*ones(sz(1,1),1,1) - sa_re_ga;
sa_re_ga = sa_re_ga./6;
h = histogram(sa_re_ga,6);
h

