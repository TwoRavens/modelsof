use raw.dta, clear  // not provided but can be downloaded from the BLS website for free
gen crossection = (suphispanic==0) & (supblack==0) // keeping only random sample, suppoor was dropped in 91, and military was also dropped even earlier. so we don't have them here.
label var cross "random sample" 

do group_a.do // defines baseline and strict groups 

label define groups 1 "Puzzle" 2 "Borrower" 3 "Neutral" 4 "Saver"
local vars "a a5001m"
foreach x of local vars{
label values  group_`x' groups
}


gen ps=(group_a==1) if !mi(group_a)  // baseline puzzle = 1  vs saver = 0
replace ps=. if (group_a==2 | group_a==3)

do groups.do // define transitions from puzze to saver and visa-versa for both baseline and strict definitions
do transitions.do  // define transitions from puzzle to other groups (not just puzzle to saver)

do riskaversion.do // create the risk aversion measure

do impatience.do /// IMPATIENCE AND TIME DISCOUNTING


do job_shock.do ///////////////////// create job shock variable, as measure of income volatility


*EMPLOYMENT STATUS VARIABLES

xtset caseid year, yearly
sort case year

gen employed=(empst==1 |empst==7) if !mi(empst) & empst!=0  //employed and military
gen unemployed=(empst==4 |empst==2) if !mi(empst) & empst!=0 //unemployed and don't know if unemployed or out of labor force
gen outlf=(empst==5 ) if !mi(empst) & empst!=0
gen inlf=1-outlf


gen Fchange=(empst!=F2.empst)  if !mi(empst, F2.empst) 
gen Bchange=(empst!=L2.empst)  if !mi(empst, L2.empst) 
gen Fmove=F2.move_75 


gen job_Fnojob=(employed==1 & F2.unemployed==1) if !mi(employed, F2.unemployed)
gen nojob_Fjob=(unemployed==1 & F2.employed==1) if !mi(unemployed, F2.employed)
gen job_Bnojob=(employed==1 & L2.unemployed==1) if !mi(employed, L2.unemployed)
gen nojob_Bjob=(unemployed==1 & L2.employed==1) if !mi(unemployed, L2.employed)

egen transitionB=rowtotal(job_Bnojob nojob_Bjob)
egen transitionF=rowtotal(job_Fnojob nojob_Fjob)


*Health and Divorce shocks

*divorced/separated within the period
capture drop divsep08
gen divsep08=((L4.married==1 | L2.married==1) & divsep==1) if year==2008 & !mi(L4.married,L2.married,divsep)
bysort caseid: egen divsep08p=max(divsep08)
drop divsep08
rename divsep08p divsep08

capture drop divsep12
gen divsep12=((L4.married==1 | L2.married==1) & divsep==1) if year==2012 & !mi(L2.married,L4.married,divsep)
bysort caseid: egen divsep12p=max(divsep12)
drop divsep12
rename divsep12p divsep12
gen Ddivsep=max(divsep12, divsep08) 

*Health limitations

gen health08=(healthlimitations==1 & (L4.healthlimitations==0 |L2.healthlimitations==0)) if year==2008 & !mi(healthlimitations,L2.healthlimitations,L4.healthlimitations)
bysort caseid: egen health08p=max(health08)
drop health08
rename health08p health08

gen health12=(healthlimitations==1 & (L4.healthlimitations==0 |L2.healthlimitations==0)) if year==2012 & !mi(healthlimitations,L2.healthlimitations,L4.healthlimitations)
bysort caseid: egen health12p=max(health12)
drop health12
rename health12p health12
gen Dhealth=max(health12, health08) 


//// Measuring Liquidity Cosntraitns, based on application for credit in the last 5 years

replace apply = 1 if turndowncred==1 & apply==.
replace apply = 0 if turndowncred==0 & apply==.

gen lconstf=(turndowncred==1) if applycred!=. & turndowncred!=. //this includes only those that were turned down.
replace lconstf=1 if ficklecred == 1  // including those that were discouraged or changed their minds for some other reason


label var lconstf "Credit Access Risk"

/// Financial Literacy and education Variables

gen collegemore=(hgc>=16) if !mi(hgc) // college or more

qui sum totalfinq if cross==1 [aw=weight], detail
capture drop mfinq finqa
gen mfinq=r(p50) if !mi(totalfinq)

gen finqa=(totalfinq>=mfinq) if !mi(totalfinq) & cross==1 // financial literacy based on correct answers above median

qui sum finknowledge if cross==1  [aw=weight], detail
gen mfink=r(p50) if !mi(finknowledge)
gen finka=(finknowledge>=mfink) if !mi(finknowledge) & cross==1  // financial self-knowledge based on self-assesment above median
drop mfink mfinq

gen interestq_c=interestq==1 if !mi(interestq) // correct answer to compound interest rate question
gen mortgq_c=mortgageq==1 if !mi(mortgageq) // correct answer to mortgage question

replace finqa=. if interestq_c==.
replace finqa=. if mortgq_c==.

*Construct home ownership and home equity

gen rhequity=rhousev-rmort if howner==1
gen rhequityp=rhequity/rhousev
replace rhequity=. if rhequityp<-.65
replace rhequityp=. if rhequityp<-.65
*for renters
replace rhequityp=0 if howner==0
replace rhequity=0 if howner==0
gen negequity=(rhequityp<0) if !mi(rhequityp)

replace hown=1 if hown==0 & rhousev>0 & rhousev<. 

gen ho_m=howner*wmortg  // home owner with mortgage
gen ho_nom= (howner==1 & wmortg==0) if !mi(howner, wmortg) // home owner without mortgage

rename wmortgdebt wmortgdebt1

/// WINSORIZE CCDEBT AND LIQ ASSETS  // income and wealth are already winsorized

foreach i in 2004 2008 2012 {
   foreach j in rtotdebt rfinasst rleftovera rmort rhousev rcar rcardebt rstudentdebt rccdebt rliqasset {
	egen pc`i'=pctile(`j') if year==`i', p(95)
	replace `j'=pc`i' if `j'>pc`i' & `j'<.
	drop pc`i'
}
}

gen rarbitrage=rliqasset-rccdebt


// bank branch data, data from FDIC to be merged when county identifiers are available

gen popsh_branch=pop/totalfs  // county population/number of bank branches
gen areash_branch=area_land/totalfs
gen lnbr_pop=ln(popsh_branch)
gen lnareal=ln(area_land)
gen lnarea=ln(area_tot)
preserve 
collapse totalfs total pop area_land pov* popsh_branch, by(state_new county_new year)

gen stc=state*10000+county
drop if stc==.

tsset stc year
bys stc: gen gtotfs4=(totalfs-l4.totalfs)/l4.totalfs
bys stc: gen gtot4=(total-l4.total)/l4.total
bys stc: gen gpopbr4=(popsh_branch-l4.popsh_branch)/l4.popsh_branch
bys stc: gen gpopbr=(popsh_branch-l2.popsh_branch)/l2.popsh_branch
bys stc: gen gpovp4=(povertypct_c/l4.povertypct_c)-1
bys stc: gen gpovp=(povertypct_c/l2.povertypct_c)-1
bys stc: gen dpopbr4=(popsh_branch-l4.popsh_branch)
bys stc: gen dpopbr=(popsh_branch-l2.popsh_branch)
bys stc: gen gpop4=(pop/l4.pop)-1
bys stc: gen gpop=(pop/l2.pop)-1

keep g* d* state county year
save county_g, replace
restore

merge m:1 state_new  county_new year using county_g
drop _m




save nsly.dta, replace


