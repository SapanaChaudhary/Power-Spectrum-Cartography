% import and save the location data
clc
clear all
close all

load sec_139
load my_map % bcch and bsic mapped to 
load ci_lat_lon
load bcch_new
load bsic
merged = sec_139;

s1 = size(merged);
s2 = size(my_map);
s3 = size(ci_lat_lon);

final_data = [];

flg_1 = 0; flg_2 = 0; flg_3 = 0; flg_4 = 0;
% %%
% j = 4;i =13;
%%
sap = 0;
for j = 1:6 % for all the columns %%just for the last column for the time being 
for i = 1:s1(1,1) % 
    if (bcch_new(i,j) ~= 1111)
        %% 
        flg_1 = flg_1+1;
        for k =1:s2(1,1)
            if ((bcch_new(i,j) == my_map(k,1))&&(bsic(i,j) == my_map(k,2))) 
                final_data(i,(j-1)*6+1) = bcch_new(i,j); % bcch
                final_data(i,(j-1)*6+2) = bsic(i,j); %bsic
                final_data(i,(j-1)*6+3) = my_map(k,3); %cell ID 
                final_data(i,(j-1)*6+4) = merged(i,(j-1)*3+41); % RSSI
                sap = sap+1;
                flg_2 = flg_2+1;
                for m = 1:s3(1,1)
                    if (ci_lat_lon(m,1) == my_map(k,3))   
                     final_data(i,(j-1)*6+5) = ci_lat_lon(m,2); % Lat
                     final_data(i,(j-1)*6+6) = ci_lat_lon(m,3); % Long
                     flg_3 = flg_3+1;
                    end
                end
%             else 
%                 final_data(i,(j-1)*6+1) = 1111; % bcch
%                 final_data(i,(j-1)*6+2) = 1111; % bsic
%                 final_data(i,(j-1)*6+3) = 1111; % cell ID 
%                 final_data(i,(j-1)*6+4) = 1111; % RSSI
%                 final_data(i,(j-1)*6+5) = 1111; % Lat
%                 final_data(i,(j-1)*6+6) = 1111; % Long
        end
        end
  %%      
    else 
        final_data(i,(j-1)*6+1) = 1111; % bcch
        final_data(i,(j-1)*6+2) = 1111; % bsic
        final_data(i,(j-1)*6+3) = 1111; % cell ID 
        final_data(i,(j-1)*6+4) = 1111; % RSSI
        final_data(i,(j-1)*6+5) = 1111; % Lat
        final_data(i,(j-1)*6+6) = 1111; % Long
        flg_4 = flg_4+1;
    end
end
%final_data(i,37)= merged(i,27);
end
%%
% Append rxlev_full_serving_cell and timing advance at the end

final_data = [final_data merged(:,32) merged(:,27)];
save('final_data','final_data');

