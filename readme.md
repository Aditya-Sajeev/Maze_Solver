# Prolog Maze Solver

This project implements a maze solving algorithm in Prolog that finds a path from a starting position to an exit in a two-dimensional maze.

## Files Overview

- **solver.pl**: Contains the main maze solving implementation with the `find_exit/2` predicate
- **example.pl**: Provides predefined test mazes and maze display functionality
- **test.pl**: Contains functionality to generate random mazes of varying sizes and complexity
- **devlog.md**: Project log that shows thought process and development process

## File Descriptions

### solver.pl

The core implementation file that contains:
- `find_exit/2`: Main predicate that finds a path from start to exit
- `validate_maze/1`: Ensures the maze has exactly one start position
- `solve/4`: Core pathfinding implementation using depth-first search
- Helper predicates for checking valid moves and positions

### example.pl

Contains:
- Predefined test mazes (simple_map, basic_map, basic_map2)
- Invalid test mazes (bad_map, bad_map2, bad_map3, bad_map4)
- `display_map/1`: Predicate for pretty-printing mazes in the console

### test.pl

Provides:
- `gen_map/4`: Generates random mazes with specified complexity, rows, and columns
- `show_random_map/3`: Convenience predicate to generate and display a random maze
- Helper predicates for maze generation

## Running the Program

### Command Line Usage

1. Ensure SWI-Prolog is installed on your system.

2. Launch SWI-Prolog with all required files:
   ```
   swipl -s solver.pl -s example.pl -s test.pl
   ```
   
   Alternatively, from within the Prolog interpreter:
   ```
   ?- [solver, example, test].
   ```

3. Test with predefined mazes:
   ```
   ?- simple_map(M), find_exit(M, Actions).
   ?- basic_map(M), find_exit(M, Actions).
   ```

4. Generate and solve random mazes:
   ```
   ?- gen_map(4, 10, 10, M), display_map(M), find_exit(M, Actions).
   ```
   Where:
   - First parameter (4): Controls maze complexity (recommended value: 4)
   - Second parameter (10): Number of rows
   - Third parameter (10): Number of columns
   - M: Variable to hold the generated maze
   - Actions: Variable to hold the solution path

5. Visualize mazes:
   ```
   ?- basic_map(M), display_map(M).
   ?- gen_map(4, 10, 10, M), display_map(M).
   ```

## Maze Format

Mazes are represented as lists of lists, where each inner list represents a row. Each cell can be:
- `s`: The starting position (exactly one per maze)
- `e`: Exit position(s)
- `f`: Floor/empty space
- `w`: Wall

## Solution Format

The solution is a list of actions: `up`, `down`, `left`, and `right` that lead from the start position to an exit.

## Example Usage

```prolog
% Load all files
?- [solver, example, test].

% Generate and display a random 10x10 maze
?- gen_map(4, 10, 10, M), display_map(M).

% Solve the displayed maze
?- find_exit(M, Actions).

% Generate, display, and solve a maze in one query
?- gen_map(4, 10, 10, M), display_map(M), find_exit(M, Actions).
```
