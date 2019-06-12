
*global DATADIR  "C:\Users\abouchat\Dropbox\Balancing"
global DATADIR  "C:\Users\MarkusWagner\Dropbox\Balancing"
*global DATADIR  "C:\Users\Tarik\Dropbox\Balancing"


cd "$DATADIR"
 
use "Data/JOP_micro_ACW.dta", clear


eststo clear

*** ML MODELS - MAIN RESULTS - TABLE 2
eststo clear 


eststo: melogit vote_ml c.investment_simpler i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)   || cy: || cyear: 

eststo: melogit vote_ml c.investment_simpler##i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)  || cy: || cyear: 

*margins, dydx(investment_simpler) at(unionnew=(0 1)) predict(mu fixed) 

margins, at(investment_simpler=(.33 2.03) unionnew=(1)) pwcompare predict(mu fixed)

*marginsplot, scheme(plottig) recastci(rcap) ciopts(lpattern(dash) lcolor(black) lwidth(thick) msize(large))  ///
*xline(0, lpattern(dash) lwidth(thick)) xscale(range(-.15 .05)) title("")  xtitle("Marginal Effect of Investment") ///
*xlabel(-.15(.05).05) ytitle("Union membership") leg(reg(lp(blank))) recast(scatter) yscale(range(-.5 1.5)) ///
* horizontal ylabel(1 "Current member" 0 "Not a member") plotopts(msize(large))

gen helpvar2=.23
label define helplabel 1 "|", replace
gen helplabel=1
label values helplabel helplabel

margins, at(investment_simpler=(-0.4(1.1)4) unionnew=(0 1)) predict(mu fixed) 

marginsplot, by(unionnew) scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))    title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment Position") leg(reg(lp(blank))) recast(line) 

*** FIGURE 3

marginsplot, scheme(plottig) recastci(rline) ci1opts(lpattern(dash) lcolor(black)) ///
ci2opts(lpattern(dash) lcolor(gs8)) ///
 plot1opts(lcolor(black)) plot2opts(lcolor(gs8))  title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment-Consumption Position") ///
text(.31 0.4 "Not union") text(.42 0.4 "Union") ///
leg(reg(lp(blank))) recast(line) ///
 addplot(scatter helpvar2 investment_simpler  if e(sample), below  mlabel(helplabel) mlabpos(0) ///
 mlabsize(large) msymbol(i) legend(off) mlabcolor(black) fcolor(gs15) color(gs15) ///
 xscale(range(-.5 4.5) ) xlabel(-.5 (.5) 4.5) yscale(range(.2 .5)) )   
 
graph export "Graphs/ess_union_ML.png", as(png) width(1920) height(1080) replace


tabulate cy essround if e(sample)

eststo:melogit vote_ml c.investment_simpler c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 

eststo:melogit vote_ml c.investment_simpler##c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 

margins, at(investment_simpler=(.33 2.03) cosmolib_pos=(-1.14)) pwcompare predict(mu fixed)

gen helpvar=-.05

margins, dydx(investment_simpler) at(cosmolib_pos=(-2(.8)4.4)) predict(mu fixed)

*** FIGURE 4 
marginsplot, scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))  yline(0, lpattern(dash))  title("") ///
ytitle(Marginal Effect of Investment) xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position") leg(reg(lp(blank))) recast(line) ///
 addplot(scatter helpvar cosmolib_pos  if e(sample), below  mlabel(helplabel) mlabcolor(black)  msymbol(i) mlabpos(0) mlabsize(large) legend(off) fcolor(gs15) color(gs15) xscale(range(-3 5) ) yscale(range(-.06 .06)) )   

graph export "Graphs/ess_prof_ML.png", as(png) width(1920) height(1080) replace

tabulate cy essround if e(sample)


esttab using "Results/Micro Regression results ML.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	se eqlabels("Variance (Survey)" "Variance (Country)" , none) ///
	mlabel ("Model 1" "Model 2" "Model 3" "Model 4") /// 
	label ///
	varwidth(13)
	
drop helpvar* helplabel	
	
	*** TABLE A16.2
	
	eststo clear
	melogit vote_ml c.investment_simpler i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)   || cy: || cyear: 
	
	egen missing=rowmiss(vote_ml investment_simpler unionnew cosmolib_pos market ///
	right_inv_simpler_left  rural edulvla agea  ///
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag) ///
if (occupation==8  | occupation==11)

estpost summarize vote_ml investment_simpler unionnew cosmolib_pos market ///
	right_inv_simpler_left  rural edulvla agea  ///
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag  if missing==0 

esttab using "Results/Micro DescrWC.rtf", cells("count mean sd min max") noobs rtf replace

*** TABLE A16.3

melogit vote_ml c.investment_simpler c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 

egen missing2=rowmiss(vote_ml investment_simpler cosmolib_pos unionnew market edulvla agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left) ///
 if (occupation==1 | occupation==2 | occupation==3 )	
 
 estpost summarize vote_ml investment_simpler cosmolib_pos unionnew market edulvla agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
if missing2==0
 
 
esttab using "Results/Micro DescrProf.rtf", cells("count mean sd min max") noobs rtf replace

tab unionnew if missing==0
tab unionnew if missing2==0

 
	

	
	****************
	***** ROB CHECK WITH OPPOSITE INTERACTIONS 
	***** *** TABLE A11.3, FIGURES A11.1 and A11.2
	****************
eststo clear	
eststo: melogit vote_ml c.investment_simpler##i.unionnew c.investment_simpler##c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)   || cy: || cyear: 

margins, at(investment_simpler=(-0.4(0.8)3.6) unionnew=(0 1)) predict(mu fixed) 
marginsplot, by(unionnew) scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))    title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment Position") leg(reg(lp(blank))) recast(line) 
 
graph export "Graphs/ess_union_ML_robwithcosmolin.png", as(png) width(1920) height(1080) replace

*Rob check: Cosmo for working class* 
margins, dydx(investment_simpler) at(cosmolib_pos=(-1.6(.8)4.4)) predict(mu fixed)

marginsplot, scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))  yline(0, lpattern(dash))  title("") ///
ytitle(Marginal Effect of Investment) xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position") leg(reg(lp(blank))) recast(line) 

graph export "Graphs/ess_union_ML_cosmolib.png", as(png) width(1920) height(1080) replace

eststo:melogit vote_ml c.investment_simpler##c.cosmolib_pos c.investment_simpler##i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec  id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 

margins, dydx(investment_simpler) at(cosmolib_pos=(-1.6(.8)4.4)) predict(mu fixed)

marginsplot, scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))  yline(0, lpattern(dash))  title("") ///
ytitle(Marginal Effect of Investment) xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position") leg(reg(lp(blank))) recast(line) 
 
graph export "Graphs/ess_prof_ML_robwithunions.png", as(png) width(1920) height(1080) replace

margins, at(investment_simpler=(-0.4(0.8)3.6) unionnew=(0 1)) predict(mu fixed) 
marginsplot, by(unionnew) scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))    title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment Position") leg(reg(lp(blank))) recast(line) 
 
graph export "Graphs/ess_union_ML_profs.png", as(png) width(1920) height(1080) replace



esttab using "Results/Micro Regression results ML rob with opposite interactions.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	se eqlabels("Variance (Survey)" "Variance (Country)" , none) ///
	mlabel ("Model 1" "Model 2" "Model 3" "Model 4") /// 
	label ///
	varwidth(13)
	
	
	*** ROB CHECK: INCLUDE NON-VOTERS
	*** APPENDIX 12
	
	
gen vote_ml2=vote_ml
replace vote_ml2=0 if vote==2
eststo clear
eststo: melogit vote_ml2 c.investment_simpler i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)   || cy: || cyear: 

eststo: melogit vote_ml2 c.investment_simpler##i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)  || cy: || cyear: 

margins, at(investment_simpler=(-0.4(1.1)4) unionnew=(0 1)) predict(mu fixed) 


gen helpvar2=.15
label define helplabel 1 "|", replace
gen helplabel=1
label values helplabel helplabel


marginsplot, scheme(plottig) recastci(rline) ci1opts(lpattern(dash) lcolor(black)) ///
ci2opts(lpattern(dash) lcolor(gs8)) ///
 plot1opts(lcolor(black)) plot2opts(lcolor(gs8))  title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment-Consumption Position") ///
text(.26 0.4 "Not union") text(.35 0.4 "Union") ///
leg(reg(lp(blank))) recast(line) ///
 addplot(scatter helpvar2 investment_simpler  if e(sample), below  mlabel(helplabel) mlabpos(0) ///
 mlabsize(large) msymbol(i) legend(off) mlabcolor(black) fcolor(gs15) color(gs15) ///
 xscale(range(-.5 4.5) ) xlabel(-.5 (.5) 4.5) yscale(range(.1 .45)) )   

 
graph export "Graphs/ess_union_ML_NONVOTERS.png", as(png) width(1920) height(1080) replace


eststo:melogit vote_ml2 c.investment_simpler c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 

eststo:melogit vote_ml2 c.investment_simpler##c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 


margins, dydx(investment_simpler) at(cosmolib_pos=(-2(.8)4.4)) predict(mu fixed)

marginsplot, scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))  yline(0, lpattern(dash))  title("") ///
ytitle(Marginal Effect of Investment) xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position") leg(reg(lp(blank))) recast(line) 

graph export "Graphs/ess_prof_ML_NONOTERS.png", as(png) width(1920) height(1080) replace

esttab using "Results/Micro Regression results ML with nonvoters.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	se eqlabels("Variance (Survey)" "Variance (Country)" , none) ///
	mlabel ("Model 1" "Model 2" "Model 3" "Model 4") /// 
	label ///
	varwidth(13)

	
	
	drop helpvar* helplabel
	

	
*** Rob check without party ID
*** APPENDIX 13 

eststo clear 

eststo: melogit vote_ml c.investment_simpler i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec  gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)   || cy: || cyear: 

eststo: melogit vote_ml c.investment_simpler##i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec  gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)  || cy: || cyear: 


margins, at(investment_simpler=(-0.4(1.1)4) unionnew=(0 1)) predict(mu fixed) 


gen helpvar2=.15
label define helplabel 1 "|", replace
gen helplabel=1
label values helplabel helplabel


marginsplot, scheme(plottig) recastci(rline) ci1opts(lpattern(dash) lcolor(black)) ///
ci2opts(lpattern(dash) lcolor(gs8)) ///
 plot1opts(lcolor(black)) plot2opts(lcolor(gs8))  title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment-Consumption Position") ///
text(.29 0.4 "Not union") text(.44 0.4 "Union") ///
leg(reg(lp(blank))) recast(line) ///
 addplot(scatter helpvar2 investment_simpler  if e(sample), below  mlabel(helplabel) mlabpos(0) ///
 mlabsize(large) msymbol(i) legend(off) mlabcolor(black) fcolor(gs15) color(gs15) ///
 xscale(range(-.5 4.5) ) xlabel(-.5 (.5) 4.5) yscale(range(.15 .5)) )   

 
 
graph export "Graphs/ess_union_ML_NOPID.png", as(png) width(1920) height(1080) replace

eststo:melogit vote_ml c.investment_simpler c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec  gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 

eststo:melogit vote_ml c.investment_simpler##c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec  gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 


margins, dydx(investment_simpler) at(cosmolib_pos=(-2(.8)4.4)) predict(mu fixed)

marginsplot, scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))  yline(0, lpattern(dash))  title("") ///
ytitle(Marginal Effect of Investment) xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position") leg(reg(lp(blank))) recast(line) 

graph export "Graphs/ess_prof_ML_NOPID.png", as(png) width(1920) height(1080) replace

esttab using "Results/Micro Regression results ML No PID.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	se eqlabels("Variance (Survey)" "Variance (Country)" , none) ///
	mlabel ("Model 1" "Model 2" "Model 3" "Model 4") /// 
	label ///
	varwidth(13)

drop helpvar*  helplabel




*****
	*** ROB CHECK WITH UNION DENSITY
	*** APPENDIX 14
	
	
	
	melogit vote_ml c.investment_simpler##i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)  || cy: || cyear: 

	
	gen sampledata=(e(sample)==1)
bys sampledata cyear: gen aggdata=(_n==1)
sum aggdata if sampledata==1&aggdata==1
	replace aggdata=. if sampledata==0|aggdata==0
	
	centile union_add if aggdata==1, c(25 50 75)
	
	gen uniongroups=0 if union_add<=1.852184
	replace uniongroups=1 if union_add> 1.852184 &union_add!=.
	
	eststo clear
	
	
	
	*** Median SPLIT
eststo:	melogit vote_ml c.investment_simpler##i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)&uniongroups==0   || cyear: 

margins, at(investment_simpler=(-0.4(0.8)3.6) unionnew=(0 1)) predict(mu fixed) 
marginsplot, by(unionnew) scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))    title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment Position") leg(reg(lp(blank))) recast(line) name(A, replace)


eststo:	melogit vote_ml c.investment_simpler##i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)&uniongroups==1   || cyear: 

margins, at(investment_simpler=(-0.4(0.8)3.6) unionnew=(0 1)) predict(mu fixed) 
marginsplot, by(unionnew) scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))    title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment Position") leg(reg(lp(blank))) recast(line) name(B, replace)

graph combine A B, scheme(plottig) col(1)


graph export "Graphs/ess_union_ML_mediansplit.png", as(png) width(1920) height(1080) replace


esttab using "Results/Micro Regression results ML rob by union dens.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	se eqlabels("Variance (Survey)" "Variance (Country-Year)" , none) ///
	mlabel ("Model 1" "Model 2" "Model 3" "Model 4") /// 
	label ///
	varwidth(13)
	


*** ROB CHECK - MAIN RESULTS WITH INCOME
*** APPENDIX 15
eststo clear 


eststo: melogit vote_ml c.investment_simpler i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec income id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)   || cy: || cyear: 

eststo: melogit vote_ml c.investment_simpler##i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec income id_ml gdpchange MLincumbent sdvoteshare_lag ///
[pweight=dweight] if (occupation==8  | occupation==11)  || cy: || cyear: 

*margins, dydx(investment_simpler) at(unionnew=(0 1)) predict(mu fixed) 

margins, at(investment_simpler=(.33 2.03) unionnew=(1)) pwcompare predict(mu fixed)

margins, at(investment_simpler=(-0.4(1.1)4) unionnew=(0 1)) predict(mu fixed) 


gen helpvar2=.23
label define helplabel 1 "|", replace
gen helplabel=1
label values helplabel helplabel


marginsplot, scheme(plottig) recastci(rline) ci1opts(lpattern(dash) lcolor(black)) ///
ci2opts(lpattern(dash) lcolor(gs8)) ///
 plot1opts(lcolor(black)) plot2opts(lcolor(gs8))  title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment-Consumption Position") ///
text(.31 0.4 "Not union") text(.42 0.4 "Union") ///
leg(reg(lp(blank))) recast(line) ///
 addplot(scatter helpvar2 investment_simpler  if e(sample), below  mlabel(helplabel) mlabpos(0) ///
 mlabsize(large) msymbol(i) legend(off) mlabcolor(black) fcolor(gs15) color(gs15) ///
 xscale(range(-.5 4.5) ) xlabel(-.5 (.5) 4.5) yscale(range(.2 .5)) )   

 
graph export "Graphs/ess_union_ML_w income.png", as(png) width(1920) height(1080) replace


tabulate cy essround if e(sample)

eststo:melogit vote_ml c.investment_simpler c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec income id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 

eststo:melogit vote_ml c.investment_simpler##c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec income id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left ///
[pweight=dweight]  if (occupation==1 | occupation==2 | occupation==3 )  || cy: || cyear: 

*margins, at(investment_simpler=(.33 2.03) cosmolib_pos=(-1.14)) pwcompare predict(mu fixed)



gen helpvar=-.05

margins, dydx(investment_simpler) at(cosmolib_pos=(-2(.8)4.4)) predict(mu fixed)

marginsplot, scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))  yline(0, lpattern(dash))  title("") ///
ytitle(Marginal Effect of Investment) xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position") leg(reg(lp(blank))) recast(line) ///
 addplot(scatter helpvar cosmolib_pos  if e(sample), below  mlabel(helplabel) mlabsize(large) legend(off) fcolor(gs15) color(gs15) xscale(range(-3 5) ) yscale(range(-.06 .06)) )   

graph export "Graphs/ess_prof_ML_w income.png", as(png) width(1920) height(1080) replace

tabulate cy essround if e(sample)


esttab using "Results/Micro Regression results ML_w income.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	se eqlabels("Variance (Survey)" "Variance (Country)" , none) ///
	mlabel ("Model 1" "Model 2" "Model 3" "Model 4") /// 
	label ///
	varwidth(13)
	
	drop helpvar* helplabel	
	


*** ROBUSTNESS: HIGH AND LOW INCOME GROUPS	
eststo clear 


eststo: melogit vote_ml c.investment_simpler i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec income id_ml gdpchange MLincumbent sdvoteshare_lag i.occupation ///
[pweight=dweight] if income<6  || cy: || cyear: 

eststo: melogit vote_ml c.investment_simpler##i.unionnew c.cosmolib_pos market right_inv_simpler_left  rural edulvla c.agea##c.agea ///
lrscale gndr rlgatnd_rec polintr_rec income id_ml gdpchange MLincumbent sdvoteshare_lag i.occupation ///
[pweight=dweight] if income<6  || cy: || cyear: 

*margins, dydx(investment_simpler) at(unionnew=(0 1)) predict(mu fixed) 

margins, at(investment_simpler=(-0.4(1.1)4) unionnew=(0 1)) predict(mu fixed) 


gen helpvar2=.23
label define helplabel 1 "|", replace
gen helplabel=1
label values helplabel helplabel


marginsplot, scheme(plottig) recastci(rline) ci1opts(lpattern(dash) lcolor(black)) ///
ci2opts(lpattern(dash) lcolor(gs8)) ///
 plot1opts(lcolor(black)) plot2opts(lcolor(gs8))  title("") ///
ytitle(Predicted Probability SD Vote)  xtitle("Investment-Consumption Position") ///
text(.31 0.4 "Not union") text(.42 0.4 "Union") ///
leg(reg(lp(blank))) recast(line) ///
 addplot(scatter helpvar2 investment_simpler  if e(sample), below  mlabel(helplabel) mlabpos(0) ///
 mlabsize(large) msymbol(i) legend(off) mlabcolor(black) fcolor(gs15) color(gs15) ///
 xscale(range(-.5 4.5) ) xlabel(-.5 (.5) 4.5) yscale(range(.2 .5)) )   

 
graph export "Graphs/ess_union_ML_income groups.png", as(png) width(1920) height(1080) replace


tabulate cy essround if e(sample)

eststo:melogit vote_ml c.investment_simpler c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec income id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left i.occupation ///
[pweight=dweight]  if income>=6&income<.  || cy: || cyear: 

eststo:melogit vote_ml c.investment_simpler##c.cosmolib_pos i.unionnew market edulvla c.agea##c.agea rural /// 
lrscale gndr rlgatnd_rec polintr_rec income id_ml gdpchange MLincumbent sdvoteshare_lag right_inv_simpler_left i.occupation ///
[pweight=dweight]  if income>=6&income<. || cy: || cyear: 


gen helpvar=-.05

margins, dydx(investment_simpler) at(cosmolib_pos=(-2(.8)4.4)) predict(mu fixed)

marginsplot, scheme(plottig) recastci(rline) ciopts(lpattern(dash) lcolor(black))  yline(0, lpattern(dash))  title("") ///
ytitle(Marginal Effect of Investment) xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position") leg(reg(lp(blank))) recast(line) ///
 addplot(scatter helpvar cosmolib_pos  if e(sample), below  mlabel(helplabel) mlabsize(large) legend(off) fcolor(gs15) color(gs15) xscale(range(-3 5) ) yscale(range(-.06 .06)) )   

graph export "Graphs/ess_prof_ML_income groups.png", as(png) width(1920) height(1080) replace

tabulate cy essround if e(sample)


esttab using "Results/Micro Regression results ML_w income high low groups.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	se eqlabels("Variance (Survey)" "Variance (Country)" , none) ///
	mlabel ("Model 1" "Model 2" "Model 3" "Model 4") /// 
	label ///
	varwidth(13)
	
	drop helpvar* helplabel	
	
	
	
	
	
	
	