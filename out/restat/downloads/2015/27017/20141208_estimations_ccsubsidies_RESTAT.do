/**********************************************
*PART 3: final sample and estimation results
*********************************************/

*****Paper as of 12.08.2014

****Table 1: child care statistics
*data from NOVA (on my computer)

***Table 2: descriptive statistics

*total sample

sum age08 female sosken order feduy08 meduy08 fageb mageb mimmigrantb fimmigrantb marrcohb stpaver skraver munaver 

*.5 sample

preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>0.5
drop if norminc<-.5

sum age08 female sosken order feduy08 meduy08 fageb mageb mimmigrantb fimmigrantb marrcohb stpaver skraver munaver 
restore

*.1 sample

preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>0.1
drop if norminc<-.1

sum age08 female sosken order feduy08 meduy08 fageb mageb mimmigrantb fimmigrantb marrcohb stpaver skraver munaver 




****Table 3

***grade point average
*BW: .02, .05, .1, .25, .5
*Polynomials: 0- 1 - 2 - 3 - 4
log using /home1/katrine/ccsubsidies/reviserestat031212.log, replace
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l


*no poly
xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m01
xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m02
xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m03
xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m04
xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m05

*linear
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m11
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m12
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m13
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m14
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m15

*quadratic
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m21
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m22
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m23
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m24
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m25

*cubic
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m31
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m32
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m33
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m34
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m35

*quartic
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.02 & norminc>-.02, robust
estimates store m41
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.05 & norminc>-.05, robust
estimates store m42
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.10 & norminc>-.10, robust
estimates store m43
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.25 & norminc>-.25, robust
estimates store m44
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.50 & norminc>-.50, robust
estimates store m45

esttab m01 m02 m03 m04 m05, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13 m14 m15, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m21 m22 m23 m24 m25, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m31 m32 m33 m34 m35, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m41 m42 m43 m44 m45, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*aic test
estout m01 m11 m21 m31 m41, keep(dum) stats(N aic)
estout m02 m12 m22 m32 m42, keep(dum) stats(N aic)
estout m03 m13 m23 m33 m43, keep(dum) stats(N aic)
estout m04 m14 m24 m34 m44, keep(dum) stats(N aic)
estout m05 m15 m25 m35 m45, keep(dum) stats(N aic)

*bin test

*bins of .01
gen bins=.
forvalues i=-1(.01)0{
replace bins=`i' if norminc>=`i' & norminc<`i'+.01
}
forvalues i=0(.01)1{
replace bins=`i' if norminc>=`i' & norminc<`i'+.01
}


*no poly
keep stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb foedselsaar mkom5 bins norminc r l r2 l2 r3 l3 r4 l4

xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.02 & norminc>=-.02, robust
estimates store p01
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.05 & norminc>=-.05, robust
estimates store p02
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.10 & norminc>=-.10, robust
estimates store p03
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.25 & norminc>=-.25, robust
estimates store p04
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.50 & norminc>=-.50, robust
estimates store p05
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*linear
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p11
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p12
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p13
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p14
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p15
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*quadratic
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p21
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p22
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p23
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p24
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p25
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*cubic
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p31
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p32
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p33
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p34
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p34
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*quartic

xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p41
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p42
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p43
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p44
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg stpaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p45
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

esttab p01 p02 p03 p04 p05, keep(dum) stats(p_diff) br
esttab p11 p12 p13 p14 p15, keep(dum) stats(p_diff) br
esttab p21 p22 p23 p24 p25, keep(dum) stats(p_diff) br
esttab p31 p32 p33 p34 p35, keep(dum) stats(p_diff) br
esttab p41 p42 p43 p44 p45, keep(dum) stats(p_diff) br

log close

restore


****Table 4: written exam
log using /home1/katrine/ccsubsidies/reviserestat031212_wri.log, replace
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51
gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

*no poly
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m01
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m02
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m03
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m04
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m05

*linear
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m11
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m12
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m13
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m14
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m15

*quadratic
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m21
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m22
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m23
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m24
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m25

*cubic
xi:quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m31
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m32
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m33
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m34
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m35

*quartic
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.02 & norminc>-.02, robust
estimates store m41
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.05 & norminc>-.05, robust
estimates store m42
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.10 & norminc>-.10, robust
estimates store m43
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.25 & norminc>-.25, robust
estimates store m44
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.50 & norminc>-.50, robust
estimates store m45

esttab m01 m02 m03 m04 m05, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13 m14 m15, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m21 m22 m23 m24 m25, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m31 m32 m33 m34 m35, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m41 m42 m43 m44 m45, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*aic test
estout m01 m11 m21 m31 m41, keep(dum) stats(N aic)
estout m02 m12 m22 m32 m42, keep(dum) stats(N aic)
estout m03 m13 m23 m33 m43, keep(dum) stats(N aic)
estout m04 m14 m24 m34 m44, keep(dum) stats(N aic)
estout m05 m15 m25 m35 m45, keep(dum) stats(N aic)

*bin test

*bins of .01
gen bins=.
forvalues i=-1(.01)0{
replace bins=`i' if norminc>=`i' & norminc<`i'+.01
}
forvalues i=0(.01)1{
replace bins=`i' if norminc>=`i' & norminc<`i'+.01
}


*no poly
keep skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb foedselsaar mkom5 bins norminc r l r2 l2 r3 l3 r4 l4
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.02 & norminc>=-.02, robust
estimates store p01
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.05 & norminc>=-.05, robust
estimates store p02
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.10 & norminc>=-.10, robust
estimates store p03
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.25 & norminc>=-.25, robust
estimates store p04
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.50 & norminc>=-.50, robust
estimates store p05
quietly testparm _Ibins*
estadd scalar p_diff=r(p)


*linear
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p11
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p12
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p13
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p14
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p15
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*quadratic
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p21
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p22
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p23
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p24
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p25
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*cubic
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p31
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p32
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p33
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p34
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p35
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*quartic
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p41
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p42
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p43
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p44
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg skraverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p45
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

esttab p01 p02 p03 p04 p05, keep(dum) stats(p_diff) br
esttab p11 p12 p13 p14 p15, keep(dum) stats(p_diff) br
esttab p21 p22 p23 p24 p25, keep(dum) stats(p_diff) br
esttab p31 p32 p33 p34 p35, keep(dum) stats(p_diff) br
esttab p41 p42 p43 p44 p45, keep(dum) stats(p_diff) br

log close
restore

***Table 5: oral exam

log using /home1/katrine/ccsubsidies/reviserestat031212_oral.log, replace
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

*no poly
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m01
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m02
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m03
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m04
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m05

*linear
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m11
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m12
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m13
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m14
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m15

*quadratic
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m21
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m22
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m23
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m24
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m25

*cubic
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.02 & norminc>-.02, robust
estimates store m31
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.05 & norminc>-.05, robust
estimates store m32
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.10 & norminc>-.10, robust
estimates store m33
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m34
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.50 & norminc>-.50, robust
estimates store m35

*quartic
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.02 & norminc>-.02, robust
estimates store m41
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.05 & norminc>-.05, robust
estimates store m42
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.10 & norminc>-.10, robust
estimates store m43
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.25 & norminc>-.25, robust
estimates store m44
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5  if norminc<.50 & norminc>-.50, robust
estimates store m45

esttab m01 m02 m03 m04 m05, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13 m14 m15, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m21 m22 m23 m24 m25, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m31 m32 m33 m34 m35, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m41 m42 m43 m44 m45, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*aic test
estout m01 m11 m21 m31 m41, keep(dum) stats(N aic)
estout m02 m12 m22 m32 m42, keep(dum) stats(N aic)
estout m03 m13 m23 m33 m43, keep(dum) stats(N aic)
estout m04 m14 m24 m34 m44, keep(dum) stats(N aic)
estout m05 m15 m25 m35 m45, keep(dum) stats(N aic)

*bin test

*bins of .01
gen bins=.
forvalues i=-1(.01)0{
replace bins=`i' if norminc>=`i' & norminc<`i'+.01
}
forvalues i=0(.01)1{
replace bins=`i' if norminc>=`i' & norminc<`i'+.01
}


*no poly
keep munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb foedselsaar mkom5 bins norminc r l r2 l2 r3 l3 r4 l4

xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.02 & norminc>=-.02, robust
estimates store p01
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.05 & norminc>=-.05, robust
estimates store p02
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.10 & norminc>=-.10, robust
estimates store p03
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.25 & norminc>=-.25, robust
estimates store p04
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<=.50 & norminc>=-.50, robust
estimates store p05
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*linear
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p11
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p12
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p13
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p14
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p15
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*quadratic
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p21
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p22
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p23
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p24
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p25
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*cubic
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p31
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p32
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p33
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p34
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 r3 l3 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p35
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

*quartic
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.02 & norminc>-.02, robust
estimates store p41
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.05 & norminc>-.05, robust
estimates store p42
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.10 & norminc>-.10, robust
estimates store p43
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.25 & norminc>-.25, robust
estimates store p44
quietly testparm _Ibins*
estadd scalar p_diff=r(p)
xi: quietly reg munaverst dum r l r2 l2 r3 l3 r4 l4 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 i.bins if norminc<.50 & norminc>-.50, robust
estimates store p45
quietly testparm _Ibins*
estadd scalar p_diff=r(p)

esttab p01 p02 p03 p04 p05, keep(dum) stats(p_diff) br
esttab p11 p12 p13 p14 p15, keep(dum) stats(p_diff) br
esttab p21 p22 p23 p24 p25, keep(dum) stats(p_diff) br
esttab p31 p32 p33 p34 p35, keep(dum) stats(p_diff) br
esttab p41 p42 p43 p44 p45, keep(dum) stats(p_diff) br

log close
restore

****Table 6

***Child outcomes -- linear regressions -- BW .1 -- with controls
***by subgroups. Changes in cutoffs over time, large vs small price jumps, cutoff at low vs high levels of family income

preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

gen change9397=((mcutoff197-mcutoff193)/mcutoff193)
sum change9397
codebook change9397 if norminc<.1 & norminc>-.1

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

*by changes in cutoffs
*linear - BW .1
* no change
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if change9397<=.05 & change9397!=. & norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if change9397<=.05 & change9397!=. & norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if change9397<=.05 & change9397!=. & norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*change
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if change9397>.05 & change9397!=. & norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if change9397>.05 & change9397!=. & norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if change9397>.05 & change9397!=. & norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
restore


****by difference in prices

preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l


sum cc5fs if diffprice5>=500 & diffprice5!=. & norminc<.1 & norminc>-.1
sum cc5fs if  diffprice5<500 & norminc<.1 & norminc>-.1
*BIG diff
*linear - BW .1
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if diffprice5>=500 & diffprice5!=. & norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if diffprice5>=500 & diffprice5!=. & norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if diffprice5>=500 & diffprice5!=. & norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*SMALL diff
*linear - BW .1
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if diffprice5<500 & diffprice5!=. & norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if diffprice5<500 & diffprice5!=. & norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if diffprice5<500 & diffprice5!=. & norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
restore

****by size of cutoffs
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

keep if norminc<.1 & norminc>-.1
sort mcutoff51
gen cut=group(2)


sum cc5fs if cut==1 & norminc<.1 & norminc>-.1
sum cc5fs if cut==2 & norminc<.1 & norminc>-.1
*cutoff low levels of family income
*linear - BW .1
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if cut==1 & norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if cut==1 & norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if cut==1 & norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*cutoff higher levels of family income
*linear - BW .1
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if cut==2 & norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if cut==2 & norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if cut==2 & norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

log close
restore


****Table 7

***Mechanisms -- linear regressions -- BW .1 -- with controls

log using /home1/katrine/ccsubsidies/reviserestat201212.log, replace
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen netinc=faminc5_1-(PRICE5_1*12)
gen netincln=ln(netinc)
replace PRICE5_1=PRICE5_1*12
gen minc5ln=ln(minc5)
gen finc5ln=ln(finc5)

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l


*linear - BW .1
xi: quietly reg cc5fs dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg PRICE5_1 dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg netincln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3
xi: quietly reg mwork52G dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m4
xi: quietly reg fwork52G dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m5
xi: quietly reg mpart5 dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m6
xi: quietly reg minc5ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m7
xi: quietly reg finc5ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m8

esttab m1 m2 m3 m4, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m5 m6 m7 m8, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .25
xi: quietly reg cc5fs dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg PRICE5_1 dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg netincln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3
xi: quietly reg mwork52G dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m4
xi: quietly reg fwork52G dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m5
xi: quietly reg mpart5 dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m6
xi: quietly reg minc5ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m7
xi: quietly reg finc5ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m8

esttab m1 m2 m3 m4, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m5 m6 m7 m8, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .6
xi: quietly reg cc5fs dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg PRICE5_1 dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg netincln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3
xi: quietly reg mwork52G dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m4
xi: quietly reg fwork52G dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m5
xi: quietly reg mpart5 dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m6
xi: quietly reg minc5ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m7
xi: quietly reg finc5ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m8

esttab m1 m2 m3 m4, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m5 m6 m7 m8, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .1
xi: quietly reg cc5fs dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg PRICE5_1 dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg netincln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3
xi: quietly reg mwork52G dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m4
xi: quietly reg fwork52G dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m5
xi: quietly reg mpart5 dum r l  r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m6
xi: quietly reg minc5ln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m7
xi: quietly reg finc5ln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m8

esttab m1 m2 m3 m4, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m5 m6 m7 m8, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .25
xi: quietly reg cc5fs dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg PRICE5_1 dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg netincln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3
xi: quietly reg mwork52G dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m4
xi: quietly reg fwork52G dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m5
xi: quietly reg mpart5 dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m6
xi: quietly reg minc5ln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m7
xi: quietly reg finc5ln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m8

esttab m1 m2 m3 m4, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m5 m6 m7 m8, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*qudratic - BW .6
xi: quietly reg cc5fs dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg PRICE5_1 dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg netincln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3
xi: quietly reg mwork52G dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m4
xi: quietly reg fwork52G dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m5
xi: quietly reg mpart5 dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m6
xi: quietly reg minc5ln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m7
xi: quietly reg finc5ln dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m8

esttab m1 m2 m3 m4, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m5 m6 m7 m8, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

log close
restore

**long term effects on family income
log using /home1/katrine/ccsubsidies/reviserestat201212.log, replace
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen netinc=faminc5_1-(PRICE5_1*12)
gen netincln=ln(netinc)
replace PRICE5_1=PRICE5_1*12
gen minc5ln=ln(minc5)
gen finc5ln=ln(finc5)

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l


*linear - BW .1
xi: quietly reg faminc615ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg faminc6_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m2
xi: quietly reg faminc6_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m3
xi: quietly reg faminc7_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m4
xi: quietly reg faminc7_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m5

esttab m1 m2 m3 m4 m5, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .25
xi: quietly reg faminc615ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg faminc6_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m2
xi: quietly reg faminc6_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m3
xi: quietly reg faminc7_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m4
xi: quietly reg faminc7_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m5

esttab m1 m2 m3 m4 m5, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .5
xi: quietly reg faminc615ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg faminc6_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m2
xi: quietly reg faminc6_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m3
xi: quietly reg faminc7_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m4
xi: quietly reg faminc7_1ln dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m5

esttab m1 m2 m3 m4 m5, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .1
xi: quietly reg faminc615ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg faminc6_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m2
xi: quietly reg faminc6_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m3
xi: quietly reg faminc7_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m4
xi: quietly reg faminc7_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m5

esttab m1 m2 m3 m4 m5, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .25
xi: quietly reg faminc615ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg faminc6_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m2
xi: quietly reg faminc6_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m3
xi: quietly reg faminc7_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m4
xi: quietly reg faminc7_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m5

esttab m1 m2 m3 m4 m5, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .5
xi: quietly reg faminc615ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg faminc6_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m2
xi: quietly reg faminc6_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m3
xi: quietly reg faminc7_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5 & (foedselsaar==1986|foedselsaar==1987|foedselsaar==1988|foedselsaar==1989|foedselsaar==1990), robust
estimates store m4
xi: quietly reg faminc7_1ln dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5 & (foedselsaar==1991|foedselsaar==1992), robust
estimates store m5

esttab m1 m2 m3 m4 m5, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


log close
restore


***Table 8: effects on older siblings

log using /home1/katrine/ccsubsidies/reviserestat201212.log, replace
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

egen stpaversosoldst = std(stpaversosold)
egen skraversosoldst = std(skraversosold)
egen munaversosoldst = std(munaversosold)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

*linear - BW .1
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .25
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .5
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .1
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .25
xi: quietly reg stpaverst dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .5
xi: quietly reg stpaverst dum r l  r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


restore

***Appendix Table 1: definitions of child care coverage
*see do-file on variables

***Appendix Table 2: Distribution of student performance

*total sample
tab skraver
tab munaver
tab stpaver

*.5 sample
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>0.5
drop if norminc<-.5

tab skraver
tab munaver
tab stpaver

restore

*.1 sample
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>0.1
drop if norminc<-.1

tab skraver
tab munaver
tab stpaver

restore


***Appendix Table 3

preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

xi: quietly reg stpaverst faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5
predict stpaversthat
xi: quietly reg stpaverst faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5, robust
predict stpaverpred
xi: reg skraverst faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5, robust
predict skraverpred
xi: reg munaverst faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5, robust
predict munaverpred

replace faminc13_1=ln(faminc13_1)


*linear .1
xi: quietly reg meduyb dum r l if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg feduyb dum r l if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg mageb dum r l if norminc<.1 & norminc>-.1, robust
estimates store m3
xi: quietly reg fageb dum  r l if norminc<.1 & norminc>-.1, robust
estimates store m4
xi: quietly reg mimmigrantb dum r l if norminc<.1 & norminc>-.1, robust
estimates store m5
xi: quietly reg fimmigrantb  dum r l if norminc<.1 & norminc>-.1, robust
estimates store m6
xi: quietly reg marrcohb dum r l if norminc<.1 & norminc>-.1, robust
estimates store m7
xi: quietly reg mwelfare4 dum r l  if norminc<.1 & norminc>-.1, robust
estimates store m8
xi: quietly reg student4 dum r l  if norminc<.1 & norminc>-.1, robust
estimates store m9
xi: quietly reg faminc13_1 dum  r l if norminc<.1 & norminc>-.1, robust
estimates store m10
xi: quietly reg stpaverpred dum r l if norminc<.1 & norminc>-.1, robust
estimates store m11
xi: quietly reg skraverpred dum r l if norminc<.1 & norminc>-.1, robust
estimates store m12
xi: quietly reg munaverpred dum r l if norminc<.1 & norminc>-.1, robust
estimates store m13

esttab m1 m2 m3 m4 m5 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m6 m7 m8 m9 m10 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .25
xi: quietly reg meduyb dum r l  if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg feduyb dum  r l if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg mageb dum r l if norminc<.25 & norminc>-.25, robust
estimates store m3
xi: quietly reg fageb dum r l  if norminc<.25 & norminc>-.25, robust
estimates store m4
xi: quietly reg mimmigrantb dum r l if norminc<.25 & norminc>-.25, robust
estimates store m5
xi: quietly reg fimmigrantb dum r l if norminc<.25 & norminc>-.25, robust
estimates store m6
xi: quietly reg marrcohb dum r l if norminc<.25 & norminc>-.25, robust
estimates store m7
xi: quietly reg mwelfare4 dum r l  if norminc<.25 & norminc>-.25, robust
estimates store m8
xi: quietly reg student4 dum r l  if norminc<.25 & norminc>-.25, robust
estimates store m9
xi: quietly reg faminc13_1 dum r l  if norminc<.25 & norminc>-.25, robust
estimates store m10
xi: quietly reg stpaverpred dum r l  if norminc<.25 & norminc>-.25, robust
estimates store m11
xi: quietly reg skraverpred dum r l  if norminc<.25 & norminc>-.25, robust
estimates store m12
xi: quietly reg munaverpred dum  r l if norminc<.25 & norminc>-.25, robust
estimates store m13

esttab m1 m2 m3 m4 m5 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m6 m7 m8 m9 m10 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .5
xi: quietly reg meduyb dum r l  if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg feduyb dum  r l if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg mageb dum r l if norminc<.5 & norminc>-.5, robust
estimates store m3
xi: quietly reg fageb dum r l  if norminc<.5 & norminc>-.5, robust
estimates store m4
xi: quietly reg mimmigrantb dum r l if norminc<.5 & norminc>-.5, robust
estimates store m5
xi: quietly reg fimmigrantb dum r l if norminc<.5 & norminc>-.5, robust
estimates store m6
xi: quietly reg marrcohb dum r l if norminc<.5 & norminc>-.5, robust
estimates store m7
xi: quietly reg mwelfare4 dum r l  if norminc<.5 & norminc>-.5, robust
estimates store m8
xi: quietly reg student4 dum r l  if norminc<.5 & norminc>-.5, robust
estimates store m9
xi: quietly reg faminc13_1 dum r l  if norminc<.5 & norminc>-.5, robust
estimates store m10
xi: quietly reg stpaverpred dum r l  if norminc<.5 & norminc>-.5, robust
estimates store m11
xi: quietly reg skraverpred dum r l  if norminc<.5 & norminc>-.5, robust
estimates store m12
xi: quietly reg munaverpred dum  r l if norminc<.5 & norminc>-.5, robust
estimates store m13

esttab m1 m2 m3 m4 m5 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m6 m7 m8 m9 m10 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic .1
xi: quietly reg meduyb dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg feduyb dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg mageb dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m3
xi: quietly reg fageb dum  r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m4
xi: quietly reg mimmigrantb dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m5
xi: quietly reg fimmigrantb  dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m6
xi: quietly reg marrcohb dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m7
xi: quietly reg mwelfare4 dum r l r2 l2   if norminc<.1 & norminc>-.1, robust
estimates store m8
xi: quietly reg student4 dum r l r2 l2   if norminc<.1 & norminc>-.1, robust
estimates store m9
xi: quietly reg faminc13_1 dum  r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m10
xi: quietly reg stpaverpred dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m11
xi: quietly reg skraverpred dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m12
xi: quietly reg munaverpred dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m13

esttab m1 m2 m3 m4 m5 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m6 m7 m8 m9 m10 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .25
xi: quietly reg meduyb dum r l r2 l2   if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg feduyb dum  r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg mageb dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m3
xi: quietly reg fageb dum r l r2 l2   if norminc<.25 & norminc>-.25, robust
estimates store m4
xi: quietly reg mimmigrantb dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m5
xi: quietly reg fimmigrantb dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m6
xi: quietly reg marrcohb dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m7
xi: quietly reg mwelfare4 dum r l r2 l2   if norminc<.25 & norminc>-.25, robust
estimates store m8
xi: quietly reg student4 dum r l r2 l2   if norminc<.25 & norminc>-.25, robust
estimates store m9
xi: quietly reg faminc13_1 dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m10
xi: quietly reg stpaverpred dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m11
xi: quietly reg skraverpred dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m12
xi: quietly reg munaverpred dum  r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m13

esttab m1 m2 m3 m4 m5 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m6 m7 m8 m9 m10 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .5
xi: quietly reg meduyb dum r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg feduyb dum  r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg mageb dum r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m3
xi: quietly reg fageb dum r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m4
xi: quietly reg mimmigrantb dum r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m5
xi: quietly reg fimmigrantb dum r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m6
xi: quietly reg marrcohb dum r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m7
xi: quietly reg mwelfare4 dum r l r2 l2   if norminc<.5 & norminc>-.5, robust
estimates store m8
xi: quietly reg student4 dum r l r2 l2   if norminc<.5 & norminc>-.5, robust
estimates store m9
xi: quietly reg faminc13_1 dum r l  r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m10
xi: quietly reg stpaverpred dum r l r2 l2   if norminc<.5 & norminc>-.5, robust
estimates store m11
xi: quietly reg skraverpred dum r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m12
xi: quietly reg munaverpred dum  r l r2 l2  if norminc<.5 & norminc>-.5, robust
estimates store m13

esttab m1 m2 m3 m4 m5 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m6 m7 m8 m9 m10 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
esttab m11 m12 m13, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

***Appendix Table 4: additional balancing tests

log using /home1/katrine/ccsubsidies/reviserestat201212.log, replace
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51
replace faminc13_1=ln(faminc13_1)

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

*linear - BW .1
xi: quietly reg dum1 dum r l if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg dum2 dum r l if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg dum3 dum r l if norminc<.1 & norminc>-.1, robust
estimates store m3
xi: quietly reg dum4 dum r l if norminc<.1 & norminc>-.1, robust
estimates store m4

esttab m1 m2 m3 m4, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*linear - BW .25
xi: quietly reg dum1 dum r l if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg dum2 dum r l if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg dum3 dum r l if norminc<.25 & norminc>-.25, robust
estimates store m3
xi: quietly reg dum4 dum r l if norminc<.25 & norminc>-.25, robust
estimates store m4

esttab m1 m2 m3 m4 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .5
xi: quietly reg dum1 dum r l if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg dum2 dum r l if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg dum3 dum r l if norminc<.5 & norminc>-.5, robust
estimates store m3
xi: quietly reg dum4 dum r l if norminc<.5 & norminc>-.5, robust
estimates store m4

esttab m1 m2 m3 m4 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .1
xi: quietly reg dum1 dum r l r2 l2 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg dum2 dum r l r2 l2  if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg dum3 dum r l r2 l2 if norminc<.1 & norminc>-.1, robust
estimates store m3
xi: quietly reg dum4 dum r l r2 l2 if norminc<.1 & norminc>-.1, robust
estimates store m4

esttab m1 m2 m3 m4, keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*quadratic - BW .25
xi: quietly reg dum1 dum r l r2 l2 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg dum2 dum r l r2 l2 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg dum3 dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m3
xi: quietly reg dum4 dum r l r2 l2  if norminc<.25 & norminc>-.25, robust
estimates store m4

esttab m1 m2 m3 m4 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .5
xi: quietly reg dum1 dum r l r2 l2 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg dum2 dum r l r2 l2 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg dum3 dum r l r2 l2 if norminc<.5 & norminc>-.5, robust
estimates store m3
xi: quietly reg dum4 dum r l r2 l2 if norminc<.5 & norminc>-.5, robust
estimates store m4

esttab m1 m2 m3 m4 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


***Appendix table 5: placebo flat price

preserve
set more off
set matsize 1200

drop if faminc5yb_1>1000000
egen mcutoff51m=mean(mcutoff51)
replace mcutoff51=mcutoff51m if kom5steep==0
keep if kom5steep==0

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.

sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

keep stpaverst skraverst munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb foedselsaar mkom5 norminc

*linear - BW .1
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .25
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*linear - BW .5
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .1
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*quadratic - BW .25
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*qudartic - BW .5
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


restore

***Appendix Table 6- move cutoff and window

***-5 %
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

replace norminc=norminc+.05

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.


sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

keep stpaverst skraverst munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb foedselsaar mkom5 norminc

*linear - BW .1
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*linear - BW .25
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*linear - BW .5
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*quadratic - BW .1
xi: quietly reg stpaverst dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*quadratic - BW .25
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*quadratic - BW .5
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


restore

***+5 %
preserve
set more off
set matsize 800

drop if faminc5yb_1>1000000
keep if kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
gen norminc_2=norminc*norminc
gen norminc_3=norminc*norminc*norminc
gen nfaminc03_1=faminc03_1/mcutoff51

replace norminc=norminc-.05

gen dum=1 if norminc<0
replace dum=0 if dum==.

gen duml=1 if norminc>=0
replace duml=0 if duml==.


sum norminc

egen stpaverst = std(stpaver)
egen skraverst = std(skraver)
egen munaverst = std(munaver)

*linear
gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

keep stpaverst skraverst munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb foedselsaar mkom5 norminc

*linear - BW .1
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*linear - BW .25
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*linear - BW .5
xi: quietly reg stpaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg skraverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg munaverst dum r l faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*quadratic - BW .1
xi: quietly reg stpaverst dum r l r2 l2  faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.1 & norminc>-.1, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*quadratic - BW .25
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.25 & norminc>-.25, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*quadratic - BW .5
xi: quietly reg stpaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m1
xi: quietly reg skraverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m2
xi: quietly reg munaverst dum r l r2 l2 faminc13_1 mwelfare4 student4 marrcohb meduyb feduyb mageb fageb mimmigrantb fimmigrantb i.foedselsaar*i.mkom5 if norminc<.5 & norminc>-.5, robust
estimates store m3

esttab m1 m2 m3 , keep(dum) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


restore



****figure 1: map

****figure 2: children's outcomes

*grade point average4
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.
egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (lfit stpst norminc if dum==1, lpattern(solid)) (lfit stpst norminc if dum==0, lpattern(solid))  (lfitci stpst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci stpst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average)  legend(off)
graph save "/home1/katrine/childcare/win1_stp110113.gph", replace
graph export  /home1/katrine/childcare/win1_stp110113.png, replace
restore

*window .5
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.5
drop if norminc<-.5
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.
egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.5(.05)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.05).5{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min

sort mnorminc
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (lfit stpst norminc if dum==1, lpattern(solid)) (lfit stpst norminc if dum==0, lpattern(solid))  (lfitci stpst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci stpst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.5(.1).5) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average)  legend(off)
graph save "/home1/katrine/childcare/win5_stp110113.gph", replace
graph export  /home1/katrine/childcare/win5_stp110113.png, replace
restore

*window .5 - quartic
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.5
drop if norminc<-.5
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.
egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.5(.05)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.05).5{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min

gen duml=1 if norminc>=0
replace duml=0 if duml==.

gen r=norminc*dum
gen l=norminc*duml

*quadratic
gen r2=r*r
gen l2=l*l

*cubic
gen r3=r*r*r
gen l3=l*l*l

*quartic
gen r4=r*r*r*r
gen l4=l*l*l*l

*calculate standard error

reg stpst r r2 r3 r4 if dum==1
matrix list e(V)
matrix V=e(V)
scalar varr=V[1,1]
scalar varr2=V[2,2]
scalar varr3=V[3,3]
scalar varr4=V[4,4]
scalar varcons=V[5,5]
scalar covconsr=V[5,1]
scalar covconsr2=V[5,2]
scalar covconsr3=V[5,3]
scalar covconsr4=V[5,4]
scalar covrcons=V[5,1]
scalar covrr2=V[2,1]
scalar covrr3=V[3,1]
scalar covrr4=V[4,1]
scalar covr2cons=V[5,2]
scalar covr2r=V[2,1]
scalar covr2r3=V[3,2]
scalar covr2r4=V[4,2]
scalar covr3cons=V[5,3]
scalar covr3r=V[3,1]
scalar covr3r2=V[3,2]
scalar covr3r4=V[4,3]
scalar covr4cons=V[5,4]
scalar covr4r=V[4,1]
scalar covr4r2=V[4,2]
scalar covr4r3=V[4,3]

gen vartotr=varcons+(r^2*varr)+(r^4*varr2)+(r^6*varr3)+(r^8*varr4)+(r*covconsr)+(r^2*covconsr2)+(r^3*covconsr3)+(r^4*covconsr4)+(r*covrcons)+(r^2*covrr2)+(r^4*covrr3)+(r^5*covrr4)+(r^2*covr2cons)+(r^3*covr2r)+(r^5*covr2r3)+(r^6*covr2r4)+(r^3*covr3cons)+(r^4*covr3r)+(r^5*covr3r2)+(r^7*covr3r4)+(r^4*covr4cons)+(r^5*covr4r)+(r^6*covr4r2)+(r^7*covr4r3)
gen sdtotr=sqrt(vartotr)

reg stpst l l2 l3 l4 if dum==0

matrix list e(V)
matrix V=e(V)
scalar varl=V[1,1]
scalar varl2=V[2,2]
scalar varl3=V[3,3]
scalar varl4=V[4,4]
scalar varcons=V[5,5]
scalar covconsl=V[5,1]
scalar covconsl2=V[5,2]
scalar covconsl3=V[5,3]
scalar covconsl4=V[5,4]
scalar covlcons=V[5,1]
scalar covll2=V[2,1]
scalar covll3=V[3,1]
scalar covll4=V[4,1]
scalar covl2cons=V[5,2]
scalar covl2l=V[2,1]
scalar covl2l3=V[3,2]
scalar covl2l4=V[4,2]
scalar covl3cons=V[5,3]
scalar covl3l=V[3,1]
scalar covl3l2=V[3,2]
scalar covl3l4=V[4,3]
scalar covl4cons=V[5,4]
scalar covl4l=V[4,1]
scalar covl4l2=V[4,2]
scalar covl4l3=V[4,3]

gen vartotl=varcons+(l^2*varl)+(l^4*varl2)+(l^6*varl3)+(l^8*varl4)+(l*covconsl)+(l^2*covconsl2)+(l^3*covconsl3)+(l^4*covconsl4)+(l*covlcons)+(l^2*covll2)+(l^4*covll3)+(l^5*covll4)+(l^2*covl2cons)+(l^3*covl2l)+(l^5*covl2l3)+(l^6*covl2l4)+(l^3*covl3cons)+(l^4*covl3l)+(l^5*covl3l2)+(l^7*covl3l4)+(l^4*covl4cons)+(l^5*covl4l)+(l^6*covl4l2)+(l^7*covl4l3)
gen sdtotl=sqrt(vartotl)



reg stpst r r2 r3 r4 if dum==1
gen kat1=_b[_cons]+(_b[r]*r)+(_b[r2]*r2)+(_b[r3]*r3)+(_b[r4]*r4)
gen katse1u=kat1+(1.96*sdtotr)
gen katse1l=kat1-(1.96*sdtotr)
reg stpst l l2 l3 l4 if dum==0
gen kat2=_b[_cons]+(_b[l]*l)+(_b[l2]*l2)+(_b[l3]*l3)+(_b[l4]*l4)
gen katse2u=kat2+(1.96*sdtotl)
gen katse2l=kat2-(1.96*sdtotl)

sum kat1 katse1u katse1l kat2 katse2u katse2l r r2 r3 r4 l l2 l3 l4

sort mnorminc

*twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (line kat1 norminc if dum==1, lcolor(black)  lpattern(solid)) (line kat2 norminc if dum==0, lcolor(black) lpattern(solid)) (line katse2u norminc if dum==0, lcolor(black) lpattern(dash)) (line katse2l norminc if dum==0, lcolor(black) lpattern(dash)) , xline(0) xtitle(normalized income) xlabel(-.5(.1).5) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average)  legend(off)
*twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (line kat1 norminc if dum==1, lcolor(black)  lpattern(solid)) (line kat2 norminc if dum==0, lcolor(black) lpattern(solid)) (line katse1u norminc if dum==1, lcolor(black) lpattern(dash)) (line katse1l norminc if dum==1, lcolor(black) lpattern(dash)) , xline(0) xtitle(normalized income) xlabel(-.5(.1).5) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average)  legend(off)
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (line kat1 norminc if dum==1, lcolor(black)  lpattern(solid)) (line kat2 norminc if dum==0, lcolor(black) lpattern(solid)) (line katse1u norminc if dum==1, lcolor(black) lpattern(dash)) (line katse1l norminc if dum==1, lcolor(black) lpattern(dash))  (line katse2u norminc if dum==0, lcolor(black) lpattern(dash)) (line katse2l norminc if dum==0, lcolor(black) lpattern(dash)) , xline(0) xtitle(normalized income) xlabel(-.5(.1).5) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average)  legend(off)
graph save "/home1/katrine/childcare/win5_quartic_stp110113.gph", replace
graph export  /home1/katrine/childcare/win5_quartic_stp110113.png, replace
restore

*written exam
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if skraver==.
egen skrst = std(skraver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mskrst=mean(skrst)

egen a=mean(skrst)
egen b=sd(skrst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mskrst mnorminc, mcolor(black) msize(small)) (lfit skrst norminc if dum==1, lpattern(solid)) (lfit skrst norminc if dum==0, lpattern(solid))  (lfitci skrst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci skrst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Written exam)  legend(off)
graph save "/home1/katrine/childcare/win1_skr110113.gph", replace
graph export  /home1/katrine/childcare/win1_skr110113.png, replace
restore

*window .5
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.5
drop if norminc<-.5
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if skraver==.
egen skrst = std(skraver)
sort norminc
gen g100=.
forvalues i=-.5(.05)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.05).5{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mskrst=mean(skrst)

egen a=mean(skrst)
egen b=sd(skrst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mskrst mnorminc, mcolor(black) msize(small)) (lfit skrst norminc if dum==1, lpattern(solid)) (lfit skrst norminc if dum==0, lpattern(solid))  (lfitci skrst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci skrst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.5(.1).5) ylabel(-1(.2)1) ytitle(standardized test score) title(Written exam)  legend(off)
graph save "/home1/katrine/childcare/win5_skr110113.gph", replace
graph export  /home1/katrine/childcare/win5_skr110113.png, replace
restore

*window .5 - no polynomial
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.5
drop if norminc<-.5
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if skraver==.
egen skrst = std(skraver)
sort norminc
gen g100=.
forvalues i=-.5(.05)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.05).5{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mskrst=mean(skrst)

egen a=mean(skrst)
egen b=sd(skrst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min

reg skrst  if dum==1
gen kat1=_b[_cons]
gen katse1u=_b[_cons]+(1.96*_se[_cons])
gen katse1l=_b[_cons]-(1.96*_se[_cons])
reg skrst  if dum==0
gen kat2=_b[_cons]
gen katse2u=_b[_cons]+(1.96*_se[_cons])
gen katse2l=_b[_cons]-(1.96*_se[_cons])

sort mnorminc
twoway (scatter mskrst mnorminc, mcolor(black) msize(small)) (line kat1 norminc if dum==1, lcolor(black)  lpattern(solid)) (line kat2 norminc if dum==0, lcolor(black) lpattern(solid)) (line katse1u norminc if dum==1, lcolor(black) lpattern(dash)) (line katse1l norminc if dum==1, lcolor(black) lpattern(dash))  (line katse2u norminc if dum==0, lcolor(black) lpattern(dash)) (line katse2l norminc if dum==0, lcolor(black) lpattern(dash)) , xline(0) xtitle(normalized income) xlabel(-.5(.1).5) ylabel(-1(.2)1) ytitle(standardized test score) title(Written exam)  legend(off)
graph save "/home1/katrine/childcare/win5_nopoly_skr110113.gph", replace
graph export  /home1/katrine/childcare/win5_nopoly_skr110113.png, replace
restore


*oral exam
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if munaver==.
egen munst = std(munaver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mmunst=mean(munst)

egen a=mean(munst)
egen b=sd(munst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mmunst mnorminc, mcolor(black) msize(small)) (lfit munst norminc if dum==1, lpattern(solid)) (lfit munst norminc if dum==0, lpattern(solid))  (lfitci munst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci munst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Oral exam)  legend(off)
graph save "/home1/katrine/childcare/win1_mun110113.gph", replace
graph export  /home1/katrine/childcare/win1_mun110113.png, replace
restore

*window .5
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.5
drop if norminc<-.5
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if munaver==.
egen munst = std(munaver)
sort norminc
gen g100=.
forvalues i=-.5(.05)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.05).5{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mmunst=mean(munst)

egen a=mean(munst)
egen b=sd(munst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mmunst mnorminc, mcolor(black) msize(small)) (lfit munst norminc if dum==1, lpattern(solid)) (lfit munst norminc if dum==0, lpattern(solid))  (lfitci munst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci munst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.5(.1).5) ylabel(-1(.2)1) ytitle(standardized test score) title(Oral exam)  legend(off)
graph save "/home1/katrine/childcare/win5_mun110113.gph", replace
graph export  /home1/katrine/childcare/win5_mun110113.png, replace
restore




****figure 3: mechanisms

*child care attendance
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if cc5fs==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mcc5fs=mean(cc5fs)

egen a=mean(cc5fs)
egen b=sd(cc5fs)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mcc5fs mnorminc, mcolor(black) msize(small)) (lfit cc5fs norminc if dum==1, lpattern(solid)) (lfit cc5fs norminc if dum==0, lpattern(solid))  (lfitci cc5fs norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci cc5fs norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(.05(.1)1.05) ytitle(fraction in child care) title(Child care attendance)  legend(off)
graph save "/home1/katrine/childcare/win1_cc5fs110113.gph", replace
graph export  /home1/katrine/childcare/win1_cc5fs110113.png, replace
restore

*price of child care attendance
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
replace PRICE5_1=PRICE5_1/100
drop if PRICE5_1==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mPRICE5_1=mean(PRICE5_1)

egen a=mean(PRICE5_1)
egen b=sd(PRICE5_1)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mPRICE5_1 mnorminc, mcolor(black) msize(small)) (lfit PRICE5_1 norminc if dum==1, lpattern(solid)) (lfit PRICE5_1 norminc if dum==0, lpattern(solid))  (lfitci PRICE5_1 norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci PRICE5_1 norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(5(3)21) ytitle(Price of child care (in 1000 NOK)) title(Yearly price of child care)  legend(off)
graph save "/home1/katrine/childcare/win1_price110113.gph", replace
graph export  /home1/katrine/childcare/win1_price110113.png, replace
restore

*net yearly income
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
gen netinc=faminc5_1-(PRICE5_1*12)
gen netincln=ln(netinc)
drop if netincln==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mnetincln=mean(netincln)

egen a=mean(netincln)
egen b=sd(netincln)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mnetincln mnorminc, mcolor(black) msize(small)) (lfit netincln norminc if dum==1, lpattern(solid)) (lfit netincln norminc if dum==0, lpattern(solid))  (lfitci netincln norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci netincln norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(11.2(.3)12.5) ytitle(income in ln) title(Ln(net income) (gross income-price of child care))  legend(off)
graph save "/home1/katrine/childcare/win1_netincln110113.gph", replace
graph export  /home1/katrine/childcare/win1_netincln110113.png, replace
restore

*mothers labour supply
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if mwork52G==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mmpart5=mean(mpart5)

egen a=mean(mpart5)
egen b=sd(mpart5)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mmpart5 mnorminc, mcolor(black) msize(small)) (lfit mpart5 norminc if dum==1, lpattern(solid)) (lfit mpart5 norminc if dum==0, lpattern(solid))  (lfitci mpart5 norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci mpart5 norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-.20(.1).55) ytitle(Fraction part time) title(Mother's work part time when child is age 5)  legend(off)
graph save "/home1/katrine/childcare/win1_mpart5110113.gph", replace
graph export  /home1/katrine/childcare/win1_mpart5110113.png, replace
restore


*mothers part time
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if mpart5==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mmwork52G=mean(mwork52G)

egen a=mean(mwork52G)
egen b=sd(mwork52G)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mmwork52G mnorminc, mcolor(black) msize(small)) (lfit mwork52G norminc if dum==1, lpattern(solid)) (lfit mwork52G norminc if dum==0, lpattern(solid))  (lfitci mwork52G norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci mwork52G norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-.12(.1).85) ytitle(Fraction working) title(Mother's labour supply when child is age 5)  legend(off)
graph save "/home1/katrine/childcare/win1_mwork52G110113.gph", replace
graph export  /home1/katrine/childcare/win1_mwork52G110113.png, replace
restore

*mothers income
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
gen minc5ln=ln(minc5)
gen finc5ln=ln(finc5)
drop if minc5ln==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mminc5ln=mean(minc5ln)

egen a=mean(minc5ln)
egen b=sd(minc5ln)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mminc5ln mnorminc, mcolor(black) msize(small)) (lfit minc5ln norminc if dum==1, lpattern(solid)) (lfit minc5ln norminc if dum==0, lpattern(solid))  (lfitci minc5ln norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci minc5ln norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(9.8(.4)12) ytitle(Income in ln) title(Ln(mother's income) when child is age 5)  legend(off)
graph save "/home1/katrine/childcare/win1_minc5ln110113.gph", replace
graph export  /home1/katrine/childcare/win1_minc5ln110113.png, replace
restore


*fathers labour supply
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if fwork52G==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mfwork52G=mean(fwork52G)

egen a=mean(fwork52G)
egen b=sd(fwork52G)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mfwork52G mnorminc, mcolor(black) msize(small)) (lfit fwork52G norminc if dum==1, lpattern(solid)) (lfit fwork52G norminc if dum==0, lpattern(solid))  (lfitci fwork52G norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci fwork52G norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(.26(.1)1.16) ytitle(Fraction working) title(Father's labour supply when child is age 5)  legend(off)
graph save "/home1/katrine/childcare/win1_fwork52G110113.gph", replace
graph export  /home1/katrine/childcare/win1_fwork52G110113.png, replace
restore

*fathers income
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
gen minc5ln=ln(minc5)
gen finc5ln=ln(finc5)
drop if finc5ln==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mfinc5ln=mean(finc5ln)

egen a=mean(finc5ln)
egen b=sd(finc5ln)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mfinc5ln mnorminc, mcolor(black) msize(small)) (lfit finc5ln norminc if dum==1, lpattern(solid)) (lfit finc5ln norminc if dum==0, lpattern(solid))  (lfitci finc5ln norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci finc5ln norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(10.6(.4)12.5) ytitle(Income in ln) title(Ln(father's income) when child is age 5)  legend(off)
graph save "/home1/katrine/childcare/win1_finc5ln110113.gph", replace
graph export  /home1/katrine/childcare/win1_finc5ln110113.png, replace
restore


*****Appendix Figure 2: balancing tests
*mothers education when child is born
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if meduyb==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mmeduyb=mean(meduyb)

egen a=mean(meduyb)
egen b=sd(meduyb)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mmeduyb mnorminc, mcolor(black) msize(small)) (lfit meduyb norminc if dum==1, lpattern(solid)) (lfit meduyb norminc if dum==0, lpattern(solid))  (lfitci meduyb norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci meduyb norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(6(.8)13.2) ytitle(Years of education) title(Mother's education when child is born)  legend(off)
graph save "/home1/katrine/childcare/win1_meduyb110113.gph", replace
graph export  /home1/katrine/childcare/win1_meduyb110113.png, replace
restore

*fathers education when child is born
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if feduyb==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mfeduyb=mean(feduyb)

egen a=mean(feduyb)
egen b=sd(feduyb)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mfeduyb mnorminc, mcolor(black) msize(small)) (lfit feduyb norminc if dum==1, lpattern(solid)) (lfit feduyb norminc if dum==0, lpattern(solid))  (lfitci feduyb norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci feduyb norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(6(.8)13.2) ytitle(Years of education) title(Father's education when child is born)  legend(off)
graph save "/home1/katrine/childcare/win1_feduyb110113.gph", replace
graph export  /home1/katrine/childcare/win1_feduyb110113.png, replace
restore

*mothers age when child is born
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if mageb==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mmageb=mean(mageb)

egen a=mean(mageb)
egen b=sd(mageb)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mmageb mnorminc, mcolor(black) msize(small)) (lfit mageb norminc if dum==1, lpattern(solid)) (lfit mageb norminc if dum==0, lpattern(solid))  (lfitci mageb norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci mageb norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(20.7(2)30.7) ytitle(Years) title(Mother's age when child is born)  legend(off)
graph save "/home1/katrine/childcare/win1_mageb110113.gph", replace
graph export  /home1/katrine/childcare/win1_mageb110113.png, replace
restore

*fathers age when child is born
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if fageb==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mfageb=mean(fageb)

egen a=mean(fageb)
egen b=sd(fageb)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min

sort mnorminc
twoway (scatter mfageb mnorminc, mcolor(black) msize(small)) (lfit fageb norminc if dum==1, lpattern(solid)) (lfit fageb norminc if dum==0, lpattern(solid))  (lfitci fageb norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci fageb norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(22.9(2)34.9) ytitle(Years) title(Father's age when child is born)  legend(off)
graph save "/home1/katrine/childcare/win1_fageb110113.gph", replace
graph export  /home1/katrine/childcare/win1_fageb110113.png, replace
restore

*mother immigrant when child is born
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if mimmigrantb==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mmimmigrantb=mean(mimmigrantb)

egen a=mean(mimmigrantb)
egen b=sd(mimmigrantb)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min

sort mnorminc
twoway (scatter mmimmigrantb mnorminc, mcolor(black) msize(small)) (lfit mimmigrantb norminc if dum==1, lpattern(solid)) (lfit mimmigrantb norminc if dum==0, lpattern(solid))  (lfitci mimmigrantb norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci mimmigrantb norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-.21(.1).59) ytitle(fraction non-Norwegian citizen) title(Mother non-Norwegian citizen when child is born)  legend(off)
graph save "/home1/katrine/childcare/win1_mimmigrantb110113.gph", replace
graph export  /home1/katrine/childcare/win1_mimmigrantb110113.png, replace
restore

*father immigrant when child is born
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if fimmigrantb==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mfimmigrantb=mean(fimmigrantb)

egen a=mean(fimmigrantb)
egen b=sd(fimmigrantb)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min

sort mnorminc
twoway (scatter mfimmigrantb mnorminc, mcolor(black) msize(small)) (lfit fimmigrantb norminc if dum==1, lpattern(solid)) (lfit fimmigrantb norminc if dum==0, lpattern(solid))  (lfitci fimmigrantb norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci fimmigrantb norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-.20(.1).60) ytitle(fraction non-Norwegian citizen) title(Father non-Norwegian citizen when child is born)  legend(off)
graph save "/home1/katrine/childcare/win1_fimmigrantb110113.gph", replace
graph export  /home1/katrine/childcare/win1_fimmigrantb110113.png, replace
restore

*married/cohabiting
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if marrcohb==.
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mmarrcohb=mean(marrcohb)

egen a=mean(marrcohb)
egen b=sd(marrcohb)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min

sort mnorminc
twoway (scatter mmarrcohb mnorminc, mcolor(black) msize(small)) (lfit marrcohb norminc if dum==1, lpattern(solid)) (lfit marrcohb norminc if dum==0, lpattern(solid))  (lfitci marrcohb norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci marrcohb norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(.27(.1)1.17) ytitle(fraction married/cohabiting) title(Married/cohabiting child is born)  legend(off)
graph save "/home1/katrine/childcare/win1_marrcohb110113.gph", replace
graph export  /home1/katrine/childcare/win1_marrcohb110113.png, replace
restore



****Appendix Figure 3: by price jumps

*grade point average
*small changes in cutoffs
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.

gen change9397=((mcutoff197-mcutoff193)/mcutoff193)
sum change9397
codebook change9397 if norminc<.1 & norminc>-.1
keep if change9397<.05 

egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min



sort mnorminc
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (lfit stpst norminc if dum==1, lpattern(solid)) (lfit stpst norminc if dum==0, lpattern(solid))  (lfitci stpst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci stpst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average - small changes in cutoffs)  legend(off)
graph save "/home1/katrine/childcare/win1_smallchanges_stp110113.gph", replace
graph export  /home1/katrine/childcare/win1_smallchanges_stp110113.png, replace
restore

*big changes in cutoffs
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.

gen change9397=((mcutoff197-mcutoff193)/mcutoff193)
sum change9397
codebook change9397 if norminc<.1 & norminc>-.1
keep if change9397>=.05 & change9397!=. 

egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (lfit stpst norminc if dum==1, lpattern(solid)) (lfit stpst norminc if dum==0, lpattern(solid))  (lfitci stpst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci stpst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average - big changes in cutoffs)  legend(off)
graph save "/home1/katrine/childcare/win1_bigchanges_stp110113.gph", replace
graph export  /home1/katrine/childcare/win1_bigchanges_stp110113.png, replace
restore


*grade point average
*large price jumps
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.
keep if diffprice>=500 & diffprice!=.
egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (lfit stpst norminc if dum==1, lpattern(solid)) (lfit stpst norminc if dum==0, lpattern(solid))  (lfitci stpst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci stpst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average - large price jumps)  legend(off)
graph save "/home1/katrine/childcare/win1_diffpricebig_stp110113.gph", replace
graph export  /home1/katrine/childcare/win1_diffpricebig_stp110113.png, replace
restore

*small price jumps
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1
gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.
keep if diffprice<500 & diffprice!=.
egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (lfit stpst norminc if dum==1, lpattern(solid)) (lfit stpst norminc if dum==0, lpattern(solid))  (lfitci stpst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci stpst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average - small price jumps)  legend(off)
graph save "/home1/katrine/childcare/win1_diffpricesmall_stp110113.gph", replace
graph export  /home1/katrine/childcare/win1_diffpricesmall_stp110113.png, replace
restore

*low levels of family income
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1

sort mcutoff51
gen cut=group(2)

gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.
keep if cut==1
egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (lfit stpst norminc if dum==1, lpattern(solid)) (lfit stpst norminc if dum==0, lpattern(solid))  (lfitci stpst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci stpst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average - cutoff at low levels of family income)  legend(off)
graph save "/home1/katrine/childcare/win1_cutlow_stp110113.gph", replace
graph export  /home1/katrine/childcare/win1_cutlow_stp110113.png, replace
restore

*higher levels of family income
*window .1
preserve
set more off
set matsize 800
drop if faminc5yb_1>1000000
keep if  kom5steep==1

gen norminc=faminc5yb_1/mcutoff51
replace norminc=norminc-1
drop if norminc>.1
drop if norminc<-.1

sort mcutoff51
gen cut=group(2)

gen dum=1 if norminc<0
replace dum=0 if dum==.
drop if stpaver==.
keep if cut==2
egen stpst = std(stpaver)
sort norminc
gen g100=.
forvalues i=-.1(.01)0{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
forvalues i=0(.01).1{ 
replace g100=`i' if norminc>=`i' & norminc<`i'+1
}
sort g100
by g100: egen mnorminc=mean(norminc)
sort mnorminc
by mnorminc: egen mstpst=mean(stpst)

egen a=mean(stpst)
egen b=sd(stpst)
gen max=a+(1*b)
gen min=a-(1*b)
sum max min


sort mnorminc
twoway (scatter mstpst mnorminc, mcolor(black) msize(small)) (lfit stpst norminc if dum==1, lpattern(solid)) (lfit stpst norminc if dum==0, lpattern(solid))  (lfitci stpst norminc if dum==1, lpattern(dash) lcolor(black) ciplot(rline)) (lfitci stpst norminc if dum==0, lcolor(black) lpattern(dash) ciplot(rline)) , xline(0) xtitle(normalized income) xlabel(-.1(.02).1) ylabel(-1(.2)1) ytitle(standardized test score) title(Grade point average - cutoff at higher levels of family income)  legend(off)
graph save "/home1/katrine/childcare/win1_cuthigh_stp110113.gph", replace
graph export  /home1/katrine/childcare/win1_cuthigh_stp110113.png, replace
restore
