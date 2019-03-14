****************************************************************************
* File-Nale: 		ab2008.do
* Date:		 04/30/2018
* Author: 		Fred Batista
* Purpose: 		individual level analyses of knowledge
* Data used: 		ab2008.dta
* Data Output:	Journal of Politics’ paper	*/
****************************************************************************

set mem 1000m

svyset upm [pweight=weight1500], strata(estratopri)

*********** Dependent variables: preparing questions of political knowledge

generate uspres = gi1

generate province = gi3

generate timeterm = gi4

gen braspres = gi5

gen prescong = gi2

recode uspres province timeterm prescong braspres (2=0) (1=1) (8 9 =0)

label variable province "Knows number of provinces"

label variable uspres "Knows US president"

label variable timeterm "Knows duration of presidential term"

label variable braspres "Knows Brazil's President"

label variable prescong "Knows President of Congress"

gen knowledge=((timeterm + province + uspres)*100)/3

label variable knowledge "Political Knowledge"

generate uspres2 = gi1

generate province2 = gi3

generate timeterm2 = gi4

gen braspres2 = gi5

gen prescong2 = gi2

recode uspres2 province2 timeterm2 prescong2 braspres2 (8=0) (2=1) (1=2) (9 =.)

* droping US and Canada

drop if pais == 40

drop if pais == 41

************** First level independent variables
 
gen wealth = Wealths

gen interest = 4 - pol1

label variable interest "Political interest"

gen exposure1= 4 - a1

gen exposure2= 4 - a2

gen exposure3= 4 - a3

gen exposure4= 4 - a4i

gen exposure5 = 5 -pol2

gen exposure = (exposure1 + exposure2 + exposure3 + exposure4 + exposure5)/4

label variable exposure "Exposure to media"

recode ocup4a (1/4 = 1) (6=1) (5=0) (7=0), gen (employed)

label variable mujer "Woman"

gen man = 2 - mujer

label variable q2s "Age"

gen age_sq = q2s*q2s

label variable ed "Education"

recode ur (2=0) (1=1)

gen remit = q10a

recode remit (1=1) (2=0)

label variable remit "Receives Remittances"

gen relative = q10c

recode relative (1 2 = 1) (3 4 = 0)

label variable relative "Relatives Abroad"

* gender-based opportunities (individual level)

gen single = q11

recode single (2 3 4 5 6 = 0)

gen married = 1 - single 

label variable single "Single"

gen hijos = q12s

label variable hijos "Children"

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


**** ANALYSES

sort pais

* "discrimination"

by pais: factor uspres province timeterm braspres prescong, ml factor(1)

factor uspres province timeterm braspres if pais==10, ml factor(1)

** difficulty

by pais: summarize uspres province timeterm braspres prescong


*** Mexico

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==1, base(2)


*** Guatemala

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==2, base(2)



*** El Salvador

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==3, base(2)



*** Honduras

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==4, base(2)


*** Nicaragua

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==5, base(2)



*** Costa Rica

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==6, base(2)



*** Panama

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==7, base(2)


*** Colombia

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==8, base(2)



*** Ecuador

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==9, base(2)


*** Bolivia

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==10, base(2)


* prescong not asked in Bolivia

*** Peru

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==11, base(2)


*** Paraguay

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==12, base(2)



***Chile

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==13, base(2)



*** Uruguay

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==14, base(2)



*** Brazil

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15, base(2)


* braspres (in Brazil asked for name of president of venezuela

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==15, base(2)



*** Venezuela

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==16, base(2)



*** Argentina

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==17, base(2)



*** Dominican Republic

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==21, base(2)



*** Haiti

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==22, base(2)



*** Jamaica

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==23, base(2)



*** Guyana (no question on media exposure)

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

probit uspres man ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

mlogit uspres2 mujer ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

probit province man ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

mlogit province2 mujer ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

probit timeterm man ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

probit braspres man ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

mlogit braspres2 mujer ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

probit prescong man ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24

mlogit prescong2 mujer ur q2s age_sq wealth ed interest eff2 housewife hijos single if pais==24, base(2)



*** Belize

* uspres

khb probit uspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

probit uspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

mlogit uspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26, base(2)


* province

khb probit province man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

probit province man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

mlogit province2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26, base(2)


* timeterm

khb probit timeterm man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

probit timeterm man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

mlogit timeterm2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26, base(2)


* braspres

khb probit braspres man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

probit braspres man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

mlogit braspres2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26, base(2)


* prescong

khb probit prescong man || ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

probit prescong man ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26

mlogit prescong2 mujer ur q2s age_sq wealth ed interest exposure eff2 housewife hijos single if pais==26, base(2)
