* Stata replication file for Appointments and Attrition: Time and Executive Disadvantage in the Appointments Process
* By Gary E. Hollibaugh, Jr. and Lawrence S. Rothenberg
* Corresponding Email: gary.hollibaugh@pitt.edu


* need to install estout to use esttab for the purposes of saving the CSV files
ssc install estout

* load the file; make sure you're in the correct working directory
use "vacanciesJPP.dta", clear

* create temporal variables
gen year_in_vacancy = day_in_vacancy/365
gen year_in_congress = 2 - days_left_in_congress/365
gen year_in_term = day_in_admin/365.25
replace year_in_term = year_in_term - 4 if year_in_term > 4

gen firstterm = 1 if year_in_admin <= 4
replace firstterm = 0 if year_in_admin > 4

gen years_remaining_in_term = 4 - year_in_admin if firstterm == 1
replace years_remaining_in_term = 8 - year_in_admin if firstterm == 0

gen firstyear = 0
replace firstyear = 1 if year_in_admin < 2


* log the ideological divergences to reduce skew
gen log_cfscore_presdiff = log(abs(cfscore - president_CF))
gen log_cfscore_fildiff = log(abs(cfscore - filibuster_CF))
gen cfscore_diff = abs(cfscore - president_CF) - abs(cfscore - filibuster_CF)


* create commission variables based on selin's coding
decode subagency, gen(subagency_str)
gen commission = 0
replace commission = 1 if strpos(subagency_str, "Commodity Credit Corporation") > 0
replace commission = 1 if strpos(subagency_str, "Corporation for National") > 0
replace commission = 1 if strpos(subagency_str, "Equal Employment Opportunity Commission") > 0
replace commission = 1 if strpos(subagency_str, "Export-Import Bank") > 0
replace commission = 1 if strpos(subagency_str, "Federal Labor Relations Authority") > 0
replace commission = 1 if strpos(subagency_str, "Foreign Claims Settlement Commission") > 0
replace commission = 1 if strpos(subagency_str, "IRS Oversight Board") > 0
replace commission = 1 if strpos(subagency_str, "Institute of Education Sciences") > 0
replace commission = 1 if strpos(subagency_str, "National Indian Gaming Commission") > 0
replace commission = 1 if strpos(subagency_str, "National Labor Relations Board") > 0
replace commission = 1 if strpos(subagency_str, "National Science Foundation") > 0
replace commission = 1 if strpos(subagency_str, "Overseas Private Investment Corporation") > 0
replace commission = 1 if strpos(subagency_str, "Postal Rate Commission") > 0
replace commission = 1 if strpos(subagency_str, "Postal Regulatory Commission") > 0
  

* label variables for the purposes of creating tables
label variable year_in_vacancy "Year in Vacancy"
label variable year_in_congress "Year in Congress"
label variable year_in_term "Year in Term"
label variable years_remaining_in_term "Years Remaining in Term"
label variable pres_filibuster_diff "President-Filibuster Distance"
label variable divided "Divided Government"
label variable tier_one "Tier One Position"
label variable tier_two "Tier Two Position"
label variable pres_approval "Presidential Approval"
label variable spellnumber "Nomination Attempt"
label variable firstterm "President's First Term"
label variable agriculture "Agriculture"
label variable commerce "Commerce"
label variable justice "Justice"
label variable labor "Labor"
label variable natl_security "National Security"
label variable social_welfare "Social Welfare"
label variable infrastructure "Infrastructure"
label variable nondepartmental "Nondepartmental"
label variable roll_calls "Senate Workload"
label variable active_noms "Number of Pending Nominations"
label variable pres_agency_agree "President-Agency Agreement"


* Table 1 models
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3

esttab m1 m2 m3 using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/Table1.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")


	
*** Figure 1 	
* Generate standardized main independent variables for ease of interpretation
egen zlog_cfscore_presdiff = std(log_cfscore_presdiff)
egen zlog_cfscore_fildiff = std(log_cfscore_fildiff)
egen zcfscore_diff = std(cfscore_diff)
egen zpres_filibuster_diff = std(pres_filibuster_diff)
egen zpres_approval = std(pres_approval)

label variable zpres_filibuster_diff "President-Filibuster Distance"
label variable zpres_approval "Presidential Approval"


* Estimate models	
heckman zlog_cfscore_presdiff year_in_vacancy year_in_congress c.zpres_filibuster_diff##c.divided tier_one ///
	tier_two zpres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.zpres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two zpres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store presmod

heckman zlog_cfscore_fildiff year_in_vacancy year_in_congress c.zpres_filibuster_diff##c.divided tier_one ///
	tier_two zpres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.zpres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two zpres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store filmod

heckman zcfscore_diff year_in_vacancy year_in_congress c.zpres_filibuster_diff##c.divided tier_one ///
	tier_two zpres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.zpres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two zpres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store relmod

* Plot
coefplot (presmod, label(`""Logged President-" "Nominee Divergence""')) ///
	(filmod, label(`""Logged Filibuster-" "Nominee Divergence""')) ///
	(relmod, label(Relative Divergence)),  ciopts(recast(. rcap)) msize(1) ///
	coeflabels(c.zpres_filibuster_diff#c.divided = "Pres.-Fil. Dist. × Divided Gov't", interaction(" × ")) ///
	xline(0, lpattern("shortdash") lcolor("gs12")) byopts(yrescale xrescale) levels(95 90) ///
	drop(_cons) ///
	scheme(s1mono) ///
	headings( ///
	year_in_vacancy = "{bf:Temporal Variables}" ///
	zpres_filibuster_diff  = "{bf:Partisan/Ideological Variables}" ///
	tier_one = "{bf:Control Variables}") legend(cols(1)) ysize(11) graphregion(margin(l=51.5)) ///
	xtitle("Standardized Coefficient")
graph export "Figure1.pdf", replace
	
	

	

*** Models in Appendix

* Table A-1
regress log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if nomination_sent == 1 & in_vacancy == 1, vce(cluster spell_id)
estimates store m1a
	
regress log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if nomination_sent == 1 & in_vacancy == 1,	vce(cluster spell_id)
estimates store m2a	
	
regress cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if nomination_sent == 1 & in_vacancy == 1,	vce(cluster spell_id)
estimates store m3a

esttab m1a m2a m3a using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA1.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(F r2 N, fmt(3 3 0) ///
	labels("F Statistic" "R-Squared" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	

* Table A-2
regress log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if nomination_sent == 1 & in_vacancy == 1, vce(cluster spell_id)
estimates store m4a
	
regress log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if nomination_sent == 1 & in_vacancy == 1, vce(cluster spell_id)
estimates store m5a	
	
regress cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if nomination_sent == 1 & in_vacancy == 1, vce(cluster spell_id)
estimates store m6a

esttab m4a m5a m6a using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA2.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(F r2 N, fmt(3 3 0) ///
	labels("F Statistic" "R-Squared" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	

* Table A-3
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m4	
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m5	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m6

esttab m4 m5 m6 using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA3.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")	

	
* Table A-4		
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & partybalancing != 1 & multimember != 1, ///
	select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1a	

heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & partybalancing != 1 & multimember != 1, ///
	select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2a
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & partybalancing != 1 & multimember != 1, ///
	select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3a
		

esttab m1a m2a m3a using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA4.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
		

* Table A-5
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1 & partybalancing != 1 & multimember != 1, ///
	select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m4b	
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1 & partybalancing != 1 & multimember != 1, ///
	select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m5b	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1 & partybalancing != 1 & multimember != 1, ///
	select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m6b


esttab m4b m5b m6b using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA5.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
		
		
* Table A-6			
heckman log_cfscore_presdiff year_in_vacancy year_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_term ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1b	
	
heckman log_cfscore_fildiff year_in_vacancy year_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_term ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2b	
	
heckman cfscore_diff year_in_vacancy year_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_term ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3b

esttab m1b m2b m3b using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA6.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")

	
* Table A-7
heckman log_cfscore_presdiff year_in_vacancy year_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = year_in_vacancy year_in_term ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m4b	
	
heckman log_cfscore_fildiff year_in_vacancy year_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = year_in_vacancy year_in_term ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m5b	
	
heckman cfscore_diff year_in_vacancy year_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval pres_agency_agree spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = year_in_vacancy year_in_term ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval pres_agency_agree spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m6b


esttab m4b m5b m6b using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA7.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
		
		
* Tables A-8a and A-8b (marginal effects are in A-8b, and the saved table is A-8a)
heckman log_cfscore_presdiff c.year_in_vacancy##c.tier_one c.year_in_congress##c.tier_one ///
	c.year_in_vacancy##c.tier_two c.year_in_congress##c.tier_two c.pres_filibuster_diff##c.divided ///
	pres_approval spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = c.year_in_vacancy##c.tier_one c.year_in_congress##c.tier_one ///
	c.year_in_vacancy##c.tier_two c.year_in_congress##c.tier_two c.pres_filibuster_diff##c.divided ///
	agriculture commerce  justice labor natl_security social_welfare infrastructure nondepartmental ///
	pres_approval spellnumber firstterm roll_calls active_noms) vce(cluster spell_id) 		
estimates store m1c
	
margins, dydx(year_in_vacancy) at(tier_one = (0 1) tier_two = (0 1)) vsquish
margins, dydx(year_in_congress) at(tier_one = (0 1) tier_two = (0 1)) vsquish
margins, dydx(year_in_vacancy) at(tier_one = (0 1) tier_two = (0 1)) predict(psel) vsquish
margins, dydx(year_in_congress) at(tier_one = (0 1) tier_two = (0 1)) predict(psel) vsquish
	
heckman log_cfscore_fildiff c.year_in_vacancy##c.tier_one c.year_in_congress##c.tier_one ///
	c.year_in_vacancy##c.tier_two c.year_in_congress##c.tier_two c.pres_filibuster_diff##c.divided ///
	pres_approval spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = c.year_in_vacancy##c.tier_one c.year_in_congress##c.tier_one ///
	c.year_in_vacancy##c.tier_two c.year_in_congress##c.tier_two c.pres_filibuster_diff##c.divided ///
	agriculture commerce  justice labor natl_security social_welfare infrastructure nondepartmental ///
	pres_approval spellnumber firstterm roll_calls active_noms) vce(cluster spell_id) 		
estimates store m2c
	
margins, dydx(year_in_vacancy) at(tier_one = (0 1) tier_two = (0 1)) vsquish
margins, dydx(year_in_congress) at(tier_one = (0 1) tier_two = (0 1)) vsquish
margins, dydx(year_in_vacancy) at(tier_one = (0 1) tier_two = (0 1)) predict(psel) vsquish
margins, dydx(year_in_congress) at(tier_one = (0 1) tier_two = (0 1)) predict(psel) vsquish
	
heckman cfscore_diff c.year_in_vacancy##c.tier_one c.year_in_congress##c.tier_one ///
	c.year_in_vacancy##c.tier_two c.year_in_congress##c.tier_two c.pres_filibuster_diff##c.divided ///
	pres_approval spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = c.year_in_vacancy##c.tier_one c.year_in_congress##c.tier_one ///
	c.year_in_vacancy##c.tier_two c.year_in_congress##c.tier_two c.pres_filibuster_diff##c.divided ///
	agriculture commerce  justice labor natl_security social_welfare infrastructure nondepartmental ///
	pres_approval spellnumber firstterm roll_calls active_noms) vce(cluster spell_id) 		
estimates store m3c
	
margins, dydx(year_in_vacancy) at(tier_one = (0 1) tier_two = (0 1)) vsquish
margins, dydx(year_in_congress) at(tier_one = (0 1) tier_two = (0 1)) vsquish
margins, dydx(year_in_vacancy) at(tier_one = (0 1) tier_two = (0 1)) predict(psel) vsquish
margins, dydx(year_in_congress) at(tier_one = (0 1) tier_two = (0 1)) predict(psel) vsquish
	
	
esttab m1c m2c m3c using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA8a.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	
	
* Tables A-9a and A-9b (marginal effects are in A-9b, and the saved table is A-9a)	
heckman log_cfscore_presdiff c.year_in_vacancy##c.pres_approval c.year_in_congress##c.pres_approval ///
	c.pres_filibuster_diff##c.divided tier_one tier_two ///
	spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = c.year_in_vacancy##c.pres_approval c.year_in_congress##c.pres_approval  ///
	c.pres_filibuster_diff##c.divided tier_one tier_two ///
	agriculture commerce  justice labor natl_security social_welfare infrastructure nondepartmental ///
	spellnumber firstterm roll_calls active_noms) vce(cluster spell_id) 		
estimates store m1d

margins, dydx(year_in_vacancy) at(pres_approval = (25 40 53 61 89)) vsquish
margins, dydx(year_in_congress) at(pres_approval = (25 40 53 61 89)) vsquish
margins, dydx(year_in_vacancy) at(pres_approval = (25 40 53 61 89)) predict(psel) vsquish
margins, dydx(year_in_congress) at(pres_approval = (25 40 53 61 89)) predict(psel) vsquish

	
heckman log_cfscore_fildiff c.year_in_vacancy##c.pres_approval c.year_in_congress##c.pres_approval ///
	c.pres_filibuster_diff##c.divided tier_one tier_two ///
	spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = c.year_in_vacancy##c.pres_approval c.year_in_congress##c.pres_approval  ///
	c.pres_filibuster_diff##c.divided tier_one tier_two  ///
	agriculture commerce  justice labor natl_security social_welfare infrastructure nondepartmental ///
	spellnumber firstterm roll_calls active_noms) vce(cluster spell_id) 		
estimates store m2d

margins, dydx(year_in_vacancy) at(pres_approval = (25 40 53 61 89)) vsquish
margins, dydx(year_in_congress) at(pres_approval = (25 40 53 61 89)) vsquish	
margins, dydx(year_in_vacancy) at(pres_approval = (25 40 53 61 89)) predict(psel) vsquish
margins, dydx(year_in_congress) at(pres_approval = (25 40 53 61 89)) predict(psel) vsquish

	
heckman cfscore_diff c.year_in_vacancy##c.pres_approval c.year_in_congress##c.pres_approval ///
	c.pres_filibuster_diff##c.divided tier_one tier_two ///
	spellnumber firstterm if in_vacancy == 1, ///
	select(nomination_sent = c.year_in_vacancy##c.pres_approval c.year_in_congress##c.pres_approval  ///
	c.pres_filibuster_diff##c.divided tier_one tier_two ///
	agriculture commerce  justice labor natl_security social_welfare infrastructure nondepartmental ///
	spellnumber firstterm roll_calls active_noms) vce(cluster spell_id) 		
estimates store m3d

margins, dydx(year_in_vacancy) at(pres_approval = (25 40 53 61 89)) vsquish
margins, dydx(year_in_congress) at(pres_approval = (25 40 53 61 89)) vsquish
margins, dydx(year_in_vacancy) at(pres_approval = (25 40 53 61 89)) predict(psel) vsquish
margins, dydx(year_in_congress) at(pres_approval = (25 40 53 61 89)) predict(psel) vsquish


esttab m1d m2d m3d using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA9a.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	
	
* Table A-10
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & in_recess == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1norecess	
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & in_recess == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2norecess		
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & in_recess == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3norecess	

esttab m1norecess m2norecess m3norecess using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA10.csv", ///
	replace label onecell cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	
	
* Table A-11
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided commission tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided commission agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1comm		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided commission tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided commission agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2comm	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided commission tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided commission agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3comm

esttab m1comm m2comm m3comm using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA11.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")

	
* Table A-12
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided date_since_recess agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m1recess		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided date_since_recess agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2recess	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided date_since_recess agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3recess


esttab m1recess m2recess m3recess using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA12.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	
	
* Table A-13
heckman log_cfscore_presdiff year_in_vacancy year_in_congress years_remaining_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	years_remaining_in_term c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) difficult
estimates store m1term		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress years_remaining_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	years_remaining_in_term c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2term	
	
heckman cfscore_diff year_in_vacancy year_in_congress years_remaining_in_term c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	years_remaining_in_term c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3term


esttab m1term m2term m3term using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA13.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
		

* Table A-14
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval c.pres_approval##c.divided spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval c.pres_approval##c.divided  spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) difficult
estimates store m1appdiv		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval c.pres_approval##c.divided spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval c.pres_approval##c.divided  spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2appdiv
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval c.pres_approval##c.divided spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval c.pres_approval##c.divided  spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3appdiv


esttab m1appdiv m2appdiv m3appdiv using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA14.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
		
		
* Table A-15
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & commission == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1nocomm		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & commission == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2nocomm	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & commission == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3nocomm

esttab m1nocomm m2nocomm m3nocomm using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA15.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")

		
* Table A-16, Column 1
corrci log_cfscore_presdiff roll_calls, level(90)
corrci log_cfscore_presdiff active_noms, level(90)
esize twosample  log_cfscore_presdiff, by(agriculture) pbc level(90)
esize twosample  log_cfscore_presdiff, by(commerce) pbc level(90)
esize twosample  log_cfscore_presdiff, by(justice) pbc level(90)
esize twosample  log_cfscore_presdiff, by(labor) pbc level(90)
esize twosample  log_cfscore_presdiff, by(natl_security) pbc level(90)
esize twosample  log_cfscore_presdiff, by(social_welfare) pbc level(90)	
esize twosample  log_cfscore_presdiff, by(infrastructure) pbc level(90)	
esize twosample  log_cfscore_presdiff, by(nondepartmental) pbc level(90)
				
* Table A-16, Column 2
corrci log_cfscore_fildiff roll_calls, level(90)
corrci log_cfscore_fildiff active_noms, level(90)
esize twosample  log_cfscore_fildiff, by(agriculture) pbc level(90)
esize twosample  log_cfscore_fildiff, by(commerce) pbc level(90)
esize twosample  log_cfscore_fildiff, by(justice) pbc level(90)
esize twosample  log_cfscore_fildiff, by(labor) pbc level(90)
esize twosample  log_cfscore_fildiff, by(natl_security) pbc level(90)
esize twosample  log_cfscore_fildiff, by(social_welfare) pbc level(90)	
esize twosample  log_cfscore_fildiff, by(infrastructure) pbc level(90)	
esize twosample  log_cfscore_fildiff, by(nondepartmental) pbc level(90)
		
* Table A-16, Column 3
corrci cfscore_diff roll_calls, level(90)
corrci cfscore_diff active_noms, level(90)
esize twosample  cfscore_diff, by(agriculture) pbc level(90)
esize twosample  cfscore_diff, by(commerce) pbc level(90)
esize twosample  cfscore_diff, by(justice) pbc level(90)
esize twosample  cfscore_diff, by(labor) pbc level(90)
esize twosample  cfscore_diff, by(natl_security) pbc level(90)
esize twosample  cfscore_diff, by(social_welfare) pbc level(90)	
esize twosample  cfscore_diff, by(infrastructure) pbc level(90)	
esize twosample  cfscore_diff, by(nondepartmental) pbc level(90)
		


* Table A-17
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided tier_one tier_two pres_approval spellnumber firstterm) ///
	vce(cluster spell_id) 
matrix m1noexcstart = e(b)
estimates store m1noexc
		
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided tier_one tier_two pres_approval spellnumber firstterm) ///
	vce(cluster spell_id) 
matrix m2noexcstart = e(b)
estimates store m2noexc

* (convergence issues so need to specify starting values, so use a simpler model to generate them)
heckman cfscore_diff year_in_vacancy year_in_congress ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	tier_one tier_two pres_approval spellnumber firstterm) ///
	vce(cluster spell_id)
matrix m3noexcstart = e(b)
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided tier_one tier_two pres_approval spellnumber firstterm) ///
	vce(cluster spell_id) difficult from(m3noexcstart)
estimates store m3noexc

esttab m1noexc m2noexc m3noexc using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA17.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	
			
* Table A-18
heckman log_cfscore_presdiff year_in_vacancy year_in_congress tier_one ///
	tier_two pres_approval spellnumber if in_vacancy == 1 & ((datevacancybegan <= 15009) & ///
	datevacancybegan >= 14981), select(nomination_sent = year_in_vacancy year_in_congress ///
	tier_one tier_two ///
	pres_approval spellnumber roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1cohort	
		
heckman log_cfscore_fildiff year_in_vacancy year_in_congress pres_filibuster_diff divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & ((datevacancybegan <= 15009) & ///
	datevacancybegan >= 14981), select(nomination_sent = year_in_vacancy year_in_congress ///
	pres_filibuster_diff divided nondepartmental tier_one tier_two ///
	pres_approval spellnumber roll_calls active_noms) ///
	robust
estimates store m2cohort	
		
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & ((datevacancybegan <= 15009) & ///
	datevacancybegan >= 14981), select(nomination_sent = year_in_vacancy year_in_congress ///
	pres_filibuster_diff nondepartmental tier_one tier_two pres_approval spellnumber roll_calls active_noms) ///
	robust
estimates store m3cohort	
		
esttab m1cohort m2cohort m3cohort using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA18.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	

	
* Table A-19	
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_one == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1notier1		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_one == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2notier1	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_one == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3notier1	

esttab m1notier1 m2notier1 m3notier1 using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA19.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")


		
* Table A-20
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_two == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1notier2		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_two == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2notier2	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_two == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3notier2	

esttab m1notier2 m2notier2 m3notier2 using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA20.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")

			
		
* Table A-21
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & (tier_one == 1| tier_two == 1), select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1notier3		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & (tier_one == 1| tier_two == 1), select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2notier3	
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & (tier_one == 1| tier_two == 1), select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3notier3	

esttab m1notier3 m2notier3 m3notier3 using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA21.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
		
		

* Table A-22
heckman log_cfscore_presdiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_one == 0 & tier_two == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m1onlytier3		
	
heckman log_cfscore_fildiff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_one == 0 & tier_two == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m2onlytier3		
	
heckman cfscore_diff year_in_vacancy year_in_congress c.pres_filibuster_diff##c.divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1 & tier_one == 0 & tier_two == 0, select(nomination_sent = year_in_vacancy year_in_congress ///
	c.pres_filibuster_diff##c.divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber firstterm roll_calls active_noms) ///
	vce(cluster spell_id)
estimates store m3onlytier3		

esttab m1onlytier3 m2onlytier3 m3onlytier3 using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA22.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
		
		

* Tables A-23a and A-23b (marginal effects in A-23b, coefficients in A-23a and saved as CSV)	
heckman log_cfscore_presdiff c.year_in_vacancy##c.year_in_admin c.year_in_congress##c.year_in_admin pres_filibuster_dif divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = c.year_in_vacancy##c.year_in_admin /// 
	c.year_in_congress##c.year_in_admin ///
	pres_filibuster_diff divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber roll_calls active_noms) ///
	vce(cluster spell_id) difficult
estimates store m1yearinteract	
	
margins, dydx(year_in_vacancy) at(year_in_admin = (1 2 4 8)) vsquish
margins, dydx(year_in_congress) at(year_in_admin = (1 2 4 8)) vsquish	
margins, dydx(year_in_vacancy) at(year_in_admin = (1 2 4 8)) predict(psel) vsquish
margins, dydx(year_in_congress) at(year_in_admin = (1 2 4 8)) predict(psel) vsquish	
	
	
heckman log_cfscore_fildiff c.year_in_vacancy##c.year_in_admin c.year_in_congress##c.year_in_admin pres_filibuster_dif divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = c.year_in_vacancy##c.year_in_admin /// 
	c.year_in_congress##c.year_in_admin ///
	pres_filibuster_diff divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m2yearinteract			
	
margins, dydx(year_in_vacancy) at(year_in_admin = (1 2 4 8)) vsquish
margins, dydx(year_in_congress) at(year_in_admin = (1 2 4 8)) vsquish	
margins, dydx(year_in_vacancy) at(year_in_admin = (1 2 4 8)) predict(psel) vsquish
margins, dydx(year_in_congress) at(year_in_admin = (1 2 4 8)) predict(psel) vsquish	
	
	
heckman cfscore_diff c.year_in_vacancy##c.year_in_admin c.year_in_congress##c.year_in_admin pres_filibuster_dif divided tier_one ///
	tier_two pres_approval spellnumber firstterm if in_vacancy == 1, select(nomination_sent = c.year_in_vacancy##c.year_in_admin /// 
	c.year_in_congress##c.year_in_admin ///
	pres_filibuster_diff divided agriculture commerce  justice labor natl_security social_welfare ///
	infrastructure nondepartmental tier_one tier_two pres_approval spellnumber roll_calls active_noms) ///
	vce(cluster spell_id) 
estimates store m3yearinteract		

margins, dydx(year_in_vacancy) at(year_in_admin = (1 2 4 8)) vsquish
margins, dydx(year_in_congress) at(year_in_admin = (1 2 4 8)) vsquish	
margins, dydx(year_in_vacancy) at(year_in_admin = (1 2 4 8)) predict(psel) vsquish
margins, dydx(year_in_congress) at(year_in_admin = (1 2 4 8)) predict(psel) vsquish	
	

esttab m1yearinteract m2yearinteract m3yearinteract using "/Users/garyhollibaugh/Dropbox/Projects/Offline Rothenberg-Hollibaugh Ideology and Vacancies/TableA23.csv", ///
	replace label onecell unstack cells(b(star fmt(3)) se(par fmt(3))) stats(chi2 bic ll N, fmt(3 3 3 0) ///
	labels("Wald Test" "BIC" "Log Likelihood" "Number of observations")) wrap varwidth(95) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) ///
	starlevels(* 0.1 ** .05 *** 0.01) ///
	mtitles("Logged President-Nominee Distance" "Logged Filibuster-Nominee Distance" "Relative President-Filibuster Distance")
	

