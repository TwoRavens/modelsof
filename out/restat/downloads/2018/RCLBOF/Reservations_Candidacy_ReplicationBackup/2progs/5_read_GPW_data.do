************************************************************************
***************SETUP CODE HEADER FOR ALL PROGRAMS***********************
***************									 ***********************
************************************************************************
clear
clear matrix
clear mata
cap log close

global root ~/dropbox/Reservations_Candidacy_ReplicationBackup
include "$root/2progs/00_Set_paths.do"
************************************************************************
************************************************************************
insheet using "$data/ind_gpwv3_pcount_ascii_25/indp00ag.asc", nonames clear
count
keep if _n<7
replace v1=subinstr(v1,"       "," ",.)
replace v1=subinstr(v1,"      "," ",.)
replace v1=subinstr(v1,"    "," ",.)
replace v1=subinstr(v1,"   "," ",.)
replace v1=subinstr(v1,"  "," ",.)
split v1, p(" ")
drop v1
renvars v11 v12 \ info value
destring value, replace
sum value if info=="xllcorner"
local Xstart = `r(mean)'
sum value if info=="yllcorner"
local Ystart = `r(mean)'
//note that  "cellsize"==2.5/60

clear
infix str vals 1-10000  using ///
"$data/ind_gpwv3_pcount_ascii_25/indp00ag.asc" in 7/822
g Yindex=abs(_N-_n)
g Yval = `Ystart' + Yindex*(2.5/60)
sum Yval, d
drop Yindex
split vals, p(" ")
drop vals
destring _all, replace

reshape long vals, i(Yval) j(Xindex)
g Xval = `Xstart' + (Xindex-1)*(2.5/60)
sum Xval, d
drop Xindex
order Xval Yval
count
drop if vals==0
count

outsheet using population_count_grid_GPW_adj.csv, comma names replace
