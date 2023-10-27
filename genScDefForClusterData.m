function scStateDef = genScDefForClusterData(numEntities)
scStateDef = cell(numEntities,1);
for i = 1:numEntities
    tmp{1,1} = 1;
    tmp{1,2} = 3;
    tmp{1,3} = i;
    tmp{1,4} = [];
    scStateDef{i,1} = tmp;
end