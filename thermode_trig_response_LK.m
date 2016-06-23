function [log] = thermode_trig(temp_list)
% use "mouse port adapter" to define thermode temperatures via matlab
% needed scripts to send trigger: config_io.m, outp.m
% Medoc sequence
%
% script by Arvina Grahl, University Medical Center Hamburg-Eppendorf (UKE)
% April 2016
% 
% CAVE 64bit computer:
% io64.mexw64 (same folder as config_io.m & outp.m) & inpoutx64.dll files 
% needed (for windows: copy inpoutx64.dll file to C:\WINDOWS\SYSTEM32 directory)
% download e.g.: http://apps.usd.edu/coglab/psyc770/IO64.html
% 
% NOTES:
% - large temperature slack between matlab & thermode (probably dependent on search rate �C/sec)
% - script very quick & dirty -> timing far away from precise -> optimise by using psychtoolbox
% - currently BNC box needed to use this script -> I will solder a cable with 3 BNCs to parallel port soon


if nargin < 5
    error('Not enough input arguments. Please enter a temperature vector!');
end

portAdd     = hex2dec('378'); % parallel port
trigAllPins = 255;
trig_high   = 2; % Pin 2 higher
trig_low    = 4; % Pin 3 lower
trig_go     = 8; % Pin 4 send manual trigger
sequDur_sec = 600; % duration of whole Medoc Search sequence (in sec)
degrees_sec = 10; % search rate (°C/sec)
wait_sec    = []; % open pin in seconds
base_temp   = 32; % baseline temperature in °C
trial_dur   = 8; % duration of each trial in seconds
iti_dur     = 8; % duration of inter stimulus interval in seconds
therm_diff  = 0; % time lack between script & thermode in °C
temp_corr   = temp_list-therm_diff; % trials within 10 min sequence
log         = [];

config_io64; % load driver

outp64(portAdd,0); % set currents of all pins to zero

%%%%%%%%%%%%%%%% for testing purpose only
fprintf(['\n%%%%%%%%%%%%%%\nPress any button to start sequence (' num2str(sequDur_sec/60) ' min)\n%%%%%%%%%%%%%%\n']);
pause('on'); commandwindow; pause; 
%%%%%%%%%%%%%%%%

timestamp = datestr(now,30);
fprintf(['Experiment start: ' timestamp '\n']);

trig_manual; % start sequence -> due to maximum duration in "Medoc Search" is 10 min

pause(2); % wait 2 sec 
for trial = 1:size(temp_corr,2)
    wait_sec = (temp_corr(trial)-base_temp)/degrees_sec; % calc seconds needed to reach temperature
    log.rise_sec(1,trial) = wait_sec; % log wait_sec per trial
    fprintf(['\ntrial no.: ' num2str(trial) ', temperature °C: ' num2str(temp_list(trial)) '(corr.°C:' num2str(temp_corr(trial)) '), sec to rise: ' num2str(wait_sec) '\n']);
    higher_temp; % send temperature (time to rise = wait_sec)
    pause(trial_dur-wait_sec); % duration until offset -> start back to baseline
    lower_temp; % go back to baseline
    
    pause(iti_dur);
end

log.temp_list = temp_list;
log.temp_corr = temp_corr;




% ------------------------------------------------------------------------
    function trig_manual
        % send trigger for baseline trial
        outp(portAdd,trig_go); % send manual trigger
        pause(.001); % wait for xy sec
        outp(portAdd,0);
    end

    function higher_temp
        outp(portAdd,trig_high); % send higher
        pause(wait_sec); % wait for xy sec
        outp(portAdd,0);
    end

    function lower_temp
        outp(portAdd,trig_low); % send lower
        pause(wait_sec); % wait for xy sec
        outp(portAdd,0);
    end

end