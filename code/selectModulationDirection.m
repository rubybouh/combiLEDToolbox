function [whichReceptorsToTarget,whichReceptorsToIgnore,desiredContrast] = ...
    selectModulationDirection(whichDirection)

%% Define the receptor sets to isolate
% I consider the following modulations:
%   LMS -   Equal contrast on the peripheral cones, silencing Mel, as
%           this modulation would mostly be used in conjunction with
%           light flux and mel stimuli
%   LminusM - An L-M modulation that has equal contrast with eccentricity.
%           Ignore mel.
%   S -     An S modulation that has equal contrast with eccentricity.
%           Ignore mel.
%   Mel -   Mel directed, silencing peripheral but not central cones. It is
%           very hard to get any contrast on Mel while silencing both
%           central and peripheral cones. This stimulus would be used in
%           concert with occlusion of the macular region of the stimulus.
%   SnoMel- S modulation in the periphery that silences melanopsin.

switch whichDirection
    case 'LminusM_wide'
        whichReceptorsToTarget = [1 2 4 5];
        whichReceptorsToIgnore = 10;
        desiredContrast = [1 -1 1 -1];
    case 'LminusM_foveal'
        whichReceptorsToTarget = [1 2];
        whichReceptorsToIgnore = [4 5 7 8 9 10];
        desiredContrast = [1 -1];
    case 'L_wide'
        whichReceptorsToTarget = [1 4];
        whichReceptorsToIgnore = [7 8 9 10];
        desiredContrast = [1 1];
    case 'L_foveal'
        whichReceptorsToTarget = [1];
        whichReceptorsToIgnore = [4 5 7 8 9 10];
        desiredContrast = [1];
    case 'M'
        whichReceptorsToTarget = [2 5];
        whichReceptorsToIgnore = [7 8 9 10];
        desiredContrast = [1 1];
    case 'S_wide'
        whichReceptorsToTarget = [3 6];
        whichReceptorsToIgnore = [7 8 9 10];
        desiredContrast = [1 1];
    case 'S_foveal'
        whichReceptorsToTarget = [3];
        whichReceptorsToIgnore = [6 7 8 9 10];
        desiredContrast = [1];
    case 'PenumbralLuminance'
        whichReceptorsToTarget = [4 5 7 8];
        whichReceptorsToIgnore = [10];
        desiredContrast = [-1 -1 1 1];
    case 'CenterPeriphery'
        whichReceptorsToTarget = [1 2 3 4 5 6];
        whichReceptorsToIgnore = [7 8 9 10];
        desiredContrast = [-1 -1 -1 1 1 1];
    case 'LMS'
        whichReceptorsToTarget = [1 2 3 4 5 6];
        whichReceptorsToIgnore = [7 8 9 10];
        desiredContrast = [1 1 1 1 1 1];
    case 'Mel'
        whichReceptorsToTarget = 10;
        whichReceptorsToIgnore = [1 2 3 7 8 9];
        desiredContrast = 1;
    case 'SnoMel'
        whichReceptorsToTarget = 6;
        whichReceptorsToIgnore = [1 2 3 7 8 9];
        desiredContrast = 1;
end

end