
*Reed, Clark, Nordstrom, and Siegel
*replication for "Bargaining in the Shadow of a Commitment Problem"
*June 5, 2016
*Research & Politics

*Figure 4

clear
use rcns_allgames.dta

#delimit ; 
twoway (scatter choice eq if correct==0, ylabel(0 1) xline(0,  lcolor(gs13))
 mcolor(gs13) msymbol(circle) msize(small)) (pcarrowi .7 .01 .7 .3 (1) "Commitment Problem"
 , mlabsize(vsmall))
(scatter choice eq if correct==1, mcolor(gs3) msize(small) msymbol(circle) ylabel(0 1)) 
 (scatteri .3 -1 "Incorrect" , mcolor(gs13) msymbol(circle)) 
 (pcarrowi .65 -.01 .65 -.3 (11) "No Commitment Problem" , mlabsize(vsmall))
 (scatteri .25 -1 "Correct", mcolor(gs3) msymbol(circle)), ytitle("Fight=0, Bargain=1")
xtitle("10*(p1-p2)-(c1+c2)") legend(off);
#delimit cr

*Figure 5

clear
use rcns_allgames.dta
reg demand p_later c1 c2 if twostage==1 & fight==2
prgen p_later, x(c1= .01 c2= .1) gen(two_low) ci
prgen p_later, x(c1= .1 c2= .1) gen(two_med) ci
prgen p_later, x(c1= .2 c2= .1) gen(two_hi) ci

reg demand p_later c1 c2 if twostage==0
prgen p_later, x(c1= .01 c2= .1) gen(one_low) ci
prgen p_later, x(c1= .1 c2= .1) gen(one_med) ci
prgen p_later, x(c1= .2 c2= .1) gen(one_hi) ci

gen averagenash= 10*two_lowx+.1
#delimit ; 
twoway (rarea two_lowxbub two_lowxblb two_lowx ,fcolor(gs13)fintensity(12) lcolor(white)) 
(rarea two_hixbub two_hixblb two_lowx,fcolor(gs1)fintensity(10) lcolor(white))
(line averagenash two_lowx) 
(scatteri 6.4 .1 "Proposer Costs Low", msymbol(none)) (scatteri 5 .6 "Proposer Costs High", msymbol(none))
 (scatteri 1 .1 "Nash average", msymbol(none)), 
ytitle(Average Demand) xtitle(Win Probability)  scheme(tufte) legend(off) 
title("Two-Stage Game") ;
graph save two_stage_costs.gph, replace;
#delimit cr

#delimit ; 
twoway (rarea one_lowxbub one_lowxblb two_lowx ,fcolor(gs13)fintensity(12) lcolor(white)) 
(rarea one_hixbub one_hixblb two_lowx,fcolor(gs1)fintensity(10) lcolor(white))
(line averagenash two_lowx) 
(scatteri 6.4 .1 "Proposer Costs Low", msymbol(none)) (scatteri 5 .6 "Proposer Costs High", msymbol(none))
 (scatteri 1 .1 "Nash average", msymbol(none)), 
ytitle(Average Demand) xtitle(Win Probability)  scheme(tufte) legend(off) 
title("Ultimatum Game");
graph save one_stage_costs.gph, replace;
graph combine two_stage_costs.gph one_stage_costs.gph, note("(Responder costs held at mean)");
#delimit cr


*Figure 6
clear
use rcns_allgames.dta
reg demand i.period p_later if fight~=1
twoway (line nash p_later) (scatter demand p_later if fight~=1), by(period) scheme(tufte)
 

*Table 1
*this code produces Table 1 standard errors clustered by bargaining round

clear
use rcns_allgames.dta
label variable nash "Nash Demand" 

gen Bargain=0
replace Bargain=1 if fight==2
gen Demand=.
replace Demand=demand if fight==2
label variable Bargain "Bargain = 1, Fight = 0"
label variable c1 "Cost for Conflict to Proposer"
label variable c2 "Cost for Conflict to Responder" 
label variable p_1 "Win Probability in first stage" 
label variable phat "Win probability in second stage"

*Column 1 
eststo clear
eststo: qui heckman Demand phat c1, sel(Bargain = p_1 phat c1 c2) cluster(period)
estimates store model1
*Column 2
eststo: qui heckman Demand phat c1 c2 , sel(Bargain = p_1 phat c1 c2) cluster(period)
estimates store model2
*Column 3
eststo: qui reg demand p_1 c1 if twostage==0, cluster(period) 
*Column 4
eststo: qui reg demand p_1 c1 c2 if twostage==0, cluster(period)

*this produces Table 1 
esttab using table1.tex, ar2  b(3) se(3) par label  lines replace


*Table 2
*this code produces Table 2, standard errors clustered by round, fixed effects for round

clear
use rcns_allgames.dta
label variable nash "Nash Demand" 

gen Bargain=0
replace Bargain=1 if fight==2
gen Demand=.
replace Demand=demand if fight==2
label variable Bargain "Bargain = 1, Fight = 0"
label variable c1 "Cost for Conflict to Proposer"
label variable c2 "Cost for Conflict to Responder" 
label variable p_1 "Win Probability in first stage" 
label variable phat "Win probability in second stage"


*Column 1
eststo clear
eststo: qui heckman Demand phat c1 i.period, sel(Bargain = p_1 phat c1 c2 i.period) cluster(period)
*Column 2
eststo: qui heckman Demand phat c1 c2 i.period , sel(Bargain = p_1 phat c1 c2 i.period) cluster(period)
*Column 3
eststo: qui reg demand p_1 c1 i.period if twostage==0, cluster(period) 
*Column 4
eststo: qui reg demand p_1 c1 c2 i.period if twostage==0, cluster(period)
esttab using table2.tex, ar2  b(3) se(3) par label  lines replace




