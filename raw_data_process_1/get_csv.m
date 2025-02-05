function y = get_csv(fn)

for iii = 1:fn

clc
clearvars -except iii
close all    
    
fname = sprintf ( 'f%i_new.txt', iii );
csv_name = sprintf ( '%i.csv', iii );
    
s1 = ' %*s'; 
j = 0;
% All the 76 measurement trace fields
s = cell(76,1);
% cell ID, site ID, TRX No. information
s2 = cell(4,1);
% time of measurement
s3 = cell(4,1);

%% Generate strings corresponding to different fields
% Fetch TRX Numbers first
% A sequence of %s is used to leave the first 17 bytes(from the starting of each instance) because 
% numbers corresponding to different transmitters occur at these locations

% Different power values
% assign indices for extracting bit values
% Again, leave respective number of bits and read 59th byte, 60th byte, and so on
for i = 1:76
    s{i} = [repmat(s1,1,(17+j)) ' %s %*[^\n]'];
    j = j+1;
end

j = 0;
for k = 1:3
    s2{k} = [repmat(s1,1,(12+j)) ' %s %*[^\n]'];
    j = j+1;
end

j = 0;
for k = 1:4
    s3{k} = [repmat(s1,1,(j)) ' %s %*[^\n]'];
    j = j+1;
end

%% In the folowing code the transmitter values and power values are read seperately 
%  because transmitter value occurs at 18th byte and 59th byte from MEAS
%  file occurs at 77th position from the starting of a particular instance
%  in the trace file
%  Similarly, 60th byte occurs at 78th position and so on
%% Open the text file and read power values from the respective bytes
for i=1:76
    f = fopen(fname);
    fseek(f, 0 , 'bof');  % move the file pointer to the beggining of the file 
    data(:,i) = textscan(f, s{i,1}); %,'Content',1);
    f = fclose(f);
end

for i=1:3
    f = fopen(fname);
    fseek(f, 0 , 'bof');  % move the file pointer to the beggining of the file 
    loc_data(:,i) = textscan(f, s2{i,1}); %,'Content',1);
    f = fclose(f);
end

for i=1:4
    f = fopen(fname);
    fseek(f, 0 , 'bof');  % move the file pointer to the beggining of the file 
    time_data(:,i) = textscan(f, s3{i,1}); %,'Content',1);
    f = fclose(f);
end

%% Get date and time data
%serial_number = str2num(cell2mat(time_data{1,1}));
date = time_data{1,2};
time = time_data{1,3};
millisecond = str2num(cell2mat(time_data{1,4}));

sn = cell2mat(date);
size1 = size(sn);
for i = 1:size1(1,1)
    yy(i) = str2num(sn(i,1:4));
    mm(i) = str2num(sn(i,6:7));
    dd(i) = str2num(sn(i,9:10));
end

sn1 = cell2mat(time);
size2 = size(sn);
for i = 1:size2(1,1)
    hour(i) = str2num(sn1(i,1:2));
    minutes(i) = str2num(sn1(i,4:5));
    seconds(i) = str2num(sn1(i,7:8));
end

%% Get file content
for i = 1:76
[a2{i},a3{i}] = HexToBin(data{1,i}) ;
end

% store the required bits in respective variables
% Site ID
a11 = loc_data{1,1};
a22 = cell2mat(a11);
a33 = a22(:,1:3);


site_id = str2num(a33);

% Cell ID
b11 = loc_data{1,3};
b22 = cell2mat(b11);
b33 = b22(:,1:3);
cell_id = str2num(b33);

% Transmitter values
trx_values = str2double(data{1,1}); % bin2dec([a2{1,1},a3{1,1}]);

asd = horzcat(site_id,cell_id,trx_values);

% Uplink Sender CPU ID
ul_sender_cpu_id = bin2dec([a2{1,2},a3{1,2},a2{1,3},a3{1,3},a2{1,4},a3{1,4},a2{1,5},a3{1,5}]);

% Uplink Sender PID
ul_sender_pid = bin2dec([a2{1,6},a3{1,6},a2{1,7},a3{1,7},a2{1,8},a3{1,8},a2{1,9},a3{1,9}]);

% Uplink Receiver CPU
ul_receiver_cpu_id = bin2dec([a2{1,10},a3{1,10},a2{1,11},a3{1,11},a2{1,12},a3{1,12},a2{1,13},a3{1,13}]);

% Uplink Receiver PID
ul_receiver_pid = bin2dec([a2{1,14},a3{1,14},a2{1,15},a3{1,15},a2{1,16},a3{1,16},a2{1,17},a3{1,17}]);

% Uplink Length
ul_length = bin2dec([a2{1,18},a3{1,18},a2{1,19},a3{1,19},a2{1,20},a3{1,20},a2{1,21},a3{1,21}]);

% Message Type
msg_type = bin2dec([a2{1,22},a3{1,22},a2{1,23},a3{1,23}]);

% Handle
handle = bin2dec([a2{1,24},a3{1,24},a2{1,25},a3{1,25}]);

% CRDLC CCB
crdlc_ccb = bin2dec([a2{1,26},a3{1,26},a2{1,27},a3{1,27}]);

% MTLS CCB
mtls_ccb = bin2dec([a2{1,28},a3{1,28},a2{1,29},a3{1,29}]);

% AUC Reserved
auc_reserved = bin2dec([a2{1,30},a3{1,30},a2{1,31},a3{1,31}]);

% Data length
data_length = bin2dec([a2{1,33},a3{1,33}]);

% Channel type
clear {c1,c2}
c1 = a2{1,37}; c2 = a3{1,37};
channel_type = bin2dec([c1(:,1:4),c2(:,1)]);

% Time slot
time_slot = bin2dec([c2(:,2:4)]);
unique(time_slot)

% Measurement result number
rxlev_ncell2 = bin2dec([a2{1,39},a3{1,39}]);

% Receiver Level Full Up
clear {c1,c2}
c1 = a2{1,42}; c2 = a3{1,42};
rxlev_full_up = bin2dec([c1(:,3:4),c2(:,1:4)]);

% Receiver level sub Up
clear {c1,c2}
c1 = a2{1,43}; c2 = a3{1,43};
rxqual_full_up = bin2dec([c1(:,3:4),c2(:,1:4)]);

% Receiver Qual full Up ber
clear {c1,c2}
c1 = a2{1,44}; c2 = a3{1,44};
rxqual_sub_up = bin2dec([c1(:,3:4),c2(:,1)]);

% Receiver Qual sub Up ber
rxqual_sub_up = bin2dec(c2(:,2:4));

% RQI Value
% rqi_value = bin2dec([a2{1,46},a3{1,46}]);

% TLV type RX Level
% Main Level
tlv_type_rx_main_level = bin2dec([a2{1,47},a3{1,47}]);
% Sub Level
tlv_type_rx_sub_level = bin2dec([a2{1,48},a3{1,48}]);

% Base Station Power
clear {c1,c2}
c1 = a2{1,50}; c2 = a3{1,50};
% Reserved 
bs_reserved = bin2dec(c1(:,1:3));
% Power Level
bs_power_level = bin2dec([c1(:,4),c2(:,1:4)]);

% Layer "1" Information
% Mobile station power level
clear {c1,c2}
c1 = a2{1,52}; c2 = a3{1,52};
ms_power_level = bin2dec([c1(:,1:4),c2(:,1)]);
% Reserved
ms_reserved = bin2dec(c2(:,2:4));

% Actual Timing Advance 
clear {c1,c2}
c1 = a2{1,53}; c2 = a3{1,53};
actual_timing_adv = bin2dec([c1(:,1:4),c2(:,1:2)]);
% Reserved
timing_reserved = bin2dec(c2(:,3:4));

% Layer "3" Information
% Enhanced MEAS msg type
enhanced_meas_msg_type = bin2dec([a2{1,57},a3{1,57}]);

% Measurement report
% BA used
clear {c1,c2}
c1 = a2{1,59}; c2 = a3{1,59}; 
ba_used = bin2dec(c1(:,1));
% DTX used
dtx_used = bin2dec(c1(:,2));

% Receiver Level Full Serving Cell
rx_lev_full_serving_cell = bin2dec([c1(:,3:4),c2(:,1:4)]);

asd1 = horzcat(asd,time_slot); %rx_lev_full_serving_cell
un_asd = unique(asd1,'rows');
size(un_asd)

% BA used 3G
clear {c1,c2}
c1 = a2{1,60}; c2 = a3{1,60}; 
ba_used_3g = bin2dec(c1(:,1));
% MEAS valid
meas_valid = bin2dec(c1(:,2));

% Receiver Level sub Serving Cell
rx_lev_sub_serving_cell = bin2dec([c1(:,3:4),c2(:,1:4)]);

% Spare
clear {c1,c2}
c1 = a2{1,61}; c2 = a3{1,61}; 
spare = bin2dec(c1(:,1));
% Receiver Qual Full Serving cell
rx_qual_full_serving_cell = bin2dec(c1(:,2));
% Receiver Qual Sub Serving cell
rx_qual_sub_serving_cell = bin2dec(c2(:,1:3));

% No n cell : Number of neighbour cells (I SUPPOSE !!!!!)
%% N CELL 1
clear {c3,c4}
c3 = a2{1,62}; c4 = a3{1,62}; 
no_n_cell = bin2dec([c2(:,4),c3(:,1:2)]);
% Receiver level ncell = 1
rxlev_ncell_1 = bin2dec([c3(:,3:4),c4(:,1:4)]);

% bcch frequency ncell-1
clear {c1,c2}
c1 = a2{1,63}; c2 = a3{1,63}; 
bcch_freq_ncell_1 = bin2dec([c1(:,1:4),c2(:,1)]);
% bsic ncell-1
clear {c3,c4}
c3 = a2{1,64}; c4 = a3{1,64}; 
bsic_ncell_1 = bin2dec([c2(:,2:4),c3(:,1:3)]);

%% N CELL 2
% Rx level ncell = 2
clear {c1,c2}
c1 = a2{1,65}; c2 = a3{1,65}; 
rxlev_ncell_2 = bin2dec([c3(:,1),c4(:,1:4),c1(:,1)]);
% bcch frequency ncell-1
bcch_freq_ncell_2 = bin2dec([c1(:,2:4),c2(:,1:2)]);

% bsic ncell-2
clear {c3,c4}
c3 = a2{1,66}; c4 = a3{1,66}; 
bsic_ncell_2 = bin2dec([c2(:,3:4),c3(:,1:4)]);

%% N CELL 3
% Rx level ncell = 3
clear {c1,c2}
c1 = a2{1,67}; c2 = a3{1,67}; 
rxlev_ncell_3 = bin2dec([c4(:,1:4),c1(:,1:2)]);
% bcch frequency ncell-3
bcch_freq_ncell_3 = bin2dec([c1(:,3:4),c2(:,1:3)]);

% bsic ncell-3
clear {c3,c4}
c3 = a2{1,68}; c4 = a3{1,68}; 
bsic_ncell_3 = bin2dec([c2(:,4),c3(:,1:4),c4(:,1)]);

%% N CELL 4
% Rx level ncell = 4
clear {c1,c2}
c1 = a2{1,69}; c2 = a3{1,69}; 
rxlev_ncell_4 = bin2dec([c4(:,2:4),c1(:,1:3)]);
% bcch frequency ncell-4
bcch_freq_ncell_4 = bin2dec([c1(:,4),c2(:,1:4)]);

% bsic ncell-4
clear {c3,c4}
c3 = a2{1,70}; c4 = a3{1,70}; 
bsic_ncell_4 = bin2dec([c3(:,1:4),c4(:,1:2)]);

%% N CELL 5
% Rx level ncell = 5
clear {c1,c2}
c1 = a2{1,71}; c2 = a3{1,71}; 
rxlev_ncell_5 = bin2dec([c4(:,3:4),c1(:,1:4)]);
% bcch frequency ncell-5
clear {c3,c4}
c3 = a2{1,72}; c4 = a3{1,72}; 
bcch_freq_ncell_5 = bin2dec([c2(:,1:4),c3(:,1)]);

% bsic ncell-5
bsic_ncell_5 = bin2dec([c3(:,2:4),c4(:,1:3)]);

%% N CELL 6
% Rx level ncell = 6
clear {c1,c2}
c1 = a2{1,73}; c2 = a3{1,73}; 
rxlev_ncell_6 = bin2dec([c4(:,4),c1(:,1:4),c2(:,1)]);
% bcch frequency ncell-6
clear {c3,c4}
c3 = a2{1,74}; c4 = a3{1,74}; 
bcch_freq_ncell_6 = bin2dec([c2(:,2:4),c3(:,1:2)]);

% bsic ncell-6
bsic_ncell_6 = bin2dec([c3(:,3:4),c4(:,1:4)]);

%% concatenate individual vectors 
%millisecond
to_write_data = [dd' mm' yy' hour' minutes' seconds' millisecond... 
site_id  cell_id  trx_values ul_sender_cpu_id ul_sender_pid ul_receiver_cpu_id ...
ul_receiver_pid ul_length msg_type handle crdlc_ccb mtls_ccb auc_reserved data_length channel_type ...
time_slot rxlev_ncell2 rxlev_full_up rxqual_full_up rxqual_sub_up tlv_type_rx_main_level ...
tlv_type_rx_sub_level bs_reserved bs_power_level ms_power_level ms_reserved actual_timing_adv ...
timing_reserved enhanced_meas_msg_type ba_used dtx_used rx_lev_full_serving_cell ...
ba_used_3g meas_valid rx_lev_sub_serving_cell spare rx_qual_full_serving_cell ...
rx_qual_sub_serving_cell no_n_cell rxlev_ncell_1 bcch_freq_ncell_1 bsic_ncell_1 rxlev_ncell_2 ...
bcch_freq_ncell_2 bsic_ncell_2 rxlev_ncell_3 bcch_freq_ncell_3 bsic_ncell_3 rxlev_ncell_4 ...
bcch_freq_ncell_4 bsic_ncell_4 rxlev_ncell_5 bcch_freq_ncell_5 bsic_ncell_5 ...
rxlev_ncell_6 bcch_freq_ncell_6 bsic_ncell_6];

to_write = to_write_data;

% fileID = fopen('my_data.csv','w');
% s11 = '%d ';
% formatSpec = [repmat(s11,1,58) '\n'];
% [nrows,ncols] = size(to_write);
% for row = 1:nrows
%     fprintf(fileID,formatSpec,to_write(row,:));
% end
% fclose(fileID);

%fileID = fopen('dummy.csv','w');
%fprintf(fileID, to_write);
csvwrite(csv_name,to_write);

end
y = 1;
end
