% Anaísa Forti da Fonseca
% 11811ECP012

% EXERCÍCIO 04
/*
1 ?- [H|T]=[[[]]].
H = [[]],
T = [].

2 ?- [H|T]=[[a,b]].
H = [a, b],
T = [].   

3 ?- [H1,H2|T]=[[a,b]].
false.

4 ?- [H1,H2|T]=[[]|[a]].
H1 = T, T = [],
H2 = a.

5 ?- [_|T]=[a,b|[c]].
T = [b, c].

6 ?- [H|_]=[[a]|b,c].
ERROR: Syntax error: Unexpected comma or bar in rest of list
ERROR: [H|_]=[[a]|
ERROR: ** here ** 
ERROR: b,c] . 

7 ?- [[1],X|X]=[X,Y,Z].
X = Y, Y = [1],
Z = 1.

8 ?- [X|X]=[[]].
X = [].

9 ?- [X|X]=[[],[]].
false.

10 ?- [X,X]=[[],[]].
X = [].

11 ?- [X,Y,_|Z]=[1,2,3,4].
X = 1,
Y = 2,
Z = [4].

12 ?- [X|[_,Z]]=[1,2,3,4].   
false.

13 ?- [X|[Y|Z]]=[1,2,3,4]. 
X = 1,
Y = 2,
Z = [3, 4].

14 ?- [1|[Y,X]]=[X,2,3].
false.

15 ?- 2-2+C=A-B+5.         
C = 5,
A = B, B = 2.

16 ?- 3+0=4-1.
false.

17 ?- 3+02=:=4-1.
false.

18 ?- pai(joao,X)=pai(Y,maria).
X = maria,
Y = joao.

19 ?- pai(Joao,X)=pai(adao,ada). 
Joao = adao,
X = ada.

20 ?- 1+2 is 3.
false.
*/


% EXERCÍCIO 11
multiplo([ H| T]) :- 
    pertence(H,T),!.
multiplo([_| T]) :-
    multiplo(T).

pertence(H,[H|_]).
pertence(X,[_|T]) :- 
    pertence(X,T),!.
/*
?- multiplo([a,b,c,b]).
true.

?- multiplo([a,b,c,d]).
false.
*/


% EXERCÍCIO 12
meio(Lista,X) :-
    append(Metade1,[X|Metade2],Lista),
    length(Metade1,Comprimento),
    length(Metade2,Comprimento).

/*
?- meio([a,b,c,d,e],X).
X = c ;
false.

?- meio([a,b,c,d],X).
false.
*/


% EXERCÍCIO 13
% a)
f(X,Y) :-
    (X>100 -> 
        Y is X-10 ;
        Y is ((X+11)-10)-10).
/*
?- f(200,Y).
Y = 190.

?- f(10,Y).
Y = 1.
*/

% b)
/*
?- f(95,Y).
Y = 86.
*/


% EXERCÍCIO 14
transforma(C,F) :-
    F is 1.8*C+32.
/*
?- transforma(0,F).
F = 32.0.

?- transforma(100,F).
F = 212.0.
*/


% EXERCÍCIO 19
reverso(Lista, Atsil) :- reverso(Lista, [ ], Atsil).
reverso([ ], A, A).
reverso([ H| T], A, Atsil) :-
    reverso(T,[ H| A], Atsil).
/* 
?- reverso([r,o,m,a],X).
X = [a, m, o, r].

?- reverso([a,m,o,r],X).
X = [r, o, m, a].
*/


% EXERCÍCIO 20
palindrome(Lista) :-
    reverso(Lista,Lista).
/*
?- palindrome([a,r,a,r,a]).
true.

?- palindrome([1,2,3,2,1]).
true.
*/