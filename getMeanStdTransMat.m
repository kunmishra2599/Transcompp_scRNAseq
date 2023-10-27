function ms_tm = getMeanStdTransMat(transMat)

m_tm = mean(transMat);
s_tm = std(transMat);
l = length(m_tm);
numEntities = sqrt(l);
tmp = cell(1,l);
for i = 1:length(m_tm)
    tmp{1,i} = [num2str(m_tm(i),3),' +/- ',num2str(s_tm(i),3)];
end

ms_tm = reshape(tmp,numEntities,numEntities)';
end