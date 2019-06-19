*Description: This file generates estimates in Table 4 of the paper.

*Preliminaries: You need to have the data file abbgh_data_new.dta in your current directory
*	1. data3d.txt
*	2. data2d_large.txt
*	3. abbgh_data_new.dta

clear all
set more off

log using table04.log, replace

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

**********************
*** Table 4, Col 1 ***
**********************
gen Lc_morec = Lc*(split==1)
gen Lc_2_morec = Lc_2*(split==1)

* first stage
reg Lc $RDTFP $IMP1 $EXP1 $LIMU1 $POL1 $POL2 $Xex
test $POL1 $POL2
test $RDTFP $IMP1 $EXP1 $LIMU1 
predict LceF, resid

* regression with control function
nbreg patcw Lc Lc_2 LceF Lc_morec Lc_2_morec yr* iii*, vce(cluster sic2)
test Lc Lc_2
test Lc_morec Lc_2_morec
drop LceF


**********************
*** Table 4, Col 3 ***
**********************

drop if year<1976
drop if sic2==36 | sic2==32 | sic2==23 | sic2==24

* first stage
reg Lc $RDTFP $IMP1 $EXP1 $LIMU1 $POL1 $POL2 $Xex
test $POL1 $POL2
test $RDTFP $IMP1 $EXP1 $LIMU1 
predict LceF, resid

* regression with control function
nbreg patcw Lc Lc_2 LceF Lc_morec Lc_2_morec yr* iii*, vce(cluster sic2)
test Lc Lc_2
test Lc_morec Lc_2_morec



***************
*** US Data ***
***************

clear all
set more off

*** Import data ***
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
label var industry "3-Digit SIC codes"
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
tabulate industry, gen(i)
tabulate year, gen(d)

*** Generate competition squared
gen c1sq = c1^2

**********************
*** Table 4, Col 2 ***
**********************

egen gap2_p50 = pctile(gap2),p(50)
gen gap2_ind = 1 if gap2<gap2_p50
replace gap2_ind = 0 if gap2_ind==.
gen c1gap2 = c1*gap2_ind
gen c1sqgap2 = c1sq*gap2_ind

* first stage
reg c1 instf_1 d* i1-i116
test instf_1
predict c1_cf, resid
* regression with the control function
nbreg cwp c1 c1sq c1_cf c1gap2 c1sqgap2 d* i1-i116, vce(cluster industry)
test c1 c1sq
test c1gap2 c1sqgap2

drop c1gap2 c1sqgap2 gap2_ind 

************************
*** Table 4, Col (4) ***
************************
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

egen gap2_p50 = pctile(gap2),p(50)
gen gap2_ind = 1 if gap2<gap2_p50
replace gap2_ind = 0 if gap2_ind==.
gen c1gap2 = c1*gap2_ind
gen c1sqgap2 = c1sq*gap2_ind

* first stage
reg c1 instf_1 d* ii*
test instf_1
predict c1_cf, resid
* regression with the control function
nbreg cwp c1 c1sq c1_cf c1gap2 c1sqgap2 d* ii*, vce(cluster industry)
test c1 c1sq
test c1gap2 c1sqgap2

*---------------------------------------------------------------------------

log close
