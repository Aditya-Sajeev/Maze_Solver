% Project 2: Maze Solver
% Optimized predicate find_exit/2 that finds a path from start 's' to exit 'e' in a maze

% Main predicate: find a path from start to exit
find_exit(Maze, Actions) :-
    % Validate the maze has exactly one start position
    validate_maze(Maze),
    
    % Find the start position coordinates
    find_start(Maze, StartRow, StartCol),
    
    % Solve the maze using depth-first search with efficient visited tracking
    solve(Maze, StartRow, StartCol, Actions).

% Validate that maze has exactly one start position
validate_maze(Maze) :-
    flatten(Maze, FlatMaze),
    include(=(s), FlatMaze, StartCells),
    length(StartCells, 1).

% Find the start position coordinates
find_start(Maze, Row, Col) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, s).

% Core pathfinding algorithm with more efficient implementation
solve(Maze, StartRow, StartCol, Actions) :-
    % Initialize visited positions with starting position
    solve_path(Maze, StartRow, StartCol, [(StartRow, StartCol)], [], RevActions),
    % Reverse to get actions in correct order
    reverse(RevActions, Actions).

% Base case: current position is an exit
solve_path(Maze, Row, Col, _, AccActions, AccActions) :-
    is_exit(Maze, Row, Col).

% Recursive case: try each possible move
solve_path(Maze, Row, Col, Visited, AccActions, FinalActions) :-
    % Try moves in an order that may be more efficient for typical mazes
    member(Move, [right, down, left, up]),
    
    % Calculate new position after move
    apply_move(Move, Row, Col, NewRow, NewCol),
    
    % Check if the move is valid and not previously visited
    valid_move(Maze, NewRow, NewCol),
    \+ memberchk((NewRow, NewCol), Visited),
    
    % Continue search from new position
    solve_path(Maze, NewRow, NewCol, [(NewRow, NewCol)|Visited], [Move|AccActions], FinalActions).

% Apply a move to current coordinates
apply_move(right, Row, Col, Row, NewCol) :- NewCol is Col + 1.
apply_move(left, Row, Col, Row, NewCol) :- NewCol is Col - 1.
apply_move(down, Row, Col, NewRow, Col) :- NewRow is Row + 1.
apply_move(up, Row, Col, NewRow, Col) :- NewRow is Row - 1.

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