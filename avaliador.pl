% Anaísa Forti da Fonseca
% 11811ECP012

avalia(C,C) :- number(C). %constante

avalia(A+B,Valor) :-
    avalia(A,ValorA),
    avalia(B,ValorB),
    Valor is ValorA + ValorB.

avalia(-A,Valor) :-
    avalia(A,ValorA),
    Valor is -ValorA.

avalia(A-B,Valor) :-
    avalia(A,ValorA),
    avalia(B,ValorB),
    Valor is ValorA - ValorB.

avalia(A*B,Valor) :-
    avalia(A,ValorA),
    avalia(B,ValorB),
    Valor is ValorA * ValorB.

avalia(A/B,Valor) :-
    avalia(A,ValorA),
    avalia(B,ValorB),
    Valor is ValorA / ValorB.


avalia(sen(A),Valor) :-
    avalia(A,ValorA),
    Valor is sin(ValorA).

avalia(cos(A),Valor) :-
    avalia(A,ValorA),
    Valor is cos(ValorA).

avalia(tg(A),Valor) :-
    avalia(A,ValorA),
    Valor is tan(ValorA).

avalia(A^B,Valor) :-
    avalia(A,ValorA),
    avalia(B,ValorB),
    Valor is ValorA**ValorB.

avalia(ln(A),Valor) :-
    avalia(A,ValorA),
    Valor is log(ValorA).

avalia(log(A),Valor) :-
    avalia(A,ValorA),
    Valor is log10(ValorA).

avalia(exp(A),Valor) :-
    avalia(A,ValorA),
    Valor is e**ValorA.

avalia(min(A,B),Valor) :-
    avalia(A,ValorA),
    avalia(B,ValorB),
    Valor is min(ValorA,ValorB).

avalia(max(A,B),Valor) :-
    avalia(A,ValorA),
    avalia(B,ValorB),
    Valor is max(ValorA,ValorB).

avalia(raiz(A),Valor) :-
    avalia(A,ValorA),
    Valor is sqrt(ValorA).

avalia(pi,Valor) :-
    Valor is pi.


/*
-- TESTES --

1 ?- ['avaliador.pl'].
true.

2 ?- avalia(sen(30),X).
X = -0.9880316240928618.

3 ?- avalia(cos(30),X). 
X = 0.15425144988758405.

4 ?- avalia(tg(30),X).  
X = -6.405331196646276.

5 ?- avalia(sen(1)^cos(1),X).   
X = 0.9109582585823961.

6 ?- avalia(tg(30)+15,X).
X = 8.594668803353724.

7 ?- avalia(ln(1),X).
X = 0.0.

8 ?- avalia(ln(2)^2,X).  
X = 0.4804530139182014.

9 ?- avalia(log(10)/2,X).
X = 0.5.

10 ?- avalia(10/max(3,5),X).
X = 2.

11 ?- avalia(3*min(4,7),X).  
X = 12.

12 ?- avalia(10*raiz(4)+exp(0),X).
X = 21.0.

13 ?- avalia(max(2,3)^2+tg(pi),X).
X = 9.0.
*/
