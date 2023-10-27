function [scData_num,numEntities,cell_types] = cat2idx(scData)
l = length(scData);
scData_num = cell(1,l);
cell_types = {};
for i = 1:l
    tmp = scData{1,i};
    cell_types = unique([cell_types;tmp(2:end)]);
end
numEntities = length(cell_types);

for i = 1:l
    tmp = scData{1,i};
    tmp2 = [cell_types;tmp(2:end)];
    g = grp2idx(tmp2);
    scData_num{1,i} = g((numEntities+1):end);
end
end