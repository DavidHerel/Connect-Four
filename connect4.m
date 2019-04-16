%Core implementation of Connect 4
%   inputs:
%   sizeOfBoard - user can specify how big board he wants
%
function connect4(lengthOfBoard, widthOfBoard)   

%take care of inputs
if nargin == 0
    lengthOfBoard = 7;
    widthOfBoard = 6;
elseif nargin == 1
    widthOfBoard = 6;
else
    
end

%initialize board
board = zeros(lengthOfBoard, widthOfBoard);
%gameOver is false
gameOver = false;
%declare which player is on turn
turn = 1;
%declare player1
player1 = 50;
%declare player2
player2 = 1000;

while gameOver ~= true
    %if the board is full -> lets end the game with tie
    if(not(ismember(0, board)))
        disp("It is a tie")
       break 
    end
    
    %first player is on turn
    if turn == 1
        %lets make a random move
        board = makeRandomMove(board, player1);
        
        %check if the move secured win
        gameOver = checkBoard(board, player1);
        
        %display board (simple gui)
        basicGui(board)
        
        %if player secured win
        %lets end the game
        if gameOver
            disp("Player 1 wins!!!!")
            break
        end
        %if not change turn
        turn = 2;
        
    %second player is on turn
    elseif turn == 2
        %lets make a random move
        board = makeRandomMove(board, player2);
        
        %check if the move secured win
        gameOver = checkBoard(board, player2);
        
        %display board (simple gui)
        basicGui(board)
        
        %if player secured win
        %lets end the game        
        if gameOver
            disp("Player 2 wins!!!!")
            break
        end
        %if not change turn
        turn = 1;
    end
    %little pause here to make game smoother
    pause(0.75);
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
function isOver = checkBoard(board, player)
    if checkHorizontal(board, player) || checkVertical(board, player) || checkDiagonal(board, player)
       isOver = true;
    else
        isOver = false;
    end
end

%Check if the game is finished in all horizontal lines
%
%   output:
%   isOver - returns True or False -> depends if is it over or not
function isOver = checkHorizontal(board, player)
    isOver = false;
    indexes = size(board);
    
    %count it for every line
    for n = 1:indexes(1)
        %reset board if we are on new line
        counter = 0;
        for ni = 1:indexes(2)
            %If we not find our disc -> lets reset counter
            if board(n, ni) ~= player
                counter = 0;
            end

            %if we find our disc, lets increase counter by 1
            if (board(n,ni) == player)
                counter = counter + 1;            
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
function isOver = checkVertical(board, player)
    isOver = false;
    indexes = size(board);
    
    %count it for every line
    for n = 1:indexes(2)
        %reset board if we are on new line
        counter = 0;
        for ni = 1:indexes(1)
            %If we not find our disc -> lets reset counter
            if board(ni, n) ~= player
                counter = 0;
            end

            %if we find our disc, lets increase counter by 1
            if (board(ni,n) == player)
                counter = counter + 1;            
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
function isOver = checkDiagonal(board, player)
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
                   if (prevX >= 0 && prevY >= 0)
                       %check if there 4 same discs
                       nowCoord = board(x,y);
                       if (nowCoord == player && board(x+lenCoord, y+widCoord) == player && ...
                               player == board(x+2*lenCoord, y+2*widCoord)&&player == board(prevX, prevY))
                           %it there are -> lets return true
                           isOver = true;
                           return
                       end
                   end
               end
           end
       end
    end
    
end
