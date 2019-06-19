*Description: This file generates the estimates in Table 2 of the paper. 

*Preliminaries: You need to have the following data files in your current directory
*	1. data3d.txt
*	2. data2d_large.txt
*	3. abbgh_data_new.dta

clear all
set more off

log using table02.log, replace

use abbgh_data_new

global RD    = "rd_yUSA rd_yUSA_2 rd_yFRA rd_yFRA_2" 
global RDTFP = "rd_yUSA rd_yUSA_2 tfpUSA tfpUSA_2 rd_yFRA rd_yFRA_2 tfpFRA tfpFRA_2 tfpFRAdum" 
global IMP   = "imp_yUSA imp_yUSA_2 imp_yFRA imp_yFRA_2"
global EXP   = "exp_yUSA exp_yUSA_2 exp_yFRA exp_yFRA_2"
global LIMU  = "muUt muUt2 liUSA liUSA_2 muFt muFt2 liFRA liFRA_2"

global RD1    = "rd_yUSA1 rd_yUSA1_2 rd_yFRA1 rd_yFRA1_2" 
global RDTFP1 = "rd_yUSA1 rd_yUSA1_2 tfpUSA1 tfpUSA1_2 rd_yFRA1 rd_yFRA1_2 tfpFRA1 tfpFRA1_2 tfpFRA1dum" 
global IMP1   = "imp_yUSA1 imp_yUSA1_2 imp_yFRA1 imp_yFRA1_2"
global EXP1   = "exp_yUSA1 exp_yUSA1_2 exp_yFRA1 exp_yFRA1_2"
global LIMU1  = "muUt muUt2 liUSA1 liUSA1_2 muFt muFt2 liFRA1 liFRA1_2"

global POL1 = "SMPhighD SMPmedD car per brew"
global POL2 = "tele phar text raz steel ord"

global Xex "yr* iii*"

global X "Lc_2 Fl1Lc_2 Fl2Lc_2 Fl3Lc_2 Fl4Lc_2"

global XF   "L LeF   L_2 $Xex ici lucas unilev gec pilk gkn btr sandn"
global XFnn "L LeFnn L_2 $Xex ici lucas unilev gec pilk gkn btr sandn"

global XFc   "Lc LceF   Lc_2 $Xex"
global XFnnc "Lc LceFnn Lc_2 $Xex"

global XFa   "ALPHA ALPHAeF   ALPHA_2 $Xex ici lucas unilev gec pilk gkn btr sandn"
global XFnna "ALPHA ALPHAeFnn ALPHA_2 $Xex ici lucas unilev gec pilk gkn btr sandn"

* First Stage
reg Lc $RDTFP $IMP1 $EXP1 $LIMU1 $POL1 $POL2 $Xex
test $POL1 $POL2
test $RDTFP $IMP1 $EXP1 $LIMU1 
test $POL1 $POL2 $RDTFP $IMP1 $EXP1 $LIMU1 

predict LceF, resid

*-----------------------
*** Col (1) Table 2 ***
*-----------------------
* Linear Relationship with Control Function
nbreg patcw Lc LceF $Xex, vce(cluster sic2)

*-----------------------
*** Col (3) Table 2 ***
*-----------------------
* Quadratic Relationship with Control Function
nbreg patcw Lc LceF Lc_2 $Xex, vce(cluster sic2)
test Lc Lc_2

*----------------------------------------------------------------
*** Likelihood-Ratio Test between Linear and Quadratic Models ***
*----------------------------------------------------------------
quietly nbreg patcw Lc LceF $Xex
estimates store A

quietly nbreg patcw Lc LceF Lc_2 $Xex
estimates store B

lrtest A B 

drop LceF
*-----------------------
*** Col (5) Table 2 ***
*-----------------------
drop if year<1976
drop if sic2==36 | sic2==32 | sic2==23 | sic2==24

* first stage
reg Lc $RDTFP $IMP1 $EXP1 $LIMU1 $POL1 $POL2 $Xex
test $POL1 $POL2
test $RDTFP $IMP1 $EXP1 $LIMU1 
test $POL1 $POL2 $RDTFP $IMP1 $EXP1 $LIMU1 
predict LceF, resid

* regression with control function
nbreg patcw Lc LceF Lc_2 $Xex, vce(cluster sic2)
test Lc Lc_2

*--------------
*** US Data ***
*--------------
clear all
set more off

insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data3d.txt, tab
drop empty
drop if year<1976
drop if year>2001

*** Label variables ***
label var c1 "Competition (1 - LI)"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted Patents"
label var gap1 "Technological Gap based on Labor Productivity"
label var gap2 "Technological Gap based on TFP"
label var industry "2-Digit SIC codes"
label var inst1_f "Freight as percentage of Import Value"
label var inst2_ip "Import Penetration"
label var inst3_t "Tariffs as percentage of Import Value"
label var instf_1 "Weighted Forex 1"
label var instf_2 "Weighted Forex 2"
label var instf_3 "Weighted Forex 3"
label var instf_4 "Weighted Forex 4"
label var no_of_firms "Number of Firms"
label var pat "Patents"
label var rnd "Research and Development Expenditure"
label var rndint "Research Intensity"
label var year "Year"

tabulate industry, gen(ii)
tabulate year, gen(d)

gen c1sq = c1^2

* first stage
reg c1 instf_1 d* ii* 
test instf_1
predict c1_cf, resid

*-----------------------
*** Col (2) Table 2 ***
*-----------------------
* Linear Relationship with Control Function
nbreg cwp c1 c1_cf d* ii*, vce(cluster industry)

*-----------------------
*** Col (4) Table 2 ***
*-----------------------
* Quadratic Relationship with Control Function
nbreg cwp c1 c1sq c1_cf d* ii*, vce(cluster industry)
test c1 c1sq

*----------------------------------------------------------------
*** Likelihood-Ratio Test between Linear and Quadratic Models ***
*----------------------------------------------------------------
quietly nbreg cwp c1 c1_cf d* ii*
estimates store A

quietly nbreg cwp c1 c1sq c1_cf d* ii*
estimates store B

lrtest A B

*-----------------------
*** Col (6) Table 2 ***
*-----------------------

clear
insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data2d_large.txt, tab

drop empty
drop if year<1976
drop if year>1994
drop if industry==24 | industry==25 | industry==31 | industry==32

*** Label variables ***
label var c1 "Competition (1 - LI)"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted Patents"
label var gap1 "Technological Gap based on Labor Productivity"
label var gap2 "Technological Gap based on TFP"
label var industry "2-Digit SIC codes"
label var inst1_f "Freight as percentage of Import Value"
label var inst2_ip "Import Penetration"
label var inst3_t "Tariffs as percentage of Import Value"
label var instf_1 "Weighted Forex 1"
label var instf_2 "Weighted Forex 2"
label var instf_3 "Weighted Forex 3"
label var instf_4 "Weighted Forex 4"
label var no_of_firms "Number of Firms"
label var pat "Patents"
label var rnd "Research and Development Expenditure"
label var rndint "Research Intensity"
label var year "Year"

*** Generate time and industry dummies ***
tabulate industry, gen(ii)
tabulate year, gen(d)

*** Generate competition squared
gen c1sq = c1^2

* first stage
reg c1 instf_1 d* ii*
test instf_1
predict c1_cf, resid

* regression with control function
nbreg cwp c1 c1sq c1_cf d* ii*, vce(cluster industry)
test c1 c1sq
*-----------------------------------------------------------------------------

log close



