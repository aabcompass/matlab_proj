% #define N_OF_PIXELS_PER_PMT		64 /* number of pixel on PMT */
% #define N_OF_PMT_PER_ECASIC 	6	/* number of PMT on EC ASIC board */
% #define N_OF_ECASIC_PER_PDM		6  /* number of EC ASIC boards in PDM */
% 
% #define N_OF_PIXEL_PER_PDM		(N_OF_PIXELS_PER_PMT * N_OF_PMT_PER_ECASIC * N_OF_ECASIC_PER_PDM)
% 
% #define NMAX_OF_THESHOLDS	1024
% 
% typedef struct
% {
% 	uint32_t int32_data[NMAX_OF_THESHOLDS][N_OF_PIXEL_PER_PDM];
% } DATA_TYPE_SCURVE_V1;
% 
% // Common Zynq board header
% // for all packets with scientific and configuration data
% typedef struct
% {
% 	uint32_t header; // 'Z'(31:24) | instrument_id(23:16) | data_type(15:8) | packet_ver(7:0)
% 	uint32_t payload_size;
% } ZynqBoardHeader; //
%
% typedef struct
% {
% 	ZynqBoardHeader zbh;
% 	DATA_TYPE_SCURVE_V1 payload;
% } Z_DATA_TYPE_SCURVE_V1;
% 

% 
% /* generic packet header for all cpu packets and hk/scurve sub packets */
% /* the zynq packet has its own header defined in pdmdata.h */
% /* 16 bytes */
% typedef struct
% {
%   uint32_t spacer = ID_TAG; /* AA55AA55 HEX */
%   uint32_t header; /* 'P'(31:24) | instrument_id(23:16) | pkt_type(15:8) | pkt_ver(7:0) */
%   uint32_t pkt_size; /* size of packet */
%   uint32_t pkt_num; /* counter for each pkt_type, reset each run */
% } CpuPktHeader; 
% 
% typedef struct
% {
%   CpuPktHeader sc_packet_header; /* 16 bytes */
%   CpuTimeStamp sc_time; /* 4 bytes */
%   uint16_t sc_start; /* 2 bytes */
%   uint16_t sc_step; /* 2 bytes */
%   uint16_t sc_stop; /* 2 bytes */
%   uint16_t sc_acc; /* 2 bytes */
%   Z_DATA_TYPE_SCURVE_V1 sc_data; /* 9437192 bytes */
% } SC_PACKET;
% 
% typedef struct
% {
%   uint32_t spacer = ID_TAG; /* AA55AA55 HEX */
%   uint32_t header; /* 'C'(31:24) | instrument_id(23:16) | file_type(15:8) | file_ver(7:0) */
%   uint32_t run_size; /* number of cpu packets in the run */
% } CpuFileHeader; 
% 
% /* cpu file trailer */
% /* 12 bytes */
% typedef struct
% {
%   uint32_t spacer = ID_TAG; /* AA55AA55 HEX */
%   uint32_t run_size; /* number of cpu packets in the run */
%   uint32_t crc; /* checksum */
% } CpuFileTrailer; 
% 
% 
% /* SC file to store a single S-curve */
% /* shown here as demonstration only */
% /* 9437244 bytes (~9 MB) */
% typedef struct
% {
%   CpuFileHeader cpu_file_header; /* 12 bytes */
%   SC_PACKET scurve_packet; /* 9437220 bytes */
%   CpuFileTrailer cpu_file_trailer; /* 12 bytes */
% } SC_FILE;
% 

clear all;

%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_14__18_00_52__3400.dat');
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_14__17_48_56__3400.dat');

%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_15__16_40_32__3850.dat'); %good scurve IMHO
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_15__16_57_40__3850.dat'); %one pixel super strange
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_15__17_32_04__3850.dat'); % no light?
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_15__17_39_36__3850.dat'); % good
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_15__17_45_31__3850.dat'); % good
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_15__17_50_25__3850.dat'); % no light?
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__10_38_53__3850.dat'); % no light. some pixel have spikes

%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__10_38_53__3850.dat'); %  spikes
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__10_43_11__3850.dat'); % light
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__11_22_06__3850.dat'); % no light. spikes: 60, 2040. DM:1020
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__12_06_37__3850.dat'); % no light. spikes: 60, 2040. DM:1020
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__12_14_16__3700.dat'); % no light. spikes: 60, 2040 
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__12_18_16__3600.dat'); % no light. spikes: 60, 2040
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__12_23_28__3500.dat'); % no light. spikes: 60, 2040
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__13_03_41__3800.dat'); % no pedestal
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__13_10_40__3800.dat'); % no light. huge spikes: 60, 2040
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__13_19_22__3800.dat'); % no light. small spike 2040
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__15_05_35__3800.dat'); % no light. small spike 60
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__15_07_01__3850.dat'); % DM:60, 1020, 2040
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__15_18_44__nohv.dat'); %pedestal ok 
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__16_18_03__3850.dat'); % was a HW error. thr.voltage wasn't changed
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__16_20_22__3850.dat'); % was a HW error. thr.voltage wasn't changed
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__16_28_47__3850.dat'); % % DM:60, 1020, 2040, no pedestal
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__16_36_19__nohv.dat'); % pedestal ok 
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__16_41_29__3850.dat'); % DM:60, 1020, 2040, no pedestal
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__16_45_00__nohv.dat'); % pedestal ok 
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__16_49_05__3850.dat'); % no pedestal
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__17_02_51__3850.dat'); % no pedestal
%fid = fopen('/mnt/d/EUSO/Integrations/2017.12/CPU_RUN_SC__2017_12_16__17_08_50__3850.dat'); % no pedestal
 
% Integration 2018.02 %
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_SC__2018_02_09__12_27_52__2000.dat'); %  pedestal exists, but some pixels have low intensity
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_SC__2018_02_09__12_28_42__2000.dat'); %  pedestal exists, but some pixels have low intensity
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_SC__2018_02_09__12_29_30__2000.dat'); %  pedestal exists, but some pixels have low intensity
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_SC__2018_02_09__12_35_58__1000.dat'); %  pedestal exists, but some pixels have low intensity
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_SC__2018_02_09__12_36_47__1000.dat'); %  pedestal exists, but some pixels have low intensity
%fid = fopen('/mnt/d/EUSO/Integrations/2018.02/CPU_RUN_SC__2018_02_09__12_37_36__1000.dat'); %  pedestal exists, but some pixels have low intensity

%fid = fopen('/home/minieusouser/DATA/scurve_00000000.dat','r');
fid = fopen('/mnt/d/EUSO/Integrations/2019.03/fm_frame_712/CPU_RUN_SC__2019_03_04__11_47_22__noHV__pushing_zynq_step1.dat','r');

D = struct_read(fid,'iii4ii4h2i2359296I');
D8 = D{8};
%D = struct_read(fid,'2i2359296I');
%D8 = D{2};

N_OF_PIXEL_PER_PDM = 2304;
NMAX_OF_THESHOLDS = 1024;

scurves_all = reshape(D8, N_OF_PIXEL_PER_PDM, NMAX_OF_THESHOLDS);
%mesh(scurves_all)
j=1;
for i=1:1:1024
    scurves(:, j) = scurves_all(:, i);
    j=j+1;
end
%mesh(scurves)
imagesc(scurves')

