*************************************************************
/*
.do file for :

Borrowing Trouble: Sovereign Credit, Military Regimes, and Conflict
Patrick Shea, University of Houston (pshea@uh.edu)

The following file is for the main manuscript's tables and
graphs. Necessary packages are detailed below.  Replication materials 
for appendix is found in a separate file. 

STATA version: 14

August 14, 2015

*/

***************************************************************************
*Directory
cd "C:\Users\Shea\Dropbox\My Projects\Targets\Work\Data\Analysis\"

*Main data file
use "main_target.dta", clear
set more off


*********************************************************
*Table 1 - Cross Tabs of Military Regimes and Conflict
*********************************************************

tab conflict2  military, chi2 r co 




**********************************************************************
*Figure 1 - Histogram of Bond Yield Changes (Military and Non-Military
***********************************************************************





twoway (histogram  ldirrat if military==1,  width(.1) color(edkblue) ) ///
       (histogram ldirrat if military==0 & ldirrat <2 & ldirrat>-2,  width(.1) ///
	   fcolor(none) lcolor(black)), legend(order(1 "Military" 2 "Non-Military" )) ///
	   xlabel(-2(1)2) graphregion(fcolor(white)) xtitle("Changes in Bond Yield")

	   graph export "hist2.pdf", as(pdf) replace
	   

*********************************************************
*Table 2 - Main Logistic Regression Results
*********************************************************	   


****BASELINE***********************

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat military `control', cluster(ccode) 
estimates store m1

***Interaction***********************



local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat "
logit target l.dirrat ldir_mil military `control', cluster(ccode) 
estimates store m2	   

estout m1 m2 ,  cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) ///
 order(L.dirrat military ldir_mil ) ///
mlabels ("Model 1" "Model 2"   )

	   
	   
*********************************************************
*Figure 2 - Simulated Marginal Effects Graph from Model 2
*********************************************************	 
use "main_target.dta", clear
set more off

local per_up = 95
local per_lo = 5

sort ccode year

sum lncap 
local c4 = r(mean)
sum growth_gdp5
local c5 = r(mean)
sum gwf_dem
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem tyears t2 t3  lirrat"
logit target l.dirrat military ldir_mil   `control', cluster(ccode) robust 


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

postfile `relplot' effect low high military var6 var7 str4 model using "sim.dta", replace 


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

post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  5  )  ( "Military" )   

postclose `relplot'

drop change_2 effect xb1 xb2 p1 p2

use "sim.dta", clear 
 

twoway (scatter effect var7  if(military==0) ) ///
	|| (scatter effect var7 if(military==1))    ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 6))  ///
	xlabel( 1 "Non-Military" 5 "Military ") ///
	xtitle("Regimes") ytitle("Marginal Effect of Improving Bond Yields") ///
	legend(off)
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy

graph export "geddes3.pdf", as(pdf) replace

*********************************************************
*Figure 3 - Predicted Probabilities
*********************************************************	 
use "main_target.dta", clear
set more off


sort ccode year




sum lncap 
local c4 = r(mean)
sum growth_gdp5
local c5 = r(mean)
sum gwf_dem
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)




local control "lncap growth_gdp5 gwf_dem  tyears t2 t3  lirrat"
logit target l.dirrat military ldir_mil   `control', cluster(ccode) robust 


estimates store m1


drawnorm b1-b11, n(10000) means(e(b)) cov(e(V)) clear

postutil clear

postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 ///
           using "sim.dta", replace



local i = -2.2

while `i' <= 2{
{

**Predicted Probilities for Non-Military Regimes (b2*0)
gen xb0 =  b1*`i' + b2*0 + b3*`i'*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1
 

gen prob0 = 1/(1 + exp(-xb0))
egen probhat0 =mean(prob0)

**Predicted Probilities for Military Regimes (b2*1 and b6*0)
gen xb1 =  b1*`i' + b2*1 + b3*`i'*1 + b4*`c4' + b5*`c5' + b6*0 + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*1

gen prob1= 1/(1 + exp(-xb1))
egen probhat1 =mean(prob1)
 
tempname prob_hat0 lo0 hi0  prob_hat1 lo1 hi1  

_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)

_pctile prob1, p(2.5,97.5) 
scalar `lo1' = r(r1)
scalar `hi1' = r(r2)

scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1

 post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
      }
 
 drop xb0 prob0  probhat0 xb1 prob1  probhat1
local i= `i' + .01
display "." _c
} 

display ""

postclose mypost

use "sim.dta", clear

gen yline=0

gen MV = (_n-221)/100
drop if MV>2


*Note that drarea is a special STATA program to overlay graps. 
ssc install drarea

drarea hi1 lo1 hi0 lo0  MV, color(edkblue gs8) ///
 twoway (( line prob_hat1 MV, clcolor(black)) (line prob_hat0 MV, clcolor(black))) ///
 ytitle(Probability of Being Targeted in MID) ///
xtitle("Change in Bond Yield") ///
xlabel(-2(1)2) ylabel(0(.2)1) ///
title (Predicted Probabilities and Confidence Intervals) ///
graphregion(fcolor(white)) ///
legend(label(1 "Military Regimes") label(2 "Non-Military Regimes") order(1 2))

graph export "predprob2.pdf", as(pdf) replace



*********************************************************
*Figure 4 - Conflict's effect on Bond Yields
*********************************************************	

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
stats( aic N, fmt(%9.2f %9.0f ) labels("AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) order( target ltarget ) ///
mlabels ("Model 1" "Model 2" "Model 3" "Model 4"  ) ///
title("Random Effects Logit Examining Interstate Targets") 

*Note: You'll will need to download package coefplot
ssc install coefplot

coefplot  (tm0) (tm1) (t1m0)  (t1m1), ///
levels(95) drop( ldirrat growth_gdp5 tyears us2 _cons) xline(0)  ///
coeflabels(target = "Target time t") xlabel(-1(.5)1) 


*Just some style changes for graph
gr_edit plotregion1.plot5.style.editstyle area(linestyle(color(navy))) editcopy
gr_edit  plotregion1.plot6.style.editstyle marker(fillcolor(navy)) editcopy
gr_edit  plotregion1.plot6.style.editstyle marker(linestyle(color(navy))) editcopy
gr_edit  plotregion1.plot7.style.editstyle area(linestyle(color(maroon))) editcopy
gr_edit  plotregion1.plot8.style.editstyle marker(fillcolor(maroon)) editcopy
gr_edit plotregion1.plot8.style.editstyle marker(linestyle(color(maroon))) editcopy
gr_edit  yaxis1.major.num_rule_ticks = 0
gr_edit yaxis1.edit_tick 2 2 `"Target time t-1"', tickset(major)
gr_edit legend.plotregion1.label[1].text = {}
gr_edit legend.plotregion1.label[1].text.Arrpush All Regimes
gr_edit legend.plotregion1.label[2].text = {}
gr_edit legend.plotregion1.label[2].text.Arrpush Military Regimes
gr_edit legend.plotregion1.label[3].draw_view.setstyle, style(no)
gr_edit legend.plotregion1.label[3].fill_if_undrawn.setstyle, style(no)
gr_edit legend.plotregion1.key[3].draw_view.setstyle, style(no)
gr_edit legend.plotregion1.label[4].draw_view.setstyle, style(no)
gr_edit legend.plotregion1.key[4].draw_view.setstyle, style(no)
gr_edit xaxis1.title.text = {}
gr_edit xaxis1.title.text.Arrpush Changes in Bond Yields
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy

graph export "targetoncredit.pdf", as(pdf) replace

*********************************************************
*Table 3 and Figure 5 - Selection Models and Graph
*********************************************************	

use "main_target.dta", clear
set more off


logit bond gwf_dem military lncap growth_gdp5 exports2 lngdp t_* reg_* tyear, cluster(ccode) robust
predict p1, xb

estimates store msel
gen mills = exp(-.5*p1^2)/(sqrt(2*_pi)*normprob(p1))

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat mills"
logit  target l.dirrat ldir_mil military `control',  cluster(ccode) robust
estimates store mout

lab var military "Military (GWF)"
lab var lncap "Capabilities"
lab var gwf_dem "Democracy (GWF)"
lab var tyear "Years since Targeted"
lab var t2 "Years since Targeted$^2$"
lab var t3 "Years since Targeted$^3$"

lab var t_1 "1960 - 1969"
lab var t_2 "1970 - 1979"
lab var t_3 "1980 - 1989"
lab var t_4 "1990 - 1999"
lab var t_5 "2000 - 2008"

la var exports "Exports"
lab var lngdp "GDP"


*Table 3 
estout  msel mout,   cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	eqlab("/lnsig2u" "ln($\sigma^2_u$)", none) ///
stats( ll aic N, fmt(%9.1f %9.1f %9.0f) labels("Log Likelihood" "AIC"))  style(tex) ///
legend label collabels(none) varlabels(_cons Constant) order(L.dirrat military ldir_mil lncap growth_gdp5 lirrat gwf_dem ) ///
drop(t_* reg_*) ///
mlabels ("Model 1" "Model 2"  )


local per_up = 95
local per_lo = 5

sort ccode year

sum lncap 
local c4 = r(mean)
sum growth_gdp5
local c5 = r(mean)
sum gwf_dem
local c6 = r(mean)
sum tyears 
local c7 = r(mean)
sum t2
local c8 = r(mean)
sum t3 
local c9 = r(mean)
sum lirrat 
local c10 = r(mean)
sum mills 
local c11 = r(mean)

local control "lncap growth_gdp5 gwf_dem  tyear t2 t3 lirrat mills"						
logit  target l.dirrat military ldir_mil  `control',  cluster(ccode) robust

drawnorm b1-b12, n(10000) means(e(b)) cov(e(V)) clear



**marginal effect of decreased bond yield for non-military regimes (i.e. b2*0)
gen xb0 =  b1*0 + b2*0 + b3*0*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*1
  
gen p1 = 1/(1 + exp(-xb0))

sum p1

gen xb1 =  b1*-1+ b2*0 + b3*-1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*1


gen p2 = 1/(1 + exp(-xb1))


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

postfile `relplot' effect low high military var6 var7 str4 model using "sim.dta", replace 


post `relplot' (effect) (`lo')  ( `hi' ) ( 0 )  ( 1 )  (  1  )  ( "Non_mil" )   


drop change_2 effect xb1 xb0 p1 p2


**marginal effect of decreased bond yield for military regimes (i.e. b2*1)
gen xb0 =  b1*0 + b2*1 + b3*1*0 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*1
  
  
gen p1 = 1/(1 + exp(-xb0))

sum p1

gen xb1 =  b1*-1+ b2*1 + b3*-1*1 + b4*`c4' + b5*`c5' + b6*`c6' + b7*`c7' + b8*`c8' + b9*`c9'  ///
 + b10*`c10' + b11*`c11' + b12*1

gen p2 = 1/(1 + exp(-xb1))

gen change_2 = (p2 - p1)/p1
egen effect = mean(change_2)

_pctile change_2, p(`per_lo',`per_up')
local lo= r(r1)
local hi= r(r2)

sum effect
local effect = r(mean)

di in yellow "Effect of Decreased Bond Yield Change for Military Regimes"
di in yellow `effect' in green " [ " in yellow `hi' in green " , " in yellow `lo' in green " ]" 

post `relplot' (effect) (`lo')  ( `hi' ) ( 1 )  ( 1 )  (  5  )  ( "Military" )   

postclose `relplot'

drop change_2 effect xb1 xb0 p1 p2

use "sim.dta", clear 
 

twoway (scatter effect var7  if(military==0) ) ///
	|| (scatter effect var7 if(military==1))    ///
		|| rcap  low high var7 	///	
		,lwidth(med) lcolor(black)  ///
	,    xscale(range(0 6))  ///
	xlabel( 1 "Non-Military" 5 "Military ") ///
	xtitle("Regimes") ytitle("Marginal Effect of Improving Bond Yields") ///
	legend(off)
	
gr_edit style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy





graph export "sel_fig.pdf", as(pdf) replace

	   
