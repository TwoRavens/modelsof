*************************************************************
/*
.do file for :

Borrowing Trouble: Sovereign Credit, Military Regimes, and Conflict
Patrick Shea, University of Houston (pshea@uh.edu)

The following file is for the appendix's tables and
graphs.   Replication materials for main manuscript is found in a separate file. 

STATA version: 14

August 14, 2015

*/

***************************************************************************


*Directory
cd "C:\Users\Shea\Dropbox\My Projects\Targets\Work\Data\Analysis\"

*Main data file
use "main_target.dta", clear
set more off

****************************************************************************************************************************

****************************************************************************************************************************
*****A. Descriptive Stats


**Box Plot Figure A1
gen boxplot = 1 if military ==1
replace boxplot=2 if military==0

label define boxplot 1 "Military " 2 "Non-Military" 

graph box ldirrat , over(boxplot) noout label 

gr_edit scaleaxis.title.text = {}
gr_edit scaleaxis.title.text.Arrpush Change in Bond Yield

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy 
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit note.draw_view.setstyle, style(no)
gr_edit note.fill_if_undrawn.setstyle, style(no)

gr_edit grpaxis.major.num_rule_ticks = 0
gr_edit grpaxis.edit_tick 1 20.5882 `"Military Regime"', tickset(major)
// grpaxis edits


gr_edit grpaxis.major.num_rule_ticks = 0
gr_edit grpaxis.edit_tick 2 79.4118 `"Non-Military Regime"', tickset(major)
// grpaxis edits

graph export "box.pdf", as(pdf) replace


**Summary Table A1

sutex dirrat lirrat lncap growth_gdp5 gwf_dem military  tyear t2 t3 ///
neigh rival allies issues ///
, minmax labels

************************************************************************************************************************************************


************************************************************************************************************************************************
**B Conflict's effect on Bond Yields


use "main_target.dta", clear
set more off

xtreg dirrat  target ldirrat growth_gdp5 tyears us2 , i(ccode) fe
estimates store tm0

xtreg dirrat   target  ldirrat growth_gdp5 tyears us2 if military==1, i(ccode) fe 
estimates store tm1


xtreg dirrat  ltarget  ldirrat growth_gdp5 tyears us2 , i(ccode) fe
estimates store t1m0

xtreg dirrat   ltarget  ldirrat growth_gdp5 tyears us2 if military==1, i(ccode) fe
estimates store t1m1

lab var us2 "U.S. Bond Yield"

lab var tyears "Years since Targeted"
lab var target "Targeted$_t$"
lab var ltarget "Targeted$_{t-1}$"

**Table in Appendix

estout tm0 tm1 t1m0 t1m1,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( r2 N, fmt(%9.2f %9.0f ) labels("R-squared"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) order( target ltarget ) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 

**NOte: Graphs in Main file


************************************************************************************************************************************************


************************************************************************************************************************************************
**C Additional Confounders Considered

use "main_target.dta", clear
set more off

replace gdp = gdp/1000000


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat ldir_mil military l.gdp `control', cluster(ccode) robust
estimates store gdp


merge m:m ccode year using "C:\Users\Shea\Dropbox\My Projects\Assassination and Conflict\Project\Work\Data\Originals\haber.dta"

drop if _m==2
drop _m

xtset ccode year

replace total_oil_income_pc  = total_oil_income_pc /1000000

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat ldir_mil military l.total_oil_income_pc d.total_oil_income_pc `control', cluster(ccode) robust
estimates store  oil



replace total_resources_income_pc  = total_resources_income_pc /1000000

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat ldir_mil military l.total_resources_income_pc d.total_resources_income_pc `control', cluster(ccode) robust
estimates store  nr

merge m:m ccode year using "C:\Users\Shea\Dropbox\Credit and Political Survival\Data\WDIaidoil.dta"

drop if _m==2
drop _m

xtset ccode year


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat ldir_mil military l.aidgni d.aidgni `control', cluster(ccode) robust
estimates store  aid



xtset ccode year


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat ldir_mil military taxrevGDP_l d.taxrevGDP `control', cluster(ccode) robust
estimates store tax

lab var gdp "GDP"
lab var total_oil_income_pc "Oil Income Per Cap"
lab var total_resources_income_pc "Natural Resource Income Per Cap"
lab var aidgni "Foreign Assistance"
lab var taxrevGDP_l "Tax Revenue"

estout gdp oil nr aid tax,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) order(L.dirrat military ldir_mil L.gdp ///
 L.total_oil_income_pc L.total_resources_income_pc L.aidgni taxrevGDP_l D.total_oil_income_pc D.total_resources_income_pc D.aidgni D.taxrevGDP lncap growth_gdp5 lirrat gwf_dem) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  "Model 5") ///
title("Random Effects Logit Examining Interstate Targets") 


************************************************************************************************************************************************


************************************************************************************************************************************************
**D CGV Data and Count Model
use "main_target.dta", clear
set more off




local control "lncap growth_gdp5 democracy  tyear t2 t3 lirrat"
logit target l.dirrat ldir_cheb mil_cheb `control', cluster(ccode) robust
estimates store m3

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
nbreg sumtarget l.dirrat ldir_mil military `control' , cluster(ccode)
estimates store nbr

lab var democracy "Democracy (CGV)"
lab var mil_cheb "Military (CGV)"
lab var ldir_cheb "$\Delta$ Yield X Military (CGV)"

estout m3 nbr,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) order(L.dirrat military ldir_mil mil_cheb ldir_cheb lncap growth_gdp5 lirrat gwf_dem democracy  ) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 




local per_up = 95
local per_lo = 5


sort ccode year



sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp democracy  tyears t2 t3  lirrat"
logit target l.dirrat military ldir_mil   `control', cluster(ccode) robust 


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

tempname relplot 

postfile `relplot' effect low high military var6 var7 str4 model using "sim.dta", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1  )  ( "Non_mil" ) 

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  2  )  ( "Military" )   



drop change_2 effect xb1 xb2 p1 p2


use "main_target.dta", clear
set more off



local per_up = 95
local per_lo = 5


sort ccode year



sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
nbreg sumtarget l.dirrat military ldir_mil  `control' , cluster(ccode)  





drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  8  )  ( "Non_mil" ) 

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  9  )  ( "Military" )   

postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2

use "sim.dta", clear 




twoway (scatter effect var7  if(military==0) ///
		,msymbol(D) ) ///
	|| (scatter effect var7  if(military==1)    ///
		,msymbol(S) msize(large)) ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 10))  ///
	xlabel( 1.5 "Chebiub Regime Data" 8.5 "Count Model") ///
	legend( ///
			cols(3) ///
			label(1 "Non-Military Regimes") ///
			label(2 "Military Regimes") ///
			label(3 "95% CI")  ///
			) ///
	xtitle("") ytitle("Marginal Effect of Improving Credit Costs")
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy





************************************************************************************************************************************************


************************************************************************************************************************************************
**E Alternative Pathways - Targeting in Response to Military Regimes' Initiation?

use "main_target.dta", clear
set more off


local control "lncap growth_gdp5 gwf_dem  iyear i2 i3 lirrat"
logit init2 dirrat dir_mil military `control', cluster(ccode) robust
estimates store init



local control "lncap growth_gdp5 gwf_dem  l.iyear l.i2 l.i3 lirrat"
logit l.init2 dirrat dir_mil military `control', cluster(ccode) robust
estimates store linit



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat riots strikes anti_govt_dem"
logit target l.dirrat ldir_mil military  `control', cluster(ccode) robust
estimates store banks



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat ldir_mil military conflict_banks_wght `control', cluster(ccode) robust
estimates store banks2


lab var riots "Riots"
lab var strikes "Strikes"
lab var anti_govt_dem "Demostrations"
lab var conflict_banks_wght "Domestic Discontent"


estout init linit banks banks2,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) order(dirrat dir_mil military) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 



local per_up = 95
local per_lo = 5


sort ccode year



sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  iyear i2 i3 lirrat"
logit init2 dirrat dir_mil military `control', cluster(ccode) robust
estimates store init




drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

tempname relplot 

postfile `relplot' effect low high military var6 var7 str4 model using "sim.dta", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1  )  ( "Non_mil" ) 

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  2  )  ( "Military" )   



drop change_2 effect xb1 xb2 p1 p2


use "main_target.dta", clear
set more off



local per_up = 95
local per_lo = 5


sort ccode year



sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  l.iyear l.i2 l.i3 lirrat"
logit l.init2 dirrat dir_mil military `control', cluster(ccode) robust
estimates store linit 





drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  8  )  ( "Non_mil" ) 

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  9  )  ( "Military" )   

postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2

use "sim.dta", clear 



twoway (scatter effect var7  if(military==0) ///
		,msymbol(D) ) ///
	|| (scatter effect var7  if(military==1)    ///
		,msymbol(S) msize(large)) ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 10))  ///
		xlabel( 1.5 "Time t" 8.5 "Time t-1") ///
	legend( ///
			cols(3) ///
			label(1 "Non-Military Regimes") ///
			label(2 "Military Regimes") ///
			label(3 "95% CI")  ///
			) ///
	xtitle("Initiations") ytitle("Marginal Effect of Improving Credit Costs")
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy



************************************************************************************************************************************************


************************************************************************************************************************************************
**F Baseline of Conflict


use "main_target.dta", clear
set more off

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat neigh "
logit target l.dirrat ldir_mil military `control', cluster(ccode) 
estimates store m21

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat  rival"
logit target l.dirrat ldir_mil military `control', cluster(ccode) 
estimates store m22

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat  allies "
logit target l.dirrat ldir_mil military `control', cluster(ccode) 
estimates store m23

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat issues"
logit target l.dirrat ldir_mil military `control', cluster(ccode) 
estimates store m24

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat neigh rival allies issues"
logit target l.dirrat ldir_mil military `control', cluster(ccode) 
estimates store m25



estout m21 m22 m23 m24 m25,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) ///
 order(L.dirrat ldir_mil military neigh rival allies issues lncap growth_gdp5 gwf_dem  lirrat ) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 


use "main_target.dta", clear
set more off


local per_up = 95
local per_lo = 5


sort ccode year




sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)
sum  neigh 
local c11 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat neigh "
logit target l.dirrat military  ldir_mil `control', cluster(ccode) 
estimates store m21


estimates store m1


drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*`c11' + b12*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



tempname relplot 

postfile `relplot' effect low high military var6 var7 str4 model using "base", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1.8  )  ( "Neigh" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  2.2  )  ( "Neigh" )   


drop change_2 effect xb1 xb2 p1 p2

use "main_target.dta", clear
set more off


local per_up = 95
local per_lo = 5


sort ccode year

sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)
sum  rival 
local c11 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat  rival"
logit target l.dirrat military  ldir_mil `control', cluster(ccode) 
estimates store m21


estimates store m1


drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*`c11' + b12*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  5.8  )  ( "Rival" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  6.2  )  ( "Rival" )   

drop change_2 effect xb1 xb2 p1 p2


use "main_target.dta", clear
set more off


local per_up = 95
local per_lo = 5


sort ccode year


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)
sum  allies 
local c11 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat  allies "
logit target l.dirrat military  ldir_mil `control', cluster(ccode) 


drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*`c11' + b12*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  9.8  )  ( "Allies" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  10.2  )  ( "Neigh" )   


drop change_2 effect xb1 xb2 p1 p2


use "main_target.dta", clear
set more off


local per_up = 95
local per_lo = 5


sort ccode year

sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)
sum  issues 
local c11 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat issues"
logit target l.dirrat military  ldir_mil `control', cluster(ccode) 


drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*`c11' + b12*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  13.8  )  ( "Issues" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  14.2  )  ( "Issues" )   


drop change_2 effect xb1 xb2 p1 p2




use "main_target.dta", clear
set more off


local per_up = 95
local per_lo = 5


sort ccode year


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)
sum  neigh 
local c11 = r(mean)
sum  rival 
local c12 = r(mean)
sum  allies 
local c13 = r(mean)
sum  issues 
local c14 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat neigh rival allies issues"
logit target l.dirrat military  ldir_mil `control', cluster(ccode) 


drawnorm b1-b15, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*`c12' + b13*`c13' + b14*`c14'+  b15*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*`c11' + b12*`c12' + b13*`c13' + b14*`c14'+  b15*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  17.8  )  ( "All" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*`c12' + b13*`c13' + b14*`c14'+  b15*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*`c11' + b12*`c12' + b13*`c13' + b14*`c14'+  b15*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  18.2  )  ( "All" )   

postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2


use "base.dta", clear

twoway (scatter effect var7  if(military==0) ///
		,msymbol(D) msize(small) ) ///
	|| (scatter effect var7  if(military==1)    ///
		,msymbol(S) ) ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 20))  ///
xlabel( 2 "Neighbors" 6 "Rivals" 10 "Allies" 14 "Disputes" 18 "All" )  ///
	legend( ///
			cols(3) ///
			label(1 "Non-Military Regimes") ///
			label(2 "Military Regimes") ///
			label(3 "95% CI")  ///
			) ///
	xtitle("") ytitle("Marginal Effect of Improving Credit Costs")
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit xaxis1.style.editstyle majorstyle(tickangle(forty_five)) editcopy
gr_edit legend.DragBy -3.784650745826 0
gr_edit style.editstyle declared_xsize(5.5) editcopy

graph export "base_fig.pdf", as(pdf) replace







************************************************************************************************************************************************


************************************************************************************************************************************************
**G. Moving Averages and Changes in Bond Yields over Multiple Years

use "main_target.dta", clear
set more off


sort ccode year


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.s2irrat ls2ir_mil military `control', cluster(ccode) robust

estimates store m1

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.s3irrat ls3ir_mil military `control', cluster(ccode) robust

estimates store m2


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target  l.moveave2 lmove2_mil military `control', cluster(ccode) robust

estimates store m3

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target  l.moveave3 lmove3_mil military `control', cluster(ccode) robust

estimates store m4

estout m1 m2 m3 m4,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) starlevels(* 0.1 ** 0.05 *** 0.01) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) ///
 order(L.s2irrat ls2ir_mil  L.s3irrat ls3ir_mil L.moveave2 lmove2_mil L.moveave3 lmove3_mil military lncap growth_gdp5 gwf_dem lirrat) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 




use "main_target.dta", clear
set more off

local per_up = 95
local per_lo = 5



sort ccode year

sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.s2irrat military ls2ir_mil  `control', cluster(ccode) robust

drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



tempname relplot 

postfile `relplot' effect low high military var6 var7 str4 model using "avg.dta", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1.8  )  ( "Change2" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  2.2  )  ( "Change2"  )   

drop change_2 effect xb1 xb2 p1 p2




use "main_target.dta", clear
set more off
local per_up = 95
local per_lo = 5
sort ccode year


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.s3irrat military ls3ir_mil  `control', cluster(ccode) robust

drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 




post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  5.8  )  ( "Change3" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  6.2  )  ( "Change3"  )   

drop change_2 effect xb1 xb2 p1 p2



use "main_target.dta", clear
set more off
local per_up = 95
local per_lo = 5

sort ccode year


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.moveave2 military lmove2_mil   `control', cluster(ccode) robust

drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  9.8  )  ( "move2" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  10.2  )  ( "move2"  )   


drop change_2 effect xb1 xb2 p1 p2




use "main_target.dta", clear
set more off
local per_up = 95
local per_lo = 5

sort ccode year


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.moveave3 military lmove3_mil   `control', cluster(ccode) robust

drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  13.8  )  ( "move3" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  14.2  )  ( "move3"  )   

postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2


use "avg.dta", clear

twoway (scatter effect var7  if(military==0) ///
		,msymbol(D) msize(small) ) ///
	|| (scatter effect var7  if(military==1)    ///
		,msymbol(S) ) ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 16))  ///
xlabel( 2 "Change (2 Yr)" 6 "Change (3 Yr)" 10 "Avg. (2 Yr)" 14 "Avg. (3 Yr)" )  ///
	legend( ///
			cols(3) ///
			label(1 "Non-Military Regimes") ///
			label(2 "Military Regimes") ///
			label(3 "95% CI")  ///
			) ///
	xtitle("") ytitle("Marginal Effect of Improving Credit Costs")
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit xaxis1.style.editstyle majorstyle(tickangle(forty_five)) editcopy
gr_edit legend.DragBy -3.784650745826 0
gr_edit style.editstyle declared_xsize(5.5) editcopy

graph export "avg_fig.pdf", as(pdf) replace



************************************************************************************************************************************************


************************************************************************************************************************************************
**H Robustness of Relative Bond Yields
use "main_target.dta", clear
set more off


sort ccode year


**Table H7 Relative Bond Yields and Foreign Policy Affinity, 1946-2008
local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_by ldir__by_mil military `control', cluster(ccode) 
estimates store m1

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_sa ldir__sa_mil military `control', cluster(ccode)
estimates store m2

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_sv ldir__sv_mil military `control', cluster(ccode)
estimates store m3

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_ka ldir__ka_mil military `control', cluster(ccode)
estimates store m4

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_kv ldir__kv_mil military `control', cluster(ccode)
estimates store m5

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_pa ldir__pa_mil military `control', cluster(ccode)
estimates store m6

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_pv ldir__pv_mil military `control', cluster(ccode)
estimates store m7

estout m1 m2 m3 m4 m5 m6 m7,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) ///
 order(military L.dirrat_by ldir__by_mil L.dirrat_sa ldir__sa_mil L.dirrat_sv ldir__sv_mil L.dirrat_ka ldir__ka_mil L.dirrat_kv ldir__kv_mil L.dirrat_pa ldir__pa_mil L.dirrat_pv ldir__pv_mil lncap growth_gdp5 gwf_dem lirrat ) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 


use "main_target.dta", clear
set more off


sort ccode year

local per_up = 95
local per_lo = 5







sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_by military ldir__by_mil `control', cluster(ccode) 


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



tempname relplot 

postfile `relplot' effect low high military var6 var7 str4 model using "rel", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1.9  )  ( "Near" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  2.1  )  ( "Near" )   


use "main_target.dta", clear
set more off


sort ccode year

local per_up = 95
local per_lo = 5


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_sa military ldir__sa_mil `control', cluster(ccode)


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  5.9  )  ( "Sscore_a" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  6.1  )  ( "Sscore_a" )  




use "main_target.dta", clear
set more off


sort ccode year

local per_up = 95
local per_lo = 5


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_sv military ldir__sv_mil `control', cluster(ccode)


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  9.9  )  ( "Sscore_v" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  10.1  )  ( "Sscore_v" )   









use "main_target.dta", clear
set more off


sort ccode year

local per_up = 95
local per_lo = 5



sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_ka military ldir__ka_mil  `control', cluster(ccode)


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  13.9  )  ( "Kappa_a" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  14.1  )  ( "Kappa_a" )




use "main_target.dta", clear
set more off


sort ccode year

local per_up = 95
local per_lo = 5


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_kv military ldir__kv_mil  `control', cluster(ccode)


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  17.9  )  ( "Kappa_v" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  18.1  )  ( "Kappa_v" )   








use "main_target.dta", clear
set more off


sort ccode year

local per_up = 95
local per_lo = 5



sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_pa military ldir__pa_mil `control', cluster(ccode)


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  21.9  )  ( "Pi_a" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  22.1  )  ( "Pi_a" )   









use "main_target.dta", clear
set more off


sort ccode year

local per_up = 95
local per_lo = 5


sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat_pv military ldir__pv_mil `control', cluster(ccode)


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 




post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  25.9  )  ( "Pi_v" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
+ b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  26.1  )  ( "Pi_v" )   



postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2

use "rel.dta", clear

twoway (scatter effect var7  if(military==0) ///
		,msymbol(D) msize(small) ) ///
	|| (scatter effect var7  if(military==1)    ///
		,msymbol(S) ) ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 28))  ///
xlabel( 2 "Contiguous (M1) " 6 "S Score Allies (M2) " 10 "S Score Vote (M3) " 14 "{&kappa} Allies (M4) " 18 "{&kappa} Vote (M5) " 22 "{&pi} Allies (M6) " 26 "{&pi} Vote (M7) " ) ///
	legend( ///
			cols(3) ///
			label(1 "Non-Military Regimes") ///
			label(2 "Military Regimes") ///
			label(3 "95% CI")  ///
			) ///
	xtitle("") ytitle("Marginal Effect of Improving Credit Costs")
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit xaxis1.style.editstyle majorstyle(tickangle(forty_five)) editcopy
gr_edit legend.DragBy -3.784650745826 0
gr_edit style.editstyle declared_xsize(7.5) editcopy

graph export "relative_fig.pdf", as(pdf) replace








*******************************************************************************

**************************************************************************************************************************************************

***Table H.8: Alternative Robustness Models
use "main_target.dta", clear
set more off


sort ccode year

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3"
logit target l.pdirrat lpdir_mil military `control', cluster(ccode) robust
estimates store pd

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3"
logit target l.pdirate lpdirate_mil military `control', cluster(ccode) robust
estimates store nous

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 l.spread"
logit target l.dspread lspr_mil military `control', cluster(ccode) robust
estimates store spread

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3"
xtlogit target l.irrat lir_mil military `control' if ccode!=2, i(ccode) fe
estimates store fe



estout pd nous spread fe,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) ///
 order(l.pdirrat lpdir_mil l.pdirate lpdirate_mil l.dspread lspr_mil l.irrat lir_mil military  lncap growth_gdp5  gwf_dem   ) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 


*******************************************************************************

**************************************************************************************************************************************************
***I. Growth Alternative

use "main_target.dta", clear
set more off


sort ccode year




local control "lncap growth_gdp gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat military `control', cluster(ccode) 
estimates store m1


local control "lncap growth_gdp gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat ldir_mil military `control', cluster(ccode) 
estimates store m2


estout m1 m2 ,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) starlevels(* 0.1 ** 0.05 *** 0.01) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) ///
 order(L.dirrat ldir_mil  military lncap growth_gdp gwf_dem lirrat) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 


local per_up = 95
local per_lo = 5


sort ccode year




sum lncap 
local c4 = r(mean)
sum growth_gdp
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)



local control "lncap growth_gdp gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat military ldir_mil  `control', cluster(ccode) robust

drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



tempname relplot 

postfile `relplot' effect low high military var6 var7 str4 model using "gro1", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1  )  ( "Non_mil" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  5  )  ( "Mil"  )   

postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2


use "gro1.dta", clear 

 

twoway (scatter effect var7  if(military==0) ) ///
	|| (scatter effect var7 if(military==1))    ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 6))  ///
	xlabel( 1 "Non-Military" 5 "Military ") ///
	xtitle("Regimes") ytitle("Marginal Effect of Improving Credit Costs") ///
	legend(off)
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy


*******************************************************************************

**************************************************************************************************************************************************
***J Outliers and Influential Observations

use "main_target.dta", clear
set more off


sort ccode year

sum dirrat
gen sd = r(sd)
gen sd3 = sd*3
gen outlier = 1 if (dirrat  > sd3  | dirrat  < (sd3*-1)) &dirrat!=. 

list country ccode year dirrat if outlier ==1 

listtex country year dirrat  if outlier ==1, type rstyle(tabular) ///
            head("\begin{tabular}{l l l}" `"\textit{Country}&\textit{Year}&\textit{$\Delta$ Bond Yield}\\"') foot("\end{tabular}")
			

			
			
local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat military `control' if outlier!=1, cluster(ccode) 
estimates store m1


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat ldir_mil military `control' if outlier!=1, cluster(ccode) 
estimates store m2


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target ldirrat ldir_mil military `control' , cluster(ccode) 

  
predict cook, dbeta

label var cook "Cook's"

graph twoway scatter cook ccodeyear, xlabel(0(200)800) ylabel(0(.1).7) ///
xtitle("Observation") ytitle("Cook's Distance")  yline(.1) ///
msymbol(none) mlabel(country) mlabposition(0) 

gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit xaxis1.draw_view.setstyle, style(no)

graph export "cook_dis.pdf", as(pdf) replace

list country ccode year dirrat cook if cook>.1 & cook!=.

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat military `control' if cook<=.1, cluster(ccode) 
estimates store m3


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat ldir_mil military `control' if cook<=.1, cluster(ccode) 
estimates store m4


estout m1 m2 m3 m4,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) starlevels(* 0.1 ** 0.05 *** 0.01) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) ///
 order(L.dirrat ldir_mil  military lncap growth_gdp5 gwf_dem lirrat) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Logit Examining Interstate Targets") 


use "main_target.dta", clear
set more off

sum dirrat
gen sd = r(sd)
gen sd3 = sd*3
gen outlier = 1 if (dirrat  > sd3  | dirrat  < (sd3*-1)) &dirrat!=. 

local per_up = 95
local per_lo = 5


sort ccode year




sum lncap 
local c4 = r(mean)
sum growth_gdp5
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat military ldir_mil  `control' if outlier!=1, cluster(ccode) robust

drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



tempname relplot 

postfile `relplot' effect low high military var6 var7 str4 model using "out", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1  )  ( "Non_mil" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  5  )  ( "Mil"  )   

postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2


use "out.dta", clear 


twoway (scatter effect var7  if(military==0) ) ///
	|| (scatter effect var7 if(military==1))    ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 6))  ///
	xlabel( 1 "Non-Military" 5 "Military ") ///
	xtitle("Regimes") ytitle("Marginal Effect of Improving Credit Costs") ///
	legend(off)
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy

graph export "out.pdf", as(pdf) replace


use "main_target.dta", clear
set more off


local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target ldirrat ldir_mil military `control' , cluster(ccode) 

  
predict cook, dbeta

sort ccode year

local per_up = 95
local per_lo = 5


sort ccode year




sum lncap 
local c4 = r(mean)
sum growth_gdp5
local c5 = r(mean)
sum democracy
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat"
logit target l.dirrat military ldir_mil  `control' if cook<=.1, cluster(ccode) robust

drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb1 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*0  + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7'+ b8*`c8' + b9*`c9'   ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))


gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Non-Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 



tempname relplot 

postfile `relplot' effect low high military var6 var7 str4 model using "cook", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1  )  ( "Non_mil" )   


drop change_2 effect xb1 xb2 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb1 =   b1*0 + b2*1 + b3*0*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p1 = 1/(1 + exp(-xb1))

sum p1

gen xb2 =  b1*-1 + b2*1 + b3*-1*1  + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
gen p2 = 1/(1 + exp(-xb2))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 


post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  5  )  ( "Mil"  )   

postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2



clear all
use "cook.dta", clear 


 

twoway (scatter effect var7  if(military==0) ) ///
	|| (scatter effect var7 if(military==1))    ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 6))  ///
	xlabel( 1 "Non-Military" 5 "Military ") ///
	xtitle("Regimes") ytitle("Marginal Effect of Improving Credit Costs") ///
	legend(off)
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy

graph export "cook.pdf", as(pdf) replace
