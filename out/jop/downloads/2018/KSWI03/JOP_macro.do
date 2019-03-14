

*global DATADIR  "Y:\Kritzinger\Markus\balancing\" 
*global DATADIR  "C:\Users\chadi\Dropbox\Balancing"
*global DATADIR  "C:\Users\Tarik\Dropbox\Balancing" 
global DATADIR  "C:\Users\MarkusWagner\Dropbox\Balancing" 

cd "$DATADIR"

use "Data\Macro_JOP_ACW.dta", clear



***********************
*MAIN RESULTS*
**********************
***TABLE 1 Models 2, 4, 6***
eststo clear

eststo: cgmreg pervote lpervote investment_simpler union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help

collin lpervote investment_simpler union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent




eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help

eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market  /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help


esttab using "Results/Macro Regression results.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)

	
 
********************
******** PARSIMONIOUS MODELS (MODELS 1, 3, 5)
********************
 
eststo clear
eststo: cgmreg pervote lpervote investment_simpler union_add cosmolib_pos ///
incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help

eststo:  cgmreg pervote lpervote c.investment_simpler##c.union_add cosmolib_pos ///
incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help

eststo:  cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add  ///
incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help


esttab using "Results/Macro Regression results parsimonious.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)

**** FIGURE 1
	
eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )   
  
 graph export "Graphs\main_macro_unioninteraction.png", as(png) width(1920) height(1080) replace
 
 **** FIGURE 2
 
eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market  /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) )

 graph export "Graphs\main_macro_cosmolibnteraction.png", as(png) width(1920) height(1080) replace
 
 
**Descriptives Table A16.1
 
 eststo clear
cgmreg pervote lpervote investment_simpler union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

egen missing=rowmiss(pervote lpervote investment_simpler union_add right_inv_simpler_left ///
market cosmolib_pos  deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent) ///
 if year>=1975  & oecdmember==10 & mainstreamL==1

estpost summarize pervote  lpervote investment_simpler union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent if missing==0 

esttab using "Results/Macro Descr.rtf", cells("count mean sd min max") noobs rtf replace

 
 
*Face Validity*
*** FIGURE A2.1
graph hbox investment_simpler if year>=1975  & oecdmember==10 & ///
(parfam==10|parfam==20 | parfam==30 | parfam==40 | parfam==50 | parfam==60| parfam==70| parfam==80), over(parfam) ytitle("Investment-consumption position") scheme(plottig)



  graph export "Graphs\app_investment_families.png", as(png) width(1920) height(1080) replace

  
  *** FIGURE A2.2
graph box investment_simpler if oecdmember==10 & ///
mainstreamL==1, by(decade) ytitle("Investment-consumption position") scheme(plottig)

  graph export "Graphs\app_investment_prepost92.png", as(png) width(1920) height(1080)  replace


bys decade country: egen mean_inv_simp=mean(investment_simpler) if mainstreamL==1 & oecdmember==10
bys decade country: egen mean_cosmolib=mean(cosmolib_pos) if mainstreamL==1 & oecdmember==10


ttest investment_simpler if oecdmember==10 & mainstreamL==1, by(decade)


*** Figure A3.1
eststo clear
eststo: cgmreg pervote lpervote c.investment_short##c.union_add right_inv_simpler_left_short cosmolib_pos market ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_short) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-2 0 2 4) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-3 6))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
 addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-3 6)) )   

 
 graph export "Graphs\app_inv_short_union.png", as(png) width(1920) height(1080) replace

*** Figure A3.2
 
eststo: cgmreg pervote lpervote c.investment_short##c.cosmolib_pos union_add right_inv_simpler_left_short market /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_short) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 8)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-5 8)) ylabel(-6 (2)8) )


 graph export "Graphs\app_inv_short_cosmolib.png", as(png) width(1920) height(1080) replace

*** Table A3.1

esttab using "Results\Macro Regression results Short Scale.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2") /// 
	label ///
	varwidth(13)
 

*** Table A3.2

eststo clear
eststo: cgmreg pervote lpervote investment_simpler_plus507 union_add right_inv_simpler_left_plus507 market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_simpler_plus507##c.union_add right_inv_simpler_left_plus507 market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_simpler_plus507##c.cosmolib_pos union_add right_inv_simpler_left_plus507 market  /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)


esttab using "Results/Macro Regression results Plus 507.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)

*** Figure A3.3

eststo: cgmreg pervote lpervote c.investment_simpler_plus507##c.union_add right_inv_simpler_left_plus507 market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )   
  
 graph export "Graphs\app_unioninteraction_plus507.png", as(png) width(1920) height(1080) replace

*** Figure A3.4 
 
eststo: cgmreg pervote lpervote c.investment_simpler_plus507##c.cosmolib_pos union_add right_inv_simpler_left_plus507 market  /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) )

 graph export "Graphs\app_cosmolibnteraction_plus507.png", as(png) width(1920) height(1080) replace

***********************
*ROBUSTNESS: Salience
**********************

*** Table A3.3

eststo clear
eststo: cgmreg pervote lpervote investment_salience consumption_salience union_add right_inv_salience_left right_cons_salience_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_salience##c.union_add c.consumption_salience##c.union_add   right_inv_salience_left right_cons_salience_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_salience##c.cosmolib_pos c.consumption_salience##c.cosmolib_pos union_add right_inv_salience_left right_cons_salience_left market /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)




esttab using "Results/Macro Regression results Salience.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)

*** Figure A3.5
	

eststo: cgmreg pervote lpervote c.log_inv_sal##c.union_add c.log_con_sal##c.union_add  right_inv_salience_left right_cons_salience_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(log_inv_sal) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-2 (.5) 2) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-2 2))  ///
 ytitle("Marginal effect of investment salience" "on predicted vote share") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-1 2)) ) name(A, replace)  

eststo: cgmreg pervote lpervote c.log_inv_sal##c.union_add c.log_con_sal##c.union_add  right_inv_salience_left right_cons_salience_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(log_con_sal) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-2 (.5) 2) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-2 2))  ///
 ytitle("Marginal effect of consumption salience" "on predicted vote share") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-1 2)) ) name(B, replace)   

graph combine A B, scheme(plottig) rows(2)
  
 graph export "Graphs\main_macro_unioninteraction_salience.png", as(png) width(1920) height(1080) replace

 
*** Figure A3.6 
 
eststo: cgmreg pervote lpervote c.log_inv_sal##c.cosmolib_pos c.log_con_sal##c.cosmolib_pos union_add right_inv_salience_left right_cons_salience_left market /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(log_inv_sal) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position")  xlabel(-4(1)4)  ///
ytitle("Marginal effect of investment salience" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15)  ) name(A, replace)

eststo: cgmreg pervote lpervote c.log_inv_sal##c.cosmolib_pos c.log_con_sal##c.cosmolib_pos union_add right_inv_salience_left right_cons_salience_left market /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(log_con_sal) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position")  xlabel(-4(1)4)  ///
ytitle("Marginal effect of consumption salience" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15)  ) name(B, replace)

graph combine A B, scheme(plottig) rows(2)

 graph export "Graphs\main_macro_cosmolibnteraction_salience.png", as(png) width(1920) height(1080) replace 
 
 
 ********************
 ********* ROB CHECK: DIFF INVESTMENT MEASURES
 ********************

***  Figure A4.1 & Figure A4.2 
 
gen investment_simpler2=log(abs_per407+abs_per411+abs_per506+0.5)- ///
log(abs_per406+abs_per409+abs_per412+abs_per701+0.5)

gen investment_simpler_mainr2=.
replace investment_simpler_mainr2=investment_simpler if mainstreamR==1
bys year country: egen right_inv_simpler_left2=min(investment_simpler_mainr2)

cgmreg pervote lpervote c.investment_simpler2##c.union_add right_inv_simpler_left2 cosmolib_pos ///
deindust market radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler2) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A1, replace) 
  
cgmreg pervote lpervote c.investment_simpler2##c.cosmolib_pos union_add right_inv_simpler_left2  /// 
radright_pres_parlgov market  radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler2) at (cosmolib_pos=(-3(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("2nd-dim. position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B1, replace)

gen investment_simpler3=log(abs_per402+abs_per411+abs_per506+0.5)- ///
log(abs_per406+abs_per409+abs_per412+abs_per701+0.5)

gen investment_simpler_mainr3=.
replace investment_simpler_mainr3=investment_simpler if mainstreamR==1
bys year country: egen right_inv_simpler_left3=min(investment_simpler_mainr3)

cgmreg pervote lpervote c.investment_simpler3##c.union_add right_inv_simpler_left3 cosmolib_pos ///
deindust market  radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.country ///
if year>=1980  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler3) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A2, replace)

cgmreg pervote lpervote c.investment_simpler3##c.cosmolib_pos union_add right_inv_simpler_left3  /// 
radright_pres_parlgov market  radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler3) at (cosmolib_pos=(-3(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("2nd-dim. position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B2, replace)


gen investment_simpler4=log(abs_per402+abs_per407+abs_per506+0.5)- ///
log(abs_per406+abs_per409+abs_per412+abs_per701+0.5)

gen investment_simpler_mainr4=.
replace investment_simpler_mainr4=investment_simpler if mainstreamR==1
bys year country: egen right_inv_simpler_left4=min(investment_simpler_mainr4)

cgmreg pervote lpervote c.investment_simpler4##c.union_add right_inv_simpler_left4 cosmolib_pos ///
deindust radright_pres_parlgov market  radleft_pres_parlgov unemp growth incumbent i.country ///
if year>=1980  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler4) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A3, replace)

cgmreg pervote lpervote c.investment_simpler4##c.cosmolib_pos union_add right_inv_simpler_left4  /// 
radright_pres_parlgov radleft_pres_parlgov market unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler4) at (cosmolib_pos=(-3(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("2nd-dim. position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B3, replace) 


gen investment_simpler5=log(abs_per402+abs_per407+abs_per411+0.5)- ///
log(abs_per406+abs_per409+abs_per412+abs_per701+0.5)

gen investment_simpler_mainr5=.
replace investment_simpler_mainr5=investment_simpler if mainstreamR==1
bys year country: egen right_inv_simpler_left5=min(investment_simpler_mainr5)

cgmreg pervote lpervote c.investment_simpler5##c.union_add right_inv_simpler_left5 cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov market unemp growth incumbent i.country ///
if year>=1980  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler5) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A4, replace)

cgmreg pervote lpervote c.investment_simpler5##c.cosmolib_pos union_add right_inv_simpler_left5  /// 
radright_pres_parlgov radleft_pres_parlgov unemp market growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler5) at (cosmolib_pos=(-3(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("2nd-dim. position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B4, replace)


gen investment_simpler6=log(abs_per402+abs_per407+abs_per411+per506+0.5)- ///
log(abs_per409+abs_per412+abs_per701+0.5)

gen investment_simpler_mainr6=.
replace investment_simpler_mainr6=investment_simpler if mainstreamR==1
bys year country: egen right_inv_simpler_left6=min(investment_simpler_mainr6)

cgmreg pervote lpervote c.investment_simpler6##c.union_add right_inv_simpler_left6 cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov market  unemp growth incumbent i.country ///
if year>=1980  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler6) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A5, replace)

cgmreg pervote lpervote c.investment_simpler6##c.cosmolib_pos union_add right_inv_simpler_left6  /// 
radright_pres_parlgov radleft_pres_parlgov unemp market growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler6) at (cosmolib_pos=(-3(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("2nd-dim. position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B5, replace)


gen investment_simpler7=log(abs_per402+abs_per407+abs_per411+per506+0.5)- ///
log(abs_per406+abs_per412+abs_per701+0.5)

gen investment_simpler_mainr7=.
replace investment_simpler_mainr7=investment_simpler if mainstreamR==1
bys year country: egen right_inv_simpler_left7=min(investment_simpler_mainr7)

cgmreg pervote lpervote c.investment_simpler7##c.union_add right_inv_simpler_left7 cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov market unemp growth incumbent i.country ///
if year>=1980  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler7) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A6, replace)

cgmreg pervote lpervote c.investment_simpler7##c.cosmolib_pos union_add right_inv_simpler_left7  /// 
radright_pres_parlgov radleft_pres_parlgov market unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler7) at (cosmolib_pos=(-3(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("2nd-dim. position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B6, replace) 


gen investment_simpler8=log(abs_per402+abs_per407+abs_per411+per506+0.5)- ///
log(abs_per406+abs_per409+abs_per701+0.5)

gen investment_simpler_mainr8=.
replace investment_simpler_mainr8=investment_simpler if mainstreamR==1
bys year country: egen right_inv_simpler_left8=min(investment_simpler_mainr8)

cgmreg pervote lpervote c.investment_simpler8##c.union_add right_inv_simpler_left8 cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov market  unemp growth incumbent i.country ///
if year>=1980  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler8) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A7, replace)

cgmreg pervote lpervote c.investment_simpler8##c.cosmolib_pos union_add right_inv_simpler_left8  /// 
radright_pres_parlgov radleft_pres_parlgov market  unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler8) at (cosmolib_pos=(-3(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("2nd-dim. position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B7, replace)


gen investment_simpler9=log(abs_per402+abs_per407+abs_per411+per506+0.5)- ///
log(abs_per406+abs_per409+abs_per412+0.5)

gen investment_simpler_mainr9=.
replace investment_simpler_mainr9=investment_simpler if mainstreamR==1
bys year country: egen right_inv_simpler_left9=min(investment_simpler_mainr9)

cgmreg pervote lpervote c.investment_simpler9##c.union_add right_inv_simpler_left9 cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov market  unemp growth incumbent i.country ///
if year>=1980  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler9) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A8, replace)

cgmreg pervote lpervote c.investment_simpler9##c.cosmolib_pos union_add right_inv_simpler_left9  /// 
radright_pres_parlgov radleft_pres_parlgov market  unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler9) at (cosmolib_pos=(-3(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("2nd-dim. position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B8, replace)

 
 
graph combine A1 A2 A3 A4 A5 A6 A7 A8 , scheme(plottig) 
  
 graph export "Graphs\app_oneout_union.png", as(png) width(1920) height(1080) replace
 
 
graph combine B1 B2 B3 B4 B5 B6 B7 B8 , scheme(plottig) 
  
 graph export "Graphs\app_oneout_cosmolib.png", as(png) width(1920) height(1080) replace
  

*** Figure A5.1 

graph hbox cosmolib_pos if year>=1975  & oecdmember==10 & ///
(parfam==10|parfam==20 | parfam==30 | parfam==40 | parfam==50 | parfam==60| parfam==70| parfam==80), ///
over(parfam) ytitle("Libertarian/Cosmopolitan vs." ///
"Authoritarian/Nationalist  position") scheme(plottig)

graph export "Graphs\app_cosmolib_families_RR2.png", as(png) width(1920) height(1080) replace

*** Figure A5.2 

graph twoway scatter cosmolib investment_simpler if year>=1975  & oecdmember==10& mainstreamL==1, ///
xtitle("Investment-Consumption Position") ///
ytitle("Libertarian/Cosmopolitan vs." ///
"Authoritarian/Nationalist position") ///
xscale(range(-6 7)) yscale(range(-6 7)) ///
xlabel(-6(1)7) ylabel(-6(1)7) ///
aspectratio(1)  
 
graph export "Graphs\scatter_cosmolib_investment.png", as(png) width(1920) height(1080) replace

*** Figure A5.3
 
sort country year
 foreach c in 11 12 13 14  22 23 31 32 33 34 35 41 42 43 51 53 {
gen y=5
 gen x=0
 graph twoway (scatter cosmolib investment_simpler ///
if oecdmember==10 & mainstreamL==1 &year>=1975&country==`c') /// 
(scatter y x if oecdmember==10 & ///
mainstreamL==1 &year>=1975&country==`c', mlab(country) mlabc(black) msymbol(i) mlabpos(0)), ///
xtitle("Investment-Consumption Position") ///
ytitle("Libertarian/Cosmopolitan vs." ///
"Authoritarian/Nationalist position") ///
xscale(range(-6 7)) yscale(range(-6 7)) ///
xlabel(-6(1)7) ylabel(-6(1)7) ///
 aspectratio(1)  title(Country `c') legend(off) ///
  name(G`c', replace)
  drop y x
 }
*
graph combine G11 G12 G13 G14 G22 G23 G31 G32 G33 G34 G35 G41 G42 G43 G51 G53, scheme(plottig) 
 
 
 graph export "Graphs\app_cosmo_invcon_bycountry.png", as(png) width(1920) height(1080) replace


*** Figure A5.4  
 
	eststo clear
	eststo: cgmreg pervote lpervote investment_simpler union_add market right_inv_simpler_left libauth_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add market right_inv_simpler_left libauth_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.1) 2.8))
marginsplot,  title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10)) ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
 addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  


 graph export "Graphs\app_libauth_union.png", as(png) width(1920) height(1080) replace
 
 
*** Figure A5.5   
 
eststo: cgmreg pervote lpervote c.investment_simpler##c.libauth_pos union_add market right_inv_simpler_left  /// 
radright_pres_parlgov radleft_pres_parlgov unemp deindust growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (libauth_pos=(-4(0.1)4.3))
marginsplot,    title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Cosmopolitan position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist libauth_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) )


 graph export "Graphs\app_libauth.png", as(png) width(1920) height(1080) replace
 
*** Table A5.1  

 
esttab using "Results\Macro Regression results Robustness Simpler Cosmolib.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)

	
********************
********* Jackknife
********************

*** Figure A6.1
 
 foreach c in 11 12 13 14   22 23 31 32 33 34 35 41 42 43 51 53 {
 
	cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left cosmolib_pos market ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if country != `c' & year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10)) ///
 ytitle("Marginal effect") title("w/o Country `c'") ///
 name(G`c', replace)
 
}
*
graph combine G11 G12 G13 G14   G22 G23 G31 G32 G33 G34 G35 G41 G42 G43 G51 G53, scheme(plottig) 
 
 
 graph export "Graphs\app_jackknife_union.png", as(png) width(1920) height(1080) replace

*** Figure A6.2 
 
 
 foreach c in 11 12 13 14   22 23 31 32 33 34 35 41 42 43 51 53 {
 
	cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if country != `c' & year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Lib vs. Auth position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect") ///
name(G`c', replace) title("w/o Country `c'")

}
*
graph combine G11 G12 G13 G14   G22 G23 G31 G32 G33 G34 G35 G41 G42 G43 G51 G53, scheme(plottig)  
 
 
 graph export "Graphs\app_jackknife_cosmolib.png", as(png) width(1920) height(1080) replace

 
 
***********************
*REDUCED TIME PERIOD
**********************

***Table A6.1 
eststo clear
eststo: cgmreg pervote lpervote investment_simpler union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1990  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1990  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market  /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1990  & oecdmember==10 & mainstreamL==1, cl(party date)


***Figure A6.3 

esttab using "Results/Macro Regression results Since 1990.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)


eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1990  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )   
  
 graph export "Graphs\main_macro_unioninteraction_since1990.png", as(png) width(1920) height(1080) replace
 
***Figure A6.4  
 
eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market  /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent i.party ///
if year>=1990  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) )

 graph export "Graphs\main_macro_cosmolibinteraction_since1990.png", as(png) width(1920) height(1080) replace
 



*** Figure A7.1

sort country year
 foreach c in 11 12 13 14  22 23 31 32 33 34 35 41 42 43 51 53 {
 gen y=2.9
 gen x=1995
graph twoway (scatter union_add year if oecdmember==10 & mainstreamL==1 &year>=1975&country==`c') ///
 (scatter y x if oecdmember==10 & mainstreamL==1 &year>=1975&country==`c', mlab(country) mlabc(black) msymbol(i) mlabpos(0)), ///
xtitle("Year") ///
ytitle("Union influence") ///
xscale(range(1975 2015)) yscale(range(1 3)) ///
xlabel(1975(5)2015) ylabel(1(.5)3) title(Country `c') legend(off) ///
  name(G`c', replace)
 drop y x
}
*
graph combine G11 G12 G13 G14 G22 G23 G31 G32 G33 G34 G35 G41 G42 G43 G51 G53, scheme(plottig) 
 
 
 graph export "Graphs\app_union_time.png", as(png) width(1920) height(1080) replace
 
*** Figure A7.2
 
graph twoway scatter union_add investment_simpler if oecdmember==10 & mainstreamL==1 , ///
xtitle("Investment-Consumption Position") ///
ytitle("Union influence") ///
xscale(range(-2 5.5)) yscale(range(1 3)) ///
xlabel(-2(.5)5.5) ylabel(1(.5)3) ///
 aspectratio(1)

graph export "Graphs\scatter_union_investment.png", as(png) width(1920) height(1080) replace
 

***Figure A7.3
 
eststo clear

eststo: cgmreg pervote lpervote c.investment_simpler##c.ud_share right_inv_simpler_left cosmolib_pos market ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(ud_share=(0.07 (0.01) 0.87))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence: UD_SHARE ") xlabel(0 (.1) 1) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
 addplot(hist ud_share if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8) ) ) name(A, replace)  

eststo: cgmreg pervote lpervote c.investment_simpler##c.coord_share right_inv_simpler_left cosmolib_pos market ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(coord_share=(0 (0.01) 1))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence: COORD_SHARE") xlabel(0 1) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
 addplot(hist coord_share if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) ) name(B, replace)  
 
graph combine A B, scheme(plottig)
 
 graph export "Graphs\app_disaggregatedunion.png", as(png) width(1920) height(1080) replace

***Table A7.1 
 
 eststo: cgmreg pervote lpervote c.investment_simpler##c.un_left right_inv_simpler_left cosmolib_pos market ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)


 eststo: cgmreg pervote lpervote c.investment_simpler##c.ud_share c.investment_simpler##c.coord_share c.investment_simpler##c.un_left right_inv_simpler_left cosmolib_pos market ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
 

esttab using "Results\Macro Regression results Disagg Union.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)
 

*** Figure A8.1 

eststo clear
eststo: cgmreg pervote lpervote investment_simpler union_add right_inv_simpler_left cosmolib_pos market ///
deindust rrvote rlvote unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left cosmolib_pos market ///
deindust rrvote rlvote unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
 addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A, replace) 


eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market  /// 
rrvote rlvote  unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Authoritarian/Nationalist vs. Libertarian/Cosmpolitan position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B, replace)

graph combine A B, scheme(plottig)


 graph export "Graphs\app_voteshares.png", as(png) width(1920) height(1080) replace
 
*** Table A8.1 

esttab using "Results\Macro Regression results Robustness Niche vote shares.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)

	
********************
******** Green parties
********************

*** Table A8.2

eststo clear

eststo: cgmreg pervote lpervote investment_simpler union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov green_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help

collin lpervote investment_simpler union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov   unemp growth incumbent




eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov green_pres_parlgov  unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help

eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market  /// 
radright_pres_parlgov radleft_pres_parlgov green_pres_parlgov  unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

predict r2help if e(sample) 
corr pervote r2help if e(sample) 
di r(rho)^2
drop r2help


esttab using "Results/Macro Regression results w Green parties.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)

*** Figure A8.2
	
eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left market cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov green_pres_parlgov  unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )   
  
 graph export "Graphs\main_macro_unioninteraction Greens.png", as(png) width(1920) height(1080) replace

*** Figure A8.3
 
eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market  /// 
radright_pres_parlgov radleft_pres_parlgov green_pres_parlgov  unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) )

 graph export "Graphs\main_macro_cosmolibnteraction Greens.png", as(png) width(1920) height(1080) replace
 

eststo clear
eststo: cgmreg pervote lpervote investment_simpler union_add right_inv_simpler_left cosmolib_pos market ///
deindust rrvote rlvote grnvote unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left cosmolib_pos market ///
deindust rrvote rlvote grnvote unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
 addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  name(A, replace) 


eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left market  /// 
rrvote rlvote grnvote  unemp growth deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Authoritarian/Nationalist vs. Libertarian/Cosmpolitan position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) name(B, replace)

graph combine A B, scheme(plottig)


 graph export "Graphs\app_voteshares_greens.png", as(png) width(1920) height(1080) replace
 

esttab using "Results\Macro Regression results Robustness Green vote shares.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)
	

	
*** Figure A9.1
eststo clear

eststo: cgmreg pervote lpervote c.rile_nocosmolib_pos c.union_add right_inv_simpler_left  cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)

eststo: cgmreg pervote lpervote c.rile_nocosmolib_pos##c.union_add right_inv_simpler_left  cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(rile) at(union_add=(1.2 (0.1) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 (2) 20) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10))  ///
 ytitle("Marginal effect of left-right position" "on predicted vote share") ///
 addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )   ///
    name(A,replace)

eststo: cgmreg pervote lpervote c.rile_nocosmolib_pos##c.cosmolib_pos union_add right_inv_simpler_left  /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth  deindust incumbent i.party ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(rile) at (cosmolib_pos=(-4(0.1)4))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Libertarian/Cosmopolitan vs. Authoritarian/Nationalist position")  xlabel(-4(1)4) ylabel(-4 (2)20) yscale(range(-5 10)) ///
ytitle("Marginal effect of left-right position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) ) ///
name(B,replace) 

	graph combine A B, scheme(plottig)
 
graph export "Graphs\rile_robustness.png", as(png) width(1920) height(1080) replace

*** Table A9.1

esttab using "Results\Macro Regression results Robustness Rile.rtf", replace ///
	 ///
	scalars(ll) ///
	nogaps se ///
	mlabel ("Model 1" "Model 2" "Model 3") /// 
	label ///
	varwidth(13)


	
	
 

	
********************
 ******** No fixed effects (referred to in text)
 ********************
 
 eststo: cgmreg pervote lpervote c.investment_simpler##c.union_add right_inv_simpler_left cosmolib_pos ///
deindust radright_pres_parlgov radleft_pres_parlgov unemp growth incumbent  ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at(union_add=(1.2 (0.01) 2.8))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) xtitle("Union influence") xlabel(1 1.5 2 2.5 3) ylabel(-4 -2 0 2 4 6) ///
 recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black)) yscale(range(-5 10)) ///
 ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
 addplot(hist union_add if e(sample), below legend(off) fcolor(gs15) color(gs15) yscale(range(-5 8)) )  
 
 
 
eststo: cgmreg pervote lpervote c.investment_simpler##c.cosmolib_pos union_add right_inv_simpler_left  /// 
radright_pres_parlgov radleft_pres_parlgov unemp growth deindust incumbent  ///
if year>=1975  & oecdmember==10 & mainstreamL==1, cl(party date)
margins, dydx(investment_simpler) at (cosmolib_pos=(-4(0.1)4.3))
marginsplot, scheme(plottig)   title("") yline(0) leg(reg(lp(blank))) recast(line) recastci(rline)  ciopts(lpattern(dash) lcolor(black))  ///
xtitle("Authoritarian/Nationalist vs. Libertarian/Cosmpolitan position")  xlabel(-4(1)4) ylabel(-4 -2 0 2 4 6) yscale(range(-5 10)) ///
ytitle("Marginal effect of investment-consumption position" "on predicted vote share") ///
addplot(hist cosmolib_pos if e(sample), below legend(off) bin(250) freq fcolor(gs15) color(gs15) yscale(range(-8 10)) ylabel(-6 (2)8) )

 
	


 
 

 

 
 
 
   

 


 
 
 

 
 
 
 
 
 
