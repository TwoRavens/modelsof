
/***********************************************
Replication code for Till Weber & Mark Franklin,
"A behavioral theory of electoral structure",
published in Political Behavior.
This file July 19, 2017.
*/**********************************************


clear all
use replic_data


* Table 1

mi est, dots: mixed ptv /*
*/ || context: || rid:, mle

mi est, dots: mixed ptv /*
*/ lrprox euprox best close demographics pseats /*
*/ || context: || rid:, mle

mi est, dots: mixed ptv /*
*/ lrprox euprox best close demographics pseats /*
*/ || context: lrprox euprox best close demographics pseats || rid:, mle

mi est, dots: mixed ptv /*
*/ c.trel##c.trel##c.lrprox c.trel##c.trel##c.euprox c.trel##c.trel##c.best /*
*/ c.trel##c.trel##c.close c.trel##c.trel##c.demographics c.trel##c.trel##c.pseats /*
*/ || context: lrprox euprox best close demographics pseats || rid:, mle
est sto M4


* Figure 2

est res M4
mi est, post

matrix b=e(b)
matrix V=e(V)

forval c1 = 1/26 {
	scalar b`c1' = b[1,`c1']
	scalar varb`c1' = V[`c1',`c1']
	forval c2 = 1/26 {
		scalar covb`c1'b`c2' = V[`c1',`c2']
	}
}

gen aux = (_n-1)/100 in 1/101

loc v1 = 3
loc v2 = 4
loc v3 = 5

foreach var of varlist lrprox euprox best close demographics pseats {
	gen me_`var' = b`v1'+b`v2'*aux+b`v3'*(aux^2)
	gen se_`var' = sqrt(varb`v1'+(aux^2)*varb`v2'+(aux^4)*varb`v3'+2*aux*covb`v1'b`v2'+2*(aux^2)*covb`v1'b`v3'+2*(aux^3)*covb`v2'b`v3')
	gen one95_`var' = me_`var'-(1.645*se_`var')
	gen one90_`var' = me_`var'-(1.282*se_`var')
	loc v1 = `v1'+4
	loc v2 = `v2'+4
	loc v3 = `v3'+4
}

line me_lrprox aux, clwidth(vthick) clcolor(black) || /*
*/ rarea one90_lrprox me_lrprox aux, color(gs12) lwidth(none) || /*
*/ rarea one95_lrprox one90_lrprox aux, color(gs14) lwidth(none) || /*
*/ line me_euprox aux, clwidth(vthick) clcolor(black) || /*
*/ rarea one90_euprox me_euprox aux, color(gs12) lwidth(none) || /*
*/ rarea one95_euprox one90_euprox aux, color(gs14) lwidth(none) || /*
*/ line me_best aux, clwidth(vthick) clcolor(black) || /*
*/ rarea one90_best me_best aux, color(gs12) lwidth(none) || /*
*/ rarea one95_best one90_best aux, color(gs14) lwidth(none) || /*
*/ line me_close aux, clwidth(vthick) clcolor(black) || /*
*/ rarea one90_close me_close aux, color(gs12) lwidth(none) || /*
*/ rarea one95_close one90_close aux, color(gs14) lwidth(none) || /*
*/ , xmlabel(0.1 0.2 0.3 0.4 0.6 0.7 0.8 0.9, labsize(medium)) /*
*/ xlabel(0 "1st election" 0.5 "midterm" 1.0 "2nd election", labsize(medium) angle(40)) /*
*/ ylabel(0(.5)4.5, labsize(medium) /*
*/ glwidth(vvthin) nogrid) legend(col(2) size(medium) lwidth(vvthin) order(2 3) /*
*/ label(2 "90% confidence") label(3 "95% confidence")) /*
*/ xtitle(Relative cycle position, size(medium)) xsca(titlegap(-3)) ysca(titlegap(2)) /*
*/ ytitle("Marginal effect on party preference", size(medium)) graphregion(fcolor(white)) ysize(9) xsize(3) /*
*/ text(3.38 0 "Party Identification", placement(e) size(medium)) text(2.5 0 "Left-right proximity", placement(e) size(medium)) /*
*/ text(1.1 0 "Issue competence", placement(e) size(medium)) text(0.07 0 "EU proximity", placement(e) size(medium)) /*
*/ title("Entropic and mixed forces", color(black) size(vlarge))

line me_demographics aux, clwidth(vthick) clcolor(black) || /*
*/ rarea one90_demographics me_demographics aux, color(gs12) lwidth(none) || /*
*/ rarea one95_demographics one90_demographics aux, color(gs14) lwidth(none) || /*
*/ line me_pseats aux, clwidth(vthick) clcolor(black) || /*
*/ rarea one90_pseats me_pseats aux, color(gs12) lwidth(none) || /*
*/ rarea one95_pseats one90_pseats aux, color(gs14) lwidth(none) || /*
*/ , xmlabel(0.1 0.2 0.3 0.4 0.6 0.7 0.8 0.9, labsize(medium)) /*
*/ xlabel(0 "1st election" 0.5 "midterm" 1.0 "2nd election", labsize(medium) angle(40)) /*
*/ ylabel(0(.5)4.5, labsize(medium) /*
*/ glwidth(vvthin) nogrid) legend(col(2) size(medium) lwidth(vvthin) order(2 3) /*
*/ label(2 "90% confidence") label(3 "95% confidence")) /*
*/ xtitle(Relative cycle position, size(medium)) xsca(titlegap(-3)) ysca(titlegap(2)) /*
*/ ytitle("Marginal effect on party preference", size(medium)) graphregion(fcolor(white)) ysize(9) xsize(3) /*
*/ text(1.1 1 "Social structure", placement(w) size(medium)) text(3.05 1 "Party size", placement(w) size(medium)) /*
*/ title("Structuring forces", color(black) size(vlarge))


* Table App-5

mi est, dots: mixed ptv /*
*/ c.trel##c.trel##c.twoparty##c.pseats /*
*/ lrprox euprox best close demographics /*
*/ || context: lrprox euprox best close demographics || rid:, mle cluster(context)
est sto M5

mi est, dots: mixed ptv /*
*/ c.trel##c.trel##c.twoparty##c.demographics /*
*/ lrprox euprox best close pseats /*
*/ || context: lrprox euprox best close demographics pseats || rid:, mle
est sto M6


* Figure 4a

est res M5
mi est, post

matrix b=e(b)

forval c1 = 1/17 {
	scalar b`c1' = b[1,`c1']
}

gen aux2 = .
gen me_pseats_triple = .
forval step=0/15 {
	loc first = `step'*100+1
	loc last = 100+`step'*100
	replace aux2 = (_n-1-`step'*100)/99 in `first'/`last'
	replace me_pseats_triple = b6+b7*aux2+b8*(aux2^2)+b9*(.25+`step'*.05)+b10*aux2*(.25+`step'*.05)+b11*(aux2^2)*(.25+`step'*.05) in `first'/`last'
}

line me_pseats_triple aux2 if _n<=100, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>100 & _n<=200, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>200 & _n<=300, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>300 & _n<=400, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>400 & _n<=500, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>500 & _n<=600, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>600 & _n<=700, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>700 & _n<=800, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>800 & _n<=900, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>900 & _n<=1000, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>1000 & _n<=1100, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>1100 & _n<=1200, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>1200 & _n<=1300, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>1300 & _n<=1400, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>1400 & _n<=1500, clwidth(medthick) clcolor(black) || /*
*/ line me_pseats_triple aux2 if _n>1500 & _n<=1600, clwidth(medthick) clcolor(black) || /*
*/ , xmlabel(0.1 0.2 0.3 0.4 0.6 0.7 0.8 0.9, labsize(medium)) /*
*/ xlabel(0 "1st election" 0.5 "midterm" 1.0 "2nd election", labsize(medium) angle(40)) /*
*/ xmtick(1.1, tlcolor(none)) ylabel(0(1)9, labsize(medium) glwidth(vvthin) nogrid) legend(off) /*
*/ xtitle(Relative cycle position, size(medium)) xsca(titlegap(1)) ysca(titlegap(2)) /*
*/ ytitle("Marginal effect of party size on party preference", size(medium)) graphregion(fcolor(white)) ysize(9) xsize(3) /*
*/ text(7.5 1.2 "Two-party dominance", placement(w) size(medium)) text(7.15 1.13 ".25", placement(w) size(medium)) /*
*/ text(6.75 1.13 ".30", placement(w) size(medium)) text(6.3 1.13 ".35", placement(w) size(medium)) text(5.9 1.13 ".40", placement(w) size(medium)) /*
*/ text(5.5 1.13 ".45", placement(w) size(medium)) text(5.1 1.13 ".50", placement(w) size(medium)) text(4.7 1.13 ".55", placement(w) size(medium)) /*
*/ text(4.25 1.13 ".60", placement(w) size(medium)) text(3.85 1.13 ".65", placement(w) size(medium)) text(3.4 1.13 ".70", placement(w) size(medium)) /*
*/ text(3 1.13 ".75", placement(w) size(medium)) text(2.6 1.13 ".80", placement(w) size(medium)) text(2.2 1.13 ".85", placement(w) size(medium)) /*
*/ text(1.8 1.13 ".90", placement(w) size(medium)) text(1.4 1.13 ".95", placement(w) size(medium)) text(1 1.13 "1.00", placement(w) size(medium)) /*
*/ title("Effects of party size", color(black) size(vlarge))


* Figure 4b

est res M6
mi est, post

matrix b=e(b)

forval c1 = 1/17 {
	scalar b`c1' = b[1,`c1']
}

gen me_demogr_triple = .
forval step=0/15 {
	loc first = `step'*100+1
	loc last = 100+`step'*100
	replace me_demogr_triple = b6+b7*aux2+b8*(aux2^2)+b9*(.25+`step'*.05)+b10*aux2*(.25+`step'*.05)+b11*(aux2^2)*(.25+`step'*.05) in `first'/`last'
}

line me_demogr_triple aux2 if _n<=100, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>100 & _n<=200, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>200 & _n<=300, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>300 & _n<=400, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>400 & _n<=500, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>500 & _n<=600, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>600 & _n<=700, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>700 & _n<=800, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>800 & _n<=900, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>900 & _n<=1000, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>1000 & _n<=1100, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>1100 & _n<=1200, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>1200 & _n<=1300, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>1300 & _n<=1400, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>1400 & _n<=1500, clwidth(medthick) clcolor(black) || /*
*/ line me_demogr_triple aux2 if _n>1500 & _n<=1600, clwidth(medthick) clcolor(black) || /*
*/ , xmlabel(0.1 0.2 0.3 0.4 0.6 0.7 0.8 0.9, labsize(medium)) /*
*/ xlabel(0 "1st election" 0.5 "midterm" 1.0 "2nd election", labsize(medium) angle(40)) /*
*/ xmtick(1.1, tlcolor(none)) ylabel(0(.2)2, labsize(medium) glwidth(vvthin) nogrid) legend(off) /*
*/ xtitle(Relative cycle position, size(medium)) xsca(titlegap(1)) ysca(titlegap(2)) /*
*/ ytitle("Marginal effect of social structure on party preference", size(medium)) graphregion(fcolor(white)) ysize(9) xsize(3) /*
*/ text(1.9 1.2 "Two-party dominance", placement(w) size(medium)) text(1.82 1.13 ".25", placement(w) size(medium)) /*
*/ text(1.72 1.13 ".30", placement(w) size(medium)) text(1.62 1.13 ".35", placement(w) size(medium)) text(1.52 1.13 ".40", placement(w) size(medium)) /*
*/ text(1.43 1.13 ".45", placement(w) size(medium)) text(1.33 1.13 ".50", placement(w) size(medium)) text(1.24 1.13 ".55", placement(w) size(medium)) /*
*/ text(1.14 1.13 ".60", placement(w) size(medium)) text(1.05 1.13 ".65", placement(w) size(medium)) text(.95 1.13 ".70", placement(w) size(medium)) /*
*/ text(.86 1.13 ".75", placement(w) size(medium)) text(.77 1.13 ".80", placement(w) size(medium)) text(.67 1.13 ".85", placement(w) size(medium)) /*
*/ text(.57 1.13 ".90", placement(w) size(medium)) text(.47 1.13 ".95", placement(w) size(medium)) text(.38 1.13 "1.00", placement(w) size(medium)) /*
*/ title("Effects of social structure", color(black) size(vlarge))


* Table App-4

foreach var of varlist best close lrprox euprox {
	gen `var'_r2 = .
	forval imp=1/5 {
		levelsof context, local(context)
		foreach c of local context {
			qui anova `var' stack if context==`c' & _mi_m==`imp'
			replace `var'_r2 = e(r2) if context==`c' & _mi_m==`imp'
		}
	}
}

bysort _mi_m context: gen pres = _n
gen country = mod(context,100)
replace trel = 0 if _n==4087200

mi est, post: reg close_r2 c.trel##c.trel if pres==1, cl(country)
predict close_r2_pred, xb
predict close_r2_se, stdp

mi est, post: reg best_r2 c.trel##c.trel if pres==1, cl(country)
predict best_r2_pred, xb
predict best_r2_se, stdp

mi est, post: reg lrprox_r2 c.trel##c.trel if pres==1, cl(country)
predict lrprox_r2_pred, xb
predict lrprox_r2_se, stdp

mi est, post: reg euprox_r2 c.trel##c.trel if pres==1, cl(country)
predict euprox_r2_pred, xb
predict euprox_r2_se, stdp

foreach var of varlist close best lrprox euprox {
	gen `var'_r2_ci95 = `var'_r2_pred-(1.645*`var'_r2_se)
	gen `var'_r2_ci90 = `var'_r2_pred-(1.282*`var'_r2_se)
}


* Figure 3

replace pres = 1 if _n==4087200

line close_r2_pred trel if pres==1, sort(trel) clwidth(thick) clcolor(black) || /*
*/ rarea close_r2_ci90 close_r2_pred trel if pres==1, sort(trel) color(gs12) lwidth(none) || /*
*/ rarea close_r2_ci95 close_r2_ci90 trel if pres==1, sort(trel) color(gs14) lwidth(none) || /*
*/ , xlabel(0(.1)1, labsize(small)) ylabel(0(.025).15, labsize(small) /*
*/ glwidth(vvthin) nogrid) yscale(noline) xscale(noline) legend(col(2) size(3) lwidth(vvthin) order(2 3) /*
*/ label(2 "90% confidence") label(3 "95% confidence")) yline(0, lcolor(black) lwidth(thin)) /*
*/ title("Party identification", size(medium) height(8) alignment(top) color(black)) /*
*/ xtitle(Cycle position, size(3)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ ytitle("ANOVA R-squared from party", size(3)) graphregion(fcolor(white)) ysize(6) xsize(4)

line best_r2_pred trel if pres==1, sort(trel) clwidth(thick) clcolor(black) || /*
*/ rarea best_r2_ci90 best_r2_pred trel if pres==1, sort(trel) color(gs12) lwidth(none) || /*
*/ rarea best_r2_ci95 best_r2_ci90 trel if pres==1, sort(trel) color(gs14) lwidth(none) || /*
*/ , xlabel(0(.1)1, labsize(small)) ylabel(0(.025).15, labsize(small) /*
*/ glwidth(vvthin) nogrid) yscale(noline) xscale(noline) legend(col(2) size(3) lwidth(vvthin) order(2 3) /*
*/ label(2 "90% confidence") label(3 "95% confidence")) yline(0, lcolor(black) lwidth(thin)) /*
*/ title("Issue competence", size(medium) height(8) alignment(top) color(black)) /*
*/ xtitle(Cycle position, size(3)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ ytitle("ANOVA R-squared from party", size(3)) graphregion(fcolor(white)) ysize(6) xsize(4)

line lrprox_r2_pred trel if pres==1, sort(trel) clwidth(thick) clcolor(black) || /*
*/ rarea lrprox_r2_ci90 lrprox_r2_pred trel if pres==1, sort(trel) color(gs12) lwidth(none) || /*
*/ rarea lrprox_r2_ci95 lrprox_r2_ci90 trel if pres==1, sort(trel) color(gs14) lwidth(none) || /*
*/ , xlabel(0(.1)1, labsize(small)) ylabel(0(.025).15, labsize(small) /*
*/ glwidth(vvthin) nogrid) yscale(noline) xscale(noline) legend(col(2) size(3) lwidth(vvthin) order(2 3) /*
*/ label(2 "90% confidence") label(3 "95% confidence")) yline(0, lcolor(black) lwidth(thin)) /*
*/ title("Left-right proximity", size(medium) height(8) alignment(top) color(black)) /*
*/ xtitle(Cycle position, size(3)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ ytitle("ANOVA R-squared from party", size(3)) graphregion(fcolor(white)) ysize(6) xsize(4)

line euprox_r2_pred trel if pres==1, sort(trel) clwidth(thick) clcolor(black) || /*
*/ rarea euprox_r2_ci90 euprox_r2_pred trel if pres==1, sort(trel) color(gs12) lwidth(none) || /*
*/ rarea euprox_r2_ci95 euprox_r2_ci90 trel if pres==1, sort(trel) color(gs14) lwidth(none) || /*
*/ , xlabel(0(.1)1, labsize(small)) ylabel(0(.025).15, labsize(small) /*
*/ glwidth(vvthin) nogrid) yscale(noline) xscale(noline) legend(col(2) size(3) lwidth(vvthin) order(2 3) /*
*/ label(2 "90% confidence") label(3 "95% confidence")) yline(0, lcolor(black) lwidth(thin)) /*
*/ title("EU proximity", size(medium) height(8) alignment(top) color(black)) /*
*/ xtitle(Cycle position, size(3)) xsca(titlegap(2)) ysca(titlegap(2)) /*
*/ ytitle("ANOVA R-squared from party", size(3)) graphregion(fcolor(white)) ysize(6) xsize(4)
