
*set working directory
*cd ""


log using Diasporas_Disasters_Table, text replace


********************************************************************************
*
* Replication Material for:
*
* No Calm After the Storm -- Diaspora Influence on Bilateral Emergency Aid Flows                                                                           *
*
* Hendrik Platte
*
* Version: April 12, 2019
*
* Calculations were done with Stata SE 14.2
*
* Address Correspondence to: hendrik.platte@uni-konstanz.de
*
********************************************************************************



********************************************************************************
*Table 1
********************************************************************************

clear
use oecd_sample
set matsize 5000

tsset dyadid year

*labels
label var ln_diaspora_ipo "Diaspora"
label var ln_alldeaths "Deaths"
label var ln_allaffected "Affected"
label var ln_dis "Distance"
label var ln_flow_b "Exports Donor to Recipient"
label var ln_population_don "Population Donor"
label var ln_gdppc_don "GDP p.c. Donor"
label var ln_population_rec "Population Recipient"
label var ln_gdppc_rec "GDP p.c. Recipient"

********************************************************************************
*Model 1

tobit ln_sum_aid ln_diaspora_ipo ln_alldeaths ln_allaffected ///
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


eststo margins_1		

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)


********************************************************************************
*Model 2 

clear
use un_sample

*labels
label var ln_total_aid "Emergency Aid"
label var ln_diaspora_ipo_2 "Diaspora"
label var ln_deaths "Deaths"
label var ln_affected "Affected"
label var ln_dis "Distance"
label var ln_flow_b "Exports Donor to Recipient"
label var polity_don "Democracy Donor"
label var polity_rec "Democracy Recipient"
label var ln_population_don "Population Donor"
label var ln_gdppc_don "GDP p.c. Donor"
label var ln_population_rec "Population Recipient"
label var ln_gdppc_rec "GDP p.c. Recipient"


tobit ln_total_aid ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) 
	
estpost margins, dydx(ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace

codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_2
	
estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)

	
********************************************************************************
*Model 3 

clear
use oecd_sample

tsset dyadid year

*labels
label var ln_diaspora_ipo "Diaspora"
label var ln_alldeaths "Deaths"
label var ln_allaffected "Affected"
label var ln_dis "Distance"
label var ln_flow_b "Exports Donor to Recipient"
label var ln_population_don "Population Donor"
label var ln_gdppc_don "GDP p.c. Donor"
label var ln_population_rec "Population Recipient"
label var ln_gdppc_rec "GDP p.c. Recipient"


gen dist_inter=ln_dis*ln_diaspora_ipo
label var dist_inter "Distance*Diaspora"


tobit ln_sum_aid ln_diaspora_ipo dist_inter ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 
	

estpost margins, dydx(ln_diaspora_ipo dist_inter ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 26, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 131, replace
	
codebook dyadid if e(sample)
estadd scalar Dyads = 3373, replace

eststo margins_3

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)


********************************************************************************
*Model 4 

clear
use un_sample


*labels
label var ln_total_aid "Emergency Aid"
label var ln_diaspora_ipo_2 "Diaspora"
label var ln_deaths "Deaths"
label var ln_affected "Affected"
label var ln_dis "Distance"
label var ln_flow_b "Exports Donor to Recipient"
label var polity_don "Democracy Donor"
label var polity_rec "Democracy Recipient"
label var ln_population_don "Population Donor"
label var ln_gdppc_don "GDP p.c. Donor"
label var ln_population_rec "Population Recipient"
label var ln_gdppc_rec "GDP p.c. Recipient"

gen affected_inter=ln_affected*ln_diaspora_ipo_2
label var affected_inter "Affected*Diaspora"


tobit ln_total_aid ln_diaspora_ipo_2 affected_inter ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) 
	
estpost margins, dydx(ln_diaspora_ipo_2 affected_inter ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace

codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_4

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)


********************************************************************************
*Model 5


gen polity_don_inter=polity_don*ln_diaspora_ipo_2
label var polity_don_inter "Democracy Donor*Diaspora"


tobit ln_total_aid ln_diaspora_ipo_2 polity_don_inter ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) 
	
estpost margins, dydx(ln_diaspora_ipo_2 polity_don_inter ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) predict(ystar(0,.))
	
codebook code_don if e(sample)
estadd scalar Donors = 44, replace

codebook code_rec if e(sample)
estadd scalar Recipients = 78, replace

codebook dyadid if e(sample)
estadd scalar Dyads = 3351, replace

eststo margins_5

estout, cells(b(star fmt(3)) se(par fmt(2))) stats( N) starlevels(* 0.10 ** 0.05 *** 0.01)

*export to tex-file
esttab margins_1 margins_2 margins_3 margins_4 margins_5 using psrm_table.tex, replace ///
	nonumbers mtitles("M1 (OECD)" "M2 (UN)" "M3 (OECD)" "M4 (UN)" "M5 (UN)") ///
	label b(3) star(* 0.1 ** 0.05 *** 0.01) staraux booktabs ///
	title(Pooled Tobit Models, Impact of Migrant Stocks on Aid Flows\label{table:psrm})  ///
	se(3) obslast not pr2 stats(N Donors Recipients Dyads, fmt(0)) noomitted ///
	order(ln_diaspora_ipo ln_diaspora_ipo_2 ln_alldeaths ln_deaths ln_allaffected ln_affected affected_inter ///
	cep_colony cep_comlang_off defense ln_dis dist_inter ln_flow_b polity_don polity_don_inter polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec) eqlabels(, none) noconstant nonotes ///
	addnotes("The dependent variable is the log of (1 plus) emergency aid commitments from the donor to the recipient." ///
	"Reported are marginal effects calculated as the effect on the latent variable multiplied by the probability of being uncensored." ///
	"All models include donor, recipient and year dummies (M2, M4 and M5 additionally disaster-type dummies), standard errors in parentheses." ///
	"\sym{*} \(p<0.1\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")
	
********************************************************************************
*Table 2
********************************************************************************
	
	
*the moreClarify Software needs to be installed
*running the moreClarify commands consecutively in a single do file may produce error messages
*in that case, please run the commands seperately
ssc install more_clarify


clear
use oecd_sample


********************************************************************************
*Model 1

tobit ln_sum_aid ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim)

sum ln_diaspora_ipo

sum ln_diaspora_ipo if e(sample)
*mean: 5.605116   
*SD: 3.330387

postsim, saving(clarify, replace): tobit ln_sum_aid ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim) 

preserve 
use clarify, clear
sum

*mean + 1SD	
simqoi using clarify, ev at((mean) _all ln_diaspora_ipo=(5.605116 8.935503))
*-37.75093
*-36.84007

*calculate percentage change
dis (-36.84007-(-37.75093))/37.75093*100
*+2.41%


********************************************************************************
*Model 2

clear
use un_sample

tobit ln_total_aid ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0)
	
sum ln_diaspora_ipo_2

sum ln_diaspora_ipo_2 if e(sample)
*mean: 5.056693   
*SD: 3.719534

postsim, saving(clarify, replace): tobit ln_total_aid ln_diaspora_ipo_2 ln_deaths ln_affected ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) 
	
	
preserve 
use clarify, clear
sum



*mean + 1SD	-- e(sample)
simqoi using clarify, ev at((mean) _all ln_diaspora_ipo_2=(5.056693 8.776227))
*-22.43028
*-20.5437

*calculate percentage change
dis (-20.5437-(-22.43028))/22.43028*100
*+8.41%

********************************************************************************
*Model 3

clear
use oecd_sample

tsset dyadid year

tobit ln_sum_aid c.ln_dis##c.ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim)
	
	
sum ln_diaspora_ipo

sum ln_diaspora_ipo if e(sample)
*mean: 5.605116   
*SD: 3.330387

sum ln_dis
sum ln_dis if e(sample)
codebook ln_dis if e(sample)

postsim, saving(clarify, replace): tobit ln_sum_aid c.ln_dis##c.ln_diaspora_ipo ln_alldeaths ln_allaffected ///
	cep_colony cep_comlang_off defense ln_flow_b ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec polity_rec ///
	i.code_don i.code_rec i.year if year>1989, ll(0) vce(oim)

preserve 
use clarify, clear
sum

*mean + 1SD	
simqoi using clarify, ev at((mean) _all ln_diaspora_ipo=(5.605116 8.935503) ln_dis=4.1271343)
*-19.25102
*-20.45688

*calculate percentage change
dis (-20.45688-(-19.25102))/19.25102*100
*-6.26%

simqoi using clarify, ev at((mean) _all ln_diaspora_ipo=(5.605116 8.935503) ln_dis=9.8814974)
*-42.47914
*-41.0086

*calculate percentage change
dis (-41.0086-(-42.47914))/42.47914*100
*+3.46


********************************************************************************
*Model 4

clear
use un_sample

tobit ln_total_aid c.ln_affected##c.ln_diaspora_ipo_2 ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0)

sum ln_diaspora_ipo_2

sum ln_diaspora_ipo_2 if e(sample)
*mean: 5.056693    
*SD: 3.719534

postsim, saving(clarify, replace): tobit ln_total_aid c.ln_affected##c.ln_diaspora_ipo_2 ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b ///
	polity_don polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) 
	

preserve 
use clarify, clear
sum

*mean + 1SD	
simqoi using clarify, ev at((mean) _all ln_diaspora_ipo_2=(5.056693 8.776227) ln_affected=0)
*-24.84512
*-19.45854

*calculate percentage change
dis (-19.45854-(-24.84512))/24.84512*100
*+21.68%

simqoi using clarify, ev at((mean) _all ln_diaspora_ipo_2=(5.056693 8.776227) ln_affected=18.864885)
*-21.31318
*-20.94506
*+1.73%


********************************************************************************
*Model 5


postsim, saving(clarify, replace): tobit ln_total_aid c.polity_don##c.ln_diaspora_ipo_2 ln_affected ln_deaths ///
	cep_colony cep_comlang_off defense ln_dis ln_flow_b polity_rec ///
	ln_population_don ln_gdppc_don ln_population_rec ln_gdppc_rec ///
	i.code_don i.code_rec i.year i.disaster_type, ll(0) vce(cluster dyadid)
	
preserve 
use clarify, clear
sum


*mean + 1SD	
simqoi using clarify, ev at((mean) _all ln_diaspora_ipo_2=(5.056693 8.776227) polity_don=-10)
*-29.17659
*-26.17323

*calculate percentage change
dis (-26.17323-(-29.17659))/29.17659*100
*+10.29%

simqoi using clarify, ev at((mean) _all ln_diaspora_ipo_2=(5.056693 8.776227) polity_don=10)
*-21.90333
*-20.76739

*calculate percentage change
dis (-20.76739-(-21.90333))/21.90333*100
*+5.19

********************************************************************************
log close
	
