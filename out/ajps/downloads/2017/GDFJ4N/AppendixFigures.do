*Strategies of Resistance: Diversification and Diffusion. Cunningham, Dahl & Frugé
*/This do-file reproduces the Figures in the appendix

*/Figure 1:

use "appendixfigure1_AJPS.dta", clear
graph bar economic_noncoop protest_demonstration nvintervention social_noncoop political_nocoop, over(group1) legend(lab(1 "Economic non-cooperation") ///
lab(2 "Protest and Demonstration" ) lab(3 "NV intervention" ) lab(4 "Social non-cooperation" ) lab(5 "Political non-cooperation" )) ///
 graphregion(color(white))

*/Figure 2:
use "StrategiesResistance_Replication_AJPS.dta", clear
preserve
sort facid
by facid: gen n=_n
keep if n==1
gen x=1
sort kgcid
by kgcid: egen N_org=sum(x)
drop n
by kgcid: gen n=_n
keep if n==1
hist N_org, freq xtitle("Number of organizations") ytitle("Number of movements")


*/Figure 3:
use "StrategiesResistance_Replication_AJPS.dta", clear
preserve
sort facid
by facid: gen n=_n
keep if n==1
gen x=1
sort kgcid
by kgcid: egen N_org=sum(x)
drop n
by kgcid: gen n=_n
keep if n==1
label var N_org "Number of organizations"
graph box N_org
restore

*/Figure 4:
use "StrategiesResistance_Replication_AJPS.dta", clear
preserve
sort kgcid year
gen x=1
by kgcid year: egen annual_Norg=sum(x)
by kgcid: egen maxannual_Norg=max(annual_Norg)
by kgcid: gen n=_n
keep if n==1
hist maxannual_Norg, freq ytitle("Number of movements") xtitle("Yearly maximum number of organizations")
restore

*/Figure 5:
use "StrategiesResistance_Replication_AJPS.dta", clear
sort kgcid
by kgcid: gen n=_n
keep if n==1
sort gwno
gen x=1
by gwno: egen Nmovements_ctry=sum(x)
drop n
by gwno: gen n=_n
keep if n==1
drop if Nmovements_ctry==1
label var Nmovements_ctry "Number movements in Country"
hist Nmovements_ctry,  bin(10) freq


*/Figure 6:
use "county level direct diffusion_AJPS.dta"
twoway (bar effect xpos, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability) xtitle(Direct Diffusion) yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xlabel(.5 "Economic" 1 "Protest" 1.5 "Social" 2 "Violence", labsize(small) angle(forty_five)) legend(off) graphregion(fcolor(white) ifcolor(white)) 


*/Figure 7:
use "Country diffusion_AJPS.dta"
twoway (bar violence xpos1, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Violence) ///
 xlabel(.5 "Protest" 1 "NV Intervention" 1.5 "Institutional" 2 "Violence" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "violence_country", replace
twoway (bar economic xpos2, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Economic) ///
 xlabel(.5 "Economic" 1 "Political" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "economic_country", replace
twoway (bar protest xpos3, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Protest) ///
 xlabel(.5 "Economic" 1 "Protest" 1.5 "Violence"  , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "protest_country", replace
twoway (bar social xpos4, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Social) ///
 xlabel(.5 "Economic" 1 "Protest" 1.5 "Social" 2 "NV Intervention" 2.5 "Institutional" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "social_country", replace
twoway (bar political xpos5, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Political) ///
 xlabel(.5 "Social" 1  "Institutional"  , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "political_country", replace
twoway (bar institutional xpos6, fcolor(black) lcolor(black) barwidth(.1)), ytitle(Change in Probability ) ///
yscale(lcolor(black) line) yline(0, lpattern(dash) lc(black)) xtitle(Effects of Institutional) ///
 xlabel(.5 "Social" 1 "Political" , labsize(small) angle(forty_five)) legend(off) ///
  graphregion(fcolor(white) ifcolor(white)) 
gr save "institutional_country", replace
gr combine  "economic_country" "protest_country" "social_country" "political_country" "institutional_country" "violence_country"  

