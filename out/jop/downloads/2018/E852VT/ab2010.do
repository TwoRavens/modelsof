****************************************************************************
* File-Nale: 		ab2010.do
* Date:		 04/30/2018
* Author: 		Fred Batista
* Purpose: 		individual level analyses of knowledge
* Data used: 		ab2010.dta
* Data Output:	Journal of Politics’ paper	*/
****************************************************************************


set mem 1000m

svyset upm [pweight=weight1500], strata(estratopri)

*********** Dependent variables: preparing questions of political knowledge

generate uspres = gi1

generate province = gi3

generate timeterm = gi4

recode uspres province timeterm (2=0) (1=1) (.=0)

label variable province "Knows number of provinces"

label variable uspres "Knows US president"

label variable timeterm "Knows duration of presidential term"

gen polknow=timeterm + province + uspres

label variable polknow "Political Knowledge"

gen knowledge = polknow*100/3


* droping US and Canada

drop if pais == 40

drop if pais == 41

************** First level independent variables
 
gen income = q10

label variable income "Income"

gen wealth = quintall

gen interest = 4 - pol1

label variable interest "Political interest"

gen exposure = 5 -gi0

label variable exposure "Exposure to media"

gen mediahome = r1 + r4 + r4a + r15 + r18

label variable mediahome "Acess to media at home"

recode ocup4a (1/4 = 1) (6=1) (5=0) (7=0), gen (employed)

label variable mujer "Woman"

gen man = 2 - mujer

label variable q2s "Age"

gen age_sq = q2s*q2s

label variable ed "Education"

gen remit = q10a

recode remit (1=1) (2=0)

label variable remit "Receives Remittances"

gen relative = q10c

recode relative (1 2 = 1) (3 4 = 0)

label variable relative "Relatives Abroad"

gen single = q11

recode single (2 3 4 5 6 = 0)

* gender-based opportunities (individual level)

gen single = q11

recode single (2 3 4 5 6 = 0)

gen married = 1 - single

label variable single "Single"

gen hijos = q12s

label variable hijos "Children"

gen sexint=sexi

recode sexint (2=0)

label variable sexint "Male Interviewer"

gen mujer_x_sexint = mujer*sexint

label variable mujer_x_sexint "Woman*Male Interviewer"

gen mujer_x_single = mujer*single

label variable mujer_x_single "Woman*Single"

gen mujer_x_hijos=mujer*q12s

label variable mujer_x_hijos "Woman*Children"

gen hijos2 = q12a

label variable hijos2 "Children at Home"

gen mujer_x_hijos2=mujer*q12a

label variable mujer_x_hijos2 "Woman*Children at Home"

gen housewife = ocup4a

recode housewife (5=1) (1 2 3 4 6 7 = 0)

label variable housewife "Housewife"


* ANALYSES

*** item analyses

sort pais

* "discrimination"

by pais: factor uspres province timeterm, ml factor(1)

** difficulty

by pais: summarize uspres province timeterm 


*** Mexico

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1


*** Guatemala

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2


*** El Salvador

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3


*** Honduras

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4


*** Nicaragua

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5


*** Costa Rica

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6


*** Panama

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7


*** Colombia

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8


*** Ecuador

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9


*** Bolivia

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10


*** Peru

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11


*** Paraguay

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12


*** Chile

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13


*** Uruguay

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14


*** Brazil

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15


*** Venezuela

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16


*** Argentina

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

*** Domincan Republic

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21


*** Haiti

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22


*** Jamaica

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23



*** Guyana

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==24

probit uspres man ur q2s age_sq wealth ed interest eff2 exposure housewife hijos single if pais==24

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==24

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==24

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==24

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==24


*** Trinidad & Tobago

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==25

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==25

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==25

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==25

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==25

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==25


*** Belize

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26


*** Suriname

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==27

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==27

* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==27

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==27

* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==27

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==27
