function [out, lcist] = calib16(s,threshold, baseline, ROR)
correct  = 0;
Dlist    = [-4.5 -2.5 -1.5 -.5 -6.5 -3.0 -2.0 -1.0 0 -3.5 -2.5 -1.5 -.5 -3.5 -2.5 -1.5];
Tmax     = threshold + 3;
list0    = Tmax + Dlist;
bias     = .1/3; %Deg per delta dg
list     = list0;
if correct ==1
list     = list0 - abs(list0-baseline).*bias;
end
Tplateau = 5;
fprintf('Your temperature list is the following: \n')
list(:)'
fprintf('-----------------------------------------------\n')
prompt = 'Press 1 to accept, 0 to enter debugging mode. \n';
x = input(prompt);
fprintf('-----------------------------------------------\n')

if x ==0
    keyboard;
end
if strcmp(s.Status,'closed')
    fopen(s)
end
% start thermode communication
serialcom(s,'DIAG',[],'verbose');
serialcom(s,'T',baseline,'wverbose');
pause(.5);
serialcom(s,'ROR',ROR,'verbose');
pause(.5);
fprintf('-----------------------------------------------------------------\n')
prompt = 'Press 1 to send Start-Trigger, press 0 to enter debugging mode. \n';
x = input(prompt);
fprintf('-----------------------------------------------------------------\n')
if x == 0
    keyboard;
elseif x == 1
    serialcom(s,'START',[],'verbose');
else 
    fprintf('Need to enter 1 or 0.\n')
end
c = 0;
for l = list(:)'
    c = c + 1;
    fprintf('Starting Trial %02d / %02d with Temp: %5.2f C. corr. to %5.2f C. \n',c,length(list),list0(c),list(c))
    serialcom(s,'SET',l);
    pause(Tplateau);
    serialcom(s,'SET',baseline);
    pause(5);
end

fprintf('-----------------------------------------------------\n')
fprintf('Finished with temperature list, please stop thermode!\n')
fprintf('-----------------------------------------------------\n')
end
