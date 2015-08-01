function labels_colors = defineLabelsColors_default
%DEFINELABELSCOLORS_DEFAULT   Labels and colors for plotting.
%   LABELS_COLORS = DEFINELABELSCOLORS_DEFAULT returns default labels and
%   colors for plotting. LABELS_COLORS is an N x 5 cell with tag, label,
%   color, second option for color, and line style in its columns. Use it
%   with MAKECOLORSLABELS.
%
%   See also MAKECOLORSLABELS.

%   Edit log: AK 7/01, BH 6/24/11

% Define colors and labels
%         TAG                               LabelName          Color              Color2    Line style 
labels_colors = { ...
        'All',                              'All',             [0   0   0],       [],       '-'; ...
        'Correct',                          'Correct',         [0.2 0.6 0],       [],       '-'; ...
        'Error',                            'Error',           [0.6 0.2 0],       [1 0 0],  '-'; ...
        'LeftChoice',                       'Left',            [0.2 0 0.9],       [],       '-'; ...
        'RightChoice',                      'Right',           [0.9 0 0.2],       [],       '-'; ...
        'Stimulus=[1 2 7 8]',               'Easy',            [0.3 0.9 0],       [],       '-'; ...
        'Stimulus=[3 4 5 6]',               'Diff',            [0.9 0.3 0],       [],       '-'; ...
        'Stimulus=[1 2 7 8]&Correct',     'Corr Easy',         [0.3 0.9 0],       [],       '-'; ...
        'Stimulus=[3 4 5 6]&Correct',     'Corr Diff',         [0.9 0.3 0],       [],       '-'; ...
        'Stimulus=[1 8]&Correct',         'Corr Easy',         [0.3 0.9 0.3],     [],       '-'; ...
        'Stimulus=[3 6]&Correct',         'Corr Med',          [0.3 0.6 0.9],     [],       '-'; ...
        'Stimulus=[4 5]&Correct',         'Corr Diff',         [0.9 0.3 0.3],     [],       '-'; ...
        'OdorRatio=[0100]&Correct',      'Corr Easy',         [0.3 0.9 0.3],     [],       '-'; ...
        'OdorRatio=[3268]&Correct',      'Corr Med',          [0.3 0.6 0.9],     [],       '-'; ...
        'OdorRatio=[32445668]&Correct',  'Corr Med',          [0.3 0.6 0.9],     [],       '-'; ...
        'OdorRatio=[4456]&Correct',      'Corr Diff',         [1 0.5 0.3],       [],       '-'; ...
        'OdorRatio=[0100]&Error',        'Err Easy',          [0.5 0.1 0.1],     [1 0 0],  '-'; ...
        'OdorRatio=[3268]&Error',        'Err Med',           [0.1 0.1 0.6],     [1 0 0],  '-'; ...
        'OdorRatio=[32445668]&Error',    'Err Med',           [0.8 0.2 0.2],     [1 0 0],  '-'; ...
        'OdorRatio=[4456]&Error',        'Err Diff',          [0.6 0.1 0.1],     [1 0 0],  '-'; ...
        'OdorRatio=[4456]',              '44/56',             [1 0.3 0.3],       [],       '-'; ...
        'OdorRatio=[3268]',              '32/68',             [0.3 0.3 0.9],     [],       '-'; ...
        'OdorRatio=[0100]',              '0/100',             [0.2 0.9 0.4],     [],       '-'; ...
        'OdorRatio=0',                    '0/100',             [0.15 0.9 0.1],    [],       '-'; ...
        'OdorRatio=32',                   '32/68',             [0.25 0.65 0.25],  [],       '-';   ...
        'OdorRatio=44',                   '44/56',             [0.25 0.55 0.45],  [],       '-';   ...
        'OdorRatio=50',                   '50/50',             [0.3 0.5 0.5],     [],       '-'; ...
        'OdorRatio=56',                   '56/44',             [0.25 0.45 0.55],  [],       '-';   ...
        'OdorRatio=68',                   '68/32',             [0.25 0.35 0.65],  [],       '-';   ...
        'OdorRatio=100',                  '100/0',             [0.15 0.1 0.9],    [],       '-'; ...
        'OdorRatio=0&Correct',            '0/100 corr',        [0.15 0.9 0.1],    [],       '-'; ...
        'OdorRatio=32&Correct',           '32/68 corr',        [0.25 0.65 0.25],  [],       '-';   ...
        'OdorRatio=44&Correct',           '44/56 corr',        [0.25 0.55 0.45],  [],       '-';   ...
        'OdorRatio=56&Correct',           '56/44 corr',        [0.25 0.45 0.55],  [],       '-';   ...
        'OdorRatio=68&Correct',           '68/32 corr',        [0.25 0.35 0.65],  [],       '-';   ...
        'OdorRatio=100&Correct',          '100/0 corr',        [0.15 0.1 0.9],    [],       '-';   ...
        'OdorRatio=0&Error',              '0/100 err',         [0.15 0.9 0.1],    [1 0 0],  '-';  ...
        'OdorRatio=32&Error',             '32/68 err',         [0.25 0.65 0.25],  [1 0 0],  '-';  ...
        'OdorRatio=44&Error',             '44/56 err',         [0.25 0.55 0.45],  [1 0 0],  '-';  ...
        'OdorRatio=56&Error',             '56/44 err',         [0.25 0.45 0.55],  [1 0 0],  '-';  ...
        'OdorRatio=68&Error',             '68/32 err',         [0.25 0.35 0.65],  [1 0 0],  '-';  ...
        'OdorRatio=100&Error',            '100/0 err',         [0.15 0.1 0.9],    [1 0 0],  '-'; ...
    };