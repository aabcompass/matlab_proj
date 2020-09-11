str.a = 1;
str.b = 2;
fid = fopen('str_file.bin', 'w');
fwrite(fid, str.a);
fclose(fid);
struct_write