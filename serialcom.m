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
mspb = 11/s.BaudRate; %muS per byte (comes from baudrate) (1/BaudRate * 11 bits per byte)


% clear buffer by reading out potential leftovers
while s.BytesAvailable ~= 0
    fread(s,s.BytesAvailable);
    warning('Detected and cleaned buffer leftovers...')
end

% differentiate between command types, e.g. 'DIAG' vs 'T;32', what to send
% via the serial port.
if any(strcmp(cmd,{'HELP','DIAG','START'}))
    fprintf(s,cmd);
    fprintf('Sending command %s. \n',cmd)
elseif any(strcmp(cmd,{'T','RoR','SET','MOVE'}))
    cmdstr = [cmd ';' num2str(varargin{1})];
    fprintf(s,cmdstr);
    fprintf('Sending command %s. \n',cmdstr)
end

% ensure to wait long enough to get back the Arduino's response (if wanted)
if length(varargin) ==2
    switch cmd
        case 'DIAG'
            ws = 70*mspb;
            fprintf('%s, waiting %g seconds to allow Arduino response.\n',cmd,ws)
            pause(ws)
        case 'HELP'
            ws = 326*mspb;
            fprintf('%s, waiting %g seconds to allow Arduino response.\n',cmd,ws)
            pause(ws)
        case 'T'
            ws = 25*mspb;
            fprintf('%s, waiting %g seconds to allow Arduino response.\n',cmd,ws)
            pause(ws)
        case 'RoR'
            ws = 18*mspb;
            fprintf('%s, waiting %g seconds to allow Arduino response.\n',cmd,ws)
            pause(ws)
        case 'START'
            ws = 6*mspb;
            fprintf('%s, waiting %g seconds to allow Arduino response.\n',cmd,ws)
            pause(.05)
        case 'MOVE'
            ws = 24*mspb;
            fprintf('%s, waiting %g seconds to allow Arduino response.\n',cmd,ws)
            pause(ws)
        case 'SET'
            ws = 52*mspb;
            fprintf('%s, waiting %g seconds to allow Arduino response.\n',cmd,ws)
            pause(ws)
    end
end
%read out Arduino's response from buffer

try
    out = char(fread(s,s.BytesAvailable))'; %reads as many bytes as stored in buffer
    if strcmp(varargin{end},'verbose')
        fprintf('%s \n',out)
    end
catch
    % e.g. if buffer is empty
    fprintf('Problem with s.BytesAvailable... \n')
end
end
