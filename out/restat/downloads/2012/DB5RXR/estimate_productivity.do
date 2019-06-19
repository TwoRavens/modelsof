version 10
clear
capture program drop _all
set memory 350m
capture log close
set more off
log using ${empdecomp}estimate_productivity, text replace

***29.09.2008**RBal***********************************
* Use empdecomppanel1_update.dta and try to generate 
* tfp measures based on OLS regressions, similar to
* Melitz and Polanec (2008)
******************************************************
	use ${industri}empdecomppanel1_update.dta

#delimit ;
	keep aar bnr v13 v15 v34 isic3 k1 k2 k3 Li_h Li_e 
	Qidef Midef totutenl  MNE50 VAdef;
#delimit cr
gen isic2=int(isic3/10)
replace totutenl=0 if totutenl==2
	quietly tab aar, gen(Y)
	quietly tab isic3, gen (I)
	egen ind_year=group(isic2 aar)
	quietly tab ind_year, gen(iy)
	drop I1 Y1 iy1

gen va=log(VAdef)
gen q=log(Qidef)
gen m= log(Midef)
replace v13=1 if v13>0 & v13<1
replace Li_e=1 if Li_e>0 & Li_e<1
gen h=log(Li_h)
gen l=log(v13)
gen e=log(Li_e)
gen c1=log(k1)
gen c3=log(k3)
gen c2=log(k2)

* TFP based on gross output Qidef
* preferred measure uses either Li_h or Li_e
* where labour input includes rented labour

* A: based on hours (includes rented labour)
* B: based on employees (includes rented labour)

foreach t in 1 2 3 {
quietly reg q m h c`t' I* Y* iy*, cluster(bnr)
gen qhhat= _b[m]*m+_b[h]*h+_b[c`t']*c`t'
gen uhhat`t'=q-qhhat
drop qhhat
quietly reg q m e c`t' I* Y* iy*, cluster(bnr)
gen qehat= _b[m]*m+_b[e]*h+_b[c`t']*c`t'
gen uehat`t'=q-qehat
drop qehat
}
corr uh* ue*
rename uhhat3 uhhat
rename uehat3 uehat
label var uehat "TFP measure based on k3, employees"
label var uhhat "TFP measure based on k3, total hours"

* include dummy for totutenl, use k3
quietly reg q m e c3 totutenl I* Y* iy*, cluster(bnr)
gen q3hat= _b[m]*m+_b[e]*l+_b[c3]*c3
gen uehatD=q-q3hat
drop q3hat
label var uehatD "TFP useing k3 and employees, +D for totutenl=1"

* include dummy for totutenl and dom MNEs, use k3
replace MNE50=0 if MNE50==.
quietly reg q m e c3 totutenl MNE50 I* Y* iy*, cluster(bnr)
gen q3hat= _b[m]*m+_b[e]*l+_b[c3]*c3
gen uehatD1=q-q3hat
drop q3hat
label var uehatD1 "TFP using k3 and employees, +D for totutenl=1 and domMNE"

* Impose CRS, use k3
* CRS
gen q3=q-c3
gen e3=e-c3
gen m3=m-c3

quietly reg q3 m3 e3  I* Y* iy*, cluster(bnr)
gen q3chat= _b[m3]*m3+_b[e3]*e3
gen uehatcrs=q3-q3chat
corr uehatcrs uehat uehatD


* From earlier: this measure of l does not include rented labour
quietly reg q m l c3 I* Y* iy*, cluster(bnr)
gen q3hat= _b[m]*m+_b[l]*l+_b[c3]*c3
gen u3hat=q-q3hat
drop q3hat
corr u3hat uehat uhhat
label var u3hat "TFP using k3, and only own employees"


* TFP measures based on value added: should only include labor and capital
* Since the value added measure subtracts inputs included rented labour
* and capital, the labour measure should be l, but k1-k3 includes rented capital
* leave that problem for now.


quietly reg va l c3 totutenl I* Y* iy*, cluster(bnr)
gen q3hat=_b[l]*l+_b[c3]*c3
gen vahat=q-q3hat
drop q3hat
label var vahat "TFP using k3, l and not m (valueadded based)"

corr vahat uehat
	keep aar bnr vahat ue* uh* u3hat
	compress
	sort bnr aar
	merge bnr aar using ${industri}empdecomppanel1_update.dta
	assert _merge==3
	drop _merge
	sort bnr aar
	save ${industri}empdecomppanel1_update.dta, replace

 

	* Mean of different tfp measures by year
	table aar, c(m uehat m u3hat m uehat1 m uehat2)
	table aar, c(m vahat m uehat m uehatD m uehatcrs)
	table aar, c(m uehat m uhhat m uhhat1 m uhhat2)

	* Median of different tfp measures by year
	table aar, c(med uehat med u3hat med uehat1 med uehat2)
	table aar, c(med vahat med uehat med uehatD med uehatcrs)
	table aar, c(med uehat med uhhat med uhhat1 med uhhat2)



capture log close
exit

quietly reg q m e c3  I* Y* iy*, cluster(bnr)
est store t2
est table t1 t1, keep(m e c3 _const totutenl MNE50)
est table t1 t1, keep(m e c3 _cons totutenl MNE50)
est table t1 t2, keep(m e c3 _cons totutenl MNE50)
test c3+e+m=1
gen MNEdummy==1 if totutenl==1 | MNE50==1
gen MNEdummy=1 if totutenl==1 | MNE50==1
replace MNEdummy=0 if MNEdummy==.
quietly reg q m e c3 MNEdummy  I* Y* iy*, cluster(bnr)
gen mM=m*MNEdummy
gen eM=e*MNEdummy
gen cM=c3*MNEdummy
quietly reg q m e c3 MNEdummy  I* Y* iy*, cluster(bnr)
est store t3
quietly reg q m e c3 mM eM cM  I* Y* iy*, cluster(bnr)
est store t4
est table t1 t2 t3 t4, keep(m mM e eM  c3 cM totutenl MNE50 MNEdummy_cons)
est table t1 t2 t3 t4, keep(m mM e eM  c3 cM totutenl MNE50 MNEdummy _cons)
qui est replay t4
gen testhat= _b[m]*m+_b[e]*l+_b[c3]*c3 if MNEdummy==0
replace testhat=( _b[m]+_b[mM])*m+(_b[e]+_b[eM])*l+(_b[c3]+_b[cM])*c3 if MNEdummy==1
gen TFPny=q-testhat