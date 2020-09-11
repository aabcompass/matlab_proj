clear all;
% setup parameters
n_ecasic=1;%6
dimx_ecasic = 8;
dimy_ecasic = 8;%48
ipaddr = '192.168.7.10';
port = 23

%open tcp connection
t = tcpip(ipaddr, port, 'NetworkRole', 'client', 'InputBufferSize', 10000);
fopen(t);
% setup threshold
%fwrite(t, 'slowctrl all dac 680');
%[msg_reply, count] = fread(t, 5, 'char'); 

%fwrite(t, 'acq test 2');
%[pdm_data, count] = fread(t, 5, 'uint32');
for i=1:100000
    % acquire one frame
    fwrite(t, 'acq live');
    [pdm_data, count] = (fread(t, n_ecasic*dimx_ecasic*dimy_ecasic, 'uint32'));
    pdm_data = swapbytes(uint32(pdm_data));

    % obtain 6 images from EC-ASIC boards. Each  EC-ASIC board has 8x48 image
    ecasics_2d = reshape(pdm_data, [dimx_ecasic dimy_ecasic n_ecasic]); 
    % concatenation of 6 images into one image 48x48
    %pdm_2d = [ecasics_2d(:,:,1)' ecasics_2d(:,:,2)' ecasics_2d(:,:,3)' ecasics_2d(:,:,4)' ecasics_2d(:,:,5)' ecasics_2d(:,:,6)'];
    pdm_2d = ecasics_2d(:,:,1)';
    % plot 2D image
    clims = [0 255];
    %pcolor(double(pdm_2d)/16384);
    colorbar;
    imagesc(double(pdm_2d)/16384);
    colorbar;

    pause(0.01)   %0.1sec
end


%% close tcp
fclose(t);
'port closed'
