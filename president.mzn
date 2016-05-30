/*
The Presidental Question

Horribly difficult test question:
Xxxx xx xxx xx xxx xxxxx xxxxx xx xxx xxxx xxxxx xxxxx xxx, xx xxx xxxx xxx xx 
xxx xxxxxxx xx xxx xxxx xx xx xxx x xxx xx xxx xxxx xxxxxx xxx xx xx xxx xxxx 
xxx xx xx xxx xxxx xxx xx xx xxx xxxx xxx xx xx xxx xxxx xxx?

a)   All of the below
b)   None of the below
c)   All of the above
d)   Exactly one of the above
e)   None of the above
f)   None of the above

Found on
http://puzzling.stackexchange.com/questions/26129/how-to-become-president-of-the-united-states-of-america

Model created by Max Block
*/

int: n = 6; % Number of questions
array[1..n] of var bool: truth; % Truth values

% Declare variables
var bool: a;
var bool: b;
var bool: c;
var bool: d;
var bool: e;
var bool: f;

% Make sure the short variables are the same as the corresponding in truth
constraint a <-> truth[1];
constraint b <-> truth[2];
constraint c <-> truth[3];
constraint d <-> truth[4]; 
constraint e <-> truth[5]; 
constraint f <-> truth[6];

% Model the answers' meanings
constraint a <-> b /\ c /\ d /\ e /\ f;
constraint b <-> not c /\ not d /\ not e /\ not f;
constraint c <-> a /\ b;
constraint d <-> sum (i in 1..3) (bool2int(truth[i])) = 1;
constraint e <-> not a /\ not b /\ not c /\ not d;
constraint f <-> not a /\ not b /\ not c /\ not d /\ not e;

solve :: bool_search([a,b,c,d,e,f], first_fail, indomain_min, complete) satisfy;