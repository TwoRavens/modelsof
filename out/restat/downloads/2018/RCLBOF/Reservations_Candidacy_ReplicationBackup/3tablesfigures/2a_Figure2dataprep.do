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

use "$data/20110220_IMMT_ReplicationData/table10a.dta", clear
gsort state dist1988 +year
keep state dist1988 year wdistres
keep if year>=1995
replace wdistres = 0 if mi(wdistres)
reshape wide  wdistres, i(state dist) j(year)
g count = 1

foreach var of varlist wdistres* {
replace `var' = 0 if mi(`var')
replace `var' = 1 if `var' >0 & `var'<1
}
order state count

gsort state -wdistres1995 -wdistres1996 -wdistres1997 -wdistres1998 -wdistres1999 -wdistres2000
g index = _n

reshape long wdistres, i(state index count dist) j(year)

gsort state index +year
keep state  index year wdistres count dist
g type = ""
replace type = "start" if wdistres>0 & !mi(wdistres) & wdistres[_n-1] ==0 & index == index[_n-1]
replace type = "start" if wdistres>0 & !mi(wdistres) & year==1995
replace type = "end" if wdistres>0 & !mi(wdistres) & wdistres[_n+1] ==0 & index == index[_n+1]
replace type = "end" if wdistres>0 & !mi(wdistres) & year==2007
replace type = "start_end" if wdistres>0 & !mi(wdistres) & wdistres[_n-1]==0  & wdistres[_n+1]==0 & index == index[_n-1] & index == index[_n+1]
replace type = "start_end" if wdistres>0 & !mi(wdistres) & wdistres[_n-1]==0  & year==2007 & index == index[_n-1]

//get the never nevers here
bys state index: egen ever = sum(wdistres)
replace type="never_never" if ever==0
drop ever
drop if type=="" | (type=="never_never" & (year!=1995))
keep state index type year count dist
gsort state index count type +year
bys state state index count type: g rank2=_n

reshape wide year, i(state dist index count rank2) j(type) string
replace yearstart = yearstart_end if mi(yearstart) & !mi(yearstart_end)
replace yearend = yearstart_end if mi(yearend) & !mi(yearstart_end)
replace yearstart = 1995 if mi(yearstart) & !mi(yearnever_never)
replace yearend = 2007 if mi(yearend) & !mi(yearnever_never)
g type = "never" if !mi(yearnever_never)
drop  yearstart_end yearnever_never

rename count n
rename yearstart start
rename yearend end
g north = 1
replace north = 1 if state=="RAJASTHAN"
replace north = 2 if state=="HARYANA"
replace north = 3 if state=="PUNJAB"
replace north = 4 if state=="GUJARAT"
replace north = 5 if state=="BIHAR"
replace north = 6 if state=="ORISSA"
replace north = 7 if state=="MAHARASHTRA"
replace north = 8 if state=="ANDHRA PRADESH"
replace north = 9 if state=="KERALA"
replace north = 10 if state=="WEST BENGAL"
rename index areaindex

replace end = end+1
gsort -north state type -start -end
g index=_n
gsort -north state +dist
bys areaindex: g rank= _N
replace index =index[_n-1] if rank>1 & areaindex==areaindex[_n-1]
drop areaindex
gsort +index
replace index = _n
rename index areaindex

replace start = . if type=="never"
bys state: egen minstart = min(start)
replace start = minstart if type=="never"
drop minstart
gsort -north state -dist
replace areaindex=_n
outsheet using "$work/leadership_resv_timeline_long_new.csv", comma replace
