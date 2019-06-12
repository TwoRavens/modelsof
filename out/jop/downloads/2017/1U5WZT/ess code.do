/////////VARIABLE DEFINITIONS.
//////Generate interest in politics scale:
gen rpolin=(4-polintr)/3
//////Generate participation scale:
recode vote (1=1) (2=0) (3=.), generate(rvote)
recode contplt (1=1) (2=0), generate(rpar1)
recode wrkprty (1=1) (2=0), generate(rpar2)
recode badge (1=1) (2=0), generate(rpar3)
recode wrkorg (1=1) (2=0), generate(rpar4)  
recode sgnptit (1=1) (2=0), generate(rpar5)
recode pbldmn (1=1) (2=0), generate(rpar6)
recode bctprd (1=1) (2=0), generate(rpar7)
egen rpart=rmean(rvote rpar1 rpar2 rpar3 rpar4 rpar5 rpar6 rpar7)
//////Generate nation indicator:
encode cntry, generate(nation)
//////Generate age:
gen age=agea
//////Generate income:
gen incscal=hinctnta
//////Generate gender:
recode gndr (1=1) (2=0), gen(gender)
//////Generate ethnic minority/majority indicator:
recode blgetmg (1=0) (2=1), gen(ethmaj)
//////Generate education:
recode edulvl (0=0) (1=0) (2=0) (3=1) (4=2) (5=3) (6=4), generate(reduc)
gen rreduc=reduc/4
//////Ideological cross-pressure:
///Generate economic issues scale.
gen gvjbevn01=gvjbevn/10 
gen gvhlthc01=gvhlthc/10 
gen gvslvol01 =gvslvol/10
gen gvslvue01=gvslvue/10 
gen gvcldcr01=gvcldcr/10 
gen gvpdlwk01=gvpdlwk/10 
egen econ=rmean(gvjbevn01 gvhlthc01 gvslvol01 gvslvue01 gvcldcr01 gvpdlwk01)
gen recon01=1-econ
///Generate social issues scale.
gen freehms01=(freehms-1)/4
gen immig101=(10-imwbcnt)/10
gen immig201=(10-imueclt)/10  
gen women01=(5-wmcpwrk)/4
gen hrshsnt01=(5-hrshsnt)/4
gen mnrgtjb01=(5-mnrgtjb)/4
egen rsoc01=rmean(freehms01 women01 hrshsnt01 mnrgtjb01 immig101 immig201)
///Generate cross-pressure scale:
gen crossp=abs(recon01-rsoc01)
///Grand-mean enter cross-pressure scale:
gen ccrossp=crossp-.3169613 
//////Generate authoritarianism:
gen rauth=(5-schtaut)/4
///Grand-mean center authoritarianism:
gen cauth=rauth-.7651411
//////Generate conservation values:
gen rimpsafe=(6-impsafe)/5
gen ripstrgv=(6-ipstrgv)/5
gen ripfrule=(6-ipfrule)/5 
gen ripbhprp=(6-ipbhprp)/5
gen ripmodst=(6-ipmodst)/5 
gen rimptrad=(6-imptrad)/5
egen rcvt=rmean(ripmodst rimptrad rimpsafe ripstrgv ripfrule ripbhprp)
///Grand-mean center conservation values:
gen ccvt=rcvt-.6850663
//////Generate ideology:
gen rideo=lrscale/10
///Grand-mean center ideology scale.
gen cideo=rideo-.5201489
//////Generate interaction terms (for specifying random effects):
gen cidaut=cideo*cauth
gen cidccvt=cideo*ccvt
//////Generate East/West indicator.
///Coding:
gen ew=.
replace ew=0 if cntry=="HR"
replace ew=0 if cntry=="CZ"
replace ew=0 if cntry=="EE"
replace ew=0 if cntry=="HU"
replace ew=0 if cntry=="LV"
replace ew=0 if cntry=="PL"
replace ew=0 if cntry=="RO"
replace ew=0 if cntry=="RU"
replace ew=0 if cntry=="SK"
replace ew=0 if cntry=="SI"
replace ew=0 if cntry=="UA"
replace ew=1 if cntry=="BE"
replace ew=1 if cntry=="GB"
replace ew=1 if cntry=="CY"
replace ew=1 if cntry=="DK"
replace ew=1 if cntry=="FI"
replace ew=1 if cntry=="DE"
replace ew=1 if cntry=="GR"
replace ew=1 if cntry=="IL"
replace ew=1 if cntry=="NL"
replace ew=1 if cntry=="NO"
replace ew=1 if cntry=="PT"
replace ew=1 if cntry=="FR"
replace ew=1 if cntry=="ES"
replace ew=1 if cntry=="SE"
replace ew=1 if cntry=="CH"
replace ew=1 if cntry=="TR"
///Reverse so that 1 = East:
recode ew (0=1) (1=0), generate(ewr)

/////////ANALYSES.
//////Interest: Authoritarianism analysis (Table 2, Figure 2).
///Estimate model:
mixed rpolin age incscal gender ethmaj rreduc c.ccrossp c.cauth c.cideo c.cideo#c.cideo c.cideo#c.cauth ///
	i.ewr i.ewr#c.cauth i.ewr#c.cideo c.cauth#i.ewr#c.cideo || nation: c.cauth c.cideo cidaut, var
///estimate conditional effects of authoritarianism at 1 SD above and below mean of ideology, West:
margins, dydx(c.cauth) at(cideo=(-.2295619 .2295619 ) ewr=(0))
///estimate conditional effects of authoritarianism at 1 SD above and below mean of ideology, East:
margins, dydx(c.cauth) at(cideo=(-.2295619 .2295619 ) ewr=(1))
///Graph (additional manual modification done to get appearance in paper):
quietly margins, dydx(c.cauth) at(cideo=(-.2295619 (.01) .2295619 ) ewr=(0))
marginsplot, recast(line) recastci(rarea) ylabel(-.3 (.1) .3) ytitle("Conditional effect of authoritarianism") title ("Western Europe / "Westernized" Nations") saving (auth1i, replace)
quietly margins, dydx(c.cauth) at(cideo=(-.2295619 (.01) .2295619 ) ewr=(1))
marginsplot, recast(line) recastci(rarea) ylabel(-.3 (.1) .3) ytitle("Conditional effect of authoritarianism") title ("Eastern Europe") saving (auth2i, replace)
graph combine auth1i.gph auth2i.gph, cols(2) altshrink ycommon ysize(2) title("Dependent Variable: Interest in Politics") saving(authessi, replace)

//////Participation: Authoritarianism analysis (Table 2, Figure 2).
///Estimate model:
mixed rpart age incscal gender ethmaj rreduc c.ccrossp c.cauth c.cideo c.cideo#c.cideo c.cideo#c.cauth ///
	i.ewr i.ewr#c.cauth i.ewr#c.cideo c.cauth#i.ewr#c.cideo || nation: c.cauth c.cideo cidaut, var
///estimate conditional effects of authoritarianism at 1 SD above and below mean of ideology, West:
margins, dydx(c.cauth) at(cideo=(-.2295619 .2295619 ) ewr=(0))
///estimate conditional effects of authoritarianism at 1 SD above and below mean of ideology, East:
margins, dydx(c.cauth) at(cideo=(-.2295619 .2295619 ) ewr=(1))
///Graph (additional manual modification done to get appearance in paper):
quietly margins, dydx(c.cauth) at(cideo=(-.2295619 (.01) .2295619 ) ewr=(0))
marginsplot, recast(line) recastci(rarea) ylabel(-.3 (.1) .3) ytitle("Conditional effect of authoritarianism") title("Western Europe / "Westernized" Nations") saving (auth1p, replace)
quietly margins, dydx(c.cauth) at(cideo=(-.2295619 (.01) .2295619 ) ewr=(1))
marginsplot, recast(line) recastci(rarea) ylabel(-.3 (.1) .3) ytitle("Conditional effect of authoritarianism") title ("Eastern Europe") saving (auth2p, replace)
graph combine auth1p.gph auth2p.gph, cols(2) altshrink ycommon ysize(2) title("Dependent Variable: Participation") saving(authessp, replace)

//////Interest: Conservation values analysis (Table 3, Figure 3).
///Estimate model:
mixed rpolin age incscal gender ethmaj rreduc c.ccrossp c.ccvt c.cideo c.cideo#c.cideo c.cideo#c.ccvt ///
	i.ewr i.ewr#c.ccvt i.ewr#c.cideo c.ccvt#i.ewr#c.cideo || nation: c.ccvt c.cideo cidccvt, var
///estimate conditional effects of conservation values at 1 SD above and below mean of ideology, West:
margins, dydx(c.ccvt) at(cideo=(-.2295619 .2295619 ) ewr=(0))
///estimate conditional effects of conservation values at 1 SD above and below mean of ideology, East:
margins, dydx(c.ccvt) at(cideo=(-.2295619 .2295619 ) ewr=(1))
///Graph (additional manual modification done to get appearance in paper):
quietly margins, dydx(c.ccvt) at(cideo=(-.2295619 (.01) .2295619 ) ewr=(0))
marginsplot, recast(line) recastci(rarea) ylabel(-.3 (.1) .3) ytitle("Conditional effect of conservation values") title("Western Europe / "Westernized" Nations") saving (csv1i, replace)
quietly margins, dydx(c.ccvt) at(cideo=(-.2295619 (.01) .2295619 ) ewr=(1))
marginsplot, recast(line) recastci(rarea) ylabel(-.3 (.1) .3) ytitle("Conditional effect of conservation values") title("Eastern Europe") saving (csv2i, replace)
graph combine csv1i.gph csv2i.gph, cols(2) altshrink ycommon ysize(2) title("Dependent Variable: Interest in Politics") saving(csvessi, replace)

//////Participation: Conservation values analysis (Table 3, Figure 3).
///Estimate model:
mixed rpart age incscal gender ethmaj rreduc c.ccrossp c.ccvt c.cideo c.cideo#c.cideo c.cideo#c.ccvt ///
	i.ewr i.ewr#c.ccvt i.ewr#c.cideo c.ccvt#i.ewr#c.cideo || nation: c.ccvt c.cideo cidccvt, var
///estimate conditional effects of conservation values at 1 SD above and below mean of ideology, West:
margins, dydx(c.ccvt) at(cideo=(-.2295619 .2295619 ) ewr=(0))
///estimate conditional effects of conservation values at 1 SD above and below mean of ideology, East:
margins, dydx(c.ccvt) at(cideo=(-.2295619 .2295619 ) ewr=(1))
///Graph (additional manual modification done to get appearance in paper):
quietly margins, dydx(c.ccvt) at(cideo=(-.2295619 (.01) .2295619 ) ewr=(0))
marginsplot, recast(line) recastci(rarea) ylabel(-.3 (.1) .3) ytitle("Conditional effect of conservation values") title("Western Europe / "Westernized" Nations") saving (csv1p, replace)
quietly margins, dydx(c.ccvt) at(cideo=(-.2295619 (.01) .2295619 ) ewr=(1))
marginsplot, recast(line) recastci(rarea) ylabel(-.3 (.1) .3) ytitle("Conditional effect of conservation values") title("Eastern Europe") saving (csv2p, replace)
graph combine csv1p.gph csv2p.gph, cols(2) altshrink ycommon ysize(2) title("Dependent Variable: Participation") saving(csvessp, replace)

//////Robustness check with age and education interactions added (Footnote 8 / Appendix)
///Grand-mean center age and education.
summ age
gen cage=age-r(mean)
summ rreduc
gen creduc=rreduc-r(mean)
///Generate interaction terms (for specifying random effects):
gen cagaut=cauth*cage
gen cedaut=cauth*creduc
gen cagcv=ccvt*cage
gen cedcv=ccvt*creduc
///Analysis:
mixed rpolin c.cage incscal gender ethmaj c.creduc c.ccrossp c.cauth c.cideo c.cideo#c.cideo c.cideo#c.cauth c.cauth#c.cage c.cauth#c.creduc ///
	i.ewr i.ewr#c.cauth i.ewr#c.cideo c.cauth#i.ewr#c.cideo || nation: c.cauth c.cideo c.cage c.creduc cidaut cagaut cedaut, var
mixed rpart c.cage incscal gender ethmaj c.creduc c.ccrossp c.cauth c.cideo c.cideo#c.cideo c.cideo#c.cauth c.cauth#c.cage c.cauth#c.creduc ///
	i.ewr i.ewr#c.cauth i.ewr#c.cideo c.cauth#i.ewr#c.cideo || nation: c.cauth c.cideo c.cage c.creduc cidaut cagaut cedaut, var	
mixed rpolin c.cage incscal gender ethmaj c.creduc c.ccrossp c.ccvt c.cideo c.cideo#c.cideo c.cideo#c.ccvt c.ccvt#c.cage c.ccvt#c.creduc ///
	i.ewr i.ewr#c.ccvt i.ewr#c.cideo c.ccvt#i.ewr#c.cideo || nation: c.ccvt c.cideo c.cage c.creduc cidccvt cagcv cedcv, var
mixed rpart c.cage incscal gender ethmaj c.creduc c.ccrossp c.ccvt c.cideo c.cideo#c.cideo c.cideo#c.ccvt c.ccvt#c.cage c.ccvt#c.creduc ///
	i.ewr i.ewr#c.ccvt i.ewr#c.cideo c.ccvt#i.ewr#c.cideo || nation: c.ccvt c.cideo c.cage c.creduc cidccvt cagcv cedcv, var	

//////Robustness check with additional nation-level variables (Footnote 6 / Appendix)
///Nation-level variables (for reference):
///HDI2005 -> UN Human Development Index in 2005
///Elecpr -> Proportional representation? (1 = yes, 0 = no)
///parl -> Parliamentary system? (1 = yes, 0 = no)
///fedtype -> Federalism (1 = unitary, 0 = federal)
///Without interactions:
mixed rpolin c.HDI2005 i.Elecpr i.parl i.fedtype age incscal gender ethmaj rreduc c.ccrossp c.cauth c.cideo c.cideo#c.cideo c.cideo#c.cauth ///
	i.ewr i.ewr#c.cauth i.ewr#c.cideo c.cauth#i.ewr#c.cideo || nation: c.cauth c.cideo cidaut, var
mixed rpart c.HDI2005 i.Elecpr i.parl i.fedtype age incscal gender ethmaj rreduc c.ccrossp c.cauth c.cideo c.cideo#c.cideo c.cideo#c.cauth ///
	i.ewr i.ewr#c.cauth i.ewr#c.cideo c.cauth#i.ewr#c.cideo || nation: c.cauth c.cideo cidaut, var
mixed rpolin c.HDI2005 i.Elecpr i.parl i.fedtype age incscal gender ethmaj rreduc c.ccrossp c.ccvt c.cideo c.cideo#c.cideo c.cideo#c.ccvt ///
	i.ewr i.ewr#c.ccvt i.ewr#c.cideo c.ccvt#i.ewr#c.cideo || nation: c.ccvt c.cideo cidccvt, var
mixed rpart c.HDI2005 i.Elecpr i.parl i.fedtype age incscal gender ethmaj rreduc c.ccrossp c.ccvt c.cideo c.cideo#c.cideo c.cideo#c.ccvt ///
	i.ewr i.ewr#c.ccvt i.ewr#c.cideo c.ccvt#i.ewr#c.cideo || nation: c.ccvt c.cideo cidccvt, var	
///With interactions:
mixed rpolin c.HDI2005 i.Elecpr i.parl i.fedtype age incscal gender ethmaj rreduc c.ccrossp c.cauth c.cideo c.cideo#c.cideo c.cideo#c.cauth ///
	i.ewr i.ewr#c.cauth i.ewr#c.cideo c.cauth#i.ewr#c.cideo ///
	c.HDI2005#c.cideo i.Elecpr#c.cideo i.parl#c.cideo i.fedtype#c.cideo ///
	c.HDI2005#c.cauth c.HDI2005#c.cideo#c.cauth ///
	i.Elecpr#c.cauth i.Elecpr#c.cideo#c.cauth ///
	i.parl#c.cauth i.parl#c.cideo#c.cauth ///
	i.fedtype#c.cauth i.fedtype#c.cideo#c.cauth || nation: c.cauth c.cideo cidaut, var
mixed rpart c.HDI2005 i.Elecpr i.parl i.fedtype age incscal gender ethmaj rreduc c.ccrossp c.cauth c.cideo c.cideo#c.cideo c.cideo#c.cauth ///
	i.ewr i.ewr#c.cauth i.ewr#c.cideo c.cauth#i.ewr#c.cideo ///
	c.HDI2005#c.cideo i.Elecpr#c.cideo i.parl#c.cideo i.fedtype#c.cideo ///
	c.HDI2005#c.cauth c.HDI2005#c.cideo#c.cauth ///
	i.Elecpr#c.cauth i.Elecpr#c.cideo#c.cauth ///
	i.parl#c.cauth i.parl#c.cideo#c.cauth ///
	i.fedtype#c.cauth i.fedtype#c.cideo#c.cauth || nation: c.cauth c.cideo cidaut, var
mixed rpolin c.HDI2005 i.Elecpr i.parl i.fedtype age incscal gender ethmaj rreduc c.ccrossp c.ccvt c.cideo c.cideo#c.cideo c.cideo#c.ccvt ///
	i.ewr i.ewr#c.ccvt i.ewr#c.cideo c.ccvt#i.ewr#c.cideo ///
	c.HDI2005#c.cideo i.Elecpr#c.cideo i.parl#c.cideo i.fedtype#c.cideo ///
	c.HDI2005#c.ccvt c.HDI2005#c.cideo#c.ccvt ///
	i.Elecpr#c.ccvt i.Elecpr#c.cideo#c.ccvt ///
	i.parl#c.ccvt i.parl#c.cideo#c.ccvt ///
	i.fedtype#c.ccvt i.fedtype#c.cideo#c.ccvt || nation: c.ccvt c.cideo cidccvt, var
mixed rpart c.HDI2005 i.Elecpr i.parl i.fedtype age incscal gender ethmaj rreduc c.ccrossp c.ccvt c.cideo c.cideo#c.cideo c.cideo#c.ccvt ///
	i.ewr i.ewr#c.ccvt i.ewr#c.cideo c.ccvt#i.ewr#c.cideo ///
	c.HDI2005#c.cideo i.Elecpr#c.cideo i.parl#c.cideo i.fedtype#c.cideo ///
	c.HDI2005#c.ccvt c.HDI2005#c.cideo#c.ccvt ///
	i.Elecpr#c.ccvt i.Elecpr#c.cideo#c.ccvt ///
	i.parl#c.ccvt i.parl#c.cideo#c.ccvt ///
	i.fedtype#c.ccvt i.fedtype#c.cideo#c.ccvt || nation: c.ccvt c.cideo cidccvt, var
	
