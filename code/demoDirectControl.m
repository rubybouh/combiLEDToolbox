
% Open a CombiLEDcontrol object
obj = CombiLEDcontrol();

% By default, gamma correction is not performed in directMode. Here we turn
% gamma correction on.
obj.setDirectModeGamma(true);

% A default gamma table will be used. One could load a cal file and send 
% the measured gamma table using the commands below:
%{
    cal = selectCal();
    obj.setGamma(cal.processedData.gammaTable);
%}

% Device settings are given as a vector of floats in the range of 0-1.
mySettings = [0.5,0,0,0,0,0,0,0];

% Send the settings
obj.setPrimaries(mySettings);
pause

% Close the device
obj.serialClose;
clear obj
