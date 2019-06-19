clear

version 11
cap log close
set more off
set matsize 800

* in the following line, specify the directory in which the data and do files are saved
cd "C:\set_your_own_directory_here"


***************************************************
**    baseline differences (Table 1 top panel)   **
***************************************************

u "MS15162_baseline data.dta", clear

* individual (current and temporary mig.)
xi: reg  migUS_97 treatp , robust cl(village)
xi: reg  t_migUS_97 treatp , robust cl(village)

* control group means:
su migUS_97 if treatp==0
su t_migUS_97 if treatp==0

* household with at least one mig. (current and temporary mig.)
xi: reg  mighhUS_d_97 treatp if tag==1, robust cl(village)
xi: reg  t_mighhUS_d_97 treatp if tag==1, robust cl(village)

* control group means:
su mighhUS_d_97 if treatp==0 & tag==1
su t_mighhUS_d_97 if treatp==0 & tag==1


***************************************************
** 1998 ATE (Table 1 middle and bottom panels)   **
***************************************************


u "MS15162_endline data.dta", clear

xi: reg migUS  treatp t_mighhUS_97 mighhUS_97 age* female i.educb isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region, robust cl(village)
bys treatp:su migUS

xi: reg mighhUd  treatp t_mighhUS_97 mighhUS_97 isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region if tag==1, robust cl(village)
bys treatp:su mighhUd

xi: reg migMX t_mighhUS_97 mighhUS_97 treatp age* female i.educb isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region, robust cl(village)
bys treatp:su migMX



***************************************************
**                    Table 2                    **
***************************************************


foreach x in what {
xtile w3p=`x' if treatp!=. & childpr!=1,nq(3)

char w3p[omit] 1
xi: reg migUS  i.treatp*i.w3p t_mighhUS_97 mighhUS_97 isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region if childpr!=1, robust cl(village)
testparm _Itrea _ItreXw3p_1_2
testparm _Itrea _ItreXw3p_1_3
lincom _Itrea + _ItreXw3p_1_2
lincom _Itrea+  _ItreXw3p_1_3

forvalues i=1/3 {
su migUS if treatp==0 & w3p==`i' & childpr!=1
}
drop w3p
}



***************************************************
**                    Table 3                    **
***************************************************

g loanmig=0 if migUS!=.
replace loanmig=1 if migUS==1 & loand==1

g noloanmig=0 if migUS!=.
replace noloanmig=1 if migUS==1 & loand==0

ta treatp loanm, row
egen hh_loanmig=sum(loanmig), by(folio)
ta hh_loan
replace hh_loan=1 if hh_loan>1 & hh_loan!=.

ta treatp noloanm, row
egen hh_noloanmig=sum(loanmig), by(folio)
ta hh_noloan
replace hh_noloan=1 if hh_noloan>1 & hh_noloan!=.

* each regression is one column, cols. 1-11

xi: reg loand treatp  t_mighhUS_97 mighhUS_97 age* female i.educb isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region, robust cl(village)
bys treatp:su loand

xi: reg loanq treatp t_mighhUS_97 mighhUS_97  age* female i.educb isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region if loanq>50 & loanq<5000, robust cl(village)
bys treatp:su loanq  if loanq>50 & loanq<5000


xtile w3p=what if treatp!=.,nq(3)
forvalues i=1/3 {
xi: reg loanq treatp t_mighhUS_97 mighhUS_97  isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region if loanq>50 & loanq<5000 & w3p==`i', robust cl(village)
bys treatp:su loanq  if loanq>50 & loanq<5000 & w3p==`i'
}

xi: reg loand treatp t_mighhUS_97 mighhUS_97 isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region if tag==1, robust cl(village)
bys treatp:su loand if tag==1

xi: reg loanq treatp t_mighhUS_97 mighhUS_97 isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region if tag==1 & loanq>50 & loanq<5000, robust cl(village)
bys treatp:su loanq  if loanq>50 & loanq<5000 & tag==1

xi: reg loanm treatp  t_mighhUS_97 mighhUS_97 age* female i.educb isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region, robust cl(village)
bys treatp:su loanm

xi: reg noloanm treatp  t_mighhUS_97 mighhUS_97 age* female i.educb isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region, robust cl(village)
bys treatp:su noloanm

reg loanq treatp if migUS==1 & loanq>50 & loanq<5000, cl(village)

reg loanq treatp if migUS==0 & loanq>50 & loanq<5000, cl(village)

xi: reg hh_loan treatp t_mighhUS_97 mighhUS_97 isolated netwealth shock network_shock hhhage hhhsex hhtrpr hhtrse  hhhindigenous hhhalpha indice hhsize07 hhsize814 hhsize1518 hhsize1921 hhsize22 hect_riego_d hect_temporal_d yycali i.region if tag==1, robust cl(village)
bys treatp:su hh_loan if tag==1




***************************************************
**                  Figure 1                     **
***************************************************


twoway kdensity what if treatp==0  &  childpr!=1 & migUS==0 & what>83 & what<358, gaus xti(Predicted wages for eligible households) yti(density) lwidth(medthick) legen(label(1 "Control (m=0)")) lpa(l) lc(gs14) fc(none) ||   kdensity what if treatp==0  &  childpr!=1 & migUS==1 & what>83 & what<358, gaus xti(Predicted wages for eligible households) yti(density) lwidth(medthick) legen(label(2 "Control (m=1)")) lpa(-) lc(gs10) fc(none) ||  kdensity what if treatp==1  &  childpr!=1 & migUS==1 & what>83 & what<358, gaus lwidth(medthick) legen(label(3 "Treatment (m=1)") pos(1) col(1) ring(0))  lpa(._) lc(gs0) fc(none)


log close




