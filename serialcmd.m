function out = serialcmd(s,cmd,varargin)
% clear buffer by reading potential leftovers
while s.BytesAvailable ~= 0
    fread(s,s.BytesAvailable);
    fprintf('Cleaned leftovers... \n')
end
% differentiate between command types, e.g. 'DIAG' vs 'T;32')
if nargin <3
    fprintf(s,cmd);
elseif nargin == 3
    cmdstr = [cmd ';' num2str(varargin{1})];
    fprintf(s,cmdstr);pause(.05)
end
try
    out = char(fread(s,s.BytesAvailable))';
    fprintf('%s \n',out)
catch
    fprintf('Problem with s.BytesAvailable... \n')
end
end
