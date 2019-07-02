	*******************************************************
clear matrix
//cd "/Users/larsc/Docs/Projects/AdminUnits/Data"

clear
insheet using "ineqaggworld_pgs.csv", comma
rename auid adminunits_auid
sort adminunits_auid
save mountains.dta, replace

drop if popintersection < 5000
drop if popintersection == .

rename auid adminunits_auid
* CD: instead of merging with ANALYSIS_group_rcra I used statusid from original group-year dataset:
****************************************************************************************************
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

//sort cowgroupid year
//merge cowgroupid year using ANALYSIS_group_rcra, keep(excluded egip monop dominant senior junior autonomy powerless discrim separatist)
//drop _merge

//gen ngroups = 1
//gen nexclgroups = 1 if excluded == 1
//gen nautgroups = 1 if autonomy == 1
//gen ndiscgroups = 1 if discrim == 1
//gen nsepgroups = 1 if separatist == 1
//gen nmondomgroups = 1 if monop == 1 | dominant == 1
************************************
** CD end
************************************

bys adminunits_auid: egen maxpop=max(gpop)

gen sumexclrpop = sumexclpop/sumgpop

// max excluded group fractionalization
bys cowgroupid: egen sumgrouppop=sum(gpop)
gen one = 1
bys cowgroupid: egen nexclgroupsecs=sum(one) if excluded==1
replace nexclgroupsecs = 0 if nexclgroupsecs == .
gen nmaxgroupsecs = nexclgroupsecs if gpop==maxexclpop & gpop!=0

//max excluded group share
replace nmaxgroupsecs = 0 if nmaxgroupsecs == .
replace sumgrouppop = 0 if sumgrouppop ==.
gen maxgroupshare = maxexclpop/sumgrouppop if gpop==maxexclpop & gpop!=0
replace maxgroupshare = 0 if maxgroupshare == .

// average group fractionalization
bys cowgroupid: egen ngroupsecs = sum(one)
/////////////// stop //////
bys adminunits_auid: egen meanexclgroupsecs = mean(nexclgroupsecs)
bys adminunits_auid: egen minexclgroupsecs = min(nexclgroupsecs)
replace meanexclgroupsecs = 0 if meanexclgroupsecs == .
replace minexclgroupsecs = 0 if minexclgroupsecs == .

gen maxexcluded = 0
replace maxexcluded = 1 if gpop==maxpop & gpop!=0 & excluded == 1 //the largest group in the AU is excluded 

gen maxaut = 0
//gen maxgroup = group if gpop==maxexclpop & gpop!=0

gen exclpopsharegroup = gpop/sumgrouppop if excluded == 1

//=============================== collapse to adminunit year ============================================//

use Country-Level.dta
keep if year == 1991
save countrylevel1991, replace
clear
//===================================================



insheet using "ineqaggworld.csv", comma
rename auid adminunits_auid
rename admin_name name
//=======================================================
// ==== final dataset ================================================================================
// ===================================================================================================
gen ethnicau = 1
replace ethnicau = 0 if ngroups ==.

replace excluded = 0 if excluded == .
replace sumexclpop = 0 if sumexclpop ==.




//=== net wealth ===============================================
gen netnordhaus = sumnordhaus - sumoil90/1000

bys cowcode: egen sumgdpcap = sum(sumnordhaus90*1000000)
bys cowcode: egen sumpop = sum(sumpop90)
bys cowcode: egen sumnetgdp=sum(netnordhaus)

gen avggdpcap = sumgdpcap / sumpop
gen netavggdpcap = sumnetgdp / sumpop
gen netgdpcap=netnordhaus/sumpop90
//==============================================================

//=== INEQUALITY =============================



//=== net inequality ==


gen majexcl = 0
replace majexcl=1 if maxexclrpop>0.5 & maxexclrpop!=.

gen nethigh = netineq
replace nethigh=0 if netineq<1 & ineq!=.

gen netlow = 1/netineq
replace netlow = 0 if netineq>1 & ineq!=.

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


//------------------
//-- ongoing91: war in 1991 (incidence, not onset)
//------------------
gen ongoingdrop=ongoing91


//------------------
//-- federation dummy
//------------------

gen federal = 0

replace federal = 1 if cowcode == 2 | cowcode == 20 | cowcode == 70 | cowcode == 101 | cowcode == 140 | cowcode == 160 | cowcode == 200 | cowcode == 211
replace federal = 1 if cowcode == 225 | cowcode == 230 | cowcode == 255 | cowcode == 305 | cowcode == 315 | cowcode == 325 | cowcode == 345 | cowcode == 346 
replace federal = 1 if cowcode == 365 | cowcode == 369 | cowcode == 432 | cowcode == 471 | cowcode == 475 | cowcode == 510 | cowcode == 530 | cowcode == 560
replace federal = 1 if cowcode == 625 | cowcode == 696 | cowcode == 750 | cowcode == 770 | cowcode == 775 | cowcode == 820 | cowcode == 900
// STATA: stop.../////////////////////////////////////////////////////////////////////
stop



//***************************************************



relogit onset high low 	excluded maxautsep 	federal epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
 outreg2 using results, word alpha(0.001, 0.01, 0.05) replace



//*******************************************************

// Main models

relogit onset high low 	excluded maxautsep 	federal epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
 outreg2 using results, word alpha(0.001, 0.01, 0.05)

relogit onset nethigh netlow 	 		federal excluded maxautsep	epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
 outreg2 using results, word alpha(0.001, 0.01, 0.05)
 
 
 
 
 
logit onset lineq2 epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
prgen lineq2, f(-2) t(2) gen(pplineq2)
twoway (line pplinp1 pplinx, clpattern("shortdash") xtitle("Inequality") ytitle("Pr(conflict)") legend(order(1 "rich countries" 2 "poor countries"))) 

drop pp*
prgen high, f(0) t(4.3) x(low 0 maxautsep 0 excluded 0) rest() gen(pphigh)
prgen low, f(0) t(7.1) x(high 0 maxautsep 0 excluded 0) rest() gen(pplow)
twoway (line pphighp1 pphighx, clpattern("shortdash") xtitle("low/high") ytitle("Pr(conflict)") legend(order(1 "rich countries" 2 "poor countries"))) (line pplowp1 pplowx, clpattern("dash"))

drop newva*
logit onset high low excluded maxautsep epr_lgdpcapl lpopdens if ongoingdrop==0 , cl(cowcode) 
prgen excluded, f(0) t(1) x(high max low 0) rest() gen(newvar1)
prgen excluded, f(0) t(1) x(high 0 low max) rest() gen(newvar2)
prgen excluded, f(0) t(1) x(high 0 low 0) rest() gen(newvar3)
twoway (line newvar1p1 newvar1x, clpattern("shortdash") xtitle("Excluded") ytitle("Pr(conflict)") legend(order(1 "rich countries" 2 "poor countries" 3 "average"))) (line newvar2p1 newvar2x, clpattern("dash")) (line newvar3p1 newvar3x) 

logit onset high low excluded maxautsep epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
prgen maxautsep, f(0) t(1) x(high max low 0) rest() gen(newvar4)
prgen maxautsep, f(0) t(1) x(high 0 low max) rest() gen(newvar5)
prgen maxautsep, f(0) t(1) x(high 0 low 0) rest() gen(newvar6)
twoway (line newvar4p1 newvar4x, clpattern("shortdash") xtitle("Reg. Autonomy") ytitle("Pr(conflict)") legend(order(1 "rich countries" 2 "poor countries" 3 "average"))) (line newvar5p1 newvar5x, clpattern("dash")) (line newvar3p1 newvar3x) 


drop onset_pp
 outreg2 using results, word alpha(0.001, 0.01, 0.05)

//ROBUSTNESS CHECKS for model 2.3 ================================
	// without Chechnya (very poor): STABLE
relogit onset high low excluded maxautsep epr_lgdpcapl lpopdens if ongoingdrop==0 & adminunits_auid !=365011 & adminunits_auid!=365015, cl(cowcode) //Chechnya, Dagestan
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05) replace
	// without 4 adminunits in Nigeria (comparably rich): STABLE
relogit onset high low excluded maxautsep epr_lgdpcapl lpopdens if ongoingdrop==0 & adminunits_auid!=54003 & adminunits_auid !=475003 & adminunits_auid != 475023, cl(cowcode)  //Cabinda, Delta, Rivers .... 
	// KAPUTT! If only Cabinda is excluded, it's stable...
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
	
	// geographical variables

//relogit onset high low excluded maxautsep lminborddist epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 	// -, insign
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
relogit onset high low excluded maxautsep lmeanborddist epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 	// -, sign! and smashes maxautsep

//relogit onset high low excluded maxautsep lmincapdist epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 	//-, insign
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
relogit onset high low excluded maxautsep lmeancapdist epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 	//-, sign!

//relogit onset high low excluded maxautsep relcapdist epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 		// -, insign
	
	// number of administrative units per country ... nothing
//relogit onset high low excluded maxautsep sumunits epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode)  		//-, insign
relogit onset high low excluded maxautsep lsumunits epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 	// -, insign
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
	// country dummy for previous conflict: negative sign. while adminunit warhist1 is positive significant!
relogit onset high low excluded maxautsep warhistc1 epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 	// -, sign!
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
	//country dummy and sumunits interacted... nothing FN
//gen warhistunits = warhistc1*sumunits
//relogit onset high low excluded maxautsep warhistc1 sumunits warhistunits epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 	// -, sign!

	//net gdp asymm ... kind of stable shoots down maxautsep a little...
relogit onset nethigh netlow 	 		excluded maxautsep	epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
relogit onset nethigh netlow sumoil90 	excluded maxautsep	epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)
	//endogeneity: exclude AU with ongoing conflict in 1990... stable (excludes only 4 adminunits / 33 observations)
relogit onset high low excluded maxautsep epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
 outreg2 using sensitivity, word alpha(0.001, 0.01, 0.05)


// ROBUSTNESS CHECK for model 1.3 =================================

	//linear term for highlow ... positive significant
relogit onset highlow excluded maxautsep epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) // +,sign
	// net gdp symm.. shoots down maxautsep
relogit onset lnetineq2 sumoil90 excluded maxautsep	epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
relogit onset 			sumoil90 excluded maxautsep	epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 
relogit onset lnetineq2 		 excluded maxautsep	epr_lgdpcapl lpopdens if ongoingdrop==0, cl(cowcode) 

//*** COMMENTS 
//replace warhist1 by warhist => a bit shaky
 
 
	// list onsets:
list epr_cname name low high excluded maxautsep if onset == 1
list adminunits_auid name low high excluded maxautsep if onset == 1
list epr_cname name low high autg if onset == 1 


	// list crosstabs
tab onset excluded if year > 1990, chi2
tab onset maxautsep if year > 1990, chi2
tab onset high if high > 0, chi2

