% get the pairs

% Samathur_1/2/3 kaise find out karun ?
% Ye hai data me, it is quiet straight forward 

load cell_bcch
load cell_bsic
load cell_name
load final_bcch_new
sz = size(cell_bcch);

merg_bcch = final_bcch_new; %[66 67 68 69 70 71 77 78];

%% code for making all the pairs 
k = 1;
d = 10000;
for i = 1:8
   for j = 1:sz(1,1)
       if (cell_bcch(j) == merg_bcch(i))
           clear {b,c};
           my_map(k,1) = cell_bcch(j);
           my_map(k,2) = cell_bsic(j);
           b = cell_name(j);
           my_map(k,3) = str2num(strcat(mat2str(cell2mat(textscan(b{1,1},'%d'))),mat2str(cell2mat(textscan(flip(b{1,1}),'%d'))))); 
           k = k+1;
       end
   end
end

save('my_map','my_map');

