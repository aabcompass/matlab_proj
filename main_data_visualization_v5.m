%Программа для вывода изображения, полученного с платы цифровой обработки
%данных УФ-атмосфера.

% Задание параметров программы
clear all; 
level=3; % задать уровень триггера. / Data type {raw, 1st integrated, 2nd integrated}
frame_step=1;
mode_2d = 1;
mode_lightcurve = 0;
fix_color_map = 0;
colorbar_lim = 200; %установить предел цветовой шкалы / set colorbar limit
                % его надо бы сделать слайдером 
only_triggered = 0;


frame_size=2304; % задать число пикселей ФПУ / number of pixels on FS
num_of_frames=128; % задать число фреймов в пакете / number of frames per packet


magic_A = [hex2dec('01') hex2dec('0A') hex2dec('01') hex2dec('5A') hex2dec('18') hex2dec('80') hex2dec('04') hex2dec('00')];
magic_B = [hex2dec('01') hex2dec('0B') hex2dec('01') hex2dec('5A') hex2dec('18') hex2dec('00') hex2dec('09') hex2dec('00')];
magic_C = [hex2dec('01') hex2dec('0C') hex2dec('01') hex2dec('5A') hex2dec('1C') hex2dec('00') hex2dec('12') hex2dec('00')];


cw90 = 3; % поворот МАФЭУ на 90 градусов по часовой стрелки 
ccw90 = 1;% поворот МАФЭУ на 90 градусов против часовой стрелки
cw180 = 2;% поворот МАФЭУ на 180 градусов
rotation_needed = 1;
% Некоторые МАФЭУ (8х)по техническим причинам повернуты. 
current_frame_global = 1;


%% visualization
% Подготовка данных к формированию изображения

% path to directory with data files   
%path='~/xil_proj/pdm_zynq_board/lftp/1/';
%path='/mnt/d/EUSO/ISS/04_2019_11_07/Lech/';
%path='/mnt/d/EUSO/ISS/08_2019_12_30/';
%path='/mnt/d/EUSO/ISS/10_2020_01_14/rg4508/';
%path='/mnt/d/EUSO/ISS/12_2020_03_02/rg4919/';
%path='/mnt/d/EUSO/ISS/14_2020_03_31/';
%path='/mnt/d/EUSO/ISS/15_2020_04_29/5419/';
%path='/mnt/d/EUSO/ISS/17_2020_06_15/Session-17(20200615)_ISS/';
%path='/mnt/d/EUSO/ISS/18_2020_06_24/5916/11/';
%path='/mnt/d/EUSO/Integrations/2020_03_19/';
%path='/mnt/d/EUSO/ISS/09_2020_01_08/'
%path='/mnt/d/EUSO/Integrations/2019.05_Philippe_calib/ScanDat1/';
%path='/mnt/d/EUSO/Integrations/2019.03/fm_bad_ECUNITS/';
%path='/mnt/d/EUSO/Integrations/2018.11/ta/Jacek(1EC)/hv=4095_cath=3_f=5kHz/';
path='/mnt/d/EUSO/Integrations/2020.09_Hiroko_L2_test/2/MINIEUSOUSER/DATA/';

listing = dir([path '*.dat']);


%lightcurve = zeros(packetsInFile*10, num_of_frames);

for filename_cntr = 1:numel(listing) % указание на номера файлов, из которых будет произведено чтение
    %цикл, выполняющийся для каждого файла. 
    
    filename = [path listing(filename_cntr,1).name];    
    pause(0.2)
    fid = fopen(filename);
    
    display(filename);
    
    cpu_file = uint8(fread(fid, inf)); %прочитать файл в память / read file to memory
    fclose(fid); %закрыть файл / close file
    size_frame_file = size(cpu_file); % опрелелить размер прочитанных данных / get data size
    sections_D(1,:) = strfind(cpu_file',magic_A);
    sections_D(2,:) = strfind(cpu_file',magic_B);
    sections_D3 = strfind(cpu_file',magic_C);
    sections_D(3,1:numel(sections_D3)) = sections_D3;

    strange_offset = 2;
    n_of_frames_in_packet = 128; 
    D_bytes=uint8(zeros(3, numel(sections_D(1,:)), 4*frame_size*n_of_frames_in_packet));
    D_tt = zeros(3, numel(sections_D(1,:)));
    D_ngtu = zeros(3, numel(sections_D(1,:)));
    D_cath = zeros(3, numel(sections_D(1,:)), 12);
    for j=1:3 % for each data type (D1 or D2 or D3)
        for i=1:numel(sections_D(level,:))
            if (sections_D(j,i) ~= 0) || (only_triggered == 0)
                if(sections_D(j,i)+30+(j==3)*4+strange_offset+(2^(j-1))*frame_size*n_of_frames_in_packet-1) <= size(cpu_file, 1)
                    tmp=uint8(cpu_file(sections_D(j,i)+30+(j==3)*4+strange_offset : sections_D(j,i)+30+(j==3)*4+strange_offset+(2^(j-1))*frame_size*n_of_frames_in_packet-1)); 
                    D_bytes(j,i,1:size(tmp)) = tmp(:);                                       
                    D_ngtu(j,i) = typecast(uint8(cpu_file(sections_D(j,i)+8:sections_D(j,i)+11)), 'uint32');
                    D_unixtime(j,i) = typecast(uint8(cpu_file(sections_D(j,i)+12:sections_D(j,i)+15)), 'uint32');
                    D_tt(j,i) = uint8(cpu_file(sections_D(j,i)+16));
                    D_cath(j,i,:) = uint8(cpu_file(sections_D(j,i)+20:sections_D(j,i)+31));
                end
            end
        end 
    end
    
    datasize = 294912*2^(level-1);
    accumulation = 128^(level-1);
    lightcurve_sum=zeros(128);
    for i=1:frame_step:numel(sections_D(level,:))
        if D_tt(level,i) == 0
            continue;
        end
        fprintf('T:%d\n', i);

        frame_data = reshape(D_bytes(level,i,1:datasize), [1 datasize]); % выбрать из всех данных, полученных из файла, блок, содержащий изображение / take subarray with only image data
        if level == 3% случай триггера уровня 3
            frame_data_cast = typecast(frame_data(:), 'uint32'); %преобразовать представление данных к  uint32 // convert to uint32
        elseif level == 2% случай триггера уровня 2
            frame_data_cast = typecast(frame_data(:), 'uint16');%преобразовать представление данных к  uint16 // convert to uint16
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
                for i=0:5 %для каждой строки элементов изображения 8х8 (МАФЭУ)
                    for j=0:5%для каждого столбца элементов изображения 8х8 (МАФЭУ)
                        if((rem(i,2)==0) && (rem(j,2)==0))%условия поворота
                           pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = fliplr(rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), cw180));%поворот по часовой стрелке %rot90 cw90
                        end
                        if((rem(i,2)==0) && (rem(j,2)==1))%условия поворота
                           pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = fliplr(rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), cw90));%поворот по часовой стрелке
                        end
                        if((rem(i,2)==1) && (rem(j,2)==0))%условия поворота
                           pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = fliplr(rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), ccw90));%поворот по часовой стрелке
                        end
                        if((rem(i,2)==1) && (rem(j,2)==1))%условия поворота
                           pdm_2d_rot(i*8+1:i*8+8, j*8+1:j*8+8) = fliplr(rot90(pdm_2d(i*8+1:i*8+8, j*8+1:j*8+8), 0));%зеркально отобразить fliplr
                        end
                   end
                end            
            end

            
           
            if mode_2d == 1
                if fix_color_map == 1 
                    imagesc(pdm_2d_rot, [0 colorbar_lim]);%вывести график на экран / plot the color image
                else
                    imagesc(pdm_2d_rot);
                end;
                colorbar %вывести цветовую шкалу / show colorbar
            end
            fprintf('*');
           
            %display([int8(current_frame) sum(pic)])
            %pdm_2d_rot_part = pdm_2d_rot(19:22,3:6);
            %pdm_2d_rot_part_2 = pdm_2d_rot_part(:);
            %pdm_2d_rot_part_L2(:,current_frame+128*(filename_cntr-1))=pdm_2d_rot_part_2';
            %timehystogram(filename_cntr, current_frame) = sum(sum(pdm_2d_rot));
            if mode_lightcurve == 1
                lightcurvesum(current_frame)=sum(pic);
                current_frame_global = current_frame_global + 1;
                lightcurvesum_global(current_frame_global) = sum(pic);
            end
            %plot(lightcurve','-o');
        end 
        fprintf('\n');
        %D_cath(level,i)'
        if mode_lightcurve == 1
            plot(lightcurvesum)
        end
        
           
        
        
    end
    %plot(D_ngtu(3,:),'.-');
    
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


