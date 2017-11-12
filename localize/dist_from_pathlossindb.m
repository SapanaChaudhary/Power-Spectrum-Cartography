%inverted okumura hata model
function [d] = dist_from_pathlossindb(lo)
% lu = path loss in dB from small sized city
% lo = path loss in dB from open area
f=900;
hm=2.5; % hm = hr = average mobile station height 
hb=35;

%okumara hata model
% d is in meters
%ch =3.2*(log10(11.75*hm))^2-4.97;
ch = 0.8 + (1.1*log10(f)-0.7)*hm - 1.56*log10(f);
lu = lo + 4.78*(log10(f))^2 - 18.33*log10(f) + 40.94 ;
d = 1000*10^((lu - 69.55 - 26.16*log10(f) + 13.82*log10(hb)+ ch)/(44.9-6.55*log10(hb))); 

% cost model
% lu = 46.3 + 33.9*log10(f) - 13.82*log10(hb) - a_cost + (44.9 - 6.55*log10(hb))*log10(d);
% a_cost = (1.1*log10(f) - 0.7)*hm -(1.56*log10(f) - 0.8);
% d = 1000*10^((lu - 46.3 - 33.9*log10(f) + 13.82*log10(hb) + a_cost)/(44.9 - 6.55*log10(hb)));
