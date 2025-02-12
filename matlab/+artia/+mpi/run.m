function [status, result] = run(command, nodes, config, varargin)
% artia.mpi.run executes Artiatomi tools using mpiexec locally orr
% remotely.
%
% Parameters:
%   command (str):
%       The command to execute.
%   nodes (int):
%       The number of nodes to run the command on.
%   config (str):
%       Path to the config file for this command.
%
% Name Value Pairs:
%   suppressOutput (bool):
%       If true, output of the command being run is not printed in the
%       MATLAB command window.
%   runRemote (bool):
%       If true, command is run using ssh on the host provided in Name
%       Value Pair remoteHost. Requires passwordless ssh setup.
%   remoteHost (str):
%       The remote host to run the command on.
%   execDir (str):
%       Directory where the process should be run.
%
% Returns:
%   status (int): 
%       The status code returned from the execution.
%   result (str):
%       The standard output of the command.
%
% Author:
%   UE, 2019

    % Default params
    defs = struct();
    defs.suppressOutput.val = true;
    defs.runRemote.val = false;
    defs.remoteHost.val = '';
    defs.execDir.val = '';
    artia.sys.getOpts(varargin, defs);
    
    com = sprintf('mpiexec -n %d %s -u %s', nodes, command, config);
    
    if ~isempty(execDir)
        com = sprintf('cd %s; %s', execDir, com);
    end
    
    if runRemote
        com = sprintf('ssh -t %s "%s"', remoteHost, com);
    end
    
    if suppressOutput
        [status, result] = system(com);
    else
        system(com)
    end
end

