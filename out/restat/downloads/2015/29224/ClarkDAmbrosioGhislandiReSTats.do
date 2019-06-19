
*-----------------
* Create main dataset
*----------------------

use "C:\Private\Dati\SOEP\SoepLong\SOEPlongv29\pkal.dta"
keep hid pid syear kal1d02
save "C:\Private\Ricerca\2012\PersistPov\May2013\dapkal.dta", replace

use "C:\Private\Dati\SOEP\SoepLong\SOEPlongv29\pequiv.dta"
keep if d11101>=16
keep hid pid syear i11102 p11101 d11102ll d11101 d11104 d11106 d11108 d11109 d11107 e11102 y11101 w11102 l11101 l11102 m11126 m11124 d11106 d11107
gen ey=i11102/sqrt(d11106)
ren w11102 weight
merge 1:1 syear hid pid using C:\Private\Ricerca\2012\PersistPov\May2013\dapkal.dta
keep if _merge==3
drop _merge
save "C:\Private\Ricerca\2012\PersistPov\May2013\dapequiv.dta", replace

use "C:\Private\Dati\SOEP\SoepLong\SOEPlongv29\pl.dta"
keep hid pid syear plb0025 pld0159 plh0171 plh0173 plh0177 plh0175
merge 1:1 syear hid pid using C:\Private\Ricerca\2012\PersistPov\May2013\dapequiv.dta
keep if _merge==3
drop _merge
save "C:\Private\Ricerca\2012\PersistPov\May2013\dapequivpl.dta", replace

use "C:\Private\Dati\SOEP\SoepLong\SOEPlongv29\pgen.dta"
keep hid pid syear pglfs pgemplst
merge 1:1 syear hid pid using C:\Private\Ricerca\2012\PersistPov\May2013\dapequivpl.dta
keep if _merge==3
drop _merge
save "C:\Private\Ricerca\2012\PersistPov\May2013\dapequivplpgen.dta", replace

use "C:\Private\Dati\SOEP\SoepLong\SOEPlongv29\hgen.dta"
keep hid syear hgtyp1hh
merge 1:m syear hid using C:\Private\Ricerca\2012\PersistPov\May2013\dapequivplpgen.dta
keep if _merge==3
drop _merge
label var hgtyp1hh "household type"
save "C:\Private\Ricerca\2012\PersistPov\May2013\dapequivplpgenhgen.dta", replace


use "C:\Private\Dati\SOEP\SoepLong\SOEPlongv29\hl.dta"
keep hid syear hlf0001 hlf0105 hlf0114 hlf0115
merge 1:m syear hid using C:\Private\Ricerca\2012\PersistPov\May2013\dapequivplpgenhgen.dta
keep if _merge==3
drop _merge
label var hlf0105 "lived here one year ago"
label var hlf0114 "why changed: separated"
label var hlf0115 "why changed: left parent house"
label var plh0171 "satisfaction with health"
label var plh0173 "satisfaction with work"
label var plh0177 "satisfaction with dwelling"
label var plh0175 "satisfaction with household income"
save "C:\Private\Ricerca\2012\PersistPov\Nov2013\baseRestat.dta", replace


*-----------------
* Create and name main variables
*----------------------

rename d11101 age
gen ageg1=age<=20
gen ageg2=(age>20&age<=30)
gen ageg3=(age>30&age<=40)
gen ageg4=(age>40&age<=50)
gen ageg5=(age>50&age<=60)
gen ageg6=(age>60&age<=70)
gen ageg7=(age>70&age<=80)
gen ageg8=(age>80)
gen sex= d11102ll==1
mvdecode d11104, mv(-1)
qui ta d11104, g(mar)
gen region= l11102==2
gen child= d11107
mvdecode d11109, mv(-1 -2)
gen yeduc=d11109
mvdecode pglfs, mv(-1)
*employment: 1=employed; 2=unemployed; 3=retired; 4=inactive
recode pglfs 11 12=1 6=2 2=3 1 3 4 5 7/10=4, gen(employment)
gen  owner=hlf0001==3
replace owner=. if hlf0001<0
gen ill=(plb0025==1|plb0025==2)  /*Only for the employed. Here I would interpret the -8 as no-ill*/
rename p11101 satlife
replace satlife=. if satlife<0
rename syear year
rename  y11101  cpi
gen emplst=e11102==1
ren l11101 bula
mvdecode bula, mv(-1)
tsset pid year
mvdecode d11108, mv(-1)
qui ta d11108, g(education)
mvdecode m11124, mv(-1)
rename m11124 disability
gen income=ey
global iir "ageg1-ageg3 ageg5-ageg8 sex education2 education3 mar2 mar3 mar4 mar5 region child"
capture drop N
bysort pid: gen N=_N
capture drop grp
egen grp=group(hid year)
capture drop povline
g povline = 0
 forvalues i = 1984/2012  { 
       qui summarize ey  [aw=weight] if year== `i', detail 
       replace povline = 0.6*(r(p50)) if year== `i'  
 } 
capture drop g0
 qui gen g0= (ey<povline) if ey < .
  capture drop g1
 qui gen g1=((povline-ey)/povline)
 replace g1=0 if g0==0
drop if year==1984


*---------------
* TAB 2
*----------------
/*All*/
xi: xtreg  satlife g0 g1  i.year i.employment $iir, fe vce(cluster grp) nonest
/*Men*/
xi: xtreg  satlife g0 g1   i.year i.employment $iir if sex==1, fe vce(cluster grp) nonest
/*Women*/
 xi: xtreg  satlife g0 g1   i.year i.employment $iir   if sex==0, fe vce(cluster grp) nonest


*---------------
* TAB 3
*----------------

capture drop poventry
g poventry=(g0==1 & l1.g0==0) if g0<. & l1.g0<.
sort pid year
capture drop runsumpov
by pid: gen runsumpov=sum(poventry)
capture drop povfirstobs
by pid: g povfirstobs=g0[1]==1

cap prog drop makedur
prog def makedur
for any 01 12 23 34 45 5o: g `1'Xy=0 if `2'==0
replace `1'01y=. if `2'==1 & `1'entry==.
replace `1'12y=. if `2'==1 & (`1'entry==. | l1.`1'entry==.)
replace `1'23y=. if `2'==1 & (`1'entry==. | l1.`1'entry==. | l2.`1'entry==.)
replace `1'34y=. if `2'==1 & (`1'entry==. | l1.`1'entry==. | l2.`1'entry==. | l3.`1'entry==.)
replace `1'45y=. if `2'==1 & (`1'entry==. | l1.`1'entry==. | l2.`1'entry==. | l3.`1'entry==. | l4.`1'entry==.)
replace `1'5oy=. if `2'==1 & (`1'entry==. | l1.`1'entry==. | l2.`1'entry==. | l3.`1'entry==. | l4.`1'entry==.)
replace `1'01y=1 if `2'==1 & `1'entry==1
replace `1'12y=1 if `2'==1 & l1.`2'==1 & `1'entry==0 & l1.`1'entry==1
replace `1'23y=1 if `2'==1 & l1.`2'==1 & l2.`2'==1 & `1'entry==0 & l1.`1'entry==0 & l2.`1'entry==1
replace `1'34y=1 if `2'==1 & l1.`2'==1 & l2.`2'==1 & l3.`2'==1 & `1'entry==0 & l1.`1'entry==0 & l2.`1'entry==0 & l3.`1'entry==1
replace `1'45y=1 if `2'==1 & l1.`2'==1 & l2.`2'==1 & l3.`2'==1 & l4.`2'==1 & `1'entry==0 & l1.`1'entry==0 & l2.`1'entry==0 & l3.`1'entry==0 & l4.`1'entry==1
replace `1'5oy=1 if `2'==1 & l1.`2'==1 & l2.`2'==1 & l3.`2'==1 & l4.`2'==1 & l5.`2'==1 & `1'entry==0 & l1.`1'entry==0 & l2.`1'entry==0 & l3.`1'entry==0 & l4.`1'entry==0
for any 12 23 34 45 5o: replace `1'Xy=0 if `1'01y==1
for any 01 23 34 45 5o: replace `1'Xy=0 if `1'12y==1
for any 01 12 34 45 5o: replace `1'Xy=0 if `1'23y==1
for any 01 12 23 45 5o: replace `1'Xy=0 if `1'34y==1
for any 01 12 23 34 5o: replace `1'Xy=0 if `1'45y==1
for any 01 12 23 34 45: replace `1'Xy=0 if `1'5oy==1
end

capture drop pov01y pov12y pov23y pov34y pov45y pov5oy
for any pov \ var g0: makedur X Y

/*All sample*/
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if runsumpov < 2 & povfirstobs==0,fe vce(cluster grp) nonest
/*Men*/
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if runsumpov < 2 & povfirstobs==0 & sex==1,fe vce(cluster grp) nonest
/*Women*/
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if runsumpov < 2 & povfirstobs==0 & sex==0,fe vce(cluster grp) nonest


*---------------
* TAB 4
*----------------

sort pid year
capture drop povyrgap
by pid: g byte povyrgap=year!=l1.year+1 & _n!=1 & g0==1
capture drop runsumyrgap
by pid: g runsumyrgap=sum(povyrgap)
capture drop g0_1
gen g0_1=g0*(runsumpov==1)*(runsumyrgap==0)
capture drop sumpovfirst
by pid: egen sumpovfirst=sum(g0_1)
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if runsumpov < 2 & povfirstobs==0,fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if runsumpov < 2 & povfirstobs==0 & runsumyrgap==0& sumpovfirst>2,fe vce(cluster grp)nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if runsumpov < 2 & povfirstobs==0 & runsumyrgap==0 &sumpovfirst>3,fe vce(cluster grp)nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if runsumpov < 2 & povfirstobs==0 & runsumyrgap==0 & sumpovfirst>4,fe vce(cluster grp)nonest


*---------------
* Figure 2
*----------------

*employment
g switch_u_1=(l1.unemployed==1 & l2.employment==1) if l1.employment<. & l2.employment<.
sort pid year
capture drop cumsumswitch_u_1
by pid: gen cumsumswitch_u_1=sum(switch_u_1)
capture drop flag
gen flag=cumsumswitch_u_1>0&runsumpov==0
by pid: egen lostjob_1=max(flag) /*0, they did not lose the job; 1, they lost job,  BEFORE falling into poverty*/
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov < 2 & povfirstobs==0 & lostjob_1==0),fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov < 2 & povfirstobs==0 & lostjob_1==1),fe vce(cluster grp) nonest

*retired
sort pid year
g switch_r_1=(l1.retired==1 & l2.retired==0) if l1.employment<. & l2.employment<.
sort pid year
capture drop cumsumswitch_r_1
by pid: gen cumsumswitch_r_1=sum(switch_r_1)
capture drop flag
gen flag=cumsumswitch_r_1>0&runsumpov==0
by pid: egen pension_1=max(flag) /*0, they did not retire ; 1, they retire,  BEFORE falling into poverty*/
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov < 2 & povfirstobs==0 & pension_1==0),fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov < 2 & povfirstobs==0 & pension_1==1),fe vce(cluster grp) nonest

*family: change+incr+decr in number of members
sort pid year
g switch_ch_1=(l1.d11106!=l2.d11106) if l1.d11106<. & l2.d11106<.
g increase_fam=(l1.d11106>l2.d11106) if l1.d11106<. & l2.d11106<.
g decrease_fam=(l1.d11106<l2.d11106) if l1.d11106<. & l2.d11106<.
sort pid year
capture drop cumsumswitch_ch_1
by pid: gen cumsumswitch_ch_1=sum(switch_ch_1)
capture drop flag
gen flag=cumsumswitch_ch_1>0&runsumpov==0
by pid: egen bigfam_1=max(flag) /*0, they did not change family ; 1, change family,  BEFORE falling into poverty*/
sort pid year
by pid: gen cumsumincrease=sum(increase_fam)
by pid: gen cumsumdecrease=sum(decrease_fam)
capture drop flag
gen flag=cumsumincrease>0&runsumpov==0
by pid: egen incrfam_1=max(flag) /*0, they did not increase family ; 1, increased family,  BEFORE falling into poverty*/
capture drop flag
gen flag=cumsumdecrease>0&runsumpov==0
by pid: egen decrfam_1=max(flag) /*0, they did not decrease family ; 1, decreased family,  BEFORE falling into poverty*/
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov<2 & povfirstobs==0 & bigfam_1==0),fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov<2 & povfirstobs==0  & bigfam_1==1),fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov<2 & povfirstobs==0  & incrfam_1==0),fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov<2 & povfirstobs==0 & incrfam_1==1),fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov<2 & povfirstobs==0 & decrfam_1==0),fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov<2 & povfirstobs==0 & decrfam_1==1),fe vce(cluster grp) nonest

*disability
g switch_d_1=(l1.disability==1& l2.disability==0) if l1.disability<. & l2.disability<.
sort pid year
capture drop cumsumswitch_d_1
by pid: gen cumsumswitch_d_1=sum(switch_d_1)
capture drop flag
gen flag=cumsumswitch_d_1>0&runsumpov==0
by pid: egen badhealth_1=max(flag) 
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov<2 & povfirstobs==0 & badhealth_1==0),fe vce(cluster grp) nonest
xi: xtreg satlife pov01y pov12y pov23y pov34y pov45y pov5oy i.year i.employment $iir if (runsumpov<2 & povfirstobs==0 &  badhealth_1==1),fe vce(cluster grp) nonest











