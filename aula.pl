/* SEASON 01 */

%___________________________________________________________________________________________
/* EPISODE 01 */

gosta(murilo,banana).
gosta(murilo,goiaba).

/*
Fato é uma verdade expressa em prolog.
É uma relação entre dois objetos (termos).
"gosta" é o nome da relação, aqui, denomiraremos como funtor.
"gosta" relaciona dois objetos, aqui, 2 é a aridade do fato "gosta".

Um programa prolog é uma coleção de cláusulas, que são regras e fatos.
Hipótese do mundo fechado:
    o que está declarado no programa é verdadeiro e o que não está declarado é falso.
*/


%___________________________________________________________________________________________
/* EPISODE 02 */
/*
Exercício 001
    Represente em prolog a seguinte tabela:

    produto  |  unidade  |  estoque  |  preço
    ---------+-----------+-----------+--------
    farinha  |    kg     |    100    |  2.50
    arroz    |    5kg    |    30     | 25.00
    sabão    |   barra   |    400    |  1.75
*/

produto(farinha,kg,100,2.50).
produto(arroz,5-kg,30,25.00).
produto(sabao,barra,400,1.75).

/*
Para consultar, por exemplo, o preço da farinha fazemos:
    produto(farinha,_,_Preco).
Dev-se utilizar letra maiúscula na variável que deseja encontrar e _ nas que não importam no momento.
*/


%___________________________________________________________________________________________
/* EPISODE 03 */

/*
Variável lógica, substituição, instância.
Variável inicia-se com letra maiúscula ou underscore (_).
Underscore (_) é uma variável sem nome, anônima, ela não retém valor.

= é, em prolog, a unificação (não existe atribuição).
Para atribuições, utiliza-se is:
    A is 1+1.
    #A = 2.
*/


%___________________________________________________________________________________________
/* EPISODE 04 */

% Fatos
homem(marcelo).
homem(igor).
mulher(maria).
mulher(eva).

% Regras:
ser_humano(X) :- homem(X).      %ser_humano(X) <- homem(X)
ser_humano(X) :- mulher(X).

/*
homem(Quem).
#Quem = marcelo ;
#Quem = igor.

mulher(Quem).
Quem = maria ;
Quem = eva.

ser_humano(Quem).
#Quem = marcelo ;
#Quem = igor ;
#Quem = maria ;
#Quem = eva.

ser_humano(hitler).
#false

Regra é uma construção para generalização.
Uma regra tem uma cabeça (head) e um corpo (body). Regra é <cabeça> :- <corpo>.
O corpo de uma regra é formado por uma sequência de predicados separados por vírgula (e-lógico)ou por ponto e vírgula (ou-lógico).
    ser_humano(X) :- homem(X);mulher(X)
*/


%___________________________________________________________________________________________
/* EPISODE 05 */

/*
Regras e desenvolvimento "topdown"
Veja: https://pt.wikipedia.org/wiki/Abordagem_top-down_e_bottom-up

Resolução da equação de 2o grau.
Ax2 + bx + c = 0
delta<0 -> não existem raízes reais.
delta=0 -> existe uma única raiz real.
delta>0 -> existem duas raízes reais.
Será retornado: resposta(2) resposta(2,3) ou resposta('não existem raízes reais').
*/

resolve2grau(A,B,C,Resp) :-
    calcula_delta(A,B,C,Delta),
    calcula_raizes(A,B,Delta,Resp).

calcula_delta(A,B,C,Delta) :-
    Delta is B*B-4*A*C.

calcula_raizes(_,_,Delta,resposta('nao existem raizes reais')) :-
    Delta < 0.
calcula_raizes(A,B,Delta,resposta(Raiz)) :-
    Delta = 0,
    Raiz is -B/(2*A).
calcula_raizes(A,B,Delta,resposta(Raiz1,Raiz2)) :-
    Delta > 0,
    RaizDelta is sqrt(Delta),
    Raiz1 is (-B+RaizDelta)/(2*A),
    Raiz2 is (-B-RaizDelta)/(2*A).

/*
resolve2grau(1,-5,6,Resp).
#Resp = resposta(3.0,2.0).

resolve2grau(1,-5,8,Resp).
#Resp = resposta('nao existem raizes reais')
*/