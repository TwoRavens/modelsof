* reg_rtol.do FILE

* Regression with multiply imputed data
* shown in Tables 5, 7, S1, S3, S5, S7, S9

* It requires the "mim" and "mimstack" modules that can be installed typing "ssc install mim" and "ssc install mimstack"

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



cd "..\..\Data\Estimates\"
cd "benchmark\"
* cd "robustness_10y\"
* cd "robustness_nom\"
* cd "robustness_60obs\"
* cd "robustness_realw\"

clear
set more off
capture log close
log using "..\..\..\code\stata\Log\benchmark\reg_rtol.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_10y\reg_rtol.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_nom\reg_rtol.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_60obs\reg_rtol.txt", text replace
* log using "..\..\..\code\stata\Log\robustness_realw\reg_rtol.txt", text replace

* Generate new variables
local m 1
while `m'< 6 {
	use micro_`m'.dta, clear

	gen lnrtol0 = ln(1+rtol0)
	gen lnrtol1 = ln(1+rtol1)
	gen lnrtol2 = ln(1+rtol2)
	gen lnrtol3 = ln(1+rtol3)
	gen lnrtol32 = ln(1+rtol3)
	gen lnbias3 = ln(1+bias3)
	gen lnsd0 = ln(1+portsd0)
	gen lnsd2 = ln(1+portsd2)
	gen sel3 = (lnrtol3>0)
	gen den = .059324 + wtbond*.037295 + wtstok*.053191 + wthcap*.004006 + wtrest*.022859
	gen fit3 = bias3/den
	gen lnfit3 = ln(1+fit3)

	gen age = x8022
	gen age2 = x8022^2/100
	gen age100 = x8022/100

	gen female = (x8021==2)

	gen black = (x6809==2)
	gen hispanic = (x6809==3)
	gen nwhite = (x6809~=1) /* head is non-white */

	gen married = (x8023==1 | x8023==2) /* Married or living together */
	gen divorced = (x8023==3 | x8023==4) /* Separated or divorced */
	gen widowed = (x8023==5) /* Widowed */
	gen nevermar = (x8023==6) /* Never married */

	gen fammem = x101-1 /* Number of family members, excluding head and partner (if any) */
	replace fammem = fammem-1 if married==1
	replace fammem = 0 if fammem < 0
	gen children = fammem>0 /* If household members apart from head and spouse are present */

	gen hschool = (x5901>=8 & x5901<=12) /* Some high school */
	gen college = (x5901>=13 & x5901<=16) /* Some college */
	gen postgrad = (x5901==17) /* Some PhD */
	gen college2 = (x5901>=13 & x5901<=17) /* Some college or PhD */

	gen empl = (x4106==1) /* Employee */
	gen selfempl = (x4106==2) /* Self-employed */

	gen inco = x5702 + x5704 + x5716 + x5718 + x5720 + x5722 + x5724
	gen lnincome = ln(inco)/10
	gen hcap = wthcap*totwth
	gen lhcap = ln(hcap)/10 /* Human capital */
	gen lnfwth = ln(finwth)/10 /* Financial wealth */
	xtile fwthperc = finwth, nq(3) /* Total wealth percentiles */
	gen lnincfwth = ln(inco+finwth)/10 /* Income + financial wealth */
	gen lwth = ln(totwth)/10 /* Total wealth */
	gen lntwth = ln(totwth*(1-wthcap))/10 /* Total wealth without human capital */
	xtile twthperc3 = lntwth [pw = x42001], nq(3) /* Total wealth: 3 groups */
	xtile twthperc10 = lntwth [pw = x42001], nq(10) /* Total wealth: 10 groups */
	gen inctwth = inco+totwth*(1-wthcap)
	gen lninctwth = ln(inctwth)/10 /* Income + total wealth */
	gen agewth = age*lninctwth /* Interaction between age and total wealth */
	xtile inctwthperc3 = lninctwth [pw = x42001], nq(3) /* Total wealth: 3 groups */
	xtile inctwthperc10 = lninctwth [pw = x42001], nq(10) /* Total wealth: 10 groups */

	gen incfem = lninctwth*female /* Income for female heads */
	gen femmar = married*female /* =1 if married and female head */

	gen everinherit = (x5801==1) /* If ever inherited */
	gen weverinh = x5802 /* Number of received bequests */
	gen planinherit = (x5819==1) /* If plan to leave bequest */
	gen wplaninh = x5821/(totwth*(1-wthcap)) /* Planned inheritance size */
	gen bequestimp = (x5824<=2) /* Importance of estate bequests (in general) */
	gen planestate = (x5825==1) /* Plan to leave estate */

	gen advisor = (x7112>=8 & x7112<=12) /* Follows recommendations of a financial advisor */
	gen wkfinance = (x7402==5) /* Work in Finance */
	gen shopsaving = (x7111==4 | x7111==5) /* Moderate to high shop for saving */
	gen shopcredit = (x7100==4 | x7100==5) /* Moderate to high shop for credit */
	gen usepc = (x6497==1) /* Use of computer to manage money */
	gen nfininst = x8300 /* N. financial institutions */
	gen ncheckacc = x3504 /* N. checking accounts */

	gen health_exc = (x6030==1) /* Excellent health */
	gen future_bett = (x301==1) /* Expects the future to be better */
	gen myopic = (x3008<=2) /* Planning horizon equal or below one year */
	gen risktol = (x3014<3) /* Self-assessed risk tolerant */

	save reg_`m'.dta, replace
	local m = `m'+1
}

qui sum inco [fw = int(x42001)]
scalar minc = r(mean)
qui sum inctwth [fw = int(x42001)]
scalar mwth = r(mean)
qui sum finwth [fw = int(x42001)]
scalar mfwth = r(mean)

* Recognize the 5 datasets with imputed values
mimstack, m(5) sortorder(id) istub(reg_) nomj0


***************
* Display average values

sum portsd0 [fw = int(x42001)]
sum lnsd0 [fw = int(x42001)]
disp exp(r(mean))-1

sum rtol0 [fw = int(x42001)]
sum lnrtol0 [fw = int(x42001)]
disp exp(r(mean))-1

sum portsd2 [fw = int(x42001)]
sum lnsd2 [fw = int(x42001)]
disp exp(r(mean))-1

sum rtol2 [fw = int(x42001)]
sum lnrtol2 [fw = int(x42001)]
disp exp(r(mean))-1

sum rtol3 [fw = int(x42001)]
sum lnrtol3 [fw = int(x42001)]
disp exp(r(mean))-1

sum lnrtol32 if twthperc10 > 8 [fw = int(x42001)]
disp exp(r(mean))-1


***************
* Regression
* Preferred specification

global narrowpref age100 lnincome lnfwth children female divorced widowed nevermar nwhite hschool college2 ///
empl selfempl advisor wkfinance shopcredit usepc nfininst ///
health_exc future_bett

global broadpref age100 lnincome lntwth children female divorced widowed nevermar nwhite hschool college2 ///
empl selfempl advisor wkfinance shopcredit usepc nfininst ///
health_exc future_bett

sum lnrtol32 $broadpref if twthperc10 > 8 [fw = int(x42001)]
sum lnrtol32 $broadpref [fw = int(x42001)]

mim, category(fit): reg lnrtol0 $narrowpref if rtol0>0 [pw = x42001]
sum rtol0 [fw = int(x42001)] if rtol0 > 0
sum lnrtol0 [fw = int(x42001)] if rtol0 > 0
disp exp(r(mean))-1

mim, category(fit): reg lnrtol0 $narrowpref [pw = x42001]
sum rtol0 [fw = int(x42001)]
sum lnrtol0 [fw = int(x42001)]
disp exp(r(mean))-1

mim, category(fit): reg lnrtol2 $broadpref [pw = x42001]
sum rtol2 [fw = int(x42001)]
sum lnrtol2 [fw = int(x42001)]
disp exp(r(mean))-1

mim, category(fit): reg lnrtol3 $broadpref [pw = x42001]
sum rtol3 [fw = int(x42001)]
sum lnrtol3 [fw = int(x42001)]
disp exp(r(mean))-1

* Analysis only in the sub-sample of the 20% wealthiest
* Transaction costs are less relevant for them

mim, category(fit): reg lnrtol32 $broadpref if twthperc10 > 8 [pw = x42001]
sum lnrtol32 if twthperc10 > 8 [fw = int(x42001)]
disp exp(r(mean))-1
summarize $broadpref [fw = int(x42001)]
summarize $broadpref if twthperc10 > 8 [fw = int(x42001)]

mim, category(fit): reg lnfit3 $broadpref [pw = x42001]
mim, category(fit): reg lnfit3 $broadpref if twthperc10 > 8 [pw = x42001]


***************
* Regression with self-assessed measures (TABLE S1)
global narrowriskt $narrowpref myopic risktol
global broadriskt $broadpref myopic risktol

mim, category(fit): reg lnrtol0 $narrowriskt [pw = x42001]
mim, category(fit): reg lnrtol2 $broadriskt [pw = x42001]
mim, category(fit): reg lnrtol3 $broadriskt [pw = x42001]

* Analysis only in the sub-sample of the 20% wealthiest
* Transaction costs are less relevant for them

mim, category(fit): reg lnrtol32 $broadriskt if twthperc10 > 8 [pw = x42001]
* outreg2 using tab1, e(rss) bdec(4) rdec(4) tdec(4) adec(4)

log close

local m 1
while `m'< 6 {
	erase reg_`m'.dta
	local m = `m'+1
}

cd "..\..\..\code\stata"
