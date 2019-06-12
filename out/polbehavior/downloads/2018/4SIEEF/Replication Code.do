*Replication Code for "The political consequences of self insurance" 
*Tertytchnaya and De Vries, 2018, PB*

*Manuscript*  

/*Tables 1-3*/ use: "ebrd.data.dta"
*Table 1, Model 1* 
xi:xtlogit reduced_consumption savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, /// 
i (country)

*Table 1, Model 2* 
xi:xtlogit reduced_utilities savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, /// 
i (country)

*Table 2, Model 1* 
xi:xtmixed hhecon_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country:, mle variance 
estat ic 

*Table 2, Model 2* 
xi:xtmixed econ_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country:, mle variance
estat ic 

*Table 3, Model 1* 
xi:xtmixed nationalgov_perf savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country:, mle variance
estat ic 

*Table 3, Model 2**
xi:xtmixed nationalgov_perf hhecon_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country:, mle variance
estat ic 

*Table 3, Model 3**
xi:xtmixed nationalgov_perf econ_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred democracy_centred, /// 
|| country:, mle variance
estat ic 

*For marginal effects: 
margins, at(savings_centred =(-.2412808 .7587192)) atmeans

*For the mediation analysis, in Figure 1, please see the R file "Mediation_Savings.R" 

/*Table 4 in the manuscript*/ use:"rlms.dta"

sort idind id_w
xtset idind id_w
gen hhyear=id_h*wave

**NOTE TO CATHERINE: In M1 & M2, the fourth wave of 
*the survey drops due to collinearity*** 

*Table 4, Model 1* 
xi: xtmixed econ_satisfaction l.econ_satisfaction getby_v2 salaryh_reduced_centred ///
loghh_income_centred age_v3_centred gender_centred education_centred marital_status_centred /// 
i.id_w || hhyear:, mle variance
estat ic

*Table 4, Model 2* 
xi: xtmixed econ_satisfaction l.econ_satisfaction getby_v4 salaryh_reduced_centred ///
loghh_income_centred age_v3_centred gender_centred education_centred marital_status_centred /// 
i.id_w || hhyear:, mle variance
estat ic

*Table 4, Model 3*
xi: xtmixed un_area getby_v2 salaryh_reduced_centred loghh_income_centred age_v3_centred ///
gender_centred education_centred marital_status_centred reg_unemployment_centred || id_h:, mle variance
estat ic

*Table 4, Model 4*
xi: xtmixed un_area getby_v4 salaryh_reduced_centred loghh_income_centred age_v3_centred ///
gender_centred education_centred marital_status_centred reg_unemployment_centred || id_h:, mle variance
estat ic


*** Analysis presented in the SI *** 

/*Table A1*/ use: "ebrd.data.dta"
codebook nationalgov_perf trust_pres trust_gov econ_satisfaction hhecon_satisfaction current_hh income_categories dummy_crisis ////
has_savings newsav pcafirst age_respondent gender_respondent education _Iemployed__2 marital_status risk_v1 gdp_growth democracy, compact

Wealth index: 
pca has_elec has_tapw has_line has_heat has_internet has_secondary_house has_car has_computer
codebook has_elec has_tapw has_line has_heat has_internet has_secondary_house has_car has_computer, compact

* For the analysis we centre these variables to the mean, both versions are avaialable in the datasets.   
* Centering example: To centre we do as follows: 
sum pcafirst, d
gen w_centred= pcafirst-(r(mean))

* Catherine, can you check this: After running pca, I do: predict katya, score --> Could we double check it's all right* 

/*Table A2*/: use "rlms.dta"
codebook un_area econ_satisfaction getby_v2 getby_v4 salaryh_reduced loghh_income age_v3 gender ///
education marital_status wave hhyear reg_unemployment, compact 

/*Table B1*/ use: "ebrd.data.dta"
/*M1*/ xi:xtmixed nationalgov_perf savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country:, mle variance cov(unstr)
estat ic 

/*M2*/ xtmixed nationalgov_perf hhecon_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country:, mle variance cov(unstr)
estat ic 

/*M3*/ xtmixed nationalgov_perf econ_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred democracy_centred, /// 
|| country:, mle variance cov(unstr)
estat ic 

/*Table C1.1*/ use: "ebrd.data.dta"
xi:xtmixed hhecon_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country: savings_centred, mle variance cov(unstr)
estat ic 

xi:xtmixed econ_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred democracy_centred, /// 
|| country: savings_centred, mle variance cov(unstr)
estat ic 

xi:xtmixed nationalgov_perf savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred democracy_centred, /// 
|| country: savings_centred, mle variance cov(unstr)
estat ic 

/*Table C1.2*/ use: "rlms.dta"
xtmixed econ_satisfaction l.econ_satisfaction getby_v2 salaryh_reduced_centred ///
loghh_income_centred age_v3_centred gender_centred education_centred marital_status_centred /// 
i.wave || hhyear: getby_v2 salaryh_reduced_centred, mle variance
estat ic

xtmixed econ_satisfaction l.econ_satisfaction getby_v4 salaryh_reduced_centred loghh_income_centred ///
 age_v3_centred gender_centred education_centred marital_status_centred /// 
i.wave || hhyear: getby_v4 salaryh_reduced_centred, mle variance
estat ic

xi: xtmixed un_area getby_v2 salaryh_reduced_centred ///
loghh_income_centred age_v3_centred gender_centred education_centred marital_status_centred ///
reg_unemployment_centred || id_h: getby_v2 salaryh_reduced_centred, mle variance
estat ic

xi: xtmixed un_area getby_v4 salaryh_reduced_centred loghh_income_centred /// 
age_v3_centred gender_centred education_centred marital_status_centred ///
reg_unemployment_centred || id_h: getby_v4 salaryh_reduced_centred, mle variance
estat ic 

/*Table C2*/ use "ebrd.data.dta" 
xi:xtmixed trust_pres savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country:, mle variance
estat ic 

xi:xtmixed trust_gov savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, /// 
|| country:, mle variance cov(unstr)
estat ic 

xi:xtmixed trust_parl savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred  democracy_centred, /// 
|| country:, mle variance cov(unstr)
estat ic 

/*Table C3A-C3C*/ use: "ebrd.data.dta"

/*Table C3A*/
/*M1*/ xi:xtmixed hhecon_satisfaction savings_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, 
|| country:, mle variance

/*M2*/ xi:xtmixed hhecon_satisfaction savings_centred w_centred /// 
dummy_crisis_centred age_respondent_centred  gender_centred married_centred edu_centred employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*M3*/ xi:xtmixed hhecon_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred if dummy_crisis==1, /// 
|| country:, mle variance 

/*M4*/ xi:xtmixed hhecon_satisfaction savings_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred risk_v1_centred ///
gdp_growth_centred democracy_centred, || country:, mle variance 

/*M5*/ xi:xtmixed hhecon_satisfaction newsav_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred  democracy_centred, || country:, mle variance

/*M6*/ xi:xtmixed hhecon_satisfaction savings_centred wealth_index_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*M7*/ xi:xtmixed hhecon_satisfaction hbarter_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*Table C3B*/
/*M1*/ xi:xtmixed econ_satisfaction savings_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, 
|| country:, mle variance

/*M2*/ xi:xtmixed econ_satisfaction savings_centred w_centred /// 
dummy_crisis_centred age_respondent_centred  gender_centred married_centred edu_centred employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*M3*/ xi:xtmixed econ_satisfaction savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred if dummy_crisis==1, /// 
|| country:, mle variance 

/*M4*/ xi:xtmixed econ_satisfaction savings_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred risk_v1_centred ///
gdp_growth_centred democracy_centred, || country:, mle variance 

/*M5*/ xi:xtmixed econ_satisfaction newsav_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred  democracy_centred, || country:, mle variance

/*M6*/ xi:xtmixed econ_satisfaction savings_centred wealth_index_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*M7*/ xi:xtmixed econ_satisfaction hbarter_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*Table C3C*/
/*M1*/ xi:xtmixed nationalgov_perf savings_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, 
|| country:, mle variance

/*M2*/ xi:xtmixed nationalgov_perf savings_centred w_centred /// 
dummy_crisis_centred age_respondent_centred  gender_centred married_centred edu_centred employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*M3*/ xi:xtmixed nationalgov_perf savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred if dummy_crisis==1, /// 
|| country:, mle variance 

/*M4*/ xi:xtmixed nationalgov_perf savings_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred risk_v1_centred ///
gdp_growth_centred democracy_centred, || country:, mle variance 

/*M5*/ xi:xtmixed nationalgov_perf newsav_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred  democracy_centred, || country:, mle variance

/*M6*/ xi:xtmixed nationalgov_perf savings_centred wealth_index_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*M7*/ xi:xtmixed nationalgov_perf hbarter_centred w_centred  dummy_crisis_centred current_hh_centred ///
age_respondent_centred  gender_centred married_centred edu_centred i.employed_centred ///
risk_v1_centred gdp_growth_centred democracy_centred, || country:, mle variance

/*Section D*/ use "ebrd.data.dta"

/*Table D1 & Figure D1*/ use "ebrd.data.dta"
xi:xtmixed hhecon_satisfaction has_savings##income_categories ///
pcafirst age_respondent  gender_respondent ///
marital_status education worked_income risk_v1 gdp_growth  democracy, /// 
|| country:, mle variance

margins has_savings##income_categories, atmeans
margins, at (has_savings=(0(1)1)) at (income_categories=(0(1)2)) atmeans

xi:xtmixed econ_satisfaction ///
has_savings##income_categories pcafirst age_respondent  gender_respondent ///
marital_status education worked_income risk_v1 gdp_growth democracy, /// 
|| country:, mle variance cov(unstr)


/*Table D2.1*/
ttest lost_job, by (has_savings) unequal 
ttest wage_reduced, by (has_savings) unequal 
ttest h_reduced, by (has_savings) unequal 
ttest wage_arrears, by (has_savings) unequal 

/*Table D2.2*/
xi:xtlogit lost_job savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, i(country)

xi:xtlogit wage_reduced savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, i(country)

xi:xtlogit h_reduced savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred employed_centred risk_v1_centred gdp_growth_centred democracy_centred, i(country)

xi:xtlogit wage_arrears savings_centred w_centred age_respondent_centred  gender_centred ///
married_centred edu_centred i.employed_centred risk_v1_centred gdp_growth_centred democracy_centred, i(country)

/*Table D3.1 Matching*/ use "ebrd.data.dta"
*M1: HH satisfaction with income***
teffects nnmatch (hhecon_satisfaction pcafirst current_hh age_respondent gender_respondent marital_status education worked_income risk_v1) ///
(has_savings), ate metric(maha)  biasadj (pcafirst  current_hh age_respondent gender_respondent marital_status education worked_income risk_v1) 
tebalance summarize, baseline

*M2: Econ satisfaction with income***
teffects nnmatch (econ_satisfaction pcafirst current_hh age_respondent gender_respondent marital_status education worked_income risk_v1) ///
(has_savings), ate metric(maha)  biasadj (pcafirst  current_hh age_respondent gender_respondent marital_status education worked_income risk_v1) 
tebalance summarize, baseline

*M3: Gov approval with income***
teffects nnmatch (nationalgov_perf pcafirst current_hh age_respondent gender_respondent marital_status education worked_income risk_v1) ///
(has_savings), ate metric(maha)  biasadj (pcafirst  current_hh age_respondent gender_respondent marital_status education worked_income risk_v1) 
tebalance summarize, baseline

/*Table D3.2 Matching*/ use: "rlms.dta"
teffects nnmatch (econ_satisfaction salaryh_reduced loghh_income age_v3 gender education marital_status) ///
(getby_v2), ate metric(maha)  biasadj (salaryh_reduced loghh_income age_v3 gender education marital_status) 
tebalance summarize, baseline

teffects nnmatch (un_area salaryh_reduced loghh_income age_v3 gender education marital_status) ///
(getby_v2), ate metric(maha)  biasadj (salaryh_reduced loghh_income age_v3 gender education marital_status) 
tebalance summarize, baseline


/*Table E1*/ use: "fom.dta"
xi: xtmixed unemp_evaluations has_money_v1_centred worseoff_centred income_centred i.employment_status_centred age_centred male_centred /// 
c.education_centred reg_unemp_change_centred if voted_UR==0 ///
|| regions_v2:, mle variance

xi: xtmixed unemp_evaluations has_money_v1_centred worseoff_centred income_centred i.employment_status_centred age_centred male_centred c.education_centred ///
reg_unemp_change_centred if voted_UR==1 ///
|| regions_v2:, mle variance

xi:xtmixed putin_evaluations has_money_v1_centred worseoff_centred /// 
income_centred i.employment_status_centred age_centred male_centred c.education_centred  ///
reg_unemp_change_centred if voted_UR==0 ///
|| regions_v2:, mle variance

xi:xtmixed putin_evaluations has_money_v1_centred worseoff_centred income_centred /// 
i.employment_status_centred age_centred male_centred c.education_centred ///
reg_unemp_change_centred if voted_UR==1 ///
|| regions_v2:, mle variance

/*Table E1A*/
codebook unemp_evaluations has_money_v1 worseoff income employment_status ////
age male education voted_UR reg_unemp, compact

/*Table E1B*/
***First, for voted_UR=0** 
teffects nnmatch (unemp_evaluations worseoff income employment_status age male education) ///
(has_money), ate metric(maha)  biasadj (worseoff income employment_status age male education) ///
tebalance summarize, baseline

teffects nnmatch (putin_evaluations worseoff income employment_status age male education) /// 
(has_money_v1), ate metric(maha)  biasadj (worseoff income employment_status age male education) 
tebalance summarize, baseline

***Next, for voted_UR=1** 
teffects nnmatch (unemp_evaluations worseoff income employment_status age male education) (has_money_v1), ///
ate metric(maha)  biasadj (worseoff income employment_status age male education) 
tebalance summarize, baseline

teffects nnmatch (putin_evaluations worseoff income employment_status age male education) /// 
(has_money_v1), ate metric(maha)  biasadj (worseoff income employment_status age male education) 
tebalance summarize, baseline

/* Table E2*/ use: "ebrd.dta"
xi:xtmixed nationalgov_perf has_savings##c.democracy pcafirst age_respondent  gender_respondent ///
marital_status education worked_income risk_v1 gdp_growth, /// 
|| country:, mle variance
estat ic
/*To produce Figure E2*/margins, dydx (has_savings) at (democracy=(0(5)40)) atmeans level (95)


/* Table E3*/ use: "ebrd.dta"
xi:xtlogit voted_parliament has_savings pcafirst age_respondent  gender_respondent ///
marital_status education worked_income risk_v1 gdp_growth democracy, i(country)

xi:xtlogit voted_parliament has_savings pcafirst crisis_affected age_respondent  gender_respondent ///
marital_status education worked_income risk_v1 gdp_growth democracy, i(country)

xi:xtlogit voted_parliament has_savings pcafirst age_respondent  gender_respondent ///
marital_status education worked_income income_categories risk_v1 gdp_growth democracy, i(country)

