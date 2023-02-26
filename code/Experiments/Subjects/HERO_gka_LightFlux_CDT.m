% In these experiments we will work with this overall frequency set:
%   freq = [1, 2, 3, 4, 5, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40];
%
% For the LMS studies, we will operate in the high range. We will obtain
% CDTs for:
%   testFreqSetHz = [4,6,10,14,20,28,40]
%
% and then perform discrimination judgements with:
%   testFreqSetHz = [6,10,14,20,28]
%   refFreqSetHz = [4, 5, 6, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40];

subjectID = 'HERO_gka';
modDirection = 'LightFlux';
testFreqSetHz = [4,6,10,14,20,28,40];
observerAgeInYears = 53;
pupilDiameterMm = 3;
runDetectThreshExperiment(subjectID,modDirection,...
    observerAgeInYears,pupilDiameterMm,...
    'testFreqSetHz',testFreqSetHz);
