%% loader
clear all;
filename_without_extension = '/mnt/d/EUSO/Integrations/2018.02/1.8.2/zinq_log_20180323/run04/event_log';
%filename_without_extension = '/mnt/d/EUSO/Integrations/2018.02/1.8.1/20March2!/event_log-run6-self';
%filename_without_extension = '/mnt/d/EUSO/Integrations/2018.02/1.8.1/20March2!/event_log-run7-self';
%filename_without_extension = '/mnt/d/EUSO/Integrations/2018.02/1.8.1/20March2!/event_log-run8-external';
fid = fopen([filename_without_extension '.bin']); %self
event_log_file = fread(fid, inf);
fclose(fid);
data = uint8(event_log_file);
data_u32 = (typecast(data, 'uint32'));
record_size = 2;
records = reshape(data_u32, [record_size  numel(data_u32)/record_size]);
fid2 = fopen([filename_without_extension '.txt'], 'w'); %self
for i=1:numel(data_u32)/2
    fprintf(fid2, '%08x %d\n',  records(1,i), records(2,i));
end
fclose(fid2);
%stop
%% trains
records_size = size(records, 2);
diff=records(2,2:records_size) - records(2,1:records_size-1);
hist(diff(1,:));
