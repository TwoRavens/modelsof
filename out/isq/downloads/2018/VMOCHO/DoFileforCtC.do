 /*Do File for "Cleansing the Caliphate: Insurgent Violence against Sexual 
 Minorities"*/
 
 
******
***Results
******
 
/*Reproducing this figure requires downloading the coefplot package.*/

*Figure 1*
	
quietly logit targeting rival multiple strength sponsor democracy time time2 ///
	time3, robust cluster(sideb)
estimates store Model1
quietly logit targeting rival state territory multiple strength sponsor ///
	democracy time time2 time3, robust cluster(sideb)	
estimates store Model2	
quietly logit targeting rival state territory transform moderate multiple ///
	strength sponsor democracy time time2 time3, robust cluster(sideb)	
estimates store Model3
coefplot (Model1, label(Model 1) mcolor(black)) ///
	(Model2, label(Model 2) msymbol(d) mfcolor(white)) ///
	(Model3, label(Model 3) msymbol(s) pstyle(8) mcolor(gray12) mfcolor(gray12)), ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") xline(0, lcolor(red) lpattern(dash)) ///
	mcolor(black) mfcolor(black) msize(medlarge) ///
	levels(95 95.001) ciopts(recast(. rcap) msize(medlarge) lcolor(black)) ///
	title("Figure 1: Results", color(black)) ///
	note("N = 1545" "95% confidence intervals") ///
	order(rival state territory transform moderate multiple strength sponsor democracy)	

///Generate results, see Table A3 below
logit targeting rival multiple strength sponsor democracy time time2 time3, ///
	robust cluster(sideb)
logit targeting rival state territory multiple strength sponsor ///
	democracy time time2 time3, robust cluster(sideb)
logit targeting rival state territory transform moderate multiple ///
	strength sponsor democracy time time2 time3, robust cluster(sideb)

	
******
***Substantive Effects
******

*Figure 2*

quietly logit targeting rival multiple strength sponsor democracy time time2 time3, ///
	robust cluster(sideb)
margins, vce(delta) estimtolerance(1e-5) at(rival=(0(1)1)) atmeans vsquish
marginsplot, recast(bar) allxlabels ///
	ciopts(lcolor(red) msize(medlarge)) ///
	ytitle("Pr(Targeting)" "" msize(medium)) ///
	graphregion(color(white)) yline(0, lcolor(black) lpattern(dash)) ///
	title("Figure 2: Substantive Effect of Rivalry", color(black)) ///
	note("95% confidence intervals") 

*Figure 3*
	
quietly logit targeting rival state territory transform moderate multiple strength sponsor democracy time ///
	time2 time3, robust cluster(sideb)
margins, vce(delta) estimtolerance(1e-5) at(state=(0(1)2)) at(rival=(0) territory=(0) transform=(0) moderate=(0) multiple=(0) strength=(0) sponsor=(0) democracy=(0) time=(0) time2=(0) time3=(0)) vsquish
marginsplot, recast(bar) ///
	ciopts(lcolor(red) msize(medlarge)) ///
	ytitle("Pr(Targeting)" "" msize(medium)) ///
	graphregion(color(white)) yline(0, lcolor(black) lpattern(dash)) ///
	title("Substantive Effect of State Legitimation", color(black)) ///
	name(Sub1)
quietly logit targeting territory rival state transform moderate multiple strength sponsor democracy time time2 time3, ///
	robust cluster(sideb)
margins, vce(delta) estimtolerance(1e-5) at(territory=(0(1)1)) at(rival=(0) state=(0) transform=(0) moderate=(0) multiple=(0) strength=(0) sponsor=(0) democracy=(0) time=(0) time2=(0) time3=(0)) vsquish
marginsplot, recast(bar) ///
	ciopts(lcolor(red) msize(medlarge)) ///
	ytitle("Pr(Targeting)" "" msize(medium)) ///
	graphregion(color(white)) yline(0, lcolor(black) lpattern(dash)) ///
	title("Substantive Effect of Territory", color(black)) ///
	name(Sub2)
quietly logit targeting rival state strength territory transform moderate multiple strength sponsor democracy time ///
	time2 time3, robust cluster(sideb)
margins, vce(delta) estimtolerance(1e-5) at(transform=(0(1)1)) at(rival=(0) state=(0) territory=(0) moderate=(0) multiple=(0) strength=(0) sponsor=(0) democracy=(0) time=(0) time2=(0) time3=(0)) vsquish
marginsplot, recast(bar) ///
	ciopts(lcolor(red) msize(medlarge)) ///
	ytitle("Pr(Targeting)" "" msize(medium)) ///
	graphregion(color(white)) yline(0, lcolor(black) lpattern(dash)) ///
	title("Substantive Effect of Transformative Ideology", color(black)) ///
	name(Sub3)
graph combine Sub1 Sub2 Sub3, ///
	title("Figure 3: Additional Substantive Effects", color(black)) graphregion(color(white)) ///
	note("95% confidence intervals")
graph drop Sub1 Sub2 Sub3


	
**********************
*******APPENDIX*******
**********************

******
***Table 3A
******

///Model 0A
logit targeting rival, robust cluster(sideb)

///Model 0B
relogit targeting rival

///Model 1
logit targeting rival multiple strength sponsor democracy time time2 time3, ///
	robust cluster(sideb)
	
///Model 2	
relogit targeting rival multiple strength sponsor democracy time time2 time3

///Model 3
logit targeting rival state territory multiple strength sponsor ///
	democracy time time2 time3, robust cluster(sideb)

///Model 4	
relogit targeting rival state territory multiple strength sponsor democracy ///
	time time2 time3

///Model 5
logit targeting rival state territory transform moderate multiple ///
	strength sponsor democracy time time2 time3, robust cluster(sideb)

///Model 6
relogit targeting rival state territory transform moderate multiple ///
	strength sponsor democracy time time2 time3


*******
***Figure 3A
*******

/*Reproducing this figure requires downloading both the coefplot and relogit
packages.*/

quietly logit targeting rival multiple strength sponsor democracy time ///
	time2 time3, robust cluster(sideb)

coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 1: Logit", color(black)) ///
	name(Logita)

quietly relogit targeting rival multiple strength sponsor democracy

coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 2: Relogit", color(black)) ///
	name(Relogita)

quietly logit targeting rival state territory multiple strength sponsor ///
	democracy, robust cluster(sideb)
	
coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 3: Logit", color(black)) ///
	name(Logitb)
	
quietly relogit targeting rival state territory multiple strength sponsor ///
	democracy time time2 time3
	
coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 4: Relogit", color(black)) ///
	name(Relogitb)

quietly logit targeting rival state territory transform moderate multiple ///
	strength sponsor democracy time time2 time3, robust cluster(sideb)

coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 5: Logit", color(black)) ///
	name(Logitc)
	
quietly relogit targeting rival state territory transform moderate multiple ///
	strength sponsor democracy time time2 time3
		
coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 6: Relogit", color(black)) ///
	name(Relogitc)
	
graph combine Logita Relogita Logitb Relogitb Logitc Relogitc, ///
	title("Figure 3A: Results", color(black)) graphregion(color(white)) ///
	note("N = 1545" "95% confidence intervals")
	
graph drop Logita Relogita Logitb Relogitb Logitc Relogitc

*******
***Figure 4A
*******

///Reproducing these outputs requires both the cem and coefplot packages

imb multiple strength sponsor state territory democracy, ///
	treatment(rival)

cem multiple strength sponsor state territory democracy, ///
	treatment(rival)

logit targeting rival multiple strength sponsor democracy time time2 time3 ///
	[iweight=cem_weights], robust cluster(sideb)

coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 7", color(black)) ///
	name(Logita)

logit targeting rival state territory multiple strength sponsor democracy ///
	 [iweight=cem_weights], robust cluster(sideb)

coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 8", color(black))  ///
	name(Logitb)
	
logit targeting rival state territory transform moderate multiple strength ///
	sponsor democracy time time2 time3 [iweight=cem_weights], ///
	robust cluster(sideb)
	
coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 9", color(black))  ///
	name(Logitc)

graph combine Logita Logitb Logitc, ///
	title("Figure 4A: Results from Matching Analysis", color(black)) ///
	graphregion(color(white)) note("N = 824" "95 percent confidence intervals")
	
graph drop Logita Logitb Logitc

drop cem_weights	
	
*******
***Figure 5A
*******

logit target rival state territory transform moderate multiple strength ///
	sponsor polwing transtate democracy time time2 time3, robust cluster(sideb)
	
coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 10: Logit", color(black)) ///
	name(Model10)

relogit target rival state territory transform moderate multiple strength ///
	sponsor polwing transtate democracy
	
coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 11: Relogit", color(black)) ///
	name(Model11)
	
logit target rival state territory transform moderate multiple strength ///
	sponsor polwing transtate democracy, robust cluster(location)
	
coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 12: State Cluster", color(black)) ///
	name(Model12)	
	
logit target rival state territory transform moderate multiple strength ///
	sponsor polwing transtate democracy time time2 time3, robust cluster(region)
	
coefplot, xline(0, lcolor(red) lpattern(dash)) ///
	graphregion(color(white)) drop(time time2 time3) ///
	coeflabels(_cons = "Constant") ///
	msymbol(d) mcolor(black) mfcolor(black) ///
	levels(95 95.001) ciopts(recast(. rcap)) ///
	title("Model 13: Region Cluster", color(black)) ///
	name(Model13)	
	
graph combine Model10 Model11 Model12 Model13, ///
	graphregion(color(white)) ///
	note("N = 1545" "95 percent confidence intervals") ///
	title("Figure 5A: Robustness Checks", color(black))	
	
graph drop Model10 Model11 Model12 Model13
