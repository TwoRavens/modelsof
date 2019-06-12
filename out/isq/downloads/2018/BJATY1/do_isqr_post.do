* Final update: 7 December 2010
* Do-file for Hunjoon Kim and Kathryn Sikkink, "Explaining the Deterrence Effect of Human Rights Prosecutions
* 						for Transitional Countries," International Studies Quarterly 54(4), 939-963
* * For any further questions, contact Hunjoon Kim h.kim@griffith.edu.au

set more off
capture log close
log using k:\in.progress\3.isqr-trt1\isqr, text replace
use k:\in.progress\3.isqr-trt1\trtdata_isqr.post.dta, clear

*** Model 1: Original Poe's model

xtpcse physint physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, hetonly

* Test for various time and region specifications (time square, time cubic, time dummies)
gen yearsq = (year2)^2
gen yearcb = (year2)^3
xtpcse physint physlag polity2 t2iwar t3cwar lgdppc gdpgrth inthrcom lpop popchang rg1-rg4 ///
	year2 yearsq yearcb, hetonly
drop yearsq yearcb

tab year2, gen(yr)
xtpcse physint physlag polity2 t2iwar t3cwar lgdppc gdpgrth inthrcom lpop popchang rg1-rg4 yr1-yr24, hetonly
test yr3=yr4=yr5=yr6=yr7=yr8=yr9=yr10=yr11=yr12=yr13=yr14=yr15=yr16=yr17=yr18=yr19=yr20=yr21=yr22=yr23=yr24
test yr1 yr2 yr3 yr4 yr5 yr6 yr7 yr8 yr9 yr10 yr11 yr12 yr13 yr14 yr15 ///
	yr16 yr17 yr18 yr19 yr20 yr21 yr22 yr23 yr24
drop yr1-yr25

* Ordered probit model
oprobit physint physlag polity2 t2iwar t3cwar lgdppc gdpgrth inthrcom lpop popchang rg1-rg4 year2, ///
	cluster(cowid) nolog

* Estimates without lagged DV
xtpcse physint polity2 t2iwar t3cwar lgdppc gdpgrth inthrcom lpop popchang rg1-rg4 year2, corr(ar1) hetonly
oprobit physint polity2 t2iwar t3cwar lgdppc gdpgrth inthrcom lpop popchang rg1-rg4 year2, cluster(cowid) nolog


*** Model 2: Trial and Truth commission

** Models using TRT as IV(Model 2a)

xtpcse physint etrt, hetonly
xtpcse physint etrt etc physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, hetonly

* Fixed effect model (Model 3a) - with and without lagged DV
xtreg physint etrt etc physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, ///
	fe i(cowid)
xtreg physint etrt etc polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, ///
	fe i(cowid)

* Ordered probit model
oprobit physint etrt etc psl1-psl8 polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, cluster(cowid) nolog

* Using PTS instead of PHYSINT
xtpcse ainew etrt etc ailag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, hetonly
xtpcse sdnew etrt etc sdlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, hetonly


** Models using CTRT as IV (Model 2b)

* CTRT and TC experience
xtpcse physint lctrt, hetonly
xtpcse physint lctrt etc physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, hetonly

* Fixed effect model (Model 3b) - with and without lagged DV
xtreg physint lctrt etc physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, fe i(cowid)
xtreg physint lctrt etc polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, fe i(cowid)

* Ordered probit model
oprobit physint lctrt etc psl1-psl8 polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year, cluster(cowid) nolog

* Using PTS instead of PHYSINT
xtpcse ainew lctrt etc ailag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, hetonly
xtpcse sdnew lctrt etc sdlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, hetonly


*** Test for Civil War and Civil War Transition Effects (Model 5)

** Models using TRT as IV (Model 5a)

xtpcse physint etrt cwXetrt sfXetrt etc cwXetc sfXetc ///
	physlag polity2 t2iwar t3cwar sf inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, hetonly
lincom etrt
lincom etrt + sfXetrt 
lincom etrt + sfXetrt + cwXetrt 
lincom etrt + sfXetrt + 2*cwXetrt 
lincom etrt + sfXetrt + 3*cwXetrt 
lincom etrt + cwXetrt 
lincom etrt + 2*cwXetrt 
lincom etrt + 3*cwXetrt 

* Fixed effect model - with and without lagged DV
xtreg physint etrt cwXetrt sfXetrt etc cwXetc sfXetc ///
	physlag polity2 t2iwar t3cwar sf inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, fe i(cowid)
xtreg physint etrt cwXetrt sfXetrt etc cwXetc sfXetc ///
	polity2 t2iwar t3cwar sf inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, fe i(cowid)

* Ordered probit model
oprobit physint etrt cwXetrt sfXetrt etc cwXetc sfXetc ///
	psl1-psl8 polity2 t2iwar t3cwar sf inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, ///
	cluster(cowid) nolog

** Models using CTRT as IV (Model 5b)

xtpcse physint lctrt cwXlctrt sfXlctrt etc cwXetc sfXetc ///
	physlag polity2 t2iwar t3cwar sf inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, hetonly

* Fixed effect model - with and without lagged DV
xtreg physint lctrt cwXlctrt sfXlctrt etc cwXetc sfXetc ///
	physlag polity2 t2iwar t3cwar sf inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, fe i(cowid)
xtreg physint lctrt cwXlctrt sfXlctrt etc cwXetc sfXetc ///
	polity2 t2iwar t3cwar sf inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, fe i(cowid)

* Ordered probit model
oprobit physint lctrt cwXlctrt sfXlctrt etc cwXetc sfXetc ///
	psl1-psl8 polity2 t2iwar t3cwar sf inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, ///
	cluster(cowid) nolog


* Test for Regional TRT and CTRT Experience (Modle 6)

* Models using TRT as IV (Model 6a)

xtpcse physint regetrt etrt etc ///
	physlag polity2 t2iwar t3cwar lgdppc gdpgrth inthrcom lpop popchang rg1-rg4 year2, hetonly

* Fixed effect models - with and without lagged DV
xtreg physint regetrt etrt etc physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, fe i(cowid)
xtreg physint regetrt etrt etc polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, fe i(cowid)

* Ordered probit model
oprobit physint regetrt etrt etc psl1-psl8 ///
	polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, cluster(cowid) nolog


* Models using CTRT as IV (Model 6b)

xtpcse physint reglctrt lctrt etc ///
	physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, hetonly

* Fixed effect models - with and without lagged DV
xtreg physint reglctrt lctrt etc physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, fe i(cowid)
xtreg physint reglctrt lctrt etc polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1-rg4 year2, fe i(cowid)

* Ordered probit model
oprobit physint reglctrt lctrt etc psl1-psl8 ///
	polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, cluster(cowid) nolog


*** Two-Stage Estimations (Model 4)

** Using TRT as IV: Two-stage probit least squares (using cdsimeq) (Model 4a)

cdsimeq (physint etc physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang ///
	rg1 rg2 rg3 rg4 year2) ///
	(etrt reg2prec etc polity2 physlag lhrngo2 inthrcom demotran sfcwtran legbrit lgdppc gdpgrth ///
	rg1-rg4 year2), asis


*** Using CRTR as IV: G2SLS IV regression (cowid) (Model 4b)
xtivreg physint ///
	(lctrt = reg2prec etc polity2 physlag lhrngo2 inthrcom demotran sfcwtran legbrit lgdppc gdpgrth ///
	rg1-rg4 year2) ///
	etc physlag polity2 t2iwar t3cwar inthrcom lgdppc gdpgrth lpop popchang rg1-rg4 year2, ///
	re i(cowid) first

log close
