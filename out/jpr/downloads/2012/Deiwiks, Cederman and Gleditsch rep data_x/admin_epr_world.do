	*******************************************************	*******************************************************	* FIRST CHANGE THIS TO YOUR WORKING DIRECTORY *********clear
clear matrixset mem 500mcd "/Users/cdeiwiks/Documents/PHD/Deiwiks, Cederman, Gleditsch/STATA/world/"
//cd "/Users/larsc/Docs/Projects/AdminUnits/Data"

clear
insheet using "ineqaggworld_pgs.csv", comma
rename auid adminunits_auid
sort adminunits_auid
save mountains.dta, replaceclear insheet using "ineqaggworld_gr.csv", comma
drop if geotype == 5 //geographical concentration of ethnic groups necessary condition (Sorens drop if statusid == 1 | statusid == 5 //drop monopoly and dominant
drop if popintersection < 5000
drop if popintersection == .

rename auid adminunits_auidrename groups_cowgroupid cowgroupidrename popintersection gpop****************************************************************************************************
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
//duplicates drop adminunits_auid year cowgroupid, forcedrop if cowgroupid == .drop if adminunits_auid == .bys adminunits_auid: egen sumgpop=sum(gpop)bys adminunits_auid: egen sumexclpop=sum(gpop) if excluded==1bys adminunits_auid: egen maxexclpop=max(gpop) if excluded==1
bys adminunits_auid: egen maxpop=max(gpop)
replace maxexclpop=0 if maxexclpop==.gen maxexclrpop = maxexclpop/sumgpop
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

gen maxaut = 0replace maxaut = 1 if gpop==maxexclpop & gpop!=0 & statusid == 6  // the largest excluded group in the AU has autonomygen maxsep = 0replace maxsep = 1 if gpop==maxexclpop & gpop!=0 & statusid == 7 //...separatistgen maxdisc = 0replace maxdisc = 1 if gpop==maxexclpop & gpop!=0 & statusid == 2 // discrgen maxpowerless = 0replace maxpowerless = 1 if gpop==maxexclpop & gpop!=0 & statusid == 10 //powerless
//gen maxgroup = group if gpop==maxexclpop & gpop!=0
gen popshare = gpop/sumgpopgen sqpopshare = popshare*popsharegen exclpopshare = gpop/sumexclpop if excluded==1gen sqexclpopshare = exclpopshare*exclpopshare if excluded==1
gen exclpopsharegroup = gpop/sumgrouppop if excluded == 1

//=============================== collapse to adminunit year ============================================//sort adminunits_auidcollapse (sum)ngroups (sum)sqpopshare (sum)nexclgroups (sum)sqexclpopshare (sum)nautgroups (sum)ndiscgroups (sum)nsepgroups (sum)nmondomgroups (max)maxexclpop (max)maxexclrpop sumexclrpop meanexclgroupsecs minexclgroupsecs (max) exclpopsharegroup (max)maxgroupshare (max)nmaxgroupsecs (max)maxaut (max)maxsep (max)maxdisc (max)maxpowerless (max)maxexcluded (max)excluded (max) sumexclpop, by (adminunits_auid)//=======================================================================================================//
replace ngroups=0 if ngroups==.gen gelf = 1-sqpopsharereplace gelf = 0 if gelf==.replace nexclgroups=0 if nexclgroups==.gen exclgelf = 1-sqexclpopsharereplace exclgelf = 0 if exclgelf==.replace nautgroups = 0 if nautgroups == .replace ndiscgroups = 0 if ndiscgroups == .replace nsepgroups = 0 if nsepgroups == .replace nmondomgroups = 0 if nmondomgroups == .replace maxexclpop = 0 if maxexclpop==.sort adminunits_auidsave tempadmin, replaceclear//==== only use country level data from 1991 ===//
use Country-Level.dta
keep if year == 1991
save countrylevel1991, replace
clear
//===================================================


//======= admin unit data == 45 conflict onsets ===
insheet using "ineqaggworld.csv", comma
rename auid adminunits_auid
rename admin_name name
//=======================================================gen ccode = cowcodesort ccodemerge m:1 ccode using countrylevel1991.dta, keep(master match)drop _mergesort adminunits_auidmerge adminunits_auid using mountainsdrop _merge//duplicates list adminunits_auid
// ==== final dataset ================================================================================sort adminunits_auidmerge adminunits_auid using tempadmin, keep(ngroups gelf nexclgroups exclgelf nautgroups ndiscgroups nsepgroups nmondomgroups maxexclpop maxexclrpop sumexclrpop maxgroupshare meanexclgroupsecs minexclgroupsecs exclpopsharegroup nmaxgroupsecs maxaut maxsep maxdisc maxpowerless maxexcluded excluded sumexclpop)drop _merge
// ===================================================================================================//duplicates report adminunits_auidgen one = 1bys cowcode: egen sumunits = sum(one)gen lsumunits = log(sumunits)
gen ethnicau = 1
replace ethnicau = 0 if ngroups ==.
replace ngroups=0 if ngroups==.replace gelf = 0 if gelf==.replace nexclgroups=0 if nexclgroups==.replace exclgelf = 0 if exclgelf==.replace nautgroups = 0 if nautgroups == .replace ndiscgroups = 0 if ndiscgroups == .replace nsepgroups = 0 if nsepgroups == .replace nmondomgroups = 0 if nmondomgroups == .replace maxexclpop = 0 if maxexclpop==.replace maxaut = 0 if maxaut==.replace maxsep = 0 if maxsep==.replace maxdisc = 0 if maxdisc==.replace maxexcluded = 0 if maxexcluded==.
replace excluded = 0 if excluded == .
replace sumexclpop = 0 if sumexclpop ==.gen popdens = epr_popavg/epr_area//btscs incidence year adminunits_auid, g(peaceyears) nspline(3)

//=== geographic variables =======================gen lminborddist = log(minborddist)gen lmincapdist = log(mincapdist)
bys cowcode: egen avgcapdist=mean(meancapdist)gen relcapdist = meancapdist/avgcapdistgen gdpcap = sumnordhaus90*1000000 / sumpop90gen lgdpcap = log(gdpcap)//================================================

//=== net wealth ===============================================
gen netnordhaus = sumnordhaus - sumoil90/1000

bys cowcode: egen sumgdpcap = sum(sumnordhaus90*1000000)
bys cowcode: egen sumpop = sum(sumpop90)
bys cowcode: egen sumnetgdp=sum(netnordhaus)

gen avggdpcap = sumgdpcap / sumpop
gen netavggdpcap = sumnetgdp / sumpop
gen netgdpcap=netnordhaus/sumpop90
//==============================================================

//=== INEQUALITY =============================gen ineq = gdpcap/avggdpcapgen lineq = log(gdpcap) - log(avggdpcap)gen lineq2 = lineq*lineqgen high = ineqreplace high=0 if ineq<1 & ineq!=.gen low = 1/ineqreplace low=0 if ineq>1 & ineq!=.
gen lhigh = lineqreplace lhigh=0 if lineq<0 & lineq!=.gen llow = log(1/ineq)replace llow=0 if lineq>0 & lineq!=.gen lhigh2 = lhigh*lhighgen llow2 = llow*llowgen high20 = 0replace high20=1 if high>1.2 & high!=.gen low20 = 0replace low20=1 if low>1.2 & low!=.gen high15 = 0replace high15=1 if high>1.5 & high!=.gen low15 = 0replace low15=1 if low>1.5 & low!=.gen llow2excl = llow2 * maxexclpopgen lhigh2excl = lhigh2 * maxexclpop


//=== net inequality ==gen netineq = netgdpcap/netavggdpcapgen lnetineq = log(netineq)gen lnetineq2 = lnetineq^2
gen lnetineq2hi = lnetineq2replace lnetineq2hi = 0 if lnetineq<0 & lnetineq!=.gen lnetineq2lo = lnetineq2replace lnetineq2lo = 0 if lnetineq>0 & lnetineq!=.//gen petro = 0//replace petro=1 if petrosqkm > 0 & petrosqkm!=.gen lavggdpcap = log(avggdpcap)gen lsumpop90 = log(sumpop90)

gen majexcl = 0
replace majexcl=1 if maxexclrpop>0.5 & maxexclrpop!=.

gen nethigh = netineq
replace nethigh=0 if netineq<1 & ineq!=.

gen netlow = 1/netineq
replace netlow = 0 if netineq>1 & ineq!=.
// admin unit pop densitybys cowcode : egen sumarea = sum(areasqkm)gen audens = sumpop90 / areasqkmgen countrydens = sumpop / sumareagen devdens = audens / countrydensgen ldevdens = log(devdens)gen ldevdens2 = ldevdens^2gen popshare = sumpop90 / sumpopgen lpopshare = log(popshare)gen bal = sumpop90 / epr_milpergen lbal = log(bal)// dummiesgen exclg = nexclgroupsreplace exclg = 1 if nexclgroups>1 & nexclgroups!=.gen discg = ndiscgroupsreplace discg = 1 if ndiscgroups>1 & ndiscgroups!=.gen autg = nautgroupsreplace autg = 1 if nautgroups>1 & nautgroups!=.gen sepg = nsepgroupsreplace sepg = 1 if nsepgroups>1 & nsepgroups!=.gen ebal = maxexclpop/(maxexclpop+epr_egippop)replace ebal = 0 if ebal==.gen gbal = maxexclpop/sumpop
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

