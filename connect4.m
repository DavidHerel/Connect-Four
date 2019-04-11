%Core implementation of Connect 4
%   inputs:
%   sizeOfBoard - user can specify how big board he wants
%               - for instance: sizeOfBoard = 4 will create board 4x4
%
%   output:
%   board - returns final board with current win formation
function board = connect4(lengthOfBoard, widthOfBoard)   

%initialize board
board = zeros(lengthOfBoard, widthOfBoard);
%gameOver is false
gameOver = false;
%declare which player is on turn
turn = 1;
%declare player1
player1 = 50;
%declare player2
player2 = 100;

while gameOver ~= true
    if turn == 1
        board = makeRandomMove(board, player1);
        gameOver = checkBoard(board, player1);
        turn = 2;
    elseif turn == 2
        board = makeRandomMove(board, player2);
        gameOver = checkBoard(board, player2);
        turn = 1;
    end
    image(board)
    display(board)
    if gameOver
        break
    end
    pause(1);
end

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
%current player
%
%   output:
%   isOver - returns True or False -> depends if is it over or not
function isOver = checkBoard(board, player)
    isOver = false;
    isOver = checkHorizontal(board, player);
    isOver = checkVertical(board, player);
  %  isOver = checkDiagonal(board, player);
end

%Check if the game is finished in all horizontal lines
%
%   output:
%   isOver - returns True or False -> depends if is it over or not
function isOver = checkHorizontal(board, player)
    counter = 0;
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
    counter = 0;
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
%
%   output:
%   isOver - returns True or False -> depends if is it over or not
function isOver = checkDiagonal(board, player)
end
