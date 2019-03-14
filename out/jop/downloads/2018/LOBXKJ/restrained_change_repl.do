
* Replication syntax for "Restrained Change: Party Systems in Times of Economic Crisis"
* by Fernando Casal Bértoa and Till Weber, published in The Journal of Politics
* This file January 14, 2018


clear all
use restrained_change_repl


* Table App1

bysort crisis: tabstat restraint_pre, by(country) format(%9.2fc)


* Figure App1

hist volatility, percent xlab(0(10)60, labs(5)) ylab(0(5)20, labs(5) gsty(major) gmax) /*
*/ xti(Volatility, size(6)) xsca(titlegap(2)) yti(Percent of elections, size(6)) ysca(titlegap(2)) /*
*/ ysc(noli) xsc(noli) graphr(fcol(white)) col(gray) bin(25)

hist fragmentation, percent xlab(0(2)13, labs(5)) ylab(0(5)20, labs(5) gsty(major) gmax) /*
*/ xti(Fragmentation, size(6)) xsca(titlegap(2)) yti(Percent of elections, size(6)) ysca(titlegap(2)) /*
*/ ysc(noli) xsc(noli) graphr(fcol(white)) col(gray) bin(25)

hist polarization, percent xlab(0(10)60, labs(5)) ylab(0(5)20, labs(5) gsty(major) gmax) /*
*/ xti(Polarization, size(6)) xsca(titlegap(2)) yti(Percent of elections, size(6)) ysca(titlegap(2)) /*
*/ ysc(noli) xsc(noli) graphr(fcol(white)) col(gray) bin(25)

hist closure, percent xlab(50(10)100, labs(5)) ylab(0(5)20, labs(5) gsty(major) gmax) /*
*/ xti(Closure, size(6)) xsca(titlegap(2)) yti(Percent of elections, size(6)) ysca(titlegap(2)) /*
*/ ysc(noli) xsc(noli) graphr(fcol(white)) col(gray) bin(25)


* Table App2

factor volatility fragmentation polarization closure
predict restraint, regress
replace restraint = restraint*-1


* Table 1

eststo clear
foreach var of varl volatility fragmentation polarization closure {
	eststo `var': qui cgmreg `var'_diff if postcrisis==1, cl(country crisis)
}
estout using Table1.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(N, f(0)) replace


* Table 2

eststo clear
foreach var of varl volatility fragmentation polarization closure {
	eststo `var': qui cgmreg `var'_diff growth_post restraint_pre if postcrisis==1, cl(country crisis)
}
estout using Table2.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace


* Figure 1

expand 2, gen(clone)
expand 2 in 500, gen(clone2)
sum restraint_pre if postcrisis==1 & clone==0
replace restraint_pre = r(mean) if clone==1
replace growth_post = 8 if clone2==1
sort growth_post

qui cgmreg volatility_diff restraint_pre growth_post if postcrisis==1 & clone==0, cl(country crisis)
predict level, xb
predict error, stdp
gen lower = level-1.96*error
gen upper = level+1.96*error

tw con level growth_post if clone==1 & growth_post<=8, m(none) clw(thick) clcol(black) /*
*/ || con lower growth_post if clone==1 & growth_post<=8, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ || con upper growth_post if clone==1 & growth_post<=8, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ xlab(-8(2)8, labs(5)) ylab(-10(5)10, labs(5) glw(vvthin) nogrid) /*
*/ ysca(noline) xsca(noline) legend(off) yline(0, lcol(black) lw(thin)) /*
*/ xti("Economic growth (post)", size(6)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ yti("{&Delta} Volatility", size(6)) graphr(fcol(white)) ysize(10) xsize(10)
	
drop level error lower upper

qui cgmreg fragmentation_diff restraint_pre growth_post if postcrisis==1 & clone==0, cl(country crisis)
predict level, xb
predict error, stdp
gen lower = level-1.96*error
gen upper = level+1.96*error

tw con level growth_post if clone==1 & growth_post<=8, m(none) clw(thick) clcol(black) /*
*/ || con lower growth_post if clone==1 & growth_post<=8, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ || con upper growth_post if clone==1 & growth_post<=8, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ xlab(-8(2)8, labs(5)) ylab(-1(.5)1.5, labs(5) glw(vvthin) nogrid) /*
*/ ysca(noline) xsca(noline) legend(off) yline(0, lcol(black) lw(thin)) /*
*/ xti("Economic growth (post)", size(6)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ yti("{&Delta} Fragmentation", size(6)) graphr(fcol(white)) ysize(10) xsize(10)
	
drop level error lower upper

qui cgmreg polarization_diff restraint_pre growth_post if postcrisis==1 & clone==0, cl(country crisis)
predict level, xb
predict error, stdp
gen lower = level-1.96*error
gen upper = level+1.96*error

tw con level growth_post if clone==1 & growth_post<=8, m(none) clw(thick) clcol(black) /*
*/ || con lower growth_post if clone==1 & growth_post<=8, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ || con upper growth_post if clone==1 & growth_post<=8, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ xlab(-8(2)8, labs(5)) ylab(-10(5)20, labs(5) glw(vvthin) nogrid) /*
*/ ysca(noline) xsca(noline) legend(off) yline(0, lcol(black) lw(thin)) /*
*/ xti("Economic growth (post)", size(6)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ yti("{&Delta} Polarization", size(6)) graphr(fcol(white)) ysize(10) xsize(10)
	
drop level error lower upper

qui cgmreg closure_diff restraint_pre growth_post if postcrisis==1 & clone==0, cl(country crisis)
predict level, xb
predict error, stdp
gen lower = level-1.96*error
gen upper = level+1.96*error

tw con level growth_post if clone==1 & growth_post<=8, m(none) clw(thick) clcol(black) /*
*/ || con lower growth_post if clone==1 & growth_post<=8, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ || con upper growth_post if clone==1 & growth_post<=8, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ xlab(-8(2)8, labs(5)) ylab(-3(3)6, labs(5) glw(vvthin) nogrid) /*
*/ ysca(noline) xsca(noline) legend(off) yline(0, lcol(black) lw(thin)) /*
*/ xti("Economic growth (post)", size(6)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ yti("{&Delta} Closure", size(6)) graphr(fcol(white)) ysize(10) xsize(10)
	
drop level error lower upper

drop if clone==1
drop clone*


* Figure 2

expand 2, gen(clone)
sum growth_post if postcrisis==1 & clone==0
replace growth_post = r(mean) if clone==1
sort restraint_pre

qui cgmreg volatility_diff restraint_pre growth_post if postcrisis==1 & clone==0, cl(country crisis)
predict level, xb
predict error, stdp
gen lower = level-1.96*error
gen upper = level+1.96*error

tw con level restraint_pre if clone==1, m(none) clw(thick) clcol(black) /*
*/ || con lower restraint_pre if clone==1, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ || con upper restraint_pre if clone==1, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ xlab(-2(.5)1.5, labs(5)) ylab(-15(5)10, labs(5) glw(vvthin) nogrid) /*
*/ ysca(noline) xsca(noline) legend(off) yline(0, lcol(black) lw(thin)) /*
*/ xti("Party-system restraint (pre)", size(6)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ yti("{&Delta} Volatility", size(6)) graphr(fcol(white)) ysize(10) xsize(10)

drop level error lower upper

qui cgmreg fragmentation_diff restraint_pre growth_post if postcrisis==1 & clone==0, cl(country crisis)
predict level, xb
predict error, stdp
gen lower = level-1.96*error
gen upper = level+1.96*error

tw con level restraint_pre if clone==1, m(none) clw(thick) clcol(black) /*
*/ || con lower restraint_pre if clone==1, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ || con upper restraint_pre if clone==1, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ xlab(-2(.5)1.5, labs(5)) ylab(-1.5(.5)1.5, labs(5) glw(vvthin) nogrid) /*
*/ ysca(noline) xsca(noline) legend(off) yline(0, lcol(black) lw(thin)) /*
*/ xti("Party-system restraint (pre)", size(6)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ yti("{&Delta} Fragmentation", size(6)) graphr(fcol(white)) ysize(10) xsize(10)
	
drop level error lower upper

qui cgmreg polarization_diff restraint_pre growth_post if postcrisis==1 & clone==0, cl(country crisis)
predict level, xb
predict error, stdp
gen lower = level-1.96*error
gen upper = level+1.96*error

tw con level restraint_pre if clone==1, m(none) clw(thick) clcol(black) /*
*/ || con lower restraint_pre if clone==1, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ || con upper restraint_pre if clone==1, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ xlab(-2(.5)1.5, labs(5)) ylab(-10(5)10, labs(5) glw(vvthin) nogrid) /*
*/ ysca(noline) xsca(noline) legend(off) yline(0, lcol(black) lw(thin)) /*
*/ xti("Party-system restraint (pre)", size(6)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ yti("{&Delta} Polarization", size(6)) graphr(fcol(white)) ysize(10) xsize(10)
	
drop level error lower upper

qui cgmreg closure_diff restraint_pre growth_post if postcrisis==1 & clone==0, cl(country crisis)
predict level, xb
predict error, stdp
gen lower = level-1.96*error
gen upper = level+1.96*error

tw con level restraint_pre if clone==1, m(none) clw(thick) clcol(black) /*
*/ || con lower restraint_pre if clone==1, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ || con upper restraint_pre if clone==1, m(none) clw(medthick) clcol(black) clp(dash) /*
*/ xlab(-2(.5)1.5, labs(5)) ylab(-5(5)15, labs(5) glw(vvthin) nogrid) /*
*/ ysca(noline) xsca(noline) legend(off) yline(0, lcol(black) lw(thin)) /*
*/ xti("Party-system restraint (pre)", size(6)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ yti("{&Delta} Closure", size(6)) graphr(fcol(white)) ysize(10) xsize(10)
	
drop level error lower upper

drop if clone==1
drop clone*


* Table 3

	* Imputation of volatility for Georgia 2004 (2003 results annulled)
	qui reg volatility fragmentation polarization closure i.crisis i.postcrisis i.eumember i.postcom demagelog i.country
	predict aux
	replace volatility = aux if mi(volatility)
	drop aux

eststo clear
eststo strategic: qui cgmreg closure_diff volatility_diff fragmentation_diff polarization_diff growth_post restraint_pre if postcrisis==1, cl(country crisis)
eststo structural: qui cgmreg closure volatility fragmentation polarization if postcrisis==0, cl(country crisis)
estout using Table3.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace


* Table 4

eststo clear
foreach crisis of numlist 1929 1973 2008 {
	foreach var of varl volatility fragmentation polarization closure {
		eststo `var'_`crisis': qui reg `var'_diff if postcrisis==1 & crisis==`crisis', r
	}
}
foreach region of numlist 0 1 {
	foreach var of varl volatility fragmentation polarization closure {
		eststo `var'_`region': qui reg `var'_diff if postcrisis==1 & crisis==2008 & postcom==`region', r
	}
}
estout using Table4.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) replace


* Table App3

eststo clear
foreach var of varl volatility fragmentation polarization closure {
	eststo `var': qui cgmreg `var'_diff growth_post restraint_pre ib1929.crisis if postcrisis==1, cl(country crisis)
}
estout using TableApp2.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace


* Table App4

eststo clear
foreach crisis of numlist 1929 1973 {
	foreach var of varl volatility fragmentation polarization closure {
		eststo `var'_`crisis': qui reg `var'_diff growth_post restraint_pre if postcrisis==1 & crisis==`crisis', r
	}
}
foreach region of numlist 0 1 {
	foreach var of varl volatility fragmentation polarization closure {
		eststo `var'_`region': qui reg `var'_diff growth_post restraint_pre if postcrisis==1 & crisis==2008 & postcom==`region', r
	}
}
estout using TableApp3.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace


* Table App5

eststo clear
foreach var of varl volatility fragmentation polarization closure {
	eststo `var': qui cgmreg `var'_diff growth_post restraint_pre demagelog if postcrisis==1, cl(country crisis)
}
estout using TableApp4.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace


* Table App6

eststo clear
foreach var of varl volatility fragmentation polarization closure {
	eststo `var': qui cgmreg `var'_diff growth_post restraint_pre yearssince if postcrisis==1, cl(country crisis)
}
estout using TableApp5.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace


* Table App7

eststo clear
eststo pol1: qui reg polarization_cmp_diff if postcrisis==1 & crisis==2008, r
eststo pol2: qui reg polarization_cmp_diff growth_post restraint_cmp_pre if postcrisis==1 & crisis==2008, r
estout using TableApp6.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace


* Table App8

eststo clear
foreach var of varl volatility fragmentation polarization closure {
	eststo `var': qui reg `var'_diff unempl_diff restraint_pre if postcrisis==1 & crisis==2008, r
}
estout using TableApp7.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace


* Table App9

eststo clear
foreach var of varl volatility fragmentation polarization closure {
	eststo `var': qui reg `var'_diff growth_post restraint_pre eumember if postcrisis==1 & crisis==2008, r
}
estout using TableApp8.doc, c(b(s f(2)) se(par f(2))) starl(+ 0.10 * 0.05 ** 0.01) s(r2 N, f(2 0)) replace
