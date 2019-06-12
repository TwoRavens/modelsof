*****************************
** Replication Code Analysis for Revised Version of When The Money Stops Revision
*****************************

* This replication code is for the Life in Transition (LiTS) Surveys, wave 2006 & wave 2010 

*****************************
**** Tables in Main Text 
*****************************

/*Table 1*/ use "EBRD_2006_Replication.dta" 
/*NB: "cntry" without Mongolia and Turkey, "country" with Mongolia and Turkey*/

* Table 1, Model 1*
xi: xtmixed current_hh has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || cntry:, mle variance
estat ic
* Table 1, Model 2*
xi: xtmixed econ_satisfaction has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || cntry:, mle variance
estat ic
* Table 1, Model 3*
xi: xtmixed president_trust has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || cntry:, mle variance
estat ic
*Model 1, Model 4*
xi: xtmixed president_trust has_remittances current_hh econ_satisfaction  employed education age gender wealth_index i.tablec gdp_growth06 || cntry:, mle variance
estat ic


/*Table 4*/ use "EBRD_2010_Replication.dta"
* Model 1* 
xi:xtmixed nationalgov_perf remittances_reduced age_respondent gender_respondent marital_status worked_income ///
wealth_index education life_sat risk_v2 gdp_growth || country_:, mle variance
estat ic

* Model 2* 
xi: xtlogit blame_ourgov remittances_reduced age_respondent gender_respondent marital_status worked_income ///
wealth_index education life_sat risk_v2 gdp_growth, i(country)
estat ic

*****************************
***** Supplementary Information Tables 
*****************************

/*Table A.1*/ use "EBRD_2006_Replication.dta" 
codebook president_trust econ_satisfaction current_hh has_remittances employed education age gender wealth_index tablec gdp_growth06, compact 

/*Table A.6*/ use "EBRD_2010_Replication.dta" 
codebook nationalgov_perf blame_ourgov remittances_reduced worked_income age_respondent gender_respondent marital_status education wealth_index life_sat risk_v2 gdp_growth, compact 

/*Table B.1*/ use "EBRD_2006_Replication.dta" 
* Model 1*
xi: xtmixed current_hh has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || cntry:, mle variance
estat ic

* Model 2*
xi: xtmixed econ_satisfaction has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || cntry:, mle variance
estat ic

* Model 3*
xi: xtmixed president_trust has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || cntry:, mle variance
estat ic

* Model 4*
xi: xtmixed president_trust has_remittances current_hh econ_satisfaction  employed education age gender wealth_index i.tablec gdp_growth06 || cntry:, mle variance
estat ic


/*Table C.1*/ use "EBRD_2006_Replication.dta" 
* Model 1*
xi: xtmixed current_hh has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || country:, mle variance
estat ic

* Model 2*
xi: xtmixed econ_satisfaction has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || country:, mle variance
estat ic

* Model 3*
xi: xtmixed president_trust has_remittances employed education age gender wealth_index i.tablec gdp_growth06 || country:, mle variance
estat ic

* Model 4*
xi: xtmixed president_trust has_remittances current_hh econ_satisfaction  employed education age gender wealth_index i.tablec gdp_growth06 || country:, mle variance
estat ic


/*Table C.2*/ use "EBRD_2006_Replication.dta" 
teffects nnmatch (current_hh employed education age gender wealth_index i.tablec gdp_growth06) (has_remittances), ate metric(maha) biasadj (employed education age gender wealth_index i.tablec gdp_growth06) 
tebalance summarize
*Match for Sociotropic Assessments as the DV*
teffects nnmatch (econ_satisfaction employed education age gender wealth_index i.tablec gdp_growth06) (has_remittances), ate metric(maha) biasadj (employed education age gender wealth_index i.tablec gdp_growth06) 
tebalance summarize
*Match for Trust as the DV*
teffects nnmatch (president_trust employed education age gender wealth_index i.tablec gdp_growth06) (has_remittances), ate metric(maha) biasadj (employed education age gender wealth_index i.tablec gdp_growth06) 
tebalance summarize


/*Table C.15*/ use "EBRD_2010_Replication.dta"
*Match for Government assessments as the DV*
teffects nnmatch (nationalgov_perf age_respondent gender_respondent marital_status worked_income wealth_index education life_sat risk_v2) ///
(remittances_reduced), ate metric(maha) ///
biasadj (age_respondent gender_respondent marital_status worked_income wealth_index education life_sat risk_v2) ///
tebalance summarize

*Match for Blame attribution as the DV*
teffects nnmatch (blame_ourgov age_respondent gender_respondent marital_status worked_income wealth_index education life_sat risk_v2) ///
(remittances_reduced), ate metric(maha) ///
biasadj (age_respondent gender_respondent marital_status worked_income wealth_index education life_sat risk_v2) ///
tebalance summarize

/*Table D.5*/ use "EBRD_2010_Replication.dta"
/*Model 1*/
xi:xtmixed nationalgov_perf remittances_reduced##c.help_child age_respondent gender_respondent ///
marital_status worked_income wealth_index education life_sat risk_v2 gdp_growth || country_:, mle variance
estat ic

/*Model 2*/
xi:xtmixed nationalgov_perf remittances_reduced##c.help_house age_respondent gender_respondent ///
marital_status worked_income wealth_index education life_sat risk_v2 gdp_growth || country_:, mle variance
estat ic

/*Model 3*/
xi:xtmixed nationalgov_perf remittances_reduced##c.help_tsa age_respondent gender_respondent ///
marital_status worked_income wealth_index education life_sat risk_v2 gdp_growth || country_:, mle variance
estat ic

/*Model 4*/
xi:xtmixed nationalgov_perf remittances_reduced##c.help_un age_respondent gender_respondent ///
marital_status worked_income wealth_index education life_sat risk_v2 gdp_growth || country_:, mle variance
estat ic

