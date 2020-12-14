% Anaísa Forti da Fonseca
% 11811ECP012

/*
Esquadrilha de aviões
https://rachacuca.com.br/logica/problemas/esquadrilha-de-avioes/
Nesse problema temos uma esquadrilha de 5 aviões em um show aéreo.
Cada um deles solta fumaça de uma cor e possui uma anomalia diferente.
Além disso, os aviões são comandados por cinco experientes pilotos que
praticam um esporte cada um, além de preferirem uma bebida distinta.

esquadrilha(piloto1,piloto2,piloto3,piloto4,piloto5)
piloto(Nome, Cor, Anomalia, Bebida, Esporte)
*/


resolve(S) :-
    S = esquadrilha(piloto(_,_,_,_,_),
                    piloto(_,_,_,_,_),
                    piloto(_,_,_,_,_),
                    piloto(_,_,_,_,_),
                    piloto(_,_,_,_,_)),

    % o avião de Milton solta fumaça vermelha
    membro(A,S),
    nome(A,milton),
    cor(A,vermelho),

    % o radio de Walter está com problemas
    membro(B,S),
    nome(B,walter),
    anomalia(B,radio),
    
    % o piloto do avião que solta fumaça verde adora pescar
    membro(C,S),
    cor(C,verde),
    esporte(C,pesca),

    % o Rui joga futebol nos finais de semana.
    membro(D,S),
    nome(D,rui),
    esporte(D,futebol),

    % o avião que solta fumaça verde está imediatamente à direita do avião que solta fumaça branca.
    direita(E,F,S),
    cor(E,branco),
    cor(F,verde),

    % o piloto que bebe leite está com o altímetro desregulado.
    membro(G,S),
    bebida(G,leite),
    anomalia(G,altimetro),

    % o piloto do avião que solta fumaça preta bebe cerveja.
    membro(H,S),
    cor(H,preta),
    bebida(H,cerveja),

    % o praticante de natação pilota o avião que solta fumaça vermelha.
    membro(I,S),
    esporte(I,natacao),
    cor(I,vermelho),

    % o Farfarelli está na ponta esquerda da formação.
    pontaesquerda(P1,S),
    nome(P1,farfarelli),

    % o piloto que bebe café voa ao lado do avião que está com pane no sistema hidráulico.
    lado(J,K,S),
    bebida(J,cafe),
    anomalia(K,hidraulico),

    % o piloto que bebe cerveja voa ao lado do piloto que enfrenta problemas na bússola.
    lado(L,M,S),
    bebida(L,cerveja),
    anomalia(M,bussola),

    % o homem que pratica equitação gosta de beber chá.
    membro(N,S),
    esporte(N,equitacao),
    bebida(N,cha),

    % o Cap. Nascimento bebe somente água.
    membro(O,S),
    nome(O,nascimento),
    bebida(O,agua),

    % o Farfarelli voa ao lado do avião que solta fumaça azul.
    lado(P,Q,S),
    nome(P,farfarelli),
    cor(Q,azul),

    % na formação, há um avião entre o que tem problema hidráulico e o com pane no altímetro.
    entre(R,_,U,S),
    anomalia(R,hidraulico),
    anomalia(U,altimetro),

    % restrições de fechamento
    membro(F1,S),
    anomalia(F1,temperatura),

    membro(F2,S),
    esporte(F2,tenis).


% definições
nome(piloto(T,_,_,_,_),T).
cor(piloto(_,T,_,_,_),T).
anomalia(piloto(_,_,T,_,_),T).
bebida(piloto(_,_,_,T,_),T).
esporte(piloto(_,_,_,_,T),T).

membro(M,esquadrilha(M,_,_,_,_)).
membro(M,esquadrilha(_,M,_,_,_)).
membro(M,esquadrilha(_,_,M,_,_)).
membro(M,esquadrilha(_,_,_,M,_)).
membro(M,esquadrilha(_,_,_,_,M)).

pontaesquerda(P,esquadrilha(P,_,_,_,_)).

direita(A,B,esquadrilha(_,_,_,A,B)).
direita(A,B,esquadrilha(_,A,B,_,_)).
direita(A,B,esquadrilha(A,B,_,_,_)).
direita(A,B,esquadrilha(_,_,A,B,_)).

lado(A,B,esquadrilha(A,B,_,_,_)).
lado(A,B,esquadrilha(_,A,B,_,_)).
lado(A,B,esquadrilha(B,A,_,_,_)).
lado(A,B,esquadrilha(_,_,A,B,_)).
lado(A,B,esquadrilha(_,B,A,_,_)).
lado(A,B,esquadrilha(_,_,_,A,B)).
lado(A,B,esquadrilha(_,_,B,A,_)).
lado(A,B,esquadrilha(_,_,_,B,A)).

entre(A,B,C,esquadrilha(A,B,C,_,_)).
entre(A,B,C,esquadrilha(_,A,B,C,_)).
entre(A,B,C,esquadrilha(_,_,A,B,C)).
entre(A,B,C,esquadrilha(C,B,A,_,_)).
entre(A,B,C,esquadrilha(_,C,B,A,_)).
entre(A,B,C,esquadrilha(_,_,C,B,A)).