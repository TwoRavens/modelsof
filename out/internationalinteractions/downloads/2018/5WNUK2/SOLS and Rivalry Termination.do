// Bryan Rooney
// Rivalry and Regime Change
// 1/18/2016

/*clear
cd "/Users/bryanandrewrooney/Dropbox/Rivalry/Rivalry 1.18"

insheet using "Rivalry data 1816-2010.csv"

gen endyear=end
gen beginyear=start
replace endyear=2010 if end==.
replace beginyear= "1816" if start =="pre1816"
destring beginyear, replace

sort ccode1 beginyear
gen rivid=_n

gen duration = (endyear-beginyear)+1

expand duration
sort rivid
by rivid: gen temp=_n-1
gen year=beginyear+temp
drop temp
sort rivid year

gen terminate=0
replace terminate=1 if end==year & end!=.

replace positional=0 if positional==.
replace spatial=0 if spatial==.
replace ideol=0 if ideol==.

sort ccode1 ccode2 year
save "rivalrythompson.dta", replace

//SOLS Data merge

use "CHISOLSstyr3_0.dta", clear

gen numsols= solschange1+solschange2+solschange3+solschange4+solschange5+solschange6+solschange7
gen nummin= solsminch1+solsminch2+solsminch3+solsminch4+solsminch5+solsminch6+solsminch7

keep ccode year regtrans leadertrans solschange solsminchange numsols nummin 
rename ccode ccode1
rename regtrans rega
rename leadertrans leada
rename solschange solsa
rename solsminchange solsmina
rename numsols numsolsa
rename nummin numina

sort ccode1 year

save "solsamerge", replace

use "CHISOLSstyr3_0.dta", clear

gen numsols= solschange1+solschange2+solschange3+solschange4+solschange5+solschange6+solschange7
gen nummin= solsminch1+solsminch2+solsminch3+solsminch4+solsminch5+solsminch6+solsminch7

keep ccode year regtrans leadertrans solschange solsminchange numsols nummin 
rename ccode ccode2
rename regtrans regb
rename leadertrans leadb
rename solschange solsb
rename solsminchange solsminb
rename numsols numsolsb
rename nummin numinb

sort ccode2 year

save "solsbmerge", replace

//Merge 
clear

use "rivalrythompson.dta", clear

sort ccode1 year
merge ccode1 year using "solsamerge"
drop _merge

sort ccode2 year
merge ccode2 year using "solsbmerge"
drop _merge

drop if rivid==.

gen solschange=.
replace solschange=1 if solsa==1 
replace solschange=1 if solsa==2
replace solschange=1 if solsa==3
replace solschange=1 if solsb==1 
replace solschange=1 if solsb==3 
replace solschange=1 if solsb==2
replace solschange=0 if solsa==0 & solsb==0

gen regtrans=.
replace regtrans=1 if rega>=1 & rega!=.
replace regtrans=1 if regb>=1 & regb!=.
replace regtrans=0 if rega==0 & regb==0

gen leadertrans=.
replace leadertrans=1 if leada>=1 & leada!=.
replace leadertrans=1 if leadb>=1 & leadb!=.
replace leadertrans=0 if leada==0 & leadb==0

tab terminate solschange, row

gen time=year-beginyear+1

sort ccode1 ccode2 year
save "rivalrySOLS.dta", replace

//Merge with DUTRPIC Data

use "rivalrySOLS.dta", clear

sort ccode1 ccode2 year
merge ccode1 ccode2 year using "dr_dyadic_data_11212015.dta"

sort ccode1 ccode2 year
save "rivalrySOLScontrols.dta", replace

//Other Data

//IGO
use "IGO_dyadunit_stata_v2.3.dta", clear
egen jointigo = anycount(AAAID-Wassen), values(1)
keep ccode1 ccode2 year jointigo
sort ccode1 ccode2 year
save "jointigo.dta", replace

use "rivalrySOLScontrols.dta"
drop _merge
sort ccode1 ccode2 year
merge ccode1 ccode2 year using "jointigo.dta", nokeep
tab _merge
drop _merge
sort rivid year
save "rivalrySOLScontrols2.dta", replace

//Trade
clear
insheet using "COW_Trade_3.0/dyadic_trade_3.0.csv"

gen trade=.
replace trade=flow1+flow2 if flow1!=-9 & flow2!=-9
keep ccode1 ccode2 year trade
sort ccode1 ccode2 year
save "tradetemp.dta", replace
clear

use "rivalrySOLScontrols2.dta", clear
sort ccode1 ccode2 year
merge ccode1 ccode2 year using "tradetemp.dta", nokeep
tab _merge
drop _merge

sort ccode1 year
save "rivalrySOLScontrols3.dta", replace

// Other MIDs

clear
insheet using "MID-level/MIDB_4.01.csv"
gen mid=1
sort ccode styear
bysort ccode styear: egen count_mid = count(mid)
save "participantMID.dta", replace

rename ccode ccode1
rename styear year
collapse count_mid, by(ccode1 year)
rename count_mid count_mid1
sort ccode1 year
save "mida.dta", replace

clear
use "participantMID.dta"
rename ccode ccode2
rename styear year
collapse count_mid, by(ccode2 year)
rename count_mid count_mid2
sort ccode2 year
save "midb.dta", replace

clear
use "rivalrySOLScontrols3.dta", clear
sort ccode1 year
merge m:1 ccode1 year using "mida.dta"
tab _merge
drop _merge

sort ccode2 year
merge m:1 ccode2 year using "midb.dta"
tab _merge
drop _merge

replace count_mid1=0 if count_mid1==.
replace count_mid2=0 if count_mid2==.
gen outside_mida = count_mid1 - mid_count
gen outside_midb = count_mid2 - mid_count
gen outside_mid = outside_mida + outside_midb

gen numsols_ch = numsolsa+numsolsb

drop if rivid==.
gen sols_cha=solsa
replace sols_cha=1 if sols_cha==2
replace sols_cha=1 if sols_cha==3
gen sols_chb=solsb
replace sols_chb=1 if sols_chb==2
replace sols_chb=1 if sols_chb==3
tab sols_cha rega, row
tab sols_chb regb, row

save  "rivalrySOLScontrols4.dta", replace
use "rivalrySOLScontrols4.dta", clear

label var solschange "Source of Leader Support Change"
label var regtrans "Regime Transition"
label var contiguity "Contiguity"
label var stalemate "Probability of Stalemate"
label var past_mids "Past MIDs"
label var jointdem "Joint Democracy"
label var icb_dummy "Crisis in Rivalry"
label var jointigo "Joint IGO Memberships"
label var trade "Trade Flows"
label var peace_years_mid "Peace Years"
label var positional "Positional Rivalry"
label var spatial "Spatial Rivalry"
label var ideol "Ideological Rivalry"
label var terminate "Rivalry Termination"
label var leadertrans "Leader Transition"
label var rivalry_length "Rivalry Length"


browse if terminate==1 & solschange==1 & regtrans==0
browse if terminate==0 & solschange==0 & leadertrans==0
browse if terminate==1 & solschange==0 & regtrans==1
browse if terminate==1 & solschange==0 & leadertrans==1

gen solsdem_ch=.
replace solsdem_ch=1 if solsa==1 & polity2_1>=6 & polity2_1!=.
replace solsdem_ch=1 if solsa==2 & polity2_1>=6 & polity2_1!=.
replace solsdem_ch=1 if solsa==3 & polity2_1>=6 & polity2_1!=.
replace solsdem_ch=1 if solsb==1 & polity2_2>=6 & polity2_2!=.
replace solsdem_ch=1 if solsb==3 & polity2_2>=6 & polity2_2!=.
replace solsdem_ch=1 if solsb==2 & polity2_2>=6 & polity2_2!=.
replace solsdem_ch=0 if solsa==0 & solsb==0
replace solsdem_ch=0 if solsa==1 & polity2_1<=6 & polity2_1!=.
replace solsdem_ch=0 if solsa==2 & polity2_1<=6 & polity2_1!=.
replace solsdem_ch=0 if solsa==3 & polity2_1<=6 & polity2_1!=.
replace solsdem_ch=0 if solsb==1 & polity2_2<=6 & polity2_2!=.
replace solsdem_ch=0 if solsb==2 & polity2_2<=6 & polity2_2!=.
replace solsdem_ch=0 if solsb==3 & polity2_2<=6 & polity2_2!=.

gen solsaut_ch=.
replace solsaut_ch=0 if solsa==1 & polity2_1>=6 & polity2_1!=.
replace solsaut_ch=0 if solsa==2 & polity2_1>=6 & polity2_1!=.
replace solsaut_ch=0 if solsa==3 & polity2_1>=6 & polity2_1!=.
replace solsaut_ch=0 if solsb==1 & polity2_2>=6 & polity2_2!=.
replace solsaut_ch=0 if solsb==3 & polity2_2>=6 & polity2_2!=.
replace solsaut_ch=0 if solsb==2 & polity2_2>=6 & polity2_2!=.
replace solsaut_ch=0 if solsa==0 & solsb==0
replace solsaut_ch=1 if solsa==1 & polity2_1<=6 & polity2_1!=.
replace solsaut_ch=1 if solsa==2 & polity2_1<=6 & polity2_1!=.
replace solsaut_ch=1 if solsa==3 & polity2_1<=6 & polity2_1!=.
replace solsaut_ch=1 if solsb==1 & polity2_2<=6 & polity2_2!=.
replace solsaut_ch=1 if solsb==2 & polity2_2<=6 & polity2_2!=.
replace solsaut_ch=1 if solsb==3 & polity2_2<=6 & polity2_2!=.

gen regtransboth=regtrans
replace regtransboth=0 if regb>=1 & regb!=. & rega<1 
replace regtransboth=0 if rega>=1 & rega!=. & regb<1 

gen solsboth=solschange
replace solsboth=0 if solsb>=1 & solsb!=. & solsa<1 
replace solsboth=0 if solsa>=1 & solsa!=. & solsb<1 


gen solsone=solschange
replace solsone=0 if solsboth==1

//Regions
gen region1=.
replace region1=1 if ccode1>0 & ccode1<200
replace region1=2 if ccode1>200 & ccode1<400
replace region1=3 if ccode1>400 & ccode1<600
replace region1=4 if ccode1>=600 & ccode1<=700
replace region1=5 if ccode1>700 & ccode1!=.

gen region2=.
replace region2=1 if ccode2>0 & ccode2<200
replace region2=2 if ccode2>200 & ccode2<400
replace region2=3 if ccode2>400 & ccode2<600
replace region2=4 if ccode2>=600 & ccode2<=700
replace region2=5 if ccode2>700 & ccode2!=.

gen sameregion=.
replace sameregion=1 if region1==region2
replace sameregion=0 if region1!=region2 & region1!=. & region2!=.

gen region=.
replace region=0 if region1!=region2 & region1!=. & region2!=.
replace region=1 if region1==1  & region2==1 
replace region=2 if region1==2 & region2==2
replace region=3 if region1==3 & region2==3
replace region=4 if region1==4 & region2==4
replace region=5 if region1==5 & region2==5

egen dyad = concat(ccode1 ccode2)
destring dyad, replace

sort rivdyad year
by rivdyad: gen lagsols=solschange[_n-1]

sort rivdyad year
by rivdyad: gen lagsols2=solschange[_n-2]

sort rivdyad year
by rivdyad: gen lagsols3=solschange[_n-3]


sort rivdyad year
by rivdyad: gen lagsols4=solschange[_n-4]

gen sols2yrs=.
replace sols2yrs=1 if solschange==1
replace sols2yrs=1 if lagsols==1
replace sols2yrs=0 if solschange==0 & lagsols==0 

gen sols3yrs=.
replace sols3yrs=1 if solschange==1
replace sols3yrs=1 if lagsols==1
replace sols3yrs=1 if lagsols2==1
replace sols3yrs=0 if solschange==0 & lagsols==0 & lagsols2==0

gen sols5yrs=.
replace sols5yrs=1 if solschange==1
replace sols5yrs=1 if lagsols==1
replace sols5yrs=1 if lagsols2==1
replace sols5yrs=1 if lagsols3==1
replace sols5yrs=1 if lagsols4==1
replace sols5yrs=0 if solschange==0 & lagsols==0 & lagsols2==0 & lagsols3==0 & lagsols4==0 


sort rivdyad year
by rivdyad: gen lagreg=regtrans[_n-1]

sort rivdyad year
by rivdyad: gen lagreg2=regtrans[_n-2]

sort rivdyad year
by rivdyad: gen lagreg3=regtrans[_n-3]


sort rivdyad year
by rivdyad: gen lagreg4=regtrans[_n-4]

gen reg2yrs=.
replace reg2yrs=1 if regtrans==1
replace reg2yrs=1 if lagsols==1
replace reg2yrs=0 if solschange==0 & lagreg==0 

gen reg3yrs=.
replace reg3yrs=1 if regtrans==1
replace reg3yrs=1 if lagreg==1
replace reg3yrs=1 if lagreg2==1
replace reg3yrs=0 if regtrans==0 & lagreg==0 & lagreg2==0

gen reg5yrs=.
replace reg5yrs=1 if regtrans==1
replace reg5yrs=1 if lagreg==1
replace reg5yrs=1 if lagreg2==1
replace reg5yrs=1 if lagreg3==1
replace reg5yrs=1 if lagreg4==1
replace reg5yrs=0 if regtrans==0 & lagreg==0 & lagreg2==0 & lagreg3==0 & lagreg4==0 


sort rivdyad year
by rivdyad: gen lagstale=stalemate[_n-1]

sort rivdyad year
by rivdyad: gen lagmidout=outside_mid[_n-1]

sort rivdyad year
by rivdyad: gen lagicb=icb_dummy[_n-1]

sort rivdyad year
by rivdyad: gen lagpy=peace_years_mid[_n-1]

sort rivdyad year
by rivdyad: gen lagigo=jointigo[_n-1]

sort rivdyad year
by rivdyad: gen lagtrade=trade[_n-1]

sort rivdyad year
by rivdyad: gen lagdem=jointdem[_n-1]


label var solschange "Source of Leader Support Change"
label var regtrans "Regime Transition"
label var contiguity "Contiguity"
label var stalemate "Probability of Stalemate"
label var past_mids "Past MIDs"
label var jointdem "Joint Democracy"
label var outside_mid "Non-Rival MIDs"
label var icb_dummy "Crisis in Rivalry"
label var jointigo "Joint IGO Memberships"
label var trade "Trade Flows"
label var peace_years_mid "Peace Years"
label var positional "Positional Rivalry"
label var spatial "Spatial Rivalry"
label var ideol "Ideological Rivalry"
label var terminate "Rivalry Termination"
label var numsols_ch "Number of SOLS Changes" 
label var leadertrans "Leader Transition"
label var rivalry_length "Rivalry Length"

gen dem_change=.
replace dem_change=0 if solschange==0
replace dem_change=1 if solsa>=1 & solsa!=. & polity2_1>=6 & polity2_1!=.
replace dem_change=1 if solsb>=1 & solsb!=. & polity2_2>=6 & polity2_1!=.
replace dem_change=0 if solsa>=1 & solsa!=. & polity2_1<=5
replace dem_change=0 if solsb>=1 & solsb!=. & polity2_1<=5

gen nondem_change=.
replace nondem_change=0 if solschange==0
replace nondem_change=0 if solsa>=1 & solsa!=. & polity2_1>=6 & polity2_1!=.
replace nondem_change=0 if solsb>=1 & solsb!=. & polity2_2>=6 & polity2_1!=.
replace nondem_change=1 if solsa>=1 & solsa!=. & polity2_1<=5
replace nondem_change=1 if solsb>=1 & solsb!=. & polity2_1<=5

label var dem_change "Democratic Source of Leader Support Change"
label var nondem_change "Non-Democratic Source of Leader Support Change"


sort rivdyad year
by rivdyad: gen lagterminate=terminate[_n-1]

gen terminate2yrs=.
replace terminate2yrs=1 if terminate==1
replace terminate2yrs=1 if lagterminate==1
replace terminate2yrs=0 if terminate==0 & lagterminate==0

sort rivdyad year
by rivdyad: gen lagterminate2=terminate[_n-2]

gen terminate3yrs=.
replace terminate3yrs=1 if terminate==1
replace terminate3yrs=1 if lagterminate==1
replace terminate3yrs=1 if lagterminate2==1
replace terminate3yrs=0 if terminate==0 & lagterminate==0 & lagterminate2==0

sort rivdyad year
by rivdyad: gen lagterminate3=terminate[_n-3]

sort rivdyad year
by rivdyad: gen lagterminate4=terminate[_n-4]

gen terminate5yrs=.
replace terminate5yrs=1 if terminate==1
replace terminate5yrs=1 if lagterminate==1
replace terminate5yrs=1 if lagterminate2==1
replace terminate5yrs=1 if lagterminate3==1
replace terminate5yrs=1 if lagterminate4==1
replace terminate5yrs=0 if terminate==0 & lagterminate==0 & lagterminate2==0 & lagterminate3 ==0 & lagterminate4==0



save  "final_data.dta", replace

*/	

use  "Rivalry Replication.dta", clear

gen dyadid=((ccode1*1000)+ccode2)

//Analysis

//Summary stats

sutex terminate solschange regtrans contiguity stalemate past_mids peace_years_mid outside_mid  jointdem jointigo ln_tradefl , lab nobs key(descstat) replace file(descstat.tex) title("Summary Statistics") minmax

sort rivid year
tab solschange terminate, row

//Table 1

global X regtrans contiguity stalemate past_mids peace_years_mid outside_mid  jointdem jointigo ln_tradefl 

eststo clear
stset time terminate, id(rivid)
eststo: stcox solschange regtrans, robust cluster(rivdyad)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate2yrs, id(rivid)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate3yrs, id(rivid)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
esttab using Table1.tex, se star(* 0.10 ** 0.05 *** .01) label replace eform
eststo clear

//Table 3

eststo clear
stset time terminate, id(rivid)
eststo: stcox solschange regtrans, robust cluster(rivdyad)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate2yrs, id(rivid)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate3yrs, id(rivid)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
esttab using Table1_Coef.tex, se star(* 0.10 ** 0.05 *** .01) label replace 
eststo clear


//Tables 5 and 6 

stset, clear
stset time terminate, id(rivid)
eststo: stcox solsone regtrans, robust cluster(rivdyad)
eststo: stcox solsone $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate2yrs, id(rivid)
eststo: stcox solsone $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate3yrs, id(rivid)
eststo: stcox solsone $X i.region, robust cluster(rivdyad)
esttab using Solsone.tex, se star(* 0.10 ** 0.05 *** .01) label replace eform
eststo clear

stset, clear
stset time terminate, id(rivid)
eststo: stcox solsboth regtrans, robust cluster(rivdyad)
eststo: stcox solsboth $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate2yrs, id(rivid)
eststo: stcox solsboth $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate3yrs, id(rivid)
eststo: stcox solsboth $X i.region, robust cluster(rivdyad)
esttab using Solsboth.tex, se star(* 0.10 ** 0.05 *** .01) label replace eform
eststo clear

//Table 7

global X regtrans contiguity stalemate past_mids peace_years_mid outside_mid  jointdem jointigo ln_tradefl positional spatial ideol 

eststo clear
stset time terminate, id(rivid)
eststo: stcox solschange regtrans, robust cluster(rivdyad)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate2yrs, id(rivid)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate3yrs, id(rivid)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
esttab using Table1_riv_types.tex, se star(* 0.10 ** 0.05 *** .01) label replace eform
eststo clear

//Table 8

global X leadertrans contiguity stalemate past_mids peace_years_mid outside_mid  jointdem jointigo ln_tradefl 

eststo clear
stset time terminate, id(rivid)
eststo: stcox solschange leadertrans, robust cluster(rivdyad)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate2yrs, id(rivid)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate3yrs, id(rivid)
eststo: stcox solschange $X i.region, robust cluster(rivdyad)
esttab using leader_trans.tex, se star(* 0.10 ** 0.05 *** .01) label replace eform
eststo clear

//Table 9

global X regtrans contiguity stalemate past_mids peace_years_mid outside_mid  jointdem jointigo ln_tradefl 

eststo clear
stset time terminate, id(rivid)
eststo: stcox dem_change nondem_change regtrans, robust cluster(rivdyad)
eststo: stcox dem_change nondem_change $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate2yrs, id(rivid)
eststo: stcox dem_change nondem_change $X i.region, robust cluster(rivdyad)
stset, clear
stset time terminate3yrs, id(rivid)
eststo: stcox dem_change nondem_change $X i.region, robust cluster(rivdyad)
esttab using regime_type.tex, se star(* 0.10 ** 0.05 *** .01) label replace eform
eststo clear

//Figure 1

//Requires package st0380 

global X regtrans contiguity stalemate past_mids peace_years_mid outside_mid  jointdem jointigo ln_tradefl 

stset time terminate, id(rivid)
stcox solschange $X i.region, robust cluster(rivdyad)
predict xb, xb
predict s0, basesurv
xtile group = xb, nquantiles(2)
stcoxgrp xb s0, mean(s) by(group) km(km)
line s1 km1 km_lb1 km_ub1 s2 km2 km_lb2 km_ub2 _t if _t<=200, sort connect(J..) lpattern(l - - - l - - -) 


// Table 10 (Archigos)
// Convergence takes a long time
// Recommended to run in Stata 13

use  "Archigos.dta", clear
drop if rivid==.


eststo clear
stset time terminate, id(rivid)
eststo: ivpoisson gmm _d $X (solschange = irreg_ch) i._t if _st==1, add 
esttab using iv.tex, se star(* 0.10 ** 0.05 *** .01) label replace 
eststo clear

// Table 4 (Crescenzi Score) 
// NOTE: Table 4 presents exponentiated coefficients

use  "Conflict Score.dta", clear

global X regtrans contiguity stalemate past_mids peace_years_mid outside_mid  jointdem jointigo ln_tradefl 

eststo: reg ConIISmid_bl solschange $X i.region, robust cluster(dyadid)
eststo: tobit ConIISmid_bl solschange $X i.region, ul(0) ll(-1)
esttab using Conflict_score.tex, se star(* 0.10 ** 0.05 *** .01) label replace eform
eststo clear
