%% Clear all, close all
clc
clear all
close all

%% first i need to have the conversion table loaded
bcch_ncell = [0 1 2 3 4 5 6 7 8 9 10; 66 67 68 69 70 71 73 76 77 78 81]';

%% find unique neighbours
aa = load('sec_139');
a = aa.sec_139;
sz = size(a);
bcch = a(1:sz(1,1),[48 51 54 57 60 63]);
bsic = a(1:sz(1,1),[49 52 55 58 61 64]);

%% find actual bcch frequencies corresponding to bcch values obtained above

for i = 1:6
    for k = 1:sz(1,1)
        flag = 0;
for j = 1:11   
    if (bcch(k,i) == bcch_ncell(j,1))
        bcch_new(k,i) = bcch_ncell(j,2);
        flag = 1;
    end
end
if (flag == 0)
        bcch_new(k,i) = 1111;
end
    end
end
    
save('bcch','bcch')
save('bcch_new','bcch_new')
save('bsic')

unique_bcch_new = unique(bcch_new);
size_unique_bcch_new = size(unique_bcch_new);
final_bcch_new = unique_bcch_new(1:size_unique_bcch_new(1,1),:);
save('final_bcch_new','final_bcch_new');
% % Unique neighbour mapping
% 
% for j = 1:6
%     for i = 1:sz(1,1)
%         
%     end
% end
