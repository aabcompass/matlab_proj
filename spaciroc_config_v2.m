ip_addr='192.168.7.10';
tcp_port_ctrl=50000;
tcp_port_spaciroc_ctrl=50001;
% t = tcpip(ip_addr,tcp_port_ctrl);
% fopen(t);
% fwrite(t,'SPACIROC_RELOAD;');
% fclose(t);

KI_value = bin2dec('010010000000');
DAC4_value = 00;
DAC3_value = bin2dec('0000000000');
DAC2_value = 100; %bin2dec('0010000000');
DAC1_value = 0;
GAIN_value = bin2dec('1000001000');


slv_reg(0+1) = bin2dec('0000 1111 0000 11 10 0101010101010101');
slv_reg(1+1) = 1023;
slv_reg(2+1) = KI_value * 65536 + KI_value;
slv_reg(3+1) = KI_value * 65536 + KI_value;
slv_reg(4+1) = KI_value * 65536 + KI_value;
slv_reg(5+1) = KI_value * 65536 + KI_value;
slv_reg(6+1) = bin2dec('1111 1111 1111 1111 1111 1111 1111 1111');
slv_reg(7+1) = bin2dec('1111 1111 1111 1111 1111 1111 1111 1111');
slv_reg(8+1) = bin2dec('1 1 0 1 0 11111 00 1101001 1');
slv_reg(9+1) = DAC4_value + DAC3_value*65536;
slv_reg(10+1) = DAC2_value + DAC1_value*65536;
for i = 11:42
    slv_reg(i+1) = GAIN_value*65536 + GAIN_value;
end

slv_reg_uint32 = uint32(slv_reg);

% for i=1:43
%     slv_reg_uint32(i) = 0;
% end

%t2 = tcpip(ip_addr,tcp_port_spaciroc_ctrl);
%fopen(t2);
%fwrite(t2, slv_reg_uint32, 'uint32');
%fclose(t2);
%'Ports closed'

t2 = tcp(ip_addr,tcp_port_spaciroc_ctrl);
fopen(t2);
fwrite(t2, slv_reg_uint32, 'uint32');
fclose(t2);
'Ports closed'


fileID = fopen('spaciroc.bin','w');
fwrite(fileID,slv_reg_uint32,'integer*4');
fclose(fileID);


%%














