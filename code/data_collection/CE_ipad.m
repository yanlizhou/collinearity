function CE_ipad(session)
% This funciton performs the colinearity experiment and collects subjects'
% data and store it in the result folder.
% Yanli Zhou
% 7/14/2016
%% Initiation

% 1. Clear Matlab window:
%
% 2. Check for OpenGL compatibility, abort otherwise:
AssertOpenGL;

% 3. Reseed the random-number generator for each expt.
%rng('shuffle');

% Experimental parameters
if nargin < 1 || isempty(session);  session = 1;  end
% if rem(session,2)  == 0
%     sequence    = 1;
% else
%     sequence    = 2;
% end

% 4. Keyboard set-up
% Confidence ratings: 1 - 4 (lowest - highest)

KbName('UnifyKeyNames');
sameresp1  = KbName('r');      % "same" response via key 'g', CF = 1
sameresp2  = KbName('e');      % "same" response via key 'f', CF = 2
sameresp3  = KbName('w');      % "same" response via key 'd', CF = 3
sameresp4  = KbName('q');      % "same" response via key 's', CF = 4

diffresp1  = KbName('u');      % "different" response via key 'h', CF = 1
diffresp2  = KbName('i');      % "different" response via key 'j', CF = 2
diffresp3  = KbName('o');      % "different" response via key 'k', CF = 3
diffresp4  = KbName('p');      % "different" response via key 'l', CF = 4

lefthigh1  = KbName('v');      % "left higher" response via key 'v',CF = 1
lefthigh2  = KbName('c');      % "left higher" response via key 'c',CF = 2
lefthigh3  = KbName('x');      % "left higher" response via key 'x',CF = 3
lefthigh4  = KbName('z');      % "left higher" response via key 'z',CF = 4

righthigh1 = KbName('n');      % "right higher" response via key 'n',CF = 1
righthigh2 = KbName('m');      % "right higher" response via key 'm',CF = 2
righthigh3 = KbName(',<');      % "right higher" response via key ',',CF = 3
righthigh4 = KbName('.>');      % "right higher" response via key '.',CF = 4

escape    = KbName('ESCAPE');
spaceBar  = KbName('SPACE');

% 5. file handling
subNo   = input('Please enter the initials of the subject: ', 's');

blockNo = input('Please enter the block to start with: ');

% Define filename of result file:
if blockNo == 1
    datafilename = [subNo num2str(session) '.mat']; % name of data file to write to
else
    datafilename = [subNo num2str(session) num2str(blockNo) '.mat'];
end

%datafilename = fullfile('C:\Users\malab\Desktop\yanli\result',datafilename);
datafilename = fullfile('/Users/Sage/Documents/MATLAB/TEMP',datafilename);

% check for existing result file to prevent accidentally overwriting files from a previous subject/session:
if fopen(datafilename, 'rt')~=-1
    fclose('all');
    error('Result data file already exists! Choose a different subject name.');
end

% 6 Sound handling

[correct_sound, f_correct]     = audioread('correct_sound.wav');
[incorrect_sound, f_incorrect] = audioread('incorrect_sound.wav');
load('CE_demo_text.mat');

%%

scale           = 2; %4;
% ------------------- stimulus parameters -------------------%
w               = 70*scale; % occluder's width
v_dy            = (6*scale)^2;
% -------------------- fixed parameters --------------------%
stimDuration_p  = 0.50;
stimDuration    = 0.10;              % stimulus duration: 100 ms
ISIduration     = 0.850;
textduration    = 3.000;
fixDuration     = 0.450;
dotSizePix      = 3*scale;
penWidthPixels  = 1*scale;
occluder_height = 1500*scale;            % height of occluder in px.
occluder_color  = 90;
line_height     = 2*scale;
line_width      = 105*scale;
line_color      = 230;

nTrials         = 840; %840;
nTrialsC        = 600; %600;
nTrialsperBloD  = 120; %120
nBlocksperTasD  = 2;
fbtrials        = 120;  %120;                % show written feedback every fbtrials trials
check           = (1:nTrialsperBloD)';
checktemp       = ((nTrialsperBloD+nTrialsC+1):nTrials)';
check           = [check;checktemp];
check2          = nTrialsperBloD+1;
check3          = [1,nTrialsperBloD+nTrialsC+1];
numy            = 4;
yD              = [0; 60; 120; 210];
yD              = yD.*scale;
%%
% ---------------------- practice trials --------------------%
if session == 1
    nTrials_t     = 24;   %40
    nTrials_t_c   = 24;
else
    nTrials_t     = 16;   %40
    nTrials_t_c   = 16;
end
% ----------------------- c -----------------------
tempy       = nTrials_t_c/numy;
temp0       = randperm(nTrials_t_c);
yVecC_t     = repmat(yD,tempy,1);
yVecC_t     = yVecC_t(temp0);
yleftC_t    = NaN(nTrials_t_c,1);
yrightC_t   = NaN(nTrials_t_c,1);
for ii = 1:nTrials_t_c
    yval = yVecC_t(ii);
    if mod(ii,2) == 0
        yleftC_t(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightC_t(ii) = yleftC_t(ii);
    elseif mod(ii+1,4)==0
        yleftC_t(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightC_t(ii) = sqrt(v_dy).*randn(1)+yval;
        if yrightC_t(ii) < yleftC_t(ii)
            temp = yrightC_t(ii);
            yrightC_t(ii) = yleftC_t(ii);
            yleftC_t(ii) = temp;
        end
    else
        yleftC_t(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightC_t(ii) = sqrt(v_dy).*randn(1)+yval;
        if yrightC_t(ii) > yleftC_t(ii)
            temp = yrightC_t(ii);
            yrightC_t(ii) = yleftC_t(ii);
            yleftC_t(ii) = temp;
        end
    end
    
end
yleftC_t = round(yleftC_t);
yrightC_t = round(yrightC_t);
% ----------------------- d -----------------------
yVecD_t         = repmat(yD,tempy,1);
temp0           = randperm(nTrials_t);
yVecD_t         = yVecD_t(temp0);
yleftD_t      = NaN(nTrials_t,1);
yrightD_t     = NaN(nTrials_t,1);
for ii = 1:(nTrials_t)
    yval = yVecD_t(ii);
    if mod(ii,2) == 0
        yleftD_t(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightD_t(ii) = sqrt(v_dy).*randn(1)+yval;
        if yrightD_t(ii) < yleftD_t(ii)
            temp = yrightD_t(ii);
            yrightD_t(ii) = yleftD_t(ii);
            yleftD_t(ii) = temp;
        end
    else
        yleftD_t(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightD_t(ii) = sqrt(v_dy).*randn(1)+yval;
        while yrightD_t(ii) > yleftD_t(ii)
            temp = yrightD_t(ii);
            yrightD_t(ii) = yleftD_t(ii);
            yleftD_t(ii) = temp;
        end
    end
end
yleftD_t = round(yleftD_t);
yrightD_t = round(yrightD_t);

% ------- y and dy vectors for the catagorization task ------%
%%
tempy           = nTrialsC/numy;
temp0           = randperm(nTrialsC);
yVecC_raw       = repmat(yD,tempy,1);
yVecC_raw       = yVecC_raw(temp0);
yleftC_raw      = NaN(nTrialsC,1);
yrightC_raw     = NaN(nTrialsC,1);
dyVecC_raw      = NaN(nTrialsC,1);
for ii = 1:nTrialsC
    yval = yVecC_raw(ii);
    if mod(ii,2) == 0
        yleftC_raw(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightC_raw(ii) = yleftC_raw(ii);
    elseif mod(ii+1,4)==0
        yleftC_raw(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightC_raw(ii) = sqrt(v_dy).*randn(1)+yval;
        if yrightC_raw(ii) < yleftC_raw(ii)
            temp = yrightC_raw(ii);
            yrightC_raw(ii) = yleftC_raw(ii);
            yleftC_raw(ii) = temp;
        end
    else
        yleftC_raw(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightC_raw(ii) = sqrt(v_dy).*randn(1)+yval;
        if yrightC_raw(ii) > yleftC_raw(ii)
            temp = yrightC_raw(ii);
            yrightC_raw(ii) = yleftC_raw(ii);
            yleftC_raw(ii) = temp;
        end
    end
    yleftC_raw(ii) = round(yleftC_raw(ii));
    yrightC_raw(ii) = round(yrightC_raw(ii));
    dyVecC_raw(ii)  = yleftC_raw(ii)-yrightC_raw(ii);
    
end
temp2           = [yVecC_raw yleftC_raw yrightC_raw dyVecC_raw];
temp0           = randperm(nTrialsC);
random0          = temp2(temp0,:);
blankmat        = NaN(nTrialsperBloD,4);
random0          = [blankmat;random0;blankmat];
yVecC           = random0(:,1);
yleftC          = random0(:,2);
yrightC         = random0(:,3);
dyVecC          = random0(:,4);

% ------- y and dy vectors for the discrimination task ------%
tempy           = (nTrialsperBloD*nBlocksperTasD)/numy;
yVecD_raw       = repmat(yD,tempy,1);
temp0           = randperm(nTrialsperBloD*nBlocksperTasD);
yVecD_raw       = yVecD_raw(temp0);
yleftD_raw      = NaN(nTrialsperBloD*nBlocksperTasD,1);
yrightD_raw     = NaN(nTrialsperBloD*nBlocksperTasD,1);
dyVecD_raw      = NaN(nTrialsperBloD*nBlocksperTasD,1);
for ii = 1:(nTrialsperBloD*nBlocksperTasD)
    yval = yVecD_raw(ii);
    if mod(ii,2) == 0
        yleftD_raw(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightD_raw(ii) = sqrt(v_dy).*randn(1)+yval;
        if yrightD_raw(ii) < yleftD_raw(ii)
            temp = yrightD_raw(ii);
            yrightD_raw(ii) = yleftD_raw(ii);
            yleftD_raw(ii) = temp;
        end
    else
        yleftD_raw(ii)  = sqrt(v_dy).*randn(1)+yval;
        yrightD_raw(ii) = sqrt(v_dy).*randn(1)+yval;
        if yrightD_raw(ii) > yleftD_raw(ii)
            temp = yrightD_raw(ii);
            yrightD_raw(ii) = yleftD_raw(ii);
            yleftD_raw(ii) = temp;
        end
    end
    
    yleftD_raw(ii) = round(yleftD_raw(ii));
    yrightD_raw(ii) = round(yrightD_raw(ii));
    dyVecD_raw(ii)  = yleftD_raw(ii)-yrightD_raw(ii);
    
end

temp2           = [yVecD_raw yleftD_raw yrightD_raw dyVecD_raw];
temp0           = randperm(nTrialsperBloD*nBlocksperTasD);
random          = temp2(temp0,:);
random1         = random(1:(nTrialsperBloD*nBlocksperTasD)/2,:);
random2         = random(((nTrialsperBloD*nBlocksperTasD)/2)+1:(nTrialsperBloD*nBlocksperTasD),:);
blankmat        = NaN(nTrialsC,4);
random          = [random1;blankmat;random2];
yVecD           = random(:,1);
yleftD          = random(:,2);
yrightD         = random(:,3);
dyVecD          = random(:,4);

% -------- Creating the matrix that stores the data ---------%
fullDataMat     = NaN(nTrials,13);

%% Experiment
try
    % choose a screen
    screens = Screen('Screens');
    screenNumber = max(screens);
    
    % color set-up
    black = BlackIndex(screenNumber);%screenNumber
    white = WhiteIndex(screenNumber);%screenNumber
    grey  = white / 2;
    
    oldVisualDebugLevel   = Screen('Preference', 'VisualDebugLevel', 3);
    oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference', 'SkipSyncTests',2);
    
    % Open a window
    [window, winRect]  = Screen('OpenWindow', screenNumber , grey);%screenNumber
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    [xCenter, yCenter] = RectCenter(winRect);
    yCross = yCenter + 100*scale;
    ymsg   = yCenter + 40*scale;
    ymsg2  = yCenter + 80*scale;
    % Hide the cursor
    HideCursor;
    
    Screen('TextSize', window, 30);
    Screen('TextFont', window, 'Times');
    % ----------------  Demo --------------------
    if session == 1
        % intro text for practice trials
        CE_demo_ipad(black,white,window,winRect,'D');
        WaitSecs(0.5);
    end
    % --------------------------------------Experiment--------------------------------------
    if blockNo == 1 || blockNo == 2
        starttrial = 1;
    elseif blockNo == 3 || blockNo == 4
        starttrial = nTrialsperBloD+1;
    elseif blockNo == 5 || blockNo == 6
        starttrial = nTrialsperBloD+nTrialsC+1;
    end
    
    
    
    for thistrial = starttrial:nTrials
        
        [KeyIsDown, ~, KeyCode] = KbCheck;
        if KeyIsDown && KeyCode(escape)
            Screen('CloseAll');
            ShowCursor;
            fclose('all');
            Priority(0); break;
        end
        
        % ------------------------- Discrimination practice trials --------------------------
        if (ismember(thistrial,check3)==1 && blockNo == 1) || ...
                (ismember(thistrial,check3)==1 && blockNo == 5)
            message = ['Practice trials for the HEIGHT JUDGEMENT task! \n\n'...
                'Press a BLUE key on the LEFT if the line on the LEFT is higher \n\n '...
                'Press a BLUE key on the RIGHT if the line on the RIGHT is higher. \n\n' ...
                'Please press the key that reflects your confidence about your judgement:\n\n'...
                '1 = not confident; 2 = moderately confident; 3 = confident; 4 = very confident;\n\n\n'...
                'Please fixate on the fixation point. \n\n\nPress SPACE BAR to start.'];
            
            DrawFormattedText(window, message, 'center',ymsg, black);
            Screen('Flip', window);
            % Wait for space bar:
            [~, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0)
                [~, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            
            if thistrial == 1
                start  = 1;
                ending = nTrials_t/2;
            elseif thistrial == nTrialsperBloD+nTrialsC+1
                start  = nTrials_t/2 + 1;
                ending = nTrials_t;
            end
            for ii = start:ending
                % Preparing the occluder
                occluder_tex        = occluder_color * ones(occluder_height,w);
                occTex              = Screen('MakeTexture', window, occluder_tex);
                occluderRect        = CenterRectOnPoint([0 0 w occluder_height], xCenter, yCenter);
                
                Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
                Screen('FrameRect', window, black, occluderRect, penWidthPixels);
                Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=ISIduration
                    WaitSecs(0.001);
                end
                
                yrightCoord         = yrightD_t(ii);
                yleftCoord          = yleftD_t(ii);
                
                line_tex            = line_color * ones(line_height,line_width);
                lineRect            = [0 0 line_width line_height];
                lineTex             = Screen('MakeTexture', window, line_tex);
                
                lineRect_right      = CenterRectOnPoint(lineRect, xCenter + line_width/2, yCross - yrightCoord);
                lineRect_left       = CenterRectOnPoint(lineRect, xCenter - line_width/2, yCross - yleftCoord);
                
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
                Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
                Screen('FrameRect', window, black, occluderRect, penWidthPixels);
                Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
                
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=stimDuration_p
                    WaitSecs(0.001);
                end
                
                Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
                Screen('FrameRect', window, black, occluderRect, penWidthPixels);
                Screen('DrawDots', window, [xCenter yCross], dotSizePix, [0 240 0], [], 2);
                %DrawFormattedText(window, yrightCoord, 'center', 'center', black);
                Screen('Flip', window);
                
                [KeyIsDown, ~, KeyCode] = KbCheck;
                while ( KeyCode(lefthigh1)==0 && ...
                        KeyCode(lefthigh2)==0 && ...
                        KeyCode(lefthigh3)==0 && ...
                        KeyCode(lefthigh4)==0 && ...
                        KeyCode(righthigh1)==0 && ...
                        KeyCode(righthigh2)==0 && ...
                        KeyCode(righthigh3)==0 && ...
                        KeyCode(righthigh4)==0 && ...
                        KeyCode(escape)==0)
                    [KeyIsDown, ~, KeyCode] = KbCheck;
                    WaitSecs(0.001);
                end
                if KeyIsDown && KeyCode(escape)
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');
                    Priority(0); break;
                end
                if yCross - yrightCoord < yCross - yleftCoord
                    trial_type = 3; % right line higher
                else
                    trial_type = 2; % left line higher
                end
                if ((KeyCode(lefthigh1)==1 && trial_type==2) || ...
                        (KeyCode(lefthigh2)==1 && trial_type==2) || ...
                        (KeyCode(lefthigh3)==1 && trial_type==2) || ...
                        (KeyCode(lefthigh4)==1 && trial_type==2) || ...
                        (KeyCode(righthigh1)==1 && trial_type==3) ||...
                        (KeyCode(righthigh2)==1 && trial_type==3) ||...
                        (KeyCode(righthigh3)==1 && trial_type==3) ||...
                        (KeyCode(righthigh4)==1 && trial_type==3))
                    
                    correct = 1; playblocking(audioplayer(correct_sound, f_correct));
                else
                    correct = 0; playblocking(audioplayer(incorrect_sound, f_incorrect));
                end
                
                if correct == 1
                    status = 'correct.';
                else
                    status = 'incorrect.';
                end
                
                if (KeyCode(lefthigh1)==1  || KeyCode(righthigh1)==1)
                    cf = 'not confident.';
                elseif (KeyCode(lefthigh2)==1  || KeyCode(righthigh2)==1)
                    cf = 'moderately confident.';
                elseif (KeyCode(lefthigh3)==1  || KeyCode(righthigh3)==1)
                    cf = 'confident.';
                elseif (KeyCode(lefthigh4)==1  || KeyCode(righthigh4)==1)
                    cf = 'very confident.';
                end
                
                if KeyCode(lefthigh1)==1 || KeyCode(lefthigh2)==1 || KeyCode(lefthigh3)==1 || KeyCode(lefthigh4)==1
                    judgement = 'left';
                elseif KeyCode(righthigh1)==1 || KeyCode(righthigh2)==1 || KeyCode(righthigh3)==1 || KeyCode(righthigh4)==1
                    judgement = 'right';
                end
                
                message = ['You reported that the ',judgement,' line is higher.\n'...
                    'You were ',cf,'\n\n'...
                    'You were ',status];
                
                DrawFormattedText(window, message, 'center',ymsg2, black);
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=textduration
                    WaitSecs(0.001);
                end
            end
            message = 'Good job! \n\n\n Press SPACE BAR to start the actual experiment.';
            DrawFormattedText(window, message, 'center',ymsg2, black);
            Screen('Flip', window);
            % Wait for space bar:
            [~, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0)
                [~, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            Screen('Flip', window);
            WaitSecs(1.000);
        end
        % ------------------------- Categorization practice trials --------------------------
        if session == 1 && thistrial == nTrialsperBloD+1
            % intro text for practice trials
            CE_demo_ipad(black,white,window,winRect,'C');
            WaitSecs(0.5);
        end
        
        if thistrial == nTrialsperBloD+1 && blockNo == 3
            Screen('Flip', window);
            WaitSecs(1.000);
            message = ['Practice trials for the SAMENESS JUDGEMENT task! \n\n'...
                'Press a RED key on the LEFT if the lines are the SAME line \n\n '...
                'Press a RED key on the RIGHT if the lines are DIFFERENT lines. \n\n' ...
                'Please press the key that reflects your confidence about your judgement:\n\n'...
                '1 = not confident; 2 = moderately confident; 3 = confident; 4 = very confident;\n\n\n'...
                'Please fixate on the fixation point. \n\n\nPress SPACE BAR to start.'];
            DrawFormattedText(window, message, 'center',ymsg, black);
            Screen('Flip', window);
            % Wait for space bar:
            [~, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0)
                [~, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            for ii = 1:nTrials_t_c
                % Preparing the occluder
                occluder_tex        = occluder_color * ones(occluder_height,w);
                occTex              = Screen('MakeTexture', window, occluder_tex);
                occluderRect        = CenterRectOnPoint([0 0 w occluder_height], xCenter, yCenter);
                
                Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
                Screen('FrameRect', window, black, occluderRect, penWidthPixels);
                Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=ISIduration
                    WaitSecs(0.001);
                end
                
                yrightCoord         = yrightC_t(ii);
                yleftCoord          = yleftC_t(ii);
                
                line_tex            = line_color * ones(line_height,line_width);
                lineRect            = [0 0 line_width line_height];
                lineTex             = Screen('MakeTexture', window, line_tex);
                
                lineRect_right      = CenterRectOnPoint(lineRect, xCenter + line_width/2, yCross - yrightCoord);
                lineRect_left       = CenterRectOnPoint(lineRect, xCenter - line_width/2, yCross - yleftCoord);
                
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
                Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
                Screen('FrameRect', window, black, occluderRect, penWidthPixels);
                Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
                
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=stimDuration_p
                    WaitSecs(0.001);
                end
                
                Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
                Screen('FrameRect', window, black, occluderRect, penWidthPixels);
                Screen('DrawDots', window, [xCenter yCross], dotSizePix, [0 240 0], [], 2);
                Screen('Flip', window);
                
                [KeyIsDown, ~, KeyCode] = KbCheck;
                while ( KeyCode(sameresp1)==0 && ...
                        KeyCode(sameresp2)==0 && ...
                        KeyCode(sameresp3)==0 && ...
                        KeyCode(sameresp4)==0 && ...
                        KeyCode(diffresp1)==0 && ...
                        KeyCode(diffresp2)==0 && ...
                        KeyCode(diffresp3)==0 && ...
                        KeyCode(diffresp4)==0 && ...
                        KeyCode(escape)==0)
                    [KeyIsDown, ~, KeyCode] = KbCheck;
                    WaitSecs(0.001);
                end
                if KeyIsDown && KeyCode(escape)
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');
                    Priority(0); break;
                end
                if  yrightCoord == yleftCoord
                    trial_type = 1; % right line higher
                else
                    trial_type = 0; % left line higher
                end
                if ((KeyCode(sameresp1)==1 && trial_type==1) || ...
                        (KeyCode(sameresp2)==1 && trial_type==1) || ...
                        (KeyCode(sameresp3)==1 && trial_type==1) || ...
                        (KeyCode(sameresp4)==1 && trial_type==1) || ...
                        (KeyCode(diffresp1)==1 && trial_type==0) ||...
                        (KeyCode(diffresp2)==1 && trial_type==0) ||...
                        (KeyCode(diffresp3)==1 && trial_type==0) ||...
                        (KeyCode(diffresp4)==1 && trial_type==0))
                    
                    correct = 1; playblocking(audioplayer(correct_sound, f_correct));
                else
                    correct = 0; playblocking(audioplayer(incorrect_sound, f_incorrect));
                end
                if correct == 1
                    status = 'correct.';
                else
                    status = 'incorrect.';
                end
                
                if (KeyCode(sameresp1)==1  || KeyCode(diffresp1)==1)
                    cf = 'not confident.';
                elseif (KeyCode(sameresp2)==1  || KeyCode(diffresp2)==1)
                    cf = 'moderately confident.';
                elseif (KeyCode(sameresp3)==1  || KeyCode(diffresp3)==1)
                    cf = 'confident.';
                elseif (KeyCode(sameresp4)==1  || KeyCode(diffresp4)==1)
                    cf = 'very confident.';
                end
                
                if KeyCode(sameresp1)==1 || KeyCode(sameresp2)==1 || KeyCode(sameresp3)==1 || KeyCode(sameresp4)==1
                    judgement = 'the same';
                elseif KeyCode(diffresp1)==1 || KeyCode(diffresp2)==1 || KeyCode(diffresp3)==1 || KeyCode(diffresp4)==1
                    judgement = 'different';
                end
                
                message = ['You reported that the lines are ',judgement,'.\n'...
                    'You were ',cf,'\n\n'...
                    'You were ',status];
                
                DrawFormattedText(window, message,'center',ymsg2, black);
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=textduration
                    WaitSecs(0.001);
                end
                
            end
            
            message = 'Good job! \n\n\n Press SPACE BAR to start the actual experiment.';
            DrawFormattedText(window, message,'center',ymsg2, black);
            Screen('Flip', window);
            % Wait for space bar:
            [~, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0)
                [~, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
        end
        
        % ----------------------------------------------------------------------------------
        % Preparing the occluder
        
        occluder_tex        = occluder_color * ones(occluder_height,w);
        occTex              = Screen('MakeTexture', window, occluder_tex);
        occluderRect        = CenterRectOnPoint([0 0 w occluder_height], xCenter, yCenter);
        
        if ismember(thistrial,check3)==1
            %             % intro text for discrimination task
            %             if thistrial~=1 && session ~=1
            %                 Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            %                 Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            %                 Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            %                 Screen('Flip', window);
            %                 WaitSecs(0.500);
            %             else if thistrial == 1 && session == 1
            %                     Screen('Flip', window);
            %                     WaitSecs(1.000);
            %                 end
            %             end
            Screen('Flip', window);
            WaitSecs(1.000);
            
            message = ['HEIGHT JUDGEMENT task! \n\n'...
                'Press a BLUE key on the LEFT if the line on the LEFT is higher \n\n '...
                'Press a BLUE key on the RIGHT if the line on the RIGHT is higher. \n\n' ...
                'Please press the key that reflects your confidence about your judgement:\n\n'...
                '1 = not confident; 2 = moderately confident; 3 = confident; 4 = very confident;\n\n\n'...
                'Please fixate on the fixation point. \n\n\nPress SPACE BAR to start.'];
            DrawFormattedText(window, message,'center',ymsg, black);
            Screen('Flip', window);
            
            % Wait for space bar:
            [~, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0)
                [~, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
        elseif thistrial == check2
            
            Screen('Flip', window);
            WaitSecs(1.000);
            
            message = ['SAMENESS JUDGEMENT task! \n\n'...
                'Press a RED key on the LEFT if the lines are the SAME line \n\n '...
                'Press a RED key on the RIGHT if the lines are DIFFERENT lines. \n\n' ...
                'Please press the key that reflects your confidence about your judgement:\n\n'...
                '1 = not confident; 2 = moderately confident; 3 = confident; 4 = very confident;\n\n\n'...
                'Notice that no audio feedback will be given during this task.\n\n\n'...
                'Please fixate on the fixation point. \n\n\nPress SPACE BAR to start.'];
            DrawFormattedText(window, message, 'center',ymsg, black);
            Screen('Flip', window);
            % Wait for space bar:
            [~, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0)
                [~, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
        end
        
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=ISIduration
            WaitSecs(0.001);
        end
        
        if ismember(thistrial,check)==0
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=fixDuration
                WaitSecs(0.001);
            end
        end
        
        % Draw the lines for the catagorization task
        if ismember(thistrial,check)==0
            yrightCoord         = yrightC(thistrial);
            yleftCoord          = yleftC(thistrial);
            
            line_tex            = line_color * ones(line_height,line_width);
            lineRect            = [0 0 line_width line_height];
            lineTex             = Screen('MakeTexture', window, line_tex);
            
            lineRect_right      = CenterRectOnPoint(lineRect, xCenter + line_width/2, yCross - yrightCoord);
            lineRect_left       = CenterRectOnPoint(lineRect, xCenter - line_width/2, yCross - yleftCoord);
            
            
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
            
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            
            [~, startrt] = Screen('Flip', window);
        end
        
        % Draw the lines for the discrimination task
        if ismember(thistrial,check)==1
            yrightCoord         = yrightD(thistrial);
            yleftCoord          = yleftD(thistrial);
            
            line_tex            = line_color * ones(line_height,line_width);
            lineRect            = [0 0 line_width line_height];
            lineTex             = Screen('MakeTexture', window, line_tex);
            
            lineRect_right      = CenterRectOnPoint(lineRect, xCenter + line_width/2, yCross - yrightCoord);
            lineRect_left       = CenterRectOnPoint(lineRect, xCenter - line_width/2, yCross - yleftCoord);
            
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            
            [~, startrt] = Screen('Flip', window);
        end
        
        resptimestart = startrt;
        
        while (GetSecs - startrt)<=stimDuration
            WaitSecs(0.001);
        end
        
        
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        %message = 'Same ("f") or different ("j")?';
        %DrawFormattedText(window, message, 'center', yCenter-60, black);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, [0 240 0], [], 2);
        Screen('Flip', window);
        
        
        % wait for a response
        if ismember(thistrial,check)==1
            [KeyIsDown, resptimeend, KeyCode] = KbCheck;
            while ( KeyCode(lefthigh1)==0 && ...
                    KeyCode(lefthigh2)==0 && ...
                    KeyCode(lefthigh3)==0 && ...
                    KeyCode(lefthigh4)==0 && ...
                    KeyCode(righthigh1)==0 && ...
                    KeyCode(righthigh2)==0 && ...
                    KeyCode(righthigh3)==0 && ...
                    KeyCode(righthigh4)==0 && ...
                    KeyCode(escape)==0)
                [KeyIsDown, resptimeend, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
        elseif ismember(thistrial,check)==0
            [KeyIsDown, resptimeend, KeyCode] = KbCheck;
            while ( KeyCode(sameresp1)==0 && ...
                    KeyCode(sameresp2)==0 && ...
                    KeyCode(sameresp3)==0 && ...
                    KeyCode(sameresp4)==0 && ...
                    KeyCode(diffresp1)==0 && ...
                    KeyCode(diffresp2)==0 && ...
                    KeyCode(diffresp3)==0 && ...
                    KeyCode(diffresp4)==0 && ...
                    KeyCode(escape)==0)
                [KeyIsDown, resptimeend, KeyCode] = KbCheck;
                WaitSecs(0.0001);
            end
        end
        
        if KeyIsDown && KeyCode(escape)
            Screen('CloseAll');
            ShowCursor;
            fclose('all');
            Priority(0); break;
        end
        
        respkey  = KbName(KeyCode); % get key pressed by subject
        resptime = resptimeend - resptimestart;
        if ismember(thistrial,check)==0
            if dyVecC(thistrial) == 0
                trial_type = 1 ; %"same" trial
            else
                trial_type = 0 ; %"different" trial
            end
        elseif ismember(thistrial,check)==1
            if yCross - yrightCoord < yCross - yleftCoord
                trial_type = 3; % right line higher
            else
                trial_type = 2; % left line higher
            end
        end
        
        % avoid multiple key presses.
        if iscell(respkey)==1
            respkey = -100;
            correct = 0;
        elseif ismember(thistrial,check)==0
            if ((KeyCode(sameresp1)==1 && trial_type==1) || ...
                    (KeyCode(sameresp2)==1 && trial_type==1) || ...
                    (KeyCode(sameresp3)==1 && trial_type==1) || ...
                    (KeyCode(sameresp4)==1 && trial_type==1) || ...
                    (KeyCode(diffresp1)==1 && trial_type==0) ||...
                    (KeyCode(diffresp2)==1 && trial_type==0) ||...
                    (KeyCode(diffresp3)==1 && trial_type==0) ||...
                    (KeyCode(diffresp4)==1 && trial_type==0))
                correct = 1; %correct = correct + 1;
            else
                correct = 0;
            end
            
            
        elseif ismember(thistrial,check)==1
            
            if ((KeyCode(lefthigh1)==1 && trial_type==2) || ...
                    (KeyCode(lefthigh2)==1 && trial_type==2) || ...
                    (KeyCode(lefthigh3)==1 && trial_type==2) || ...
                    (KeyCode(lefthigh4)==1 && trial_type==2) || ...
                    (KeyCode(righthigh1)==1 && trial_type==3) ||...
                    (KeyCode(righthigh2)==1 && trial_type==3) ||...
                    (KeyCode(righthigh3)==1 && trial_type==3) ||...
                    (KeyCode(righthigh4)==1 && trial_type==3))
                
                correct = 1; playblocking(audioplayer(correct_sound, f_correct)); %correct = correct + 1;
            else
                correct = 0; playblocking(audioplayer(incorrect_sound, f_incorrect));
            end
        end
        
        if ismember(thistrial,check) == 0
            if (KeyCode(sameresp1)==1  || KeyCode(diffresp1)==1)
                CF = 1;
            elseif (KeyCode(sameresp2)==1  || KeyCode(diffresp2)==1)
                CF = 2;
            elseif (KeyCode(sameresp3)==1  || KeyCode(diffresp3)==1)
                CF = 3;
            elseif (KeyCode(sameresp4)==1  || KeyCode(diffresp4)==1)
                CF = 4;
            end
            
        elseif ismember(thistrial,check) == 1
            if (KeyCode(lefthigh1)==1  || KeyCode(righthigh1)==1)
                CF = 1;
            elseif (KeyCode(lefthigh2)==1  || KeyCode(righthigh2)==1)
                CF = 2;
            elseif (KeyCode(lefthigh3)==1  || KeyCode(righthigh3)==1)
                CF = 3;
            elseif (KeyCode(lefthigh4)==1  || KeyCode(righthigh4)==1)
                CF = 4;
            end
        end
        
        if ismember(thistrial,check) == 1
            if strcmp(respkey,',<')
                respkey = 11;
            elseif strcmp(respkey,'.>')
                respkey = 22;
            end
        end
        
        if rem(thistrial, fbtrials) == 0 && thistrial ~= nTrials && thistrial ~= nTrialsperBloD && thistrial ~= nTrialsperBloD+nTrialsC
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            Screen('Flip', window);
            WaitSecs(0.500);
            str = sprintf('%i %% of the experiment completed.\n\n Well done!\n\n Press SPACE BAR to continue when you are ready.',  floor(100*(thistrial/nTrials))); %floor(100*(correct/fbtrials)), fbtrials);
            DrawFormattedText(window, str, 'center',ymsg2, black);
            Screen('Flip', window);
            % Wait for spacebar:
            [~, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0)
                [~, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            %WaitSecs(1.000);
        end
        
        %         if thistrial == nTrials/2
        %             WaitSecs(1.000);
        %             message = ['First half completed.\n\n' 'Now take a break:)\n\n' 'Press SPACE BAR to start the second half.'];
        %             DrawFormattedText(window, message, 'center', 'center', black);
        %             Screen('Flip', window);
        %
        %             % Wait for spacebar:
        %             [~, ~, KeyCode] = KbCheck;
        %             while (KeyCode(spaceBar)==0)
        %                 [~, ~, KeyCode] = KbCheck;
        %                 WaitSecs(0.001);
        %             end
        %             WaitSecs(2.000);
        %         end
        
        %Screen('Close', occTex);
        
        % Store data
        fullDataMat(thistrial,1) =  yVecC(thistrial);
        fullDataMat(thistrial,2) =  dyVecC(thistrial);
        fullDataMat(thistrial,3) =  yVecD(thistrial);
        fullDataMat(thistrial,4) =  dyVecD(thistrial);
        fullDataMat(thistrial,5) =  trial_type;
        fullDataMat(thistrial,6) =  respkey;
        fullDataMat(thistrial,7) =  correct;
        fullDataMat(thistrial,8) =  resptime;
        fullDataMat(thistrial,9) =  yleftC(thistrial);
        fullDataMat(thistrial,10)=  yrightC(thistrial);
        fullDataMat(thistrial,11)=  yleftD(thistrial);
        fullDataMat(thistrial,12)=  yrightD(thistrial);
        fullDataMat(thistrial,13)=  CF;
        
        save(datafilename,'fullDataMat');
        %fullDataMat(thistrial,:)
    end
    
    
    message = 'You have completed this session.\n\n Please find the experimenter!';
    DrawFormattedText(window, message, 'center',ymsg2, black);
    Screen('Flip', window);
    WaitSecs(3.000);
    
    % Revive the mouse cursor.
    ShowCursor;
    
    % Close screen
    Screen('CloseAll');
    
    % Restore preferences
    %     Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    %     Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
catch
    % If there is an error in our try block, let's
    % return the user to the familiar MATLAB prompt.
    ShowCursor;
    Screen('CloseAll');
    %     Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    %     Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    psychrethrow(psychlasterror);
    
end


% Fin