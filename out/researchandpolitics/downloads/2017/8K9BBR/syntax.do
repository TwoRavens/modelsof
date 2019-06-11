***HEADER**********************************************************

clear matrix
set more off
cap ssc install cibar

cap cd "***Set working directory here***"

cap log close
cap log using syntax.log, replace

use data, clear

***ANALYSIS*************************************************************

//Figure 1

xi: logit clicked i.condition voted dem rep q_age, r
coefplot, drop(_I* _cons) xline(1) eform xtitle(" " "Click rate (odds ratio)") ///
	mlabel format(%9.2f) mlabposition(12) mlabgap(*2) graphr(c(white))
graph export "fig1.png", replace

//Figure 2

cibar clicked, over1(condition) ///
	barg(4) barc(gs1 gs7 gs7 gs7) ciopts(lc(gs10) lp(dash)) ///
	gr(yti("Click rate (proportion)" " ") ysc(r(0 0.03)) ylab(0(0.01)0.03) ///
	xlab(1 "Neither" 2 "Identity" 3 "Gratitude" 4 "Both") ///
	graphr(c(white)) leg(off))
graph export "fig2.png", replace

logit clicked identity gratitude both voted, r


***SUPPLEMENTAL INFORMATION*************************************************************

//Table S1: Summary statistics

summarize voted dem rep q_age male

//Figure S1: Sensitivity analysis for Figure 1

eststo fig1: xi: logit clicked i.condition voted dem rep q_age, r
eststo fig1_gender: xi: logit clicked i.condition voted dem rep q_age male, r
coefplot (fig1,label(without gender) msiz(small)) ///
		 (fig1_gender,label(with gender) m(triangle) msiz(small)), ///
		 drop(_I* _cons) xline(1) eform xtitle(" " "Click rate (odds ratio)") ///
		 mlabel format(%9.2f) mlabposition(12) mlabgap(*2) graphr(c(white))
graph export "figS1.png", replace
eststo clear

//Figure S2: Balance test

forvalues c = 2/4 {
	recode condition (1=`c')(`c'=1), gen(condition`c')
}
	
eststo balance12: mlogit condition voted dem rep q_age male, b(2) r rrr
eststo balance13: mlogit condition voted dem rep q_age male, b(3) r rrr
eststo balance14: mlogit condition voted dem rep q_age male, b(4) r rrr
eststo balance23: mlogit condition2 voted dem rep q_age male, b(3) r rrr
eststo balance24: mlogit condition2 voted dem rep q_age male, b(4) r rrr
eststo balance34: mlogit condition3 voted dem rep q_age male, b(4) r rrr

coefplot(balance12,label(Neither vs. Identity) ciop(lc(gs0)) mc(gs0)) ///
		(balance13,label(Neither vs. Gratitude) ciop(lc(gs2)) mc(gs2)) ///
		(balance14,label(Neither vs. Both) ciop(lc(gs4)) mc(gs4)) ///
		(balance23,label(Identity vs. Gratitude) ciop(lc(gs6)) mc(gs6)) ///
		(balance24,label(Identity vs. Both) ciop(lc(gs8)) mc(gs8)) ///
		(balance34,label(Gratitude vs. Both) ciop(lc(gs10)) mc(gs10)), ///
		drop(_cons) xline(1) eform xtitle(Odds ratio) legend(cols(1) ring(0) pos(5) ///
		bm(none) m(zero) si(small)) graphr(c(white))
graph export "figS2.png", replace
eststo clear

//Figure S3: Sensitivity analysis for covariate adjustment

eststo noadjust: logit clicked identity gratitude both, r // without adjustment
eststo adjust: logit clicked identity gratitude both voted, r // with adjustment

coefplot (noadjust,label(No adjustment)) (adjust,label(Adjustment)), ///
	drop(voted _cons) xline(1) eform xtitle(Odds ratio) legend(cols(1) ring(0) pos(3) ///
	bm(none) m(zero) si(small)) graphr(c(white))
graph export "figS3.png", replace
eststo clear

//Table S2: Heterogeneous effects by primary voter

eststo: logit clicked identity##i.voted gratitude both dem rep q_age male, r
estadd local controls "Yes"
estadd local cfx "Yes"
	margins, dydx(identity) over(voted)

eststo: logit clicked identity gratitude##i.voted both dem rep q_age male, r
estadd local controls "Yes"
estadd local cfx "Yes"
	margins, dydx(gratitude) over(voted)

eststo: logit clicked identity gratitude both##i.voted dem rep q_age male, r
estadd local controls "Yes"
estadd local cfx "Yes"
	margins, dydx(both) over(voted)

esttab using "tabS2.rtf", replace compress onecell label se pr2 ///
	drop(identity gratitude both male dem rep q_age _cons) nobaselevels ///
	scalar("controls Controls" "cfx Condition-FE") ///
	rename(1.gratitude#1.voted "Interaction", 1.identity#1.voted "Interaction", 1.both#1.voted "Interaction", ///
		  1.identity "Treatment", 1.gratitude "Treatment", 1.both "Treatment") ///
	mtitles ("Identity" "Gratitude" "Both")	
eststo clear

cap log close
