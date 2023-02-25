function initializeQP(obj)

% Pull out some information from the obj
TestContrastSet = obj.TestContrastSet;
psiParamsDomainList = obj.psiParamsDomainList;
simulateResponse = obj.simulateResponse;
verbose = obj.verbose;

% Handle simulation and the outcome function
if simulateResponse
    simulatePsiParams = obj.simulatePsiParams;
    qpOutcomeF = @(x) qpSimulatedObserver(x,@qpPFWeibullLog,simulatePsiParams);
else
    qpOutcomeF = [];
end

% Create the Quest+ varargin
qpKeyVals = { ...
    'stimParamsDomainList',{TestContrastSet}, ...
    'psiParamsDomainList',psiParamsDomainList, ...
    'qpPF',@qpPFWeibullLog, ...
    'qpOutcomeF',qpOutcomeF, ...
    'nOutcomes', 2, ...
    'verbose',verbose};

% Alert the user
if verbose
    fprintf('Initializing Quest+\n')
end

% Perform the initialize operation
obj.questData = qpInitialize(qpKeyVals{:});

end