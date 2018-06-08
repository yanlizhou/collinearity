function CE_demo_ipad(black,white,window,winRect,task)
% Initiation


% 3. Keyboard set-up
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

%% Parameters
scale           = 2;
% ------------------- stimulus parameters -------------------%
w               = 70*scale; % occluder's width
yD              = [0; 60; 120; 210];
yD              = yD.*scale;
numy            = 4;
v_dy            = (6*scale)^2;
load('CE_demo_text.mat');
% -------------------- fixed parameters --------------------%
stimDuration    = 0.50;               % stimulus duration: 200 ms
ISIduration     = 0.40;
dotSizePix      = 3*scale;
penWidthPixels  = 1*scale;
occluder_height = 1500*scale;
occluder_color  = 90;
line_height     = 2*scale;
line_width      = 105*scale;
line_color      = 230;
numSides        = 3;
anglesDeg       = linspace(0, 360, numSides + 1);
anglesRad       = anglesDeg * (pi / 180);
radius          = 5*scale;
isConvex        = 1;
WidthPix        = 2*scale;
textsize        = 30;

%% Demo

Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[xCenter, yCenter] = RectCenter(winRect);
%[x_width, y_width] = Screen('WindowSize',window);
yCross = yCenter + 100*scale;
%     gaussianx       = (xCenter - x_width/3:xCenter + x_width/3)';
%     gaussiany       =  normpdf(gaussianx,xCenter,x_width/14)*-50000 + (yCenter+300);
%     gaussiancord    = [gaussianx, gaussiany];

% Hide the cursor
HideCursor;

% Fonts
Screen('TextSize', window, textsize);
Screen('TextFont', window, 'Times');

% Preparing the occluder
occluder_tex        = occluder_color * ones(occluder_height,w);
occTex              = Screen('MakeTexture', window, occluder_tex);
occluderRect        = CenterRectOnPoint([0 0 w occluder_height], xCenter, yCenter);


if task == 'D'
    % ----------------------------- screen 1 ---------------------------
    DrawFormattedText(window, msg1, 'center', 'center', black);
    %gaussiancord = drawgaussian(x_width,y_width,0,1,xCenter-300,yCenter+300,3);
    %fillgaussian(gaussiancord,1,window);
    %     Screen('FramePoly', window, white, gaussiancord ,3);
    %     Screen('FillPoly', window, grey-20, gaussiancord, 0);
    Screen('Flip', window);
    
    % Wait for space bar:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    %
    %     % ----------------------------- screen 2 ---------------------------
    %     DrawFormattedText(window, msg2, 'center', 'center', black);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     % Wait for space bar:
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %
    % ----------------------------- screen 3 ---------------------------
    Screen('TextSize', window, textsize);
    Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    %DrawFormattedText(window, 'Press SPACE to continue', 800, 800, black);
    yPosVector1 = sin(anglesRad) .* radius + yCenter;
    xPosVector1 = cos(anglesRad) .* radius + xCenter-40*scale;
    yPosVector2 = sin(anglesRad) .* radius + yCross;
    xPosVector2 = cos(anglesRad) .* radius + xCenter-10*scale;
    Screen('FillPoly', window, white, [xPosVector1; yPosVector1]', isConvex);
    Screen('FillPoly', window, white, [xPosVector2; yPosVector2]', isConvex);
    Screen('DrawLine', window, white, xCenter-120*scale, yCenter, xCenter-40*scale, yCenter, WidthPix);
    Screen('DrawLine', window, white, xCenter-90*scale, yCross, xCenter-10*scale, yCross, WidthPix);
    DrawFormattedText(window, 'Occluder', xCenter-120*scale, yCenter+5*scale, black);
    DrawFormattedText(window, 'Fixation dot', xCenter-90*scale, yCross+5*scale, black);
    [~, startrt] = Screen('Flip', window);
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    
    % ----------------------------- screen 4 ---------------------------
    %     Screen('TextSize', window, 25);
    %     DrawFormattedText(window, msg3, 'center', 'center', black);
    %     [~, startrt] = Screen('Flip', window);
    %
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     % Wait for space bar:
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %
    % ----------------------------- screen 5 ---------------------------
    yrightCoord = 24*scale;
    yleftCoord  = 36*scale;
    line_tex    = line_color * ones(line_height,line_width);
    lineRect    = [0 0 line_width line_height];
    lineTex     = Screen('MakeTexture', window, line_tex);
    
    lineRect_right = CenterRectOnPoint(lineRect, xCenter + line_width/2 , yCross - yrightCoord);
    lineRect_left  = CenterRectOnPoint(lineRect, xCenter - line_width/2 , yCross - yleftCoord);
    Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
    Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
    Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    [~, startrt] = Screen('Flip', window);
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    % Wait for space bar:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
    Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
    [~, startrt] = Screen('Flip', window);
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    % Wait for space bar:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
    Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
    Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    [~, startrt] = Screen('Flip', window);
    
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    % Wait for space bar:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    
    % ----------------------------- screen 6 ---------------------------
    Screen('TextSize', window, textsize);
    DrawFormattedText(window, msg4, 'center', 'center', black);
    [~, startrt] = Screen('Flip', window);
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    % Wait for space bar:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    % ----------------------------- screen 7 ---------------------------
    Yanli = 0;
    while Yanli == 0
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=1;
            WaitSecs(0.001);
        end
        
        yrightCoord = 36*scale;
        yleftCoord  = 24*scale;
        
        
        line_tex    = line_color * ones(line_height,line_width);
        lineRect    = [0 0 line_width line_height];
        lineTex     = Screen('MakeTexture', window, line_tex);
        lineRect_right = CenterRectOnPoint(lineRect, xCenter + line_width/2, yCross - yrightCoord);
        lineRect_left  = CenterRectOnPoint(lineRect, xCenter - line_width/2, yCross - yleftCoord);
        
        Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
        Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
        
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=stimDuration
            WaitSecs(0.001);
        end
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=0.5;
            WaitSecs(0.001);
        end
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        DrawFormattedText(window, 'Left ("C") or right ("N") higher?', 'center', yCross-60*scale, black);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, [0 240 0], [], 2);
        Screen('Flip', window);
        [KeyIsDown, ~, KeyCode] = KbCheck;
        while ( KeyCode(lefthigh)==0 && KeyCode(righthigh)==0 && KeyCode(escape)==0)
            [KeyIsDown, ~, KeyCode] = KbCheck;
            WaitSecs(0.001);
        end
        if KeyIsDown && KeyCode(escape)
            Screen('CloseAll');
            ShowCursor;
            fclose('all');
            Priority(0);
        end
        if KeyCode(righthigh1)==1 || KeyCode(righthigh2)==1 || KeyCode(righthigh3)==1 || KeyCode(righthigh4)==1
            Yanli = 250;
            DrawFormattedText(window, 'Bingo!', 'center', 'center', [0 240 0]);
            if KeyCode(righthigh1)==1
                confidence = 1;
            elseif KeyCode(righthigh2)==1
                confidence = 2;
            elseif KeyCode(righthigh3)==1
                confidence = 3;
            elseif KeyCode(righthigh4)==1
                confidence = 4;
            end
            if confidence == 1
                cf = 'not confident.';
            elseif confidence == 2
                cf = 'moderately confident.';
            elseif confidence == 3
                cf = 'confident.';
            elseif confidence == 4
                cf = 'very confident.';
            end
            message = ['You reported that the RIGHT line is higher.\n\n'...
                'You are ',cf,'.'];
            DrawFormattedText(window, message, xCenter, yCross, black);
            
            Screen('Flip', window);
            WaitSecs(1.000);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=ISIduration
                WaitSecs(0.001);
            end
            % Wait for space bar:
            [KeyIsDown, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
                [KeyIsDown, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            if KeyIsDown && KeyCode(escape)
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                Priority(0);
            end
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=ISIduration
                WaitSecs(0.001);
            end
            % Wait for space bar:
            [KeyIsDown, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
                [KeyIsDown, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            if KeyIsDown && KeyCode(escape)
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                Priority(0);
            end
            
        elseif KeyCode(lefthigh1)==1 ||KeyCode(lefthigh2)==1 || KeyCode(lefthigh3)==1 || KeyCode(lefthigh4)==1
            DrawFormattedText(window, 'Try again!', 'center', 'center', [240 0 0]);
            Screen('Flip', window);
            WaitSecs(1.000);
        end
        
    end
    
    % ----------------------------- screen 8 ---------------------------
    Yanli = 0;
    while Yanli == 0
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=1;
            WaitSecs(0.001);
        end
        
        yrightCoord = 86*scale;
        yleftCoord  = 94*scale;
        
        line_tex    = line_color * ones(line_height,line_width);
        lineRect    = [0 0 line_width line_height];
        lineTex     = Screen('MakeTexture', window, line_tex);
        lineRect_right = CenterRectOnPoint(lineRect, xCenter + line_width/2, yCross - yrightCoord);
        lineRect_left  = CenterRectOnPoint(lineRect, xCenter - line_width/2, yCross - yleftCoord);
        
        Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
        Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
        
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=stimDuration
            WaitSecs(0.001);
        end
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=0.5;
            WaitSecs(0.001);
        end
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        DrawFormattedText(window, 'Left ("C") or right ("N") higher?', 'center', yCross-60*scale, black);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, [0 240 0], [], 2);
        Screen('Flip', window);
        [KeyIsDown, ~, KeyCode] = KbCheck;
        while ( KeyCode(lefthigh)==0 && KeyCode(righthigh)==0 && KeyCode(escape)==0)
            [KeyIsDown, ~, KeyCode] = KbCheck;
            WaitSecs(0.001);
        end
        if KeyIsDown && KeyCode(escape)
            Screen('CloseAll');
            ShowCursor;
            fclose('all');
            Priority(0);
        end
        if KeyCode(lefthigh1)==1 || KeyCode(lefthigh2)==1 || KeyCode(lefthigh3)==1 || KeyCode(lefthigh4)==1 
            Yanli = 250;
            DrawFormattedText(window, 'Bingo!', 'center', 'center', [0 240 0]);
            
            if KeyCode(lefthigh1)==1
                confidence = 1;
            elseif KeyCode(lefthigh2)==1
                confidence = 2;
            elseif KeyCode(lefthigh3)==1
                confidence = 3;
            elseif KeyCode(lefthigh4)==1
                confidence = 4;
            end
            if confidence == 1
                cf = 'not confident.';
            elseif confidence == 2
                cf = 'moderately confident.';
            elseif confidence == 3
                cf = 'confident.';
            elseif confidence == 4
                cf = 'very confident.';
            end
            message = ['You reported that the LEFT line is higher.\n\n'...
                'You are ',cf,'.'];
            DrawFormattedText(window, message, xCenter, yCross, black);
            
            
            Screen('Flip', window);
            WaitSecs(1.000);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=ISIduration
                WaitSecs(0.001);
            end
            % Wait for space bar:
            [KeyIsDown, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
                [KeyIsDown, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            if KeyIsDown && KeyCode(escape)
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                Priority(0);
            end
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=ISIduration
                WaitSecs(0.001);
            end
            % Wait for space bar:
            [KeyIsDown, ~, KeyCode] = KbCheck;
            while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
                [KeyIsDown, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            if KeyIsDown && KeyCode(escape)
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                Priority(0);
            end
            
            
        elseif KeyCode(righthigh1)==1 || KeyCode(righthigh2)==1 || KeyCode(righthigh3)==1 || KeyCode(righthigh4)==1
            DrawFormattedText(window, 'Try again!', 'center', 'center', [240 0 0]);
            Screen('Flip', window);
            WaitSecs(1.000);
        end
        
    end
    
    % ----------------------------- screen 12 ---------------------------
    Screen('TextSize', window, textsize);
    DrawFormattedText(window, msg6, 'center', 'center', black);
    [~, startrt] = Screen('Flip', window);
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    % Wait for space bar:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    % ----------------------------- screen 12a ---------------------------
    dotmat1 = repmat(yCross,1,14);
    dotmat2 = repmat(yCross-60*scale,1,14);
    dotmat3 = repmat(yCross-120*scale,1,14);
    dotmat4 = repmat(yCross-210*scale,1,14);
    dotmattemp = linspace(xCenter+w/2-2,xCenter-w/2+2,14);
    dotmat1 = [dotmattemp;dotmat1];
    dotmat2 = [dotmattemp;dotmat2];
    dotmat3 = [dotmattemp;dotmat3];
    dotmat4 = [dotmattemp;dotmat4];
    dotsize = 2*scale;
    Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    Screen('DrawDots', window, dotmat1, dotsize, black);
    Screen('DrawDots', window, dotmat2, dotsize, black);
    Screen('DrawDots', window, dotmat3, dotsize, black);
    Screen('DrawDots', window, dotmat4, dotsize, black);
    [~, startrt] = Screen('Flip', window);
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    % ----------------------------- screen 12b ---------------------------
    %     %baseRect = [0 0 50 50];
    %     %centeredRect = CenterRectOnPointd(baseRect, xCenter-w/2, yCross-210);
    %     Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    %     Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    %     Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    %     Screen('DrawDots', window, dotmat1, 2, black);
    %     Screen('DrawDots', window, dotmat2, 2, black);
    %     Screen('DrawDots', window, dotmat3, 2, black);
    %     Screen('DrawDots', window, dotmat4, 2, black);
    %     %Screen('FrameOval', window, [230 0 0], centeredRect, 3);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    % -------------------------- screen 12.d --------------------------
    DrawFormattedText(window, msg8, 'center', 'center', black);
    [~, startrt] = Screen('Flip', window);
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    % Wait for space bar:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    %     %---------------------------- 12.c-------------------------------%
    %     DrawFormattedText(window, msg7, 'center', 'center', black);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     % Wait for space bar:
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %     % initialize text ---------------------------------------------------
    %     message = 'Probability of showing up \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n';
    %     [~, ~, textBounds] = DrawFormattedText(window, message, 'center', 'center', black);
    %     Screen('FillRect', window, grey);
    %     textureRect = ones(ceil((textBounds(4) - textBounds(2)) * 1.1), ceil((textBounds(3) - textBounds(1)) * 1.1)) .* grey;
    %     textTexture = Screen('MakeTexture', window, textureRect);
    %     Screen('TextSize', textTexture, 25);
    %     Screen('TextFont', textTexture, 'Helvetica');
    %     DrawFormattedText(textTexture, message, 'center', 'center', black);
    %
    %
    %     % ----------------------------- screen 13 ---------------------------
    %     gaussiancord = drawgaussian(x_width, y_width, 1 , 1,xCenter,yCenter+300,3);
    %     Screen('DrawTextures', window, textTexture, [], [], 270);
    %     DrawFormattedText(window, 'Distance from the center', 'center', yCenter+320, black);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('Drawline', window, white, xCenter+x_width/3+5, yCenter+300+10, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-25, yCenter-250+15, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('FramePoly', window, white, gaussiancord,3);
    %     Screen('FillPoly', window, grey-20, gaussiancord, 0);
    %
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     % Wait for space bar:
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %
    %     % small occluders --------------------------------------------------
    %     occluder_tex        = occluder_color * ones(150,36);
    %     occTex              = Screen('MakeTexture', window, occluder_tex);
    %     occluderRect1       = CenterRectOnPoint([0 0 36 150], xCenter-400, yCenter-100);
    %     occluderRect2       = CenterRectOnPoint([0 0 36 150], xCenter-200, yCenter-100);
    %     occluderRect3       = CenterRectOnPoint([0 0 36 150], xCenter, yCenter-100);
    %     occluderRect4       = CenterRectOnPoint([0 0 36 150], xCenter+200, yCenter-100);
    %     occluderRect5       = CenterRectOnPoint([0 0 36 150], xCenter+400, yCenter-100);
    %     yrightCoord = [10,  5,0,-5,-10];
    %     yleftCoord  = [-10,-5,0, 5, 10];
    %     line_tex    = line_color * ones(line_height,80);
    %     lineRect    = [0 0 80 line_height];
    %     tempxCenter = [-400,-200,0,200,400];
    %     for ii = 1:5
    %         lineTex(ii,:)        = Screen('MakeTexture', window, line_tex);
    %         lineRect_left(ii,:)  = CenterRectOnPoint(lineRect, xCenter+tempxCenter(ii) - 80/2, yCenter-100 - yleftCoord(ii));
    %     end
    %     dotmattemp = repmat(yCenter-100,1,9);
    %     dotmat1 = linspace(xCenter-400-36/2,xCenter-400+36/2,9); dotmat1 = [dotmat1;dotmattemp];
    %     dotmat2 = linspace(xCenter-200-36/2,xCenter-200+36/2,9);dotmat2 = [dotmat2;dotmattemp];
    %     dotmat3 = linspace(xCenter-36/2,xCenter+36/2,9);dotmat3 = [dotmat3;dotmattemp];
    %     dotmat4 = linspace(xCenter+200-36/2,xCenter+200+36/2,9);dotmat4 = [dotmat4;dotmattemp];
    %     dotmat5 = linspace(xCenter+400-36/2,xCenter+400+36/2,9);dotmat5 = [dotmat5;dotmattemp];
    %
    %     % ----------------------------- screen 14 ---------------------------
    %     Screen('DrawTextures', window, textTexture, [], [], 270);
    %     DrawFormattedText(window, 'Distance from the center', 'center', yCenter+320, black);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('Drawline', window, white, xCenter+x_width/3+5, yCenter+300+10, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-25, yCenter-250+15, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-405, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-395, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-400, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(1,:), lineRect, lineRect_left(1,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect1, occluderRect1);
    %     Screen('FrameRect', window, black, occluderRect1, penWidthPixels);
    %     Screen('DrawDots', window, dotmat1, 2, black);
    %     Screen('FramePoly', window, white, gaussiancord,3);
    %     Screen('FillPoly', window, grey-20, gaussiancord, 0);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     % Wait for space bar:
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %
    %     % ----------------------------- screen 15 ---------------------------
    %     Screen('DrawTextures', window, textTexture, [], [], 270);
    %     DrawFormattedText(window, 'Distance from the center', 'center', yCenter+320, black);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('Drawline', window, white, xCenter+x_width/3+5, yCenter+300+10, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-25, yCenter-250+15, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-405, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-395, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-400, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(1,:), lineRect, lineRect_left(1,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect1, occluderRect1);
    %     Screen('FrameRect', window, black, occluderRect1, penWidthPixels);
    %     Screen('DrawDots', window, dotmat1, 2, black);
    %     Screen('FramePoly', window, white, gaussiancord,3);
    %     Screen('FillPoly', window, grey-20, gaussiancord, 0);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-205, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-195, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-200, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(2,:), lineRect, lineRect_left(2,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect2, occluderRect2);
    %     Screen('FrameRect', window, black, occluderRect2, penWidthPixels);
    %     Screen('DrawDots', window, dotmat2, 2, black);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     % Wait for space bar:
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %     % ----------------------------- screen 16 ---------------------------
    %     Screen('DrawTextures', window, textTexture, [], [], 270);
    %     DrawFormattedText(window, 'Distance from the center', 'center', yCenter+320, black);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('Drawline', window, white, xCenter+x_width/3+5, yCenter+300+10, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-25, yCenter-250+15, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-405, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-395, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-400, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(1,:), lineRect, lineRect_left(1,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect1, occluderRect1);
    %     Screen('FrameRect', window, black, occluderRect1, penWidthPixels);
    %     Screen('DrawDots', window, dotmat1, 2, black);
    %     Screen('FramePoly', window, white, gaussiancord,3);
    %     Screen('FillPoly', window, grey-20, gaussiancord, 0);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-205, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-195, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-200, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(2,:), lineRect, lineRect_left(2,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect2, occluderRect2);
    %     Screen('FrameRect', window, black, occluderRect2, penWidthPixels);
    %     Screen('DrawDots', window, dotmat2, 2, black);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter-5, yCenter+90, WidthPix);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter+5, yCenter+90, WidthPix);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(3,:), lineRect, lineRect_left(3,:));
    %     Screen('DrawTexture', window, occTex, occluderRect3, occluderRect3);
    %     Screen('FrameRect', window, black, occluderRect3, penWidthPixels);
    %     Screen('DrawDots', window, dotmat3, 2, black);
    %
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %     % ----------------------------- screen 17 ---------------------------
    %     Screen('DrawTextures', window, textTexture, [], [], 270);
    %     DrawFormattedText(window, 'Distance from the center', 'center', yCenter+320, black);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('Drawline', window, white, xCenter+x_width/3+5, yCenter+300+10, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-25, yCenter-250+15, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-405, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-395, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-400, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(1,:), lineRect, lineRect_left(1,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect1, occluderRect1);
    %     Screen('FrameRect', window, black, occluderRect1, penWidthPixels);
    %     Screen('DrawDots', window, dotmat1, 2, black);
    %     Screen('FramePoly', window, white, gaussiancord,3);
    %     Screen('FillPoly', window, grey-20, gaussiancord, 0);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-205, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-195, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-200, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(2,:), lineRect, lineRect_left(2,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect2, occluderRect2);
    %     Screen('FrameRect', window, black, occluderRect2, penWidthPixels);
    %     Screen('DrawDots', window, dotmat2, 2, black);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter-5, yCenter+90, WidthPix);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter+5, yCenter+90, WidthPix);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(3,:), lineRect, lineRect_left(3,:));
    %     Screen('DrawTexture', window, occTex, occluderRect3, occluderRect3);
    %     Screen('FrameRect', window, black, occluderRect3, penWidthPixels);
    %     Screen('DrawDots', window, dotmat3, 2, black);
    %     Screen('DrawLine', window, black, xCenter+200, yCenter+200, xCenter+195, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter+200, yCenter+200, xCenter+205, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter+200, yCenter+200, xCenter+200, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(4,:), lineRect, lineRect_left(4,:));
    %     Screen('DrawTexture', window, occTex, occluderRect4, occluderRect4);
    %     Screen('FrameRect', window, black, occluderRect4, penWidthPixels);
    %     Screen('DrawDots', window, dotmat4, 2, black);
    %
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %     % ----------------------------- screen 18 ---------------------------
    %     Screen('DrawTextures', window, textTexture, [], [], 270);
    %     DrawFormattedText(window, 'Distance from the center', 'center', yCenter+320, black);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-15, yCenter+300, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('Drawline', window, white, xCenter+x_width/3+5, yCenter+300+10, xCenter+x_width/3+20, yCenter+300,3);
    %     Screen('Drawline', window, white, xCenter-x_width/3-25, yCenter-250+15, xCenter-x_width/3-15, yCenter-250,3);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-405, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-395, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-400, yCenter+240, xCenter-400, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(1,:), lineRect, lineRect_left(1,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect1, occluderRect1);
    %     Screen('FrameRect', window, black, occluderRect1, penWidthPixels);
    %     Screen('DrawDots', window, dotmat1, 2, black);
    %     Screen('FramePoly', window, white, gaussiancord,3);
    %     Screen('FillPoly', window, grey-20, gaussiancord, 0);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-205, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-195, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter-200, yCenter+200, xCenter-200, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(2,:), lineRect, lineRect_left(2,:));
    %     Screen('DrawTexture', window, occTex,  occluderRect2, occluderRect2);
    %     Screen('FrameRect', window, black, occluderRect2, penWidthPixels);
    %     Screen('DrawDots', window, dotmat2, 2, black);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter-5, yCenter+90, WidthPix);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter+5, yCenter+90, WidthPix);
    %     Screen('DrawLine', window, black, xCenter, yCenter+100, xCenter, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(3,:), lineRect, lineRect_left(3,:));
    %     Screen('DrawTexture', window, occTex, occluderRect3, occluderRect3);
    %     Screen('FrameRect', window, black, occluderRect3, penWidthPixels);
    %     Screen('DrawDots', window, dotmat3, 2, black);
    %     Screen('DrawLine', window, black, xCenter+200, yCenter+200, xCenter+195, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter+200, yCenter+200, xCenter+205, yCenter+190, WidthPix);
    %     Screen('DrawLine', window, black, xCenter+200, yCenter+200, xCenter+200, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(4,:), lineRect, lineRect_left(4,:));
    %     Screen('DrawTexture', window, occTex, occluderRect4, occluderRect4);
    %     Screen('FrameRect', window, black, occluderRect4, penWidthPixels);
    %     Screen('DrawDots', window, dotmat4, 2, black);
    %     Screen('DrawLine', window, black, xCenter+400, yCenter+240, xCenter+395, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter+400, yCenter+240, xCenter+405, yCenter+230, WidthPix);
    %     Screen('DrawLine', window, black, xCenter+400, yCenter+240, xCenter+400, yCenter+30, WidthPix);
    %     Screen('DrawTexture', window, lineTex(5,:), lineRect, lineRect_left(5,:));
    %     Screen('DrawTexture', window, occTex, occluderRect5, occluderRect5);
    %     Screen('FrameRect', window, black, occluderRect5, penWidthPixels);
    %     Screen('DrawDots', window, dotmat5, 2, black);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %     % ----------------------------- screen 19 ---------------------------
    %     DrawFormattedText(window, msg8, 'center', 'center', black);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     % Wait for space bar:
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %
    %     % ----------------------------- screen 20 ---------------------------
    %     Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    %     Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    %     Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %
    
    %     % -------------------------little gaussians--------------------------
    %     gaussiancord1 = drawgaussian(x_width, y_width,0,1,xCenter-w/2,yCross,25);
    %     gaussiancord2 = drawgaussian(x_width, y_width,0,0,xCenter+w/2,yCross,25);
    %     gaussiancord3 = drawgaussian(x_width, y_width,0,1,xCenter-w/2,yCross-30,25);
    %     gaussiancord4 = drawgaussian(x_width, y_width,0,0,xCenter+w/2,yCross-30,25);
    %     gaussiancord5 = drawgaussian(x_width, y_width,0,1,xCenter-w/2,yCross-90,25);
    %     gaussiancord6 = drawgaussian(x_width, y_width,0,0,xCenter+w/2,yCross-90,25);
    %     gaussiancord7 = drawgaussian(x_width, y_width,0,1,xCenter-w/2,yCross-210,25);
    %     gaussiancord8 = drawgaussian(x_width, y_width,0,0,xCenter+w/2,yCross-210,25);
    %     % ----------------------------- screen 21 ---------------------------
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross, xCenter-w/2-15, yCross, 2);
    %     Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    %     Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    %     Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    %     Screen('FramePoly', window, black, gaussiancord1,2);
    %     Screen('FramePoly', window, black, gaussiancord2,2);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %     % ----------------------------- screen 22 ---------------------------
    %
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross, xCenter-w/2-15, yCross, 2);
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross-30, xCenter-w/2-15, yCross-30, 2);
    %     Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    %     Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    %     Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    %     Screen('FramePoly', window, black, gaussiancord1,2);
    %     Screen('FramePoly', window, black, gaussiancord2,2);
    %     Screen('FramePoly', window, black, gaussiancord3,2);
    %     Screen('FramePoly', window, black, gaussiancord4,2);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %     % ----------------------------- screen 23 ---------------------------
    %
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross, xCenter-w/2-15, yCross, 2);
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross-30, xCenter-w/2-15, yCross-30, 2);
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross-90, xCenter-w/2-15, yCross-90, 2);
    %     Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    %     Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    %     Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    %     Screen('FramePoly', window, black, gaussiancord1,2);
    %     Screen('FramePoly', window, black, gaussiancord2,2);
    %     Screen('FramePoly', window, black, gaussiancord3,2);
    %     Screen('FramePoly', window, black, gaussiancord4,2);
    %     Screen('FramePoly', window, black, gaussiancord5,2);
    %     Screen('FramePoly', window, black, gaussiancord6,2);
    %
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    %     % ----------------------------- screen 24 ---------------------------
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross, xCenter-w/2-15, yCross, 2);
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross-30, xCenter-w/2-15, yCross-30, 2);
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross-90, xCenter-w/2-15, yCross-90, 2);
    %     Screen('DrawLine', window, white, xCenter+w/2+15, yCross-210, xCenter-w/2-15, yCross-210, 2);
    %     Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
    %     Screen('FrameRect', window, black, occluderRect, penWidthPixels);
    %     Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
    %     Screen('FramePoly', window, black, gaussiancord1,2);
    %     Screen('FramePoly', window, black, gaussiancord2,2);
    %     Screen('FramePoly', window, black, gaussiancord3,2);
    %     Screen('FramePoly', window, black, gaussiancord4,2);
    %     Screen('FramePoly', window, black, gaussiancord5,2);
    %     Screen('FramePoly', window, black, gaussiancord6,2);
    %     Screen('FramePoly', window, black, gaussiancord7,2);
    %     Screen('FramePoly', window, black, gaussiancord8,2);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    
    % ----------------------------- screen 25 ---------------------------
    nTrials_sample  = 12;
    tempy       = nTrials_sample/numy;
    yVecD       = repmat(yD,tempy,1);
    temp0       = randperm(nTrials_sample);
    yVecD       = yVecD(temp0);
    yleftD      = NaN(nTrials_sample,1);
    yrightD     = NaN(nTrials_sample,1);
    yleftD_     = NaN(nTrials_sample,1);
    yrightD_    = NaN(nTrials_sample,1);
    for ii = 1:(nTrials_sample)
        yval = yVecD(ii);
        if mod(ii,2) == 0
            yleftD_(ii) = sqrt(v_dy).*randn(1)+210*scale;
            yrightD_(ii) = sqrt(v_dy).*randn(1)+210*scale;
            yleftD(ii)  = sqrt(v_dy).*randn(1)+yval;
            yrightD(ii) = sqrt(v_dy).*randn(1)+yval;
            if yrightD(ii) < yleftD(ii)
                temp = yrightD(ii);
                yrightD(ii) = yleftD(ii);
                yleftD(ii) = temp;
            end
            if yrightD_(ii) < yleftD_(ii)
                temp = yrightD_(ii);
                yrightD_(ii) = yleftD_(ii);
                yleftD_(ii) = temp;
            end
        else
            yleftD(ii)  = sqrt(v_dy).*randn(1)+yval;
            yrightD(ii) = sqrt(v_dy).*randn(1)+yval;
            yleftD_(ii) = sqrt(v_dy).*randn(1)+210*scale;
            yrightD_(ii) = sqrt(v_dy).*randn(1)+210*scale;
            if yrightD(ii) > yleftD(ii)
                temp = yrightD(ii);
                yrightD(ii) = yleftD(ii);
                yleftD(ii) = temp;
            end
            
            if yrightD_(ii) < yleftD_(ii)
                temp = yrightD_(ii);
                yrightD_(ii) = yleftD_(ii);
                yleftD_(ii) = temp;
            end
        end
    end
    
    
    for thistrial = 1:nTrials_sample
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        Screen('DrawDots', window, dotmat1, dotsize, black);
        Screen('DrawDots', window, dotmat2, dotsize, black);
        Screen('DrawDots', window, dotmat3, dotsize, black);
        Screen('DrawDots', window, dotmat4, dotsize, black);
        %         Screen('FramePoly', window, black, gaussiancord1,2);
        %         Screen('FramePoly', window, black, gaussiancord2,2);
        %         Screen('FramePoly', window, black, gaussiancord3,2);
        %         Screen('FramePoly', window, black, gaussiancord4,2);
        %         Screen('FramePoly', window, black, gaussiancord5,2);
        %         Screen('FramePoly', window, black, gaussiancord6,2);
        %         Screen('FramePoly', window, black, gaussiancord7,2);
        %         Screen('FramePoly', window, black, gaussiancord8,2);
        yrightCoord         = yrightD_(thistrial);
        yleftCoord          = yleftD_(thistrial);
        
        line_tex            = line_color * ones(line_height,line_width);
        lineRect            = [0 0 line_width line_height];
        lineTex             = Screen('MakeTexture', window, line_tex);
        
        lineRect_right      = CenterRectOnPoint(lineRect, xCenter + w/2, yCross - yrightCoord);
        lineRect_left       = CenterRectOnPoint(lineRect, xCenter - w/2, yCross - yleftCoord);
        
        Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
        Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        Screen('DrawDots', window, dotmat1, dotsize, black);
        Screen('DrawDots', window, dotmat2, dotsize, black);
        Screen('DrawDots', window, dotmat3, dotsize, black);
        Screen('DrawDots', window, dotmat4, dotsize, black);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=stimDuration
            WaitSecs(0.001);
        end
        
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        Screen('DrawDots', window, dotmat1, dotsize, black);
        Screen('DrawDots', window, dotmat2, dotsize, black);
        Screen('DrawDots', window, dotmat3, dotsize, black);
        Screen('DrawDots', window, dotmat4, dotsize, black);
        %         Screen('FramePoly', window, black, gaussiancord1,2);
        %         Screen('FramePoly', window, black, gaussiancord2,2);
        %         Screen('FramePoly', window, black, gaussiancord3,2);
        %         Screen('FramePoly', window, black, gaussiancord4,2);
        %         Screen('FramePoly', window, black, gaussiancord5,2);
        %         Screen('FramePoly', window, black, gaussiancord6,2);
        %         Screen('FramePoly', window, black, gaussiancord7,2);
        %         Screen('FramePoly', window, black, gaussiancord8,2);
        
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=ISIduration
            WaitSecs(0.001);
        end
        
    end
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    
    % -------------------------- screen 26 --------------------------
    DrawFormattedText(window, msg9, 'center', 'center', black);
    [~, startrt] = Screen('Flip', window);
    while (GetSecs - startrt)<=ISIduration
        WaitSecs(0.001);
    end
    % Wait for space bar:
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    
    % -------------------------- screen 27 --------------------------
    
    for thistrial = 1:nTrials_sample
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        Screen('DrawDots', window, dotmat1, dotsize, black);
        Screen('DrawDots', window, dotmat2, dotsize, black);
        Screen('DrawDots', window, dotmat3, dotsize, black);
        Screen('DrawDots', window, dotmat4, dotsize, black);
        %         Screen('FramePoly', window, black, gaussiancord1,2);
        %         Screen('FramePoly', window, black, gaussiancord2,2);
        %         Screen('FramePoly', window, black, gaussiancord3,2);
        %         Screen('FramePoly', window, black, gaussiancord4,2);
        %         Screen('FramePoly', window, black, gaussiancord5,2);
        %         Screen('FramePoly', window, black, gaussiancord6,2);
        %         Screen('FramePoly', window, black, gaussiancord7,2);
        %         Screen('FramePoly', window, black, gaussiancord8,2);
        yrightCoord         = yrightD(thistrial);
        yleftCoord          = yleftD(thistrial);
        
        line_tex            = line_color * ones(line_height,line_width);
        lineRect            = [0 0 line_width line_height];
        lineTex             = Screen('MakeTexture', window, line_tex);
        
        lineRect_right      = CenterRectOnPoint(lineRect, xCenter + w/2, yCross - yrightCoord);
        lineRect_left       = CenterRectOnPoint(lineRect, xCenter - w/2, yCross - yleftCoord);
        
        Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
        Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        Screen('DrawDots', window, dotmat1, dotsize, black);
        Screen('DrawDots', window, dotmat2, dotsize, black);
        Screen('DrawDots', window, dotmat3, dotsize, black);
        Screen('DrawDots', window, dotmat4, dotsize, black);
        
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=stimDuration
            WaitSecs(0.001);
        end
        
        Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
        Screen('FrameRect', window, black, occluderRect, penWidthPixels);
        Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
        Screen('DrawDots', window, dotmat1, dotsize, black);
        Screen('DrawDots', window, dotmat2, dotsize, black);
        Screen('DrawDots', window, dotmat3, dotsize, black);
        Screen('DrawDots', window, dotmat4, dotsize, black);
        %         Screen('FramePoly', window, black, gaussiancord1,2);
        %         Screen('FramePoly', window, black, gaussiancord2,2);
        %         Screen('FramePoly', window, black, gaussiancord3,2);
        %         Screen('FramePoly', window, black, gaussiancord4,2);
        %         Screen('FramePoly', window, black, gaussiancord5,2);
        %         Screen('FramePoly', window, black, gaussiancord6,2);
        %         Screen('FramePoly', window, black, gaussiancord7,2);
        %         Screen('FramePoly', window, black, gaussiancord8,2);
        
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=ISIduration
            WaitSecs(0.001);
        end
        
    end
    [KeyIsDown, ~, KeyCode] = KbCheck;
    while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
        [KeyIsDown, ~, KeyCode] = KbCheck;
        WaitSecs(0.001);
    end
    if KeyIsDown && KeyCode(escape)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
    end
    
    % -------------------------- screen 29-------------------------------------
    %     DrawFormattedText(window, msg10, 'center', 'center', black);
    %     [~, startrt] = Screen('Flip', window);
    %     while (GetSecs - startrt)<=ISIduration
    %         WaitSecs(0.001);
    %     end
    %     % Wait for space bar:
    %     [KeyIsDown, ~, KeyCode] = KbCheck;
    %     while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
    %         [KeyIsDown, ~, KeyCode] = KbCheck;
    %         WaitSecs(0.001);
    %     end
    %     if KeyIsDown && KeyCode(escape)
    %         Screen('CloseAll');
    %         ShowCursor;
    %         fclose('all');
    %         Priority(0);
    %     end
    
    %     % Revive the mouse cursor.
    %     ShowCursor;
    %
    %     % Close screen
    %     Screen('CloseAll');
    %
    %     % Restore preferences
    %     Screen('Preference', 'VisualDebugLevel', oldVisualDebugLevel);
    %     Screen('Preference', 'SuppressAllWarnings', oldSupressAllWarnings);
    
else if task == 'C'
        % ----------------------------- screen 9 ---------------------------
        Screen('TextSize', window, textsize);
        DrawFormattedText(window, 'Please find the experimenter.', 'center', 'center', black);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=ISIduration
            WaitSecs(0.001);
        end
        % Wait for space bar:
        [KeyIsDown, ~, KeyCode] = KbCheck;
        while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
            [KeyIsDown, ~, KeyCode] = KbCheck;
            WaitSecs(0.001);
        end
        if KeyIsDown && KeyCode(escape)
            Screen('CloseAll');
            ShowCursor;
            fclose('all');
            Priority(0);
        end
        DrawFormattedText(window, msg5, 'center', 'center', black);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=ISIduration
            WaitSecs(0.001);
        end
        % Wait for space bar:
        [KeyIsDown, ~, KeyCode] = KbCheck;
        while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
            [KeyIsDown, ~, KeyCode] = KbCheck;
            WaitSecs(0.001);
        end
        if KeyIsDown && KeyCode(escape)
            Screen('CloseAll');
            ShowCursor;
            fclose('all');
            Priority(0);
        end
        
        % ----------------------------- screen 10 ---------------------------
        Yanli = 0;
        while Yanli == 0
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=1;
                WaitSecs(0.001);
            end
            
            yrightCoord = 90*scale;
            yleftCoord  = 90*scale;
            
            
            line_tex    = line_color * ones(line_height,line_width);
            lineRect    = [0 0 line_width line_height];
            lineTex     = Screen('MakeTexture', window, line_tex);
            lineRect_right = CenterRectOnPoint(lineRect, xCenter + line_width/2, yCross - yrightCoord);
            lineRect_left  = CenterRectOnPoint(lineRect, xCenter - line_width/2, yCross - yleftCoord);
            
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
            
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=stimDuration
                WaitSecs(0.001);
            end
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=0.5;
                WaitSecs(0.001);
            end
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            DrawFormattedText(window, 'Same ("F") or different ("J")?', 'center', yCross-60*scale, black);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, [0 240 0], [], 2);
            Screen('Flip', window);
            [KeyIsDown, ~, KeyCode] = KbCheck;
            while ( KeyCode(sameresp)==0 && KeyCode(diffresp)==0 && KeyCode(escape)==0)
                [KeyIsDown, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            if KeyIsDown && KeyCode(escape)
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                Priority(0);
            end
            if KeyCode(sameresp1)==1 || KeyCode(sameresp2)==1 || KeyCode(sameresp3)==1 || KeyCode(sameresp4)==1
                Yanli = 250;
                DrawFormattedText(window, 'Bingo!', 'center', 'center', [0 240 0]);
                if KeyCode(sameresp1)==1
                    confidence = 1;
                elseif KeyCode(sameresp2)==1
                    confidence = 2;
                elseif KeyCode(sameresp3)==1
                    confidence = 3;
                elseif KeyCode(sameresp4)==1
                    confidence = 4;
                end
                if confidence == 1
                    cf = 'not confident.';
                elseif confidence == 2
                    cf = 'moderately confident.';
                elseif confidence == 3
                    cf = 'confident.';
                elseif confidence == 4
                    cf = 'very confident.';
                end
                message = ['You reported that the two lines belong to the SAME line.\n\n'...
                    'You are ',cf,'.'];
                DrawFormattedText(window, message, xCenter, yCross, black);

                Screen('Flip', window);
                WaitSecs(1.000);
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
                Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
                Screen('FrameRect', window, black, occluderRect, penWidthPixels);
                Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=ISIduration
                    WaitSecs(0.001);
                end
                % Wait for space bar:
                [KeyIsDown, ~, KeyCode] = KbCheck;
                while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
                    [KeyIsDown, ~, KeyCode] = KbCheck;
                    WaitSecs(0.001);
                end
                if KeyIsDown && KeyCode(escape)
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');
                    Priority(0);
                end
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=ISIduration
                    WaitSecs(0.001);
                end
                % Wait for space bar:
                [KeyIsDown, ~, KeyCode] = KbCheck;
                while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
                    [KeyIsDown, ~, KeyCode] = KbCheck;
                    WaitSecs(0.001);
                end
                if KeyIsDown && KeyCode(escape)
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');
                    Priority(0);
                end
                
                
            elseif KeyCode(diffresp1)==1 || KeyCode(diffresp2)==1 || KeyCode(diffresp3)==1 || KeyCode(diffresp4)==1
                DrawFormattedText(window, 'Try again!', 'center', 'center', [240 0 0]);
                Screen('Flip', window);
                WaitSecs(1.000);
            end
            
        end
        % ----------------------------- screen 11 ---------------------------
        
        Yanli = 0;
        while Yanli == 0
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=1;
                WaitSecs(0.001);
            end
            
            yrightCoord = 33*scale;
            yleftCoord  = 27*scale;
            
            
            line_tex    = line_color * ones(line_height,line_width);
            lineRect    = [0 0 line_width line_height];
            lineTex     = Screen('MakeTexture', window, line_tex);
            lineRect_right = CenterRectOnPoint(lineRect, xCenter + line_width/2, yCross - yrightCoord);
            lineRect_left  = CenterRectOnPoint(lineRect, xCenter - line_width/2, yCross - yleftCoord);
            
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
            Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
            
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=stimDuration
                WaitSecs(0.001);
            end
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
            [~, startrt] = Screen('Flip', window);
            while (GetSecs - startrt)<=0.5;
                WaitSecs(0.001);
            end
            Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
            Screen('FrameRect', window, black, occluderRect, penWidthPixels);
            DrawFormattedText(window, 'Same ("F") or different ("J")?', 'center', yCross-60*scale, black);
            Screen('DrawDots', window, [xCenter yCross], dotSizePix, [0 240 0], [], 2);
            Screen('Flip', window);
            [KeyIsDown, ~, KeyCode] = KbCheck;
            while ( KeyCode(sameresp)==0 && KeyCode(diffresp)==0 && KeyCode(escape)==0)
                [KeyIsDown, ~, KeyCode] = KbCheck;
                WaitSecs(0.001);
            end
            if KeyIsDown && KeyCode(escape)
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                Priority(0);
            end
            if KeyCode(diffresp1)==1 || KeyCode(diffresp2)==1 || KeyCode(diffresp3)==1 || KeyCode(diffresp4)==1
                Yanli = 250;
                DrawFormattedText(window, 'Bingo!', 'center', 'center', [0 240 0]);
                if KeyCode(diffresp1)==1
                    confidence = 1;
                elseif KeyCode(diffresp2)==1
                    confidence = 2;
                elseif KeyCode(diffresp3)==1
                    confidence = 3;
                elseif KeyCode(diffresp4)==1
                    confidence = 4;
                end
                if confidence == 1
                    cf = 'not confident.';
                elseif confidence == 2
                    cf = 'moderately confident.';
                elseif confidence == 3
                    cf = 'confident.';
                elseif confidence == 4
                    cf = 'very confident.';
                end
                message = ['You reported that the two lines belong to DIFFERENT lines.\n\n'...
                    'You are ',cf,'.'];
                DrawFormattedText(window, message, xCenter, yCross, black);

                Screen('Flip', window);
                WaitSecs(1.000);
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
                Screen('DrawTexture', window, occTex,  occluderRect, occluderRect);
                Screen('FrameRect', window, black, occluderRect, penWidthPixels);
                Screen('DrawDots', window, [xCenter yCross], dotSizePix, white, [], 2);
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=ISIduration
                    WaitSecs(0.001);
                end
                % Wait for space bar:
                [KeyIsDown, ~, KeyCode] = KbCheck;
                while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
                    [KeyIsDown, ~, KeyCode] = KbCheck;
                    WaitSecs(0.001);
                end
                if KeyIsDown && KeyCode(escape)
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');
                    Priority(0);
                end
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_right);
                Screen('DrawTexture', window, lineTex, lineRect, lineRect_left);
                [~, startrt] = Screen('Flip', window);
                while (GetSecs - startrt)<=ISIduration
                    WaitSecs(0.001);
                end
                % Wait for space bar:
                [KeyIsDown, ~, KeyCode] = KbCheck;
                while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
                    [KeyIsDown, ~, KeyCode] = KbCheck;
                    WaitSecs(0.001);
                end
                if KeyIsDown && KeyCode(escape)
                    Screen('CloseAll');
                    ShowCursor;
                    fclose('all');
                    Priority(0);
                end
                
            elseif KeyCode(sameresp1)==1 || KeyCode(sameresp2)==1 || KeyCode(sameresp3)==1 || KeyCode(sameresp4)==1
                DrawFormattedText(window, 'Try again!', 'center', 'center', [240 0 0]);
                Screen('Flip', window);
                WaitSecs(1.000);
            end
            
        end
        DrawFormattedText(window, msg10, 'center', 'center', black);
        [~, startrt] = Screen('Flip', window);
        while (GetSecs - startrt)<=ISIduration
            WaitSecs(0.001);
        end
        % Wait for space bar:
        [KeyIsDown, ~, KeyCode] = KbCheck;
        while (KeyCode(spaceBar)==0 && KeyCode(escape)==0)
            [KeyIsDown, ~, KeyCode] = KbCheck;
            WaitSecs(0.001);
        end
        if KeyIsDown && KeyCode(escape)
            Screen('CloseAll');
            ShowCursor;
            fclose('all');
            Priority(0);
        end
    end
end
