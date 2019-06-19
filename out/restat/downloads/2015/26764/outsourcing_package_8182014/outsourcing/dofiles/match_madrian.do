capture log close
set more off
clear
prog drop _all
global path "/data/nta0/avi/research"
set mem 5000m
log using $masterpath/logfiles/match_madrian.log, replace
**************************************************************************************
* Created by: Shannon Phillips
* Date: November 2008
* Purpose: Longitudinally match CPS respondents following 
* 	    Madrian and Lefgren's "An approach to longitudinally matching Current    	
* 	    Population Survey (CPS) respondents" in JESM. 
* 	    Adapted by Trefler & Liu using:
*		-naive match criteria: hhid, hhnum, lineno
*		-validation criteria: sex, race, age	
*          We additionally use: veteran, marriage, kids	 	        				   		
**************************************************************************************

******************************
* Read in individual workers *
******************************
use $masterpath/datafiles/micro_ind7090
keep year month minsamp hhid hhnum lineno fnlwgt orgwgt age female wbho educ state union agric manuf servs ehf finger dcp sts math ind7090 exper lwage nonwhite man7090 ihwt state occ8090 vet married ownchild

***********************************************************************
* Recode man7090 to eliminate categories not available in the BEA data 
***********************************************************************
gen man7090_orig=man7090
do $masterpath/dofiles/man7090_bea.do
do $masterpath/dofiles/labels_man7090_orig.do

*************************************************************************
* Restrict the sample to years and observations with offshoring measures 
*************************************************************************
drop if year<=1981
do $masterpath/dofiles/keepvars2
save $masterpath/datafiles/micro_ind7090_bea, replace

*************************************************************************************
* Procedure used to longitudinally match CPS respondents
**************************************************************************************
* Step 1.
* Make two data extracts, one for period 1 and one for period 2, both of which
* contain the variables necessary to merge and any additional variables to be used
* in a statistical analysis.
**************************************************************************************
* For a March-to-March merge, respondents
* with a MIS of 1–4 should be included in the period 1 extract, while respondents
* with a MIS of 5–8 should be included in the period 2 extract. Respondents
* with a MIS of 5–8 in period 1 or with a MIS of 1–4 in period 2 can be excluded
* since these respondents are not included in the sampling frame of both surveys.
**************************************************************************************
* Step 2.
* Recode MIS in the period 2 data to correspond to the appropriate value that
* respondents in period 1 would have if they were in both surveys. For March-to-
* March merges, subtract 4 from the period 2 MIS. For a month-to-month merge,
* subtract 1 from the period 2 MIS. Other variables that will be used to determine the
* validity of matches (e.g. sex, race, age, etc.) will need to be given different
* names in the two extracts so that both the period 1 and period 2 values are
* preserved.
**************************************************************************************
* Step 3.
* Sort the period 1 and period 2 data by MIS, HHID, HHNUM and LINENO. For a
* March 1994-to-March 1995 merge, the data must be sorted by MIS, STATE,
* HHID, HHNUM, and LINENO. This would be true for some of the month-to-
* month merges in the 1994–1995 time period as well and results from the
* fact that the CPS only assigns unique household identifiers (HHID) within state
* over part of this time period.
**************************************************************************************
* Step 4.
* Match merge the sorted period 1 and period 2 data extracts on the basis of the variables
* used to sort the data above.
**************************************************************************************
* For issues remaining after merge:
**************************************************************************************
* One problem that may arise (depending on which CPSs are being merged), is the
* presence of multiple post-merge observations with the same identifying variables
* (HHID, HHNUM, LINENO). This occurs because even though HHID, HHNUM
* and LINENO are meant to uniquely identify individuals, in some CPS surveys there
* are multiple respondents who have the same HHID, HHNUM and LINENO. If, for
* example, there are two individuals with the same HHID, HHNUM and LINEO in both
* of the CPS surveys being matched, we will end up with four merged observations.
* Two of the merged observations will be (potentially) correct, and two of them will be
* incorrect. We deal with this issue in a way designed to preserve as many potentially
* correct matches as possible.
**************************************************************************************
* First, we create a unique identifier for all respondents in both period 1 and 2 (these
* identifiers are not unique across period 1 and 2, only within period 1 and 2–we do not merge on
* the basis of these identifiers).
**************************************************************************************
* After merging the period 1 and period 2 data extracts as described
* above, we flag the post-merge observations that do not have a unique value of the
* period 1 and/or period 2 identifiers that we create. 
**************************************************************************************

global list "age wbho nonwhite female fnlwgt orgwgt man7090 man7090_orig exper educ lwage ihwt manuf servs agric union finger sts math dcp ehf occ8090 ind7090 vet minsamp year month married ownchild"
global list_state "age wbho nonwhite female fnlwgt orgwgt man7090 man7090_orig exper educ lwage ihwt manuf servs agric union finger sts math dcp ehf occ8090 ind7090 vet minsamp year month married ownchild state"
**************************************************************************************
* Data extract in period 1. 1994 only.
**************************************************************************************
use $masterpath/datafiles/micro_ind7090_bea, clear
keep if year==1994
keep if minsamp==4

foreach j of global list {
	rename `j' `j'1 
}
gen N1=_n
gen year=year1
gen month=month1
sort state hhid hhnum lineno year month
save $masterpath/datafiles/match_1_1994.dta, replace

**************************************************************************************
* Data extract in period 2. 1995 only.
**************************************************************************************
use $masterpath/datafiles/micro_ind7090_bea, clear
keep if year==1995
keep if minsamp==8

foreach j of global list {
	rename `j' `j'2 
}
gen N2=_n
gen year=year2
gen month=month2
sort state hhid hhnum lineno year month
save $masterpath/datafiles/match_2_1995.dta, replace

**************************************************************************************
* Merge 1994 period 1 data with 1995 period 2 data 
**************************************************************************************
use $masterpath/datafiles/match_1_1994.dta, clear
replace year=year+1
sort state hhid hhnum lineno year month
merge state hhid hhnum lineno year month using $masterpath/datafiles/match_2_1995.dta
keep if _merge==3
drop _merge
gen agediff=age2-age1
gen nragediff=(agediff==-1 | agediff==0 | agediff==1 | agediff==2 | agediff==3)
gen educdiff=educ2-educ1
gen nreducdiff=(educdiff==-1 | educdiff==0 | educdiff==1 | educdiff==2 | educdiff==3)
gen femalediff=female2-female1
gen wbhodiff=wbho2-wbho1
gen lwagediff=lwage2-lwage1

keep if nragediff==1
keep if nreducdiff==1
keep if femalediff==0
keep if wbhodiff==0
keep if lwagediff~=.
drop if hhnum==.
keep if occ80901~=. & occ80902~=. & ind70901~=. & ind70902~=.

gen vetdiff=vet2-vet1
gen marrieddiff=married2-married1
gen ownchilddiff=ownchild2-ownchild1
sort N1
display "Four duplicate period 1 observations: Drop duplicate if veteran status differs"
count if (N1==N1[_n-1]|N1==N1[_n+1]) 
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & vetdiff==1

display "Two duplicate period 1 observations: One has consistent occupation across periods, drop the other"
count if (N1==N1[_n-1]|N1==N1[_n+1]) 
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & educdiff==1 & occ80901~=occ80902 & (occ80901[_n-1]==occ80902[_n-1] | occ80901[_n+1]==occ80902[_n+1])
assert N1~=N1[_n-1] 

sort N2
display "Four duplicate period 2 observations: Drop duplicate if veteran status differs"
count if (N2==N2[_n-1]| N2==N2[_n+1]) 
drop if (N2==N2[_n-1]| N2==N2[_n+1]) & vetdiff==-1

display "Two duplicate period 2 observations: One has consistent occupation across periods, drop the other"
count if (N2==N2[_n-1]| N2==N2[_n+1]) 
drop if (N2==N2[_n-1]| N2==N2[_n+1]) & occ80901~=occ80902 & (occ80901[_n-1]==occ80902[_n-1] | occ80901[_n+1]==occ80902[_n+1])
assert N2~=N2[_n-1] 

drop N1 N2
sort hhid hhnum lineno year month
save $masterpath/datafiles/match_madrian_9495.dta, replace
**************************************************************************************

**************************************************************************************
* Data extract in period 1. Non-1994. 
**************************************************************************************
use $masterpath/datafiles/micro_ind7090_bea, clear
keep if year~=1994
keep if minsamp==4

foreach j of global list_state {
	rename `j' `j'1 
}
gen year=year1
gen month=month1
gen N1=_n
sort hhid hhnum lineno year month
save $masterpath/datafiles/match_1.dta, replace

**************************************************************************************
* Data extract in period 2. Non-1995.
**************************************************************************************
use $masterpath/datafiles/micro_ind7090_bea, clear
keep if year~=1995
keep if minsamp==8

foreach j of global list_state {
	rename `j' `j'2 
}
gen year=year2
gen month=month2
gen N2=_n
sort hhid hhnum lineno year month
save $masterpath/datafiles/match_2.dta, replace

**************************************************************************************
* Merge non-1994 period 1 data with non-1995 period 2 data 
**************************************************************************************
use $masterpath/datafiles/match_1.dta, clear
replace year=year+1
sort hhid hhnum lineno year month
merge hhid hhnum lineno year month using $masterpath/datafiles/match_2.dta
keep if _merge==3
drop _merge
gen agediff=age2-age1
gen nragediff=(agediff==-1 | agediff==0 | agediff==1 | agediff==2 | agediff==3)
gen educdiff=educ2-educ1
gen nreducdiff=(educdiff==-1 | educdiff==0 | educdiff==1 | educdiff==2 | educdiff==3)
gen femalediff=female2-female1
gen wbhodiff=wbho2-wbho1
gen lwagediff=lwage2-lwage1

keep if nragediff==1
keep if nreducdiff==1
keep if femalediff==0
keep if wbhodiff==0
keep if lwagediff~=.
drop if hhnum==.
keep if occ80901~=. & occ80902~=. & ind70901~=. & ind70902~=.

gen vetdiff=vet2-vet1
gen marrieddiff=married2-married1
gen monthdiff=month2-month1
gen ownchilddiff=ownchild2-ownchild1
gen uniondiff=union2-union1
sort N1
display "64 duplicate period 1 observations: Delete 10 duplicates w/age diff=-1, 2, or 3"
count if (N1==N1[_n-1]|N1==N1[_n+1]) 
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & (agediff==-1 | agediff==2 | agediff==3)

display "44 duplicate period 1 observations: Delete 2 duplicates w/educ diff=-1, 2, or 3"
count if (N1==N1[_n-1]|N1==N1[_n+1]) 
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & (educdiff==-1 | educdiff==2 | educdiff==3)

display "40 duplicate period 1 observations: Delete 12 duplicates w/kid diff=-1, 3, or 4"
count if (N1==N1[_n-1]|N1==N1[_n+1]) 
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & (ownchilddiff==-1 | ownchilddiff==3 | ownchilddiff==4)

display "28 duplicate period 1 observations: Delete 1 duplicate w/different marital status"
count if (N1==N1[_n-1]|N1==N1[_n+1]) 
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & marrieddiff==1

display "26 duplicate period 1 observations: Six have consistent occupation across periods, drop the other duplicate"
count if (N1==N1[_n-1]|N1==N1[_n+1]) & occ80901~=occ80902 & ((occ80901[_n-1]==occ80902[_n-1] & N1==N1[_n-1]) | (occ80901[_n+1]==occ80902[_n+1] & N1==N1[_n+1]))
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & occ80901~=occ80902 & ((occ80901[_n-1]==occ80902[_n-1] & N1==N1[_n-1]) | (occ80901[_n+1]==occ80902[_n+1] & N1==N1[_n+1]))

display "14 duplicate period 1 observations: Two have consistent industry across periods, drop the other duplicate"
count if (N1==N1[_n-1]|N1==N1[_n+1]) & ind70901~=ind70902 & ((ind70901[_n-1]==ind70902[_n-1] & N1==N1[_n-1]) | (ind70901[_n+1]==ind70902[_n+1] & N1==N1[_n+1]))
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & ind70901~=ind70902 & ((ind70901[_n-1]==ind70902[_n-1] & N1==N1[_n-1]) | (ind70901[_n+1]==ind70902[_n+1] & N1==N1[_n+1]))

display "Ten duplicate period 1 observations: Two match on age, educ, kids, marriage, occ, ind, but differ on union. Drop where union differs"
count if (N1==N1[_n-1]|N1==N1[_n+1]) 
drop if (N1==N1[_n-1]|N1==N1[_n+1]) & uniondiff==1

display "Eight duplicate period 1 observations: Drop 2nd of each pair of duplicates"
count if (N1==N1[_n-1]|N1==N1[_n+1]) 
drop if N1==N1[_n-1]

assert N1~=N1[_n-1] 

sort N2
display "74 duplicate period 2 observations: Delete 13 duplicates w/age diff=-1, 2, or 3"
count if (N2==N2[_n-1]| N2==N2[_n+1]) 
drop if (N2==N2[_n-1]|N2==N2[_n+1]) & (agediff==-1 | agediff==2 | agediff==3)

display "48 duplicate period 2 observations: Delete 5 duplicates w/educ diff=-1, 2, or 3"
count if (N2==N2[_n-1]| N2==N2[_n+1]) 
drop if (N2==N2[_n-1]|N2==N2[_n+1]) & (educdiff==-1 | educdiff==2 | educdiff==3)

display "38 duplicate period 2 observations: Delete 2 duplicates w/kid diff=-1"
count if (N2==N2[_n-1]| N2==N2[_n+1]) 
drop if (N2==N2[_n-1]|N2==N2[_n+1]) & ownchilddiff==-1 

display "36 duplicate period 2 observations: Delete 0 duplicate w/different marital status"
count if (N2==N2[_n-1]| N2==N2[_n+1]) 
drop if (N2==N2[_n-1]|N2==N2[_n+1]) & marrieddiff==1

display "36 duplicate period 2 observations: Eight have consistent occupation across periods, drop the other duplicate"
count if (N2==N2[_n-1]|N2==N2[_n+1]) & occ80901~=occ80902 & ((occ80901[_n-1]==occ80902[_n-1] & N2==N2[_n-1]) | (occ80901[_n+1]==occ80902[_n+1] & N2==N2[_n+1]))
drop if (N2==N2[_n-1]|N2==N2[_n+1]) & occ80901~=occ80902 & ((occ80901[_n-1]==occ80902[_n-1] & N2==N2[_n-1]) | (occ80901[_n+1]==occ80902[_n+1] & N2==N2[_n+1]))

display "20 duplicate period 2 observations: Seven have consistent industry across periods, drop the other duplicate"
count if (N2==N2[_n-1]|N2==N2[_n+1]) & ind70901~=ind70902 & ((ind70901[_n-1]==ind70902[_n-1] & N2==N2[_n-1]) | (ind70901[_n+1]==ind70902[_n+1] & N2==N2[_n+1]))
drop if (N2==N2[_n-1]|N2==N2[_n+1]) & ind70901~=ind70902 & ((ind70901[_n-1]==ind70902[_n-1] & N2==N2[_n-1]) | (ind70901[_n+1]==ind70902[_n+1] & N2==N2[_n+1]))

display "Six duplicate period 2 observations: Drop where no age increment when duplicate has one"
count if (N2==N2[_n-1]| N2==N2[_n+1]) 
drop if (N2==N2[_n-1]|N2==N2[_n+1]) & agediff==0

display "Four duplicate period 2 observations: Drop 2nd of each pair of duplicates"
count if (N2==N2[_n-1]| N2==N2[_n+1]) 
drop if N2==N2[_n-1]

assert N2~=N2[_n-1] 
drop N1 N2
save $masterpath/datafiles/match_madrian_no9495.dta, replace

**************************************************************************************
* Append March 1994-to-March 1995 merged data with non 1994-1995 merged data
**************************************************************************************
use $masterpath/datafiles/match_madrian_no9495.dta, clear
append using $masterpath/datafiles/match_madrian_9495.dta

gen leftmfg=(manuf1==1 & manuf2==0) 
gen switchind=ind70902~=ind70901
gen switchocc=occ80902~=occ80901

gen sameind=ind70901==ind70902
gen sameocc=occ80901==occ80902
gen sameman=man70901==man70902 if man70901~=.

gen sameagr=agric1==agric2
gen samemfg=manuf1==manuf2
gen samesvs=servs1==servs2

**********************************************************************
* Create measure of routineness of task
**********************************************************************
gen routine1=(finger1 + sts1)/(finger1 + sts1 + math1 + dcp1 + ehf1)
label variable routine1 "Routineness of task in period 1:(finger+sts)/(finger+sts+math+dcp+ehf)"

gen routine2=(finger2 + sts2)/(finger2 + sts2 + math2 + dcp2 + ehf2)
label variable routine2 "Routineness of task in period 2:(finger+sts)/(finger+sts+math+dcp+ehf)"

********************************
gen agecorrect=(agediff==0 | agediff==1)
gen educorrect=(educdiff==0 | educdiff==1)
gen kidscorrect=(ownchild1==ownchild2 | ownchild2==ownchild1+1) if ownchild1~=. 
gen marriedcorrect=(married1==married2)

gen match1=(agecorrect==1 & educorrect==1 & marriedcorrect==1 & kidscorrect==1)
gen match2=(agecorrect==1 & educorrect==1 & marriedcorrect==1)
gen match3=(agecorrect==1 & educorrect==1)
gen match4=1
label variable match1 "Strictest matches: Strict on Age, Educ, Marriage, Kids"
label variable match2 "Strict matches: Strict on Age, Educ, Marriage"
label variable match3 "Loose matches: Strict on Age, Educ"
label variable match4 "Loosest matches: Loose on Age, Educ"
********************************

save $masterpath/datafiles/match_madrian_wide, replace

global list1 "age wbho nonwhite female fnlwgt orgwgt man7090 man7090_orig exper educ lwage ihwt manuf servs agric union finger sts math dcp ehf occ8090 ind7090 vet minsamp year month married ownchild state routine"
gen pid=_n
drop state hhid hhnum lineno year month 
sort pid 
reshape long $list1, i(pid) j(period)
xtset pid period
sort pid period

sort man7090_orig educ year
save $masterpath/datafiles/match_madrian_long.dta, replace
label data "Matched CPS data, 1984-2002"

erase $masterpath/datafiles/match_1.dta 
erase $masterpath/datafiles/match_1_1994.dta 
erase $masterpath/datafiles/match_2.dta 
erase $masterpath/datafiles/match_2_1995.dta   
erase $masterpath/datafiles/match_madrian_no9495.dta 
erase $masterpath/datafiles/match_madrian_9495.dta
erase $masterpath/datafiles/micro_ind7090_bea.dta

*************************************
use $masterpath/datafiles/merge_educ_man7090.dta
sort man7090_orig year
merge man7090_orig year using $masterpath/trade/net_export_prices.dta
drop _merge
sort man7090_orig year 
keep if year>=1982

replace lowincemp=1 if lowincemp==0
gen llowincemp=log(lowincemp)
gen lhigh=log(highincemp)

keep year man7090_orig piinv79 tfp579 px pm expmod79 penmod79 lowincemp highincemp rpiship79 cap79 labor79
collapse piinv79 tfp579 px pm expmod79 penmod79 lowincemp highincemp rpiship79, by(man7090_orig year)

gen piinv79_100=piinv79*100
gen lpiinv79=log(piinv79_100)
gen lpx=log(px)
gen lpm=log(pm)
gen tot=lpx-lpm
gen llowincemp=log(lowincemp)
gen lhigh=log(highincemp)
gen lrpiship79=log(rpiship79)

sort man7090_orig year
by man7090_orig: gen lpiinv79diff=lpiinv79-lpiinv79[_n-1]
by man7090_orig: gen tfp579diff=tfp579-tfp579[_n-1]
by man7090_orig: gen totdiff=tot-tot[_n-1]
by man7090_orig: gen expmod79diff=expmod79-expmod79[_n-1]
by man7090_orig: gen penmod79diff=penmod79-penmod79[_n-1]
by man7090_orig: gen llowincempdiff=llowincemp-llowincemp[_n-1]
by man7090_orig: gen lhighdiff=lhigh-lhigh[_n-1]

label variable piinv79_100 "Real price of investment at 1979 weights * 100"
label variable lpiinv79 "Log(real price of investment at 1979 weights * 100)"
label variable lpx "Log(price exports at t)"
label variable lpm "Log(price imports at t)"
label variable tot "Terms of trade at t: lpx-lpm"
label variable lpiinv79diff "Change in log(real price of investment at 1979 weights * 100) b/w t and t-1"
label variable tfp579diff "Change in Total Factor Productivity at 1979 weights b/w t and t-1"
label variable totdiff "Change in terms of trade (lpx-lpm) b/w t and t-1"
label variable expmod79diff "Change in Exports/Shipments at 1979 weights b/w t and t-1"
label variable penmod79diff "Change in Imports/(Imports+Production) at 1979 weights b/w t and t-1"
label variable llowincemp "Log total employment in low income countries, including China"
label variable lhigh "Log total employment in high income countries"
label variable llowincempdiff "Change in log employment in low income countries b/w t and t-1"
label variable lhighdiff "Change in log employment in high income countries at 1979 weights b/w t and t-1"
label variable lrpiship79 "Log of real price of shipments using 1979 weights"

keep man7090_orig year lpiinv79diff tfp579diff totdiff expmod79diff penmod79diff lowincemp highincemp llowincempdiff lhighdiff lpiinv79 tfp579 expmod79 penmod79 llowincemp lhigh lrpiship79 

rename man7090_orig man7090_orig1
rename year year1

sort man7090_orig1 year1
save $masterpath/datafiles/diff.dta, replace
*************************************
use $masterpath/datafiles/offshore_exposure, clear
collapse *_effective *_effective_occ, by(occ8090 year)
gen Dvsh_effective=vsh_effective-p_vsh_effective_occ
gen Dexpmod_effective=expmod_effective-p_expmod_effective_occ
gen Dpenmod_effective=penmod_effective-p_penmod_effective_occ
gen Dllowincemp_effective=llowincemp_effective-p_llowincemp_effective_occ
gen Dlhigh_effective=lhigh_effective-p_lhigh_effective_occ
gen Dlowincemp_effective=lowincemp_effective-p_lowincemp_effective_occ
gen Dhighincemp_effective=highincemp_effective-p_highincemp_effective_occ

rename occ8090 occ80901
rename year year1

sort occ80901 year1
save $masterpath/datafiles/occ8090_diff.dta, replace
*************************************

use $masterpath/datafiles/match_madrian_wide, clear
sort man7090_orig1 year1
merge man7090_orig1 year1 using $masterpath/datafiles/diff.dta
tab _merge
drop if _merge==2
drop _merge

sort occ80901 year1
merge occ80901 year1 using $masterpath/datafiles/occ8090_diff.dta
tab _merge
drop if _merge==2
drop _merge
save $masterpath/datafiles/switchers.dta, replace

log close
exit
