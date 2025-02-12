function fid = write_header(header, file)
% artia.mrc.write_header writes the header of an MRC-file.
%
% Parameters:
%   header (struct):
%       Matlab struct containing the MRC-header sections as fields.
%
%   fileName (str/fileID):
%       1. String input: Path to the file.
%       2. File ID input: Matlab file ID to an opened file.
%
% Returns:
%   fid (fileID):
%       Matlab file ID to the file.
%
% Author:
%    UE, 2019
%

    if ischar(file)
        fid = fopen(file,'w','ieee-le');
    else
        fid = file;
    end
        
    header_fmt = artia.mrc.header_fmt();
    names = fieldnames(header_fmt);
    
    % Set up FEI extended header writing
    header.next = 1024 * 32 * 4;
    header.extended = artia.mrc.ext2arr(header.extended);
    header_fmt.extended{3} = 'float32';
    
    for i = 1:numel(names)
        fwrite(fid, header.(names{i}), header_fmt.(names{i}){3});
    end
    
    
    % Close file if filename was supplied
    if ischar(file)
        fclose(fid);
        fid = [];
    end
end