%Программа для вывода изображения, полученного с платы цифровой обработки
%данных УФ-атмосфера.

% Задание параметров программы
clear all; 
frame_size=2304; % задать число пикселей ФПУ / number of pixels on FS
num_of_frames=128; % задать число фреймов в пакете / number of frames per packet
level=2; % задать уровень триггера. / Data type {raw, 1st integrated, 2nd integrated}
frame_step=1;

if(level==3) 
    packetsInFile=1;
else
    packetsInFile=4;
end

% первый уровень - без интегрирования
% второй уровень - с интегрированием по времени в течении 128 фреймов
% третий уровень - с двойным интегрирование по времени в течении 128*128 фреймов
cw90 = 3; % поворот МАФЭУ на 90 градусов по часовой стрелки 
ccw90 = 1;% поворот МАФЭУ на 90 градусов против часовой стрелки
cw180 = 2;% поворот МАФЭУ на 180 градусов
rotation_needed = 0;



%% visualization
% Подготовка данных к формированию изображения

% path to directory with data files   
path='/home/alx/xil_proj/pdm_zynq_board/lftp/';
%path='/mnt/d/EUSO/Integrations/2019.05_Philippe_calib/ScanDat1/';
%path='/mnt/d/EUSO/Integrations/2019.03/fm_bad_ECUNITS/';
%path='/mnt/d/EUSO/Integrations/2018.11/ta/Jacek(1EC)/hv=4095_cath=3_f=5kHz/';
listing = dir([path 'frm*']);

lightcurve = zeros(packetsInFile*10, num_of_frames);

for filename_cntr = 1:numel(listing) % указание на номера файлов, из которых будет произведено чтение
    %цикл, выполняющийся для каждого файла. 
    
    filename = [path listing(filename_cntr,1).name];    
    pause(0.2)
    fid = fopen(filename);
    
    display(filename);
    
    frame_file = uint8(fread(fid, inf)); %прочитать файл в память / read file to memory
    fclose(fid); %закрыть файл / close file
    size_frame_file = size(frame_file); % опрелелить размер прочитанных данных / get data size
    
    for j=1:packetsInFile
        if level == 3 % случай триггера уровня 3 / level=3 case
            start_addr = 1 + (294932+12)*4 + (589844+12)*4 + 8+8+4+12+4; %задать стартовый адрес / set start address
            trig_type_addr = start_addr - 20;
            ts_gtu_addr = start_addr - 28;
            datasize = 294912*4; %задать размер блока данных, содержащих изображение 
            accumulation = 128*128; % задать коэффициент интегрирования
            colorbar_lim = 1;% задать предет цветовой шкалы
        elseif level == 2 % случай триггера уровня 2 / level=2 case
            start_addr = 1 + (294932+12)*4 + 8+8+4+12 + (589844+12)*(j-1); %задать стартовый адрес
            trig_type_addr = start_addr - 16;
            ts_gtu_addr = start_addr - 24;
            datasize = 294912*2;  % задать коэффициент интегрирования
            accumulation = 128;% задать коэффициент интегрирования
            colorbar_lim = 1;% задать предет цветовой шкалы
        elseif level == 1% случай триггера уровня 1 / level=1 case
            start_addr = 1 + 8+8+4+12 + (294932+12)*(j-1);%задать стартовый адрес
            trig_type_addr = start_addr - 16;
            ts_gtu_addr = start_addr - 24;
            datasize = 294912; % задать коэффициент интегрирования
            accumulation = 1;% задать коэффициент интегрирования
            colorbar_lim = 10;% задать предет цветовой шкалы
        end
        n_pixels = 2304;%задать число пикселей
        n_packets = 128;%задать число пакетов
        trig_type_u8=frame_file(trig_type_addr:trig_type_addr+3);
        trig_type=typecast(trig_type_u8,  'uint32');
        ts_gtu_u8=frame_file(ts_gtu_addr:ts_gtu_addr+3);
        ts_gtu=typecast(ts_gtu_u8,  'uint32');
        fprintf('%d %d %f\n', j, trig_type, double(ts_gtu)/400000);
        frame_data = frame_file(start_addr:start_addr+datasize-1); % выбрать из всех данных, полученных из файла, блок, содержащий изображение / take subarray with only image data
        if level == 3% случай триггера уровня 3
            frame_data_cast = typecast(frame_data, 'uint32'); %преобразовать представление данных к  uint32 // convert to uint32
        elseif level == 2% случай триггера уровня 2
            frame_data_cast = typecast(frame_data, 'uint16');%преобразовать представление данных к  uint16 // convert to uint16
        elseif level == 1% случай триггера уровня 1
            frame_data_cast = frame_data;% оставить представление данных без изменения  // leave unchanged
        end
        frames = reshape(frame_data_cast, [frame_size num_of_frames]); % перегруппировать массив из одномерного в двумерный

        % Формирование изображения на экране
        for current_frame=1:1:num_of_frames % для каждого фрейма, прочитанного из файла / for each file in directory
            %disp(current_frame); % вывести значение переменной на экран / print to log screen
            pic = double(frames(:, current_frame)')/accumulation;% выбрать один фрейм из блока данных, который содержит все фреймы / select just one frame
            dimx_ecasic = 8; %задать размер по х блока данных, выдаваемый платой ECASIC
            dimy_ecasic = 48;%задать размер по y блока данных, выдаваемый платой ECASIC
            n_ecasic=6;% задать количество плат ECASIC
            ecasics_2d = fliplr(reshape(pic', [dimx_ecasic dimy_ecasic n_ecasic])); % сформировать двумерный массив 8х48, содержащий изображение одного фрейма / form an array 8x48 with just one frame

            % сформировать двумерный массив 48х48, содержащий изображение одного фрейма 
            pdm_2d = [ecasics_2d(:,:,1)' ecasics_2d(:,:,2)' ecasics_2d(:,:,3)' ecasics_2d(:,:,4)' ecasics_2d(:,:,5)' ecasics_2d(:,:,6)']; % form an array 48x48 with just one frame

            %figure %подготовить пустой график
            %imagesc(pdm_2d, clims); %вывести на график двумерный массив
            %colorbar
            pause(0.01)   %задержать выполнение программы на 0.1sec 
            % выполнить поворот элементов изображения в зависимости от
            % расположения
            % here we rotate PMTs depending on their positions 
            pdm_2d_rot = pdm_2d; % подготовить выходной массив для повернутых данных. Проинициализировать массив начальными данными до поворота
            if(rotation_needed)
                for i=0:5 %для каждой с*троки элементов изображения 8х8 (МАФЭУ)
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
            colorbar_lim = 100; %установить предел цветовой шкалы / set colorbar limit
            clims = [0 colorbar_lim];%установить предел цветовой шкалы
            %pcolor(pdm_2d_rot);
            
            %imagesc(pdm_2d_rot);%вывести график на экран / plot the color image
            %colorbar %вывести цветовую шкалу / show colorbar
            fprintf('*');
           
            %display([int8(current_frame) sum(pic)])
            %pdm_2d_rot_part = pdm_2d_rot(19:22,3:6);
            %pdm_2d_rot_part_2 = pdm_2d_rot_part(:);
            %pdm_2d_rot_part_L2(:,current_frame+128*(filename_cntr-1))=pdm_2d_rot_part_2';
            %timehystogram(filename_cntr, current_frame) = sum(sum(pdm_2d_rot));
            lightcurve(filename_cntr*4+j, current_frame)=sum(pic);
            plot(lightcurve','-o');
        end  
        
        
    end
    
end
stop % stop the program execution
%%
imagesc(timehystogram) 
colorbar
stop
%% Write to ASCII file.
dlmwrite('frames.txt', frames','precision', '%d');
%%
pdm_2d_rot_part_f1 = pdm_2d_rot_part(:,:,1,1);
%%


