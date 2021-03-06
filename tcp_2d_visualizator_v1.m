clear all;
% setup parameters
n_ecasic=6;
dimx_ecasic = 8;
dimy_ecasic = 48;
ipaddr = '192.168.7.10';
port = 23

fix_color_map = 1;
colorbar_lim = 10; %установить предел цветовой шкалы / set colorbar limit


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
    [pdm_data, count] = (fread(t, 2304, 'uint32'));
    pdm_data = swapbytes(uint32(pdm_data));

    % obtain 6 images from EC-ASIC boards. Each  EC-ASIC board has 8x48 image
    ecasics_2d = reshape(pdm_data, [dimx_ecasic dimy_ecasic n_ecasic]); 
    % concatenation of 6 images into one image 48x48
    pdm_2d = [ecasics_2d(:,:,1)' ecasics_2d(:,:,2)' ecasics_2d(:,:,3)' ecasics_2d(:,:,4)' ecasics_2d(:,:,5)' ecasics_2d(:,:,6)'];
    % plot 2D image
    clims = [0 colorbar_lim];
    %pcolor(double(pdm_2d)/16384);    
    %imagesc(double(pdm_2d(1:16,17:24))/16384);
    
    if fix_color_map==1
        imagesc(double(pdm_2d)/16384, clims);
    else
        %imagesc(double(pdm_2d(9:24,17:24))/16384);
        %imagesc(double(pdm_2d(33:48,9:16))/16384);
        imagesc(double(pdm_2d)/16384);
        %imagesc(double(pdm_2d));
    end
    %imagesc(double(pdm_2d));
    colorbar;

    pause(0.01)   %0.1sec
end


%% close tcp
fclose(t);
'port closed'
