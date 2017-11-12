% remove all rssi with rxlev '0' and '1'
clc
clear all
close all

bb = load('final_data');
aa = bb.final_data;

nb_rss = [4,10,16,22,28,34];

for i =1:length(aa)
    for j = nb_rss
        if (aa(i,j) == 0 ||aa(i,j) == 1 ||aa(i,j)== 1111)
            aa(i,[j-3 j-2 j-1 j j+1 j+2]) = 0;
        end
    end
end

% remove all co-sectors of samathur

nb_co_sec = [3,9,15,21,27,33];

for i =1:length(aa)
    for j = nb_co_sec
        if (aa(i,j) == 51201 ||aa(i,j) == 51202 ||aa(i,j)== 51203)
            aa(i,[j-2 j-1 j j+1 j+2 j+3]) = 0;
        end
    end
end

% remove all non-neighbours
% create the neighbour list first


%% THIS DOES NOT SEEM TO WORK
% nb_valid = [51192,51193,51211,51341,51581,51592,51611,51613,51623,51712,51713,51851,51853,52641];
% 
% for i = 1:length(aa)
%     for j = nb_co_sec
%         if (aa(i,j)~=51192 ||aa(i,j)~=51193 ||aa(i,j)~=51211 ||aa(i,j)~=51341 ||aa(i,j)~=51581 ...
%             ||aa(i,j)~=51592 ||aa(i,j)~=51611 ||aa(i,j)~=51613 ||aa(i,j)~=51623 ||aa(i,j)~=51712 ...
%             ||aa(i,j)~=51713 ||aa(i,j)~=51851 ||aa(i,j)~=51853 ||aa(i,j)~=52641)
%             aa(i,[j-2 j-1 j j+1 j+2 j+3]) = 0;
%         end
%     end
% end

save('aa','aa');














