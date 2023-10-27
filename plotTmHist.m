function plotTmHist(transMat)
l = size(transMat,2);
numEntities = sqrt(l);
figure;
for i = 1:l
    subplot(numEntities,numEntities,i);
    histogram(transMat(:,i));
    xlabel('Transition probability');
end
end