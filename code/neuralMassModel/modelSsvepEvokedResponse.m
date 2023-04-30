function [spdStim,spdRest,freqSupportHz,temporalResponseStim,temporalResponseRest,temporalSupportSecs] = modelSsvepEvokedResponse(params,stimFreqHz,stimAmplitude,varargin)
%
%
%
%{
    params = [32,3,50,7,-2,50];
    stimFreqHz = [4,6,10,14,20,28,40];
    stimAmplitude = 100;
    figure
    for ii = 1:length(stimFreqHz)
        [spdStim,spdRest,freqSupportHz] = modelSsvepEvokedResponse(params,stimFreqHz(ii),stimAmplitude);
        plot(log10(freqSupportHz),spdStim-spdRest,'-');
        hold on
    end
%}

% Parse the parameters
p = inputParser; p.KeepUnmatched = false;
p.addParameter('mdl','alpha_mod_stimulation',@ischar);
p.addParameter('modelDurSecs',3,@isscalar);
p.addParameter('censorIdx',500,@isscalar);
p.addParameter('nSims',10,@isscalar);
p.parse(varargin{:})

censorIdx = p.Results.censorIdx;

% Define the identity of and path to the simulink model
mdl = p.Results.mdl;
mdlPath = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))),'simulink',[mdl '.slx']);

% Load the model into memory in the background
mdlHandle = load_system(mdlPath);

% Unpack the params
c1Gain = params(1);
c2Gain = params(2);
sigMax = params(3);
sigHalfPoint = params(4);
sigSlope = params(5);
inputNoiseAmplitude = params(6);

% Set the period of time to be modeled, in seconds
set_param(mdl,'StopTime',num2str(p.Results.modelDurSecs));

% Set the stimulation frequency
set_param(fullfile(mdl,"Signal Generator"),"Frequency",num2str(stimFreqHz));

% Set the connectivity params
set_param(fullfile(mdl,"C1"),"Gain",num2str(c1Gain));
set_param(fullfile(mdl,"C2"),"Gain",num2str(c2Gain));

% Set the sigmoid function
sigExpression = sprintf("%d*(1 + exp((u(1) - %d)/(%d)))^(-1)",sigMax,sigHalfPoint,sigSlope);
set_param(fullfile(mdl,"Fcn1"),"Expression",sigExpression);
set_param(fullfile(mdl,"Fcn2"),"Expression",sigExpression);

% Set the input noise
set_param(fullfile(mdl,"Input noise","Gain5"),"Gain",num2str(inputNoiseAmplitude));

% Loop over the requested number of simulations
for ii = 1:p.Results.nSims

    % Update the noise seed so that we obtain different simulated responses
    set_param(fullfile(mdl,"Input noise","WN"),"Seed",num2str(round(rand*1e7)));

    % Obtain the output with stimulation
    set_param(fullfile(mdl,"Signal Generator"),"Amplitude",num2str(stimAmplitude));
    simIn = Simulink.SimulationInput(mdl);
    simOut = sim(simIn);
    outputTimeDomainStim(ii,:) = simOut.signal(censorIdx:end,2);

    % Obtain the output without stimulation
    set_param(fullfile(mdl,"Signal Generator"),"Amplitude","0");
    simIn = Simulink.SimulationInput(mdl);
    simOut = sim(simIn);
    outputTimeDomainRest(ii,:) = simOut.signal(censorIdx:end,2);

    % Get the temporal support of the output
    temporalSupportSecs = simOut.signal(censorIdx:end,1);

    % Get the deltaT of the output
    deltaTSecs = diff(temporalSupportSecs(1:2));

    % Obtain the Fourier transforms
    [freqSupportHz, outputAmpStim(ii,:)] = simpleFFT( outputTimeDomainStim(ii,:)-mean(outputTimeDomainStim(ii,:)), 1/deltaTSecs);
    [~, outputAmpRest(ii,:)] = simpleFFT( outputTimeDomainRest(ii,:)-mean(outputTimeDomainRest(ii,:)), 1/deltaTSecs);
end

% Obtain the average temporal response
temporalResponseStim = mean(outputTimeDomainStim);
temporalResponseRest = mean(outputTimeDomainRest);

% Obtain the average power spectrum
spdStim = (mean(outputAmpStim).^2)./size(outputAmpStim,2);
spdRest = (mean(outputAmpRest).^2)./size(outputAmpRest,2);

% Nan the first dc offset value of the spds
spdStim(1)=nan;
spdRest(1)=nan;

% Close the simulink model
bdclose(mdlHandle);

end