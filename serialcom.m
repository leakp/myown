function [out] = serialcom(s,cmd,varargin)
% SERIALCOM allows talking to an Arduino via an established serial
% connection. Possible inputs for CMD are 'HELP','DIAG','START', without
% optional input, and 'T','RoR','SET' and 'MOVE' with corresponding
% temperature ('T','RoR','SET', in format [xx.xx]) or time ('MOVE', [ms]).

% Examples for usage:
% serialcom(s,'HELP')
% serialcom(s,'DIAG')
% serialcom(s,'START')
% serialcom(s,'T',35.00)
% serialcom(s,'RoR',10.00)
% serialcom(s,'SET',38.50)
% serialcom(s,'MOVE',1000) to move up for 1000 ms
%
% While the first varargin is thus expected (if applicable) to be the
% input for setting temperatures and raise durations, a second input can be
% 'verbose', when response from Arduino is wanted as output e.g.:
% out = serialcom(s,'T',35,'verbose')
% out = serialcom(s,'HELP',[],'verbose')
out  = [];
buffer_warn  = 0;
suppress_out = 0; %suppress output even for DIAG and HELP
% mspb = 11/s.BaudRate; %muS per byte (comes from baudrate) (1/BaudRate * 11 bits per byte)


% clear buffer by reading out potential leftovers
while s.BytesAvailable ~= 0
    fread(s,s.BytesAvailable);
    if buffer_warn
        warning('Detected and cleaned buffer leftovers...')
    end
end

% differentiate between command types, e.g. 'DIAG' vs 'T;32', what to send
% via the serial port.
if any(strcmp(cmd,{'HELP','DIAG','START'}))
    fprintf(s,cmd);
    fprintf('Sending command %s. \n',cmd)
elseif any(strcmp(cmd,{'T','ROR','SET','MOVE'}))
    cmdstr = [cmd ';' num2str(varargin{1})];
    fprintf(s,cmdstr);
    fprintf('Sending command %s. \n',cmdstr)
end

if any(strcmp(cmd,{'HELP','DIAG',}))
    fprintf('Asked for %s, waiting %g seconds for Arduino response.\n',cmd,.5)
    pause(.5)
    if ~suppress_out
        fprintf('%s \n',char(fread(s,s.BytesAvailable))')
    end
end
% ensure to wait long enough to get back the Arduino's response (if wanted)
if length(varargin) == 2
    ws = .2;
    fprintf('Verbose wanted, waiting %g seconds for Arduino response.\n',ws)
    pause(ws)
    %read out Arduino's response from buffer
    try
        out = char(fread(s,s.BytesAvailable))'; %reads as many bytes as stored in buffer
        if ~suppress_out
            fprintf('%s \n',out)
        end
    catch
        % e.g. if buffer is empty
        warning('Problem with s.BytesAvailable, reading buffer was not successful... \n')
    end
end
end
