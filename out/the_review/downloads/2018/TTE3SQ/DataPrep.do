use dta/FivaSmith_Jan2018.dta, clear   /* Fiva and Smith dataset , last edited January 10, 2018 */

drop votes1-rejectedChange age birthyear deathyear /* these variables only matter for pre-1921 period , or we only have them for elected */

rename elected seat
renpfix isco ISIC

replace ISIC1=9999 if ISIC1==.
replace ISIC1=9999 if ISIC1>100

replace ISIC2=9999 if ISIC2==.
replace ISIC2=9999 if ISIC2>100

*********************************************************************************
******************************FIXING DUPLICATES *********************************
*********************************************************************************

bysort pid year: egen min_rank=min(rank)
keep if rank==min_rank  /* keeping only the highest ranked entry for each candidate */
drop if party=="v" & year==2013 & district=="aust-agder" /* Venstre ran with identical lists in Vest-Agder and Aust-Agder in 2013. Venstre were 8.5pp away from winning a regular seat in Vest-Agder, and 13.1pp away from winning a regular seat in Aust-Agder, so we keep Vest-Agder */

drop if candidatename_ed=="Anders Lange" & district=="vest-agder" /* Anders Lange was ranked first in both Oslo and Vest-Agder, but performed best in Oslo */
drop if candidatename_ed=="Svend Haakon Jacobsen" & district=="rogaland" /* runs in both districts as hopeless candidate but same rank, arbitrary exclude one */
drop if candidatename_ed=="Kristin Dalehamn" & district=="rogaland" /* runs in both districts as hopeless candidate but same rank, arbitrary exclude one */
drop if candidatename_ed=="Steinar Bastesen" & district=="nord-trøndelag" /* runs in two districts in 2001, and wins in Nordland */

gen rank1=0
replace rank1=1 if rank==1

gen cand=1  /* ALL CANDIDATES IN DATASET ARE RUNNING BEFORE RESHAPING */

/* MAIN PARTIES */
gen main=0
replace main=1 if party=="nkp"|party=="sv"|party=="dna"|party=="sp"|party=="v"|party=="krf"|party=="h"|party=="frp"
keep if main==1

drop *pact* /* don't need these variables */

drop if year<1944

gen zz=1
egen count=sum(zz), by(pid year)
assert count==1 /* verifying that pid year uniquely id. obs. */


********************************************************************************************************************
******************* RESHAPING TO GET A BALANCED PANEL SO EVERY CANDIDATE IS IN EVERY ELECTION YEAR *****************
********************************************************************************************************************
foreach var in occupation1 occupation2 ISIC1 ISIC2 rank1{
rename `var' `var'_
}

sum
reshape wide pid_NSD pid_NSD2 parachute districtid district region magnitude electorate party partyname rank candrun candwin first_year last_year ever_seat candidatename_orig candidatename_ed firstname lastname female hometown_orig hometown hometownpop hometownID town districttown occupation_orig occupation1_ occupation2_ ISIC1_ ISIC2_ seat votes voteshare approvedvotesoverall castedvotesoverall turnout parliament adjustmentseats margin min_rank rank1_ cand deputy deputy1 days, i(pid) j(year)
reshape long pid_NSD pid_NSD2 parachute districtid district region magnitude electorate party partyname rank candrun candwin first_year last_year ever_seat candidatename_orig candidatename_ed firstname lastname female hometown_orig hometown hometownpop hometownID town districttown occupation_orig occupation1_ occupation2_ ISIC1_ ISIC2_ seat votes voteshare approvedvotesoverall castedvotesoverall turnout parliament adjustmentseats margin min_rank rank1_ cand deputy deputy1 days, i(pid) j(year)
sum

foreach var in occupation1 occupation2 ISIC1 ISIC2 rank1{
rename `var'_ `var'
}

replace seat=0 if seat==.
replace cand=0 if cand==.
replace rank1=0 if rank1==.

sort pid year

foreach var in seat cand rank1 rank margin {
forvalues i=0(1)17 {
by pid: gen `var'_next`i'=`var'[_n+`i']
by pid: gen `var'_prev`i'=`var'[_n-`i'] 
}
}


gen firstyear=0
replace firstyear=1 if year==first_year

/* MAKE OCCUPATION CLASSIFICATION BASED ON FIRST-YEAR CAND. IS RUNNING */

foreach type in 1 2 {
gen ISIC`type'_first=-999
replace ISIC`type'_first=ISIC`type' if year==first_year  /* ONLY USING occupations status from first-year */
egen ISIC`type'_FIRST=max(ISIC`type'_first), by (pid)
drop ISIC`type' ISIC`type'_first
rename ISIC`type'_FIRST ISIC`type'

/* TWO DIGIT ISIC */

forvalues i=1(1)179{
gen d_ISIC`type'`i'=0
replace d_ISIC`type'`i'=1 if ISIC`type'==`i'
}

/* ONE DIGIT ISIC */

forvalues i=1(1)17{
egen isic`type'_`i'=rowtotal(d_ISIC`type'`i'0- d_ISIC`type'`i'9)
}

}

/* JOINT ISIC - ONE DIGIT */
forvalues i=1(1)17{
gen jointisic`i'=(isic1_`i'+isic2_`i')>0
}

gen jointisic0=0
replace jointisic0=1 if (ISIC1==9999 & ISIC2==9999)

egen test=rowtotal(jointisic1-jointisic0)  /* should sum to at least one */
sum test if districtid!=.

drop isic* d_ISIC* ISIC*
renpfix jointisic isic

gen previous_non_hopeless=0
**** all candidates previously winning a seat ****
forvalues i=1(1)17 {
replace previous_non_hopeless=1 if seat_prev`i'==1 
}
**** all candidates entering discontinuity window in previous elections ****
forvalues i=1(1)17 {
replace previous_non_hopeless=1 if abs(margin_prev`i')<0.5 & margin_prev`i'!=.
}

save dta/DataPrep, replace
