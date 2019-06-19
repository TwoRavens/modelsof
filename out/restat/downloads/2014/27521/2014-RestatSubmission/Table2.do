set mem 10000M
local fileName = "Table2"
log using `fileName'.log, replace


capture mkdir Results
capture ssc install outreg2

use PrivateData/ProcessedData, clear
	drop if plantitle==""
	xi i.pt*age_self, noomit
	drop _Ipt_*
	gen o40=age>=4
	
	sort age age_self
	
	gen age_self2=age_self*age_self
	gen age_self3=age_self2*age_self
	xi i.age
	xi, prefix(_J) i.age*i.plan 
	drop _Jage_* _Jplan_*
	gen po40=o40*predictedPremium 
	gen page=predictedPremium*age_self
	xi i.plan*age_self i.plan*age_self2 
	drop _Iplan_*
	
	
	
***Estimate the specifications for Panel A
       asclogit choseThisPlan predictedPremium, alt(pt) case(caseid)  altwise robust
	       predict sh, altwise
	       est store cr1
       asclogit choseThisPlan predictedPremium page, alt(pt) case(caseid)  altwise robust
		est store cr2
       asclogit choseThisPlan predictedPremium page, alt(pt) case(caseid)  altwise casevars(age_self) robust
	       gen semi_elast=(_b[predictedPremium]+_b[page]*age_self)*(1-sh) 
	       est store cr3
outreg2 [cr1 cr2 cr3] using Results/Table2_PanelA, replace excel 

***Now Estimate Panel B
	asclogit choseThisPlan predictedPremium _I* if age==1 | age==2, alt(pt) case(caseid) altwise robust 
	       gen elast1=_b[predictedPremium]*(1-sh)*predictedPremium if age==1 | age==2
		gen semi_elast_avg=_b[predictedPremium]*(1-sh) if age<3
		est store dr1 
		predict sh1 if age==1 | age==2, altwise
		gen alpha1=_b[predictedPremium]
		gen p1=predictedPremium if age==1 | age==2
		gen semi_lb=_b[predictedPremium]*(1-sh) if age==1 

	asclogit choseThisPlan predictedPremium _I* if age==2 | age==3, alt(pt) case(caseid) altwise robust 
		replace semi_elast_avg=(semi_elast_avg+_b[predictedPremium]*(1-sh))/2 if age==2
		replace semi_elast_avg=(_b[predictedPremium]*(1-sh))/2 if age==3
		gen elast2=_b[predictedPremium]*(1-sh)*predictedPremium if age==2 | age==3
		replace semi_lb=_b[predictedPremium]*(1-sh) if age==2
		predict sh2 if age==3 | age==2, altwise
		gen alpha2=_b[predictedPremium]
		gen p2=predictedPremium if age==3 | age==2
		est store dr2
       asclogit choseThisPlan predictedPremium _I* if age==3 | age==4, alt(pt) case(caseid) altwise robust 
		gen elast3=_b[predictedPremium]*(1-sh)*predictedPremium if age==3 | age==4
		predict sh3 if age==3 | age==4, altwise
		gen p3=predictedPremium if age==3 | age==4
		gen alpha3=_b[predictedPremium]
		replace semi_elast_avg=(semi_elast_avg+_b[predictedPremium]*(1-sh))/2 if age==3
		replace semi_elast_avg=(_b[predictedPremium]*(1-sh))/2 if age==4
		replace semi_lb=_b[predictedPremium]*(1-sh) if age==3
		est store dr3

	asclogit choseThisPlan predictedPremium _I* if age==4 | age==5, alt(pt) case(caseid) altwise robust 
		gen elast4=_b[predictedPremium]*(1-sh)*predictedPremium if age==4 | age==5
		predict sh4 if age==4 | age==5, altwise
		gen p4=predictedPremium if age==4 | age==4
		gen alpha4=_b[predictedPremium]
		replace semi_elast_avg=(semi_elast_avg+_b[predictedPremium]*(1-sh))/2 if age==4
		replace semi_elast_avg=(_b[predictedPremium]*(1-sh))/2 if age==5
		replace semi_lb=_b[predictedPremium]*(1-sh) if age==4
		est store dr4
       asclogit choseThisPlan predictedPremium _I* if age==5 | age==6, alt(pt) case(caseid) altwise robust 
		gen elast5=_b[predictedPremium]*(1-sh)*predictedPremium if age==5 | age==6
		predict sh5 if age==5 | age==6, altwise
		gen p5=predictedPremium if age==5 | age==6
		gen alpha5=_b[predictedPremium]
		replace semi_elast_avg=(semi_elast_avg+_b[predictedPremium]*(1-sh))/2 if age==5
		replace semi_elast_avg=(_b[predictedPremium]*(1-sh))/2 if age==6
		replace semi_lb=_b[predictedPremium]*(1-sh) if age==5
		est store dr5
       asclogit choseThisPlan predictedPremium _I* if age==6 | age==7, alt(pt) case(caseid) altwise robust 
	       gen elast6=_b[predictedPremium]*(1-sh)*predictedPremium if age==1 | age==6
		replace semi_elast_avg=(semi_elast_avg+_b[predictedPremium]*(1-sh))/2 if age==6
		predict sh6 if age==6 | age==7, altwise
		gen alpha6=_b[predictedPremium]
		gen p6=predictedPremium if age==6 | age==7
		est store dr6 
outreg2 [dr1 dr2 dr3 dr4 dr5 dr6] using Results/Table2_PanelB, replace excel 

	drop sh
	
	asclogit choseThisPlan predictedPremium _I* if age<5, alt(pt) case(caseid) altwise robust 
		est store dr7
		predict shu40, altwise
		replace predictedPremium=.65*predictedPremium
		predict shu40_tax, altwise
		replace predictedPremium=predictedPremium/.65
	       gen alphau40=_b[predictedPremium]
	       gen elastu40=_b[predictedPremium]*(1-shu40)*predictedPremium if age<5
	       gen mkupu40=-1/elastu40
	asclogit choseThisPlan predictedPremium  _I* if age>=5, alt(pt) case(caseid) altwise robust 
		est store dr8
		cap drop o45
		cap drop po45
		gen o45=age>4
		gen po45=predictedPremium*o45
		predict sho40, altwise
		replace predictedPremium=.65*predictedPremium
		predict sho40_tax, altwise
		replace predictedPremium=predictedPremium/.65
	
	       gen elasto40=_b[predictedPremium]*(1-sho40)*predictedPremium 
	       gen alphao40=_b[predictedPremium]
	       gen mkupo40=-1/elasto40

	asclogit choseThisPlan predictedPremium _I*, alt(pt) case(caseid) casevars(o45) altwise robust
		predict sh, altwise
		gen elast_all=(_b[predictedPremium])*(1-sh)*predictedPremium
		gen pooledmkup=-1/elast_all
	
outreg2 [dr7 dr8] using Results/Table2_PanelC, replace excel

***Now, prepare matlab output

 drop elast* mkup* sh*  alpha* elast*
	asclogit choseThisPlan predictedPremium _I* if age<5, alt(pt) case(caseid) altwise robust 
		est store dr7
		predict shu40, altwise
		replace predictedPremium=.85*predictedPremium
		replace predictedPremium=predictedPremium/.85
		gen tempprem=predictedPremium
		replace predictedPremium=3.25 if predictedPremium>3.25 & bronze==1
		replace predictedPremium=tempprem
	       gen alphau40=_b[predictedPremium]
	       *gen elastu40=_b[predictedPremium]*(1-shu40)*predictedPremium 
	       *gen mkupu40=-1/elastu40
		predict deltau, xb
		replace deltau=deltau-alphau40*predictedPremium
	
	asclogit choseThisPlan predictedPremium  _I* if age>=5, alt(pt) case(caseid) altwise robust 
		est store dr8
		cap drop o45
		cap drop po45
		gen o45=age>4
		gen po45=predictedPremium*o45
		predict sho40, altwise
		replace predictedPremium=.85*predictedPremium
		replace predictedPremium=predictedPremium/.85
		replace predictedPremium=3.25 if predictedPremium>3.25 & bronze==1
		replace predictedPremium=tempprem
	       *gen elasto40=_b[predictedPremium]*(1-sho40)*predictedPremium if age>4
	       gen alphao40=_b[predictedPremium]
	       *gen mkupo40=-1/elasto40
	       predict deltao, xb
	       replace deltao=deltao-alphao40*predictedPremium
	
	egen carrier=group(carrierOpt)
	cap drop tier
	gen tier=1 if bronze==1
	replace tier=2 if silver==1
	replace tier=3 if bronze+silver==0
	replace predictedPremium=. if age>4
preserve
collapse (mean) carrier tier predictedPremium shu40 sho40 alphau40 alphao40 delta*, by(pt)
save WorkingData/BasisOfTable4, replace
! st WorkingData/BasisOfTable4.dta WorkingData/BasisOfTable4.csv


