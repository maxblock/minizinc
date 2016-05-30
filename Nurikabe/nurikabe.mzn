% A solver for the logic puzzle Nurikabe
% In the puzzle, islands are to be placed such that the size of the islands 
% correspond to given sizes. The islands are separated by a coherent stream.

% Author: Max Block, GitHub: maxblock

%%%%%%%%%%%%%%%%%%
% INSTANCE DATA
%%%%%%%%%%%%%%%%%%
int: m = 8; % The height of the board
int: n = 6; % The width of the board

set of int: M = 1..m;
set of int: N = 1..n;

array[M, N] of 0..m*n: sizes = [| 0, 0, 0, 0, 0, 0
                                | 0, 0, 5, 0, 0, 0
                                | 0, 1, 0, 2, 0, 0
                                | 0, 0, 0, 0, 0, 4
                                | 5, 0, 0, 0, 0, 0
                                | 0, 0, 2, 0, 1, 0
                                | 0, 0, 0, 0, 0, 3
                                | 0, 0, 0, 0, 0, 0 |];

string: filled = "X";
string: empty = ".";

%%%%%%%%%%%%%%%%%%
% VARIABLES
%%%%%%%%%%%%%%%%%%
array[M, N] of var 0..m*n: board;

%%%%%%%%%%%%%%%%%%
% CONSTRAINTS
%%%%%%%%%%%%%%%%%%
% Each numbered cell is part of an island, indicating the island's size
constraint forall (i in M, j in N) (sum (k in M, l in N) 
  (bool2int(board[k,l] == j + (i-1) * n)) == sizes[i,j]);

% The numbered cell is part of the correct island
constraint forall (i in M, j in N)
  (sizes[i,j] != 0 -> board[i,j] == j + (i-1) * n);

% All island cells are adjacent to another cell of the same island, if it is not of size 1
constraint forall (i in M, j in N)
  (true); %TODO

% The stream is a single coherent whole
constraint forall (i in M, j in N)
  (true); %TODO

% Islands should not connect to each other
constraint forall (i in 2..m-1, j in 2..n-1) (
    board[i,j] != 0 -> (
        (board[i+1, j  ] == 0 \/ board[i+1, j  ] == board[i, j]) /\
        (board[i  , j+1] == 0 \/ board[i  , j+1] == board[i, j]) /\
        (board[i-1, j  ] == 0 \/ board[i-1, j  ] == board[i, j]) /\
        (board[i  , j-1] == 0 \/ board[i  , j-1] == board[i, j])
));

% There are no 2x2 squares in the stream
constraint forall (i in 1..m-1, j in 1..n-1) (
    board[i  , j  ] != 0 \/
    board[i+1, j  ] != 0 \/
    board[i  , j+1] != 0 \/
    board[i+1, j+1] != 0
    );
%TODO: Check sum > 0 instead?

%%%%%%%%%%%%%%%%%%
% IMPLIED CONSTRAINTS / SYMMETRY BREAKING
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
% SOLVE / OUTPUT
%%%%%%%%%%%%%%%%%%
solve satisfy;

output [if j = 1 then "\n" else "" endif ++
        show(if board[i,j] > 0 then filled else empty endif)
        | i in M, j in N];