% The Mini-EUSO CPU MAIN file loader

% typedef struct
% {
% 	uint32_t n_gtu;
% 	uint32_t unix_time;
% } TimeStamp_dual;

% typedef struct
% {
% 	// Unix timestamp
% 	TimeStamp_dual ts;
% 	// Flags
% 	uint32_t trig_type;
% 	// Cathode status
% 	uint8_t cathode_status[12];
% 	// HVPS status
% 	uint32_t hv_status;
% 	// double integrated data
% 	uint32_t int32_data[N_OF_FRAMES_L3_V0][N_OF_PIXEL_PER_PDM];
% } DATA_TYPE_SCI_L3_V2;
% 
% typedef struct
% {
% 	ZynqBoardHeader zbh;
% 	DATA_TYPE_SCI_L3_V2 payload;
% } Z_DATA_TYPE_SCI_L3_V2;
% 
% typedef struct
% {
% 	// Unix timestamp
% 	TimeStamp_dual ts;
% 	// Flags
% 	uint32_t trig_type;
% 	// Cathode status
% 	uint8_t cathode_status[12];
% 	// intergrated data
% 	uint16_t int16_data[N_OF_FRAMES_L2_V0][N_OF_PIXEL_PER_PDM];
% } DATA_TYPE_SCI_L2_V2;
% 
% typedef struct
% {
% 	ZynqBoardHeader zbh;
% 	DATA_TYPE_SCI_L2_V2 payload;
% } Z_DATA_TYPE_SCI_L2_V2;
% 
% typedef struct
% {
% 	// Unix timestamp
% 	TimeStamp_dual ts;
% 	// Flags
% 	uint32_t trig_type;
% 	// Cathode status
% 	uint8_t cathode_status[12];
% 	// raw data (2.5 us GTU)
% 	uint8_t raw_data [N_OF_FRAMES_L1_V0][N_OF_PIXEL_PER_PDM];
% } DATA_TYPE_SCI_L1_V2;
% 

% typedef struct
% {
% 	uint32_t header; // 'Z'(31:24) | instrument_id(23:16) | data_type(15:8) | packet_ver(7:0)
% 	uint32_t payload_size;
% } ZynqBoardHeader; //

% typedef struct
% {
% 	ZynqBoardHeader zbh;
% 	DATA_TYPE_SCI_L1_V2 payload;
% } Z_DATA_TYPE_SCI_L1_V2;

% typedef struct
% {
%   uint8_t N1; /* 1 byte */
%   uint8_t N2; /* 1 byte */
%   std::vector<Z_DATA_TYPE_SCI_L1_V2> level1_data; /* 294944 * N1 bytes */
%   std::vector<Z_DATA_TYPE_SCI_L2_V2> level2_data; /* 589856 * N2 bytes */
%   Z_DATA_TYPE_SCI_L3_V2 level3_data; /* 1179684 bytes */
% } ZYNQ_PACKET;

% typedef struct
% {
%   CpuPktHeader cpu_packet_header; /* 16 bytes */
%   CpuTimeStamp cpu_time; /* 4 bytes */
%   HK_PACKET hk_packet; /* 296 bytes */
%   ZYNQ_PACKET zynq_packet; /* variable size */
% } CPU_PACKET;

%#define RUN_SIZE 25


% typedef struct
% {
%   CpuFileHeader cpu_file_header; /* 12 bytes */
%   CPU_PACKET cpu_run_payload[RUN_SIZE]; /* variable size */
%   CpuFileTrailer cpu_file_trailer; /* 12 bytes */
% } CPU_FILE;

clear all;

fid = fopen('/mnt/d/EUSO/ISS/04_2019_11_07/Lech/CPU_RUN_MAIN__2019_11_07__05_59_33__1100Cathode2FullPDMonlyself.dat');
%fid = fopen('/mnt/d/EUSO/ISS/01_2019_10_08/CPU_RUN_MAIN__2019_10_07__18_48_34__1100Cathode2OnlyEC7onlyself.dat');
%fid = fopen('/mnt/d/EUSO/ISS/02_2019_10_20/CPU_RUN_MAIN__2019_10_19__19_04_39__1000Cathode2FullPDMonlyself.dat');
%fid = fopen('/mnt/d/EUSO/ISS/03_2019_10_25/UV_session3/CPU_RUN_MAIN__2019_10_25__20_56_20__1100Cathode2FullPDMonlyself.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2019.05/CPU_RUN_MAIN__2019_06_08__17_43_18__trig_3750_cath2_nolight.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2019.01_vibrations/CPU_RUN_MAIN__2016_01_22__18_01_02__MAIN_3_PACKETS_BEFORE_VIBRATION_19_02_2019.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.8.1/20March2!/CPU_RUN_MAIN__2018_03_20__14_06_04__Torino_lab_run8_led2p7Vpp_pw1ms_1Hz_extTrigPw100mus_external_dv3950_dac500.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.8.1/20March2!/CPU_RUN_MAIN__2018_03_20__13_27_17__Torino_lab_run7_led2p7Vpp_pw1ms_1Hz_extTrigPw100musOff_self_dv3950_dac500.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.8.1/20March2!/CPU_RUN_MAIN__2018_03_20__13_16_09__Torino_lab_run6_led2p7Vpp_pw50mus_1Hz_extTrigPw100musOff_self_dv3950_dac500.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.8.1/19March/CPU_RUN_MAIN__2018_03_19__17_50_27__Torino_lab_run8_led2p75Vpp_pw1ms_10Hz_external_dv3950_dac500.dat');% no shifting
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.2/CPU_RUN_MAIN__2018_03_05__09_07_09__per_bgl.dat');% no shifting
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.2/CPU_RUN_MAIN__2018_03_05__09_06_22__per_bgl.dat');% no shifting
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.2/CPU_RUN_MAIN__2018_03_05__10_56_04__per_bgl_led_w50mus_p1ms_2.45V_moved_vicecovered.dat');%shifting
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.2/CPU_RUN_MAIN__2018_03_05__10_18_58__per_bgl_led_w1ms_p100ms_2.45V_moved_vicecovered.dat');%shifting
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.2/CPU_RUN_MAIN__2018_03_05__10_11_00__per_bgl_led_w1ms_p100ms_2.45V_moved.dat'); %shifting
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.2/CPU_RUN_MAIN__2018_03_05__10_07_09__per_bgl_led_w40ms_p100ms_2.45V_moved.dat');%shifting
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.2/CPU_RUN_MAIN__2018_03_05__10_00_51__per_bgl_led_w40ms_p100ms_2.45V.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.2/CPU_RUN_MAIN__2018_03_05__09_52_36__per_bgl_led_w1ms_p100ms_2.45V.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.1/CPU_RUN_MAIN__2018_03_04__13_25_50__bgl_minieusomoved.dat'); %self 
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.1/CPU_RUN_MAIN__2018_03_04__13_23_32__bgl_minieusomoved.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.0/CPU_RUN_MAIN__2018_03_03__17_22_25__self_tank_rot.dat'); %self 
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.0/CPU_RUN_MAIN__2018_03_03__17_46_15__per_debris_moved_tankbackandforth.dat'); %self 
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.0/CPU_RUN_MAIN__2018_03_03__17_50_05__per_debris_moved_tankbackandforth.dat'); %self 
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.0/CPU_RUN_MAIN__2018_03_03__18_14_39__clouds.dat'); %self 
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.0/CPU_RUN_MAIN__2018_03_03__18_21_34__clouds.dat'); % periodic. Travelling. Optic lines
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/1.7.0/CPU_RUN_MAIN__2018_03_03__18_34_16__led.dat'); % self, no L1 data
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/shifting/2/CPU_RUN_MAIN__2018_02_27__14_09_43__mapping_shift_nohvconnected.dat'); %ngtu reset in D2
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/ngtu_reset/CPU_RUN_MAIN__2018_02_26__09_12_05__self_bgl_led2.45_100ms_p10s.dat'); %ngtu reset in D2
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/trigger_empty_packet/CPU_RUN_MAIN__2018_02_25__11_16_11__self.dat'); % packet of empty (all 0) data every 8 packets
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/shifting/CPU_RUN_MAIN__2018_02_24__11_41_36__.dat'); %
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/periodic/CPU_RUN_MAIN__2018_02_23__13_36_40.dat'); %periodic
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_MAIN__2018_02_23__12_41_19__test_file_for_Alexander.dat'); %test
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_MAIN__2018_02_22__09_06_11.dat'); % self 
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_MAIN__2018_02_22__09_05_13.dat'); % self 
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_MAIN__2018_02_22__09_18_07.dat'); % gathered in self mode
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_MAIN__2018_02_23__08_12_46.dat'); % gathered in periodic mode. Disturbances in all EC-ASICs
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
n_of_frames_in_packet = 12; % was 128
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
