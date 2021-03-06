%%
% file
%   deltaU.m
%
% author
%   Jingja Xu 
%
% date
%   5/30/2016
%   
% description
%   This function generates a gradient matrix 
%
% inputs
%   nodenum - the number of nodes in the heart
%   path - the path to the index.bin, surnum.bin and delta.bin files
function deltaU (nodenum,path)
    file = strcat(path,'index.bin');
    fid = fopen(file,'rb');
    id = fread(fid,[300,inf],'int');
    fclose(fid);

    file = strcat(path,'surnum.bin');
    fid = fopen(file,'rb');
    surnum = fread(fid,'int');
    fclose(fid);

    file = strcat(path,'delta.bin');
    fid = fopen(file,'rb');
    delta = fread(fid,[3*nodenum,inf],'double');
    fclose(fid);

    delta = delta';

    ndelta = zeros(nodenum,3*nodenum);

    for i = 1:nodenum
        for j = 1:surnum(i)
            ndelta(id(j,i),3*i-2:3*i) = delta(j,3*i-2:3*i);
        end
    end
    ndelta = ndelta';

    dtx2 = zeros(nodenum,nodenum);
    dty2 = zeros(nodenum,nodenum);
    dtz2 = zeros(nodenum,nodenum);
    for i = 1:nodenum
        dtx2(i,:) = (ndelta(i*3-2,:));
        dty2(i,:) = (ndelta(i*3-1,:));
        dtz2(i,:) = (ndelta(i*3,:));
    end

    deltasort(1:nodenum,1:nodenum) = dtx2;
    deltasort(nodenum+1:2*nodenum,1:nodenum) = dty2;
    deltasort(2*nodenum+1:3*nodenum,1:nodenum) = dtz2;

    file = strcat(path,'deltasort.bin');
    fid = fopen(file,'wb');
    fwrite(fid,deltasort,'double');
    fclose(fid);
end
