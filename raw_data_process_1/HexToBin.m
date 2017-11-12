% Function to perform the required data conversion : Hex to Bin

function [a2,a3] = HexToBin(data2)
a1 = hex2dec(data2);  % Example : F4 will get converted to 244
dum = dec2hex(a1,2); % 255 will get converted to 'F4', now F and 4 can be accessed seperately
a2 = dec2bin(hex2dec(dum(:,1)),4);
a3 = dec2bin(hex2dec(dum(:,2)),4);
end