**** DATA CHECK AND PREPARATION

discard
capture log close
set more off
clear matrix
cd "/Users/andrea/Documents/DSM/INITIATION"
clear
set mem 100m
clear
use "/Users/andrea/Documents/DSM/INITIATION/base_countries_and_dyads_sa.dta", clear
egen cr=group(comres)
iis cr
tis year
set matsize 800
tsset cr year

***************************************************
**DATA GEN

bysort cr year: gen mercbol=1 if comres=="ARGBOL" | comres=="BOLARG" | comres=="BRABOL" | comres=="BOLBRA" | comres=="PRYBOL" | comres=="BOLPRY" | comres=="URYBOL" | comres=="BOLURY"
replace mercbol=0 if mercbol==. 
count if mercbol==1
*tiene que dar 4*2*19=152
bysort cr year: gen merccev=1 if comres=="ARGCOL" | comres=="COLARG" | comres=="BRACOL" | comres=="COLBRA" | comres=="PRYCOL" | comres=="COLPRY" | comres=="URYCOL" | comres=="COLURY" | comres=="ARGECU" | comres=="ECUARG" | comres=="BRAECU" | comres=="ECUBRA" | comres=="PRYECU" | comres=="ECUPRY" | comres=="URYECU" | comres=="ECUURY" | comres=="ARGVEN" | comres=="VENARG" | comres=="BRAVEN" | comres=="VENBRA" | comres=="PRYVEN" | comres=="VENPRY" | comres=="URYVEN" | comres=="VENURY"
replace merccev=0 if merccev==. 
count if merccev==1
*tiene que dar 4*2*19=152
bysort cr year: gen mercper=1 if comres=="ARGPER" | comres=="PERARG" | comres=="BRAPER" | comres=="PERBRA" | comres=="PRYPER" | comres=="PERPRY" | comres=="URYPER" | comres=="PERURY"
replace mercper=0 if mercper==. 
count if mercper==1
*tiene que dar 4*2*19=152
bysort cr year: gen mercchl=1 if comres=="ARGCHL" | comres=="CHLARG" | comres=="BRACHL" | comres=="CHLBRA" | comres=="PRYCHL" | comres=="CHLPRY" | comres=="URYCHL" | comres=="CHLURY"
replace mercchl=0 if mercchl==. 
count if mercchl==1
*tiene que dar 4*2*19=152


***OTRAS VARIABLES 
*BANDWAGON(-1)
sort cr year
tsset cr year
gen bandrta_1 = l.bandrta

*logGDPpc
gen lgdppc00com=ln(gdppc00com)
gen lgdppc00res=ln(gdppc00res)

*log trade dep
gen lbiltrade = ln(biltrade)
sort cr year
tsset cr year
gen lbiltrade_1 = l.lbiltrade


*log share agric/food exp
gen lsxafcom = ln(sxafcom)
sort cr year
tsset cr year
gen lsxafcom_1 = l.lsxafcom

*log GDP ratio
gen lgdpratio = ln(gdpratio)
sort cr year
tsset cr year
gen lgdpratio_1 = l.lgdpratio

*log exports dependence
gen lxdepcom = ln(xdepcom)
sort cr year
tsset cr year
gen lxdepcom_1 = l.lxdepcom

*crear dummies year
tab year, gen (y)
assert y1==0 | y1==1 | y2==0 | y2==1 | y3==0 | y3==1 | y4==0 | y4==1 | y5==0 | y5==1 | y6==0 | y6==1 | y7==0 | y7==1 | y8==0 | y8==1 | y9==0 | y9==1 | y10==0 | y10==1 | y11==0 | y11==1 | y12==0 | y12==1 | y13==0 | y13==1 | y14==0 | y14==1 | y15==0 | y15==1 | y16==0 | y16==1 |y17==0 | y17==1 | y18==0 | y18==1 | y19==0 | y19==1 | y20==1 | y20==1

*crear dummies country
tab com, gen (c)
assert c1==0 | c1==1 | c2==0 | c2==1 | c3==0 | c3==1 | c4==0 | c4==1 | c5==0 | c5==1 | c6==0 | c6==1 | c7==0 | c7==1 | c8==0 | c8==1 | c9==0 | c9==1 | c10==0
tab res, gen (r)
assert r1==0 | r1==1 | r2==0 | r2==1 | r3==0 | r3==1 | r4==0 | r4==1 | r5==0 | r5==1 | r6==0 | r6==1 | r7==0 | r7==1 | r8==0 | r8==1 | r9==0 | r9==1 | r10==0


*TODO EN LAGS
sort cr year
tsset cr year
gen poli2com_1=l.poli2com
gen poli2res_1=l.poli2res
gen civlicom_1=l.civlicom
gen civlires_1=l.civlires
gen joincivl_1=l.joincivl
gen geffecom_1=l.geffecom
gen gefferes_1=l.gefferes
gen rolawcom_1=l.rolawcom
gen rolawres_1=l.rolawires
gen regqucom_1=l.regqucom
gen regqures_1=l.regquires
gen jointdem_1=l.jointdem
gen xdepcom_1=l.xdepcom
gen biltrade_1=l.biltrade


gen gdpratio_1=l.gdpratio
gen gdppc00com_1=l.gdppc00com
gen gdppc00res_1=l.gdppc00res
gen lgdppc00com_1=l.lgdppc00com
gen lgdppc00res_1=l.lgdppc00res

gen sxafcom_1=l.sxafcom
gen sxagrcom_1=l.sxagrcom
gen sxfoodcom_1=l.sxfoodcom


sort year comres
rename y1 d89
rename y2 d90
rename y3 d91
rename y4 d92
rename y5 d93
rename y6 d94
rename y7 d95
rename y8 d96
rename y9 d97
rename y10 d98
rename y11 d99
rename y12 d00
rename y13 d01
rename y14 d02
rename y15 d03
rename y16 d04
rename y17 d05
rename y18 d06
rename y19 d07
rename y20 d08

sort com year
rename c1 ARGcomrename c2 BOLcomrename c3 BRAcomrename c4 CHLcomrename c5 COLcomrename c6 ECUcomrename c7 PERcomrename c8 PRYcomrename c9 URYcomrename c10 VENcom

sort res year
rename r1 ARGresrename r2 BOLresrename r3 BRAresrename r4 CHLresrename r5 COLresrename r6 ECUresrename r7 PERresrename r8 PRYresrename r9 URYresrename r10 VENres

drop if year<1996


gen exprta=exprtacom+exprtadef
gen expwto=expwtocom+expwtodef
gen expcom=exprtacom+expwtocom
gen expdef=exprtadef+expwtodef

gen experience=expcom+expdef
assert experience==exprta+expwto

gen exprtacom2=exprtacom^2
gen expwtocom2=expwtocom^2
gen exprtadef2=exprtadef^2
gen expwtodef2=expwtodef^2

gen exprta2=exprta^2
gen expwto2=expwto^2

gen expcom2=expcom^2
gen expdef2=expdef^2
gen experience2=experience^2

gen exprsxaf=exprta*sxafcom_1
gen exprgdpr=exprta*gdpratio_1
gen expwgdpr=expwto*gdpratio_1
gen exprgdppc=exprta*gdppc00com_1
gen expwgdppc=expwto*gdppc00com_1
gen gdprsxaf=gdpratio*sxafcom_1
gen expwsxaf=expwto*sxafcom_1

gen exprlgdpr=exprta*lgdpratio_1
gen expwlgdpr=expwto*lgdpratio_1
gen exprlgdppc=exprta*lgdppc00com_1
gen expwlgdppc=expwto*lgdppc00com_1

gen exprcomsxaf=exprtacom*sxafcom_1
gen exprcomgdpr=exprtacom*gdpratio_1
gen expwcomgdpr=expwtocom*gdpratio_1
gen expwcomsxaf=expwtocom*sxafcom_1

gen exprcomlgdpr=exprtacom*lgdpratio_1
gen expwcomlgdpr=expwtocom*lgdpratio_1

gen exprdefgdpr=exprtadef*gdpratio_1
gen expwdefgdpr=expwtodef*gdpratio_1
gen exprdeflgdpr=exprtadef*lgdpratio_1
gen expwdeflgdpr=expwtodef*lgdpratio_1

gen expcomgdpr=expcom*gdpratio_1
gen expdefgdpr=expdef*gdpratio_1
gen expcomlgdpr=expcom*lgdpratio_1
gen expdeflgdpr=expdef*lgdpratio_1

gen expgdpr=experience*gdpratio_1
gen explgdpr=experience*lgdpratio_1

gen lsxfalgdpr=lsxafcom_1*lgdpratio_1
gen lsxfaexp=lsxafcom_1*experience

save datadyadssa96.dta, replace

log using "/Users/andrea/Documents/DSM/INITIATION/correlations.log", replace

**** CORRELATIONS 
** rule of law con cantidad de disputas rta (PA)
xtreg qdisprta rolawcom, pa i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local brolawcom = _b[rolawcom]
xtreg rolawcom qdisprta, pa robust
local bqdisprta = _b[qdisprta]
* here we're making a new macro equal to the correlation
	local rqdrlpa = (`brolawcom'*`bqdisprta')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rqdrlpa
** rule of law con cantidad de disputas rta (RE)
xtreg qdisprta rolawcom, re i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local brolawcom = _b[rolawcom]
xtreg rolawcom qdisprta, re robust
local bqdisprta = _b[qdisprta]
* here we're making a new macro equal to the correlation
	local rqdrlre = (`brolawcom'*`bqdisprta')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rqdrlre
** rule of law con cantidad de disputas rta (FE)
xtreg qdisprta rolawcom, fe i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local brolawcom = _b[rolawcom]
xtreg rolawcom qdisprta, fe robust
local bqdisprta = _b[qdisprta]
* here we're making a new macro equal to the correlation
	local rqdrlfe = (`brolawcom'*`bqdisprta')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rqdrlfe
corr qdisprta rolawcom

** corruption con tama–o del pa’s (GDP) PA
xtreg corrcom gdp00com, pa i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bgdp00com = _b[gdp00com]
xtreg gdp00com corrcom, pa robust
local bcorrcom = _b[corrcom]
* here we're making a new macro equal to the correlation
	local rcorgdppa = (`bgdp00com'*`bcorrcom')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rcorgdppa
** corruption con tama–o del pa’s (GDP) RE
xtreg corrcom gdp00com, re i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bgdp00com = _b[gdp00com]
xtreg gdp00com corrcom, pa robust
local bcorrcom = _b[corrcom]
* here we're making a new macro equal to the correlation
	local rcorgdpre = (`bgdp00com'*`bcorrcom')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rcorgdpre
** corruption con tama–o del pa’s (GDP) FE
xtreg corrcom gdp00com, fe i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bgdp00com = _b[gdp00com]
xtreg gdp00com corrcom, fe robust
local bcorrcom = _b[corrcom]
* here we're making a new macro equal to the correlation
	local rcorgdpfe = (`bgdp00com'*`bcorrcom')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rcorgdpfe
corr corrcom gdp00com

** corruption con tama–o del pa’s (POP) PA
xtreg corrcom popcom, pa i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bpopcom = _b[popcom]
xtreg popcom corrcom, pa robust
local bcorrcom = _b[corrcom]
* here we're making a new macro equal to the correlation
	local rcorpoppa = (`bpopcom'*`bcorrcom')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rcorpoppa
** corruption con tama–o del pa’s (POP) RE
xtreg corrcom popcom, re i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bpopcom = _b[popcom]
xtreg popcom corrcom, pa robust
local bcorrcom = _b[corrcom]
* here we're making a new macro equal to the correlation
	local rcorpopre = (`bpopcom'*`bcorrcom')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rcorpopre
** corruption con tama–o del pa’s (POP) FE
xtreg corrcom popcom, fe i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bpopcom = _b[popcom]
xtreg popcom corrcom, fe robust
local bcorrcom = _b[corrcom]
* here we're making a new macro equal to the correlation
	local rcorpopfe = (`bpopcom'*`bcorrcom')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rcorpopfe
corr corrcom popcom

** country size (GDPPPP05) con share of agricultural and food exports (PA)
xtreg gdpppp05com sxafcom, pa i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bsxafcom = _b[sxafcom]
xtreg sxafcom gdpppp05com, pa robust
local bgdpppp05com = _b[gdpppp05com]
* here we're making a new macro equal to the correlation
	local rgdpsxafpa = (`bsxafcom'*`bgdpppp05com')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rgdpsxafpa
** country size con share of agricultural and food exports (RE)
xtreg gdpppp05com sxafcom, re i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bsxafcom = _b[sxafcom]
xtreg sxafcom gdpppp05com, re robust
local bgdpppp05com = _b[gdpppp05com]
* here we're making a new macro equal to the correlation
	local rgdpsxafre = (`bsxafcom'*`bgdpppp05com')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rgdpsxafre
** country size con share of agricultural and food exports (FE)
xtreg gdpppp05com sxafcom, fe i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bsxafcom = _b[sxafcom]
xtreg sxafcom gdpppp05com, fe robust
local bgdpppp05com = _b[gdpppp05com]
* here we're making a new macro equal to the correlation
	local rgdpsxaffe = (`bsxafcom'*`bgdpppp05com')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rgdpsxaffe
corr sxafcom gdpppp05com

* country size (GDP00) con share of agricultural and food exports (PA)
xtreg gdp00com sxafcom, pa i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bsxafcom = _b[sxafcom]
xtreg sxafcom gdp00com, pa robust
local bgdp00com = _b[gdp00com]
* here we're making a new macro equal to the correlation
	local rgdp00sxafpa = (`bsxafcom'*`bgdp00com')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rgdp00sxafpa
** country size con share of agricultural and food exports (RE)
xtreg gdp00com sxafcom, re i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bsxafcom = _b[sxafcom]
xtreg sxafcom gdp00com, re robust
local bgdp00com = _b[gdp00com]
* here we're making a new macro equal to the correlation
	local rgdp00sxafre = (`bsxafcom'*`bgdp00com')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rgdp00sxafre
** country size con share of agricultural and food exports (FE)
xtreg gdp00com sxafcom, fe i(cr) robust
* here we're saving the coefficient in a local macro called `bx'
local bsxafcom = _b[sxafcom]
xtreg sxafcom gdp00com, fe robust
local bgdp00com = _b[gdp00com]
* here we're making a new macro equal to the correlation
	local rgdp00sxaffe = (`bsxafcom'*`bgdp00com')^0.5
* here we ask stata to show us the value for our new correlation.
	macro list _rgdp00sxaffe
corr sxafcom gdp00com

log close

**** ESTIMATIONS 

discard
capture log close
set more off
cd "/Users/andrea/Documents/DSM/INITIATION"
clear
clear matrix
set mem 100m
clear
use datadyadssa96.dta, clear
iis cr
tis year
set matsize 800
tsset cr year

****REGRESSIONS

log using "/Users/andrea/Documents/DSM/INITIATION/resultsinidyads96final.log", replace


****WITHOUT INTERACTIONS
xtgee disprta exprta expwto exprta2 expwto2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se replace
margins, dydx (*) atmeans
margins, at(exprta = (0 (100) 1000)) atmeans
margins, at(expwto = (0 (10) 70)) atmeans

xtprobit disprta exprta expwto exprta2 expwto2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta  exprta expwto exprta2 expwto2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta  exprta expwto exprta2 expwto2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(exprta min mean)
simqi, fd(prval(1)) changex(exprta 0 1)
simqi, fd(prval(1)) changex(exprta 0 10)
simqi, fd(prval(1)) changex(exprta 0 50)
simqi, fd(prval(1)) changex(exprta 0 100)
simqi, fd(prval(1)) changex(exprta 0 150)
simqi, fd(prval(1)) changex(exprta 0 200)
simqi, fd(prval(1)) changex(exprta 0 7.5021)
simqi, fd(prval(1)) changex(exprta 0 211.6363)

setx mean
simqi, fd(prval(1)) changex(expwto min mean)
simqi, fd(prval(1)) changex(expwto 0 1)
simqi, fd(prval(1)) changex(expwto 0 2)
simqi, fd(prval(1)) changex(expwto 0 3)
simqi, fd(prval(1)) changex(expwto 0 4)
simqi, fd(prval(1)) changex(expwto 0 5)
simqi, fd(prval(1)) changex(expwto 0 6)
simqi, fd(prval(1)) changex(expwto 0 -2.432226)
simqi, fd(prval(1)) changex(expwto 0 14.87838)
drop b1-b27


xtgee disprta exprtacom expwtocom exprtacom2 expwtocom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(exprtacom = (0 (50) 500)) atmeans
margins, at(exprtacom = (0 1 2 3 4 5)) atmeans
margins, at(exprtacom = (0 (5) 100)) atmeans
margins, at(expwtocom = (0 (5) 40)) atmeans
margins, at(expwtocom = (0 1 2 3 4 5)) atmeans
margins, at(expwtocom = (0 (5) 100)) atmeans

xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta exprtacom expwtocom exprtacom2 expwtocom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(exprtacom min mean)
simqi, fd(prval(1)) changex(exprtacom 0 1)
simqi, fd(prval(1)) changex(exprtacom 0 5)
simqi, fd(prval(1)) changex(exprtacom 0 10)
simqi, fd(prval(1)) changex(exprtacom 0 25)
simqi, fd(prval(1)) changex(exprtacom 0 40)
simqi, fd(prval(1)) changex(exprtacom 0 50)
simqi, fd(prval(1)) changex(exprtacom 0 -11.71091)
simqi, fd(prval(1)) changex(exprtacom 0 103.74167)

setx mean
simqi, fd(prval(1)) changex(expwtocom min mean)
simqi, fd(prval(1)) changex(expwtocom 0 1)
simqi, fd(prval(1)) changex(expwtocom 0 2)
simqi, fd(prval(1)) changex(expwtocom 0 3)
simqi, fd(prval(1)) changex(expwtocom 0 4)
simqi, fd(prval(1)) changex(expwtocom 0 5)
simqi, fd(prval(1)) changex(expwtocom 0 6)
simqi, fd(prval(1)) changex(expwtocom 0 -1.678742)
simqi, fd(prval(1)) changex(expwtocom 0 7.77105)
drop b1-b27


xtgee disprta exprtadef expwtodef exprtadef2 expwtodef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(exprtadef = (0 (50) 500)) atmeans
margins, at(exprtadef = (0 1 2 3 4 5)) atmeans
margins, at(exprtadef = (0 (5) 100)) atmeans
margins, at(expwtodef = (0 (2) 30)) atmeans
margins, at(expwtodef = (0 1 2 3 4 5)) atmeans
margins, at(expwtodef = (0 (5) 100)) atmeans

xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta exprtadef expwtodef exprtadef2 expwtodef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(exprtadef min mean)
simqi, fd(prval(1)) changex(exprtadef 0 1)
simqi, fd(prval(1)) changex(exprtadef 0 10)
simqi, fd(prval(1)) changex(exprtadef 0 30)
simqi, fd(prval(1)) changex(exprtadef 0 50)
simqi, fd(prval(1)) changex(exprtadef 0 75)
simqi, fd(prval(1)) changex(exprtadef 0 100)
simqi, fd(prval(1)) changex(exprtadef 0 12.93987)
simqi, fd(prval(1)) changex(exprtadef 0 114.16783)

setx mean
simqi, fd(prval(1)) changex(expwtodef min mean)
simqi, fd(prval(1)) changex(expwtodef 0 1)
simqi, fd(prval(1)) changex(expwtodef 0 2)
simqi, fd(prval(1)) changex(expwtodef 0 3)
simqi, fd(prval(1)) changex(expwtodef 0 4)
simqi, fd(prval(1)) changex(expwtodef 0 5)
simqi, fd(prval(1)) changex(expwtodef 0 6)
simqi, fd(prval(1)) changex(expwtodef 0 -1.172288)
simqi, fd(prval(1)) changex(expwtodef 0 7.526134)
drop b1-b27


xtgee disprta expcom expdef expcom2 expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expcom = (0 (50) 500)) atmeans
margins, at(expdef = (0 (50) 500)) atmeans

xtprobit disprta expcom expdef expcom2 expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expcom expdef expcom2 expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expcom expdef expcom2 expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(expcom min mean)
simqi, fd(prval(1)) changex(expcom 0 1)
simqi, fd(prval(1)) changex(expcom 0 10)
simqi, fd(prval(1)) changex(expcom 0 30)
simqi, fd(prval(1)) changex(expcom 0 50)
simqi, fd(prval(1)) changex(expcom 0 75)
simqi, fd(prval(1)) changex(expcom 0 100)
simqi, fd(prval(1)) changex(expcom 0 -11.51919)
simqi, fd(prval(1)) changex(expcom 0 109.64227)

setx mean
simqi, fd(prval(1)) changex(expdef min mean)
simqi, fd(prval(1)) changex(expdef 0 1)
simqi, fd(prval(1)) changex(expdef 0 10)
simqi, fd(prval(1)) changex(expdef 0 30)
simqi, fd(prval(1)) changex(expdef 0 50)
simqi, fd(prval(1)) changex(expdef 0 75)
simqi, fd(prval(1)) changex(expdef 0 100)
simqi, fd(prval(1)) changex(expdef 0 13.21328)
simqi, fd(prval(1)) changex(expdef 0 120.24826)
drop b1-b27


xtgee disprta expcom expcom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expcom = (0 (50) 500)) atmeans

xtprobit disprta expcom expcom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expcom expcom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expcom expcom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(expcom min mean)
simqi, fd(prval(1)) changex(expcom 0 1)
simqi, fd(prval(1)) changex(expcom 0 10)
simqi, fd(prval(1)) changex(expcom 0 30)
simqi, fd(prval(1)) changex(expcom 0 50)
simqi, fd(prval(1)) changex(expcom 0 75)
simqi, fd(prval(1)) changex(expcom 0 100)
simqi, fd(prval(1)) changex(expcom 0 -11.51919)
simqi, fd(prval(1)) changex(expcom 0 109.64227)
drop b1-b25


xtgee disprta expdef expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expdef = (0 (50) 500)) atmeans

xtprobit disprta expdef expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expdef expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expdef expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi, fd(prval(1)) changex(expdef min mean)
simqi, fd(prval(1)) changex(expdef 0 1)
simqi, fd(prval(1)) changex(expdef 0 10)
simqi, fd(prval(1)) changex(expdef 0 30)
simqi, fd(prval(1)) changex(expdef 0 50)
simqi, fd(prval(1)) changex(expdef 0 75)
simqi, fd(prval(1)) changex(expdef 0 100)
simqi, fd(prval(1)) changex(expdef 0 13.21328)
simqi, fd(prval(1)) changex(expdef 0 120.24826)
drop b1-b25


xtgee disprta experience experience2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(experience = (0 (100) 1000)) atmeans

xtprobit disprta experience experience2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta experience experience2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta experience experience2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(experience min mean)
simqi, fd(prval(1)) changex(experience 0 1)
simqi, fd(prval(1)) changex(experience 0 10)
simqi, fd(prval(1)) changex(experience 0 50)
simqi, fd(prval(1)) changex(experience 0 100)
simqi, fd(prval(1)) changex(experience 0 150)
simqi, fd(prval(1)) changex(experience 0 200)
simqi, fd(prval(1)) changex(experience 0 7.4838)
simqi, fd(prval(1)) changex(experience 0 224.1008)
drop b1-b25


****WITH INTERACTIONS
xtgee disprta exprta expwto exprta2 expwto2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprlgdpr expwlgdpr bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se replace
margins, dydx (*) atmeans
margins, at(exprta = (0 (100) 1000)) atmeans
margins, at(expwto = (0 (10) 70)) atmeans

xtprobit disprta exprta expwto exprta2 expwto2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprlgdpr expwlgdpr bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprta expwto exprta2 expwto2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprlgdpr expwlgdpr bandrta can mercosur d97-d08, re
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta exprta expwto exprta2 expwto2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprlgdpr expwlgdpr bandrta can mercosur d97-d08
setx mean
simqi
simqi
simqi, fd(prval(1)) changex(exprta min mean)
simqi, fd(prval(1)) changex(exprta 0 1)
simqi, fd(prval(1)) changex(exprta 0 10)
simqi, fd(prval(1)) changex(exprta 0 50)
simqi, fd(prval(1)) changex(exprta 0 100)
simqi, fd(prval(1)) changex(exprta 0 150)
simqi, fd(prval(1)) changex(exprta 0 200)
simqi, fd(prval(1)) changex(exprta 0 7.5021)
simqi, fd(prval(1)) changex(exprta 0 211.6363)

setx mean
simqi, fd(prval(1)) changex(expwto min mean)
simqi, fd(prval(1)) changex(expwto 0 1)
simqi, fd(prval(1)) changex(expwto 0 2)
simqi, fd(prval(1)) changex(expwto 0 3)
simqi, fd(prval(1)) changex(expwto 0 4)
simqi, fd(prval(1)) changex(expwto 0 5)
simqi, fd(prval(1)) changex(expwto 0 6)
simqi, fd(prval(1)) changex(expwto 0 -2.432226)
simqi, fd(prval(1)) changex(expwto 0 14.87838)
drop b1-b29

xtgee disprta exprtacom expwtocom exprtacom2 expwtocom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprcomlgdpr expwcomlgdpr bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(exprtacom = (0 (50) 500)) atmeans
margins, at(exprtacom = (0 1 2 3 4 5)) atmeans
margins, at(exprtacom = (0 (5) 100)) atmeans
margins, at(expwtocom = (0 (5) 40)) atmeans
margins, at(expwtocom = (0 1 2 3 4 5)) atmeans
margins, at(expwtocom = (0 (5) 100)) atmeans

xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprcomlgdpr expwcomlgdpr bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprcomlgdpr expwcomlgdpr bandrta can mercosur d97-d08, re
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta exprtacom expwtocom exprtacom2 expwtocom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprcomlgdpr expwcomlgdpr bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(exprtacom min mean)
simqi, fd(prval(1)) changex(exprtacom 0 1)
simqi, fd(prval(1)) changex(exprtacom 0 5)
simqi, fd(prval(1)) changex(exprtacom 0 10)
simqi, fd(prval(1)) changex(exprtacom 0 25)
simqi, fd(prval(1)) changex(exprtacom 0 40)
simqi, fd(prval(1)) changex(exprtacom 0 50)
simqi, fd(prval(1)) changex(exprtacom 0 -11.71091)
simqi, fd(prval(1)) changex(exprtacom 0 103.74167)

setx mean
simqi, fd(prval(1)) changex(expwtocom min mean)
simqi, fd(prval(1)) changex(expwtocom 0 1)
simqi, fd(prval(1)) changex(expwtocom 0 2)
simqi, fd(prval(1)) changex(expwtocom 0 3)
simqi, fd(prval(1)) changex(expwtocom 0 4)
simqi, fd(prval(1)) changex(expwtocom 0 5)
simqi, fd(prval(1)) changex(expwtocom 0 6)
simqi, fd(prval(1)) changex(expwtocom 0 -1.678742)
simqi, fd(prval(1)) changex(expwtocom 0 7.77105)
drop b1-b29


xtgee disprta exprtadef expwtodef exprtadef2 expwtodef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprdeflgdpr expwdeflgdpr bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(exprtadef = (0 (50) 500)) atmeans
margins, at(exprtadef = (0 1 2 3 4 5)) atmeans
margins, at(exprtadef = (0 (5) 100)) atmeans
margins, at(expwtodef = (0 (2) 30)) atmeans
margins, at(expwtodef = (0 1 2 3 4 5)) atmeans
margins, at(expwtodef = (0 (5) 100)) atmeans

xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprdeflgdpr expwdeflgdpr bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprdeflgdpr expwdeflgdpr bandrta can mercosur d97-d08, re
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta exprtadef expwtodef exprtadef2 expwtodef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 exprdeflgdpr expwdeflgdpr bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(exprtadef min mean)
simqi, fd(prval(1)) changex(exprtadef 0 1)
simqi, fd(prval(1)) changex(exprtadef 0 10)
simqi, fd(prval(1)) changex(exprtadef 0 30)
simqi, fd(prval(1)) changex(exprtadef 0 50)
simqi, fd(prval(1)) changex(exprtadef 0 75)
simqi, fd(prval(1)) changex(exprtadef 0 100)
simqi, fd(prval(1)) changex(exprtadef 0 12.93987)
simqi, fd(prval(1)) changex(exprtadef 0 114.16783)

setx mean
simqi, fd(prval(1)) changex(expwtodef min mean)
simqi, fd(prval(1)) changex(expwtodef 0 1)
simqi, fd(prval(1)) changex(expwtodef 0 2)
simqi, fd(prval(1)) changex(expwtodef 0 3)
simqi, fd(prval(1)) changex(expwtodef 0 4)
simqi, fd(prval(1)) changex(expwtodef 0 5)
simqi, fd(prval(1)) changex(expwtodef 0 6)
simqi, fd(prval(1)) changex(expwtodef 0 -1.172288)
simqi, fd(prval(1)) changex(expwtodef 0 7.526134)
drop b1-b29


xtgee disprta expcom expdef expcom2 expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expcomlgdpr expdeflgdpr bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expcom = (0 (50) 500)) atmeans
margins, at(expdef = (0 (50) 500)) atmeans

xtprobit disprta expcom expdef expcom2 expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expcomlgdpr expdeflgdpr bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expcom expdef expcom2 expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expcomlgdpr expdeflgdpr bandrta can mercosur d97-d08, re
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expcom expdef expcom2 expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expcomlgdpr expdeflgdpr bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(expcom min mean)
simqi, fd(prval(1)) changex(expcom 0 1)
simqi, fd(prval(1)) changex(expcom 0 10)
simqi, fd(prval(1)) changex(expcom 0 30)
simqi, fd(prval(1)) changex(expcom 0 50)
simqi, fd(prval(1)) changex(expcom 0 75)
simqi, fd(prval(1)) changex(expcom 0 100)
simqi, fd(prval(1)) changex(expcom 0 -11.51919)
simqi, fd(prval(1)) changex(expcom 0 109.64227)

setx mean
simqi, fd(prval(1)) changex(expdef min mean)
simqi, fd(prval(1)) changex(expdef 0 1)
simqi, fd(prval(1)) changex(expdef 0 10)
simqi, fd(prval(1)) changex(expdef 0 30)
simqi, fd(prval(1)) changex(expdef 0 50)
simqi, fd(prval(1)) changex(expdef 0 75)
simqi, fd(prval(1)) changex(expdef 0 100)
simqi, fd(prval(1)) changex(expdef 0 13.21328)
simqi, fd(prval(1)) changex(expdef 0 120.24826)
drop b1-b29


xtgee disprta expcom expcom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expcomlgdpr bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expcom = (0 (50) 500)) atmeans

xtprobit disprta expcom expcom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expcomlgdpr bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expcom expcom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expcomlgdpr bandrta can mercosur d97-d08, re
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expcom expcom2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expcomlgdpr bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(expcom min mean)
simqi, fd(prval(1)) changex(expcom 0 1)
simqi, fd(prval(1)) changex(expcom 0 10)
simqi, fd(prval(1)) changex(expcom 0 30)
simqi, fd(prval(1)) changex(expcom 0 50)
simqi, fd(prval(1)) changex(expcom 0 75)
simqi, fd(prval(1)) changex(expcom 0 100)
simqi, fd(prval(1)) changex(expcom 0 -11.51919)
simqi, fd(prval(1)) changex(expcom 0 109.64227)
drop b1-b26


xtgee disprta expdef expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expdeflgdpr bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expdef = (0 (50) 500)) atmeans

xtprobit disprta expdef expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expdeflgdpr bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expdef expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expdeflgdpr bandrta can mercosur d97-d08, re
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expdef expdef2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 expdeflgdpr bandrta can mercosur d97-d08
setx mean
simqi, fd(prval(1)) changex(expdef min mean)
simqi, fd(prval(1)) changex(expdef 0 1)
simqi, fd(prval(1)) changex(expdef 0 10)
simqi, fd(prval(1)) changex(expdef 0 30)
simqi, fd(prval(1)) changex(expdef 0 50)
simqi, fd(prval(1)) changex(expdef 0 75)
simqi, fd(prval(1)) changex(expdef 0 100)
simqi, fd(prval(1)) changex(expdef 0 13.21328)
simqi, fd(prval(1)) changex(expdef 0 120.24826)
drop b1-b26


xtgee disprta experience experience2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 explgdpr bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(experience = (0 (100) 1000)) atmeans

xtprobit disprta experience experience2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 explgdpr bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta experience experience2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 explgdpr bandrta can mercosur d97-d08, re
outreg2 using resdyads96finalint, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta experience experience2 lgdpratio_1 lxdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 lsxafcom_1 explgdpr bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(experience min mean)
simqi, fd(prval(1)) changex(experience 0 1)
simqi, fd(prval(1)) changex(experience 0 10)
simqi, fd(prval(1)) changex(experience 0 50)
simqi, fd(prval(1)) changex(experience 0 100)
simqi, fd(prval(1)) changex(experience 0 150)
simqi, fd(prval(1)) changex(experience 0 200)
simqi, fd(prval(1)) changex(experience 0 7.4838)
simqi, fd(prval(1)) changex(experience 0 224.1008)
drop b1-b26

log close


****para m‡s tarde!

log using "/Users/andrea/Documents/DSM/INITIATION/resultsinidyadspoli2.log", replace

**con poli2

xtgee disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
xtprobit disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append

xtgee disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append

xtgee disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 lsxafcom_1 exprsxaf exprgdpr gdprsxaf bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append

log close

**** DESCRIPTIVES

discard
capture log close
set more off
cd "/Users/andrea/Documents/DSM/INITIATION"
clear
clear matrix
set mem 100m
clear
use datadyadssa96.dta
iis cr
tis year
set matsize 800
tsset cr year

log using "/Users/andrea/Documents/DSM/INITIATION\descriptivesdyads96.log", replace

xtsum disprta exprta exprtacom exprtadef expwto expwtocom expwtodef expcom expdef experience countrta bandrta gdpratio gdppc00com xdepcom sxafcom exprsxaf exprgdpr gdprsxaf civlicom civlires poli2com poli2res can mercosur

log close


****OLD:
xtgee disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se replace
margins, dydx (*) atmeans
margins, at(exprta = (0 (100) 1000)) atmeans
margins, at(expwto = (0 (10) 70)) atmeans

xtprobit disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(exprta min mean)
simqi, fd(prval(1)) changex(exprta 0 1)
simqi, fd(prval(1)) changex(exprta 0 10)
simqi, fd(prval(1)) changex(exprta 0 50)
simqi, fd(prval(1)) changex(exprta 0 100)
simqi, fd(prval(1)) changex(exprta 0 150)
simqi, fd(prval(1)) changex(exprta 0 200)
simqi, fd(prval(1)) changex(exprta 0 7.5021)
simqi, fd(prval(1)) changex(exprta 0 211.6363)

setx mean
simqi, fd(prval(1)) changex(expwto min mean)
simqi, fd(prval(1)) changex(expwto 0 1)
simqi, fd(prval(1)) changex(expwto 0 2)
simqi, fd(prval(1)) changex(expwto 0 3)
simqi, fd(prval(1)) changex(expwto 0 4)
simqi, fd(prval(1)) changex(expwto 0 5)
simqi, fd(prval(1)) changex(expwto 0 6)
simqi, fd(prval(1)) changex(expwto 0 -2.432226)
simqi, fd(prval(1)) changex(expwto 0 14.87838)
drop b1-b27


xtgee disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(exprtacom = (0 (50) 500)) atmeans
margins, at(exprtacom = (0 1 2 3 4 5)) atmeans
margins, at(exprtacom = (0 (5) 100)) atmeans
margins, at(expwtocom = (0 (5) 40)) atmeans
margins, at(expwtocom = (0 1 2 3 4 5)) atmeans
margins, at(expwtocom = (0 (5) 100)) atmeans

xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(exprtacom min mean)
simqi, fd(prval(1)) changex(exprtacom 0 1)
simqi, fd(prval(1)) changex(exprtacom 0 5)
simqi, fd(prval(1)) changex(exprtacom 0 10)
simqi, fd(prval(1)) changex(exprtacom 0 25)
simqi, fd(prval(1)) changex(exprtacom 0 40)
simqi, fd(prval(1)) changex(exprtacom 0 50)
simqi, fd(prval(1)) changex(exprtacom 0 -11.71091)
simqi, fd(prval(1)) changex(exprtacom 0 103.74167)

setx mean
simqi, fd(prval(1)) changex(expwtocom min mean)
simqi, fd(prval(1)) changex(expwtocom 0 1)
simqi, fd(prval(1)) changex(expwtocom 0 2)
simqi, fd(prval(1)) changex(expwtocom 0 3)
simqi, fd(prval(1)) changex(expwtocom 0 4)
simqi, fd(prval(1)) changex(expwtocom 0 5)
simqi, fd(prval(1)) changex(expwtocom 0 6)
simqi, fd(prval(1)) changex(expwtocom 0 -1.678742)
simqi, fd(prval(1)) changex(expwtocom 0 7.77105)
drop b1-b27


xtgee disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(exprtadef = (0 (50) 500)) atmeans
margins, at(exprtadef = (0 1 2 3 4 5)) atmeans
margins, at(exprtadef = (0 (5) 100)) atmeans
margins, at(expwtodef = (0 (2) 30)) atmeans
margins, at(expwtodef = (0 1 2 3 4 5)) atmeans
margins, at(expwtodef = (0 (5) 100)) atmeans

xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(exprtadef min mean)
simqi, fd(prval(1)) changex(exprtadef 0 1)
simqi, fd(prval(1)) changex(exprtadef 0 10)
simqi, fd(prval(1)) changex(exprtadef 0 30)
simqi, fd(prval(1)) changex(exprtadef 0 50)
simqi, fd(prval(1)) changex(exprtadef 0 75)
simqi, fd(prval(1)) changex(exprtadef 0 100)
simqi, fd(prval(1)) changex(exprtadef 0 12.93987)
simqi, fd(prval(1)) changex(exprtadef 0 114.16783)

setx mean
simqi, fd(prval(1)) changex(expwtodef min mean)
simqi, fd(prval(1)) changex(expwtodef 0 1)
simqi, fd(prval(1)) changex(expwtodef 0 2)
simqi, fd(prval(1)) changex(expwtodef 0 3)
simqi, fd(prval(1)) changex(expwtodef 0 4)
simqi, fd(prval(1)) changex(expwtodef 0 5)
simqi, fd(prval(1)) changex(expwtodef 0 6)
simqi, fd(prval(1)) changex(expwtodef 0 -1.172288)
simqi, fd(prval(1)) changex(expwtodef 0 7.526134)
drop b1-b27


xtgee disprta expcom expdef expcom2 expdef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expcom = (0 (50) 500)) atmeans
margins, at(expdef = (0 (50) 500)) atmeans

xtprobit disprta expcom expdef expcom2 expdef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expcom expdef expcom2 expdef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expcom expdef expcom2 expdef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(expcom min mean)
simqi, fd(prval(1)) changex(expcom 0 1)
simqi, fd(prval(1)) changex(expcom 0 10)
simqi, fd(prval(1)) changex(expcom 0 30)
simqi, fd(prval(1)) changex(expcom 0 50)
simqi, fd(prval(1)) changex(expcom 0 75)
simqi, fd(prval(1)) changex(expcom 0 100)
simqi, fd(prval(1)) changex(expcom 0 -11.51919)
simqi, fd(prval(1)) changex(expcom 0 109.64227)

setx mean
simqi, fd(prval(1)) changex(expdef min mean)
simqi, fd(prval(1)) changex(expdef 0 1)
simqi, fd(prval(1)) changex(expdef 0 10)
simqi, fd(prval(1)) changex(expdef 0 30)
simqi, fd(prval(1)) changex(expdef 0 50)
simqi, fd(prval(1)) changex(expdef 0 75)
simqi, fd(prval(1)) changex(expdef 0 100)
simqi, fd(prval(1)) changex(expdef 0 13.21328)
simqi, fd(prval(1)) changex(expdef 0 120.24826)
drop b1-b27


xtgee disprta expcom expcom2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expcom = (0 (50) 500)) atmeans

xtprobit disprta expcom expcom2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expcom expcom2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expcom expcom2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(expcom min mean)
simqi, fd(prval(1)) changex(expcom 0 1)
simqi, fd(prval(1)) changex(expcom 0 10)
simqi, fd(prval(1)) changex(expcom 0 30)
simqi, fd(prval(1)) changex(expcom 0 50)
simqi, fd(prval(1)) changex(expcom 0 75)
simqi, fd(prval(1)) changex(expcom 0 100)
simqi, fd(prval(1)) changex(expcom 0 -11.51919)
simqi, fd(prval(1)) changex(expcom 0 109.64227)
drop b1-b25


xtgee disprta expdef expdef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(expdef = (0 (50) 500)) atmeans

xtprobit disprta expdef expdef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta expdef expdef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta expdef expdef2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi, fd(prval(1)) changex(expdef min mean)
simqi, fd(prval(1)) changex(expdef 0 1)
simqi, fd(prval(1)) changex(expdef 0 10)
simqi, fd(prval(1)) changex(expdef 0 30)
simqi, fd(prval(1)) changex(expdef 0 50)
simqi, fd(prval(1)) changex(expdef 0 75)
simqi, fd(prval(1)) changex(expdef 0 100)
simqi, fd(prval(1)) changex(expdef 0 13.21328)
simqi, fd(prval(1)) changex(expdef 0 120.24826)
drop b1-b25


xtgee disprta experience experience2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
margins, at(experience = (0 (100) 1000)) atmeans

xtprobit disprta experience experience2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta experience experience2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
estsimp probit disprta experience experience2 gdpratio_1 xdepcom_1 countrta civlicom_1 civlires_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08
setx mean
simqi
simqi, fd(prval(1)) changex(experience min mean)
simqi, fd(prval(1)) changex(experience 0 1)
simqi, fd(prval(1)) changex(experience 0 10)
simqi, fd(prval(1)) changex(experience 0 50)
simqi, fd(prval(1)) changex(experience 0 100)
simqi, fd(prval(1)) changex(experience 0 150)
simqi, fd(prval(1)) changex(experience 0 200)
simqi, fd(prval(1)) changex(experience 0 7.4838)
simqi, fd(prval(1)) changex(experience 0 224.1008)
drop b1-b25


**con poli2

xtgee disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
xtprobit disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprta expwto exprta2 expwto2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append

xtgee disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtacom expwtocom exprtacom2 expwtocom2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append

xtgee disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, family(bin) link(probit) corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
margins, dydx (*) atmeans
xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, pa corr(ar1) robust force
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append
xtprobit disprta exprtadef expwtodef exprtadef2 expwtodef2 gdpratio_1 xdepcom_1 countrta poli2com_1 poli2res_1 lgdppc00com_1 sxafcom_1 bandrta can mercosur d97-d08, re
outreg2 using resdyads96final, ctitle(disprta) bdec(3) coefastr se append

log close

**** DESCRIPTIVES

discard
capture log close
set more off
cd "/Users/andrea/Documents/DSM/INITIATION"
clear
clear matrix
set mem 100m
clear
use datadyadssa96.dta
iis cr
tis year
set matsize 800
tsset cr year

log using "/Users/andrea/Documents/DSM/INITIATION\descriptivesdyads96.log", replace

xtsum disprta exprta exprtacom exprtadef expwto expwtocom expwtodef expcom expdef experience countrta bandrta gdpratio lgdppc00com xdepcom sxafcom civlicom civlires poli2com poli2res can mercosur

log close
