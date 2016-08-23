function runarduino(s,list)
baseline = 35;
ROR      = 10;
Tplateau = 5;
fprintf('Your temperature list is the following: \n')
list(:)'
prompt = 'Press 1 to accept, 0 to enter debugging mode. \n';
x = input(prompt);
if x ==0
    keyboard;
end
% start thermode communication
serialcom(s,'DIAG');
serialcom(s,'T',baseline,'verbose');
pause(.5);
serialcom(s,'ROR',ROR,'verbose');
pause(.5);
prompt = 'Press 1 to send Start-Trigger to Thermode, press 0 to enter debugging mode. \n';
fprintf('-----------------------------------------------------------------------------\n')
x = input(prompt);
fprintf('-----------------------------------------------------------------------------\n')
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
    fprintf('Starting Trial %02d / %02d with Temp: %5.2f C. \n',c,length(list),l)
    serialcom(s,'SET',l);
    pause(Tplateau);
end
serialcom(s,'SET',baseline,'verbose');
fprintf('-----------------------------------------------------\n')
fprintf('Finished with temperature list, please stop thermode!\n')
fprintf('-----------------------------------------------------\n')
end
