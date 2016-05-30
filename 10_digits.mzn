% The first digit in a 10 digit number is equal to the number of 1s in the number, the second is the number of 2s and so on. The tenth is the number of 0s. Which number is it?
set of int: digit  = 0..9;
array[1..10] of var digit: number;

constraint forall (i in 1..10) (number[i] = sum (j in 1..10) (bool2int(number[i]== i mod 10)));

solve satisfy;