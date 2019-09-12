%%Function that will create menu and start the game based on users choices
function connect4menu
figureColor        = [0.9 0.9 0.9];
textColor        = [0.95 0.95 0.95];
textFontSize1        = 9;
textFontSize2        = 10;

%gui
f = struct();
f.fig = figure( ...
    'Name', 'ConnectFour', ...
    'Color', 'white', ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'Toolbar', 'none');

%create Texts
uicontrol('Parent', f.fig, ...
    'Units', 'normalized', ...
    'Position', [0.25 0.700 0.5 0.2] , ...
    'Style', 'text', ...
    'String', 'Connect 4', 'BackgroundColor', 'b', ...
    'FontSize', 40);

f.text1Xlabel = uicontrol('Units', 'Normalized', ...
    'Position', [0.1 0.5 0.15 0.075], 'Style', 'text', ...
    'String', 'Length of board', 'BackgroundColor', figureColor, ...
    'FontSize', textFontSize1);

f.text2Xdata = uicontrol('Units', 'Normalized', ...
    'Position', [0.26 0.5 0.175 0.075], 'Style', 'edit', ...
    'String', '', 'BackgroundColor', textColor, ...
    'FontSize', textFontSize2);

f.text3Ylabel = uicontrol('Units', 'Normalized', ...
    'Position', [0.55 0.5 0.15 0.075], 'Style', 'text', ...
    'String', 'Width of board:', 'BackgroundColor', figureColor, ...
    'FontSize', textFontSize1);

f.text4Ydata = uicontrol('Units', 'Normalized', ...
    'Position', [0.71 0.5 0.175 0.075], 'Style', 'edit', ...
    'String', '','BackgroundColor', textColor, ...
    'FontSize', textFontSize2);

%creates pushButtons
c = uicontrol('Style', 'pushbutton');
c.String = 'Player vs Player';
c.Position = [150 100 100 60];
c.Callback = @plvspl;
f.c = c;

d = uicontrol('Style', 'pushbutton');
d.String = 'Player vs Computer';
d.Position = [300 100 100 60];
d.Callback = @plvsai;
f.d = d;


    function plvspl(src,event)
        if isempty(f.text2Xdata.String)
            x = 7;
        else
            x = str2double(f.text2Xdata.String);
            if (isnan(x) || x < 1)
               x = 7; 
            end
        end
        
        if isempty(f.text4Ydata.String)
            y = 6;
        else
            y = str2double(f.text4Ydata.String);
            if (isnan(y) || y < 1)
               y = 6; 
            end
        end
        close(f.fig)
        connect4(x, y, true);
    end

    function plvsai(src,event)
        if isempty(f.text2Xdata.String)
            x = 7;
        else
            x = str2double(f.text2Xdata.String);
            if (isnan(x) || x < 1)
               x = 7; 
            end
        end
        
        if isempty(f.text4Ydata.String)
            y = 6;
        else
            y = str2double(f.text4Ydata.String);
            if (isnan(y) || y < 1)
               y = 6; 
            end
        end
        close(f.fig)
        connect4(x, y, false);
    end
end