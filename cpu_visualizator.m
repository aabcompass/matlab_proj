 %fid = fopen('./CPU_RUN__2017_08_04__08_57_00.dat');
 fid = fopen('./CPU_RUN__2017_08_05__22_12_54.dat');
 cpu_file = fread(fid, inf);
 start_addr = 1+10+232730+14+4+8+8+4+4;
 period = 14+4+2064408+358;
 n_packets = 25;
 current_packet = 1;
 pdm_size = 2304;
 %pdm_array = zeros(pdm_size, n_packets);
 for i=start_addr:period:(start_addr+period*(n_packets-1))
     current_packet
     i
     pdm_array(:, current_packet) = cpu_file(i:i+pdm_size-1);
    current_packet = current_packet + 1;
 end