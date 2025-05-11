% Main predicate
find_exit(Maze, Actions) :-
    % Step 1: Validate the maze has exactly one start position
    validate_maze(Maze),
    
    % Step 2: Find the start position coordinates
    find_start(Maze, StartRow, StartCol),
    
    % Step 3: Find a path from start to exit
    % Initialize visited list with start position
    solve(Maze, StartRow, StartCol, [(StartRow, StartCol)], [], ReversedActions),
    
    % Step 4: Reverse the action list for correct order
    reverse(ReversedActions, Actions).

% Validate maze has exactly one start position
validate_maze(Maze) :-
    count_start_positions(Maze, 1).

% Count start positions in maze
count_start_positions(Maze, Count) :-
    flatten(Maze, FlatMaze),
    count_occurrences(FlatMaze, s, Count).

% Find the start position coordinates
find_start(Maze, Row, Col) :-
    nth0(Row, Maze, MazeRow),
    nth0(Col, MazeRow, s).

% Core recursive path-finding algorithm
solve(Maze, Row, Col, Visited, AccActions, Actions) :-
    % Check if current position is an exit
    is_exit(Maze, Row, Col)
    -> Actions = AccActions  % Success - return accumulated actions
    ;  % Not at exit yet, try a move
       try_move(Maze, Row, Col, Visited, AccActions, Actions).

% Try each possible move direction
try_move(Maze, Row, Col, Visited, AccActions, Actions) :-
    % Choose a move (left, right, up, or down)
    member(Move, [left, right, up, down]),
    
    % Calculate new position after move
    apply_move(Move, Row, Col, NewRow, NewCol),
    
    % Check if new position is valid
    valid_move(Maze, NewRow, NewCol),
    
    % Check if new position hasn't been visited
    \+ member((NewRow, NewCol), Visited),
    
    % Recursively continue from new position
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