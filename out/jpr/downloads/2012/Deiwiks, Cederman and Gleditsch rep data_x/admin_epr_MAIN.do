
clear
clear matrix
set mem 500m

*******************************************************
*******************************************************
* FIRST CHANGE THIS TO YOUR WORKING DIRECTORY *********
cd "/Users/cdeiwiks/Documents/PHD/Deiwiks, Cederman, Gleditsch/STATA"

clear
insheet using "ineqagg_100322_pgs_y.csv", comma
sort adminunits_auid year
save mountains.dta, replace

clear 
insheet using "ineqagg_100406_gr_y.csv", comma

drop if geotype == 5
drop if statusid == 1 | statusid == 5 //drop monopoly and dominant
drop if popintersection < 5000
drop if popintersection == .

gen one = 1
bys adminunits_auid year: egen numgroups = sum(one)
drop one
//******* dyadic overlap *************
gen overlap = intersectionarea/(areasqkm+grouparea-intersectionarea)
gen overlappop = popintersection/(sumpop90+popgroup-popintersection)
summ overlap overlappop

gen overlap2 = intersectionarea*intersectionarea/areasqkm*grouparea
gen overlappop2 = popintersection*popintersection/sumpop90*popgroup
//***********************************

rename groups_cowgroupid cowgroupid
rename popintersection gpop

gen excluded = 0
replace excluded = 1 if statusid == 2 | statusid == 6 | statusid == 7 | statusid == 10
count if statusid == 3 // state collapse (0)
count if statusid == 8 // irrelevant (292)  
drop if statusid == 8  // drop irrelevant

gen ngroups = 1				
gen nexclgroups = 1 if excluded == 1

gen nautgroups = 1 if statusid == 6  // autonomy
gen ndiscgroups = 1 if statusid == 2 // discr
gen nsepgroups = 1 if statusid == 7 //separatist
gen npowgroups = 1 if statusid == 10 //powerless
gen nmondomgroups = 1 if statusid == 1 | statusid == 5 // monopoly or dominant

duplicates drop adminunits_auid year cowgroupid, force
drop if cowgroupid == .
drop if year == .
drop if adminunits_auid == .

bys adminunits_auid year: egen sumgpop=sum(gpop)
bys adminunits_auid year: egen sumexclpop=sum(gpop) if excluded==1
bys adminunits_auid year: egen maxexclpop=max(gpop) if excluded==1
bys adminunits_auid year: egen maxpop=max(gpop)

replace maxexclpop=0 if maxexclpop==.
gen maxexclrpop = maxexclpop/sumgpop
gen sumexclrpop = sumexclpop/sumgpop

// max excluded group fractionalization
bys cowgroupid year: egen sumgrouppop=sum(gpop)
gen one = 1
bys cowgroupid year: egen nexclgroupsecs=sum(one) if excluded==1
replace nexclgroupsecs = 0 if nexclgroupsecs == .
gen nmaxgroupsecs = nexclgroupsecs if gpop==maxexclpop & gpop!=0

//max excluded group share
replace nmaxgroupsecs = 0 if nmaxgroupsecs == .
replace sumgrouppop = 0 if sumgrouppop ==.
gen maxgroupshare = maxexclpop/sumgrouppop if gpop==maxexclpop & gpop!=0
replace maxgroupshare = 0 if maxgroupshare == .

// average group fractionalization
bys cowgroupid year: egen ngroupsecs = sum(one)

bys adminunits_auid year: egen meanexclgroupsecs = mean(nexclgroupsecs)
bys adminunits_auid year: egen minexclgroupsecs = min(nexclgroupsecs)
replace meanexclgroupsecs = 0 if meanexclgroupsecs == .
replace minexclgroupsecs = 0 if minexclgroupsecs == .

gen maxexcluded = 0
replace maxexcluded = 1 if gpop==maxpop & gpop!=0 & excluded == 1 //the largest group in the AU is excluded 

gen maxaut = 0
replace maxaut = 1 if gpop==maxexclpop & gpop!=0 & statusid == 6  // the largest excluded group in the AU has autonomy

gen maxsep = 0
replace maxsep = 1 if gpop==maxexclpop & gpop!=0 & statusid == 7 //...separatist

gen maxdisc = 0
replace maxdisc = 1 if gpop==maxexclpop & gpop!=0 & statusid == 2 // discr

gen maxpowerless = 0
replace maxpowerless = 1 if gpop==maxexclpop & gpop!=0 & statusid == 10 //powerless

//gen maxgroup = group if gpop==maxexclpop & gpop!=0

gen popshare = gpop/sumgpop
gen sqpopshare = popshare*popshare

gen exclpopshare = gpop/sumexclpop if excluded==1
gen sqexclpopshare = exclpopshare*exclpopshare if excluded==1

gen exclpopsharegroup = gpop/sumgrouppop if excluded == 1

//=============================== collapse to adminunit year ============================================//
sort adminunits_auid year
collapse (sum)ngroups (sum)sqpopshare (sum)nexclgroups (sum)sqexclpopshare (sum)nautgroups (sum)ndiscgroups (sum)nsepgroups ///
	(sum)nmondomgroups (max)maxexclpop (max)maxexclrpop sumexclrpop meanexclgroupsecs minexclgroupsecs (max) exclpopsharegroup ///
	(max)maxgroupshare (max)nmaxgroupsecs (max)maxaut (max)maxsep (max)maxdisc (max)maxpowerless (max)maxexcluded (max)excluded ///
	(max)sumexclpop (min)numau (max)onset overlap overlappop overlap2 overlappop2 numgroups, by (adminunits_auid year)
//=======================================================================================================//

replace ngroups=0 if ngroups==.
gen gelf = 1-sqpopshare
replace gelf = 0 if gelf==.

replace nexclgroups=0 if nexclgroups==.
gen exclgelf = 1-sqexclpopshare
replace exclgelf = 0 if exclgelf==.

replace nautgroups = 0 if nautgroups == .
replace ndiscgroups = 0 if ndiscgroups == .
replace nsepgroups = 0 if nsepgroups == .
replace nmondomgroups = 0 if nmondomgroups == .

replace maxexclpop = 0 if maxexclpop==.

sort adminunits_auid year
save tempadmin, replace
clear


// Static coflict coding
insheet using "ineqagg_panel100715.csv", comma
gen onset1992 = 0
replace onset1992=1 if onset==1 & year>1991 & year!=.
sort adminunits_auid
collapse (max)onset1992, by(adminunits_auid)
save staticconflicts.dta, replace


clear

//======= admin unit panel data == 66 conflict onsets ===
insheet using "ineqagg_panel100715.csv", comma
//=======================================================
gen ccode = cowcode

sort ccode year
merge ccode year using Country-Level.dta, nokeep
drop _merge

sort adminunits_auid year
merge adminunits_auid year using mountains
drop _merge

sort adminunits_auid
merge adminunits_auid using staticconflicts
drop _merge

duplicates report adminunits_auid year

// ==== final dataset ================================================================================
sort adminunits_auid year
merge adminunits_auid year using tempadmin, keep(ngroups gelf nexclgroups exclgelf nautgroups ndiscgroups nsepgroups nmondomgroups ///
	maxexclpop maxexclrpop sumexclrpop maxgroupshare meanexclgroupsecs minexclgroupsecs exclpopsharegroup nmaxgroupsecs ///
	maxaut maxsep maxdisc maxpowerless maxexcluded excluded sumexclpop overlap overlappop overlap2 overlappop2 numgroups)
drop _merge
// ===================================================================================================

duplicates report adminunits_auid year

gen one = 1
bys cowcode year: egen sumunits = sum(one)
gen lsumunits = log(sumunits)

gen ethnicau = 1
replace ethnicau = 0 if ngroups ==. //12918

replace ngroups=0 if ngroups==.
replace gelf = 0 if gelf==.
replace nexclgroups=0 if nexclgroups==.
replace exclgelf = 0 if exclgelf==.
replace nautgroups = 0 if nautgroups == .
replace ndiscgroups = 0 if ndiscgroups == .
replace nsepgroups = 0 if nsepgroups == .
replace nmondomgroups = 0 if nmondomgroups == .
replace maxexclpop = 0 if maxexclpop==.
replace maxaut = 0 if maxaut==.
replace maxsep = 0 if maxsep==.
replace maxdisc = 0 if maxdisc==.
replace maxexcluded = 0 if maxexcluded==.
replace excluded = 0 if excluded == .
replace sumexclpop = 0 if sumexclpop ==.
gen popdens = epr_popavg/epr_area


btscs incidence year adminunits_auid, g(peaceyears) nspline(3)

//=== warhist adminunit ===============
gen warhist=0
sort adminunits_auid year
bys adminunits_auid: replace warhist=sum(onset)
replace warhist=warhist-1 if onset==1
	//dummy
gen warhist1=warhist
replace warhist1=1 if warhist>0


//=== warhist country =================
bys ccode year: egen warhistcy = sum(onset)
sort adminunits_auid year
bys adminunits_auid: gen warhistc=sum(warhistcy)  // running sum of onsets
replace warhistc = warhistc-warhistcy if onset == 1
	//dummy
gen warhistc1 = 0
replace warhistc1 = 1 if warhistc > 0

	// list adminunits_auid year warhist warhist1 warhistc warhistc1 if adminunits_auid == 230067
	
	
//=== post cold war dummy ========================	
gen pcw = 0
replace pcw=1 if year>1989
gen pcwyear=pcw*year
//================================================

//=== geographic variables =======================
gen lminborddist = log(minborddist)
gen lmincapdist = log(mincapdist)

bys cowcode year: egen avgcapdist=mean(meancapdist)
gen relcapdist = meancapdist/avgcapdist

gen gdpcap = sumnordhaus90*1000000 / sumpop90
gen lgdpcap = log(gdpcap)
//================================================

//=== net wealth ===============================================
gen netnordhaus = sumnordhaus - sumoil90/1000

bys cowcode year: egen sumgdpcap = sum(sumnordhaus90*1000000)
bys cowcode year: egen sumpop = sum(sumpop90)
bys cowcode year: egen sumnetgdp=sum(netnordhaus)

gen avggdpcap = sumgdpcap / sumpop
gen netavggdpcap = sumnetgdp / sumpop
gen netgdpcap=netnordhaus/sumpop90
//==============================================================

//=== INEQUALITY =============================
gen ineq = gdpcap/avggdpcap

gen lineq = log(gdpcap) - log(avggdpcap)
gen lineq2 = lineq*lineq

gen high = ineq
replace high=0 if ineq<1 & ineq!=.

gen low = 1/ineq
replace low=0 if ineq>1 & ineq!=.



gen lhigh = lineq
replace lhigh=0 if lineq<0 & lineq!=.

gen llow = log(1/ineq)
replace llow=0 if lineq>0 & lineq!=.

gen lhigh2 = lhigh*lhigh
gen llow2 = llow*llow

gen high20 = 0
replace high20=1 if high>1.2 & high!=.

gen low20 = 0
replace low20=1 if low>1.2 & low!=.

gen high15 = 0
replace high15=1 if high>1.5 & high!=.

gen low15 = 0
replace low15=1 if low>1.5 & low!=.


gen llow2excl = llow2 * maxexclpop
gen lhigh2excl = lhigh2 * maxexclpop


//=== net inequality ==
gen netineq = netgdpcap/netavggdpcap
gen lnetineq = log(netineq)
gen lnetineq2 = lnetineq^2

gen lnetineq2hi = lnetineq2
replace lnetineq2hi = 0 if lnetineq<0 & lnetineq!=.
gen lnetineq2lo = lnetineq2
replace lnetineq2lo = 0 if lnetineq>0 & lnetineq!=.

gen petro = 0
replace petro=1 if petrosqkm > 0 & petrosqkm!=.

gen lavggdpcap = log(avggdpcap)
gen lsumpop90 = log(sumpop90)

gen majexcl = 0
replace majexcl=1 if maxexclrpop>0.5 & maxexclrpop!=.


gen nethigh = netineq
replace nethigh=0 if netineq<1 & ineq!=.

gen netlow = 1/netineq
replace netlow = 0 if netineq>1 & ineq!=.

/*
gen excl = 0
replace excl = 1 if popexcl>0 & popexcl!=.

gen exclshare = popexcl/popepr
replace exclshare = 0 if exclshare == .

gen exclshare0 = popexcl/sumpop90
replace exclshare0 = 0 if exclshare0 == .

gen excl30 = 0
replace excl30=1 if exclshare>0.3 & exclshare!=.
*/

// admin unit pop density

bys cowcode year: egen sumarea = sum(areasqkm)
gen audens = sumpop90 / areasqkm
gen countrydens = sumpop / sumarea
gen devdens = audens / countrydens
gen ldevdens = log(devdens)
gen ldevdens2 = ldevdens^2

gen popshare = sumpop90 / sumpop
gen lpopshare = log(popshare)

gen bal = sumpop90 / epr_milper
gen lbal = log(bal)


// dummies
gen exclg = nexclgroups
replace exclg = 1 if nexclgroups>1 & nexclgroups!=.

gen discg = ndiscgroups
replace discg = 1 if ndiscgroups>1 & ndiscgroups!=.

gen autg = nautgroups
replace autg = 1 if nautgroups>1 & nautgroups!=.

gen sepg = nsepgroups
replace sepg = 1 if nsepgroups>1 & nsepgroups!=.

gen ebal = maxexclpop/(maxexclpop+epr_egippop)
replace ebal = 0 if ebal==.

gen gbal = maxexclpop/sumpop


gen aut = 0
replace aut = 1 if maxaut == 1 | maxsep == 1

gen maxexclrpop2 = maxexclrpop*maxexclrpop

gen lpopdens = log(popdens)

gen superexcl = 0
replace superexcl = 1 if maxdisc == 1 | maxpowerless == 1 

gen exclbot3 = 0
replace exclbot3 = 1 if maxdisc == 1 | maxpowerless == 1  | maxsep ==1

gen lnautgroups = log(nautgroups)
replace lnautgroups = 0 if lnautgroups == .

gen nautgroups1 = 0
replace nautgroups1 = 1 if nautgroups > 0

gen concexclgroup = 0
replace concexclgroup = 1 if minexclgroupsecs == 1


gen maxautsep = maxaut==1|maxsep==1

gen aupopdens = sumpop90/areasqkm

gen highlow = 0
replace highlow = high if high > 0
replace highlow = low if low > 0 

gen lmeanborddist = log(meanborddist)
gen lmeancapdist = log(meancapdist)

//*** attempts with interaction effects ***

gen lowmean = (low >= 0.8286541)
gen highmean = (high >= 0.5055)

gen excllow = excluded*lowmean
gen exclhigh = excluded*highmean
//***************************************************

	// exclude adminunits that experience conflict in 1990
//drop ong1990
gen ong1990 = 0
replace ong1990=1 if year==1990 & ongoingdrop==1
//drop ongoing1990
bys adminunits_auid: egen ongoing1990 = max(ong1990)


// STATA: stop.../////////////////////////////////////////////////////////////////////
stop

save temp.dta, replace
clear
use temp.dta



//*******************************************************************//
//						Analysis 
//*******************************************************************//

//=====================  MODELS 1-4  =======================//
relogit onset lineq2  						epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
 outreg2 using results, word alpha(0.001, 0.01, 0.05) replace
relogit onset lineq2 	excluded 			epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
 outreg2 using results, word alpha(0.001, 0.01, 0.05)
relogit onset lineq2 	excluded maxautsep	epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
 outreg2 using results, word alpha(0.001, 0.01, 0.05)
relogit onset high low 	excluded maxautsep 	epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
 outreg2 using results, word alpha(0.001, 0.01, 0.05)
//==========================================================//

logit onset high low 	excluded maxautsep 	epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
logit onset high low 	excluded maxautsep 	epr_lgdpcapl epr_lpop warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 

logit onset lineq2 epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
prgen lineq2, f(-2) t(2) gen(pplineq2)
twoway (line pplinp1 pplinx, clpattern("shortdash") xtitle("Inequality") ytitle("Pr(conflict)") legend(order(1 "rich units" 2 "poor units"))) 

drop pp*
prgen high, f(0) t(4.3) x(low 0 maxautsep 0 excluded 0) rest() gen(pphigh)
prgen low, f(0) t(7.1) x(high 0 maxautsep 0 excluded 0) rest() gen(pplow)
twoway (line pphighp1 pphighx, clpattern("shortdash") xtitle("low/high") ytitle("Pr(conflict)") legend(order(1 "rich units" 2 "poor units"))) (line pplowp1 pplowx, clpattern("dash"))

/* Predicted probabilities */
drop newva*
logit onset high low excluded maxautsep epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
prgen excluded, f(0) t(1) x(high max low 0) rest() gen(newvar1)
prgen excluded, f(0) t(1) x(high 0 low max) rest() gen(newvar2)
prgen excluded, f(0) t(1) x(high 0 low 0) rest() gen(newvar3)
twoway (line newvap1 newvax, clpattern("shortdash") xtitle("Excluded") ytitle("Pr(conflict)") legend(order(1 "rich units" 2 "poor units" 3 "average"))) (line newvar2p1 newvar2x, clpattern("dash")) (line newvar3p1 newvar3x) 

logit onset high low excluded maxautsep epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
prgen maxautsep, f(0) t(1) x(high max low 0) rest() gen(newvar4)
prgen maxautsep, f(0) t(1) x(high 0 low max) rest() gen(newvar5)
prgen maxautsep, f(0) t(1) x(high 0 low 0) rest() gen(newvar6)
twoway (line newvar4p1 newvar4x, clpattern("shortdash") xtitle("Reg. Autonomy") ytitle("Pr(conflict)") legend(order(1 "rich units" 2 "poor units	" 3 "average"))) (line newvar5p1 newvar5x, clpattern("dash")) (line newvar3p1 newvar3x) 


//**************** Almost U curve *************************************
clear
use temp.dta

logit onset high low excluded maxautsep epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
prgen high, f(0) t(7) x(low 0) rest() ci gen(pphigh)
prgen low,  f(0) t(7) x(high 0) rest() ci gen(pplow) 

keep pphig* pplow*
gen id = _n

save predprob.dta, replace
clear
use predprob.dta
drop if pphighx ==.

gen ppx1 = pphighx
gen ppx2 = -pplowx
gen ppy1 = pphighp1
gen ppy2 = pplowp1
//upper bound
gen ppyub1 = pphighp1ub
gen ppyub2 = pplowp1ub
//lower bound
gen ppylb1 = pphighp1lb
gen ppylb2 = pplowp1lb


reshape long ppx ppy ppyub ppylb, i(id) j(comb)  
sort ppx
twoway (line ppy ppx, xtitle("Inequality") ytitle("Pr(conflict)")) (line ppyub ppx, clpattern("shortdash")) (line ppylb ppx, clpattern("shortdash")) // yscale(range(0.0001))

//************** U curve *******************
estsimp logit onset high low 	excluded maxautsep	epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
setx mean
drop pi
generate plow = .
generate phi = .
generate ageaxis = _n + 17 in 1/78
setx mean
local a = 1
while `a' <= 7 {
	setx high `a'
	simqi, prval(1) genpr(pi)
	_pctile pi, p(2.5,97.5)
	replace plow = r(r1) if ageaxis==`a'
	replace phi = r(r2) if ageaxis==`a'
	drop pi
	local a = `a' + 1
}
sort ageaxis
graph plow phi ageaxis, s(ii) c(||)



//*******************************************************************//
//						ROBUSTNESS CHECKS  
//*******************************************************************//


//===============  MODEL 5  (1991 subset)  ====================//

//new onset variable
keep if year >=1991
bys adminunits_auid: egen onset1991 = max(onset)
keep if year == 1991
list year cowcode name if onset1991 == 1

relogit onset1991 high low  epr_lgdpcapl lpopdens , cl(cowcode) 
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05) replace

//===============  MODEL  6  (world)
// see admin_epr_world.do


//===============  MODEL 7  (1946-2005 period) =================//
relogit onset high low excluded maxautsep epr_lgdpcapl lpopdens warhist1 pcw peaceyears _spline* if ongoingdrop==0, cl(cowcode) 
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05) replace


//===============  MODEL 8  GDP excl. oil =================//
relogit onset nethigh netlow sumoil90 	excluded maxautsep	epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)


//*******************************************************************//
//					MORE ROBUSTNESS CHECKS  
//*******************************************************************//

	//=== without Chechnya (very poor): STABLE
relogit onset high low excluded maxautsep epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990 & name!="Chechnya", cl(cowcode) 
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05) replace

	//===  without 4 adminunits in Nigeria (comparably rich): STABLE
relogit onset high low excluded maxautsep epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990 & name!= "Bayelsa" & name != "Delta"  & name != "Rivers"  & name != "Ondo", cl(cowcode)  //
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
	
	//=== geographical variables
//relogit onset high low excluded maxautsep lminborddist epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 	// -, insign
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
//relogit onset high low excluded maxautsep lmeanborddist epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 	// -, sign! and smashes maxautsep
//relogit onset high low excluded maxautsep lmincapdist epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 	//-, insign
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
//relogit onset high low excluded maxautsep lmeancapdist epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 	//-, sign!
//relogit onset high low excluded maxautsep relcapdist epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) // -, insign
	
	//=== number of administrative units per country 
relogit onset high low excluded maxautsep lsumunits epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 	// -, insign
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)	
	//=== country dummy for previous conflict: negative sign. while adminunit warhist1 is positive significant!
relogit onset high low excluded maxautsep warhistc1 epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 	// -, sign!
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
	//=== country dummy and sumunits interacted... nothing FN
//gen warhistunits = warhistc1*sumunits
//relogit onset high low excluded maxautsep warhistc1 sumunits warhistunits epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990, cl(cowcode) 	// -, sign!
	//=== endogeneity: exclude AU with ongoing conflict in 1990... stable (excludes only 4 adminunits / 33 observations)
relogit onset high low excluded maxautsep epr_lgdpcapl lpopdens warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990 & ongoing1990==0, cl(cowcode) 
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
	//=== absolute population
relogit onset high low excluded maxautsep epr_lgdpcapl epr_lpop warhist1 peaceyears _spline* if ongoingdrop==0 & year>1990 & ongoing1990==0, cl(cowcode) 



