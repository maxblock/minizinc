% Each asterisk corresponds to a digit. All terms are palindromes (e.g 1221, 5995)
% Leading digits are non-zero
% The equation to satisfy: ** + *** = ****

set of int: digit = 0..9;
set of int: pos = 1..9;
var pos: a;
var pos: b;
var digit: c;
var pos: d;
var digit: e;

constraint 11*a + 101*b+10*c = 1001*d+110*e;

solve satisfy;