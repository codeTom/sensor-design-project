function [data] = dataTransfer (arduino, N)
  i = 1; %iterator
  value = ""; %value being read in
  data = zeros(N,4); %empty data array N x num_terms
  flush(arduino); %flush send/receive buffer
while i < N+1
  in_data = fread(arduino, 1); %read in 1 byte at a time
  if(in_data != 13) %if not end of line
    value = strcat(value,in_data); %append byte to data
  else
    temp = strsplit(value,","); %split csv
    data(i,:) = str2double(temp); %convert csv to double
    i = i+1; %increment
    value = ""; %reset value
  end
end
return;
endfunction
