%%
clear all; clc
[scData, timepoints] = loadScRNAseqData();
timepoints = timepoints-min(timepoints);
[scData_num,numEntities,cell_types] = cat2idx(scData);
disp('Finished Loading Data');

%%
clc;
TimeSeriesData = scData_num; %Single Cell data across timepoints
numTriesOpt = 50; % Number of times to repeat optimization starting from random seed.
trans_constr = []; % Constraints on transition rates. Format is [StateA StateB LowerBound Upper Bound]
% trans_constr = genSelfTransConstraints(1:numEntities); %Auto generate self transition constraints to be > 0.5 for all states
solveForBD = 0;  % Change to 1 is it is required to solve for prolif parameters.
bd_vector = [];  % Use if Prolif parameters for each state are known.
bd_constr = [];  % Use if needed to estimate Prolif parameters. Format is [State Lowerbound UpperBound]
errorTerm = 1;   % 1 = least squares, 2 = L1 norm, 3 = Least trimmed squares.
lts_frac = [];   % Required if error_term = 3. Suggested values = 0.8
solveType = 2;   % 1 = no resampling, 2 = resampling from SC data, 3 = resampling from popFrac data
numSim = 500; % Number of iterations (pseudosamples) for resampling
bootstrapSize = 100; % Number of cells in each pseudosample
scStateDef = genScDefForClusterData(numEntities); % Required when thresholds are needed to categorise raw SC data into states.

%%
tic;
if solveType==1
    popFrac = [];
    for i = 1:length(timepoints)
        tmpFrac = getPopFrac(scStateDef,scData_num{1,i});
        popFrac = [popFrac tmpFrac];
    end
    [transMat,bd_solved] = runSimulation(numEntities,popFrac,timepoints,numTriesOpt,trans_constr,solveForBD,bd_vector,bd_constr,errorTerm,lts_frac,solveType,numSim,bootstrapSize,scStateDef);
else
    [transMat,bd_solved] = runSimulation(numEntities,TimeSeriesData,timepoints,numTriesOpt,trans_constr,solveForBD,bd_vector,bd_constr,errorTerm,lts_frac,solveType,numSim,bootstrapSize,scStateDef);
end
toc
%%
ms_tm = getMeanStdTransMat(transMat);
% save('test_2_ms_tm.mat', 'ms_tm')
plotTmHist(transMat);
