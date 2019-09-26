// Agent sample_agent in project escopa_project

/* Initial beliefs and rules */
mycards([]).
tablecards([]).
availablecards([]).

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
	.

+hand(card(NAIPE,NUMBER)):
	true
	<-	
	?mycards(X);
	-mycards(X);
	+mycards([card(NAIPE,NUMBER)|X]);
	.

-hand(card(NAIPE,NUMBER)):
	true
	<-
	?mycards(X);
	-mycards(X);
	.delete(card(NAIPE,NUMBER),X,X2);
	+mycards(X2);
	.

+!start : 
	true 
	<- 
	join;
	.

+playerturn(AG) :
	.my_name(AG) & mycards(X)
	<-
	.print(X);
	.
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
