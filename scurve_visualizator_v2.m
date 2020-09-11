% in current SW release
% DAC: 0 -> 5 -> 10 -> .... -> 995 
% For each DAC step we gather 128 GTU frames 
% each GTU frame is 48px * 48 = 2304 px. 
% each px = 1 byte (SPACIROC counter has 8 bits data width)
% filesize = 2304 bytes * 128 frames/DAC_step  * 200 

% Visualizer
%clear all;
clear all;
%filesize=19660800*3;%768;
figure;
accumulation=128; % number of GTU frames per DAC step
frame_size=2304
thr_step=1
num_of_thr=1001
filesize=frame_size * accumulation * num_of_thr
l_counter=1; r_counter=1;
%fid = fopen('/home/alexander/matlab_prj/sc_pdm_noHV.dat','r');
%fid = fopen('/home/alexander/matlab_prj/sc_pdm_HV.dat','r');
%fid = fopen('/home/alexander/matlab_prj/sc_pdm_HV_light.dat','r');
fid = fopen('sc_dark_ECg_4aug.dat','r');
%fid = fopen('sc_flatsc_HV3900_ECg_4aug.dat','r');

data = fread(fid, filesize);

raw_frames = reshape(data, [frame_size accumulation num_of_thr]);

scurve = zeros(num_of_thr, frame_size);
for j=1:frame_size
    for i=1:num_of_thr
        scurve(i, j)=sum(raw_frames(j, :, i));
    end
end

% All S-Curves in one plot

% hold on
% for j=1:frame_size
%     plot(scurve(:,j))
% end

mesh(scurve)
%imagesc(scurve)
%% Only one s-curve
hold off;
figure;
plot(scurve(:,966)/accumulation,'.-');

%% All S-Curves 
%plot(scurve(:,i),'-.')
figure
hold on
for i=1:frame_size
    plot(scurve(:,i)/accumulation)
end




