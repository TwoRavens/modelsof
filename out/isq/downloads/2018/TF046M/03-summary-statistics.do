
clear

set more off

cd "~/Dropbox/research/worldleaders/final-submission"
use "data03-regression-dataset"

** sorting data
sort iso3c year month

** generating months since 2007 variable
gen months_since_2007 = (year-2007)*12 + month - 1

****Cleaning up some of the variables***

** count variables
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

** adding population
gen log_pop = log(mad_pop)
label variable log_pop "Population, in 1000s (log)"

**Log GDP Per Capita
gen log_gdp_pc= log(gdp/(1000*mad_pop))

**Generating a binary variable democracy (polity2>=6)
gen new_polity2=polity2
replace new_polity2=. if polity2==.z

** generating count of hostile events civil society -> government
gen logSOCtGOVhostilityct = log(SOCtGOVhostilityct + 1)

** generating diffusion variable
sort cown months_since_2007
bysort cown: gen l_leader_active_diffusion_K = leader_active_diffusion_K[_n-1] 

** label variables
label variable leader_active_any "Leader Has Active Social Media Account"
label variable leader_active_personal_any "Leader Has Active Personal Account"
label variable leader_active_institution_any "Leader Has Active Institutional Account"
label variable leader_active_tw_any "Leader Has Active Twitter Account"
label variable leader_active_fb_any "Leader Has Active Facebook Account"
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
label variable logSOCtGOVhostilityct "Index of Social Unrest (ICEWS)"
label variable nelda_comp "Electoral Competition (NELDA)"
label variable leader_active_diffusion_K "Adoption by K=4 Nearest Neighbors"
label variable years_in_office "Years in Office (Executive)"
label variable leg_comp "Legislative Index of Political Competitiveness"
label variable exec_comp "Executive Index of Political Competitiveness"
label variable tweet_count_pers "Monthly Count of Tweets (Personal)"
label variable tweet_count_inst "Monthly Count of Tweets (Institutional)"
label variable fb_count_pers "Monthly Count of FB Posts (Personal)"
label variable fb_count_inst "Monthly Count of FB Posts (Institutional)"
label variable tweet_prop_eng "% of Tweets in English, by Month"
label variable fb_count "Monthly Count of Posts (All)"
label variable l_leader_active_diffusion_K "Adoption by K=4 Nearest Neighbors (1 lag)"

** generating table of descriptive statistics
sutex leader_active_any leader_active_personal_any leader_active_institution_any ///
	leader_active_tw_any leader_active_fb_any tweet_count fb_count tweet_prop_eng ///
	log_gdp_pc internet prop_users elec_12months logSOCtGOVhostilityct ///
	new_polity2 l_leader_active_diffusion_K log_pop, minmax nobs digits(3) ///
	title ("Summary Statistics: Monthly Data from Jan 2007 to Nov 2013") ///
	labels

	
	
	
