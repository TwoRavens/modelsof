
clear all

set more off

cd "~/Dropbox/research/worldleaders/final-submission"
use "data03-regression-dataset"

*** validation of social media variable ****
keep if year==2012 & month==11 & region == "Europe & Central Asia (all income levels)"
keep iso3c prop_users country_name
generate eurob = .

** http://ec.europa.eu/public_opinion/archives/eb/eb78/eb78_anxde_en.pdf
replace eurob = 43 if iso3c == "AUT"
replace eurob = 47 if iso3c == "BEL"
replace eurob = 38 if iso3c == "BGR"
replace eurob = 63 if iso3c == "CYP"
replace eurob = 39 if iso3c == "CZE"
replace eurob = 34 if iso3c == "DEU"
replace eurob = 48 if iso3c == "ESP"
replace eurob = 53 if iso3c == "EST"
replace eurob = 50 if iso3c == "FIN"
replace eurob = 36 if iso3c == "FRA"
replace eurob = 39 if iso3c == "GRC"
replace eurob = 37 if iso3c == "HRV"
replace eurob = 44 if iso3c == "HUN"
replace eurob = 52 if iso3c == "IRL"
replace eurob = 77 if iso3c == "ICE"
replace eurob = 43 if iso3c == "ITA"
replace eurob = 46 if iso3c == "LTU"
replace eurob = 46 if iso3c == "LUX"
replace eurob = 60 if iso3c == "LVA"
replace eurob = 36 if iso3c == "MKD"
replace eurob = 60 if iso3c == "NLD"
replace eurob = 40 if iso3c == "POL"
replace eurob = 31 if iso3c == "PRT"
replace eurob = 28 if iso3c == "ROU"
replace eurob = 44 if iso3c == "SVK"
replace eurob = 40 if iso3c == "SVN"
replace eurob = 59 if iso3c == "SWE"
replace eurob = 49 if iso3c == "GBR"

cor prop_users eurob


*** rest of analysis ****
use "data03-regression-dataset", clear

** sorting data
sort iso3c year month

** drop countries with missing country code
drop if cown==.z

****Cleaning up some of the variables***

** adding population
gen log_pop = mad_pop
label variable log_pop "Population, in 1000s (log)"

**Log GDP Per Capita
gen log_gdp_pc= log(gdp/(1000*mad_pop))

**Generating a binary variable democracy (polity2>=6)
gen new_polity2=polity2
replace new_polity2=. if polity2==.z

gen democracy=1 if new_polity2>=6 & !missing(new_polity2)
replace democracy=0 if new_polity2<6 & !missing(new_polity2)

** generating months since 2007 variable
gen months_since_2007 = (year-2007)*12 + month - 1

** VARIABLE LABELS
label variable new_polity2 "Polity IV Score"
label variable elec_6months "Election Within 6 Months"
label variable elec_12months "Election Within 12 Months"
label variable prop_users "Social Media Users"
label variable internet "Internet Users"
label variable log_gdp_pc "Log GDP Per Capita"
label variable conflict "Banks Conflict Variable"
label variable press_freedom "Press Freedom Index (Inverse)"
label variable english_speakers "\% English Speakers"
label variable south_ame "South America"
label variable africa "Africa"
label variable europe "Europe"
label variable polit_system "Political System"
label variable log_pop "Population, in 1000s (log)"
label define polit_system 0 "Parliamentary democracy" 1 "Semi-presid. democracy" ///
	2 "Presidential democracy" 3 "Civilian dictatorship" 4 "Military dictatorship" ///
	5 "Royal dictatorship"
label values polit_system polit_system
label variable log_pop "Population, in 1000s (log)"
label variable SOCtGOVhosttotals "Social society protests, sum (ICEWS)"
label variable SOCtGOVhostilityct "Social society protests, counts (ICEWS)"
gen logSOCtGOVhosttotals = log(SOCtGOVhosttotals + 1)
gen logSOCtGOVhostilityct = log(SOCtGOVhostilityct + 1)
label variable logSOCtGOVhostilityct "Index of Social Unrest (ICEWS)"
label variable logSOCtGOVhosttotals "Social society protests, log sum (ICEWS)"
label variable nelda_comp "Electoral Competition (NELDA)"
label variable not_confident_victory "Leader Not Confident of Victory (NELDA)"
label variable riots_protests "Riots and Protests After Election (NELDA)"
label variable unfavorable_polls "Unfavorable polls (NELDA)"
label variable leader_active_diffusion_K "Adoption by K=4 Nearest Neighbors"
label variable years_in_office "Years in Office (Executive)"
label variable leg_comp "Legislative Index of Political Competitiveness"
label variable exec_comp "Executive Index of Political Competitiveness"
label variable tweet_count_pers "Monthly Count of Tweets (Personal)"
label variable tweet_count_inst "Monthly Count of Tweets (Institutional)"
label variable fh_feb "Freedom of Expression (FH)"
gen tweet_count = tweet_count_pers + tweet_count_inst
label variable tweet_count "Monthly Count of Tweets (All)"
gen tweet_prop_eng = (tweet_count_pers * tweet_count_pers_eng + ///
	tweet_count_inst * tweet_count_inst_eng) / (tweet_count_pers + tweet_count_inst)
replace tweet_prop_eng = tweet_count_pers_eng if tweet_count_inst_eng == .
replace tweet_prop_eng = tweet_count_inst_eng if tweet_count_pers_eng == .
	
label variable fb_count_pers "Monthly Count of FB Posts (Personal)"
label variable fb_count_inst "Monthly Count of FB Posts (Institutional)"
gen fb_count = fb_count_pers + fb_count_inst
label variable fb_count "Monthly Count of Posts (All)"

** high freedom of expression
gen high_feb = .
replace high_feb = 1 if fh_feb > 8 & fh_feb != .
replace high_feb = 0 if fh_feb <= 8 & fh_feb != .
label variable high_feb "High Freedom of Expression (FH)"

****DIFFUSION VARIABLES****
***Proportion of Neighbors wth social media
gen diffuse_active= leader_active_diffusion/neighbor_count
label variable diffuse_active "\% Adoption by Neighbors"
sort cown months_since_2007
bysort cown: gen l_leader_active_diffusion_K = leader_active_diffusion_K[_n-1] 
bysort cown: gen l_diffuse_active = diffuse_active[_n-1] 
label variable l_leader_active_diffusion_K "Adoption by K=4 Nearest Neighbors (1 lag)"

** LAGGED UNREST
bysort cown: gen l_logSOCtGOVhostilityct = logSOCtGOVhostilityct[_n-1] 
label variable l_logSOCtGOVhostilityct "Index of Social Unrest (ICEWS), Lagged"

*** COUNTRY WEIGHTS FOR REGRESSION ****
by iso3c, sort: egen ave_pop = mean(log(mad_pop*1000))
gen logpop = log(mad_pop*1000)
sum logpop
gen weight = 1/(ave_pop / r(mean))
sum weight
drop if weight==.

******************************************************************************
** KM Election: Figure 4
******************************************************************************
stset months_since_2007, failure(leader_active_any) id(iso3c)

stcox elec_12months
sts graph, failure ci by(elec_12months) title("") ///
	xtitle("Number of Months since 2007") ytitle("% of Leaders with Active Social Media Account") ///
	legend(ring(0) position(10) rows(4) label(1 "95% CI") label(3 "95% CI") ///
	label(5 "No Election in Next 12 Months") ///
	label(6 "Election in Next 12 Months")) ///
	graphregion(color(white)) saving(elec_plot1, replace)

stcox unfavorable_polls, nohr
sts graph, failure ci by(unfavorable_polls)  title("") ///
	xtitle("Number of Months since 2007") ytitle("% of Leaders with Active Social Media Account") ///
	legend(ring(0) position(10) rows(4) label(1 "95% CI") label(3 "95% CI") ///
	label(5 "Polls favorable to incumbent") ///
	label(6 "Polls unfavorable to incumbent")) ///
	graphregion(color(white)) saving(elec_plot2, replace)	
	
graph combine elec_plot1.gph elec_plot2.gph, rows(1) cols(2) iscale(.75) ///
	ysize(5) xsize(10) graphregion(color(white))
graph export figure4.pdf, replace




	
******************************************************************************
** KM Democracy: Figure 5
******************************************************************************

stset months_since_2007, failure(leader_active_any) id(iso3c)
stcox democracy
sts graph, failure ci by(democracy) title("") ///
	xtitle("Number of Months since 2007") ytitle("% of Leaders with Active Social Media Account") ///
	legend(ring(0) position(10) rows(4) label(1 "95% CI") label(3 "95% CI") ///
	label(5 "Non-Democracies") ///
	label(6 "Democracies")) ///
	graphregion(color(white)) saving(dem_plot1, replace)

stcox high_feb
sts graph, failure ci by(high_feb) title("") ///
	xtitle("Number of Months since 2007") ytitle("% of Leaders with Active Social Media Account") ///
	legend(ring(0) position(10) rows(4) label(1 "95% CI") label(3 "95% CI") ///
	label(5 "Low Freedom of Expression") ///
	label(6 "High Freedom of Expression")) ///
	graphregion(color(white)) saving(dem_plot2, replace)	
	
graph combine dem_plot1.gph dem_plot2.gph, rows(1) cols(2) iscale(.75) ///
	ysize(5) xsize(10) graphregion(color(white))
graph export figure5.pdf, replace
	


******************************************************************************
** preparing more variables
******************************************************************************

**Generating Regional Dummies (Destringing the variables)
drop europe
tabulate region, gen(dummy_regions)
rename dummy_regions1 east_asia
rename dummy_regions2 europe
rename dummy_regions3 latin_america
rename dummy_regions4 mena
*rename dummy_regions5 .....this is just Cape Verde, Naru, and Vatican

*base category is north america
rename dummy_regions6 north_america
rename dummy_regions7 south_asia
rename dummy_regions8 sub_sahara

******************************************************************************
*** TABLE 2
******************************************************************************

****Cox Proportional Hazard****
****Without Time-Varying Covariates****

****LEADER ACTIVE
stset months_since_2007, failure(leader_active_any) id(iso3c)

** H1: modernization hypothesis
stcox log_gdp_pc internet prop_users east_asia europe latin_america mena south_asia sub_sahara , cluster(iso3c) nohr 
estimates store m1, title(H1)

** H2: electoral pressure hypothesis
stcox elec_12months unfavorable_polls l_logSOCtGOVhostilityct east_asia europe latin_america mena  south_asia sub_sahara , robust nohr 
estimates store m2, title(H2)

** H3: transparency/democracy hypothesis
stcox new_polity2 east_asia europe latin_america mena   south_asia sub_sahara , robust nohr
estimates store m3, title(H3)

** H4: diffusion hypothesis
stcox l_leader_active_diffusion_K east_asia europe latin_america mena   south_asia sub_sahara , robust nohr
estimates store m4, title(H4)

** All together
stcox log_gdp_pc internet prop_users elec_12months unfavorable_polls l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara , robust nohr
estimates store m5, title(All1)

stcox log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara , robust nohr
estimates store m6, title(All2)

** Generating table
estout m1 m2 m3 m4 m5 m6   /*displays models 1-5*/ ///
	using "table2.tex", replace style(tex) ///
	title(Cox Proportional Hazard Model) ///
	prehead(	\def\one{\footnotesize{$\ast$}} ///
				\def\two{\footnotesize{$\ast\ast$}} ///
				\def\three{\footnotesize{$\ast\ast$$\ast$}} ///
				\begin{table}[h!]\caption{@title} ///
				\label{tab:cox1} ///
				\centering\begin{threeparttable}\begin{tabular}{l*{@M}{r@{}l}}\hline\hline ///
				) ///
	collabels(none) /*hides labels of columns*/ ///
	posthead(\hline\\) ///
	cells(b(star fmt(%9.2f)) se(par)) /*displays coefs with 1 decimal*/ ///
	starlevels(\one 0.10 \two 0.05 \three 0.01) ///
		/*reported levels of significance can changed*/ ///
	drop(east_asia europe latin_america mena   south_asia sub_sahara) ///
	varlabels(_cons Constant) /*modify label of constant*/ ///
    prefoot(\hline Region fixed effects & Yes & & Yes && Yes && Yes && Yes  && Yes\\\hline) ///
	stats(N N_sub N_fail, fmt(%9.0g %9.0g %9.0g ) labels("Observations" "Number of Countries" "Number Get Account")) ///
	nolegend /*hides significance symbols legend (I'll do it manually)*/ ///
	label  /*make use of variable labels*/ ///
	stardetach /*display stars in separated column*/ ///
	wrap varwidth(30) ///
	postfoot( ///
				\hline\hline\end{tabular} \begin{tablenotes} ///
				\item \footnotesize{Dependent variable: Does the Leader Have an Active Social Media Account? ///
					Robust standard errors in parentheses. ///
				Signif.: \one 10\% \two 5\% \three 1\%.} ///
				\end{tablenotes}\end{threeparttable}\end{table} ///
				)


******************************************************************************
*** robustness: Table 3 in appendix
******************************************************************************

stcox  elec_12months nelda_comp l_logSOCtGOVhostilityct east_asia europe latin_america mena  south_asia sub_sahara , robust nohr 
estimates store m1, title(H2)

stcox log_gdp_pc internet prop_users elec_12months nelda_comp l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara , robust nohr
estimates store m2, title(H2)

stcox elec_12months unfavorable_polls riots_protests east_asia europe latin_america mena  south_asia sub_sahara, robust nohr
estimates store m3, title(H2)

stcox log_gdp_pc internet prop_users elec_12months unfavorable_polls riots_protests new_polity2 l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara , robust nohr
estimates store m4, title(H2)

stcox fh_feb east_asia europe latin_america mena   south_asia sub_sahara , robust nohr
estimates store m5, title(H3)

stcox log_gdp_pc internet prop_users elec_12months unfavorable_polls l_logSOCtGOVhostilityct fh_feb l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara , robust nohr
estimates store m6, title(H3)


estout m1 m2 m3 m4 m5 m6 /*displays models 1-5*/ ///
	using "table3.tex", replace style(tex) ///
	title(Cox Proportional Hazard Model) ///
	prehead(	\def\one{\footnotesize{$\ast$}} ///
				\def\two{\footnotesize{$\ast\ast$}} ///
				\def\three{\footnotesize{$\ast\ast$$\ast$}} ///
				\begin{table}[h!]\caption{@title} ///
				\label{tab:robust} ///
				\centering\begin{threeparttable}\begin{tabular}{l*{@M}{r@{}l}}\hline\hline ///
				) ///
	collabels(none) /*hides labels of columns*/ ///
	posthead(\hline\\) ///
	cells(b(star fmt(%9.2f)) se(par)) /*displays coefs with 1 decimal*/ ///
	starlevels(\one 0.10 \two 0.05 \three 0.01) ///
		/*reported levels of significance can changed*/ ///
	drop(east_asia europe latin_america mena   south_asia sub_sahara) ///
	varlabels(_cons Constant) /*modify label of constant*/ ///
    prefoot(\hline Region fixed effects & Yes & & Yes && Yes && Yes && Yes && Yes \\\hline) ///
	stats(N N_sub N_fail, fmt(%9.0g %9.0g %9.0g ) labels("Observations" "Number of Countries" "Number Get Account")) ///
	nolegend /*hides significance symbols legend (I'll do it manually)*/ ///
	label  /*make use of variable labels*/ ///
	stardetach /*display stars in separated column*/ ///
	wrap varwidth(30) ///
	postfoot( ///
				\hline\hline\end{tabular} \begin{tablenotes} ///
				\item \footnotesize{Dependent variable: Does the Leader Have an Active Social Media Account? ///
					Robust standard errors in parentheses. ///
				Signif.: \one 10\% \two 5\% \three 1\%.} ///
				\end{tablenotes}\end{threeparttable}\end{table} ///
				)
				

******************************************************************************
*** Robustness: Table 4 in Appendix
******************************************************************************

stcox elec_12months  l_logSOCtGOVhostilityct log_pop east_asia europe latin_america mena   south_asia sub_sahara if democracy==1, robust nohr
estimates store m1, title(Dem1)

stcox unfavorable_polls l_logSOCtGOVhostilityct log_pop east_asia europe latin_america mena   south_asia sub_sahara if democracy==1, robust nohr
estimates store m2, title(Dem2)
	
stcox elec_12months l_logSOCtGOVhostilityct log_pop east_asia europe latin_america mena   south_asia sub_sahara if democracy==0, robust nohr
estimates store m3, title(NonDem1)

stcox  unfavorable_polls l_logSOCtGOVhostilityct log_pop east_asia europe latin_america mena   south_asia sub_sahara if democracy==0, robust nohr
estimates store m4, title(NonDem2)

estout m1 m2 m3 m4 /*displays models 1-5*/ ///
	using "table4.tex", replace style(tex) ///
	title(Cox Proportional Hazard Model) ///
	prehead(	\def\one{\footnotesize{$\ast$}} ///
				\def\two{\footnotesize{$\ast\ast$}} ///
				\def\three{\footnotesize{$\ast\ast$$\ast$}} ///
				\begin{table}[h!]\caption{@title} ///
				\label{tab:interactions} ///
				\centering\begin{threeparttable}\begin{tabular}{l*{@M}{r@{}l}}\hline\hline ///
				) ///
	collabels(none) /*hides labels of columns*/ ///
	posthead(\hline\\) ///
	cells(b(star fmt(%9.2f)) se(par)) /*displays coefs with 1 decimal*/ ///
	starlevels(\one 0.10 \two 0.05 \three 0.01) ///
		/*reported levels of significance can changed*/ ///
	drop(east_asia europe latin_america mena   south_asia sub_sahara ) ///
	varlabels(election_x_polity "Election X Polity" _cons Constant) /*modify label of constant*/ ///
	prefoot(\hline Region fixed effects & Yes & & Yes && Yes && Yes\\\hline) ///
	stats(N N_sub N_fail, fmt(%9.0g %9.0g %9.0g ) labels("Observations" "Number of Countries" "Number Get Account")) ///
	nolegend /*hides significance symbols legend (I'll do it manually)*/ ///
	label  /*make use of variable labels*/ ///
	stardetach /*display stars in separated column*/ ///
	wrap varwidth(30) ///
	postfoot( ///
				\hline\hline\end{tabular} \begin{tablenotes} ///
				\item \footnotesize{Dependent variable: Does the Leader Have an Active Account (Time-Varying Covariates)? ///
					(Type varies across columns). Robust standard errors in parentheses. ///
				Signif.: \one 10\% \two 5\% \three 1\%.} ///
				\end{tablenotes}\end{threeparttable}\end{table} ///
				)
	

	
******************************************************************************
*** Robustness: Table 5 in Appendix
******************************************************************************

** PERSONAL ACCOUNT ***
stset months_since_2007, failure(leader_active_personal_any) id(iso3c) 
stcox log_gdp_pc internet prop_users elec_12months  l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara, robust nohr
estimates store m1, title("Pers")

** INSTITUTION ACCOUNT **

stset months_since_2007, failure(leader_active_institution_any) id(iso3c)
stcox log_gdp_pc internet prop_users elec_12months  l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara, robust nohr
estimates store m2, title("Inst")

** TWITTER **
stset months_since_2007, failure(leader_active_tw_any) id(iso3c)
stcox log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara, robust nohr
estimates store m3, title("Tw")

** FACEBOOK **
stset months_since_2007, failure(leader_active_fb_any) id(iso3c)
stcox log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop east_asia europe latin_america mena   south_asia sub_sahara, robust nohr
estimates store m4, title("Fb")

** Generating table
estout m1 m2 m3 m4 /*displays models 1-5*/ ///
	using "table5.tex", replace style(tex) ///
	title(Cox Proportional Hazard Model) ///
	prehead(	\def\one{\footnotesize{$\ast$}} ///
				\def\two{\footnotesize{$\ast\ast$}} ///
				\def\three{\footnotesize{$\ast\ast$$\ast$}} ///
				\begin{table}[h!]\caption{@title} ///
				\label{tab:cox2} ///
				\centering\begin{threeparttable}\begin{tabular}{l*{@M}{r@{}l}}\hline\hline ///
				) ///
	collabels(none) /*hides labels of columns*/ ///
	posthead(\hline\\) ///
	cells(b(star fmt(%9.2f)) se(par)) /*displays coefs with 1 decimal*/ ///
	starlevels(\one 0.10 \two 0.05 \three 0.01) ///
		/*reported levels of significance can changed*/ ///
	drop(east_asia europe latin_america mena   south_asia sub_sahara) ///
	varlabels(_cons Constant) /*modify label of constant*/ ///
	prefoot(\hline Region fixed effects & Yes & & Yes && Yes && Yes \\\hline) ///
	stats(N N_sub N_fail, fmt(%9.0g %9.0g %9.0g ) labels("Observations" "Number of Countries" "Number Get Account")) ///
	nolegend /*hides significance symbols legend (I'll do it manually)*/ ///
	label  /*make use of variable labels*/ ///
	stardetach /*display stars in separated column*/ ///
	wrap varwidth(30) ///
	postfoot( ///
				\hline\hline\end{tabular} \begin{tablenotes} ///
				\item \footnotesize{Dependent variable: Does the Leader Have an Active Social Media Account ///
				(Personal or Institutional; on Twitter or on Facebook)? ///
					Robust standard errors in parentheses. ///
				Signif.: \one 10\% \two 5\% \three 1\%.} ///
				\end{tablenotes}\end{threeparttable}\end{table} ///
				)


				
******************************************************************************
*** Time Varying Covariates: Table 6 in appendix
******************************************************************************



** any social media
stset months_since_2007, failure(leader_active_any) id(iso3c)
stcox log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop ///
	east_asia europe latin_america mena   south_asia sub_sahara , ///
	tvc(log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop) robust nohr
estimates store m1, title(TVC All)


** personal
stset months_since_2007, failure(leader_active_personal_any) id(iso3c)
stcox log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop ///
	east_asia europe latin_america mena   south_asia sub_sahara , ///
	tvc(log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop) robust nohr

estimates store m2, title(TVC Pers.)


** institution
stset months_since_2007, failure(leader_active_institution_any) id(iso3c)
stcox log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop ///
	east_asia europe latin_america mena   south_asia sub_sahara , ///
	tvc(log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop) robust nohr
estimates store m3, title(TVC Inst.)


** twitter
stset months_since_2007, failure(leader_active_tw_any) id(iso3c)
stcox log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop ///
	east_asia europe latin_america mena   south_asia sub_sahara , ///
	tvc(log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop) robust nohr

estimates store m4, title(TVC Tw.)

** facebook
stset months_since_2007, failure(leader_active_fb_any) id(iso3c)
stcox log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop ///
	east_asia europe latin_america mena   south_asia sub_sahara , ///
	tvc(log_gdp_pc internet prop_users elec_12months l_logSOCtGOVhostilityct new_polity2 l_leader_active_diffusion_K log_pop) robust nohr

estimates store m5, title(TVC Fb.)


** Generating table
estout m1 m2 m3 m4 m5 /*displays models 1-5*/ ///
	using "table6.tex", replace style(tex) ///
	title(Cox Proportional Hazard Model) ///
	prehead(	\def\one{\footnotesize{$\ast$}} ///
				\def\two{\footnotesize{$\ast\ast$}} ///
				\def\three{\footnotesize{$\ast\ast$$\ast$}} ///
				\begin{table}[h!]\caption{@title} ///
				\label{tab:cox3} ///
				\centering\begin{threeparttable}\begin{tabular}{l*{@M}{r@{}l}}\hline\hline ///
				) ///
	collabels(none) /*hides labels of columns*/ ///
	posthead(\hline\\) ///
	cells(b(star fmt(%9.2f)) se(par)) /*displays coefs with 1 decimal*/ ///
	starlevels(\one 0.10 \two 0.05 \three 0.01) ///
		/*reported levels of significance can changed*/ ///
	drop(east_asia europe latin_america mena   south_asia sub_sahara ) ///
	varlabels(election_x_polity "Election X Polity" _cons Constant) /*modify label of constant*/ ///
	prefoot(\hline Region fixed effects & Yes & & Yes && Yes && Yes && Yes\\\hline) ///
	stats(N N_sub N_fail, fmt(%9.0g %9.0g %9.0g ) labels("Observations" "Number of Countries" "Number Get Account")) ///
	nolegend /*hides significance symbols legend (I'll do it manually)*/ ///
	label  /*make use of variable labels*/ ///
	stardetach /*display stars in separated column*/ ///
	wrap varwidth(30) ///
	postfoot( ///
				\hline\hline\end{tabular} \begin{tablenotes} ///
				\item \footnotesize{Dependent variable: Does the Leader Have an Active Account (Time-Varying Covariates)? ///
					(Type varies across columns). Robust standard errors in parentheses. ///
				Signif.: \one 10\% \two 5\% \three 1\%.} ///
				\end{tablenotes}\end{threeparttable}\end{table} ///
				)

				
				
			

