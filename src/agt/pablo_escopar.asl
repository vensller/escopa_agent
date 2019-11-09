// Agent sample_agent in project escopa_project

/* Initial beliefs and rules */

//getcard(X):-mycards([H|T]) & X=H.
//collectlist([card(NAIPE,NUMBER)|T], POINTS, COLLECT):-(POINTS < 15) & COLLECT=[].
//collectlist([card(NAIPE,NUMBER)|T], POINTS, COLLECT):-(POINTS >= 15) & getnumber(NUMBER,VALUE) & createcollectlist(T,VALUE,_,_,COLLECT).
//
//createcollectlist([card(NAIPE,NUMBER)|[]], MYVALUE, TOTALVALUE, CONTROLLIST, LIST):-CONTROLLIST=[card(NAIPE,NUMBER)] & 
//														                           	getnumber(NUMBER,VALUE) & 
//														                           	TOTALVALUE=MYVALUE + VALUE.
////Se for 15 então retorna a lista montada
//createcollectlist([card(NAIPE,NUMBER)|T], MYVALUE, TOTALVALUE, CONTROLLIST, LIST):-createcollectlist(T,MYVALUE,V2,L2,_) &
//												  						  		   V2 == 15 & 
//												  						  		   LIST=L2.
////Se não for 15, somente continua a execução 
//createcollectlist([card(NAIPE,NUMBER)|T], MYVALUE, TOTALVALUE, CONTROLLIST, LIST):-createcollectlist(T,MYVALUE,V2,L2,_) &
//												  						  		   not (V2 == 15) & 
//												  						  		   CONTROLLIST = [card(NAIPE,NUMBER)|L2] &
//												  						  		   getnumber(NUMBER,VALUE) &
//												  						  		   TOTALVALUE=VALUE + V2 &
//												  						  		   LIST=[].

//escopa(TOTAL, [card(NP1,N1)|[]],R):-TOTAL+N1=15 & R=card(NP1,N1).
//escopa(TOTAL, [card(NP1,N1)|[]],R):-TOTAL+N1\==15 & R=false.
//escopa(TOTAL, [card(NP1,N1)|T],R):-escopa(TOTAL,T,R1) & R1\== false & R=R1.
//escopa(TOTAL, [card(NP1,N1)|T],R):-escopa(TOTAL,T,R1) & R1=false & TOTAL+N1=15 & R=card(NP1,N1).
//escopa(TOTAL, [card(NP1,N1)|T],R):-escopa(TOTAL,T,R1) & TOTAL+N1\==15 & R=false.
mycards([]).
cardstable([]).
cardsused([]).

carddata(card(NAIPE,NUMBER), NP, NB):-NP=NAIPE & NB=NUMBER.

getnumber(NUMBER,X):-NUMBER >= 10 & X=NUMBER - 2.
getnumber(NUMBER,X):-NUMBER < 10 & X=NUMBER.

countpoints([card(NAIPE,NUMBER)|[]], POINTS):-getnumber(NUMBER,POINTS).
countpoints([card(NAIPE,NUMBER)|T], POINTS):-getnumber(NUMBER,VALUE) & countpoints(T,P2) & POINTS=VALUE + P2.

collect(TABLECARDS, R):-
	mycards(CARDS) &	
	.member(card(NP, N), CARDS) &
	getnumber(N, NEWVALUE) &
	montar_lista(TABLECARDS, [card( NP,N)], NEWVALUE, R)
	.

collectcomcard(TABLECARDS, card(NAIPE, NUMBER), R):-
	getnumber(NUMBER, N2) &
	montar_lista(TABLECARDS, [card(NAIPE,NUMBER)], N2, R)
	.
 
montar_lista(TABLECARDS, L, 15, R):-R=L.
montar_lista(TABLECARDS, L, S, R):-	
	.member(card(NP, N), TABLECARDS) &	 
	not .member(card(NP, N), L) &
	getnumber(N, NEWVALUE) &
	S+NEWVALUE < 16 &
	montar_lista(TABLECARDS, [card(NP,N)|L], S+NEWVALUE, R)
	.

getseteouros([],CARD):-false.
getseteouros([card(NAIPE,NUMBER)|T],CARD):-NAIPE=coins & NUMBER=7 & CARD=card(NAIPE,NUMBER).
getseteouros([card(NAIPE,NUMBER)|T],CARD):-getseteouros(T,X).

getmaiorouros([card(NAIPE,NUMBER)|[]],CARD):-CARD=card(NAIPE,NUMBER).
getmaiorouros([card(coins,NUMBER)|T],CARD):-getseteouros(T,card(coins,NB)) & NUMBER > NB & CARD=card(coins,NUMBER).
getmaiorouros([card(coins,NUMBER)|T],CARD):-getseteouros(T,card(NP,NB)) & CARD=card(coins,NUMBER).
getmaiorouros([card(NAIPE,NUMBER)|T],CARD):-getmaiorouros(T,X) & CARD=X.

getqualquer([card(NAIPE,NUMBER)|T],CARD):-CARD=card(NAIPE,NUMBER).

desmembrarlista([], L, C):-false.
desmembrarlista([card(NAIPE,NUMBER)|[]], L, C):-C=card(NAIPE,NUMBER) & L=[].
desmembrarlista([card(NAIPE,NUMBER)|T], L, C):-desmembrarlista(T, L2, C) & L=[card(NAIPE,NUMBER)|L2]. 

getmaiorcard([card(NAIPE,NUMBER)|[]],CARD):-CARD=card(NAIPE,NUMBER).
getmaiorcard([card(NAIPE,NUMBER)|T],CARD):-getmaiorcard(T, card(NP,NB)) & NB > NUMBER & CARD=card(NP,NB).
getmaiorcard([card(NAIPE,NUMBER)|T],CARD):-getmaiorcard(T, card(NP,NB)) & NB < NUMBER & CARD=card(NAIPE,NUMBER).

getmaiorcardnotsixsete(MYCARDS,CARD):-getmaiorcard(MYCARDS,card(NAIPE,NUMBER)) & (NUMBER < 6 | NUMBER > 7) & CARD=card(NAIPE,NUMBER).
getmaiorcardnotsixsete(MYCARDS,CARD):-false. 

getmaiorcardnotsixsetenaocoins(MYCARDS,CARD):-getmaiorcardnotsixsete(MYCARDS,card(NAIPE,NUMBER)) & (not NAIPE=coins) & CARD=card(NAIPE,NUMBER).
getmaiorcardnotsixsetenaocoins(MYCARDS,CARD):-false.

getmenorcard([card(NAIPE,NUMBER)|[]],CARD):-CARD=card(NAIPE,NUMBER).
getmenorcard([card(NAIPE,NUMBER)|T],CARD):-getmenorcard(T, card(NP,NB)) & NB < NUMBER & CARD=card(NP,NB).
getmenorcard([card(NAIPE,NUMBER)|T],CARD):-getmenorcard(T, card(NP,NB)) & NB > NUMBER & CARD=card(NAIPE,NUMBER).

getmenorcardnotsixsete(MYCARDS,CARD):-getmenorcard(MYCARDS,card(NAIPE,NUMBER)) & (NUMBER < 6 | NUMBER > 7) & CARD=card(NAIPE,NUMBER).
getmenorcardnotsixsete(MYCARDS,CARD):-false.

getmenorcardnotsixsete(MYCARDS,CARD):-getmenorcard(MYCARDS,card(NAIPE,NUMBER)) & (NUMBER < 6 | NUMBER > 7) & CARD=card(NAIPE,NUMBER).
getmenorcardnotsixsete(MYCARDS,CARD):-false.

getmenorcardnotsixsetenaocoins(MYCARDS,CARD):-getmenorcardnotsixsete(MYCARDS,card(NAIPE,NUMBER)) & (not NAIPE=coins) & CARD=card(NAIPE,NUMBER).
getmenorcardnotsixsetenaocoins(MYCARDS,CARD):-false.

/* Initial goals */
!start.

/* Plans */

// Tentar fazer 15 pontos com 7 de ouros
+!play(MYCARDS, TABLECARDS):
	getseteouros(MYCARDS, CARD) &	 
	collectcomcard(TABLECARDS, CARD, R) &		
	desmembrarlista(R, L, C) 
	<-
	.print(comouros, R);	
	!removecardfromhand(C);	
	collectcards(C,L);	
	.
	
// Tentar fazer 15 pontos com qualquer carta de ouros
+!play(MYCARDS, TABLECARDS):
	getmaiorouros(MYCARDS, card(NAIPE,NUMBER)) &
	NAIPE=coins &		
	collectcomcard(TABLECARDS, card(NAIPE,NUMBER), R) &		
	desmembrarlista(R, L, C) 
	<-
	.print(comouros, R);	
	!removecardfromhand(C);	
	collectcards(C,L);	
	.	 
	
//Quando não conseguir fazer 15 pontos com cartas de ouros, tentar com as outras
+!play(MYCARDS, TABLECARDS):
	collect(TABLECARDS, R) &
	desmembrarlista(R, L, C) 
	<-
	.print(qualquer, R);	
	!removecardfromhand(C);
	collectcards(C,L);		
	.

//Jogar maior carta na mesa (quando a soma de pontos na mesa for > 7) *** NÃO PODE JOGAR 7 E 6 E NÃO JOGAR OUROS***
+!play(MYCARDS, TABLECARDS):
	countpoints(TABLECARDS, POINTS) & 
	POINTS > 7 &
	getmaiorcardnotsixsetenaocoins(MYCARDS, CARD)
	<-
	.print(maiornaocoins, CARD);
	!drophand(CARD);
	.

//Jogar menor carta na mesa (quando a soma de pontos na mesa for <= 7) *** NÃO PODE JOGAR 7 E 6 E NÃO JOGAR OUROS***
+!play(MYCARDS, TABLECARDS):
	countpoints(TABLECARDS, POINTS) &
	POINTS <= 7 &
	getmenorcardnotsixsetenaocoins(MYCARDS, CARD)
	<-
	.print(menornaocoins, CARD);
	!drophand(CARD);
	.

//Jogar maior carta na mesa (quando a soma de pontos na mesa for > 7) *** NÃO PODE JOGAR 7 E 6 ***
+!play(MYCARDS, TABLECARDS):
	countpoints(TABLECARDS, POINTS) & 
	POINTS > 7 &
	getmaiorcardnotsixsete(MYCARDS, CARD)
	<-
	.print(maior, CARD);
	!drophand(CARD);
	.
	
//Jogar menor carta na mesa (quando a soma de pontos na mesa for <= 7) *** NÃO PODE JOGAR 7 E 6 ***
+!play(MYCARDS, TABLECARDS):
	countpoints(TABLECARDS, POINTS) &
	POINTS <= 7 &
	getmenorcardnotsixsete(MYCARDS, CARD)
	<-
	.print(menor, CARD);
	!drophand(CARD);
	.

//Jogar qualquer
+!play(MYCARDS, TABLECARDS):
	getqualquer(MYCARDS, CARD)
	<-
	.print(descartarqualquer, CARD);
	!drophand(CARD);
	.

+!removecardfromhand(CARD) :
	true
	<-
	?mycards(MYCARDS);
	-mycards(MYCARDS);
	.delete(CARD,MYCARDS,NEWCARDS);		
	+mycards(NEWCARDS);
	.

+!drophand(card(NAIPE,NUMBER)):
	true
	<-
	!removecardfromhand(card(NAIPE,NUMBER));
	dropcard(NAIPE,NUMBER);
	.

//+cardusedtocollect(AGENT,NP,NB):
//  	true
//  	<-
//  	?cardsused(Y);
//	-cardsused(Y);
//	+cardsused([card(NP,NB)|Y]);	
//	.

+cardontable(NAIPE,NUMBER):
	cardstable(TABLE)
	<-
	-+cardstable([card(NAIPE,NUMBER)|TABLE]);	
	.

-cardontable(NAIPE,NUMBER):
	cardstable(TABLE) & .delete(card(NAIPE,NUMBER), TABLE, NEWTABLE) 
	<-	
	-+cardstable(NEWTABLE);	
//	?cardsused(Y);
//	-cardsused(Y);
//	+cardsused([card(NAIPE,NUMBER)|Y]);	
	.

+hand(card(NAIPE,NUMBER)):
	true
	<-	
	?mycards(X);
	-mycards(X);
	+mycards([card(NAIPE,NUMBER)|X]);
	.
		
+!start : 
	true 
	<-
	join;
	.

+playerturn(AG):
	.my_name(AG)
	<-
	.print("Plata o Plomo!");
	.wait(3000);	
	?mycards(X);
	?cardstable(Y);
	!play(X,Y);
	.

//+playerturn(AG):
//	.my_name(AG) & getcard(CARD) & tablecards(X) & countPoints([CARD|X],POINTS) & collectlist([CARD|X],POINTS,COLLECT) & (COLLECT == [])
//	<-
//	+removecardfromhand(CARD);
//	?carddata(CARD, NAIPE, NUMBER);
//	dropcard(NAIPE,NUMBER);
//	.
//
////Quando tiver cartas para recolher
//+playerturn(AG):
//	.my_name(AG) & getcard(CARD) & tablecards(X) & countPoints([CARD|X],POINTS) & collectlist([CARD|X],POINTS,COLLECT) & (not (COLLECT == []))
//	<-
//	?tablecards(TABLE);
//	+removecardfromhand(CARD);		
//	collectcards(CARD, COLLECT);
//	.
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
