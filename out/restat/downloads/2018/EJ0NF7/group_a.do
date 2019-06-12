*only assets imputed, credit card not

gen aip = (ccdebt>0 & liqasseti>0) if !mi(ccdebt, liqasseti)
gen aib = (ccdebt>0 & liqasseti==0) if !mi(ccdebt, liqasseti)
gen ais = (ccdebt==0 & liqasseti>0) if !mi(ccdebt, liqasseti)
gen ain = (ccdebt==0 & liqasseti==0) if !mi(ccdebt, liqasseti)


*some vars for indicating whether or not present in 2004 and 2008, 2012
local vars "aip aib ais ain "
foreach x of local vars {
gen `x'04m = (`x'==1 & year==2004)
bysort caseid: egen `x'04 = max(`x'04m) if !mi(`x')
drop `x'04m
gen `x'08m = (`x'==1 & year==2008)
bysort caseid: egen `x'08 = max(`x'08m) if !mi(`x')
drop `x'08m
gen `x'12m = (`x'==1 & year==2012)
bysort caseid: egen `x'12 = max(`x'12m) if !mi(`x')
drop `x'12m
}


gen group_ai04=1 if aip==1 & year==2004
replace group_ai04=2 if aib==1 & year==2004
replace group_ai04=3 if ain==1 & year==2004
replace group_ai04=4 if ais==1 & year==2004

gen group_ai08=1 if aip==1 & year==2008
replace group_ai08=2 if aib==1 & year==2008
replace group_ai08=3 if ain==1 & year==2008
replace group_ai08=4 if ais==1 & year==2008

gen group_ai12=1 if aip==1 & year==2012
replace group_ai12=2 if aib==1 & year==2012
replace group_ai12=3 if ain==1 & year==2012
replace group_ai12=4 if ais==1 & year==2012


foreach i in ai04 ai08 ai12 {
	bys caseid: egen mg=max(group_`i')
	drop group_`i'
	rename mg group_`i' 
}

capture label drop group
label def group 1 "puzzle" 2 "borrower" 4 "saver" 3 "neutral"

foreach i in ai04 ai08 ai12 {
label val group_`i' group
}

foreach i in ai04 ai08 ai12 {
label var group_`i' "Group: assets imputed ccdebt not"
}


gen group_a=1 if aip==1
replace group_a=2 if aib==1
replace group_a=4 if ais==1
replace group_a=3 if ain==1

label var group_a "Group: assets imputed ccdebt not"
label val group_a group


///////////////////////////////////////////////////////
* ALTERNATIVE DEFINITIONS OF PUZZLE; Note specific assumptions are made about where to put those remove from the puzzle
*(savers vs. borrowers); the neutrals are unchanged
*-----------------------------------------------------------------------------


* >500 credit card, > month of incomel; previous puzzlers redistrituted between borrowers and savers
*-----------------------------------------------------------------------------------------------
bys caseid: egen mfinc9000=mean(rfaminc) if year>=1990 & year<2002
bys caseid: egen mfinc9404=mean(rfaminc) if year>=1994 & year<2006
bys caseid: egen mfinc9808=mean(rfaminc) if year>=1998 & year<2010
bys caseid: egen mfinc0212=mean(rfaminc) if year>=2002 & year<=2012

bys caseid: egen mnw9404=mean(rnw) if year>=1994 & year<2006
bys caseid: egen mnw9808=mean(rnw) if year>=1998 & year<2010
bys caseid: egen mnw0212=mean(rnw) if year>=2002 & year<=2012


gen mfinc=mfinc9404 if year==2004
replace mfinc=mfinc9808 if year==2008
replace mfinc=mfinc0212 if year==2012
replace mfinc=mfinc9000 if year==2000


gen onemonth=1/12*mfinc
gen rliqasset1m=rliqasset-onemonth if !mi(rliqasset,mfinc)
gen rccdebt1m=rccdebt-onemonth if !mi(rccdebt,mfinc)

capture drop p500_1month

gen p500_1month=(rccdebt>=500 &  rliqasset1m>=0) if !mi(rliqasset, rccdebt, mfinc)

gen group_a5001mb=1 if p500_1month==1
replace group_a5001mb=3 if (rccdebt==0 & rliqasset==0) & !mi( p500_1month)  // neutrals are kept the same
replace group_a5001mb=4 if (rccdebt<500 & rliqasset1m>=0 & group_a5001mb==.) & !mi(p500_1month)  // savers
replace group_a5001mb=2 if  group_a5001mb==. & !mi(p500_1month) // borrowers are the rest


*500, 500 for table 2

gen p500500=(rccdebt>=500 & rliqasset>=500) if !mi(rliqasset, rccdebt)
gen group_a500500=1 if p500500==1
replace group_a500500=3 if (rccdebt==0 & rliqasset==0) & !mi(p500500)
replace group_a500500=4 if (rccdebt<500 & rliqasset>=500& group_a500500==.) & !mi(p500500)
replace group_a500500=2 if group_a500500==. & !mi(p500500)



*THIS IS FOR THE TRANSITION MATRICES

local vars "group_a  group_a5001mb"
local times "04 08 12"
foreach x of local vars {

foreach y of local times {
gen `x'`y'm =`x' if year==20`y'
bysort caseid: egen `x'`y' = max(`x'`y'm) if !mi(`x')
drop `x'`y'm
}
lab var `x'04 "2004"
lab var `x'08 "2008"
lab var `x'12 "2012"

}


*TO FIND PEOPLE WHO ARE PERMANENTLY IN A GROUP OVER TIME


local vars "group_a  group_a5001mb"
foreach x of local vars{
forvalues i=1(1)4{
gen diaga`i'=(`x'04==`i' & `x'08==`i' & `x'12==`i')   if !mi(`x'04,`x'08,`x'12)  
}
gen a`x'=diaga1+2*diaga2+3*diaga3+4*diaga4
drop diaga*
}

label define agroups 0 "Switcher" 1 "Puzzle" 2 "Borrower" 3 "Neutral" 4 "Saver"
local vars "a a5001mb"
foreach x of local vars{
label values  agroup_`x' agroups
label var  agroup_`x' "Permanent"
}



*DIVIDE THE PUZZLE GROUP INTO PERSITENT/permanent VS NOT

gen group_p04=group_a04 if year==2004
replace group_p04=0 if group_a04==1 & agroup_a==1 & year==2004

gen group_p08=group_a08 if year==2008
replace group_p08=0 if group_a08==1 & agroup_a==1 & year==2008

gen group_p12=group_a12 if year==2012
replace group_p12=0 if group_a12==1 & agroup_a==1 & year==2012


label define pgroups 0 "Puzzle permanent" 1 "Puzzle other" 2 "Borrower" 3 "Neutral" 4 "Saver"
local vars "04 08 12"
foreach x of local vars{
label values  group_p`x' pgroups
}


