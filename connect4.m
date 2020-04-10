%Core implementation of Connect 4
%   inputs:
%   sizeOfBoard - user can specify how big board he wants
%
function connect4(lengthOfBoard, widthOfBoard, realPlayer)
%create image

handles = struct();
handles.fig = figure( ...
    'Name', 'ConnectFour', ...
    'Color', 'white', ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'Toolbar', 'none');
handles.axes = axes( ...
    'Xcolor', 'none', ...
    'Ycolor', 'none', 'Position', [0 0 1 1]);
handles.axes.Units = 'Pixels';

%initialize board
board = zeros(lengthOfBoard, widthOfBoard);
%gameOver is false
gameOver = false;
%declare which player is on turn
turn = 1;
%declare player1
player1 = 1;
%declare player2
player2 = 2;

%GUI function
%draw empty board
%GUI(board, handles, realPlayer, player1);
while gameOver ~= true
    %if the board is full -> lets end the game with tie
    if(not(ismember(0, board)))
        uicontrol('Units', 'normalized', ...
            'Position', [0.3 0.800 0.4 0.2] , ...
            'Style', 'text', ...
            'String', 'It is a tie', 'BackgroundColor', 'w', ...
            'FontSize', 25);
        disp("It is a tie")
        break
    end
    
    %first player is on turn
    if turn == 1
        
        if (realPlayer)
            board = GUI(board, handles, realPlayer, player1);
        else
            board = GUI(board, handles, true, player1);
        end
        
        %check if the move secured win
        [board, gameOver] = checkBoard(board, player1);
        
        pause(0.1);
        %display board (simple gui)
        %basicGui(board)
        GUI(board, handles, false, player1);
        
        %if player secured win
        %lets end the game
        if gameOver
            
            uicontrol('Units', 'normalized', ...
                'Position', [0.3 0.800 0.4 0.2] , ...
                'Style', 'text', ...
                'String', 'Red player wins', 'BackgroundColor', 'r', ...
                'FontSize', 25);
            disp("Player 1 wins!!!!")
            break
        end
        %if not change turn
        turn = 2;
        
        %second player is on turn
    elseif turn == 2
        if (realPlayer)
            board = GUI(board, handles, realPlayer, player2);
        else
            %lets make a random move
            board = makeRandomMove(board, player2);
        end
        
        %check if the move secured win
        [board, gameOver] = checkBoard(board, player2);
        pause(0.1);
        %display board (simple gui)
        % basicGui(board)
        GUI(board, handles, false, player2);
        
        %if player secured win
        %lets end the game
        if gameOver
            
            uicontrol('Units', 'normalized', ...
                'Position', [0.3 0.800 0.4 0.2] , ...
                'Style', 'text', ...
                'String', 'Blue player wins', 'BackgroundColor', 'b', ...
                'FontSize', 25);
            disp("Player 2 wins!!!!")
            break
        end
        %if not change turn
        turn = 1;
    end
end

end

%Simple gui for describing a board
function basicGui(board)
image(board)
display(board)
end

%Function that will make correct random move
%   inputs:
%   board - put there board, that we want to change
%   player - specify which player should make a move
%
%   output:
%   board - outputs updatedBoard with 1 more player disc
function board = makeRandomMove(board, player)
%determine which indexes we can use
indexes = size(board);

%choose random index
coord = randi([1 indexes(2)]);

%if this index is ocupied -> find another
while board(1,coord) ~= 0
    coord = randi([1 indexes(2)]);
end

%apply gravity on chosen coord
board = applyGravity(board, player, coord);
end

%Function that will make correct move on chosen coord
%   inputs:
%   board - put there board, that we want to change
%   player - specify which player should make a move
%   index - specify on which index we want to put a disc
%
%   output:
%   board - outputs updatedBoard with 1 more player disc
function board = applyGravity(board, player, index)
indexes = size(board);

%When we find the empty field which is at the bottom
flag = false;
%Now we are looking for first empty space in range N:1
for n = indexes(1):-1:1
    for ni = 1:indexes(2)
        %if this place is empty(0) -> we can put disc here and break the
        %cycle
        if and(ni == index, board(n,ni) == 0)
            board(n,ni) = player;
            flag = true;
            break
        end
    end
    %if we find it break the cycle
    if flag
        break
    end
end
end

%This function will check if the game is over
%that means if there are diagonally/horizontaly/verticaly 4 discs of
%current player -> return true
%
%   output:
%   isOver - returns True or False -> depends if is it over or not
function [board, isOver] = checkBoard(board, player)
isOver = false;
[board1, isOver1] = checkHorizontal(board, player);
[board2, isOver2] = checkVertical(board, player);
[board3, isOver3] = checkDiagonal(board, player);
if (isOver1)
    board = board1;
    isOver = isOver1;
elseif (isOver2)
    board = board2;
    isOver = isOver2;
elseif(isOver3)
    board = board3;
    isOver = isOver3;
end
end

%Check if the game is finished in all horizontal lines
%
%   output:
%   isOver - returns True or False -> depends if is it over or not
function [board1, isOver] = checkHorizontal(board, player)
isOver = false;
indexes = size(board);
board1 = board;

%count it for every line
for n = 1:indexes(1)
    %reset board if we are on new line
    counter = 0;
    for ni = 1:indexes(2)
        %If we not find our disc -> lets reset counter
        if board(n, ni) ~= player
            counter = 0;
            board1 = board;
        end
        
        %if we find our disc, lets increase counter by 1
        if (board(n,ni) == player)
            counter = counter + 1;
            if (player == 2)
                board1(n,ni) = 2.5;
            elseif (player == 1)
                board1(n,ni) = 1.5;
            end
        end
        
        if (counter == 4)
            isOver = true;
            break;
        end
    end
    %if we fonund it -> break the cycle
    if isOver
        break
    end
end
end

%Check if the game is finished in all vertical lines
%
%   output:
%   isOver - returns True or False -> depends if is it over or not
function [board1, isOver] = checkVertical(board, player)
isOver = false;
indexes = size(board);
board1 = board;

%count it for every line
for n = 1:indexes(2)
    %reset board if we are on new line
    counter = 0;
    for ni = 1:indexes(1)
        %If we not find our disc -> lets reset counter
        if board(ni, n) ~= player
            counter = 0;
            board1 = board;
        end
        
        %if we find our disc, lets increase counter by 1
        if (board(ni,n) == player)
            counter = counter + 1;
            if (player == 2)
                board1(ni,n) = 2.5;
            elseif (player == 1)
                board1(ni,n) = 1.5;
            end
        end
        
        if (counter == 4)
            isOver = true;
            break;
        end
    end
    %if we fonund it -> break the cycle
    if isOver
        break
    end
end
end

%Check if the game is finished in all diagonal lines
%   For every direction
%       for every coordinate
%           we will check if there exist 3 more same numbers
%   output:
%   isOver - returns True or False -> depends if is it game over or not
function [board, isOver] = checkDiagonal(board, player)
isOver = false;
indexes = size(board);

%all direction
directions = [1 0; 1 -1; 1 1; 0 1];

%for every direction
for n = 1:length(directions)
    lenCoord = directions(n, 1);
    widCoord = directions(n, 2);
    %check every coordinate
    for x = 1:indexes(1)
        for y = 1:indexes(2)
            prevX = x + 3*lenCoord;
            prevY = y + 3*widCoord;
            %if it is in range
            if (prevX  <= indexes(1) && prevY <= indexes(2))
                if (prevX >= 1 && prevY >= 1)
                    %check if there 4 same discs
                    nowCoord = board(x,y);
                    xCoord = x+2*lenCoord;
                    yCoord = y+2*widCoord;
                    if (xCoord  > indexes(1) || yCoord > indexes(2) || xCoord < 1 || yCoord < 1)
                        continue;
                    end
                    if (nowCoord == player && board(x+lenCoord, y+widCoord) == player && ...
                            player == board(xCoord, yCoord)&&player == board(prevX, prevY))
                        %it there are -> lets return true
                        if (player == 2)
                            board(x,y) = 2.5;
                            board(x+lenCoord, y+widCoord) = 2.5;
                            board(xCoord, yCoord) = 2.5;
                            board(prevX, prevY) = 2.5;
                        elseif (player == 1)
                            board(x,y) = 1.5;
                            board(x+lenCoord, y+widCoord) = 1.5;
                            board(xCoord, yCoord) = 1.5;
                            board(prevX, prevY) = 1.5;
                        end
                        isOver = true;
                        return
                    end
                end
            end
        end
    end
end

end

%lets start making GUI
%board is my board which i will get
function board = GUI (board, handles, realPlayer, player)
indexes = size(board);
lengthOfBoard = indexes(1);
widthOfBoard = indexes(2);

%my map where i will draw all ties
map = zeros(15 * lengthOfBoard, 15* widthOfBoard, 3);

handles.image = image(map, 'Parent', handles.axes);

%if it is start turn -> show only empty board
for i = 1:lengthOfBoard
    for j = 1:widthOfBoard
        img = chooseImg(board(i,j));
        map((i-1)*15+1:i*15, (j-1)*15+1:j*15, :) = img;
    end
end

%%tady spocitam v jaky ctverecku jsem podle map
handles.image.CData = map;
drawnow;
if (realPlayer)
    handles.image.ButtonDownFcn = @(src, event) clickCallback(src, event, handles.fig, handles.axes, lengthOfBoard, widthOfBoard);
    uiwait(handles.fig)

    data = getappdata(handles.fig, 'MyPos');
    x = data(1);
    while board(1,x) ~= 0
        handles.image.ButtonDownFcn = @(src, event) clickCallback(src, event, handles.fig, handles.axes, lengthOfBoard, widthOfBoard);
        uiwait(handles.fig)

        data = getappdata(handles.fig, 'MyPos');
        x = data(1);
    end
    board = applyGravity(board, player, x);
end

end

%function on choosing image
function img = chooseImg(player)
img0 = zeros(15, 15, 3);
img0(:, :, 1) = [ ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    ];
img0(:, :, 2) = [ ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    ];
img0(:, :, 3) = [ ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    ];


img1 = zeros(15, 15, 3);
img1(:, :, 1) = [ ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    ];

img15 = zeros(15, 15, 3);
img15(:, :, 1) = [ ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 255 255 0 255 255 0 0 0 0 0; ...
    0 0 0 255 255 255 255 0 255 255 255 255 0 0 0; ...
    0 0 255 255 255 255 255 0 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 0 255 255 255 255 255 0 0; ...
    0 255 255 255 255 255 255 0 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 0 255 255 255 255 255 255 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 255 255 255 255 255 255 0 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 0 255 255 255 255 255 255 0; ...
    0 0 255 255 255 255 255 0 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 0 255 255 255 255 255 0 0; ...
    0 0 0 255 255 255 255 0 255 255 255 255 0 0 0; ...
    0 0 0 0 0 255 255 0 255 255 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    ];

img2 = zeros(15, 15, 3);
img2(:, :, 3) = [ ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 255 255 255 255 255 255 255 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 255 255 255 255 255 255 0 0; ...
    0 0 0 255 255 255 255 255 255 255 255 255 0 0 0; ...
    0 0 0 0 0 255 255 255 255 255 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    ];

img25 = zeros(15, 15, 3);
img25(:, :, 3) = [ ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 0 0 0 0 255 255 0 255 255 0 0 0 0 0; ...
    0 0 0 255 255 255 255 0 255 255 255 255 0 0 0; ...
    0 0 255 255 255 255 255 0 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 0 255 255 255 255 255 0 0; ...
    0 255 255 255 255 255 255 0 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 0 255 255 255 255 255 255 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    0 255 255 255 255 255 255 0 255 255 255 255 255 255 0; ...
    0 255 255 255 255 255 255 0 255 255 255 255 255 255 0; ...
    0 0 255 255 255 255 255 0 255 255 255 255 255 0 0; ...
    0 0 255 255 255 255 255 0 255 255 255 255 255 0 0; ...
    0 0 0 255 255 255 255 0 255 255 255 255 0 0 0; ...
    0 0 0 0 0 255 255 0 255 255 0 0 0 0 0; ...
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
    ];

%who is on turn
switch player
    case 0
        img = img0;
    case 1
        img = img1;
    case 1.5
        img = img15;
    case 2
        img = img2;
    case 2.5
        img = img25;
end

end

function clickCallback(src, event, fig, ax, lengthOfBoard, widthOfBoard)
% position = fig.
currentPos = fig.CurrentPoint;
axPosition = ax.Position;

xPos = ceil(currentPos(1) / (axPosition(3) / widthOfBoard));
yPos = ceil((axPosition(4) - currentPos(2)) / (axPosition(4) / lengthOfBoard));

pos = [xPos, yPos];
setappdata(fig, 'MyPos', pos);
% vypisData(fig)
uiresume(fig)
end
