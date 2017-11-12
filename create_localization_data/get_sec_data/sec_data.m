% segregate the data based on sectors 
clc
clear all
close all

%% load data
a = load('merged.csv');
b = a;

%% sector data
sec_139_idx = b(:,9) == 139;
sec_139 = b(sec_139_idx,:);

sec_140_idx = b(:,9) == 140;
sec_140 = b(sec_140_idx,:);

sec_141_idx = b(:,9) == 141;
sec_141 = b(sec_141_idx,:);

save('sec_139','sec_139');
save('sec_140','sec_140');
save('sec_141','sec_141');
