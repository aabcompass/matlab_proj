% Visualizer
%clear all;
filesize=19660800;%768;
accumulation=128
frame_size=768
thr_step=5
num_of_thr=filesize/accumulation/frame_size 
l_counter=1; r_counter=1;
fid = fopen('/home/minieusouser/DATA/DatYYYYMMDDHHmmSS1.ready','r');
data = fread(fid, filesize);
%data = zeros(filesize,1)
for i=1:filesize
    floor(floor(i-1)/2);
    if mod(floor(floor(i-1)/2), 2) == 0 
        data_L(l_counter) = data(i);
        l_counter=l_counter+1;
    else
        data_R(r_counter) = data(i);
        r_counter=r_counter+1;
    end    
end

fclose(fid);
data_L_reshape = reshape(data_L, [8,filesize/2/8]);
data_R_reshape = reshape(data_R, [8,filesize/2/8]);

data_L_reshape_acc_thr = zeros(num_of_thr, 8, 48);
data_R_reshape_acc_thr = zeros(num_of_thr, 8, 48);

for i=1:num_of_thr
    data_L_reshape_acc = zeros(8, 48);
    for j=1:accumulation
        offset = (j-1)*48 + (i-1)*48*accumulation;
        data_L_reshape_acc = data_L_reshape_acc + data_L_reshape(:,offset+1:offset+48);
    end
    data_L_reshape_acc_thr(i,:,:) = data_L_reshape_acc;
end

for i=1:num_of_thr
    data_R_reshape_acc = zeros(8, 48);
    for j=1:accumulation
        offset = (j-1)*48 + (i-1)*48*accumulation;
        data_R_reshape_acc = data_R_reshape_acc + data_R_reshape(:,offset+1:offset+48);
    end
    data_R_reshape_acc_thr(i,:,:) = data_R_reshape_acc;
end



stop
%% video visualization data_L_reshape_acc_thr
for k=1:num_of_thr
    for i=1:8
        for j=1:48
            tmp(i,j)=data_R_reshape_acc_thr(k,i,j);
        end
    end
    pcolor(tmp);
    pause(0.2);
    dac=k*thr_step
end

%% S-Curves
i=1; %row
j=31; %column
for j=1:48
    for i=1:8
        scurve = zeros(num_of_thr);
        for k=1:num_of_thr
            scurve(k) = data_L_reshape_acc_thr(k,i,j);
        end
        plot(scurve);
        pause(0.1);
        i
        j
    end
end

