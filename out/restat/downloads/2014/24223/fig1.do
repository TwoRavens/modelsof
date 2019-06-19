*Description: This file generates Figure 1 in the paper. 

*Preliminaries: You need to have the following data files in your current directory
*	1. data3d.txt
*	2. abbgh_data_new.dta

clear
set more off

log using fig1.log, replace

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

*------------------
**** Figure 11 ****
*------------------
* first stage
reg Lc $RDTFP $IMP1 $EXP1 $LIMU1 $POL1 $POL2 $Xex
predict LceF    ,resid

* regression with control function
nbreg patcw Lc LceF Lc_2 $Xex

gen curve = exp(_b[_cons] + _b[Lc]*Lc + _b[Lc_2]*Lc_2)
label var curve "Estimated CWP"
label var patcw "Citation-weighted patents (CWP)"

egen p10 = pctile(patcw),p(10)
egen p90 = pctile(patcw),p(90)
*if patcw<p90&patcw>p10
# delimit ;
graph twoway (scatter patcw Lc , msymbol(oh))
(line curve Lc, 
sort lwidth(thick) color(black) ysc(r(0 40)) ylabel(0(10)40)
title((a) Prediction 1: ABBGH) legend(off) ytitle("Estimated CWP")), 
nodraw;
# delimit cr

drop curve

graph save fig11, replace

*------------------
**** Figure 21 ****
*------------------
* first stage
reg Lc $RDTFP $IMP1 $EXP1 $LIMU1 $POL1 $POL2 $Xex
test $RDTFP $IMP1 $EXP1 $LIMU1 $POL1 $POL2
predict Lc_hat

* second stage
reg NN Lc_hat yr* iii*, vce(cluster sic2)

gen curve = _b[_cons] + _b[Lc_hat]*Lc_hat

# delimit ;
graph twoway (line curve Lc_hat, 
sort lwidth(thick) color(black) ysc(r(0 0.5)) ylabel(0(0.1)0.5)
title((c) Prediction 2: ABBGH) legend(off) msymbol(oh) xtitle("Competition") ytitle("Estimated Tech Gap")) , nodraw;
# delimit cr

drop curve

graph save fig21, replace

*------------------
**** Figure 31 ****
*------------------
gen Lc_morec = Lc*(split==1)
gen Lc_2_morec = Lc_2*(split==1)
nbreg patcw Lc Lc_2 LceF Lc_morec Lc_2_morec yr* iii*
gen curveall = exp(_b[_cons] + _b[Lc]*Lc + _b[Lc_2]*Lc_2)
gen curvenn = exp(_b[_cons] +  _b[Lc]*Lc + _b[Lc_2]*Lc_2 + _b[Lc_morec]*Lc_morec + _b[Lc_2_morec]*Lc_2_morec)

lab var curveall "All industries"
lab var curvenn "More neck-and-neck"

# delimit ;
graph twoway (line curveall Lc, ysc(r(0 20)) ylabel(0(5)20)
sort lwidth(thick) color(black) title((e) Prediction 3: ABBGH) legend(off) ytitle("Estimated CWP")) 
(line curvenn Lc if Lc_morec~=0, 
sort lwidth(thick) color(red)), nodraw;
# delimit cr

drop curveall curvenn

graph save fig31, replace

*-----------------------------------------------------------------------------------------
clear
set more off
insheet c1 c1a c1b c2 cwp gap1 gap2 industry inst1_f inst2_ip inst3_t instf_1 instf_2 instf_3 instf_4 no_of_firms pat rnd rndint year empty using data3d.txt, tab
drop empty
drop if year<1976
drop if year>2001

*** Label variables ***
label var c1 "Competition"
label var c1a "c1 allowing for LI as low as -1"
label var c1b "c1 based on median LI"
label var c2 "Competition (1 - H)"
label var cwp "Citation-weighted patents (CWP)"
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

*------------------
**** Figure 12 ****
*------------------
* first stage
reg c1 instf_1 d* ii*
test instf_1
predict c1_cf, resid

* regression with control function
nbreg cwp c1 c1sq c1_cf d* ii*
test c1 c1sq

gen curve = exp(_b[_cons] + _b[c1]*c1 + _b[c1sq]*c1sq )
lab var curve "Estimated CWP"

egen p10 = pctile(cwp),p(10)
egen p90 = pctile(cwp),p(90)

# delimit ;
graph twoway (scatter cwp c1, msymbol(oh))
(line curve c1, 
sort lwidth(thick) color(black) ysc(r(0 80)) ylabel(0(20)80)
title((b) Prediction 1: US Data) legend(off) ytitle("Estimated CWP")),
nodraw;
# delimit cr

drop curve

graph save fig12, replace

*------------------
**** Figure 22 ****
*------------------
* first stage
reg c1 instf_1 d* ii*
test instf_1
predict c1_hat

* second stage
regress gap2 c1_hat d* ii*, vce(cluster industry)
gen curve = _b[_cons] + _b[c1_hat]*c1_hat

# delimit ;
graph twoway (line curve c1_hat, 
sort lwidth(thick) color(black)  ysc(r(0 0.5)) ylabel(0(0.1)0.5)
title((d) Prediction 2: US Data) legend(off) msymbol(oh) xtitle("Competition") ytitle("Estimated Tech Gap")) , nodraw;
# delimit cr

drop curve

graph save fig22, replace

*------------------
**** Figure 32 ****
*------------------
egen gap2_p50 = pctile(gap2),p(50)
gen gap2_ind = 1 if gap2<gap2_p50
replace gap2_ind = 0 if gap2_ind==.
gen c1gap2 = c1*gap2_ind
gen c1sqgap2 = c1sq*gap2_ind

nbreg cwp c1 c1sq c1_cf c1gap2 c1sqgap2 d* ii*
gen curveall = exp(_b[_cons] + _b[c1]*c1 + _b[c1sq]*c1sq)
gen curvenn = exp(_b[_cons] +  _b[c1]*c1 + _b[c1sq]*c1sq + _b[c1gap2]*c1gap2 + _b[c1sqgap2]*c1sqgap2)

lab var curveall "All industries"
lab var curvenn "More neck-and-neck"
* & c1>0.35
* & c1>0.35
# delimit ;
graph twoway (line curveall c1 if curveall<80, ysc(r(0 80)) ylabel(0(20)80)
sort lwidth(thick) color(black) title((f) Prediction 3: US Data) legend(off) ytitle("Estimated CWP")) 
(line curvenn c1 if c1gap2~=0 & curvenn<80, 
sort lwidth(thick) color(red)), nodraw;
# delimit cr

graph save fig32, replace

*-----------------------------------------------------------------------------
graph combine fig11.gph fig12.gph fig21.gph fig22.gph fig31.gph fig32.gph, note("Note: CWP refers to citation-weighted patent count.") cols(2) ysize(8) 
graph export fig1.ps, replace logo(off)

log close
