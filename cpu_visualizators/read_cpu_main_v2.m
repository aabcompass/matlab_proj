% The Mini-EUSO CPU MAIN file loader

clear all;


%fid = fopen('/mnt/d/EUSO/ISS/04_2019_11_07/Lech/CPU_RUN_MAIN__2019_11_07__05_59_33__1100Cathode2FullPDMonlyself.dat');
fid = fopen('/mnt/d/EUSO/Integrations/2020.09_Hiroko_L2_test/2/CPU_RUN_MAIN__2020_09_10__10_30_19__HVon_DAC_600_BkgLED_2p5V.dat');

cpu_file = fread(fid, inf);
fclose(fid);
magic_A = [hex2dec('01') hex2dec('0A') hex2dec('01') hex2dec('5A') hex2dec('18') hex2dec('80') hex2dec('04') hex2dec('00')];
magic_B = [hex2dec('01') hex2dec('0B') hex2dec('01') hex2dec('5A') hex2dec('18') hex2dec('00') hex2dec('09') hex2dec('00')];
magic_C = [hex2dec('01') hex2dec('0C') hex2dec('01') hex2dec('5A') hex2dec('1C') hex2dec('00') hex2dec('12') hex2dec('00')];
sections_D1 = strfind(cpu_file',magic_A);
sections_D2 = strfind(cpu_file',magic_B);
sections_D3 = strfind(cpu_file',magic_C);
D1_bytes = []; D2_bytes = []; D3_bytes = [];
strange_offset = 2;
n_of_frames_in_packet = 128; % was 128
for i=1:numel(sections_D1)
    D1_bytes = [D1_bytes; uint8(cpu_file(sections_D1(i)+30+strange_offset : sections_D1(i)+30+strange_offset+2304*n_of_frames_in_packet-1))];
    D1_tt(i) = uint8(cpu_file(sections_D1(i)+16));
    D1_ngtu(i) = typecast(uint8(cpu_file(sections_D1(i)+8:sections_D1(i)+11)), 'uint32');
end 
for i=1:numel(sections_D2)
    D2_bytes = [D2_bytes; uint8(cpu_file(sections_D2(i)+30+strange_offset : sections_D2(i)+30+strange_offset+2*2304*n_of_frames_in_packet-1))];
    D2_tt(i) = uint8(cpu_file(sections_D2(i)+16));
    D2_ngtu(i) = typecast(uint8(cpu_file(sections_D2(i)+8:sections_D2(i)+11)), 'uint32');
end 
for i=1:numel(sections_D3)
    D3_bytes = [D3_bytes; uint8(cpu_file(sections_D3(i)+34+strange_offset : sections_D3(i)+34+strange_offset+4*2304*n_of_frames_in_packet-1))];
    D3_tt(i) = uint8(cpu_file(sections_D3(i)+16));
    D3_ngtu(i) = typecast(uint8(cpu_file(sections_D3(i)+8:sections_D3(i)+11)), 'uint32');
end 

D1 = D1_bytes;
D2 = typecast(D2_bytes, 'uint16');
D3 = typecast(D3_bytes, 'uint32');
frame_size=2304;
[size(sections_D1, 2) size(sections_D2, 2) size(sections_D3, 2)]

sprintf('%d ', D1_tt)
sprintf('%d ', D2_tt)
sprintf('%d ', D3_tt)

sprintf('%d ', D1_ngtu)
sprintf('%d ', D2_ngtu)
sprintf('%d ', D3_ngtu)

%% hvps log packet
records = {'TURNON', 'TURN_OFF', 'DACS_LOADED', 'SR_LOADED', 'HVPS_INTR', 'BLOCK_ECUNIT', 'BLOCK_INTR', '', '', '', '', 'HVPS_STATUS', 'OVERBRIGHT'};
magic_HV = [hex2dec('55') hex2dec('AA') hex2dec('55') hex2dec('AA') hex2dec('01') hex2dec('56') hex2dec('01') hex2dec('56')];
sections_HV = strfind(cpu_file',magic_HV);
hv_packet_len_records_u8 = uint8(cpu_file(sections_HV+20:sections_HV+23));
hv_packet_len_records_u32 = typecast(hv_packet_len_records_u8, 'uint32');
hv_packet_1d_u8 = uint8(cpu_file(sections_HV+32:sections_HV+32+4*4*hv_packet_len_records_u32-1));
hv_packet_1d_u32 = typecast(hv_packet_1d_u8, 'uint32');
hv_packet_2d = reshape(hv_packet_1d_u32, [4 hv_packet_len_records_u32]);
for j=1:hv_packet_len_records_u32
    channels_s4 = dec2base(hv_packet_2d(4,j), 4);
    channels = strcat(repmat('0', 1,9-numel(channels_s4)), channels_s4);
    disp(sprintf('%d\t%d\t%s\t%s', (hv_packet_2d(1,j)),  (hv_packet_2d(2,j)),  cell2mat(records(1+(hv_packet_2d(3,j)))), channels));
end;


%% visualization
clear TT;
level = 3

if level == 3
    frames = reshape(D3, [frame_size  numel(D3)/frame_size]);
    TT = D3_tt;
    accumulation = 128*128;
    colorbar_lim = 1;
elseif level == 2
    frames = reshape(D2, [frame_size  numel(D2)/frame_size]);
    TT = D2_tt;
    accumulation = 128;
    colorbar_lim = 2;
elseif level == 1
    frames = reshape(D1, [frame_size  numel(D1)/frame_size]);
    TT = D1_tt;
    accumulation = 1;
    colorbar_lim = 2;
end

        
cw90 = 3;
ccw90 = 1;
cw180 = 2;

for current_frame=1:size(frames, 2)        
    %if TT(current_frame) == 0
    %    continue;
    %end 
    sprintf('%d/%d', floor(current_frame/n_of_frames_in_packet), mod(current_frame,n_of_frames_in_packet))
    %pause(0.2)
    pic = double(frames(:, current_frame)')/accumulation;
    dimx_ecasic = 8;
    dimy_ecasic = 48;
    n_ecasic=6;
    ecasics_2d = fliplr(reshape(pic', [dimx_ecasic dimy_ecasic n_ecasic])); %

    pdm_2d = [ecasics_2d(:,:,1)' ecasics_2d(:,:,2)' ecasics_2d(:,:,3)' ecasics_2d(:,:,4)' ecasics_2d(:,:,5)' ecasics_2d(:,:,6)'];
    %figure
    %imagesc(pdm_2d, clims);
    %colorbar
    pause(0.01)   %0.1sec
    % rotation
    pdm_2d_rot = pdm_2d;
    for i=0:5
        for j=0:5
            if((rem(i,2)==0) && (rem(j,2)==0))
               pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), cw90);
            end
            if((rem(i,2)==0) && (rem(j,2)==1))
               pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), cw180);
            end
            if((rem(i,2)==1) && (rem(j,2)==0))
               pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), 0);
            end
            if((rem(i,2)==1) && (rem(j,2)==1))
               pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = fliplr(rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), 0));
            end
       end
    end

    %figure
    clims = [-2 colorbar_lim];
    imagesc((pdm_2d_rot), clims);
    imagesc(pdm_2d_rot);
    colorbar
end
