
cd "your path comes here" // Set the working directory (from where you will upload Dataset 1 and Dataset 2) 

******************
*** Analysis 1 *** 
******************

use Kostelka_Dataset1_Established.dta, clear // upload Dataset 1, which contains elections in established democracies and founding elections in new democracies 

**************** Table 1 (Models A, B, C)**************** 

tsset Country Election_number
eststo M1: xtreg Turnout Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s  ib3.Continent if New==0, re cluster(Country) 

eststo M2: xtreg Turnout i.New Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s  ib3.Continent, re cluster(Country) 

eststo M3: xtreg Turnout i.Trans_type i.Auth_mobilization Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
 Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s  ib3.Continent, re cluster(Country) 
	
esttab M1 M2 M3 using result_1.rtf, one replace b(2) se(2) wide staraux ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001)  order(1.New 1.Trans_type 2.Trans_type 3.Trans_type ///
	4.Trans_type 5.Trans_type  6.Trans_type 1.Auth_mobilization) eqlabels(none) nobase  nodep /// 
	label mtitles("A" "B" "C") nonumbers note("Clustered standard errors in parentheses.") ///
	 indicate("Continent dummies = **Continent")
	 
************* Robustness checks (Presented in the Supplemental Materials, Table 4) ************* 

eststo clear 

*Averaged data 
preserve 
collapse Year Election_number Turnout Decisiveness Closeness Concurrent Voting_age CV CV_enforced ///
logElectorate Direct_pres ADM Continent Postcommunist New Auth_mobilization Trans_type GDP_current log_GDP /// 
GDP_growth  date multiple_el_id Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_90s Decade_2000s ///
Decade_2010s, by(Country)
eststo M1: reg Turnout i.Trans_type i.Auth_mobilization Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s ib3.Continent
restore 
	
*Prais-Winsten regression with panel-corrected standard errors & autocorrelation(ar1)	
eststo M2: xtpcse Turnout i.Trans_type i.Auth_mobilization Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s ib3.Continent, cor(ar 1)

*“Hybrid” model (Allison 2009, Bell and Jones 2015)
preserve	
foreach var of varlist Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s {
egen mean_`var' = mean(`var'), by(Country)
gen dev_`var' = `var' - mean_`var'
} 
tsset Country Election_number
eststo M3: xtreg Turnout  i.Trans_type i.Auth_mobilization mean_* dev_* i.Continent, re
restore 

*Pooled OLS
eststo M4: reg Turnout i.Trans_type i.Auth_mobilization Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s ib3.Continent, cluster(Country)

*Table 4 in the Supplemental Materials
esttab M1 M2 M3 M4 using result_2.rtf, one replace b(2) se(2) wide staraux ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001) order(1.Trans_type 2.Trans_type 3.Trans_type ///
	4.Trans_type 5.Trans_type  6.Trans_type 1.Auth_mobilization) eqlabels(none) nobase  nodep /// 
	label mtitles("A" "B" "C") nonumbers note("Clustered standard errors in parentheses.") ///
	 indicate("Continent dummies = **Continent")

	 

	 
	 
*********************************
*** Preparation of Analysis 2 *** 
*********************************

*Replication of model C
quietly xtreg Turnout i.Trans_type i.Auth_mobilization Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s  ib3.Continent, re cluster(Country)  

*Getting the estimates for the democratization bonus (they are used in the next analysis) 
matrix list e(b)
global Trans1 = _b[1.Trans_type]
global Trans2 = _b[2.Trans_type]
global Trans3 = _b[3.Trans_type]
global Trans4 = _b[4.Trans_type]
global Trans5 = _b[5.Trans_type]
global Trans6 = _b[6.Trans_type]
global Automob = _b[1.Auth_mobilization]
di $Trans1 "   " $Trans2 "   " $Trans3 "   " $Trans4 "   " $Trans5 "   " $Trans6 "   " $Automob     









******************
*** Analysis 2 *** 
******************

use Kostelka_Dataset2_New.dta, clear // upload Dataset 2, which contains elections in new democracies

*Creation of the democratization bonus
tab Trans_type, gen(Transition) // Creating transition dummies 
gen dem_bonus =  Transition1*$Trans1 + Transition2*$Trans2 + Transition4*$Trans4 + Transition5*$Trans5 + Auth_mobilization*$Automob 

*Creation of the variable Election Sequence 
recode Election_Number (1=-1) (2=-0.8) (3=-0.6) (4=-0.4) (5=-0.2) (6=0), gen(Elect_sequence) 

*Time x Democratization Bonus (and Penalty) 
gen dem_bonus_time = Elect_sequence *dem_bonus 

*Time x Third_wave 
gen Third_wave_time = Elect_sequence*Third_wave

*Time*Region Dummies  
tab Continent, gen(conti)
* Africa 
gen Africa_time = Elect_sequence *conti1 
*Asia 
gen Asia_time = Elect_sequence*conti2
*Non-Post-Communist Europe 
gen Europe_time = Elect_sequence *conti3 
replace Europe_time =0 if Postcommunist == 1
*Latin America 
gen LA_time = Elect_sequence *conti4  
*Oceania 
gen Oceania_time = Elect_sequence *conti5 
*Post-Communist  
gen PC_time = Elect_sequence *Postcommunist 



************** Table 2 *************

tsset Country Election_Number 
eststo clear 
eststo M1: xtreg Turnout dem_bonus_time Elect_sequence, fe cluster(Country)
eststo M2: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth, fe cluster(Country)
eststo M3: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time PC_time, fe cluster(Country)
test _b[Elect_sequence] + _b[Third_wave_time] =0 // Wald test reported in the text 
eststo M4: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth  Third_wave_time PC_time Closeness Decisiveness ADM logElectorate log_GDP, fe  cluster(Country) 

esttab M1 M2 M3 M4 using result_3.rtf, one replace b(2) se(2) wide staraux ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001) order("dem_bonus_time") eqlabels(none) nobase  nodep /// 
	label mtitles("D" "E" "F" "G") nonumbers note("Clustered standard errors in parentheses.") 

	

	
	
	
	
************* Robustness Checks	(Tables 5-9 in the Supplemental Materials *************

*Interactions with economic growth (see Footnote 24 in the Manuscript)
cap tab Continent, gen(conti)
xtreg Turnout dem_bonus_time Elect_sequence Third_wave_time GDP_growth  c.GDP_growth#i.Postcommunist  PC_time, fe 
xtreg Turnout dem_bonus_time Elect_sequence Third_wave_time GDP_growth  c.GDP_growth#i.conti1  PC_time, fe 
xtreg Turnout dem_bonus_time Elect_sequence Third_wave_time GDP_growth  c.GDP_growth#i.conti2  PC_time, fe 
xtreg Turnout dem_bonus_time Elect_sequence Third_wave_time GDP_growth  c.GDP_growth#i.conti3  PC_time, fe 
xtreg Turnout dem_bonus_time Elect_sequence Third_wave_time GDP_growth  c.GDP_growth#i.conti4  PC_time, fe 
xtreg Turnout dem_bonus_time Elect_sequence Third_wave_time GDP_growth  c.GDP_growth#i.conti5  PC_time, fe 
xtreg Turnout dem_bonus_time Elect_sequence Third_wave_time GDP_growth  c.GDP_growth#i.Third_wave PC_time, fe 
drop conti* 

*Table 5 in the Supplemental Materials: Alternative Technical Specification

*Creating a LAG
sort Country Year
by Country: gen Turnout_lag = Turnout[_n-1] 
gen filter = 0
replace filter =1 if dem_bonus_time !=. & Elect_sequence !=. & GDP_growth !=. & Third_wave_time !=. & PC_time !=. & Closeness !=. & Decisiveness !=. & ///
 ADM !=. & logElectorate !=. & log_GDP !=.
egen cases =count(Turnout) if filter ==1, by(Country) // to get the number of observations by panel 
xtab cases

eststo clear
eststo G1_1: xtpcse Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time Closeness Decisiveness ADM logElectorate log_GDP Turnout_lag ib4.Country, pairwise // without PCSE 
eststo G1_2: xtpcse Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time PC_time Closeness Decisiveness ///
 ADM logElectorate log_GDP ib4.Country if cases > 4 , c(ar1) pairwise   
eststo G1_3: xtreg  Turnout dem_bonus_time Elect_sequence GDP_growth  Third_wave_time  PC_time Closeness Decisiveness  Direct_pres Concurrent CV CV_enforced ADM Voting_age logElectorate log_GDP /// 
 Decade_40s Decade_50s Decade_60s Decade_70s Decade_80s Decade_2000s Decade_2010s ib3.Continent dem_bonus Third_wave  Postcommunist, re cluster(Country) // random effects 
esttab G1_1 G1_2 G1_3 using result_4.rtf, one replace b(2) se(2) wide staraux ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(**Country) order(dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time) ///
	nonumbers note("Model F1: Fixed effects, panel-corrected standard errors and lagged dependent variable." ///
	"Model F2: Fixed effects, panel-corrected standard errors and autoregression correction (AR1)." ///
	"Model 3: Random effects & clustered standard errors.") ///
	label mtitles("G 1.1" "G 1.2" "G 1.3")	

	 
*Table 6 in the Supplemental Materials: Different Democratic Standards
eststo clear
eststo G2_1: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time PC_time Closeness /// Polity 2 and more 
 Decisiveness ADM logElectorate log_GDP if filter_polity2==1, fe  cluster(Country) 
eststo G2_2: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time PC_time Closeness /// Polity 4 and more 
 Decisiveness ADM logElectorate log_GDP if filter_polity4==1, fe  cluster(Country) 
eststo G2_3: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time PC_time Closeness /// Polity 6 and more 
 Decisiveness ADM logElectorate log_GDP if filter_polity6==1, fe cluster(Country)  
esttab G2_1 G2_2 G2_3 using result_5.rtf, one replace b(2) se(2) wide staraux ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001)  order(dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time) ///
	nonumbers note("Fixed effects applied. Democratic Bonus, Third Wave and Post-Communist are interacted with Election number." ///
	"Clustered standard errors in parentheses. + p < 0.10, * p < 0.05, ** p < 0.01, *** p < 0.001") ///
	label mtitles("G 2.1" "G 2.2" "G 2.3")

* Table 7 in the Supplemental Materials: Different Levels of Economic Development
gen temp_gdp = GDP_current if Election_Number ==1 
replace temp_gdp = GDP_current if Election_Number ==2 & temp_gdp[_n-1] == .  // Getting GDP for panels where the information is missing for the founding election
egen panel_start_gdp = mode(temp_gdp), by(Country) 

gen temp1= 0 
su panel_start_gdp if Election_Number==1, d 
replace temp1 = 1 if panel_start_gdp < r(p50) & Election_Number ==1
egen filter1 = max(temp1), by(Country) 

gen temp2 = 0
su panel_start_gdp if Election_Number==1, d 
replace temp2 = 1 if GDP_current > r(p50) &  Election_Number ==1
egen filter2 = max(temp2), by(Country) 

gen temp3 = 0
su panel_start_gdp if Election_Number==1, d 
replace temp3 = 1 if GDP_current < r(p75) &  Election_Number ==1
egen filter3 = max(temp3), by(Country) 

eststo clear
* > the median 
eststo G3_1: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time PC_time Closeness ///
 Decisiveness ADM logElectorate log_GDP if filter1==1  , fe  cluster(Country) 
* < the median 
eststo G3_2: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time PC_time Closeness ///
 Decisiveness ADM logElectorate log_GDP if filter2==1 , fe  cluster(Country) 
* < 3rd quartile 
eststo G3_3: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time PC_time Closeness ///
 Decisiveness ADM logElectorate log_GDP if filter3==1, fe  cluster(Country)

esttab G3_1 G3_2 G3_3 using result_5.rtf, one  replace b(2) se(2) wide staraux ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001)  order(dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time) ///
	nonumbers note("Fixed effects applied. Democratic Bonus, Third Wave and Post-Communist are interacted with Election number." ///
	"Standard errors in parentheses. + p < 0.10, * p < 0.05, ** p < 0.01, *** p < 0.001") ///
	label mtitles("G 3.1" "G 3.2" "G 3.3")

drop temp1 temp2 temp3 filter1 filter2 filter3
	
*Table 8 in the Supplemental Materials: Additional Regional Dummies
eststo clear 
eststo G4_1: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time LA_time Closeness ///
 Decisiveness ADM logElectorate log_GDP, fe  cluster(Country) 
eststo G4_2: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time LA_time Africa_time  Closeness ///
 Decisiveness ADM logElectorate log_GDP, fe  cluster(Country)  
 eststo G4_3: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time LA_time Africa_time Asia_time Closeness ///
 Decisiveness ADM logElectorate log_GDP, fe  cluster(Country) 
 
esttab G4_1 G4_2 G4_3 using result_6.rtf, one  replace b(2) se(2) wide staraux ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001)  order(dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time LA_time Africa_time Asia_time) ///
	nonumbers note("Fixed effects applied. Democratic Bonus, Third Wave and Post-Communist are interacted with Election number." ///
	"Standard errors in parentheses. + p < 0.10, * p < 0.05, ** p < 0.01, *** p < 0.001") ///
	label mtitles("G 4.1" "G 4.2" "G 4.3")

	
* Table 9 in the Supplemental Materials: Democratization Waves 
eststo G5_1: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth PC_time Closeness Decisiveness ADM logElectorate log_GDP  if Third_wave==0, fe   
eststo G5_2: xtreg Turnout dem_bonus_time Elect_sequence GDP_growth PC_time Closeness Decisiveness ADM logElectorate log_GDP  if Third_wave==1, fe cluster(Country)  // ib4.Country 

esttab G5_1 G5_2 using result_7.rtf, one replace b(2) se(2) wide staraux ///
	star(+ 0.10 * 0.05 ** 0.01 *** 0.001)  order(dem_bonus_time Elect_sequence GDP_growth Third_wave_time  PC_time) ///
	nonumbers note("Fixed effects applied. Democratic Bonus, Third Wave and Post-Communist are interacted with Election number." ///
	"Standard errors in parentheses. + p < 0.10, * p < 0.05, ** p < 0.01, *** p < 0.001") ///
	label mtitles("G 5.1" "G 5.2")
