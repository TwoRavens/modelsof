
*set working directory
*cd ""


log using Diasporas_Disasters_Appendix, text replace


********************************************************************************
*
* Appendix
*
********************************************************************************


********************************************************************************
*Summary Statistics OECD-Sample

clear
use oecd_sample
set matsize 5000

tsset dyadid year


*labels
label var aid_dummy "Emergency Aid (Dummy)"
label var ln_sum_aid "Emergency Aid (Logged)"
label var ln_diaspora_ipo "Diaspora (WB, Logged)"
label var ln_brain_drain_ipo "Diaspora (IAB, Logged)"
label var ln_alldeaths "Deaths (Logged)"
label var ln_allaffected "Affected (Logged)"
label var ln_dis "Distance (Logged)"
label var ln_flow_b "Exports Donor to Recipient (Logged)"
label var ln_population_don "Population Donor (Logged)"
label var ln_gdppc_don "GDP p.c. Donor (Logged)"
label var ln_population_rec "Population Recipient (Logged)"
label var ln_gdppc_rec "GDP p.c. Recipient (Logged)"
label var polity_rec "Democracy Recipient"


sutex ln_sum_aid aid_dummy aid1 aid2 ln_abs_aid ln_diaspora_ipo ln_brain_drain_ipo ///
	ln_refugees ln_share1000 ln_alldeaths ///
	ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	polity_rec, ///
	labels minmax key(table:sum_oecd) title(Summary Statistics OECD-Sample) file(sum_oecd.tex) replace
	
	

********************************************************************************
*Summary Statistics UN-Sample

clear
use un_sample	


label var ln_total_aid "Emergency Aid (Logged)"
label var total_dummy "Emergency Aid (Dummy)"
label var ln_diaspora_ipo_2 "Diaspora (Logged)"
label var ln_refugees_lasso "Refugees (Logged)"
label var ln_deaths "Deaths (Logged)"
label var ln_affected "Affected (Logged)"
label var ln_dis "Distance (Logged)"
label var ln_flow_b "Exports Donor to Recipient (Logged)"
label var polity_don "Democracy Donor"
label var polity_rec "Democracy Recipient"
label var ln_population_don "Population Donor (Logged)"
label var ln_gdppc_don "GDP p.c. Donor (Logged)"
label var ln_population_rec "Population Recipient (Logged)"
label var ln_gdppc_rec "GDP p.c. Recipient (Logged)"
label var ln_share1000 "(Diaspora/Host Pop.)*1000 (Logged)"

sutex ln_total_aid total_dummy aid1 aid2 ln_abs_aid ln_diaspora_ipo_2 ln_share1000 ///
	ln_refugees_lasso ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec, ///
	labels minmax key(table:sum_un) title(Summary Statistics UN-Sample) file(sum_un.tex) replace
	
	
********************************************************************************
********************************************************************************
*Graphs with distribution
********************************************************************************
********************************************************************************

********************************************************************************
*Figure 1: Model 3 -- OECD-Data, diaspora*distance


clear
use oecd_sample

tsset dyadid year


tobit ln_sum_aid c.ln_dis##c.ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
margins, dydx(ln_diaspora_ipo) at(ln_dis=(4.127134 6.028278 7.003066 ///
	8.002694 8.500047 8.750208 9.000237 9.250138 9.500245 9.881497)) vsquish
	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Distance Donor-Recipient in km (Logged Scale)") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") ///
	xlabel(`=4.127134' "62" `=6.028278' "415" `=7.003066' "1,100" ///
	`=8.002694' "2,989" `=8.500047' "4,915" ///
	`=8.750208' "6,312" `=9.000237' "8,105" `=9.250138' "10,406" ///
	`=9.500245' "13,363" `=9.881497' "19,565", angle(45))

graph save 1.gph, replace

hist ln_dis if e(sample), freq subtitle(, lc(black)) xtitle ("Logged Distance") ///
	scheme(plotplainblind)
graph save 2.gph, replace

graph combine 1.gph 2.gph
graph export graph_1_appendix.png, width(2000) replace	
	

	
********************************************************************************
*Figure 2: Model 4 -- UN-sample, diaspora*people affected

clear
use un_sample


tobit ln_total_aid c.ln_affected##c.ln_diaspora_ipo_2 ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)
	
margins, dydx(ln_diaspora_ipo_2) at(ln_affected=(0 2.564949 4.59512 7.013016 9.036106 ///
	11.00212 13.017 15.05332 16.951 18.86489)) vsquish
	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Number of People Affected (Logged Scale)") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") ///
	xlabel(`=0' "0" `=2.564949' "12" `=4.59512' "98" ///
	`=7.013016' "1,110" `=9.036106' "8,400" ///
	`=11.00212' "60,000" `=13.017' "450,000" `=15.05332' "3,448,100" ///
	`=16.951' "2.30e+07" `=18.86489' "1.56e+08", angle(45))
graph save 1.gph, replace

hist ln_affected if e(sample), freq subtitle(, lc(black)) xtitle ("Logged Number of People Affected") ///
	scheme(plotplainblind)
graph save 2.gph, replace

graph combine 1.gph 2.gph
graph export graph_2_appendix.png, width(2000) replace


********************************************************************************
*Model 5 -- UN-Sample, diaspora*host country regime type	

tobit ln_total_aid c.polity_don##c.ln_diaspora_ipo_2 ln_affected ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)
	
margins, dydx(ln_diaspora_ipo_2) at(polity_don=(-10(2)10)) vsquish

marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Host Country Democracy Score") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") 
graph save 1.gph, replace

hist polity_don if e(sample), freq subtitle(, lc(black)) xtitle ("Host Country Democracy Score") ///
	scheme(plotplainblind)
graph save 2.gph, replace

graph combine 1.gph 2.gph
graph export graph_3_appendix.png, width(2000) replace



********************************************************************************
*Figure 4: UN-Sample, diaspora*people killed by disaster

tobit ln_total_aid c.ln_diaspora_ipo_2##c.ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)

margins, dydx(ln_diaspora_ipo_2) at(ln_deaths=(0 2.079442 3.044523 ///
	4.007333 5.010635 6.028278 7.042286 7.999007 10.19608 12.313)) vsquish
	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Number of People Killed (Logged Scale)") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") ///
	xlabel(`=0' "0" `=2.079442' "7" `=3.044523' "20" ///
	`=4.007333' "54" `=5.010635' "149" `=6.028278' "414" `=7.042286' ///
	"1,143" `=7.999007' "2,977" ///
	`=10.19608' "26,797" `=12.313' "222,570", angle(45))
graph save 1.gph, replace

hist ln_deaths if e(sample), freq subtitle(, lc(black)) xtitle ("Logged Number of People Killed") ///
	scheme(plotplainblind)
graph save 2.gph, replace

graph combine 1.gph 2.gph
graph export graph_deaths_appendix.png, width(2000) replace



********************************************************************************
*Figure 5: UN-Sample, diaspora*distance

tobit ln_total_aid c.ln_dis##c.ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)

margins, dydx(ln_diaspora_ipo) at(ln_dis=(5.209486 5.966147 7.003066 ///
	8.002694 8.500047 9.000237 9.500245 9.895204)) vsquish
	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Distance Donor-Recipient in km (Logged Scale)") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") ///
	xlabel(`=5.209486' "183" `=5.966147' "390" `=7.003066' "1,100" ///
	`=8.002694' "2,989" `=8.500047' "4,915" `=9.000237' "8,105" `=9.500245' ///
	"13,363" `=9.895204' "19,835", angle(45))
graph save 1.gph, replace

hist ln_dis if e(sample), freq subtitle(, lc(black)) xtitle ("Logged Distance") ///
	scheme(plotplainblind)
graph save 2.gph, replace

graph combine 1.gph 2.gph
graph export graph_dist_appendix.png, width(2000) replace



********************************************************************************
*Figure 6: OECD-Sample, diaspora*number of people affected

clear
use oecd_sample

tobit ln_sum_aid c.ln_allaffected##c.ln_diaspora_ipo ln_alldeaths ///
	cep_colony cep_comlang_off defense ln_flow_b ln_dis ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
	
margins, dydx(ln_diaspora_ipo) at(ln_allaffected=(0 2.079442 4.077538 6.001415 ///
	8.006368 10.00713 12.00006 13.0011 15.10335 17.05031 19.65041)) vsquish
	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Number of People Affected (Logged Scale)") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock (95% CIs)") ///
	xlabel(`=0' "0" `=2.079442' "7" `=4.077538' "58" `=6.001415' "403" ///
	`=8.006368' "2,999" `=10.00713' "22,183" `=12.00006' "162,763" `=13.0011' "442,900" ///
	`=15.10335' "3,624,958" `=17.05031' "2.54e+07" `=19.65041' "3.42e+08", angle(45))
graph save 1.gph, replace


hist ln_allaffected if e(sample), freq subtitle(, lc(black)) xtitle ("Logged Nr. of Affected") ///
	scheme(plotplainblind)
graph save 2.gph, replace

graph combine 1.gph 2.gph
graph export graph_affected_oecd_appendix.png, width(2000) replace


********************************************************************************
*Figure 7: OECD-Sample, diaspora*number of people killed by disaster

tobit ln_sum_aid c.ln_alldeaths##c.ln_diaspora_ipo ln_allaffected ///
	cep_colony cep_comlang_off defense ln_flow_b ln_dis ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
	
margins, dydx(ln_diaspora_ipo) at(ln_alldeaths=(0 1.098612 2.079442 3.044523 ///
	4.007333 5.003946 6.003887 7.002156 8.001355 9.034796 10.04329 11.21459 ///
	12.61154)) vsquish
	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Number of People Killed (Logged Scale)") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock (95% CIs)") ///
	xlabel(`=0' "0" `=1.098612' "2" `=2.079442' "7" `=3.044523' "20" ///
	`=4.007333' "54" `=5.003946' "148" `=6.003887' "404" `=7.002156' "1,098" ///
	`=8.001355' "2,984" `=9.034796' "8,389" `=10.04329' "23,000" `=11.21459' "74,204" ///
	`=12.61154' "300,000", angle(45))
graph save 1.gph, replace

hist ln_alldeaths if e(sample), freq subtitle(, lc(black)) xtitle ("Logged Nr. of People Killed") ///
	scheme(plotplainblind)
graph save 2.gph, replace

graph combine 1.gph 2.gph
graph export graph_deaths_oecd_appendix.png, width(2000) replace



********************************************************************************
********************************************************************************
*Table 4, OECD data
********************************************************************************
********************************************************************************


clear
use oecd_sample

tsset dyadid year

********************************************************************************
*Model 6 -- OECD, Logit

eststo clear

logit aid_dummy ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, cluster(dyadid) 


estpost margins, dydx(ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) 
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 122, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3143, replace

eststo margins_6


********************************************************************************
*Model 7 -- OECD, Tobit, IAB Diaspora measure

tobit ln_sum_aid ln_brain_drain_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
estpost margins, dydx(ln_brain_drain_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 19, replace

codebook code_rec if e(sample)
	
estadd scalar Recipients = 130, replace
codebook dyadid if e(sample)
estadd scalar Dyads = 2450, replace

eststo margins_7		


********************************************************************************
*Model 8 -- OECD, Tobit, + refugees

tobit ln_sum_aid ln_diaspora_ipo ln_refugees_lasso ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim)  


estpost margins, dydx(ln_diaspora_ipo ln_refugees_lasso ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 131, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3373, replace

eststo margins_8


********************************************************************************
*Model 9 -- OECD, Tobit, diaspora share in donor population

tobit ln_sum_aid ln_share1000 ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim)  

estpost margins, dydx(ln_share1000 ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 130, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3347, replace

eststo margins_9


********************************************************************************
*Model 10 -- OECD, Tobit, control for total aid received

tobit ln_sum_aid ln_diaspora_ipo ln_alldeaths ln_allaffected ln_abs_aid ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
estpost margins, dydx(ln_diaspora_ipo ln_alldeaths ln_allaffected ln_abs_aid ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 131, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3373, replace
	
eststo margins_10


********************************************************************************
*Model 11, Tobit, Foreign Aid Pre-/Post-Disaster

tsset dyadid year

*Time Dummy
gen time=.

*post: year of disaster and year after
replace time=1 if disaster_dummy==1
replace time=1 if L.disaster_dummy==1
codebook time, m

*pre: the 2 years before a disaster
replace time=0 if F.disaster_dummy==1 & time==.
replace time=0 if F2.disaster_dummy==1 & time==.
codebook time, m

label var time "Post Disaster"
label define time 1 "Post Disaster" 0 "Pre Disaster"

*Disaster impact
replace ln_alldeaths=0 if ln_alldeaths==.
replace ln_allaffected=0 if ln_allaffected==.

*interaction term
gen time_diaspora=time*ln_diaspora_ipo
label var time_diaspora "Post Disaster*Diaspora"


tobit ln_total_aid ln_diaspora_ipo time time_diaspora ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim)
	
	
estpost margins, dydx(ln_diaspora_ipo time time_diaspora ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) predict(ystar(0,.))
	
		
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 131, replace

codebook dyadid if e(sample)
estadd scalar Dyads = 3373, replace

eststo margins_11

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)

esttab margins_6 margins_7 margins_8 margins_9 margins_10 margins_11 using appendix_oecd.tex, replace ///
	nonumbers mtitles("M6 (Logit)" "M7 (Tobit)" "M8 (Tobit)" ///
	"M9 (Tobit)" "M10 (Tobit)" "M11 (Tobit)") ///
	label b(3) star(* 0.1 ** 0.05 *** 0.01) staraux booktabs ///
	title(Pooled Regression Models, Impact of Migrant Stocks on Aid Flows (OECD-Data)\label{table:oecdappendix})  ///
	se(3) obslast not pr2 stats(N Donors Recipients Dyads, fmt(0)) noomitted ///
	order(ln_diaspora_ipo ln_brain_drain_ipo ln_share1000 ///
	time time_diaspora ln_refugees_lasso ln_abs_aid ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) ///
	eqlabels(, none) noconstant nonotes ///
	addnotes("The dependent variable is the log of (1 plus) aid commitments from the donor to the recipient. Reported" ///
	"are marginal effects calculated as the effect on the latent variable multiplied by the probability of" ///
	"being uncensored (except for M6). All models include donor, recipient and year dummies; standard" ///
	"errors in parentheses. \sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")
	
	
	
********************************************************************************
*Figure 8: OECD-Sample, Model 11, Tobit, foreign aid pre- vs. post disaster

clear
use oecd_sample
tsset dyadid year


*Time Dummy
gen time=.

*post: year of disaster and year after
replace time=1 if disaster_dummy==1
replace time=1 if L.disaster_dummy==1
codebook time, m

*pre: the 2 year before a disaster
replace time=0 if F.disaster_dummy==1 & time==.
replace time=0 if F2.disaster_dummy==1 & time==.
codebook time, m

*Disaster impact
replace ln_alldeaths=0 if ln_alldeaths==.
replace ln_allaffected=0 if ln_allaffected==.



tobit ln_total_aid time##c.ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
quietly margins, at(ln_diaspora_ipo=(0(2)16) time=(0 1)) 

marginsplot, name(graph_5, replace) yline(0) subtitle(, lc(black)) ///
	xtitle ("Logged Migrant Stock") ///
	recast(line) recastci(rconnected) scheme(plotplainblind) ///
	legend(order(1 "Pre Disaster" 2 "Post Disaster")) 
	
graph export graph_5.png, width(2000) replace



********************************************************************************
********************************************************************************
*Table 5: UN-Sample
********************************************************************************
********************************************************************************

********************************************************************************
*Model 12 -- UN-Data, Logit

clear
use un_sample

eststo clear

logit total_dummy ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, vce(cluster dyadid)
	
estpost margins, dydx(ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec)
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace

codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_12


********************************************************************************
*Model 13 -- UN-Data, refugee control

tobit ln_total_aid ln_diaspora_ipo_2 ln_refugees_lasso ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)
	
estpost margins, dydx(ln_diaspora_ipo_2 ln_refugees_lasso ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace

codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_13


********************************************************************************
*Model 14 -- UN-Data, diaspora share

tobit ln_total_aid ln_share1000 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)
	
estpost margins, dydx(ln_share1000 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace

codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_14



********************************************************************************
*Model UN-Data -- FTS, total aid received

tobit ln_total_aid ln_diaspora_ipo_2 ln_abs_aid ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)
	
estpost margins, dydx(ln_diaspora_ipo_2 ln_abs_aid ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace

codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_15

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)

esttab margins_12 margins_13 margins_14 margins_15 using appendix_un.tex, replace ///
	nonumbers mtitles("M12 (Logit)" "M13 (Tobit)" "M14 (Tobit)" "M15 (Tobit)") ///
	label b(3) star(* 0.1 ** 0.05 *** 0.01) staraux booktabs ///
	title(Pooled Regression Models, Impact of Migrant Stocks on Aid Flows (UN-Data)\label{table:appendixun})  ///
	se(3) obslast not pr2 stats(N Donors Recipients Dyads, fmt(0)) noomitted ///
	order(ln_diaspora_ipo_2 ln_share1000 ln_refugees_lasso ln_abs_aid ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) eqlabels(, none) noconstant nonotes ///
	addnotes("The dependent variable is the log of (1 plus) emergency aid commitments from the donor to the recipient." ///
	"Reported are marginal effects calculated as the effect on the latent variable multiplied by the probability" ///
	"of being uncensored (except for M12). All models include donor, recipient, year and disaster-type dummies;" ///
	"robust standard errors clustered on dyads in parentheses. \sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")
	

	
********************************************************************************
********************************************************************************
*Table 6: OECD-Sample
********************************************************************************
********************************************************************************

clear
use oecd_sample
tsset dyadid year


********************************************************************************
*Model 16 -- OECD-Data, Aid/GDP Donor

eststo clear

tobit aid1 ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
estpost margins, dydx(ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 131, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3373, replace


eststo margins_16

********************************************************************************
*Model 17 -- OECD-Data, Tobit, Aid/GDP Rec

tobit aid2 ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
estpost margins, dydx(ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 131, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3373, replace

eststo margins_17		


********************************************************************************
*Model 18 -- OECD-Data, ReLogit


xi: relogit aid_dummy ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	if year>1989, cluster(dyadid) 


estpost margins, dydx(ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) 
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 131, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3373, replace

eststo margins_18


********************************************************************************
*Model 19 -- OECD-Data, PPML

xi: ppml x ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, cluster(dyadid) 


estpost margins, dydx(ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) 
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 122, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3143, replace

eststo margins_19

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)

esttab margins_16 margins_17 margins_18 margins_19 using appendix_dv_oecd.tex, replace ///
	nonumbers mtitles("M16 (Tobit)" "M17 (Tobit)" "M18 (ReLogit)" "M19 (PPML)") ///
	label b(3) star(* 0.1 ** 0.05 *** 0.01) staraux booktabs ///
	title(Pooled Regression Models, Impact of Migrant Stocks on Aid Flows (OECD-Data)\label{table:appendixdvoecd})  ///
	se(3) obslast not pr2 stats(N Donors Recipients Dyads, fmt(0)) noomitted ///
	order(ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) ///
	eqlabels(, none) noconstant nonotes ///
	addnotes("DV M16: Aid/Donor GDP*1000, M17: Aid/Recipient GDP*1000, M18: Binary," ///
	"M19: Aid (untransformed). Reported are marginal effects. All models include donor," ///
	"recipient and year dummies (except M18); standard errors in parentheses." ///
	"\sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")
	
	
********************************************************************************
********************************************************************************
*Table 7: UN-Data
********************************************************************************
********************************************************************************

clear
use un_sample

********************************************************************************
*Model 20 -- UN-Data, Aid/GDP Donor

eststo clear

tobit aid1 ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)
	
estpost margins, dydx(ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace


eststo margins_20

********************************************************************************
*Model 21 -- UN-Data, Tobit, Aid/GDP Rec

tobit aid2 ln_diaspora_ipo_2 ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) 
	
estpost margins, dydx(ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_21		


********************************************************************************
*Model 22 -- UN-Data, ReLogit


xi: relogit total_dummy ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	, cluster(dyadid)


estpost margins, dydx(ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) 
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_22


********************************************************************************
*Model 23 -- UN-Data, PPML

xi: ppml total_aid ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type


estpost margins, dydx(ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) 
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_23

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)

esttab margins_20 margins_21 margins_22 margins_23 using appendix_dv_un.tex, replace ///
	nonumbers mtitles("M20 (Tobit)" "M21 (Tobit)" "M22 (ReLogit)" "M23 (PPML)") ///
	label b(3) star(* 0.1 ** 0.05 *** 0.01) staraux booktabs ///
	title(Pooled Regression Models, Impact of Migrant Stocks on Aid Flows (UN-Data)\label{table:appendixdvun})  ///
	se(3) obslast not pr2 stats(N Donors Recipients Dyads, fmt(0)) noomitted ///
	order(ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) ///
	eqlabels(, none) noconstant nonotes ///
	addnotes("DV M20: Aid/Donor GDP*1000, M21: Aid/Recipient GDP*1000, M22: Binary," ///
	"M23: Aid (untransformed). Reported are marginal effects. All models include donor," ///
	"recipient and year dummies (except M22); standard errors in parentheses." ///
	"\sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")
	
	
	
********************************************************************************
*Figure 9: OECD-Data, Logit, distance interaction

clear
use oecd_sample
tsset dyadid year

logit aid_dummy c.ln_dis##c.ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989
	
margins, dydx(ln_diaspora_ipo) at(ln_dis=(4.127134 6.028278 7.003066 ///
	8.002694 8.500047 8.750208 9.000237 9.250138 9.500245 9.881497)) vsquish
	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Distance Donor-Recipient in km (Logged Scale)") ///
	ytitle("Effects on Probability(Emergency Aid)") scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") ///
	xlabel(`=4.127134' "62" `=6.028278' "415" `=7.003066' "1,100" ///
	`=8.002694' "2,989" `=8.500047' "4,915" ///
	`=8.750208' "6,312" `=9.000237' "8,105" `=9.250138' "10,406" ///
	`=9.500245' "13,363" `=9.881497' "19,565", angle(45))
graph export graph_1_logit_new.png, width(2000) replace




********************************************************************************
*Figure 10: UN-Sample, Logit, diaspora*people affected by disaster	

clear
use un_sample

logit total_dummy c.ln_affected##c.ln_diaspora_ipo_2 ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, vce(cluster dyadid)
	
margins, dydx(ln_diaspora_ipo_2) at(ln_affected=(0 2.564949 4.59512 7.013016 9.036106 ///
	11.00212 13.017 15.05332 16.951 18.86489)) vsquish
	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Number of People Affected (Logged Scale)") ///
	ytitle("Effects on Probability(Emergency Aid)") scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") ///
	xlabel(`=0' "0" `=2.564949' "12" `=4.59512' "98" ///
	`=7.013016' "1,110" `=9.036106' "8,400" ///
	`=11.00212' "60,000" `=13.017' "450,000" `=15.05332' "3,448,100" ///
	`=16.951' "2.30e+07" `=18.86489' "1.56e+08", angle(45))
graph export graph_2_logit_new.png, width(2000) replace	
	

********************************************************************************
*Figure 11: UN-Sample, Logit, diaspora*host country regime type	

logit total_dummy c.polity_don##c.ln_diaspora_ipo_2 ln_affected ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, vce(cluster dyadid)
	
margins, dydx(ln_diaspora_ipo_2) at(polity_don=(-10(2)10)) vsquish

marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Host Country Democracy Score") ///
	ytitle("Effects on Probability(Emergency Aid)") scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") 
graph export graph_3_logit_new.png, width(2000) replace



********************************************************************************
********************************************************************************
*Table 8: Impact of Migrant Stocks on U.S. News Reports and Aid Flows
********************************************************************************
********************************************************************************


clear
use olympic
set matsize 5000


label var dnews "News Reporting"
label var ft3 "News Pressure"
label var ln_migrants_ipo "Diaspora"
label var ln_brain_drain_ipo "Diaspora"
label var ln_gdppc "Recipient GDP p.c."
label var col "Common Official Language"
label var ln_dis "Distance"
label var ln_imports "U.S.-Imports"
label var ln_exports "U.S.-Exports"


gen interaction_2=ln_brain_drain_ipo*dnews
label var interaction_2 "News*Diaspora"

label var lkilled_imp "Deaths"
label var ltotaff_imp "Affected"


eststo clear

********************************************************************************
*M24) News on Diaspora and News Pressure

xi: logit dnews ln_brain_drain_ipo ft3 lkilled_imp ltotaff_imp ln_gdppc ///
	i.killed0 i.affected0 i.distype i.month i.country, robust

estpost margins, dydx(ln_brain_drain_ipo ft3 lkilled_imp ltotaff_imp ln_gdppc)

codebook country if e(sample)
estadd scalar Recipients = 67, replace

codebook year if e(sample)
estadd scalar Years = 23, replace

eststo margins_24


********************************************************************************
*25) Relief on News

xi: logit dcost ln_brain_drain_ipo dnews ft3 lkilled_imp ltotaff_imp ln_gdppc ///
	i.killed0 i.affected0 i.distype  i.month i.country, robust

estpost margins, dydx(ln_brain_drain_ipo dnews ft3 lkilled_imp ltotaff_imp ln_gdppc)
	
codebook country if e(sample)
estadd scalar Recipients = 115, replace

codebook year if e(sample)
estadd scalar Years = 23, replace

eststo margins_25

********************************************************************************
*26) Relief on News*Diaspora

xi: logit dcost ln_brain_drain_ipo dnews interaction_2 ft3 lkilled_imp ltotaff_imp ln_gdppc ///
	i.killed0 i.affected0 i.distype i.month  i.country, robust

estpost margins, dydx(ln_brain_drain_ipo dnews interaction_2 ft3 lkilled_imp ltotaff_imp ln_gdppc)

codebook country if e(sample)
estadd scalar Recipients = 115, replace

codebook year if e(sample)
estadd scalar Years = 23, replace
	
eststo margins_26

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)

esttab margins_24 margins_25 margins_26 using media_table.tex, replace ///
	nonumbers mtitles("M24 (DV: News Report)" "M25 (DV: Aid Flow)" "M26 (DV: Aid Flow)") ///
	label b(3) star(* 0.1 ** 0.05 *** 0.01) staraux booktabs ///
	title(Pooled Logit Models, Impact of Migrant Stocks on U.S. News Reports and Aid Flows\label{table:media})  ///
	se(3) obslast not pr2 stats(N Recipients Years, fmt(0)) noomitted ///
	order(ln_brain_drain_ipo dnews interaction_2 ft3 lkilled_imp ltotaff_imp ln_gdppc) ///
	eqlabels(, none) noconstant nonotes ///
	addnotes("Coefficients show marginal effects, robust standard errors in parentheses." ///
	"All models include recipient country, month and disaster-type fixed effects," ///
	"as well as fixed effects for the interaction of missing values on Deaths and Affected" ///
	"with disaster type. \sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")
	

********************************************************************************
*Figure 12: news report*migrant stock

xi: logit dcost dnews##c.ln_brain_drain_ipo ft3 lkilled_imp ltotaff_imp ln_gdppc ///
	i.killed0 i.affected0 i.distype i.month  i.country, robust


quietly margins, at(ln_brain_drain_ipo=(0 2.028148 4.025352 6.041207 ///
	8.001221 10.00175 12.00672 14.03827 14.87855) dnews=(0 1))
	
marginsplot, level(95) ///
	bydimension(dnews, elabel(1 "No News Report of Disaster" ///
	2 "News Report of Disaster" ///
	)) subtitle(, lc(black))  xtitle ("Migrant Stock (Logged Scale)") ///
	recast(line) recastci(rconnected) scheme(plotplainblind) ///
	ytitle(Pr(U.S. Aid Flow)) ///
	xlabel(`=0' "0" `=2.028148' "7" `=4.025352' "55" `=6.041207' "419" ///
	`=8.001221' "2,984" `=10.00175' "22,064" `=12.00672' "163,852" ///
	`=14.03827' "1,249,513" `=14.87855' "2,895,160", angle(45))
graph export graph_8_new.png, width(2000) replace


********************************************************************************
log close
	

