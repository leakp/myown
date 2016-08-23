function [out, list] = calib16(s,threshold, baseline, ROR)

Dlist    = [-4.5 -2.5 -1.5 -.5 -6.5 -3.0 -2.0 -1.0 0 -3.5 -2.5 -1.5 -.5 -3.5 -2.5 -1.5];
Tmax     = threshold + 3;
list     = Tmax + Dlist;
Tplateau = 5;
fprintf('Your Temperaturelist is the following: \n')
list(:)
prompt = 'Press 1 to accept, 0 to enter debugging mode. \n';
x = input(prompt);
if x ==0
    keyboard;
end
% start thermode communication
serialcom(s,'DIAG',[],'verbose');
serialcom(s,'T',baseline,'verbose');
pause(.5);
serialcom(s,'ROR',ROR,'verbose');
pause(.5);
prompt = 'Press 1 to send Start-Trigger, press 0 to enter debugging mode. \n';
x = input(prompt);
if x == 0
    keyboard;
elseif x == 1
    serialcom(s,'START',[],'verbose');
else 
    fprintf('Need to enter 1 or 0.\n')
end
for l = list(:)'
    serialcom(s,'SET',l);
    pause(Tplateau);
end

end
