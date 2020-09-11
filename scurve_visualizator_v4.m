% Visualizer for scurve which were elaborated inside Zynq
clear all;

figure;
frame_size=2304
num_of_thr=128*8
filesize=4*frame_size * num_of_thr
accumulation=16384;
is_cpu = 0;


%fid = fopen('/mnt/d/EUSO/Integrations/2019.03/fm_frame_712/CPU_RUN_SC__2019_03_04__11_47_22__noHV__pushing_zynq_step1.dat','r');
%fid = fopen('/mnt/d/EUSO/Integrations/2019.03/fm_frame_712/scurve_00000000.dat','r');
%fid = fopen('/home/minieusouser/DATA/scurve_00000000.dat','r');
%fid = fopen('/home/alx/xil_proj/pdm_zynq_board/scurve_00000000.dat','r');
%fid = fopen('/mnt/d/EUSO/Integrations/2019.05/scurve_00000000.dat','r');
%fid = fopen('/mnt/d/EUSO/Integrations/2018.11/ta/Jacek(1EC)/hv=4095_cath=3_f=5kHz/scurve_00000000.dat','r');
%fid = fopen('/mnt/d/EUSO/Gio/CPU_RUN_SC__2019_07_01__19_56_03__3962,3962,3962,3962,3962,3962,3962,3962,3962__dvr1100_poster_disc.dat','r');
%fid = fopen('//mnt/d/EUSO/Integrations/2017.10/Good_scurve/scurve_00000000.dat','r');
%fid = fopen('/home/minieusouser/DATA/nohead_electronic_noise.dat','r');
%fid = fopen('sc_flatsc_HV3900_ECg_4aug.dat','r');
%fid = fopen('/mnt/d/EUSO/Integrations/tmp/scurve_00000004.dat','r');
%fid = fopen('/home/alx/scurve_00000000.dat','r');
fid = fopen('/mnt/d/EUSO/Integrations/2019.05_Philippe_calib/scurve_pmt1_ec1/scurve_00000002.dat','r');

data = uint8(fread(fid, inf));

if is_cpu == 0
    data_wo_header = data(8:8+filesize-1);
else
    pos = strfind(data(:,1)', [hex2dec('01') hex2dec('14') hex2dec('01') hex2dec('5A')])
    data_wo_header = data(pos+4:pos+4+filesize-1);
end

data32 = typecast(data_wo_header, 'uint32');

scurves_all = double(reshape(data32, [frame_size num_of_thr])');
scurves_all = scurves_all'/accumulation;

j=1;
for i=1:1:1024
    scurve(:, j) = scurves_all(:, i);
    j=j+1;
end
% All S-Curves in one plot

% hold on
% for j=1:frame_size
%     plot(scurve(:,j))
% end
imagesc((double(scurve))/16384)
colorbar
%mesh((double(scurve))/16384)
%colorbar
%mesh(log(double(scurves)))
stop

%% Only one s-curve
hold off;
figure;
plot(scurve(555:666,:)'/16384,'.-');

%% All S-Curves 
%plot(scurve(:,i),'-.')
figure
hold on
for i=1:frame_size
    plot(scurve(:,i))
end

%% 2d visualization
dimx_ecasic = 8;
dimy_ecasic = 48;
n_ecasic=6;
pic = scurve(80, :);
ecasics_2d = fliplr(reshape(pic', [dimx_ecasic dimy_ecasic n_ecasic])); %

pdm_2d = [ecasics_2d(:,:,1)' ecasics_2d(:,:,2)' ecasics_2d(:,:,3)' ecasics_2d(:,:,4)' ecasics_2d(:,:,5)' ecasics_2d(:,:,6)'];
figure
clims = [0 0.1];
imagesc(pdm_2d, clims);
%% PMT rotations
cw90 = 3;
ccw90 = 1;
cw180 = 2;

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
           pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), 0);
        end
   end
end

figure
clims = [0 0.1];
imagesc(pdm_2d_rot, clims);
% dimx_pix_pmt = 8;
% dimy_pix_pmt = 8;
% dimx_pmt_ec = 2;
% dimy_pmt_ec = 2;
% dimx_ec_pdm = 3;
% dimy_ec_pdm = 3;
% cw90 = 3;
% ccw90 = 1;
% cw180 = 2;
% ec = mat2cell(pdm_2d, [16, 16, 16], [16, 16, 16]);
% ec_rot = ec;
% for i=1:3
%     for j=1:3
%         if((i==1) && (j==1))
%             ec_rot(1:8,1:8){i,j} = ec(1:8,1:8){i,j};
%         end
%         if((i==1) && (j==2))
%             ec_rot(1:8,1:8){i,j} = ec(1:8,1:8){i,j};
%         end
%         if((i==2) && (j==1))
%             ec_rot(1:8,1:8){i,j} = ec(1:8,1:8{i,j});
%         end
%         if((i==2) && (j==2))
%             ec_rot(1:8,1:8){i,j} = ec(1:8,1:8){i,j};
%         end
%     end
% end 
% pmt{:,:} = mat2cell(ec{:,:}, [8, 8], [8, 8]);
% 
% pmt = reshape(pdm_2d, [dimx_pix_pmt dimy_pix_pmt dimx_pmt_ec dimy_pmt_ec dimx_ec_pdm dimy_ec_pdm])
% pmt_rot(:,:,1,1,:,:) = rot90(pmt(:,:,1,1,:,:), cw90); 
% pmt_rot(:,:,2,1,:,:) = rot90(pmt(:,:,2,1,:,:), cw180); 
% pmt_rot(:,:,1,2,:,:) = rot90(pmt(:,:,1,2,:,:), 0); 
% pmt_rot(:,:,2,2,:,:) = rot90(pmt(:,:,2,2,:,:), 0); 
% pdm_2d_rot = reshape(pmt_rot, [48 48]);
% figure
% clims = [0 0.1];
% imagesc(pdm_2d_rot, clims);
%% tmp
imagesc(ec{1,1})
%% just one EC ASIC board
figure
clims = [0 1.5];
imagesc(ecasics_2d(:,:,1), clims)


