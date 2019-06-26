clear
set more off
cd "`w_dir'"
import excel "55145_UCDP_Dyadic_Dataset_v_1.0__1946-2007.xls", sheet("Blad1") firstrow

*check if multiple dyad-year observations
sort YEAR
sort DyadID, stable
gen flag=1 if YEAR[_n]==YEAR[_n-1]
drop if YEAR==1946 & DyadID==260 & ConflictID==7
drop flag
xtset DyadID YEAR

*mark years with "war"-intensity except if "war" happened in first year
gen war=1 if Int==2
replace war=1 if L.war==1
by DyadID: gen firstob=1 if _n==1
replace war=0 if war==1 & firstob==1
/*
errors in MILC Appendix A list of countries compared to UCDP-Dyadic
-Burundi Palipehutu escalated to war in 2001
-Liberia MODEL is not included in MILC
-Niger FARS is no conflict in 1998
-Sierra Leone WSB is not included in MILC
-Sudan SLM/A is a conflict in 2004
-Sudan NDA is not included in MILC
-Uganda UDCA/LRA is not included in MILC
*/

*keep only intrastate conflicts
gen keep=1 if Type==4
replace keep=1 if Type==3
keep if keep==1

*keep only cases which correspond to MILC case selection
drop if war==1
keep if YEAR<2005
drop if YEAR<1993
sort YEAR
sort Loca, stable

*code Egypt as part of Africa
replace Region=4 if Location=="Egypt"

*drop all non-African cases
drop if Region!=4

*gen unique dyad id 
gen dyad_unique = DyadID + 10000

*rename vars to correpond to other datasets
rename YEAR year
renam Location location
rename SideB sideb
rename Incomp incomp

*create sample identifier
gen sampleid = 1

*prepare for merging with other data
keep dyad_unique year location sideb sampleid incomp
sort year
sort dyad_unique, stable

*save dataset
save sampleselection.dta, replace
