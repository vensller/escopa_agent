// Agent sample_agent in project escopa_project

/* Initial beliefs and rules */
mycards([]).
tablecards([]).
cardsused([]).

getcard(X):-mycards([H|T]) & X=H.
carddata(card(NAIPE,NUMBER), NP, NB):-NP=NAIPE & NB=NUMBER.

getnumber(NUMBER,X):-NUMBER >= 10 & X=NUMBER - 2.
getnumber(NUMBER,X):-NUMBER < 10 & X=NUMBER.

countPoints([card(NAIPE,NUMBER)|[]], POINTS):-getnumber(NUMBER,POINTS).
countPoints([card(NAIPE,NUMBER)|T], POINTS):-getnumber(NUMBER,VALUE) & countPoints(T,P2) & POINTS=VALUE + P2.

collectlist([card(NAIPE,NUMBER)|T], POINTS, COLLECT):-(POINTS < 15) & COLLECT=[].
collectlist([card(NAIPE,NUMBER)|T], POINTS, COLLECT):-(POINTS >= 15) & getnumber(NUMBER,VALUE) & createcollectlist(T,VALUE,_,_,COLLECT).

createcollectlist([card(NAIPE,NUMBER)|[]], MYVALUE, TOTALVALUE, CONTROLLIST, LIST):-CONTROLLIST=[card(NAIPE,NUMBER)] & 
														                           	getnumber(NUMBER,VALUE) & 
														                           	TOTALVALUE=MYVALUE + VALUE.
//Se for 15 ent�o retorna a lista montada
createcollectlist([card(NAIPE,NUMBER)|T], MYVALUE, TOTALVALUE, CONTROLLIST, LIST):-createcollectlist(T,MYVALUE,V2,L2,_) &
												  						  		   V2 == 15 & 
												  						  		   LIST=L2.
//Se n�o for 15, somente continua a execu��o 
createcollectlist([card(NAIPE,NUMBER)|T], MYVALUE, TOTALVALUE, CONTROLLIST, LIST):-createcollectlist(T,MYVALUE,V2,L2,_) &
												  						  		   not (V2 == 15) & 
												  						  		   CONTROLLIST = [card(NAIPE,NUMBER)|L2] &
												  						  		   getnumber(NUMBER,VALUE) &
												  						  		   TOTALVALUE=VALUE + V2 &
												  						  		   LIST=[].												  						  		   

/* Initial goals */
!start.

/* Plans */

+cardontable(NAIPE,NUMBER):
	true
	<-
	?tablecards(X);
	-tablecards(X);
	+tablecards([card(NAIPE,NUMBER)|X]);
	.

-cardontable(NAIPE,NUMBER):
	true
	<-
	?tablecards(X);
	-tablecards(X);
	.delete(card(NAIPE,NUMBER),X,X2);	
	+tablecards(X2);
	?cardsused(Y);
	-cardsused(Y);
	+cardsused([card(NAIPE,NUMBER)|Y]);	
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

+removecardfromhand(CARD) :
	true
	<-
	?mycards(MYCARDS);
	.delete(CARD,MYCARDS,NEWCARDS);
	-mycards(MYCARDS);	
	+mycards(NEWCARDS);
	.

//Quando n�o existirem cartas a serem recolhidas
+playerturn(AG):
	.my_name(AG) & getcard(CARD) & tablecards(X) & countPoints([CARD|X],POINTS) & collectlist([CARD|X],POINTS,COLLECT) & (COLLECT == [])
	<-
	+removecardfromhand(CARD);
	?carddata(CARD, NAIPE, NUMBER);
	dropcard(NAIPE,NUMBER);
	.

//Quando tiver cartas para recolher
+playerturn(AG):
	.my_name(AG) & getcard(CARD) & tablecards(X) & countPoints([CARD|X],POINTS) & collectlist([CARD|X],POINTS,COLLECT) & (not (COLLECT == []))
	<-
	?tablecards(TABLE);
	+removecardfromhand(CARD);		
	collectcards(CARD, COLLECT);
	.
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
