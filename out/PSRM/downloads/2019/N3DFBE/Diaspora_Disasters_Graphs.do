

log using Diasporas_Disasters_Graphs, text replace

********************************************************************************
*Model 3 -- OECD Data, diaspora*distance


clear
use oecd_sample
set matsize 5000

tsset dyadid year

tobit ln_sum_aid c.ln_dis##c.ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	
	
codebook ln_dis

margins, dydx(ln_diaspora_ipo) at(ln_dis=(4(1)10)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(95) 

marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Logged Distance Donor-Recipient") ///
	scheme(plotplainblind) ///
	ytitle(Predicted log(Bilateral Aid Commitments)) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") 


margins, dydx(ln_diaspora_ipo) at(ln_dis=(4.127134 6.028278 7.003066 ///
	8.002694 8.500047 8.750208 9.000237 9.250138 9.500245 9.881497)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(95) 

marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Distance Donor-Recipient in km (Logged Scale)") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") ///
	xlabel(`=4.127134' "62" `=6.028278' "415" `=7.003066' "1,100" ///
	`=8.002694' "2,989" `=8.500047' "4,915" ///
	`=8.750208' "6,312" `=9.000237' "8,105" `=9.250138' "10,406" ///
	`=9.500245' "13,363" `=9.881497' "19,565", angle(45))

graph export graph_1.png, width(2000) replace

********************************************************************************
*Model 4 -- diaspora*severity

clear
use un_sample
set matsize 5000


tobit ln_total_aid c.ln_affected##c.ln_diaspora_ipo_2 ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0)
	
codebook ln_affected

margins, dydx(ln_diaspora_ipo_2) at(ln_affected=(0(2)18)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(95) 

margins, dydx(ln_diaspora_ipo_2) at(ln_affected=(0 2.564949 4.59512 7.013016 9.036106 ///
	11.00212 13.017 15.05332 16.951 18.86489)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(95) 

	
marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Number of People Affected (Logged Scale)") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") ///
	xlabel(`=0' "0" `=2.564949' "12" `=4.59512' "98" ///
	`=7.013016' "1,110" `=9.036106' "8,400" ///
	`=11.00212' "60,000" `=13.017' "450,000" `=15.05332' "3,448,100" ///
	`=16.951' "2.30e+07" `=18.86489' "1.56e+08", angle(45))

graph export graph_2.png, width(2000) replace

********************************************************************************
*Model 5 -- diaspora*host country regime type	

tobit ln_total_aid c.polity_don##c.ln_diaspora_ipo_2 ln_affected ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) 
	
codebook polity_don

margins, dydx(ln_diaspora_ipo_2) at(polity_don=(-10(2)10)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(95) 


marginsplot, recast(line) recastci(rconnected) yline(0) level(95) ///
	subtitle(, lc(black)) ///
	xtitle ("Host Country Democracy Score") ///
	scheme(plotplainblind) ///
	title("Average Marginal Effect of Logged Migrant Stock with 95% CIs") 

graph export graph_3.png, width(2000) replace

********************************************************************************
log close

