set more off

**** load individual level - ITANES_2006
* cd "path"
use "indiv_net",clear

*** geopolitical zone

encode a313,gen(zgp)

recode zgp (8 9 11=1 "North-west") (6 16 18=2 "North-east") (17 15 5 10=3 "red belt") ///
(7=4 "Center") (1 2 3 4 12 13 14=5 "South and islands"),gen(zgp5)

*** interest

recode a20 b20 (5 6=.),gen(inter_pr inter_po)

* REMEMBER CDL=1 - UNIONE=2

*** network

recode b180_2 b180_3 (8 9=.),gen(famnet1 famnet2)

recode famnet1 famnet2 (1=0) (2=0.10) (3=0.25) (4=0.5) (5=0.75) (6=0.9) (7=1)

replace famnet1 = famnet1*100

replace famnet2 = famnet2*100

recode b180_1 (8 9=.), gen(famcont)
recode famcont (1=0) (2=0.10) (3=0.25) (4=0.5) (5=0.75) (6=0.9) (7=1)
gen effamnet1= famnet1*famcont
gen effamnet2= famnet2*famcont

*** localvote

destring a310, gen(istat)

drop if istat==.

*** load aggregate-level data

merge m:1 istat using "Context_2006.dta"

drop if _merge !=3

gen localvote1 = (Coal_Cdx_2006/votanti_2006)*100 
gen localvote2 = (Coal_Csx_2006/votanti_2006)*100

**** ptv

recode b85_9 (12 13=.),gen(ptv1)

recode b85_5 (12 13=.),gen(ptv2)

*** gender

rename a240 gend

*** class

rename a_prof5 classe

**************
*** MODELS ***

*** MODEL 1
xtmixed ptv1 c.eta i.titstu i.gend i.inter_pr i.class i.zgp5 c.localvote1 c.effamnet1 || istat:
*outreg2 using "Tab1",excel dec(2) side

*** MODEL 3
xtmixed ptv1 c.eta i.titstu i.gend i.inter_pr i.class i.zgp5 c.localvote1##c.effamnet1 || istat:
*outreg2 using "Tab1",excel dec(2) side

**** marginal effect of the slope (LEFT PANEL)

margins, dydx(localvote1) at(effamnet=(0(1)70))
marginsplot,x(effamnet1) recastci(rarea) recast(line) scheme(s1mono) name(casalib_over)

*************
*************

*** MODEL 2
xtmixed ptv2 c.eta i.titstu i.gend i.inter_pr i.class i.zgp5 c.localvote2 c.effamnet2 || istat:
*outreg2 using "Tab1",excel dec(2) side

*** MODEL 4
xtmixed ptv2 c.eta i.titstu i.gend i.inter_pr i.class i.zgp5 c.localvote2##c.effamnet2 || istat:
*outreg2 using "Tab1",excel dec(2) side
 
**** marginal effect of the slope (RIGHT PANEL)

margins, dydx(localvote2) at(effamnet=(0(1)70))
marginsplot,x(effamnet2) recastci(rarea) recast(line) scheme(s1mono) name(unione_over)

**** FIGURE 2

graph combine casalib_over unione_over 

graph drop casalib_over unione_over 


*********** DESCRIPTIVES TABLE *************

gendummies titstu 
gendummies inter_pr 
gendummies class 
gendummies zgp5 

format ptv1 eta titstu1 titstu2 titstu3 titstu4 inter_pr1 inter_pr2 inter_pr3 inter_pr4 ///
classe1 classe2 classe3 classe4 classe5 zgp51 zgp52 zgp53 zgp54 zgp55 %9.2f

tabstat ptv1 eta titstu1 titstu2 titstu3 titstu4 inter_pr1 inter_pr2 inter_pr3 inter_pr4 ///
classe1 classe2 classe3 classe4 classe5 zgp51 zgp52 zgp53 zgp54 zgp55 localvote1 effamnet1 if e(sample),statistics(mean sd p10 p90) columns(statistics)

tabstat ptv2 localvote2 effamnet2 if e(sample),statistics(mean sd p10 p90) columns(statistics)

