*******************************************
***Analyses reported in:
*Sønderskov, KM. & Dinesen, PT.
*"Trusting the state, trusting each other? The effect of institutional trust on social trust"
*Political Behavior
*date: 20151006

version 13

*Note the data file "replication_data_all" used below are generated with "prep_data_file.do"
use replication_data_all,clear
datasignature confirm


*****************************************
******Cross-lagged Models****************
*************EVS DATA********************


keep if data =="EVS"
drop surveyyear
unab varnames : ST- STc
reshape wide ST- STc, i(id) j(wave)
rename *1 *9
rename *2 *l1
rename *9 *l2
rename *3 *0
foreach var of local varnames {
order `var'0 `var'l1 `var'l2 
}
order data id, first
*Descriptives
*sample selction
qui: reg IT0 STl? ITl?
qui: logit ST0 STl? ITl? if e(sample)
qui: gen touseM2 = e(sample)
*Table 2
su IT0 ITl? ST0 STl? if touseM2==1
*other notes
alpha ITal2 ITbl2 ITcl2 ITdl2 if touseM2==1
alpha ITal1 ITbl1 ITcl1 ITdl1 if touseM2==1
alpha ITa0 ITb0 ITc0 ITd0 if touseM2==1
corr IT0 ITf0   if  touseM2==1
corr ITl1 ITfl1 if touseM2==1
corr ITl2 ITfl2 if touseM2==1



****IT->ST

*Model 2
logit ST0 ITl? STl? if touseM2==1
eststo ST2
qui: logit ST0 ITfl? STl? if touseM2==1
eststo ST2f

*Model 4
*sample selection:
qui: reg IT0 STl? ITl? orgl? religl? lfstsfl? unemply0 edu0 income0 female0 age0 native0,r
*M4
logit ST0 ITl? STl? lfstsfl? orgl? religl? female0 native0 age0  ///
	i.edu0 i.income0  unemply0 if e(sample),r
gen touseM4 = e(sample)
eststo ST4
su ITl1 if touseM4==1,d
loc p25IT = r(p25)
loc p75IT = r(p75)
margins, at(ITl1=(0 1))
margins, at(ITl1=(`p25IT' `p75IT'))
qui: 
logit ST0 ITfl? STl? lfstsfl? orgl? religl? female0 native0 age0  ///
	i.edu0 i.income0  unemply0 if touseM4==1,r
eststo ST4f


*Model 6
*sample selection:
qui: reg IT0 STl? ITl? religl? lfstsfl? unemply0 ///
	i.edu0 i.income0 female0 age0 native0,r
*M6
logit ST0 ITl? STl? lfstsfl? religl?         female0 native0 age0  ///
	i.edu0 i.income0  unemply0 if e(sample),r
gen touseM6 = e(sample)
eststo ST6
su IT0 if touseM6==1,d
loc p25IT = r(p25)
loc p75IT = r(p75)
margins, at(ITl1=(0 1)) post
mat c = e(b)
di c[1,2]-c[1,1]
est restore ST6
margins, at(ITl1=(`p25IT' `p75IT')) post
mat c = e(b)
di "change in avg. pred. prop based on IQR = " c[1,2]-c[1,1]

qui: logit ST0 ITfl? STl? lfstsfl? religl?         female0 native0 age0  ///
	i.edu0 i.income0  unemply0 if touseM6==1,r
eststo ST6f

*ST->IT
*model 2it
reg IT0 ITl? STl? if touseM2==1
eststo IT2
qui:reg ITf0 ITfl? STl? if touseM2==1
eststo IT2f

*Model 4it
reg IT0 ITl? STl? lfstsfl? orgl? religl? female0 native0 age0 ///
	i.edu0 i.income0  unemply0 if touseM4==1,r
eststo IT4
qui:reg ITf0 ITfl? STl? lfstsfl? orgl? religl? female0 native0 age0 ///
	i.edu0 i.income0  unemply0 if touseM4==1,r
eststo IT4f
*Model 6it
reg IT0 ITl? STl? lfstsfl? religl?      female0 native0 age0 ///
	i.edu0 i.income0  unemply0 if touseM6==1,r
eststo IT6
qui:reg ITf0 ITfl? STl? lfstsfl?       religl? female0 native0 age0 ///
	i.edu0 i.income0  unemply0 if touseM4==1,r
eststo IT6f



*****************SPAPS***********************
use replication_data_all,clear
keep if data =="SPAPS"
drop surveyyear
unab varnames : ST- STc
reshape wide ST- STc, i(id) j(wave)
rename *1 *l1
rename *2 *0
foreach var of local varnames {
order `var'0 `var'l1 
}
order data id, first

*sample selction
qui: reg IT0 STl1 ITl1 i.R
qui: reg ST0 ITl1 STl1 if e(sample)
qui: gen touseM1 = e(sample)

*Descriptives,
* table 2
bys R: su STl1 ITl1 if touseM1==1
su ST0 IT0 if touseM1==1
*Other notes
bys R: alpha STal1 STbl1 STcl1 if touseM1==1
alpha STa0 STb0 STc0 if touseM1==1
alpha ITa0 ITb0 ITd0 ITe0 if touse==1
bys R: alpha ITal1 ITbl1 ITdl1 ITel1 if touse==1
corr IT0 ITf0   if touseM1==1
corr ITl1 ITfl1 if touseM1==1

****IT->ST***
*Model 1
reg ST0 ITl1 STl1 i.R if touseM1==1,r
eststo ST1

margins, dydx(ITl1) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1]
mat b = bt'
mat cit = C["ll".."ul", 1]
mat ci = cit'
mat F = b,ci
reg ST0 c.ITl1##i.R STl1 if touseM1==1,r
margins , dydx(ITl1) over(R) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1..3]
mat b = bt'
mat cit = C["ll".."ul", 1..3]
mat ci = cit'
mat Ft = b,ci
mat F = F\Ft

qui:reg STf0 ITfl1 STfl1 i.R if touseM1==1,r
eststo ST1f

*model 3
qui: reg IT0 STl1 ITl1 orgl1 religl1 lfstsfl1 unemply0 i.edu0 i.income0 female0 age0 nativel1 ///
B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R,r
*M3
reg ST0 ITl1 STl1 lfstsfl1 orgl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if e(sample),r
gen touseM3 = e(sample)
eststo ST3

margins, dydx(ITl1) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1]
mat b = bt'
mat cit = C["ll".."ul", 1]
mat ci = cit'
mat Ft = b,ci
mat F = F\Ft

reg STf0 ITfl1 STfl1 lfstsfl1 orgl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if e(sample),r
eststo ST3f

*model 5
qui: reg IT0 STl1 ITl1  religl1 lfstsfl1 unemply0 i.edu0 i.income0 female0 age0 native0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R,r
*M5
reg ST0 ITl1 STl1 lfstsfl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if e(sample),r
gen touseM5 = e(sample)
eststo ST5
su ITl1 if touseM5==1,d
di "IQR = " (r(p75)-r(p25))
di (r(p75)-r(p25))*_b[ITl1]
margins, dydx(ITl1) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1]
mat b = bt'
mat cit = C["ll".."ul", 1]
mat ci = cit'
mat Ft = b,ci
mat F = F\Ft
reg ST0 c.ITl1##R STl1 lfstsfl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if touseM5==1,r
margins , dydx(ITl1) over(R) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1..3]
mat b = bt'
mat cit = C["ll".."ul", 1..3]
mat ci = cit'
mat Ft = b,ci
mat F = F\Ft

qui:reg STf0 ITfl1 STfl1 lfstsfl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if e(sample),r
eststo ST5f

****IT->ST*********REVERSED*********

*Model 1it
reg IT0 ITl1 STl1 i.R if touseM1==1,r
eststo IT1

margins, dydx(STl1) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1]
mat b = bt'
mat cit = C["ll".."ul", 1]
mat ci = cit'
mat Ft = b,ci
mat F = F\Ft
reg IT0 ITl1 c.STl1##R if touseM1==1,r
margins , dydx(STl1) over(R) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1..3]
mat b = bt'
mat cit = C["ll".."ul", 1..3]
mat ci = cit'
mat Ft = b,ci
mat F = F\Ft

qui:reg ITf0 ITfl1 STl1 i.R if touseM1==1,r
eststo IT1f

*Model 3it
reg IT0 ITl1 STl1 lfstsfl1 orgl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if touseM3==1,r
eststo IT3
margins, dydx(STl1) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1]
mat b = bt'
mat cit = C["ll".."ul", 1]
mat ci = cit'
mat Ft = b,ci
mat F = F\Ft

qui:reg ITf0 ITfl1 STfl1 lfstsfl1 orgl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if touseM3==1,r
eststo IT3f

*Model 5it
reg IT0 ITl1 STl1 lfstsfl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if touseM5==1,r
eststo IT5

margins, dydx(STl1) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1]
mat b = bt'
mat cit = C["ll".."ul", 1]
mat ci = cit'
mat Ft = b,ci
reg IT0 ITl1 c.STl1##R lfstsfl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0 if touseM5==1,r
margins , dydx(STl1) over(R) post
estadd margins
mat C = e(margins_table)
mat bt = C["b", 1..3]
mat b = bt'
mat cit = C["ll".."ul", 1..3]
mat ci = cit'
mat Ftt = b,ci
mat Ft = Ft\Ftt
mat F = F\Ft

reg ITf0 ITfl1 STfl1 lfstsfl1 religl1 female0 native0 age0  ///
	i.edu0 i.income0 unemply0 B5extra0 B5neuro0 B5cons0 B5extra0 B5agree0 B5opena0 B5openb0  i.R if touseM5==1,r
eststo IT5f


preserve
clear
svmat F,names(col)
gen id = _n
gen byte depvar = 1
replace depvar = 2 in 10/18
lab def depvarLB 1 "Social trust" 2 "Institutional trust"
lab val depvar depvarLB
gen byte model = 1
replace model = 2 if inlist(id,5,14)
replace model = 3 if inlist(id,6,7,8,9,15,16,17,18)
gen name = 1
replace name = 2 if inlist(id,2,5,7,11,14,16)
replace name = 3 if inlist(id,3,8,12,17)
replace name = 4 if inlist(id,4,9,13,18)
lab def nameLB 1 "Average across years" 2 "2002/3" 3 "2004/5" 4 "2008/9"
lab val name nameLB
tempfile coefs
save `coefs',replace
restore



/*comparing coefs
suest sST3ar0 sIT3ar0,  
test [sST3ar0_mean]it_t0=[sIT3ar0_mean]trust3_t0

suest sST3ar1 sIT3ar1,  vce(robust)
test [sST3ar1_mean]it_t0=[sIT3ar1_mean]trust3_t0
suest sST3ar2d_mean]it_t0=[sIT3ar2_mean]trust3_t0
suest sST3ar3 sIT3ar3,  vce(robust)
test [sST3ar3_mean]it_t0=[sIT3ar3_mean]trust3_t0


reg trust3_t1 it_t0 trust3_t0 stfl_t0            relig_t0 B5extra_t1-B5open2_t1  female native age i.i4edu_t1 i.iRincome_t1  unempl_t1 i.runde if touseM3a==1
eststo a
reg it_t1 trust3_t0 it_t0 stfl_t0   relig_t0         B5extra_t1-B5open2_t1  female native age i.i4edu_t1 i.iRincome_t1  unempl_t1 i.runde if touseM3a==1
eststo b
suest a b
test [a_mean]it_t0=[b_mean]trust3_t0
*/

**************FE***************************
*********EVS************
use replication_data_all,clear
keep if data == "EVS"

xtlogit ST IT lfstsf org relig i.edu  i.income unempl i.wave,fe 
eststo m9
xtlogit ST ITf lfstsf org relig i.edu  i.income unempl i.wave,fe 
eststo m9f

xtlogit ST IT lfstsf  relig i.edu  i.income unempl i.wave,fe 
eststo m10
bys wave: egen Mit=mean(IT) if e(sample)
gen Mdevit = IT-Mit
su Mdevit,d
di r(max)-r(min)
di r(p75)-r(p25)
loc p25 = r(p25)
loc p75 = r(p75)
loc min = r(min)
loc max = r(max)

margins, at(IT=(`p25' `p75')) predict(pu0) post
mat b = e(b)
mat B = b[1,2]-b[1,1]
mat list B
est restore m10
margins, at(IT=(`min' `max')) predict(pu0) post
mat b = e(b)
mat B = b[1,2]-b[1,1]
mat list B
xtlogit ST ITf lfstsf  relig i.edu  i.income unempl i.wave,fe 
eststo m10f

*********************SPAPS
use replication_data_all,clear
keep if data=="SPAPS"
sort id wave
duplicates drop V2 if wave==1, force
*MODEL 7
qui: egen mis =  rowmiss(ST IT lfstsf org relig edu  income unempl wave)
qui: bys id: egen nmis = max(mis)
xtreg ST IT lfstsf org relig i.edu  i.income unempl i.wave if nmis<1,fe
eststo m7
margins, dydx(*)

xtreg STf ITf lfstsf org relig i.edu  i.income unempl i.wave if nmis<1,fe
eststo m7f
drop nmis mis



*Model 8
*xtreg trust3_t it_t stfl_t unempl_t i.iRincome_t i.i4edu_t i.year,fe
qui: egen mis =  rowmiss(ST IT lfstsf relig edu  income unempl wave)
qui: bys id: egen nmis = max(mis)
xtreg ST IT lfstsf relig i.edu  i.income unempl wave if nmis<1,fe
eststo m8

*des
gen dinst5 = d.IT if e(sample)
su dinst5,d
di r(p75)-r(p25)
loc p25 = r(p25)
loc p75 = r(p75)
loc min = r(min)
loc max = r(max)

margins, at(IT=(`p25' `p75')) post
mat b = e(b)
mat B = b[1,2]-b[1,1]
mat list B
est restore m8
margins, at(IT=(`min' `max')) post
mat b = e(b)
mat B = b[1,2]-b[1,1]
mat list B



xtreg STf ITf lfstsf relig edu  income unempl wave if nmis<1,fe
eststo m8f

************************************TABLES
*Table 3 - spaps/evs
esttab ST1 ST3 ST5 using Tab3a.rtf, r2 b(2) drop (*R)  replace nogaps starlevel(* 0.05 ** 0.01) stardetach
esttab ST2 ST4 ST6 using Tab3b.rtf, pr2 b(2) replace nogaps starlevel(* 0.05 ** 0.01) stardetach

*Table 4 - spaps/evs
esttab IT1 IT3 IT5 using Tab4a.rtf, r2 b(2) drop (*R)  replace nogaps starlevel(* 0.05 ** 0.01) stardetach
esttab IT2 IT4 IT6 using Tab4b.rtf, r2 b(2) replace nogaps starlevel(* 0.05 ** 0.01) stardetach

*Tab5
esttab m7 m8 m9 m10 using Tab5.rtf, b(2) replace drop(*wave) nogaps starlevel(* 0.05 ** 0.01) stardetach


*Figure 1
use `coefs',clear

tw (scatter b name if model ==1 & depvar ==1, mcolor(black) msize(medsmall)) ///
	(rcap ll ul name if model ==1 & depvar ==1,lc(black)) , yscale(range(-0.07 0.3)) xscale(range(0.7 4.3)) ///
	ylabel(-0.05 0 0.05 (0.1) .25) xlabel(none) xtick(1(1)4) xtitle("") legend(off) ytitle("Model 1") scheme(s1mono) ///
	plotregion(style(none)) yline(0) name(_11,replace) title("Social trust{subscript:to} as dependent",size(medsmall))
tw (scatter b name if model ==1 & depvar ==2, mcolor(black) msize(medsmall)) ///
	(rcap ll ul name if model ==1 & depvar ==2,lc(black)) , yscale(range(-0.07 0.3)) xscale(range(0.7 4.3)) ///
	ylabel(none) ytick(-0.05 (0.1) .25) xlabel(none) xtick(1(1)4) xtitle("") legend(off) ytitle("") scheme(s1mono) ///
	plotregion(style(none)) yline(0) name(_12,replace) title("Institutional trust{subscript:to} as dependent",size(medsmall))
tw (scatter b name if model ==2 & depvar ==1, mcolor(black) msize(medsmall)) ///
	(rcap ll ul name if model ==2 & depvar ==1,lc(black)) , yscale(range(-0.07 0.3)) xscale(range(0.7 4.3)) ///
	ylabel(-0.05 0 0.05 (0.1) .25) xlabel(none) xtick(1(1)4) xtitle("") legend(off) ytitle("Model 3") scheme(s1mono) ///
	plotregion(style(none)) yline(0) name(_21,replace) title("",size(medsmall))
tw (scatter b name if model ==2 & depvar ==2, mcolor(black) msize(medsmall)) ///
	(rcap ll ul name if model ==2 & depvar ==2,lc(black)) , yscale(range(-0.07 0.3)) xscale(range(0.7 4.3)) ///
	ylabel(none) ytick(-0.05 (0.1) .25)  xlabel(none) xtick(1(1)4) xtitle("") legend(off) ytitle("") scheme(s1mono) ///
	plotregion(style(none)) yline(0) name(_22,replace) title("",size(medsmall))
tw (scatter b name if model ==3 & depvar ==1, mcolor(black) msize(medsmall) xlabel(,valuelabel labsize(small))) ///
	(rcap ll ul name if model ==3 & depvar ==1,lc(black)) , yscale(range(-0.07 0.3)) xscale(range(0.7 4.3)) ///
	ylabel(-0.05 0 0.05  (0.1) .25) xtitle("") legend(off) ytitle("Model 5") scheme(s1mono) ///
	plotregion(style(none)) yline(0) name(_31,replace) title("",size(medsmall))
tw (scatter b name if model ==3 & depvar ==2, mcolor(black) msize(medsmall) xlabel(,valuelabel labsize(small)))  ///
	(rcap ll ul name if model ==3 & depvar ==2,lc(black)) , yscale(range(-0.07 0.3)) xscale(range(0.7 4.3)) ///
	ylabel(none) ytick(-0.05 (0.1) .25)  xtitle("") legend(off) ytitle("") scheme(s1mono) ///
	plotregion(style(none)) yline(0) name(_32,replace) title("",size(medsmall))


graph combine _11 _12 _21 _22 _31 _32, col(2) scheme(s1mono) imargin(-3 -3 -2 -2) iscale(*0.9) xsize(7.1)  graphregion(margin(1 1 0 0)) saving(fig1,replace)
graph export fig1.tif, as(tif) replace
graph export fig1.eps, as(eps) replace
graph export fig1.pdf, as(pdf) replace


*****Robustness analyses****
****Comparing with Fresults obtained using factor scores***
*log using comp ,replace text name(comp)
esttab ST1*, rename(ITl1 IT ITfl1 IT STl1 ST STfl1 ST) keep(IT ST) title(Model 1)  mlabels(Scale Factor)
esttab ST2*, rename(ITl1 IT1999 ITl2 IT1990 ITfl1 IT1999 ITfl2 IT1990 STl1 ST1990 STl2 ST1999) keep(IT* ST*) title(Model 2) mlabels(Scale Factor)
esttab ST3*, rename(ITl1 IT ITfl1 IT STl1 ST STfl1 ST) keep(IT ST)  title(Model 3)  mlabels(Scale Factor)
esttab ST4*, rename(ITl1 IT1999 ITl2 IT1990 ITfl1 IT1999 ITfl2 IT1990 STl1 ST1990 STl2 ST1999) keep(IT* ST*)  title(Model 4) mlabels(Scale Factor)
esttab ST5*, rename(ITl1 IT ITfl1 IT STl1 ST STfl1 ST) keep(IT ST)  title(Model 5)  mlabels(Scale Factor)
esttab ST6*, rename(ITl1 IT1999 ITl2 IT1990 ITfl1 IT1999 ITfl2 IT1990 STl1 ST1990 STl2 ST1999) keep(IT* ST*)  title(Model 6) mlabels(Scale Factor)

esttab IT1*, rename(ITl1 IT ITfl1 IT STl1 ST STfl1 ST) keep(IT ST) title(Model 1it)  mlabels(Scale Factor)
esttab IT2*, rename(ITl1 IT1999 ITl2 IT1990 ITfl1 IT1999 ITfl2 IT1990 STl1 ST1990 STl2 ST1999) keep(IT* ST*) title(Model 2it) mlabels(Scale Factor)
esttab IT3*, rename(ITl1 IT ITfl1 IT STl1 ST STfl1 ST) keep(IT ST)  title(Model 3it)  mlabels(Scale Factor)
esttab IT4*, rename(ITl1 IT1999 ITl2 IT1990 ITfl1 IT1999 ITfl2 IT1990 STl1 ST1990 STl2 ST1999) keep(IT* ST*)  title(Model 4it) mlabels(Scale Factor)
esttab IT5*, rename(ITl1 IT ITfl1 IT STl1 ST STfl1 ST) keep(IT ST)  title(Model 5it)  mlabels(Scale Factor)
esttab IT6*, rename(ITl1 IT1999 ITl2 IT1990 ITfl1 IT1999 ITfl2 IT1990 STl1 ST1990 STl2 ST1999) keep(IT* ST*)  title(Model 6it) mlabels(Scale Factor)

esttab m7*, rename(ITf IT) keep(IT)  title(Model 7) mlabels(Scale Factor)
esttab m8*, rename(ITf IT) keep(IT)  title(Model 8) mlabels(Scale Factor)
esttab m9*, rename(ITf IT) keep(IT)  title(Model 9) mlabels(Scale Factor)
esttab m10*, rename(ITf IT) keep(IT)  title(Model 10) mlabels(Scale Factor)


	
*log close _all
exit
