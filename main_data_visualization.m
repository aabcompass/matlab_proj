%Программа для вывода изображения, полученного с платы цифровой обработки
%данных УФ-атмосфера.

% Задание параметров программы
clear all; 
frame_size=2304; % задать число пикселей ФПУ
num_of_frames=128; % задать число фреймов в пакете
level=3; % задать уровень триггера.
frame_step=1;
% первый уровень - без интегрирования
% второй уровень - с интегрированием по времени в течении 128 фреймов
% третий уровень - с двойным интегрирование по времени в течении 128*128 фреймов
cw90 = 3; % поворот МАФЭУ на 90 градусов по часовой стрелки
ccw90 = 1;% поворот МАФЭУ на 90 градусов против часовой стрелки
cw180 = 2;% поворот МАФЭУ на 180 градусов
rotation_needed = 0;



%% visualization
% Подготовка данных к формированию изображения
for filename_cntr = 0:3 % указание на номера файлов, из которых будет произведено чтение
    %цикл, выполняющийся для каждого файла. Имена файлов 
    
    filename_cntr; % вывести на печать значение переменной
    %fid = fopen(strcat('/mnt/d/EUSO/Integrations/2018.02/1.8.2/zinq_log_20180323/run10/frm_cc_', sprintf('%08d', filename_cntr), '.dat'));
    %fid = fopen(strcat('/mnt/d/EUSO/Integrations/2018.02/1.8.2/zinq_log_20180323/run09/frm_cc_', sprintf('%08d', filename_cntr), '.dat'));
    %fid = fopen(strcat('/mnt/d/EUSO/Integrations/2018.02/1.8.2/zinq_log_20180323/run08/frm_cc_', sprintf('%08d', filename_cntr), '.dat'));
    %fid = fopen(strcat('/mnt/d/EUSO/Integrations/2018.02/1.8.2/zinq_log_20180323/run07/frm_cc_', sprintf('%08d', filename_cntr), '.dat'));
    %fid = fopen(strcat('/mnt/d/EUSO/Integrations/2018.02/1.8.2/zinq_log_20180323/run06/frm_cc_', sprintf('%08d', filename_cntr), '.dat'));
    %fid = fopen(strcat('/mnt/d/EUSO/Integrations/2018.02/1.8.2/zinq_log_20180323/run05/frm_cc_', sprintf('%08d', filename_cntr), '.dat'));
    %fid = fopen(strcat('/mnt/d/EUSO/Integrations/2018.02/1.8.2/zinq_log_20180323/run04/frm_cc_', sprintf('%08d', filename_cntr), '.dat'));
    %fid = fopen(strcat('/home/minieusouser/DATA/frm_cc_', sprintf('%08d', filename_cntr), '.dat'));
    % открыть файл и получить файловый дескриптор на файл с данными
    %filename = strcat('/home/alx/xil_proj/pdm_zynq_board/frm_cc_', sprintf('%08d', filename_cntr), '.dat');
    %filename = strcat('/home/alx/xil_proj/pdm_zynq_board/lftp/frm_cc_', sprintf('%08d', filename_cntr), '.dat')
    filename = strcat('/home/alx/xil_proj/pdm_zynq_board/lftp/frm_cc_', sprintf('%08d', filename_cntr), '.dat')
    
    %filename = strcat('/mnt/d/EUSO/Integrations/2018.11/ta/Jacek(1EC)/hv=4095_cath=3_f=5kHz/frm_cc_', sprintf('%08d', filename_cntr), '.dat')
    %filename = strcat('/mnt/d/EUSO/Integrations/2018.11/ta/Jacek(1EC)/hv=4000_cath=2_f=3Hz/frm_cc_', sprintf('%08d', filename_cntr), '.dat')
   % filename = strcat('/mnt/d/EUSO/Integrations/2018.11/ta/Jacek(1EC)/hv=4000_cath=1_f=3Hz/frm_cc_', sprintf('%08d', filename_cntr), '.dat')
    
    while(~exist(filename, 'file')) 
       'Wait not a new file...\n'
       pause(0.2)
    end
    pause(0.2)
    fid = fopen(filename);
   
    frame_file = uint8(fread(fid, inf)); %прочитать файл в память
    fclose(fid); %закрыть файл
    size_frame_file = size(frame_file); % опрелелить размер прочитанных данных
    if level == 3 % случай триггера уровня 3
        start_addr = 1 + (294932+12)*4 + (589844+12)*4 + 8+8+4+12+4; %задать стартовый адрес
        datasize = 294912*4; %задать размер блока данных, содержащих изображение
        accumulation = 128*128; % задать коэффициент интегрирования
        colorbar_lim = 1;% задать предет цветовой шкалы
    elseif level == 2 % случай триггера уровня 2
        start_addr = 1 + (294932+12)*4 + 8+8+4+12; %задать стартовый адрес
        datasize = 294912*2;  % задать коэффициент интегрирования
        accumulation = 128;% задать коэффициент интегрирования
        colorbar_lim = 1;% задать предет цветовой шкалы
    elseif level == 1% случай триггера уровня 1
        start_addr = 1 + 8+8+4+12;%задать стартовый адрес
        datasize = 294912; % задать коэффициент интегрирования
        accumulation = 1;% задать коэффициент интегрирования
        colorbar_lim = 10;% задать предет цветовой шкалы
    end
    n_pixels = 2304;%задать число пикселей
    n_packets = 128;%задать число пакетов
    frame_data = frame_file(start_addr:start_addr+datasize-1); % выбрать из всех данных, полученных из файла, блок, содержащий изображение
    if level == 3% случай триггера уровня 3
        frame_data_cast = typecast(frame_data, 'uint32'); %преобразовать представление данных к  uint32
    elseif level == 2% случай триггера уровня 2
        frame_data_cast = typecast(frame_data, 'uint16');%преобразовать представление данных к  uint16
    elseif level == 1% случай триггера уровня 1
        frame_data_cast = frame_data;% оставить представление данных без изменения
    end
    frames = reshape(frame_data_cast, [frame_size num_of_frames]); % перегруппировать массив из одномерного в двумерный

    %% 2d visualization
    % Формирование изображения на экране
    for current_frame=1:1:num_of_frames % для каждого фрейма, прочитанного из файла
        disp(current_frame); % вывести значение переменной на экран
        pic = double(frames(:, current_frame)')/accumulation;% выбрать один фрейм из блока данных, который содержит все фреймы
        dimx_ecasic = 8; %задать размер по х блока данных, выдаваемый платой ECASIC
        dimy_ecasic = 48;%задать размер по y блока данных, выдаваемый платой ECASIC
        n_ecasic=6;% задать количество плат ECASIC
        ecasics_2d = fliplr(reshape(pic', [dimx_ecasic dimy_ecasic n_ecasic])); % сформировать двумерный массив 8х48, содержащий изображение одного фрейма 
        
        % сформировать двумерный массив 48х48, содержащий изображение одного фрейма 
        pdm_2d = [ecasics_2d(:,:,1)' ecasics_2d(:,:,2)' ecasics_2d(:,:,3)' ecasics_2d(:,:,4)' ecasics_2d(:,:,5)' ecasics_2d(:,:,6)'];
        
        %figure %подготовить пустой график
        %imagesc(pdm_2d, clims); %вывести на график двумерный массив
        %colorbar
        pause(0.01)   %задержать выполнение программы на 0.1sec
        % выполнить поворот элементов изображения в зависимости от
        % расположения
        pdm_2d_rot = pdm_2d; % подготовить выходной массив для повернутых данных. Проинициализировать массив начальными данными до поворота
        if(rotation_needed)
            for i=0:5 %для каждой строки элементов изображения 8х8 (МАФЭУ)
                for j=0:5%для каждого столбца элементов изображения 8х8 (МАФЭУ)
                    if((rem(i,2)==0) && (rem(j,2)==0))%условия поворота
                       pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), cw90);%поворот по часовой стрелке
                    end
                    if((rem(i,2)==0) && (rem(j,2)==1))%условия поворота
                       pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), cw180);%поворот по часовой стрелке
                    end
                    if((rem(i,2)==1) && (rem(j,2)==0))%условия поворота
                       pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), 0);%поворот по часовой стрелке
                    end
                    if((rem(i,2)==1) && (rem(j,2)==1))%условия поворота
                       pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = fliplr(rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), 0));%зеркально отобразить
                    end
               end
            end            
        end
        
        

        %figure
        colorbar_lim = 1; %установить предел цветовой шкалы
        clims = [0 colorbar_lim];%установить предел цветовой шкалы
        %imagesc(pdm_2d_rot, clims);
        imagesc(pdm_2d_rot);%вывести график на экран
        colorbar %вывести цветовую шкалу
        %timehystogram(filename_cntr, current_frame) = sum(sum(pdm_2d_rot));
    end  
end
stop

imagesc(timehystogram)
colorbar

% %% load HVPS interrupt log file
% fid_hv = fopen('/mnt/d/EUSO/Integrations/main_data/4/raw_data/hv_00000000.dat');
% hv_file = uint8(fread(fid_hv, inf));
% fclose(fid_hv);
% hv_file_32 = typecast(hv_file, 'uint32');
% for i=1:360%size(hv_file_32)
%     i
%     current_index = uint32(floor((i-1)/4 + 1))
%     rem(i-1,4) == 3
%     if(rem(i-1,4) == 0) 
%         hvps_gtu(current_index) = hv_file_32(i); 
%     elseif(rem(i-1,4) == 1) 
%         hvps_gtu(current_index) = hvps_gtu(current_index) + hv_file_32(i)*(2^32); 
%     elseif(rem(i-1,4) == 2) 
%         hvps_rectype(current_index) = hv_file_32(i);     
%     elseif(rem(i-1,4) == 3) 
%         hvps_channels(current_index) = hv_file_32(i); 
%     end        
% end

