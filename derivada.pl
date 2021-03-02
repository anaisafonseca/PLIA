/*
Programa para determinar a derivada de uma função.
Versão original foi publicada no livro Programming in PROLOG de Clocksin e Mellish.
*/

/*
	deriv(Expressao,X,ExpressaoDerivada) :-
		ExpressaoDerivada é a derivada de Expressao em relação a X.
*/

% a derivada de X em relação a X vale 1
deriv(X,X,1). 
% a derivada de uma constante vale 0
deriv(T,_,0) :- 
    constante(T). 
% a derivada da soma de duas funções é a soma das derivadas das funções
deriv(F+G,X,DF+DG) :-
    deriv(F,X,DF),
    deriv(G,X,DG).
% a derivada da diferença de duas funções
deriv(F-G,X,DF+(-DG)) :-
    deriv(F,X,DF),
    deriv(G,X,DG).
deriv(-F,X,-DF) :-
    deriv(F,X,DF).
deriv(K*F,X,K*DF) :-
    constante(K),!,% corte!!!!
    deriv(F,X,DF).
% a derivada do produto de duas funções 
deriv(F*G,X,DF*G+DG*F) :-
    deriv(F,X,DF),
    deriv(G,X,DG).
% a derivada do quociente de duas funções 
deriv(F/G,X,(DF*G-DG*F)*(G^(-2))) :-
    deriv(F,X,DF),
    deriv(G,X,DG).
% a derivada do função exponencial, com a regra da cadeia!
deriv(exp(F),X,DF*exp(F)) :-
    deriv(F,X,DF).
% a derivada do função seno, com a regra da cadeia!
deriv(sen(F),X,DF*cos(F)) :-
    deriv(F,X,DF).
deriv(cos(F),X,-DF*sen(F)) :-
    deriv(F,X,DF).
deriv(tan(F),X,DF*sec(F)^2) :-
    deriv(F,X,DF).
deriv(sec(F),X,DF*tan(F)*sec(F)^2) :-
    deriv(F,X,DF).
deriv(cotan(F),X,-DF*cossec(F)^2) :-
    deriv(F,X,DF).
deriv(cossec(F),X,-DF*cossec(F)*cotan(F)) :-
    deriv(F,X,DF).
deriv(ln(F),X,DF*F^(-1)) :-  %ln(x)' = 1*x^(-1) = 1/x
    deriv(F,X,DF).
deriv(F^N,X,N*DF*F^(N+(-1))) :-
    constante(N),!,
    deriv(F,X,DF).
deriv(F^G,X,G*F^(G+(-1)*DF+ln(F)*(F^G)*DG)) :-
    deriv(F,X,DF),
    deriv(G,X,DG).
% uma constante pode ser um átomo ou um número
constante(X) :- atom(X);number(X).

/*
	derivada(Expressao,X,ExpressaoDerivada) :-
		ExpressaoDerivada é a derivada de Expressao em relação a X.
*/
derivada(F,X,DF) :-
    deriv(F,X,Aux), 
    simplifica(Aux,DF),!.

%simplificação das expressões
simplifica(X,X) :- constante(X),!.  %simplificar uma constante dá própria constante
simplifica(F,FS) :-
    F =.. [Operacao,X], %operação unária
    simplifica(X,XS),
    faz_operacao(Operacao,XS,FAux),
    reescreve(FAux,FS),!.
simplifica(F,FS) :-
    F =.. [Operacao,X,Y], %operação binária
    simplifica(X,XS),
    simplifica(Y,YS),
    faz_operacao(Operacao,XS,YS,FAux), %faz a operacao binária e retorna FAux
    reescreve(FAux,FS),!. %rescreve da forma mais natural
    
reescreve(X,X) :- constante(X).
reescreve(F,FR) :-
    F =.. [Operacao,X],%operação unária   
    reescreve(X,XR),
    FAux =.. [Operacao,XR],
    reescreve_aux(FAux,FR),!.
reescreve(F,FR) :-
    F =.. [Operacao,X,Y],%operação binária
    reescreve(X,XR),
    reescreve(Y,YR),
    FAux =.. [Operacao,XR,YR],
    reescreve_aux(FAux,FR),!.

reescreve_aux(1*X,X) :- !.
reescreve_aux(X*1,X) :- !.
reescreve_aux(-1+X,X-1) :- !.
reescreve_aux(X+(-Y),X-Y) :- !.
reescreve_aux(X+Y,X-Z) :- number(Y), Y<0, Z is -Y,!.
reescreve_aux(X*Y^(-1),X/Y) :- !.
reescreve_aux(X^(-1)*Y,Y/X) :- !.
reescreve_aux(X,X).  
%faz_operacao/4
faz_operacao(+,X,Y,S) :-
    soma(X,Y,S),!.
faz_operacao(-,X,Y,S) :-
    subtrai(X,Y,S),!.
faz_operacao(*,X,X,P) :-
    exponencial(X,2,P),!.
faz_operacao(*,-X,X,P) :-
    exponencial(X,2,PAux),
    menos(PAux,P),!.
faz_operacao(*,X,-X,P) :-
    exponencial(X,2,PAux),
    menos(PAux,P),!.
faz_operacao(*,X,-Y,P) :-
    produto(X,Y,PAux),
    menos(PAux,P),!.
faz_operacao(*,-X,Y,P) :-
    produto(X,Y,PAux),
    menos(PAux,P),!.
faz_operacao(*,A^X,A^Y,P) :-
    soma(X,Y,S),
    exponencial(A,S,P),!.
faz_operacao(*,X^N,Y^N,P) :-
    produto(X,Y,PAux),
    exponencial(PAux,N,P),!.
faz_operacao(*,X,Y,P) :-
    produto(X,Y,P),!.
faz_operacao(^,X*Y^(-1),-N,E) :-
    exponencial(Y*X^(-1),N,E),!.
faz_operacao(^,X,Y,E) :-
    exponencial(X,Y,E),!.
faz_operacao(/,X,Y,D) :-
    divide(X,Y,D),!.
faz_operacao(Operacao,X,Y,S) :-
    S =.. [Operacao,X,Y],!.
%faz_operacao/3
faz_operacao(-,X+Y,MX+MY) :-
    menos(X,MX),
    menos(Y,MY),!.
faz_operacao(ln,1,0) :- !.
faz_operacao(ln,exp(X),X) :- !.
faz_operacao(exp,0,1) :- !.
faz_operacao(exp,ln(X),X) :- !.
faz_operacao(sen,0,0) :- !.
faz_operacao(sen,-X,-sen(X)) :- !.
faz_operacao(cos,0,1) :- !.
faz_operacao(cos,-X,cos(X)) :- !.
faz_operacao(Operacao,X,S) :-
    S =.. [Operacao,X],!.

divide(X,X,1) :- !.
divide(X,1,X) :- !.
divide(1,X,X^(-1)) :- !.
divide(sen(X),cos(X),tan(X)) :- !.
divide(X,Y,D) :- 
    number(X),
    number(Y), 
    D is X/Y,!.

produto(_,0,0) :- !.
produto(0,_,0) :- !.
produto(1,X,X) :- !.
produto(X,1,X) :- !.
produto(X,Y,P) :- 
    number(X),
    number(Y), 
    P is X*Y,!.
produto(X,X,X^2) :- !.

exponencial(1,_,1) :- !.
exponencial(X,1,X) :- !.
exponencial(_,0,1) :- !.
exponencial(X,Y,1/E) :-
    number(Y), 
    Y<0,
    YP is -Y,
    exponencial(X,YP,E),!.
exponencial(X,Y,E) :-
    number(X),
    number(Y), 
    E is X^Y,!.

menos(-X,X) :-!.
menos(0,0) :- !.
menos(X,MX) :- 
    number(X),
    MX is -X,!.

soma(X,0,X) :- !.
soma(0,X,X) :- !.
soma(X,Y,S) :-
    number(X),
    number(Y),
    S is X+Y,!.
soma(X,-X,0) :- !.
soma(-X,X,0) :- !.
soma(A*X,B*X,S*X) :-
    number(A),
    number(B),
    S is A+B,!.
soma(A*X,X,S*X) :-
    number(A),
    S is A+1,!.
soma(X,A*X,S*X) :-
    number(A),
    S is A+1,!.
soma(A,A,2*A) :- !.

subtrai(X,X,0) :- !.
subtrai(X,0,X) :- !.
subtrai(0,X,X) :- !.
subtrai(X,Y,S) :-
    number(X),
    number(Y),
    S is X-Y,!.
subtrai(X,-X,2*X) :- !.
subtrai(-X,X,-2*X) :- !.
subtrai(A*X,B*X,S*X) :-
    number(A),
    number(B),
    S is A-B,!.
subtrai(A*X,X,S*X) :-
    number(A),
    S is A-1,!.
subtrai(X,A*X,S*X) :-
    number(A),
    S is A-1,!.