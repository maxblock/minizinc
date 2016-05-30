% Model for the Parking Lot Layout Problem:
% Given a rectangular parking lot of size m x n, fit in as many cars as possible
% Each parked car must have a clear path to the exit, situated at (1,1)

% Author: Max Block

%%%%%%%%%%%%%%%%%%
% INSTANCE DATA
%%%%%%%%%%%%%%%%%%
int: m;
int: n;
string: car_symbol = "O";
string: empty_symbol = ".";

%%%%%%%%%%%%%%%%%%
% VARIABLES
%%%%%%%%%%%%%%%%%%
array[1..m, 1..n] of var bool: lot;
var 0..m*n: ncars = sum (M in 1..m, N in 1..n) (lot[M,N]);

%%%% REDUNDANT %%%%
array[1..m, 1..n] of var bool: path;
array[1..m, 1..n] of var 0..m*n: dist;

%%%%%%%%%%%%%%%%%%
% CONSTRAINTS
%%%%%%%%%%%%%%%%%%
% The corner is part of the path
constraint path[1,1];
constraint dist[1,1] = 0;

% Channeling: Parked cars are not in path
constraint forall (M in 1..m, N in 1..n) (lot[M,N] <-> not path[M,N]);

% Parked cars have access to path
constraint forall (M in 1..m, N in 1..n) (lot[M,N] ->
    path[M-1,N] \/ 
    path[M,N-1] \/ 
    path[M+1,N] \/ 
    path[M,N+1]);

% Path is cohesive:
% Each path tile is connected to a path tile with lower distance (-1)
constraint forall (M in 1..m, N in 1..n) (
    if lot[M,N] \/ (M=1 /\ N=1) then true else
        dist[M,N] = dist[M-1,N] + 1 \/
        dist[M,N] = dist[M+1,N] + 1 \/
        dist[M,N] = dist[M,N-1] + 1 \/
        dist[M,N] = dist[M,N+1] + 1
    endif);

% The cells with a car in it
constraint forall (M in 1..m, N in 1..n) (lot[M,N] -> dist[M,N] = m*n);

%%%%%%%%%%%%%%%%%%
% IMPLIED CONSTRAINTS / SYMMETRY BREAKING
%%%%%%%%%%%%%%%%%%
% Both of the first two positions can not be a car if n,m > 2
%constraint min(m,n) > 2 -> path[1,2];

% Not all 3 spots in a corner can be cars, and we can pick which 2
%constraint min(m,n) > 2 -> path[m,2] /\ path[2, n] /\ path [m-1, n];
%constraint min(m,n) > 2 -> lot[m,1] /\ lot[m,n] /\ lot[1,n] /\
%                           lot[m-1,1] /\ lot[m,n-1] /\ lot[1,n-1];

% We have an upper bound of the possible number of cars
constraint ncars <= (2*m*n div 3);

% Left wall may be all cars
%constraint forall (M in 2..m) (lot[M,1]);

% We need to be able to get to the left wall cars
%constraint forall (M in 1..m) (path[M,2]);

% Top wall may be all cars
%constraint forall (N in 3..n) (lot[1,N]);
%%%%%%%%%%%%%%%%%%
% SOLVE / OUTPUT
%%%%%%%%%%%%%%%%%%
% Take shortest manhattan distance first
array[1..m*n] of var bool: onedlot = array1d(lot);
array[1..m*n] of int: onedmanhattan = [i div n + (i-1) mod n | i in 1..m*n];
array[1..m*n] of 1..(m*n): manhattan_args = arg_sort(onedmanhattan);
array[1..m*n] of var bool: manhattan_sorted = [onedlot[manhattan_args[i]] | i in 1..m*n];

%solve :: bool_search(manhattan_sorted, input_order, indomain_min, complete) maximize ncars;

% Solve by default search
solve maximize ncars;

output [if N = 1 then "\n" else "" endif ++
        show(if path[M,N] then empty_symbol else car_symbol endif)
        | M in 1..m, N in 1..n] ++
        ["\nncars: " ++ show(ncars)];
        % ++ ["\nDist:\n"] ++[if N = 1 then "\n" else "" endif ++ show(if dist[M,N]=m*n then empty_symbol else show(dist[M,N]) endif)| M in 1..m, N in 1..n]; 