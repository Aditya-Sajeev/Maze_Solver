5/10/2025 8:04 PM

To solve this Prolog maze project, I'll develop a predicate find_exit/2 that navigates from a start position to any exit in a maze represented as a 2D list of cells. First, I'll validate the maze structure and confirm it contains exactly one start cell, then locate this starting position by scanning the maze. The core solution will implement a depth-first search algorithm that recursively tries moving in each direction (left, right, up, down), tracking visited positions to avoid cycles. For each potential move, I'll verify it stays within maze boundaries and doesn't hit walls, then determine if it reaches an exit or requires further exploration. The implementation will leverage Prolog's natural backtracking capabilities to explore alternative paths when hitting dead ends. I'll create helper predicates to handle position validation, movement mechanics, and exit detection, gradually building up the action list as the search progresses. This approach takes advantage of Prolog's logical reasoning and pattern matching to elegantly solve the pathfinding problem without needing explicit loop constructs or complex data structures.


5/10/2025 11:46 PM

Solution Psuedocode (Depth-first search that builds a path from start to exit while avoiding walls and previously visited places using backtracking)


5/11/2025 2:12 PM

Solution implementation (Validates the maze has exactly one start position + Finds a path from start to any exit + Fails appropriately for invalid mazes or moves + Works with both bound and unbound second parameters)


5/11/2025 5:25 PM

Efficiency upgrades (Better path representation and move ordering + Addition of cuts and once/1 + Replaced   \+ member/2 with \+ memberchk/2)


5/11/2025 10:47 PM

Fixed errors from efficiency upgrades (Fixed singleton variable warning + Removed difference lists + Reverted to accumulating actions and reversing at the end)