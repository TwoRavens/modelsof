/*
 Replication file: 
 Who gets into the papers? Party campaign messages and the media
 (Thomas M. Meyer, Martin Haselmayer & Markus Wagner, University of Vienna)
 */
 
** settings **
clear
clear mata 
clear matrix
version 13.0
set more off
set scrollbufsize 50000
set mem 512M, 
set scheme sj
set trace off
capture log close


** install packes for esttab & eclplot
net sj 14-2 st0085_2
net install st0085_2

net sj 10-4 st0043_2
net install st0043_2.pkg


* get data
use pr_analysis.dta, clear


************************************************************
***************** Descriptives  ****************************
************************************************************

*** success by party
sum effective
tab actor_org
graph bar effective, over(actor_org, relabel(1 `" "SPÖ"  "(N=451)" "'  2 `" "ÖVP"  "(N=344)" "' 3 `" "FPÖ"  "(N=475)" "' 4 `" "Greens"  "(N=133)" "' 5 `" "BZÖ"  "(N=96)" "' 6 `" "TS"  "(N=114)" "') gap(200) ) ///
	bar( 1, color(black) ) ///
	intensity(100) ///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(0.0 0.25)) ///
    ylabel(0 "0" 0.05 "5" 0.10 "10" 0.15 "15" 0.20 "20" 0.25 "25", labsize(medsmall) notick nogrid) ///
	ytitle("Successful press releases (in %)" " ",size(medsmall)) ///
	ysize(4) ///
	xsize(5) ///
	yline(0.16,lpattern(dash) lcolor(black))
	
graph export fig1.tif, replace width(1500)



**********************************************************************
***************** Multivariate Analysis  ****************************
**********************************************************************

*** logistic regression
xi: logit effective  c.media_issue_salience  c.vt_issue_salience c.man_issue_salience  c.issue_engagement gov ib4.role   eventdriven press_conference words  time2 , cluster(issue)
est sto m2_logit

est restore m2_logit
margins, dydx(role) at( eventdriven=0   press_conference=0   gov=1 (mean) media_issue_salience man_issue_salience vt_issue_salience issue_engagement  words time2) 




*Graph for marginal effects (fig 2):

gen x=_n in 1/4

gen effect=.
gen upper=.
gen lower=.
gen lower95=.
gen upper95=.

est restore m2_logit
margins, at((p25) media_issue_salience role=6   eventdriven=0   press_conference=0   gov=1 (mean) man_issue_salience vt_issue_salience issue_engagement  words time2) at((p75) media_issue_salience  role=6   eventdriven=0  press_conference=0  gov=1 (mean)  man_issue_salience vt_issue_salience issue_engagement  words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==1
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==1

est restore m2_logit
margins, at((p25) vt_issue_salience role=6   eventdriven=0   press_conference=0   gov=1  (mean) man_issue_salience issue_engagement media_issue_salience words time2) at((p75) vt_issue_salience role=6    eventdriven=0  press_conference=0  gov=1 (mean) man_issue_salience   issue_engagement media_issue_salience words time2)  pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==2
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==2
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==2
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==2
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==2


est restore m2_logit
margins, at((p25) man_issue_salience role=6   eventdriven=0   press_conference=0  gov=1  (mean)  issue_engagement  vt_issue_salience  media_issue_salience words time2) at((p75) man_issue_salience role=6    eventdriven=0  press_conference=0   gov=1 (mean)  issue_engagement   vt_issue_salience  media_issue_salience words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==3
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==3
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==3
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==3
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==3

est restore m2_logit
margins, at((p25) issue_engagement role=4   eventdriven=0   press_conference=0  gov=1  (mean) man_issue_salience vt_issue_salience  media_issue_salience words time2) at((p75) issue_engagement role=4    eventdriven=0  press_conference=0   gov=1 (mean)  man_issue_salience vt_issue_salience  media_issue_salience words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==4
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==4
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==4
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==4
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==4

gen x_graph=x*10
replace x_graph=8 if x==1
replace x_graph=14 if x==2
replace x_graph=20 if x==3
replace x_graph=26 if x==4

label define Hyp  8 "Media issue importance"  14 "Voter issue importance"   ///
					20 "Party issue importance"  26 "Party system issue importance" 
label values x_graph  Hyp
sort x_graph
eclplot effect lower upper x_graph in 1/45, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black) lwidth(thick))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(5 30)) ///
	xscale(range(-0.1 0.1)) ///
    ylabel(8 14 20 26  , valuelabel labsize(small) notick nogrid) ///
	xlabel(-0.1(0.05)0.1, labsize(small) ) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(4) ///
	xsize(7) ///
	xline(0, lcolor(black)) ///
	plot( rspike lower95 upper95 x_graph, horizontal lcolor(black) lpattern(solid) lwidth(thin) below) ///
	horizontal ///
	text(8 -0.175 "H1", size(small)) ///
	text(14 -0.175 "H2", size(small)) ///
	text(20 -0.175 "H3", size(small)) ///
	text(26 -0.175 "H4", size(small)) 
	
graph export fig2.tif, replace  width(2100) 

drop x effect upper lower x_graph upper95 lower95
matrix drop _all
label drop Hyp



*** models with lower rank politicians

* logistic regression (w/o party leaders, charmen, national or reg. government)
xi: logit effective  c.media_issue_salience c.vt_issue_salience c.man_issue_salience  c.issue_engagement  gov eventdriven press_conference words  time2   if role==4 | role==7, cluster(issue)
est sto m2_nooffice_logit

	
/*Graph for marginal effects:

gen x=_n in 1/4

gen effect=.
gen upper=.
gen lower=.
gen lower95=.
gen upper95=.

est restore m2_nooffice_logit
margins, at((p25) media_issue_salience   eventdriven=0   press_conference=0   gov=1 (mean) man_issue_salience vt_issue_salience issue_engagement  words time2) at((p75) media_issue_salience    eventdriven=0  press_conference=0  gov=1 (mean)  man_issue_salience vt_issue_salience issue_engagement  words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==1
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==1

est restore m2_nooffice_logit
margins, at((p25) vt_issue_salience   eventdriven=0   press_conference=0   gov=1  (mean) man_issue_salience issue_engagement media_issue_salience words time2) at((p75) vt_issue_salience     eventdriven=0  press_conference=0  gov=1 (mean) man_issue_salience   issue_engagement media_issue_salience words time2)  pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==2
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==2
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==2
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==2
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==2


est restore m2_nooffice_logit
margins, at((p25) man_issue_salience   eventdriven=0   press_conference=0  gov=1  (mean)  issue_engagement  vt_issue_salience  media_issue_salience words time2) at((p75) man_issue_salience     eventdriven=0  press_conference=0   gov=1 (mean)  issue_engagement   vt_issue_salience  media_issue_salience words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==3
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==3
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==3
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==3
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==3

est restore m2_nooffice_logit
margins, at((p25) issue_engagement   eventdriven=0   press_conference=0  gov=1  (mean) man_issue_salience vt_issue_salience  media_issue_salience words time2) at((p75) issue_engagement     eventdriven=0  press_conference=0   gov=1 (mean)  man_issue_salience vt_issue_salience  media_issue_salience words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==4
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==4
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==4
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==4
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==4

gen x_graph=x*10
replace x_graph=8 if x==1
replace x_graph=14 if x==2
replace x_graph=20 if x==3
replace x_graph=26 if x==4

label define Hyp  8 "Media issue importance"  14 "Voter issue importance"   ///
					20 "Party issue importance"  26 "Party system issue importance" 
label values x_graph  Hyp
sort x_graph
eclplot effect lower upper x_graph in 1/45, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black) lwidth(thick))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(5 30)) ///
	xscale(range(-0.1 0.1)) ///
    ylabel(8 14 20 26  , valuelabel labsize(small) notick nogrid) ///
	xlabel(-0.1(0.05)0.1, labsize(small) ) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(4) ///
	xsize(7) ///
	xline(0, lcolor(black)) ///
	plot( rspike lower95 upper95 x_graph, horizontal lcolor(black) lpattern(solid) lwidth(thin) below) ///
	horizontal ///
	text(8 -0.175 "H1", size(small)) ///
	text(14 -0.175 "H2", size(small)) ///
	text(20 -0.175 "H3", size(small)) ///
	text(26 -0.175 "H4", size(small)) 

	
graph export fig2_unimp.tif, replace  width(2100) 

drop x effect upper lower x_graph upper95 lower95
matrix drop _all
label drop Hyp
*/



*** effect for opposition parties
xi: logit effective  c.media_issue_salience c.vt_issue_salience c.man_issue_salience  c.issue_engagement  ib4.role  eventdriven press_conference words  time2 if gov==0, cluster(issue)
est sto m2_opp_logit



/*Graph for marginal effects:

gen x=_n in 1/4

gen effect=.
gen upper=.
gen lower=.
gen lower95=.
gen upper95=.

est restore m2_opp_logit
margins, at((p25) media_issue_salience  role=4 eventdriven=0   press_conference=0    (mean) man_issue_salience vt_issue_salience issue_engagement  words time2) at((p75) media_issue_salience  role=4  eventdriven=0  press_conference=0   (mean)  man_issue_salience vt_issue_salience issue_engagement  words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==1
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==1
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==1
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==1
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==1

est restore m2_opp_logit
margins, at((p25) vt_issue_salience  role=4 eventdriven=0   press_conference=0     (mean) man_issue_salience issue_engagement media_issue_salience words time2) at((p75) vt_issue_salience  role=4   eventdriven=0  press_conference=0   (mean) man_issue_salience   issue_engagement media_issue_salience words time2)  pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==2
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==2
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==2
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==2
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==2


est restore m2_opp_logit
margins, at((p25) man_issue_salience  role=4 eventdriven=0   press_conference=0    (mean)  issue_engagement  vt_issue_salience  media_issue_salience words time2) at((p75) man_issue_salience   role=4  eventdriven=0  press_conference=0    (mean)  issue_engagement   vt_issue_salience  media_issue_salience words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==3
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==3
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==3
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==3
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==3

est restore m2_opp_logit
margins, at((p25) issue_engagement role=4  eventdriven=0   press_conference=0    (mean) man_issue_salience vt_issue_salience  media_issue_salience words time2) at((p75) issue_engagement   role=4  eventdriven=0  press_conference=0    (mean)  man_issue_salience vt_issue_salience  media_issue_salience words time2)   pwcompare post
matrix b=r(b_vs)
matrix V=r(V_vs)
matrix list b
matrix list V
replace effect=b[1,1] 					  if x==4
replace upper95=b[1,1] + 1.96*sqrt(V[1,1]) if x==4
replace lower95=b[1,1] - 1.96*sqrt(V[1,1]) if x==4
replace upper=b[1,1] + 1.645*sqrt(V[1,1]) if x==4
replace lower=b[1,1] - 1.645*sqrt(V[1,1]) if x==4

gen x_graph=x*10
replace x_graph=8 if x==1
replace x_graph=14 if x==2
replace x_graph=20 if x==3
replace x_graph=26 if x==4

label define Hyp  8 "Media issue importance"  14 "Voter issue importance"   ///
					20 "Party issue importance"  26 "Party system issue importance" 
label values x_graph  Hyp
sort x_graph
eclplot effect lower upper x_graph in 1/45, ///
	rplottype(rspike) ///
	estopts(msymbol(circle) mcolor(black)) ///
	ciopts(lcolor(black) lwidth(thick))	///
	legend(off) ///
	graphregion(color(white)) ///
	yscale(range(5 30)) ///
	xscale(range(-0.1 0.1)) ///
    ylabel(8 14 20 26  , valuelabel labsize(small) notick nogrid) ///
	xlabel(-0.1(0.05)0.1, labsize(small) ) ///
	ytitle("") ///
	xtitle("Marginal effect",size(small)) ///
	ysize(4) ///
	xsize(7) ///
	xline(0, lcolor(black)) ///
	plot( rspike lower95 upper95 x_graph, horizontal lcolor(black) lpattern(solid) lwidth(thin) below) ///
	horizontal ///
	text(8 -0.175 "H1", size(small)) ///
	text(14 -0.175 "H2", size(small)) ///
	text(20 -0.175 "H3", size(small)) ///
	text(26 -0.175 "H4", size(small)) 

	
graph export fig2_opp.tif, replace  width(2100) 

drop x effect upper lower x_graph upper95 lower95
matrix drop _all
label drop Hyp
*/

*** Table with regression results
esttab m2_logit m2_nooffice_logit   m2_opp_logit    using "results.rtf", replace label scalars(ll) se(3)  ///
						nogaps star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Full model" "Unimportant politicians" "Opposition parties")



*****************************************************************
********* Robustness checks (Online Appendices) *****************
*****************************************************************

**** Robustness check: reduced sample of political actors (Appendix C)
xi: logit effective c.media_issue_salience c.vt_issue_salience c.man_issue_salience  c.issue_engagement  gov  ib4.role  eventdriven press_conference words  time2 if role<=4 , cluster(issue)
est sto m2_logit_wo_reg_other


esttab m2_logit m2_logit_wo_reg_other    using "appendix_c.rtf", replace label scalars(ll) se(3)  ///
						nogaps star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Paper model" "w/o regional & other party members")


**** Robustness check: media issue agenda (t-1) (Appendix D)
xi: logit effective c.media_issue_salience_lag  c.vt_issue_salience c.man_issue_salience  c.issue_engagement   ib4.role  gov  eventdriven press_conference words  time2 , cluster(issue)
est sto m2_logit_media_lag


esttab m2_logit m2_logit_media_lag    using "appendix_d.rtf", replace label scalars(ll) se(3)  ///
						nogaps star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Paper model" "Media agenda (t-1)")


*** Robustness check: accounting for party agenda (t-1) (Appendix F)
xi: logit effective  c.media_issue_salience  c.vt_issue_salience c.man_issue_salience  c.issue_engagement    ib4.role  gov  eventdriven press_conference words  time2  if issue_engagement_lag~=., cluster(issue)
est sto m2_logit_reduced

xi: logit effective ib4.role  gov c.vt_issue_salience c.man_issue_salience  c.issue_engagement c.issue_engagement_lag c.media_issue_salience  eventdriven press_conference words  time2 , cluster(issue)
est sto m2_logit_mediacheck

esttab m2_logit m2_logit_reduced m2_logit_mediacheck    using "appendix_f.rtf", replace label scalars(ll) se(3)  ///
						nogaps star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Paper model" "Paper model (reduced sample)" "Model including party system issue salience (t-1)")


						

*** The issue agenda in party press releases (Appendix E)
use appendix_e.dta, clear
clogit issue_emph  man_issue_salience media_issue_salience_lag, group(res_id)
est sto choice_full
margins, dydx( man_issue_salience media_issue_salience_lag)


*SPÖ
clogit issue_emph  man_issue_salience media_issue_salience_lag if actor_org==1100000, group(res_id)
est sto choice_spo
margins, dydx(man_issue_salience media_issue_salience_lag)
*ÖVP
clogit issue_emph man_issue_salience media_issue_salience_lag if actor_org==1200000, group(res_id)
est sto choice_ovp
margins, dydx(man_issue_salience media_issue_salience_lag)
*FPÖ
clogit issue_emph man_issue_salience media_issue_salience_lag if actor_org==1300000, group(res_id)
est sto choice_fpo
margins, dydx(man_issue_salience media_issue_salience_lag)
*Greens
clogit issue_emph man_issue_salience media_issue_salience_lag if actor_org==1400000, group(res_id)
est sto choice_greens
margins, dydx(man_issue_salience media_issue_salience_lag)
*BZÖ
clogit issue_emph man_issue_salience media_issue_salience_lag if actor_org==1500000, group(res_id)
est sto choice_bzo
margins, dydx(man_issue_salience media_issue_salience_lag)
*TS
clogit issue_emph man_issue_salience media_issue_salience_lag if actor_org==1600000, group(res_id)
est sto choice_ts
margins, dydx(man_issue_salience media_issue_salience_lag)

esttab choice_full choice_spo  choice_ovp choice_fpo choice_greens choice_bzo choice_ts using "appendix_e.rtf", replace label scalars(ll) se(3)  ///
						nogaps star(+ 0.1 * 0.05 ** 0.01 *** 0.001) ///
						mtitles("Pooled model" "SPOE" "OEVP" "FPOE" "Greens" "BZOE" "TS")





*********************************************************************************




