drop _all
capture clear matrix
set more off
set virtual on
set memory 3g
set matsize 2000
set logtype text
capture log close
log using APE-eqn1, replace

use world_child3

**************************

/*

This do file calculates the average partial effects estimates of Equation 1.

> For each X(it), calculate the deviation as X(i)-X. This is interacted with height. Run with (A)  height and (B) height dummies. 
> For comparison, also calculate equation 1 without controls and with controls.

*/

**************************

** keep only children with full exposure

tab infant_exp
keep if infant_exp==1

keep caseid2 malec urban christian muslim otherrel religionmiss cbirthmth1-cbirthmth12 chld1 chld2 chld3 chldm4 age915 age1618 age1924 age2530 age3149 educf1-educf4 educm1-educm4 countryid yearc infant height100 lgdp country tallhalf tall1 tall2 shorthalf short1 short2

rename height100 H
rename lgdp Y
rename tallhalf Th
rename tall1 T1
rename tall2 T2
rename shorthalf Sh
rename short1 S1
rename short2 S2

foreach x of varlist H Y Th T1 T2 Sh S1 S2 {
	gen `x'Y=`x'*Y
	}

des *Y

* generate dummies in order to be able to demean
tab country, gen(countrynum)
tab yearc, gen(yearc)

global chcontrols malec cbirthmth2-cbirthmth12 chld2 chld3 chldm4 age915 age1618 age2530 age3149
global macontrols urban christian muslim otherrel educf2-educf4 educm2-educm4
compress

foreach var of varlist $chcontrols age1924 cbirthmth1 chld1 {
	bys caseid2: egen `var'_mean=mean(`var')
	gen `var'D=`var'-`var'_mean
	list `var' `var'D in 1
	foreach x of varlist H Y Th T1 T2 Sh S1 S2 {
	gen `var'D`x'=`var'D*`x'
	}
	}

foreach var of varlist $macontrols educf1 educm1 religionmiss {
	sum `var'
	local `var'_mean=r(mean)
	display ``var'_mean'
	gen `var'D=`var'-``var'_mean'
	list `var' `var'D in 1
	foreach x of varlist H Y Th T1 T2 Sh S1 S2 {
	gen `var'D`x'=`var'D*`x'
	}
	}

global controls_d *DH
global controls_d_htdummies *DTh *DT1 *DT2 *DSh *DS1 *DS2

* (A)
* (1) no controls
xi: reg infant H i.countryid*i.yearc, cluster(country)

* (2) controls
xi: reg infant H $chcontrols $macontrols i.countryid*i.yearc, cluster(country)

* (3) controls, plus H interacted with Xi - Xbar i.e. AVERAGE PARTIAL EFFECT ESTIMATES
xi: reg infant H $chcontrols $macontrols $controls_d i.countryid*i.yearc, cluster(country)

capture noisily test malecDH cbirthmth1DH cbirthmth2DH cbirthmth3DH cbirthmth4DH cbirthmth5DH cbirthmth6DH cbirthmth7DH cbirthmth8DH cbirthmth9DH cbirthmth10DH cbirthmth11DH cbirthmth12DH chld2DH chld3DH chldm4DH age915DH age1618DH age2530DH age3149DH age1924DH chld1DH urbanDH christianDH muslimDH otherrelDH educf2DH educf3DH educf4DH educm2DH educm3DH educm4DH educf1DH educm1DH religionmissDH

* (B)
* (1) equation 1, no controls
xi: reg infant Th T1 T2 Sh S1 S2 i.countryid*i.yearc, cluster(country)

* (2) equation 1, controls
xi: reg infant Th T1 T2 Sh S1 S2 $chcontrols $macontrols i.countryid*i.yearc, cluster(country)

* (3) equation 1, controls, plus H interacted with Xi - Xbar i.e. AVERAGE PARTIAL EFFECT ESTIMATES
xi: reg infant Th T1 T2 Sh S1 S2 $chcontrols $macontrols $controls_d_htdummies i.countryid*i.yearc, cluster(country)

capture noisily test malecDTh cbirthmth1DTh cbirthmth2DTh cbirthmth3DTh cbirthmth4DTh cbirthmth5DTh cbirthmth6DTh cbirthmth7DTh cbirthmth8DTh cbirthmth9DTh cbirthmth10DTh cbirthmth11DTh cbirthmth12DTh chld1DTh chld2DTh chld3DTh chldm4DTh age915DTh age1618DTh age2530DTh age3149DTh age1924DTh urbanDTh religionmissDTh christianDTh muslimDTh otherrelDTh educf1DTh educf2DTh educf3DTh educf4DTh educm1DTh educm2DTh educm3DTh educm4DTh malecDT1 cbirthmth1DT1 cbirthmth2DT1 cbirthmth3DT1 cbirthmth4DT1 cbirthmth5DT1 cbirthmth6DT1 cbirthmth7DT1 cbirthmth8DT1 cbirthmth9DT1 cbirthmth10DT1 cbirthmth11DT1 cbirthmth12DT1 chld1DT1 chld2DT1 chld3DT1 chldm4DT1 age915DT1 age1618DT1 age2530DT1 age3149DT1 age1924DT1 urbanDT1 religionmissDT1 christianDT1 muslimDT1 otherrelDT1 educf1DT1 educf2DT1 educf3DT1 educf4DT1 educm1DT1 educm2DT1 educm3DT1 educm4DT1 malecDT2 cbirthmth1DT2 cbirthmth2DT2 cbirthmth3DT2 cbirthmth4DT2 cbirthmth5DT2 cbirthmth6DT2 cbirthmth7DT2 cbirthmth8DT2 cbirthmth9DT2 cbirthmth10DT2 cbirthmth11DT2 cbirthmth12DT2 chld1DT2 chld2DT2 chld3DT2 chldm4DT2 age915DT2 age1618DT2 age2530DT2 age3149DT2 age1924DT2 urbanDT2 religionmissDT2 christianDT2 muslimDT2 otherrelDT2 educf1DT2 educf2DT2 educf3DT2 educf4DT2 educm1DT2 educm2DT2 educm3DT2 educm4DT2 malecDSh cbirthmth1DSh cbirthmth2DSh cbirthmth3DSh cbirthmth4DSh cbirthmth5DSh cbirthmth6DSh cbirthmth7DSh cbirthmth8DSh cbirthmth9DSh cbirthmth10DSh cbirthmth11DSh cbirthmth12DSh chld1DSh chld2DSh chld3DSh chldm4DSh age915DSh age1618DSh age2530DSh age3149DSh age1924DSh urbanDSh religionmissDSh christianDSh muslimDSh otherrelDSh educf1DSh educf2DSh educf3DSh educf4DSh educm1DSh educm2DSh educm3DSh educm4DSh malecDS1 cbirthmth1DS1 cbirthmth2DS1 cbirthmth3DS1 cbirthmth4DS1 cbirthmth5DS1 cbirthmth6DS1 cbirthmth7DS1 cbirthmth8DS1 cbirthmth9DS1 cbirthmth10DS1 cbirthmth11DS1 cbirthmth12DS1 chld1DS1 chld2DS1 chld3DS1 chldm4DS1 age915DS1 age1618DS1 age2530DS1 age3149DS1 age1924DS1 urbanDS1 religionmissDS1 christianDS1 muslimDS1 otherrelDS1 educf1DS1 educf2DS1 educf3DS1 educf4DS1 educm1DS1 educm2DS1 educm3DS1 educm4DS1 malecDS2 cbirthmth1DS2 cbirthmth2DS2 cbirthmth3DS2 cbirthmth4DS2 cbirthmth5DS2 cbirthmth6DS2 cbirthmth7DS2 cbirthmth8DS2 cbirthmth9DS2 cbirthmth10DS2 cbirthmth11DS2 cbirthmth12DS2 chld1DS2 chld2DS2 chld3DS2 chldm4DS2 age915DS2 age1618DS2 age2530DS2 age3149DS2 age1924DS2 urbanDS2 religionmissDS2 christianDS2 muslimDS2 otherrelDS2 educf1DS2 educf2DS2 educf3DS2 educf4DS2 educm1DS2 educm2DS2 educm3DS2 educm4DS2 

log close
exit
