% localization
% find the distance without removing the shadowing
% other functions used
% deg2utm, dist_from_pathlossindb, circle
clear all
close all

CC = load('abs_dist');
BB = load('final_data');
load ci_lat_lon
load xxx
load yyy
load loc_data
load final_data

aaa = 25 ; %% 26, 27, 32, 35, 64, 77, 86, 91, 123, 133 , 143, 144
%% the conversion table
for ii = 1:64
    quant(ii,1) = ii-1;
    quant(ii,2) = -110.5 +(ii-1);
end

%% load the data and extract required fields
AA = BB.final_data;
DD = CC.abs_dist;
%row = 27; %% 26, 27, 32, 35, 64, 77, 86, 91, 123, 133
bs_id_read= [3, 9, 15, 21, 27, 33];
loc_read=[ 5, 6,  11, 12,  17, 18,  23, 24,  29, 30,  35, 36];
power_read=[4,10,16,22,28,34,37];

lat_long_data = AA(:,loc_read);
pow_data = AA(:,power_read); % base station powers
bs_id_data = AA(:,bs_id_read); % base station IDs for the neighbours

%% samthur details
[sam_x, sam_y] = deg2utm(10.5996400000000,77.0146900000000);
sam = [sam_x, sam_y];
sam_power = AA(:,37); % samathur power 
for i = aaa %length(AA)
sam_radius(i) = dist_from_pathlossindb(-quant(sam_power(i)+1,2)+30+17.7815); % radius around samathur
end

% %% fetch the data for localization
% BS_loc = [];
% BS_pow = [];
% BS_id = [];
% dist= [];
% for_loc = [];
% loc_data = zeros(length(AA),6*3+1,1);
% 
% for i = 4:length(AA)
%     UI_net_power = 0;
%     for k=1:6   
%       X = lat_long_data(i,[2*k-1,2*k]);
%         if ((X(1) ~=0)&&(X(1)~=1111))
%             [xc,yc] = deg2utm(X(1),X(2));
%             xx = [xc,yc];
%             UI_net_power = UI_net_power + dbm_p(quant(pow_data(i,k)+1,2));
%             loc_data(i,[3*(k-1)+1,3*(k-1)+2,3*(k-1)+3]) = [bs_id_data(i,k),dist_from_pathlossindb(-quant(pow_data(i,k)+1,2)+30+17.7815),distance(sam,xx)];
%         end
%     end
%     loc_data(i,19) = UI_net_power;
% end

%% perform localization
% both the data on sector and timing advance can be used for better
% localization accuracy
% get the set of mid-points for each UI
% vec = [x y]
% dist = sqrt(sum(vec.^2)) % i.e. sqrt(x^2 + y^2)
% dir = atan(y/x)

% shift the origin to samathur BS

for i = aaa%:length(AA)
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
                    dir = 2*pi*unifrnd(0,1);
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


%% get the centroid from the mid-points
% [idx,c] = kmeans(xy,1)
% xy =[];
% i = aaa;
% for j = 1:k
%     xy =[xy xxx(i,j) yyy(i,j)];
% end
for i = aaa %:length(AA)
    %xy = [xxx(i,1),yyy(i,1); xxx(i,2),yyy(i,2); xxx(i,3),yyy(i,3)] %; xxx(i,4),yyy(i,4); xxx(i,5),yyy(i,5)]; % xxx(i,6),yyy(i,6)];
    xy =[];
    for j = 1:6
        if xxx(i,j) ~= 0
            xy = [xy; xxx(i,j),yyy(i,j)];
        end
    end
    
    if(isempty(xy) == 1)
                    rad = sam_radius(i);
                    dir = 2*pi*unifrnd(0,1);
                    mmm =  sam_x+ rad*cos(dir);
                    nnn =  sam_y+ rad*sin(dir);
                    xy = [mmm,nnn];
    end
    
    xy_sz = size(xy);
    if xy_sz(1,1) == 1
       b = xy;
    else
       [a,b] = kmeans(xy,1);
    end
    c(i,1) = b(1);
    c(i,2) = b(2);
    ue_pow(i) = loc_data(i,19);
end

%% surface plot 

%surf(c(:,1),c(:,2),ue_pow');
% %%
scatter(c(i,1),c(i,2),'b','filled');
hold on;
scatter(sam_x,sam_y,'r','filled');
axis equal
hold on

% modified
% find the distance without removing the shadowing
% other functions used
% deg2utm, dist_from_pathlossindb, circle

%% the conversion table
for ii = 1:64
    quant(ii,1) = ii-1;
    quant(ii,2) = -110.5 +(ii-1);
end

[sam_x, sam_y] = deg2utm(10.5996400000000,77.0146900000000);
sam = [sam_x, sam_y];

BB= load('final_data');
AA = BB.final_data;
row = aaa;
to_read=[ 5, 6,  11, 12,  17, 18,  23, 24,  29, 30,  35, 36];
power_read=[4,10,16,22,28,34];

lat_long_data = AA(row,to_read);
pow_data = AA(row,power_read);
BS_loc =[];
BS_pow =[];
BS_dist =[];
dist=[];
for k=1:6
    X=lat_long_data([2*k-1,2*k]);
    if ((X(1) ~=0)&&(X(1)~=1111))
       [xc,yc] = deg2utm(X(1),X(2));
       x_cur = [xc,yc];
     BS_loc = [BS_loc; xc,yc ];     
     BS_pow = [BS_pow, pow_data(k)]; 
     BS_dist = [BS_dist, distance(sam,x_cur)];
     dist=[dist, dist_from_pathlossindb(-quant(pow_data(k)+1,2)+30+17.7815)];
    end
end

sam_r = dist_from_pathlossindb(-quant(final_data(aaa,37),2)+30+17.7815);

scatter(BS_loc(:,1),BS_loc(:,2));
hold on;
scatter(sam_x,sam_y,'r','filled');
circle(sam_x,sam_y,sam_r);
for k=1: length(BS_loc)
circle(BS_loc(k,1),BS_loc(k,2),dist(k));
end
hold on;
axis equal

