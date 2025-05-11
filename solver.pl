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

% Validate that maze has exactly one start position - using once for efficiency
validate_maze(Maze) :-
    flatten(Maze, FlatMaze),
    once((
        include(=(s), FlatMaze, StartCells),
        length(StartCells, 1)
    )).

% Find the start position coordinates - using once for efficiency
find_start(Maze, Row, Col) :-
    once((
        nth0(Row, Maze, MazeRow),
        nth0(Col, MazeRow, s)
    )).

% Core pathfinding algorithm with more efficient implementation
solve(Maze, StartRow, StartCol, Actions) :-
    % Use a difference list for more efficient action accumulation
    solve_path(Maze, [(StartRow, StartCol)], [(StartRow, StartCol)], Actions-[]).

% Helper predicate to handle the search with difference lists for better performance
solve_path(Maze, [(Row, Col)|_], Visited, Actions-[]) :-
    % Check if current position is an exit
    is_exit(Maze, Row, Col),
    % Extract the action list from accumulated path
    extract_actions(Visited, Actions).

solve_path(Maze, [(Row, Col)|Path], Visited, Actions) :-
    % Try each move direction in a specific order (optimized for common maze patterns)
    % Choose the moves in a different order (right, down, left, up) for potentially better performance in many mazes
    move_direction(Direction, Row, Col, NewRow, NewCol),
    
    % Check if the move is valid and not previously visited
    valid_move(Maze, NewRow, NewCol),
    \+ memberchk((NewRow, NewCol), Visited),
    
    % Continue search from new position
    solve_path(Maze, [(NewRow, NewCol), (Row, Col)|Path], [(NewRow, NewCol)|Visited], Actions).

% Ordered move directions for potentially better performance in common maze patterns
move_direction(right, Row, Col, Row, NewCol) :- NewCol is Col + 1.
move_direction(down, Row, Col, NewRow, Col) :- NewRow is Row + 1.
move_direction(left, Row, Col, Row, NewCol) :- NewCol is Col - 1.
move_direction(up, Row, Col, NewRow, Col) :- NewRow is Row - 1.

% Extract actions from a path of coordinates
extract_actions([(R2, C2), (R1, C1)|Path], [Action|Actions]-Tail) :-
    % Determine the action taken to move from (R1,C1) to (R2,C2)
    determine_action(R1, C1, R2, C2, Action),
    extract_actions([(R1, C1)|Path], Actions-Tail).
extract_actions([_], T-T).

% Determine which action was taken between two positions
determine_action(R, C1, R, C2, right) :- C2 is C1 + 1.
determine_action(R, C1, R, C2, left) :- C2 is C1 - 1.
determine_action(R1, C, R2, C, down) :- R2 is R1 + 1.
determine_action(R1, C, R2, C, up) :- R2 is R1 - 1.

% Check if position is valid (within bounds and not a wall) - with cut for efficiency
valid_move(Maze, Row, Col) :-
    Row >= 0,
    Col >= 0,
    length(Maze, Rows),
    Row < Rows,
    nth0(Row, Maze, MazeRow),
    length(MazeRow, Cols),
    Col < Cols,
    nth0(Col, MazeRow, Cell),
    Cell \= w,
    !.

% Check if position is an exit - with cut for efficiency
is_exit(Maze, Row, Col) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, e),
    !.