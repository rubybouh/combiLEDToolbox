function collectTrial(obj)

% Determine if we are simulating the stimuli
simulateStimuli = obj.simulateStimuli;

% Pull out the stimulus frequency and contrast
stimFreqHz = obj.stimFreqHz;
stimContrastAdjusted = obj.stimContrastAdjusted;

% Prepare the sounds
Fs = 8192; % Sampling Frequency
dur = 0.1; % Duration in seconds
t  = linspace(0, dur, round(Fs*dur));
lowTone = sin(2*pi*500*t);
midTone = sin(2*pi*750*t);
highTone = sin(2*pi*1000*t);
readySound = [lowTone midTone highTone];
audioObjs.ready = audioplayer(readySound,Fs);
audioObjs.finished = audioplayer(fliplr(readySound),Fs);

% Handle verbosity
if obj.verbose
    fprintf('Trial %d; Freq [%2.2f Hz], contrast [%2.4f]...', ...
        obj.pupilObj.trialIdx,obj.stimFreqHz,obj.stimContrast);
end

% Present the stimuli
if ~simulateStimuli

    % Alert the subject the trial is about to start
    audioObjs.ready.play;
    stopTime = tic() + 1e9;

    % While we are waiting, configure the CombiLED
    obj.CombiLEDObj.setContrast(stimContrastAdjusted);
    obj.CombiLEDObj.setFrequency(stimFreqHz);
    obj.CombiLEDObj.setAMIndex(2); % half-cosine ramped
    obj.CombiLEDObj.setAMFrequency(obj.amFreqHz);
    obj.CombiLEDObj.setAMPhase(pi);
    obj.CombiLEDObj.setAMValues([obj.halfCosineRampDurSecs, 0]);
    obj.CombiLEDObj.setDuration(obj.trialDurationSecs)

    % Finish waiting
    obj.waitUntil(stopTime);

    % Set the video recording in motion, and wait 250 msecs to cover the
    % file and communication latency
    obj.pupilObj.recordTrial;
    obj.waitUntil(tic() + 1e9);

    % Set the ssVEP recording in motion using a parfeval so it occurs in
    % the background
    p = gcp();
    parevalHandle = parfeval(p,@obj.vepObj.recordTrial,1);

    % Start the stimulus
    stopTime = tic() + obj.trialDurationSecs*1e9;
    obj.CombiLEDObj.startModulation;

    % Wait for the trial duration
    obj.waitUntil(stopTime);

    % Store the ssVEP data
    [~,vepDataStruct]=fetchNext(parevalHandle);
    obj.vepObj.storeTrial(vepDataStruct);

    % Play the finished tone
    audioObjs.finished.play;
    obj.waitUntil(tic() + 1e9);
    
end

% Finish the line of text output
if obj.verbose
    fprintf('\n');
end

end