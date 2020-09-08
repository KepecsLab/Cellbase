function quickAnalysis_CuedOutcome(animalID,sessionID,sessionspec,protocoltag)
%QUICKANALYSIS2   Analysis of tetrode data.
%   QUICKANALYSIS2 is designed as an offline analysis tool for tetrode data
%   and behavior, which can be executed in an unsupervised manner on a
%   daily bases. It gives a quick overview of the experiment including
%   response profiles of clustered neurons, light-triggered PSTH and
%   psychometric plots of behavior. It relies on CellBase data handling
%   system.
%
%   QUICKANALYSIS2(ANIMALNO,SESSIONID,SESSIONSPEC) performs the analysis
%   for a session specified by the first two input arguments. SESSIONSPEC
%   should be a 1x3 logical array indicating the need for behavior,
%   recording and stimulation analysis.
%ju
%   QUICKANALYSIS2(ANIMALNO,SESSIONID,SESSIONSPEC,PROTOCOLTAG) accepts a
%   PROTOCOLTAG argument to allow calls to trial event conversion programs
%   for different versions of the behavioral protocol.
%
%   See also ADDNEWCELLS, PREALIGNSPIKES and VIEWCELL2B.

% Input argument check
error(nargchk(0,4,nargin))

% Behavior, recording or both
if nargin < 4
    protocoltag = '';
end
if nargin < 3
    isbeh = 1;
    isrec = 1;
    isstim = 1;
else
    isbeh = sessionspec(1);
    isrec = sessionspec(2);
    isstim = sessionspec(3);
end

% Animal, session
if nargin < 2
    sessionID = '170909a';
end
if nargin < 1
    animalID2 = 'nb046'; % Note FS- why two of these?
    animalID = 'CD4';
else
%     animalID2 = ['nb0' num2str(animalNO)];
%     animalID = ['n0' num2str(animalNO)];
end

fullpth = [getpref('cellbase','datapath') '\' animalID '\' sessionID '\'];

% Stop if error
dbstop if error

% Directories
% global DATAPATH
% resdir = [DATAPATH 'NB\_response_profiles\' animalID2 '\'];
% if ~isdir(resdir)
%     mkdir(resdir)
% end
% resdir2 = [DATAPATH 'NB\_behavior\' animalID2 '\'];
% if ~isdir(resdir2)
%     mkdir(resdir2)
% end

% Convert events file
if isrec
    nlxcsc2mat2(fullpth,'Channels','Events')
    if isbeh
        TE = makeTE_CuedOutcome_Odor_Complete_Nlx(fullpth);
    end
end

% Create trial events structure
if isbeh
%     if isempty(protocoltag)
%     validTrials = filterTE(TE, 'reject', 0);
    highValueTrials = filterTE(TE, 'trialType', 1:3);%, 'reject', 0);
    lowValueTrials = filterTE(TE, 'trialType', 4:6);%, 'reject', 0);
    uncuedTrials = filterTE(TE, 'trialType', 7:9);%, 'reject', 0);    
    rewardTrials = filterTE(TE, 'trialOutcome', 1);%, 'reject', 0);
    punishTrials = filterTE(TE, 'trialOutcome', 2);%, 'reject', 0);    
    omitTrials = filterTE(TE, 'trialOutcome', 3);%, 'reject', 0);
    trialTypes = 1:9;
    trialsByType = cell(size(trialTypes));
    for counter = 1:length(trialTypes)
        trialsByType{counter} = filterTE(TE, 'trialType', trialTypes(counter));%, 'reject', 0);
    end
    
%% plot lick averages
    h = ensureFigure('Lick_Averages', 1);
%     mcPortraitFigSetup(h);
    mcLandscapeFigSetup(h);
    pm = [2 2];
    
    % cue types
    varargin = {'trialNumbering', 'consecutive',...
        'window', [-4 0], 'zeroField', 'Us', 'startField', 'PreCsRecording', 'endField', 'PostUsRecording'};
    axh = [];
    subplot(pm(1), pm(2), 1); [ha, hl] = plotEventAverageFromTE(TE, {highValueTrials, lowValueTrials, uncuedTrials}, 'Port1In', varargin{:}...
        , 'linespec', {'b', 'r', 'g'});
    legend(hl, {'hival', 'loval', 'uncued'}, 'Location', 'southwest', 'FontSize', 12); legend('boxoff');
    title('Cue Licks'); ylabel('licks (s)'); xlabel('time from reinforcement (s)'); textBox(TE.filename{1}(1:7));  

    % window changed to US
    varargin = {'trialNumbering', 'consecutive',...
        'window', [-1 4], 'zeroField', 'Us', 'startField', 'PreCsRecording', 'endField', 'PostUsRecording'};
    
    % reward
    axh(end + 1) = subplot(pm(1), pm(2), 2); [ha, hl] = plotEventAverageFromTE(TE, trialsByType([1 4 7]), 'Port1In', varargin{:},...
        'linespec', {'b', 'r', 'g'});
    legend(hl, {'hival', 'loval', 'uncued'}, 'Location', 'southwest', 'FontSize', 12); legend('boxoff');
    title('Reward'); ylabel('licks (s)'); xlabel('time r (s)');
    
    % punish
    axh(end + 1) = subplot(pm(1), pm(2), 3); [ha, hl] = plotEventAverageFromTE(TE, trialsByType([2 5 8]), 'Port1In', varargin{:},...
        'linespec', {'b', 'r', 'g'});
    legend(hl, {'hival', 'loval', 'uncued'}, 'Location', 'southwest', 'FontSize', 12); legend('boxoff');
    title('Punish'); ylabel('licks (s)'); xlabel('time r (s)');
    
    % neutral
    % kludge 180801 - getting rid of trial type 9 (uncued neutral)
    axh(end + 1) = subplot(pm(1), pm(2), 4); [ha, hl] = plotEventAverageFromTE(TE, trialsByType([3 6]), 'Port1In', varargin{:},...
        'linespec', {'b', 'r'});%, 'g'});
    legend(hl, {'hival', 'loval'}, 'Location', 'southwest', 'FontSize', 12); legend('boxoff');
    title('Neutral'); ylabel('licks (s)'); xlabel('time r (s)');
    
    sameYScale(axh) % match y scaling
    saveas(h,fullfile(fullpth, ['Lick_Averages.jpg']));  


%% lick rasters
    h = ensureFigure('Lick_Averages', 1);

    mcLandscapeFigSetup(h);
    subplot(1,3,1); 
    eventRasterFromTE(TE, trialsByType{1}, 'Port1In', 'trialNumbering', 'consecutive',...
        'zeroField', 'Us', 'startField', 'PreCsRecording', 'endField', 'PostUsRecording');
    title('hival, reward'); xlabel('time from reinforcement (s)'); ylabel('trial number');
    set(gca, 'XLim', [-6 4]); 
    set(gca, 'YLim', [0 length(find(trialsByType{1}))]);
    set(gca, 'FontSize', 14)

    subplot(1,3,2); 
    eventRasterFromTE(TE, trialsByType{4}, 'Port1In', 'trialNumbering', 'consecutive',...
        'zeroField', 'Us', 'startField', 'PreCsRecording', 'endField', 'PostUsRecording');
    title('lowval, reward'); xlabel('time from reinforcement (s)'); ylabel('trial number');
    set(gca, 'XLim', [-6 4]); 
    set(gca, 'YLim', [0 length(find(trialsByType{4}))]);
    set(gca, 'FontSize', 14)

    subplot(1,3,3); 
    eventRasterFromTE(TE, trialsByType{7}, 'Port1In', 'trialNumbering', 'consecutive',...
        'zeroField', 'Us', 'startField', 'PreCsRecording', 'endField', 'PostUsRecording');
    title('uncued, reward'); xlabel('time from reinforcement (s)'); ylabel('trial number');
    set(gca, 'XLim', [-6 4]); 
    set(gca, 'YLim', [0 length(find(trialsByType{7}))]);
    set(gca, 'FontSize', 14)
    
    saveas(h,fullfile(fullpth, ['Lick_Rasters.jpg']));    
    
    
    

end

% Update CellBase
if isrec
    addnewcells('dir',[animalID filesep sessionID])
    cellids = findcell('rat',animalID,'session',sessionID);
    disp(cellids)
end

% Response profiles
if isbeh && isrec
    % Prealign spikes for trial events
    problem_behav_cellid = [];
    for iC = 1:length(cellids)
        cellid = cellids(iC);
%         try
            prealignSpikes(cellid,'FUNdefineEventsEpochs',@defineEventsEpochs_CuedOutcome,'filetype','event','ifsave',1,'ifappend',0, 'writing_behavior', 'overwrite')
%         catch
%             disp('Error in prealignSpikes.');
%             problem_behav_cellid = [problem_behav_cellid cellid];
%         end
    end
    

    
    % Outcome responses (not grouped by trialType)
    for k = 1:length(cellids)
        H = ensureFigure([cellids{k} '_outcomes'], 1);
        pause(0.01)
        viewcell2b(cellids(k),'TriggerName','Us_start','SortEvent','trialNumber','eventtype','behav','ShowEvents',{'Us_start'},...
            'Partitions','#trialOutcome','window',[-1 4], 'dt', 0.01, 'sigma', 0.02, 'PSTHstd', 'on', 'isadaptive', true);
        formatFigureCellbase;        
%         maximize_figure(H)
        hleg = findobj(H, 'Type', 'legend');
        hleg.String = {'Reward', 'Punish', 'Neutral'};
        
        cellidt = cellids{k};
        cellidt(cellidt=='.') = '_';
        saveas(H,fullfile(fullpth, [cellidt '_Outcome.jpg']));        

    end
    
        % Cue responses
    for k = 1:length(cellids)
        H = ensureFigure([cellids{k} '_cue'], 1);
        pause(0.01)
        viewcell2b(cellids(k),'TriggerName','Cue_start','SortEvent','trialNumber','eventtype','behav','ShowEvents',{'Cue_start'},...
            'Partitions','#cueCondition','window',[-4 3], 'dt', 0.01, 'sigma', 0.02, 'PSTHstd', 'on', 'isadaptive', true);
        formatFigureCellbase;
%         maximize_figure(H)

        
        cellidt = cellids{k};
        cellidt(cellidt=='.') = '_';
        saveas(H,fullfile(fullpth, [cellidt '_Cue.jpg']));        
%         saveas(H,fullfile(fullpth, [cellidt '_Cue.fig']));                        
%         fnm = [resdir cellidt '_HF.jpg'];   % save
%         saveas(H,fnm)
%         close(H)
    end
    
        % Reward responses
    for k = 1:length(cellids)
        H = ensureFigure([cellids{k} '_reward'], 1);
        pause(0.01)
        viewcell2b(cellids(k),'TriggerName','Us_start','SortEvent','trialNumber','eventtype','behav','ShowEvents',{'Us_start'},...
            'Partitions','#trialType: {1 4 7}','window',[-7 4], 'dt', 0.01, 'sigma', 0.02, 'PSTHstd', 'on', 'isadaptive', true);
        formatFigureCellbase;        
%         maximize_figure(H)
        hleg = findobj(H, 'Type', 'legend');
        hleg.String = {'High Value', 'Low Value', 'Uncued'};
        
        cellidt = cellids{k};
        cellidt(cellidt=='.') = '_';
        saveas(H,fullfile(fullpth, [cellidt '_Reward.jpg']));        

    end    
    
    
%     % Hit & FA #2
%     for k = 1:length(cellids)
%         H = figure;
%         pause(0.01)
%         viewcell2b(cellids(k),'TriggerName','DeliverFeedback','SortEvent','PseudoStimulusOn','eventtype','behav','ShowEvents',{{'LeftPortIn'}},'Partitions','#ResponseType','window',[-5 5])
%         maximize_figure(H)
%         
%         cellidt = cellids{k};
%         cellidt(cellidt=='.') = '_';
%         fnm = [resdir cellidt '_HF2.jpg'];   % save
%         saveas(H,fnm)
%         close(H)
%     end
%     
%     % Does it depend on stim intensity?
%     for k = 1:length(cellids)
%         H = figure;
%         viewcell2b(cellids(k),'TriggerName','StimulusOn','SortEvent','StimulusOff','eventtype','behav','ShowEvents',{{'StimulusOff'}},'Partitions','#StimulusDuration&Hit','window',[-5 5])
%         maximize_figure(H)
%         
%         cellidt = cellids{k};
%         cellidt(cellidt=='.') = '_';
%         fnm = [resdir cellidt '_SI.jpg'];   % save
%         saveas(H,fnm)
%         close(H)
%     end
    
%     Lickraster
%     for k = 1:length(cellids)
%         H = figure;
%         viewcell2b(cellids(k),'TriggerName','LickIn','SortEvent','StimulusOff','eventtype','behav','ShowEvents',{{'StimulusOff'}},'Partitions','#ResponseType','window',[-5 5])
%         maximize_figure(H)
%         
%         fnm = [resdir cellid '_HF.jpg'];   % save
%         saveas(H,fnm)
%         close(H)
%     end
end

% Light effects
if isrec && isstim

    % Create stimulus events
    MakeStimEvents_Bpod(fullpth,'PulseNttl',128, 'PulsePort', 0); % FS
    
    % Prealign spikes to stimulus events
    problem_stim_cellid = [];
    for iC = 1:length(cellids)
        cellid = cellids(iC);
        try
            prealignSpikes(cellid,'FUNdefineEventsEpochs',@defineEventsEpochs_laserstim_Bpod,'filetype','stim','ifsave',1,'ifappend',0)
        catch
            disp('Error in prealignSpikes.');
            problem_stim_cellid = [problem_stim_cellid cellid];
        end
    end
    
    % View light-triggered raster and PSTH
    TrigEvent = 'Pulse';
    SEvent = 'Pulse';
    win = [-0.05 0.05];
    parts = 'all';
%     parts = '#BurstNPulse';
    dt = 0.001;
    sigma = 0.001;
    PSTHstd = 'on';
    ShEvent = {'Pulse'};
    ShEvColors = hsv(length(ShEvent{1}));
    ShEvColors = mat2cell(ShEvColors,ones(size(ShEvColors,1),1),3);
    for iCell = 1:length(cellids)
        cellid = cellids(iCell);
        H = ensureFigure([cellids{iCell} '_laserStim'], 1);
        viewcell2b(cellid,'TriggerName',TrigEvent,'SortEvent',SEvent,'ShowEvents',ShEvent,'ShowEventsColors',ShEvColors,...
            'FigureNum',H,'eventtype','stim','window',win,'dt',dt,'sigma',sigma,'PSTHstd',PSTHstd,'Partitions',parts,...
            'EventMarkerWidth',0,'PlotZeroLine','off')
%         maximize_figure(H)
        formatFigureCellbase;
        
        cellidt = cellid{1};
        cellidt(cellidt=='.') = '_';
        saveas(H, fullfile(fullpth, [cellidt '_LS.jpg']));
%         saveas(H, fullfile(fullpth, [cellidt '_LS.fig']));        
%         close(H)

        % research statement-  tagging figure
    end
end

% Cluster quality
% if isrec
%     BatchSessionClust(fullpth)
% end

% % Behavior
% if isbeh
%     auditory_gonogo_psychplot2(animalID,sessionID)
%     % auditory_gonogo_psychplot2(animalID,sessionID,[],(1:150))
%     H = gcf;
%     fnm = [resdir2 sessionID '_PSYCHPLOT.jpg'];   % save
%     saveas(H,fnm)
%     fnm = [resdir2 sessionID '_PSYCHPLOT.fig'];
%     saveas(H,fnm)
%     
%     H = auditory_gonogo_psychplot3(animalID,sessionID);
%     maximize_figure(H)
%     fnm = [resdir2 sessionID '_PSYCHPLOT2.jpg'];   % save
%     saveas(H,fnm)
%     fnm = [resdir2 sessionID '_PSYCHPLOT2.fig'];
%     saveas(H,fnm)
% end