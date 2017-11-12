% localization : only for a particular sector : here sector 139
% find the distance without removing the shadowing
% other functions used
% deg2utm, dist_from_pathlossindb, circle
clear all
close all

CC = load('abs_dist');
BB = load('aa');
load ci_lat_lon
%load xxx
%load yyy
%load loc_data

%% base station power in dB scale
bs_power = 2.86789556 ; % 60/31 = 1.935483870967742 in W
%bs_power = 17.7815 ; % 60W
%% the conversion table
for ii = 1:64
    quant(ii,1) = ii-1;
    quant(ii,2) = -110.5 +(ii-1);
end

%% load the data and extract required fields
AA = BB.aa;
DD = CC.abs_dist;
%row = 27; %% 26, 27, 32, 35, 64, 77, 86, 91, 123, 133
bs_id_read = [3, 9, 15, 21, 27, 33];
loc_read =[ 5, 6,  11, 12,  17, 18,  23, 24,  29, 30,  35, 36];
power_read =[4,10,16,22,28,34,37];

lat_long_data = AA(:,loc_read);
pow_data = AA(:,power_read); % base station powers
bs_id_data = AA(:,bs_id_read); % base station IDs for the neighbours

%% samthur details
[sam_x, sam_y] = deg2utm(10.5996400000000,77.0146900000000);
sam = [sam_x, sam_y];
sam_power = AA(:,37); % samathur power 
for i = 1:length(AA)
sam_radius(i) = dist_from_pathlossindb(-quant(sam_power(i)+1,2)+30+bs_power); % radius around samathur
end

save('sam_radius','sam_radius');

%% fetch the data for localization
BS_loc = [];
BS_pow = [];
BS_id = [];
dist= [];
for_loc = [];
loc_data = zeros(length(AA),6*3+1,1);

for i = 1:length(AA)
    UI_net_power = 0;
    for k=1:6   
      X = lat_long_data(i,[2*k-1,2*k]);
        if ((X(1) ~=0)&&(X(1)~=1111))
            [xc,yc] = deg2utm(X(1),X(2));
            xx = [xc,yc];
            UI_net_power = UI_net_power + dbm_p(quant(pow_data(i,k)+1,2));
            loc_data(i,[3*(k-1)+1,3*(k-1)+2,3*(k-1)+3]) = [bs_id_data(i,k),dist_from_pathlossindb(-quant(pow_data(i,k)+1,2)+30+bs_power),distance(sam,xx)];
        end
    end
    % to compare cummulative power of 6 neighbours and the power from
    % Samathur BS
    neigh_power(i,1) = UI_net_power;
    S_power(i,1) = dbm_p(quant(sam_power(i)+1,2));
    loc_data(i,19) = UI_net_power + dbm_p(quant(sam_power(i)+1,2));
end

compare_power = [neigh_power S_power loc_data(:,19)];

save('loc_data','loc_data');
%% perform localization
% both the data on sector and timing advance can be used for better
% localization accuracy
% get the set of mid-points for each UI
% vec = [x y]
% dist = sqrt(sum(vec.^2)) % i.e. sqrt(x^2 + y^2)
% dir = atan(y/x)

% shift the origin to samathur BS

for i = 1:length(AA)
    k = 1;
    for j = 1:6
        if (loc_data(i,3*(j-1)+2) ~= 0)
            if (loc_data(i,3*(j-1)+2)+sam_radius(i) > loc_data(i,3*(j-1)+3))
                % means there is overlap between the circles 
                % need to take this reading 
                dis = (loc_data(i,3*(j-1)+2)+sam_radius(i))/2;
                % need to get the direction as well
                if (loc_data(i,3*(j-1)+2) > sam_radius(i))
                    % need to consider distance from the non-samathur BS
                    % get the co-ordinate of any random point at dis in the
                    % direction of samathur BS
                    [cur1,cur2] = deg2utm(AA(i, 6*(j-1)+5),AA(i, 6*(j-1)+6));
                    cur = [cur1-sam(1),cur2-sam(2)];
                    if cur == 0
                        a = sam + sam_radius(i);
                        xxx(i,k) = a(1);
                        yyy(i,k) = a(2);
                    else
                    dir = atan(cur(2)/cur(1));
                    rad = loc_data(i,3*(j-1)+3) - dis;
                    [xxx(i,k) yyy(i,k)] = sph2cart(dir,0,rad);
                    xxx(i,k) = xxx(i,k) + sam(1);
                    yyy(i,k) = yyy(i,k) + sam(2);
                    end
                    % if cells are overlapping on two different sides,
                    % consider the cell with more overlap: 
                    k = k+1;
                else
                   % consider distance from samathur BS 
                   [cur1,cur2] = deg2utm(AA(i, 6*(j-1)+5),AA(i, 6*(j-1)+6));
                    cur = [cur1-sam(1),cur2-sam(2)];
                    if cur == 0
                        a = sam + sam_radius(i);
                        xxx(i,k) = a(1);
                        yyy(i,k) = a(2);
                    else
                    dir = atan(cur(2)/cur(1));
                    rad = dis;
                    [xxx(i,k) yyy(i,k)] = sph2cart(dir,0,rad);
                    xxx(i,k) = xxx(i,k) + sam(1);
                    yyy(i,k) = yyy(i,k) + sam(2);
                    end
                    % if cells are overlapping on two different sides,
                    % consider the cell with more overlap: 
                    k = k+1;
                end
                else
                    rad = sam_radius(i);
                    dir = (2/3)*pi*unifrnd(0,1) + pi/6;
                    xxx(i,k) =  sam_x+ rad*cos(dir);
                    yyy(i,k) =  sam_y+ rad*sin(dir);
                    k = k+1;
            end
        else 
                    %rad = sam_radius(i);
                    %dir = 2*pi*unifrnd(0,1);
                    xxx(i,k) =  0; %sam_x+ rad*cos(dir);
                    yyy(i,k) =  0; %sam_y+ rad*sin(dir);
                    k = k+1;
        end       
    end
end

save('xxx','xxx');
save('yyy','yyy');
final_loc = [xxx(:,1) yyy(:,1) xxx(:,2) yyy(:,2) xxx(:,3) yyy(:,3) xxx(:,4) yyy(:,4) xxx(:,5) yyy(:,5) xxx(:,6) yyy(:,6)];
save('final_loc','final_loc');

%% get the centroid from the mid-points
% [idx,c] = kmeans(xy,1)
for i =1:length(AA)
%     xy = [xxx(i,1),yyy(i,1); xxx(i,2),yyy(i,2); xxx(i,3),yyy(i,3); xxx(i,4),yyy(i,4); xxx(i,5),yyy(i,5); xxx(i,6),yyy(i,6)];
%     [a,b] = kmeans(xy,1);
%     c(i,1) = b(1);
%     c(i,2) = b(2);
    ue_pow(i) = loc_data(i,19);
end

% save('c','c');
save('ue_pow','ue_pow');
%% surface plot 

%surf(c(:,1),c(:,2),ue_pow');
% %%
% scatter(BS_loc(:,1),BS_loc(:,2));
% hold on;
% scatter(sam_x,sam_y,'r','filled');
% for k=1: length(BS_loc)
% circle(BS_loc(k,1),BS_loc(k,2),dist(k));
% end
% hold on;
% axis equal
