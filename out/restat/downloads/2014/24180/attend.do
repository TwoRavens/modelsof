clear all
set mem 500m
* use attend.dta

*** TABLE 1. Description of Key Variables and Summary Statistics ***

sum rgive adjramount attendR price adjinc famsize child ageR female employedR marriedR highR collegeR gradR blackR whiteR [aw=iweight]


*** TABLE 2. Changes in the After-tax Price over Time within Income Deciles ***

xtile pct=lnadjinc, n(10)
tab pct, gen(iq)

* 1st column (2003)

reg price if iq1==1 & year==2003 [aw=iweight]
reg price if iq2==1 & year==2003 [aw=iweight]
reg price if iq3==1 & year==2003 [aw=iweight]
reg price if iq4==1 & year==2003 [aw=iweight]
reg price if iq5==1 & year==2003 [aw=iweight]
reg price if iq6==1 & year==2003 [aw=iweight]
reg price if iq7==1 & year==2003 [aw=iweight]
reg price if iq8==1 & year==2003 [aw=iweight]
reg price if iq9==1 & year==2003 [aw=iweight]
reg price if iq10==1 & year==2003 [aw=iweight]

* 2nd column (2005)

reg price if iq1==1 & year==2005 [aw=iweight]
reg price if iq2==1 & year==2005 [aw=iweight]
reg price if iq3==1 & year==2005 [aw=iweight]
reg price if iq4==1 & year==2005 [aw=iweight]
reg price if iq5==1 & year==2005 [aw=iweight]
reg price if iq6==1 & year==2005 [aw=iweight]
reg price if iq7==1 & year==2005 [aw=iweight]
reg price if iq8==1 & year==2005 [aw=iweight]
reg price if iq9==1 & year==2005 [aw=iweight]
reg price if iq10==1 & year==2005 [aw=iweight]

* 3rd column (Difference)

reg price y2005 if iq1==1 [aw=iweight]
reg price y2005 if iq2==1 [aw=iweight]
reg price y2005 if iq3==1 [aw=iweight]
reg price y2005 if iq4==1 [aw=iweight]
reg price y2005 if iq5==1 [aw=iweight]
reg price y2005 if iq6==1 [aw=iweight]
reg price y2005 if iq7==1 [aw=iweight]
reg price y2005 if iq8==1 [aw=iweight]
reg price y2005 if iq9==1 [aw=iweight]
reg price y2005 if iq10==1 [aw=iweight]


*** TABLE 3. The Effect of Charitable Subsidies on the Probability of Giving to Religious Organizations ***

xi i.state

global controls lnadjinc ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*

* 1st column (OLS)

reg rgive lnprice $controls, cluster(id)
reg rgive lnprice $controls if female==0, cluster(id)
reg rgive lnprice $controls if female==1, cluster(id)
reg rgive lnprice $controls if whiteR==1, cluster(id)
reg rgive lnprice $controls if blackR==1, cluster(id)
reg rgive lnprice $controls if marriedR==0, cluster(id)
reg rgive lnprice $controls if protestant==1, cluster(id)
reg rgive lnprice $controls if catholic==1, cluster(id)

* 2nd column (2SLS) * Coefficient on "lneprice" in the first stage replicates the results reported in the 1st column of Table A2 (Online Appendix)

ivreg rgive (lnprice=lneprice) $controls, cluster(id) first
ivreg rgive (lnprice=lneprice) $controls if female==0, cluster(id) first
ivreg rgive (lnprice=lneprice) $controls if female==1, cluster(id) first
ivreg rgive (lnprice=lneprice) $controls if whiteR==1, cluster(id) first
ivreg rgive (lnprice=lneprice) $controls if blackR==1, cluster(id) first
ivreg rgive (lnprice=lneprice) $controls if marriedR==0, cluster(id) first
ivreg rgive (lnprice=lneprice) $controls if protestant==1, cluster(id) first
ivreg rgive (lnprice=lneprice) $controls if catholic==1, cluster(id) first

* 3rd column (Probit)

probit rgive lnprice $controls, cluster(id)
margins, dydx(lnprice)

probit rgive lnprice $controls if female==0, cluster(id)
margins, dydx(lnprice)

probit rgive lnprice $controls if female==1, cluster(id)
margins, dydx(lnprice)

probit rgive lnprice $controls if whiteR==1, cluster(id)
margins, dydx(lnprice)

probit rgive lnprice $controls if blackR==1, cluster(id)
margins, dydx(lnprice)

probit rgive lnprice $controls if marriedR==0, cluster(id)
margins, dydx(lnprice)

probit rgive lnprice $controls if protestant==1, cluster(id)
margins, dydx(lnprice)

probit rgive lnprice $controls if catholic==1, cluster(id)
margins, dydx(lnprice)

* 4th column (IV-Probit) 

ivprobit rgive (lnprice=lneprice) $controls, cluster(id)
margins, dydx(lnprice) predict(pr)

ivprobit rgive (lnprice=lneprice) $controls if female==0, cluster(id)
margins, dydx(lnprice) predict(pr)

ivprobit rgive (lnprice=lneprice) $controls if female==1, cluster(id)
margins, dydx(lnprice) predict(pr)

ivprobit rgive (lnprice=lneprice) $controls if whiteR==1, cluster(id)
margins, dydx(lnprice) predict(pr)

ivprobit rgive (lnprice=lneprice) $controls if blackR==1, cluster(id)
margins, dydx(lnprice) predict(pr)

ivprobit rgive (lnprice=lneprice) $controls if marriedR==0, cluster(id)
margins, dydx(lnprice) predict(pr)

ivprobit rgive (lnprice=lneprice) $controls if protestant==1, cluster(id)
margins, dydx(lnprice) predict(pr)

ivprobit rgive (lnprice=lneprice) $controls if catholic==1, cluster(id)
margins, dydx(lnprice) predict(pr)

* 5th column (FE) * The first specification replicates the 1st column in Table A1 (Online Appendix)

global controls2 lnadjinc famsize child employedR marriedR highR collegeR gradR y2005 _I*

xtreg rgive lnprice $controls2, fe cluster(id)
xtreg rgive lnprice $controls2 if female==0, fe cluster(id)
xtreg rgive lnprice $controls2 if female==1, fe cluster(id)
xtreg rgive lnprice $controls2 if whiteR==1, fe cluster(id)
xtreg rgive lnprice $controls2 if blackR==1, fe cluster(id)
xtreg rgive lnprice $controls2 if marriedR==0, fe cluster(id)
xtreg rgive lnprice $controls2 if protestant==1, fe cluster(id)
xtreg rgive lnprice $controls2 if catholic==1, fe cluster(id)

* 6th column (IV-FE) * Coefficient on "lneprice" in the first stage replicates the results reported in the 2nd column of Table A2 (Online Appendix)

xtivreg2 rgive (lnprice=lneprice) $controls2, fe cluster(id) first
xtivreg2 rgive (lnprice=lneprice) $controls2 if female==0, fe cluster(id) first
xtivreg2 rgive (lnprice=lneprice) $controls2 if female==1, fe cluster(id) first
xtivreg2 rgive (lnprice=lneprice) $controls2 if whiteR==1, fe cluster(id) first
xtivreg2 rgive (lnprice=lneprice) $controls2 if blackR==1, fe cluster(id) first
xtivreg2 rgive (lnprice=lneprice) $controls2 if marriedR==0, fe cluster(id) first
xtivreg2 rgive (lnprice=lneprice) $controls2 if protestant==1, fe cluster(id) first
xtivreg2 rgive (lnprice=lneprice) $controls2 if catholic==1, fe cluster(id) first
 

*** TABLE 4. The Effect of Charitable Subsidies on the Amount of Religious Contributions ***

* 1st column (OLS)

reg lnadjramount lnprice $controls, cluster(id)
reg lnadjramount lnprice $controls if female==0, cluster(id)
reg lnadjramount lnprice $controls if female==1, cluster(id)
reg lnadjramount lnprice $controls if whiteR==1, cluster(id)
reg lnadjramount lnprice $controls if blackR==1, cluster(id)
reg lnadjramount lnprice $controls if marriedR==0, cluster(id)
reg lnadjramount lnprice $controls if protestant==1, cluster(id)
reg lnadjramount lnprice $controls if catholic==1, cluster(id)

* 2nd column (2SLS)

ivreg lnadjramount (lnprice=lneprice) $controls, cluster(id)
ivreg lnadjramount (lnprice=lneprice) $controls if female==0, cluster(id)
ivreg lnadjramount (lnprice=lneprice) $controls if female==1, cluster(id)
ivreg lnadjramount (lnprice=lneprice) $controls if whiteR==1, cluster(id)
ivreg lnadjramount (lnprice=lneprice) $controls if blackR==1, cluster(id)
ivreg lnadjramount (lnprice=lneprice) $controls if marriedR==0, cluster(id)
ivreg lnadjramount (lnprice=lneprice) $controls if protestant==1, cluster(id)
ivreg lnadjramount (lnprice=lneprice) $controls if catholic==1, cluster(id)

* 3rd column (Tobit)

tobit lnadjramount lnprice $controls, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

tobit lnadjramount lnprice $controls if female==0, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

tobit lnadjramount lnprice $controls if female==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

tobit lnadjramount lnprice $controls if whiteR==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

tobit lnadjramount lnprice $controls if blackR==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

tobit lnadjramount lnprice $controls if marriedR==0, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

tobit lnadjramount lnprice $controls if protestant==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

tobit lnadjramount lnprice $controls if catholic==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

* 4th column (IV-Tobit)

ivtobit lnadjramount (lnprice=lneprice) $controls, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

ivtobit lnadjramount (lnprice=lneprice) $controls if female==0, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

ivtobit lnadjramount (lnprice=lneprice) $controls if female==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

ivtobit lnadjramount (lnprice=lneprice) $controls if whiteR==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

ivtobit lnadjramount (lnprice=lneprice) $controls if blackR==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

ivtobit lnadjramount (lnprice=lneprice) $controls if marriedR==0, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

ivtobit lnadjramount (lnprice=lneprice) $controls if protestant==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

ivtobit lnadjramount (lnprice=lneprice) $controls if catholic==1, cluster(id) ll(0)
margins, dydx(lnprice) predict(e(0,.))

* 5th column (FE) * The first specification replicates the 2d column in Table A1 (Online Appendix)

xtreg lnadjramount lnprice $controls2, fe cluster(id)
xtreg lnadjramount lnprice $controls2 if female==0, fe cluster(id)
xtreg lnadjramount lnprice $controls2 if female==1, fe cluster(id)
xtreg lnadjramount lnprice $controls2 if whiteR==1, fe cluster(id)
xtreg lnadjramount lnprice $controls2 if blackR==1, fe cluster(id)
xtreg lnadjramount lnprice $controls2 if marriedR==0, fe cluster(id)
xtreg lnadjramount lnprice $controls2 if protestant==1, fe cluster(id)
xtreg lnadjramount lnprice $controls2 if catholic==1, fe cluster(id)

* 6th column (IV-FE)

xtivreg2 lnadjramount (lnprice=lneprice) $controls2, fe cluster(id)
xtivreg2 lnadjramount (lnprice=lneprice) $controls2 if female==0, fe cluster(id)
xtivreg2 lnadjramount (lnprice=lneprice) $controls2 if female==1, fe cluster(id)
xtivreg2 lnadjramount (lnprice=lneprice) $controls2 if whiteR==1, fe cluster(id)
xtivreg2 lnadjramount (lnprice=lneprice) $controls2 if blackR==1, fe cluster(id)
xtivreg2 lnadjramount (lnprice=lneprice) $controls2 if marriedR==0, fe cluster(id)
xtivreg2 lnadjramount (lnprice=lneprice) $controls2 if protestant==1, fe cluster(id)
xtivreg2 lnadjramount (lnprice=lneprice) $controls2 if catholic==1, fe cluster(id)


*** TABLE 5. The Effect of Charitable Subsidies on Religious Attendance ***

gen lnattendR1=ln(attendR+0.1)

gen att2=lnattendR1
replace att2=. if lnattendR1<=ln(0.1)
gen att3=lnattendR1
replace att3=ln(0.1) if lnattendR1<=ln(0.1)

gen att4=attendR
replace att4=. if attendR<=0
gen att5=attendR
replace att5=0 if attendR<=0


* 1st column (Log \ OLS)

reg lnattendR1 lnprice $controls, cluster(id)
reg lnattendR1 lnprice $controls if female==0, cluster(id)
reg lnattendR1 lnprice $controls if female==1, cluster(id)
reg lnattendR1 lnprice $controls if whiteR==1, cluster(id)
reg lnattendR1 lnprice $controls if blackR==1, cluster(id)
reg lnattendR1 lnprice $controls if marriedR==0, cluster(id)
reg lnattendR1 lnprice $controls if protestant==1, cluster(id)
reg lnattendR1 lnprice $controls if catholic==1, cluster(id)

* 2nd column (Log \ Tobit)

intreg att2 att3 lnprice $controls, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls if female==0, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls if female==1, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls if whiteR==1, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls if blackR==1, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls if marriedR==0, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls if protestant==1, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls if catholic==1, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

* 3rd column (Log \ FE) * The first specification replicates the 3rd column in Table A1 (Online Appendix)

xtreg lnattendR1 lnprice $controls2, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if female==0, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if female==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if whiteR==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if blackR==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if marriedR==0, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if protestant==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if catholic==1, fe cluster(id)

* 4th column (Level \ OLS)

reg attendR lnprice $controls, cluster(id)
reg attendR lnprice $controls if female==0, cluster(id)
reg attendR lnprice $controls if female==1, cluster(id)
reg attendR lnprice $controls if whiteR==1, cluster(id)
reg attendR lnprice $controls if blackR==1, cluster(id)
reg attendR lnprice $controls if marriedR==0, cluster(id)
reg attendR lnprice $controls if protestant==1, cluster(id)
reg attendR lnprice $controls if catholic==1, cluster(id)

* 5th column (Level \ Tobit)

intreg att4 att5 lnprice $controls, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

intreg att4 att5 lnprice $controls if female==0, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

intreg att4 att5 lnprice $controls if female==1, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

intreg att4 att5 lnprice $controls if whiteR==1, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

intreg att4 att5 lnprice $controls if blackR==1, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

intreg att4 att5 lnprice $controls if marriedR==0, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

intreg att4 att5 lnprice $controls if protestant==1, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

intreg att4 att5 lnprice $controls if catholic==1, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

* 6th column ( Level \ FE) * The first specification replicates the 4th column in Table A1 (Online Appendix)

xtreg attendR lnprice $controls2, fe cluster(id)
xtreg attendR lnprice $controls2 if female==0, fe cluster(id)
xtreg attendR lnprice $controls2 if female==1, fe cluster(id)
xtreg attendR lnprice $controls2 if whiteR==1, fe cluster(id)
xtreg attendR lnprice $controls2 if blackR==1, fe cluster(id)
xtreg attendR lnprice $controls2 if marriedR==0, fe cluster(id)
xtreg attendR lnprice $controls2 if protestant==1, fe cluster(id)
xtreg attendR lnprice $controls2 if catholic==1, fe cluster(id)


*** TABLE 6. The Effect of Charitable Subsidies on Religious Attendance: Robustness Checks ***

* predict income and generate quantiles

reg lnadjinc ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id)
predict lninchat
xtile pct2=lninchat, n(10)
tab pct2, gen(im)

* gen year/income interaction

gen iy2005=y2005*lnadjinc

* endogeneity of itemization status

gen ded=proptax+mortgage+childcare+ichar+imed+income/50

gen it=0

replace it=1 if ded>4700 & marriedR==0 & ageR<65 & year==2003
replace it=1 if ded>5850 & marriedR==0 & ageR>=65 & year==2003

replace it=1 if ded>7850 & marriedR==1 & ageR<65 & year==2003
replace it=1 if ded>8750 & marriedR==1 & ageR>=65 & year==2003


replace it=1 if ded>4850 & marriedR==0 & ageR<65 & year==2005
replace it=1 if ded>6050 & marriedR==0 & ageR>=65 & year==2005

replace it=1 if ded>9700 & marriedR==1 & ageR<65 & year==2005
replace it=1 if ded>10650 & marriedR==1 & ageR>=65 & year==2005

gen ded2=proptax+mortgage+childcare+imed+income/50

gen it2=0

replace it2=1 if ded2>4700 & marriedR==0 & ageR<65 & year==2003
replace it2=1 if ded2>5850 & marriedR==0 & ageR>=65 & year==2003

replace it2=1 if ded2>7850 & marriedR==1 & ageR<65 & year==2003
replace it2=1 if ded2>8750 & marriedR==1 & ageR>=65 & year==2003


replace it2=1 if ded2>4850 & marriedR==0 & ageR<65 & year==2005
replace it2=1 if ded2>6050 & marriedR==0 & ageR>=65 & year==2005

replace it2=1 if ded2>9700 & marriedR==1 & ageR<65 & year==2005
replace it2=1 if ded2>10650 & marriedR==1 & ageR>=65 & year==2005


* 1st column (Log \ OLS)

reg lnattendR1 lnnprice $controls, cluster(id)
reg lnattendR1 lnnprice iq* $controls, cluster(id)
reg lnattendR1 lnaprice lninchat ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id)
reg lnattendR1 lnaprice lninchat im* ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id)
reg lnattendR1 lnprice $controls if it==it2, cluster(id)
reg lnattendR1 lnprice $controls iy2005, cluster(id)
xi: reg lnattendR1 lnprice $controls i.state*y2005, cluster(id)
xi: reg lnattendR1 lnprice $controls i.state*lnadjinc, cluster(id)

* 2nd column (Log \ Tobit)

intreg att2 att3 lnnprice $controls, cluster(id)
margins, dydx(lnnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnnprice iq* $controls, cluster(id)
margins, dydx(lnnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnaprice lninchat ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id) 
margins, dydx(lnaprice) predict(e(-2.3025851,.))

intreg att2 att3 lnaprice lninchat im* ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id) 
margins, dydx(lnaprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls if it==it2, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

intreg att2 att3 lnprice $controls iy2005, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

xi: intreg att2 att3 lnprice $controls i.state*y2005, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

xi: intreg att2 att3 lnprice $controls i.state*lnadjinc, cluster(id)
margins, dydx(lnprice) predict(e(-2.3025851,.))

* 3rd column (Log \ FE)

xtreg lnattendR1 lnnprice $controls2, fe cluster(id)
xtreg lnattendR1 lnnprice iq* $controls2, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I*, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I*, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if it==it2, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 iy2005, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*y2005, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*lnadjinc, fe cluster(id)

* 4th column (Level \ OLS)

reg attendR lnnprice $controls, cluster(id)
reg attendR lnnprice iq* $controls, cluster(id)
reg attendR lnaprice lninchat ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id)
reg attendR lnaprice lninchat im* ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id)
reg attendR lnprice $controls if it==it2, cluster(id)
reg attendR lnprice $controls iy2005, cluster(id)
xi: reg attendR lnprice $controls i.state*y2005, cluster(id)
xi: reg attendR lnprice $controls i.state*lnadjinc, cluster(id)

* 5th column (Level \ Tobit)

intreg att4 att5 lnnprice $controls, cluster(id)
margins, dydx(lnnprice) predict(e(0,.))

intreg att4 att5 lnnprice iq* $controls, cluster(id)
margins, dydx(lnnprice) predict(e(0,.))

intreg att4 att5 lnaprice lninchat ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id) 
margins, dydx(lnaprice) predict(e(01,.))

intreg att4 att5 lnaprice lninchat im* ageR famsize child employedR marriedR female whiteR blackR highR collegeR gradR y2005 _I*, cluster(id) 
margins, dydx(lnaprice) predict(e(0,.))

intreg att4 att5 lnprice $controls if it==it2, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

intreg att4 att5 lnprice $controls iy2005, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

xi: intreg att4 att5 lnprice $controls i.state*y2005, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

xi: intreg att4 att5 lnprice $controls i.state*lnadjinc, cluster(id)
margins, dydx(lnprice) predict(e(0,.))

* 6th column (Level \ FE)

xtreg attendR lnnprice $controls2, fe cluster(id)
xtreg attendR lnnprice iq* $controls2, fe cluster(id)
xtreg attendR lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I*, fe cluster(id)
xtreg attendR lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I*, fe cluster(id)
xtreg attendR lnprice $controls2 if it==it2, fe cluster(id)
xtreg attendR lnprice $controls2 iy2005, fe cluster(id)
xi: xtreg attendR lnprice $controls2 i.state*y2005, fe cluster(id)
xi: xtreg attendR lnprice $controls2 i.state*lnadjinc, fe cluster(id)


*** TABLE 7. The Effect of Charitable Subsidies on Religious Attendance: Robustness Checks for Subsamples in FE Models ***

* 1st column (Male)

xtreg lnattendR1 lnnprice $controls2 if female==0, fe cluster(id)
xtreg lnattendR1 lnnprice iq* $controls2 if female==0, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I* if female==0, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I* if female==0, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if it==it2 & female==0, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 iy2005 if female==0, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*y2005 if female==0, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*lnadjinc if female==0, fe cluster(id)

* 2nd column (Female)

xtreg lnattendR1 lnnprice $controls2 if female==1, fe cluster(id)
xtreg lnattendR1 lnnprice iq* $controls2 if female==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I* if female==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I* if female==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if it==it2 & female==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 iy2005 if female==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*y2005 if female==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*lnadjinc if female==1, fe cluster(id)

* 3rd column (White)

xtreg lnattendR1 lnnprice $controls2 if whiteR==1, fe cluster(id)
xtreg lnattendR1 lnnprice iq* $controls2 if whiteR==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I* if whiteR==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I* if whiteR==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if it==it2 & whiteR==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 iy2005 if whiteR==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*y2005 if whiteR==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*lnadjinc if whiteR==1, fe cluster(id)

* 4th column (Black)

xtreg lnattendR1 lnnprice $controls2 if blackR==1, fe cluster(id)
xtreg lnattendR1 lnnprice iq* $controls2 if blackR==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I* if blackR==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I* if blackR==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if it==it2 & blackR==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 iy2005 if blackR==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*y2005 if blackR==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*lnadjinc if blackR==1, fe cluster(id)

* 5th column (Unmarried)

xtreg lnattendR1 lnnprice $controls2 if marriedR==0, fe cluster(id)
xtreg lnattendR1 lnnprice iq* $controls2 if marriedR==0, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I* if marriedR==0==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I* if marriedR==0==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if it==it2 & marriedR==0==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 iy2005 if marriedR==0==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*y2005 if marriedR==0==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*lnadjinc if marriedR==0==1, fe cluster(id)

* 6th column (protestant)

xtreg lnattendR1 lnnprice $controls2 if protestant==1, fe cluster(id)
xtreg lnattendR1 lnnprice iq* $controls2 if protestant==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I* if protestant==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I* if protestant==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if it==it2 & protestant==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 iy2005 if protestant==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*y2005 if protestant==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*lnadjinc if protestant==1, fe cluster(id)

* 7th column (catholic)

xtreg lnattendR1 lnnprice $controls2 if catholic==1, fe cluster(id)
xtreg lnattendR1 lnnprice iq* $controls2 if catholic==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat famsize child employedR marriedR highR collegeR gradR y2005 _I* if catholic==1, fe cluster(id)
xtreg lnattendR1 lnaprice lninchat im* famsize child employedR marriedR highR collegeR gradR y2005 _I* if catholic==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 if it==it2 & catholic==1, fe cluster(id)
xtreg lnattendR1 lnprice $controls2 iy2005 if catholic==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*y2005 if catholic==1, fe cluster(id)
xi: xtreg lnattendR1 lnprice $controls2 i.state*lnadjinc if catholic==1, fe cluster(id)


*** TABLE 8. The Effect of Religious Giving on Religious Attendance ***

* 1st column (Prob. of giving \ 2SLS)

ivreg lnattendR1 (rgive=lnprice) $controls, cluster(id)
ivreg lnattendR1 (rgive=lnprice) $controls if female==0, cluster(id)
ivreg lnattendR1 (rgive=lnprice) $controls if female==1, cluster(id)
ivreg lnattendR1 (rgive=lnprice) $controls if whiteR==1, cluster(id)
ivreg lnattendR1 (rgive=lnprice) $controls if blackR==1, cluster(id)
ivreg lnattendR1 (rgive=lnprice) $controls if marriedR==0, cluster(id)
ivreg lnattendR1 (rgive=lnprice) $controls if protestant==1, cluster(id)
ivreg lnattendR1 (rgive=lnprice) $controls if catholic==1, cluster(id)

* 2nd column (Prob. of giving \ IV-Tobit)

ivtobit lnattendR1 (rgive=lnprice) $controls, cluster(id) ll(-2.3025851)
margins, dydx(rgive) predict(e(-2.3025851,.))

ivtobit lnattendR1 (rgive=lnprice) $controls if female==0, cluster(id) ll(-2.3025851)
margins, dydx(rgive) predict(e(-2.3025851,.))

ivtobit lnattendR1 (rgive=lnprice) $controls if female==1, cluster(id) ll(-2.3025851)
margins, dydx(rgive) predict(e(-2.3025851,.))

ivtobit lnattendR1 (rgive=lnprice) $controls if whiteR==1, cluster(id) ll(-2.3025851)
margins, dydx(rgive) predict(e(-2.3025851,.))

ivtobit lnattendR1 (rgive=lnprice) $controls if blackR==1, cluster(id) ll(-2.3025851)
margins, dydx(rgive) predict(e(-2.3025851,.))

ivtobit lnattendR1 (rgive=lnprice) $controls if marriedR==0, cluster(id) ll(-2.3025851)
margins, dydx(rgive) predict(e(-2.3025851,.))

ivtobit lnattendR1 (rgive=lnprice) $controls if protestant==1, cluster(id) ll(-2.3025851)
margins, dydx(rgive) predict(e(-2.3025851,.))

ivtobit lnattendR1 (rgive=lnprice) $controls if catholic==1, cluster(id) ll(-2.3025851)
margins, dydx(rgive) predict(e(-2.3025851,.))

* 3rd column (Prob. of giving \ IV-FE)

xtivreg2 lnattendR1 (rgive=lnprice) $controls2, cluster(id) fe
xtivreg2 lnattendR1 (rgive=lnprice) $controls2 if female==0, cluster(id) fe
xtivreg2 lnattendR1 (rgive=lnprice) $controls2 if female==1, cluster(id) fe
xtivreg2 lnattendR1 (rgive=lnprice) $controls2 if whiteR==1, cluster(id) fe
xtivreg2 lnattendR1 (rgive=lnprice) $controls2 if blackR==1, cluster(id) fe
xtivreg2 lnattendR1 (rgive=lnprice) $controls2 if marriedR==0, cluster(id) fe
xtivreg2 lnattendR1 (rgive=lnprice) $controls2 if protestant==1, cluster(id) fe
xtivreg2 lnattendR1 (rgive=lnprice) $controls2 if catholic==1, cluster(id) fe

* 4th column (Contribution amount \ 2SLS)

ivreg lnattendR1 (lnadjramount=lnprice) $controls, cluster(id)
ivreg lnattendR1 (lnadjramount=lnprice) $controls if female==0, cluster(id)
ivreg lnattendR1 (lnadjramount=lnprice) $controls if female==1, cluster(id)
ivreg lnattendR1 (lnadjramount=lnprice) $controls if whiteR==1, cluster(id)
ivreg lnattendR1 (lnadjramount=lnprice) $controls if blackR==1, cluster(id)
ivreg lnattendR1 (lnadjramount=lnprice) $controls if marriedR==0, cluster(id)
ivreg lnattendR1 (lnadjramount=lnprice) $controls if protestant==1, cluster(id)
ivreg lnattendR1 (lnadjramount=lnprice) $controls if catholic==1, cluster(id)

* 5th column (Contribution amount \ IV-Tobit)

ivtobit lnattendR1 (lnadjramount=lnprice) $controls, cluster(id) ll(-2.3025851)
margins, dydx(lnadjramount) predict(e(-2.3025851,.))

ivtobit lnattendR1 (lnadjramount=lnprice) $controls if female==0, cluster(id) ll(-2.3025851)
margins, dydx(lnadjramount) predict(e(-2.3025851,.))

ivtobit lnattendR1 (lnadjramount=lnprice) $controls if female==1, cluster(id) ll(-2.3025851)
margins, dydx(lnadjramount) predict(e(-2.3025851,.))

ivtobit lnattendR1 (lnadjramount=lnprice) $controls if whiteR==1, cluster(id) ll(-2.3025851)
margins, dydx(lnadjramount) predict(e(-2.3025851,.))

ivtobit lnattendR1 (lnadjramount=lnprice) $controls if blackR==1, cluster(id) ll(-2.3025851)
margins, dydx(lnadjramount) predict(e(-2.3025851,.))

ivtobit lnattendR1 (lnadjramount=lnprice) $controls if marriedR==0, cluster(id) ll(-2.3025851)
margins, dydx(lnadjramount) predict(e(-2.3025851,.))

ivtobit lnattendR1 (lnadjramount=lnprice) $controls if protestant==1, cluster(id) ll(-2.3025851)
margins, dydx(lnadjramount) predict(e(-2.3025851,.))

ivtobit lnattendR1 (lnadjramount=lnprice) $controls if catholic==1, cluster(id) ll(-2.3025851)
margins, dydx(lnadjramount) predict(e(-2.3025851,.))

* 6th column (Contribution amount \ IV-FE)

xtivreg2 lnattendR1 (lnadjramount=lnprice) $controls2, cluster(id) fe
xtivreg2 lnattendR1 (lnadjramount=lnprice) $controls2 if female==0, cluster(id) fe
xtivreg2 lnattendR1 (lnadjramount=lnprice) $controls2 if female==1, cluster(id) fe
xtivreg2 lnattendR1 (lnadjramount=lnprice) $controls2 if whiteR==1, cluster(id) fe
xtivreg2 lnattendR1 (lnadjramount=lnprice) $controls2 if blackR==1, cluster(id) fe
xtivreg2 lnattendR1 (lnadjramount=lnprice) $controls2 if marriedR==0, cluster(id) fe
xtivreg2 lnattendR1 (lnadjramount=lnprice) $controls2 if protestant==1, cluster(id) fe
xtivreg2 lnattendR1 (lnadjramount=lnprice) $controls2 if catholic==1, cluster(id) fe
