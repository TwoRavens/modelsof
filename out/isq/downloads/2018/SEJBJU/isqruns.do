** Mansfield/Pevehouse ISQ "The Expansion of PTAs"

use "/users/pevehouse/Dropbox/PTAbook/PTA Expansion/PTAunit_isq.dta", clear

cd "/users/pevehouse/Dropbox/PTAbook/PTA Expansion/"

set more off

log using "/users/pevehouse/Dropbox/PTAbook/PTA Expansion/ISQmodels.log", replace

label var newmemb_1 "Expansion"
label var newmemb_1spl "Time Since Expansion"
label var PTAgdpconcen "Concentration"
label var totalGDP "Market Size"
label var existOPEN "Openness"
label var sysexpand1 "System Expansion"
label var FTA "FTA"
label var CU "CU"
label var CM "CM"
label var EU "EU"
label var Legal "Legalism"
label var Trademean "PTA Trade"
label var Africa "Africa"
label var Europe "Europe"
label var AsiaPacific "Asia-Pacific"
label var Americas "Americas"
label var MiddleEast "Middle East"
label var Vt "Vi"
label var denom "Ni-1"

local core newmemb_1spl PTAgdpconcen totalGDP existOPEN sysexpand1 

**Table 2, col. 1 [base model]

logit newmemb_1 `core' if level=="M", cluster(PTAname)
lrtest, saving(0)

outreg2 using table2, label word bdec(3) stat(coef se) replace addnote(Standard errors are clustered on the PTA. ///
Column 5 contains year-specific fixed effects, which are omitted from the table to save space.  Column 7 excludes the EC/EU. ///
All tests of statistical significance are two-tailed.)


**Table 2, col. 2

logit newmemb_1 `core' FTA CU CM EU if level=="M", cluster(PTAname)
lrtest, using(0) force

outreg2 using table2, lab word bdec(3) stat(coef se) append


**Table 2, col. 3
logit newmemb_1 `core' Legal if level=="M", cluster(PTAname)

outreg2 using table2, lab word bdec(3) stat(coef se) append


**Table 2, col. 4
logit newmemb_1 `core' Trademean if level=="M", cluster(PTAname)

outreg2 using table2, lab word bdec(3) stat(coef se) append


**Table 2, col. 5

logit newmemb_1 `core' _Iyear_1951-_Iyear_2006 if level=="M", cluster(PTAname) 
lrtest, using(0) force

outreg2 using table2, lab word bdec(3) stat(coef se) append drop(_Iyear_1951-_Iyear_2006)


**Table 2, col. 6

logit newmemb_1 `core' Africa AsiaPacific MiddleEast Americas Europe if level=="M", cluster(PTAname)
lrtest, using(0) force

outreg2 using table2, lab word bdec(3) stat(coef se) append


**Table 2, col. 7
logit newmemb_1 `core' if level=="M" & PTAname~="EEC_EU", cluster(PTAname)

outreg2 using table2, lab word bdec(3) stat(coef se) append


**Table 2, col. 8
logit newmemb_1 newmemb_1spl totalGDP existOPEN sysexpand1 Vt denom if level=="M", cluster(PTAname)

outreg2 using table2, lab word bdec(3) stat(coef se) append

**Table 3, run 1 AGE

label var PTAage "Age"
logit newmemb_1 `core' PTAage if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) replace keep(PTAage) onecol

**Table 3, run 2 CURRENCY UNIONS

label var PTA_pctcurrunion "% Currency Union"
logit newmemb_1 `core' PTA_pctcurrunion if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(PTA_pctcurrunion) onecol

**Table 3, run 3 ALLIES

label var PTAallypct "% Allies"
logit newmemb_1 `core' PTAallypct if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(PTAallypct) onecol

**Table 3, run 4 SYSTEM STATES

label var pctPTA "System States (%)"
logit newmemb_1 `core' pctPTA if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(pctPTA) onecol

**Table 3, run 5 JOINING SYSTEM STATES

label var pctjoinPTA "Joining Sys. States"
logit newmemb_1 `core' pctjoinPTA if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(pctjoinPTA) onecol

**Table 3, run 6 MAJOR POWERS

label var nMP "Major Powers"
logit newmemb_1 `core' nMP if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(nMP) onecol

**Table 3, run 7 GATT ROUND

label var GATTrnd "GATT Round"
logit newmemb_1 `core' GATTrnd if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(GATTrnd) onecol

**Table 3, run 8 CHANGE GATT SIZE

label var dGATTWTOn "Ch. GATT Size"
logit newmemb_1 `core' dGATTWTOn if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(dGATTWTOn) onecol

**Table 3, run 9 POST-COLD WAR

label var postCW "Post-Cold War"
logit newmemb_1 `core' postCW if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(postCW) onecol

**Table 3, run 10 HEGEMONY

label var hegGDP "Hegemony"
logit newmemb_1 `core' hegGDP if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(hegGDP) onecol

**Table 3, run 11 DEMOCRACY

label var meanDEMmlat "Democracy"
logit newmemb_1 `core' meanDEMmlat if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(meanDEMmlat) onecol

**Table 3, run 12 MIDS

label var PTAmids "MIDs"
logit newmemb_1 `core' PTAmids if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(PTAmids) onecol

**Table 3, run 13 DEVELOPMENT

label var meanDEVmlat "Development"
logit newmemb_1 `core' meanDEVmlat if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(meanDEVmlat) onecol

**Table 3, run 14 PCT. CONTIGUOUS 

label var PTA_contigpct "% States Contig"
logit newmemb_1 `core' PTA_contigpct if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(PTA_contigpct) onecol

**Table 3, run 15 NUMBER PRIOR EXPANSIONS

label var nexpand "Number Prev. Expansions"
logit newmemb_1 `core' nexpand if level=="M", cluster(PTAname)

outreg2 using table3, word bdec(3) stat(pval) append keep(nexpand) onecol

**Table 4 t-tests; section 1

*joinDEM = Polity scores of new members
*existDEM = Polity scores of existing members
ttest joinDEM == existDEM 

*joinGDP = Polity scores of new members
*existGDP = Polity scores of existing members
ttest joinGDP == existGDP

*joinOPEN = Polity scores of new members
*existOPEN = Polity scores of existing members
ttest joinOPEN == existOPEN

*joinPCGDP = Polity scores of new members
*existPCGDP = Polity scores of existing members
ttest joinPCGDP == existPCGDP

**Table 4 t-tests; section 2

ttest joinDEM == existDEM  if PTAname~="EEC_EU"

ttest joinGDP == existGDP if PTAname~="EEC_EU"

ttest joinOPEN == existOPEN if PTAname~="EEC_EU"

ttest joinPCGDP == existPCGDP if PTAname~="EEC_EU"

log close
