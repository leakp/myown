
%%
vec = NaN(1,100);
n =0;
while 1
   n = n + 1;
   value = readVoltage(a,2);
   vec(1,mod(n-1,100)+1) = value;
   plot(vec);
   ylim([-5 5]);
   drawnow;
end


a = arduino();
addrs = scanI2CBus(a)
mlx = i2cdev(a, addrs{:})
write(mlx, 0, 'uint8');
data = read(mlx, 2, 'uint8')
temperature = (double(bitshift(int16(data(1)), 4)) + double(bitshift(int16(data(2)), -4))) * 0.0625
%%
s = serial('COM4','BaudRate',19200)
fopen(s)

list = [1 2 4 5 6];
for i = 1:50
    i
  fwrite(s, i);
  rx(i) = fread(s, 1);
end
rx
clear rx
%%
s = serial('COM4','BaudRate',19200)
fopen(s)
fprintf(s,'DIAG')
out = fscanf(s);
while ischar(out)
    disp(out)
    out = fscanf(s);
end
fclose(s)
%%
s = serial('COM4','BaudRate',19200)
fopen(s)
fread(s,s.BytesAvailable);pause(.1);
fprintf(s,'T;35');
out = char(fread(s,s.BytesAvailable))'
fprintf(s,'T;33.70')
out = char(fread(s,s.BytesAvailable))'
fprintf(s,'ROR;10.00')

%% test how long sending/reading takes
fclose(s)
s.BytesAvailableFcn = @mycallback;
s.BytesAvailableFcnCount = 33; %DIAG: 68, HELP: 326, START: 6, T: 25, ROR: 18, MOVE: 24, SET: 33.
s.BytesAvailableFcnMode  = 'byte';
fopen(s)
fprintf(s,'T;32.00');
fprintf(s,'ROR;10.00');
char(fread(s,s.BytesAvailable))'
fprintf(s,'DIAG');
char(fread(s,s.BytesAvailable))'
global t
tic;
fprintf(s,'T;10.00')
if mod(s.ValuesSent,8)==0
    toc
end
pause(.5)
fread(s,s.BytesAvailable);

%%
clear all
addpath('C:\Users\Lea\Documents\GitHub\myown\')
global s
s = serial('COM4','BaudRate',19200)
fopen(s)
list = randsample(32:45,10,'true');
runarduino(s,list);
fclose(s)
clear all;
