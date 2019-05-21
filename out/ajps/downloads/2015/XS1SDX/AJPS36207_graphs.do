clear

set more off


/*SET YOUR PATH*/

cd "C:\Users\YOUR PATH\"

use AJPS36207.dta



/****Figure 2 ***/

preserve
drop if cand==0

twoway (kdensity promise if elec==1, lcolor(black) lwidth(thick)) (kdensity promise if random==1, lcolor(gs7) lwidth(thick)),  ytitle(Kernel density (Epanechnikov)) ytitle(, size(medium)) xtitle(Number of promised tokens) xtitle(, size(medium)) xlabel(, glcolor(gs12)) xscale(range(0 450)) xlabel(0(50)450) legend(order(1 "Election" 2 "Random") position(5) ring(0)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) title(Distribution of Promises, box bexpand size(medlarge) color(black) fcolor(gs14) lcolor(gs14)  margin(medium))

restore


/****Figure 3 ***/
preserve
keep if cand==1

cumul avgmyshare if elec==1, gen(cdf1) equal
cumul avgmyshare if random==1, gen(cdf2) equal
cumul avgmyshare if nocamp==1, gen(cdf3) equal

twoway (connected cdf1 avgmyshare, sort msymbol(circle)mcolor(black) lcolor(black) lwidth(thick) msize(large)) (connected cdf2 avgmyshare, sort msymbol(square)lwidth(thick) lcolor(gs7) msize(large) mcolor(gs7)) (connected cdf3 avgmyshare, sort lpattern(dash) msymbol(triangle)lwidth(thick) lcolor(gs12) msize(large) mcolor(gs12)), ytitle(Cumulative probability, margin(medium) size(medlarge))  ttitle(Average number of distributed tokens, margin(medsmall) size(medlarge)) tlabel(0(50)450) legend(ring(0) pos(4) order(1 2 3) label(1 "Election") label(2 "Random") label(3 "NoCampaign")   col(1) region(lp(blank)) ) title(Cumulative Distribution Functions, box bexpand size(medlarge) color(black) fcolor(gs14) lcolor(gs14)  margin(medium)) graphregion(color(white)) plotregion(lcolor(white)) ylabel(,grid glcolor(gs12)) 
     
restore




/****Figure 4 ***/
preserve
keep if cand==1
reshape long mysharev, i(id) j(votes)

graph bar (mean) myshare, over(votes, relabel(1 "60%" 2 "80%" 3 "100%") label(labsize(medium))) blabel(bar, size(small)  format(%9.1f) margin(zero)) bar(1, fcolor(black) lcolor(black))  ytitle(Average number of distributed tokens) ytitle(, size(medium)) ylabel(, labsize(medium) glcolor(gs12)) by(, caption(Approval rate, position(6) size(medium)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) by(treat, rows(1) note("")) subtitle(, margin(medsmall) size(large) box fcolor(gs14) lcolor(gs14))

restore

/****Figure 5 ***/
preserve

clear
use AJPS36207direct.dta
drop if cand==0

graph bar (mean) myshare if mewinner==1, over(my_approval, relabel(1 "66%" 2 "100%") label(labsize(medium))) blabel(bar, size(medsmall) format(%9.1f))   bar(1, fcolor(black) lcolor(black)) ytitle(Average number of distributed tokens) ytitle(, size(medium)) ylabel(0(50)250, labsize(medium) glcolor(gs12)) caption(Approval rate, position(6) size(medium)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))  plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) subtitle(Election (direct), margin(medsmall) size(large) box bexpand fcolor(gs14) lcolor(gs14)) fxsize(75)

restore


/****Figure 6***/

/****(upper panel) ***/
preserve

keep if elec==1
gen promisea=promise if candidate==1
gen promiseb=promise if candidate==2
by session, sort: egen promise_1 = max(promisea)
by session, sort: egen promise_2 = max(promiseb)
drop promisea promiseb 
drop if cand==1
drop candidate 
rename mybelief_v_a mybelief_v_1
rename mybelief_v_b mybelief_v_2

reshape long promise_ mybelief_v_ , i(id session) j(candidate)

twoway (qfit mybelief_v_ promise_), ytitle(Belief: number of distributed tokens (fitted  values)) xtitle(Number of promised tokens) xlabel(0(50)450) graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white))

restore

/****(lower panel) ***/
preserve
drop if cand==1
keep if elec==1

twoway (qfit vote_a diffpromise), ytitle(Probability to voting for candidate A (fitted  values)) xtitle(Difference in the number of promised tokens (A - B)) xlabel(-200(50)200) legend(order(1 "Fitted values" 2 "Belief")) graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white))

restore


/****Figure 7 ***/
preserve
keep if cand==1
reshape long mysharev, i(id) j(votes)


replace diffpromisemyshare=promise-mysharev  
replace  fractionofpromisekept=1-(diffpromisemyshare/promise)
replace  fractionofpromisekept=1 if fractionofpromisekept==. & promise==0
replace fractionofpromisekept=1 if fractionofpromisekept>1
replace fractionofpromisekept=fractionofpromisekept*100


/****(upper panel) ***/
twoway (kdensity fractionofpromisekept if elec==1, lcolor(black) lwidth(thick)) (kdensity fractionofpromisekept if random==1 , lcolor(gs7) lwidth(thick)) , ytitle(Kernel density (Epanechnikov)) ytitle(, size(medium)) xtitle(Pledge Fulfillment (in %)) xtitle(, size(medium)) xlabel(, glcolor(gs12)) xscale(range(0 100)) xlabel(0(10)100) legend(order(1 "Election" 2 "Random") position(11) ring(0)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) title(Distributions of Pledge Fulfillment (Sample: Full), box bexpand size(medlarge) color(black) fcolor(gs14) lcolor(gs14)  margin(medium))

/****(lower panel) ***/
twoway (kdensity fractionofpromisekept if elec==1, lcolor(black) lwidth(thick)) (kdensity fractionofpromisekept if random==1 & promise!=0, lcolor(gs7) lwidth(thick)) , ytitle(Kernel density (Epanechnikov)) ytitle(, size(medium)) xtitle(Pledge Fulfillment (in %)) xtitle(, size(medium)) xlabel(, glcolor(gs12)) xscale(range(0 100)) xlabel(0(10)100) legend(order(1 "Election" 2 "Random") position(11) ring(0)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) title(Distributions of Pledge Fulfillment (Sample: Promise>0), box bexpand size(medlarge) color(black) fcolor(gs14) lcolor(gs14)  margin(medium))

restore


