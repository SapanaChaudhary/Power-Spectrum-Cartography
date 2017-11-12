load xxx
load yyy
load sam_radius
load loc_data
load final_data %%%%%%%%%%%%%%%%%%%%%%%%  CHANGE

timing_adv = final_data(:,38);

% k =1;
% for i =1:length(xxx)
%     for j = 1:6
%         if xxx(i,j) ~= 0
%             fss(i,:) = xxx(i,:);
%             fsd(k,:) = yyy(i,:);
%             k = k+1;
%         end
% end
% 
% save('fss','fss');
% save('fsd','fsd');

%%
for i =1:length(xxx)
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
        
    %xy = [fss(i,1),fsd(i,1); fss(i,2),fsd(i,2); fss(i,3),fsd(i,3); fss(i,4),fsd(i,4); fss(i,5),fsd(i,5); fss(i,6),fsd(i,6)];
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

ue_p = ue_pow';

% for i = 1:length(fss)
%     if ue_
%     end
% end

% %add the timing advance information here
% for i = 1:length(xxx)
% if distance([c(i,1) c(i,2)],sam) > timing_adv(i)*550
% 	%localize UE at timing_adv(i)*550 in the correct direction
%     dir = atan(c(i,2)/c(i,1));
%     rad = timing_adv(i)*550;
%     [c(i,1) c(i,2)] = sph2cart(dir,0,rad);
% 	%stick to the original UE distance
% end
% end

fin = [c ue_p];
save('fin','fin')
