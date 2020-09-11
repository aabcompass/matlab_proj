clear all
a=uint32(1:1:100000);
fid=fopen('binary_accending.bin', 'w');
fwrite(fid, a);
fclose(fid);
