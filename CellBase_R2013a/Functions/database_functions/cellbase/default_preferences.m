function PREFERENCES = default_preferences()
% DEFAULT_PREFERENCES creates a struct PREFERENCES containing default
% parameters specific to a cellbase. Note than cellbase-general preferences
% (cellbase name, data folder, cellbase file) are manipulated with
% getpref('cellbase')/setpref('cellbase',...).
%
% See also import_preferences(), setcbpref(name,value), getcbpref(name), initcb()
%
% TO 05/2018

cb_path = which('initcb');
cb_path=fileparts(fileparts(fileparts(fileparts(cb_path))));

PREFERENCES = struct();

%TrialEvents parameters
PREFERENCES.TrialEvents_fname = 'TrialEvents.mat'; % FS MOD 9/2018,  session_filename now deprecated as it is redundant with TrialEvents_fname
PREFERENCES.TrialEvents_fun = fullfile(cb_path,'Templates','MakeTrialEvents.m');
PREFERENCES.TrialEvents_defineEventEpochs = fullfile(cb_path,'Templates','defineEventEpochs.m');

%StimEvents parameters
PREFERENCES.StimEvents_fname = 'StimEvents.mat';
PREFERENCES.StimEvents_fun = fullfile(cb_path,'Templates','MakeStimEvents.m');

%Spike times parameters
PREFERENCES.Spikes_cell_pattern = 'TT';
PREFERENCES.Spikes_feature_prefix = ''; % e.g. for MClust3.5 -> '', for MClust4.4 ->  '_feature' 
PREFERENCES.Spikes_timefactor = 1;
PREFERENCES.Spikes_create_fun = '';
PREFERENCES.TrodeLoadingEngine = @TrodeLoadingEngine_NLX;

%Database parameters
PREFERENCES.session_separator = '';


