// Agent sample_agent in project escopa_project

/* Initial beliefs and rules */
mycards([]).
cardstable([]).
cardsused([]).

//getcard(X):-mycards([H|T]) & X=H.
//carddata(card(NAIPE,NUMBER), NP, NB):-NP=NAIPE & NB=NUMBER.

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

//countPoints([card(NAIPE,NUMBER)|[]], POINTS):-getnumber(NUMBER,POINTS).
//countPoints([card(NAIPE,NUMBER)|T], POINTS):-getnumber(NUMBER,VALUE) & countPoints(T,P2) & POINTS=VALUE + P2.

//escopa(TOTAL, [card(NP1,N1)|[]],R):-TOTAL+N1=15 & R=card(NP1,N1).
//escopa(TOTAL, [card(NP1,N1)|[]],R):-TOTAL+N1\==15 & R=false.
//escopa(TOTAL, [card(NP1,N1)|T],R):-escopa(TOTAL,T,R1) & R1\== false & R=R1.
//escopa(TOTAL, [card(NP1,N1)|T],R):-escopa(TOTAL,T,R1) & R1=false & TOTAL+N1=15 & R=card(NP1,N1).
//escopa(TOTAL, [card(NP1,N1)|T],R):-escopa(TOTAL,T,R1) & TOTAL+N1\==15 & R=false.

getnumber(NUMBER,X):-NUMBER >= 10 & X=NUMBER - 2.
getnumber(NUMBER,X):-NUMBER < 10 & X=NUMBER.


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
getseteouros([card(NAIPE,NUMBER)|T],CARD):-NAIPE=coin & NUMBER=7 & CARD=card(NAIPE,NUMBER).
getseteouros([card(NAIPE,NUMBER)|T],CARD):-getseteouros(T,X).

getmaiorouros([],CARD):-false.

getqualquer([card(NAIPE,NUMBER)|T],CARD):-CARD=card(NAIPE,NUMBER).

desmembrarlista([], L, C):-false.
desmembrarlista([card(NAIPE,NUMBER)|[]], L, C):-C=card(NAIPE,NUMBER) & L=[].
desmembrarlista([card(NAIPE,NUMBER)|T], L, C):-desmembrarlista(T, L2, C) & L=[card(NAIPE,NUMBER)|L2]. 

/* Initial goals */
!start.

/* Plans */

// Tentar fazer 15 pontos com as cartas de ouros, testando o 7 de ouros por primeiro
+!play(MYCARDS, TABLECARDS):
	(getseteouros(MYCARDS, CARD) | getmaiorouros(MYCARDS, CARD)) &	 
	collectcomcard(TABLECARDS, CARD, R) &		
	desmembrarlista(R, L, C) 
	<-
	.print(comouros, R);	
	!removecardfromhand(C);	
	collectcards(C,L);	
	.
	
//Quando não conseguir fazer 15 pontos com cartes de ouros, tentar com as outras
+!play(MYCARDS, TABLECARDS):
	collect(TABLECARDS, R) &
	desmembrarlista(R, L, C) 
	<-
	.print(qualquer, R);	
	!removecardfromhand(C);
	collectcards(C,L);		
	.

//Não jogar 6 e 7 na mesa se tiver outra possibilidade
+!play(MYCARDS, TABLECARDS):
	getqualquer(MYCARDS, CARD)
	<-
	.print(descartarqualquer, CARD);
	!drophand(CARD);
	.

//Jogar 6 na mesa


//Jogar a desgraça do 7 fora já que n tem outra possibilidade


+!removecardfromhand(CARD) :
	true
	<-
	?mycards(MYCARDS);
	-mycards(MYCARDS);
	.delete(CARD,MYCARDS,NEWCARDS);		
	+mycards(NEWCARDS);
	.
	
+!removecardfromtable(CARD) :
	true
	<-
	?cardstable(X);
	-cardstable(X);
	.delete(CARD,X,NEWCARDS);	
	+cardstable(NEWCARDS);	
	.print(removendo, CARD);
	.

+!drophand(card(NAIPE,NUMBER)):
	true
	<-
	!removecardfromhand(card(NAIPE,NUMBER));
	dropcard(NAIPE,NUMBER);
	.

+cardusedtocollect(AGENT,NP,NB):
  	my_name(AGENT)
  	<-
  	?cardsused(Y);
	-cardsused(Y);
	+cardsused([card(NP,NB)|Y]);	
	.

+cardontable(NAIPE,NUMBER):
	true
	<-
	?cardstable(X);
	-cardstable(X);
	+cardstable([card(NAIPE,NUMBER)|X]);
	.

-cardontable(NAIPE,NUMBER):
	true
	<-
	!removecardfromtable(card(NAIPE,NUMBER));	
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
	?mycards(X);
	?cardstable(Y);
	.print(Y);
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
