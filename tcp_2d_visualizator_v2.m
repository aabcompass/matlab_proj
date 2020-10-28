clear all;
% setup parameters
n_ecasic=6;
dimx_ecasic = 8;
dimy_ecasic = 48;
ipaddr = '192.168.7.10';
port = 23

fix_color_map = 1;
colorbar_lim = 0.01;%45 %установить предел цветовой шкалы / set colorbar limit

do_remap = 1;


%open tcp connection
t = tcpip(ipaddr, port, 'NetworkRole', 'client', 'InputBufferSize', 10000);
fopen(t);
% setup threshold
%fwrite(t, 'slowctrl all dac 680');
fwrite(t, 'acq stop');
[msg_reply, count] = fread(t, 5, 'char'); 

%fwrite(t, 'acq test 2');T
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
    
    if do_remap == 1
        for i=0:5
            for j=0:5
                pdm_2d_remap(i*8+1:i*8+8, j*8+1:j*8+8)=remap_spb2(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8));
            end
        end
    else
        pdm_2d_remap = pdm_2d;
    end
    
    if fix_color_map==1
        imagesc(double(pdm_2d_remap)/16384, clims);
        %imagesc(double(pdm_2d_remap(1:16,9:16))/16384);
    else
        %imagesc(double(pdm_2d_remap(1:16,9:16))/16384);
        %imagesc(double(pdm_2d(33:48,9:16))/16384);
        imagesc(double(pdm_2d_remap)/16384);
        %imagesc(double(pdm_2d));
    end
    %imagesc(double(pdm_2d));
    colorbar;

    pause(0.01)   %0.1sec
end


%% close tcp
fclose(t);
'port closed'
