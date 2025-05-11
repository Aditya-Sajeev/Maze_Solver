% Project 2: Maze Solver
% Predicate find_exit/2 that finds a path from start 's' to exit 'e' in a maze

% Main predicate: find a path from start to exit
find_exit(Maze, Actions) :-
    % Validate the maze has exactly one start position
    validate_maze(Maze),
    
    % Find the start position coordinates
    find_start(Maze, StartRow, StartCol),
    
    % Solve the maze using depth-first search
    % Initialize empty visited list and action accumulator
    solve(Maze, StartRow, StartCol, [(StartRow, StartCol)], [], ReversedActions),
    
    % Reverse the accumulated actions to get correct order
    reverse(ReversedActions, Actions).

% Validate that maze has exactly one start position
validate_maze(Maze) :-
    flatten(Maze, FlatMaze),
    include(=(s), FlatMaze, StartCells),
    length(StartCells, 1).

% Find the start position coordinates
find_start(Maze, Row, Col) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, s).

% Core pathfinding algorithm
% Base case: current position is an exit, return accumulated actions
solve(Maze, Row, Col, _, AccActions, AccActions) :-
    is_exit(Maze, Row, Col).

% Recursive case: try to move in some direction
solve(Maze, Row, Col, Visited, AccActions, Actions) :-
    % Try one of the four possible moves
    member(Move, [left, right, up, down]),
    
    % Calculate new position after move
    apply_move(Move, Row, Col, NewRow, NewCol),
    
    % Check if the move is valid (within bounds and not a wall)
    valid_move(Maze, NewRow, NewCol),
    
    % Check that we havent visited this position before
    \+ member((NewRow, NewCol), Visited),
    
    % Continue search from new position
    solve(Maze, NewRow, NewCol, [(NewRow, NewCol)|Visited], [Move|AccActions], Actions).

% Apply a move to current coordinates
apply_move(left, Row, Col, Row, NewCol) :- NewCol is Col - 1.
apply_move(right, Row, Col, Row, NewCol) :- NewCol is Col + 1.
apply_move(up, Row, Col, NewRow, Col) :- NewRow is Row - 1.
apply_move(down, Row, Col, NewRow, Col) :- NewRow is Row + 1.

% Check if position is valid (within bounds and not a wall)
valid_move(Maze, Row, Col) :-
    Row >= 0,
    Col >= 0,
    length(Maze, Rows),
    Row < Rows,
    nth0(Row, Maze, MazeRow),
    length(MazeRow, Cols),
    Col < Cols,
    nth0(Col, MazeRow, Cell),
    Cell \= w.

% Check if position is an exit
is_exit(Maze, Row, Col) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, e).