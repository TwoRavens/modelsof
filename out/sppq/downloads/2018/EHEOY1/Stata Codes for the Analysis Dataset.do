/*All data analyses in this paper were carried out using Stata/MP 14.0 for Windows (64-bit x86-64)*/


/* The following code is to produce the results in Table 1*/

use "C:\Users\Desktop\Analysis_Dataset.dta" 

set matsize 800
ssc install outreg2
set more off

sureg (lead_ln_edu_dev gov_dem##c.govpower_new uni_dem##c.lindsay_st uni_rub##c.lindsay_st ///
Squire folded_ranney_4yrs hvd_4yr inst6013_adacope citi6013 ln_revenue ln_f_edu ln_f_develop ///
 termlimits pctscorefixed bienniel balance_stringency_scale ///
 ln_local_aid ln_gdp_capita unemploymentrate d_edu s_d_dev i.stateid i.year) ///
(lead_ln_edu_all gov_dem##c.govpower_new uni_dem##c.lindsay_st uni_rub##c.lindsay_st ///
Squire folded_ranney_4yrs hvd_4yr inst6013_adacope citi6013 ln_revenue ln_f_edu ln_f_allocation ///
 termlimits pctscorefixed bienniel balance_stringency_scale ///
 ln_local_aid ln_gdp_capita unemploymentrate d_edu s_d_all i.stateid i.year) ///
(lead_ln_edu_red gov_dem##c.govpower_new uni_dem##c.lindsay_st uni_rub##c.lindsay_st ///
Squire folded_ranney_4yrs hvd_4yr inst6013_adacope citi6013 ln_revenue ln_f_edu ln_f_redistri ///
 termlimits pctscorefixed bienniel balance_stringency_scale ///
  ln_local_aid ln_gdp_capita unemploymentrate d_edu s_d_red i.stateid i.year) ///
(lead_ln_dev_all gov_dem##c.govpower_new uni_dem##c.lindsay_st uni_rub##c.lindsay_st ///
Squire folded_ranney_4yrs hvd_4yr inst6013_adacope citi6013 ln_revenue ln_f_develop ln_f_allocation ///
 termlimits pctscorefixed bienniel balance_stringency_scale ///
 ln_local_aid ln_gdp_capita unemploymentrate s_d_dev s_d_all i.stateid i.year) ///
(lead_ln_dev_red gov_dem##c.govpower_new uni_dem##c.lindsay_st uni_rub##c.lindsay_st ///
Squire folded_ranney_4yrs hvd_4yr inst6013_adacope citi6013 ln_revenue ln_f_develop ln_f_redistri ///
 termlimits pctscorefixed bienniel balance_stringency_scale ///
  ln_local_aid ln_gdp_capita unemploymentrate s_d_dev s_d_red i.stateid i.year) ///
(lead_ln_all_red gov_dem##c.govpower_new uni_dem##c.lindsay_st uni_rub##c.lindsay_st ///
Squire folded_ranney_4yrs hvd_4yr inst6013_adacope citi6013 ln_revenue ln_f_allocation ln_f_redistri ///
 termlimits pctscorefixed bienniel balance_stringency_scale ///
 ln_local_aid ln_gdp_capita unemploymentrate s_d_all s_d_red i.stateid i.year)
 
outreg2 using Table_1.doc, se bdec(3) sdec(3) word replace


/* The following code is to produce the graphs in Figure 1*/
/*for Panel (1)*/
margins,dydx(uni_dem) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_edu_dev))
marginsplot
/*for Panel (2)*/
margins,dydx(uni_dem) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_edu_all))
marginsplot
/*for Panel (5)*/
margins,dydx(uni_dem) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_dev_red))
marginsplot
/*for Panel (6)*/
margins,dydx(uni_dem) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_all_red))
marginsplot


/* The following code is to produce the graphs in Figure 2*/
/*for Panel (1)*/
margins,dydx(uni_rub) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_edu_dev))
marginsplot
/*for Panel (2)*/
margins,dydx(uni_rub) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_edu_all))
marginsplot
/*for Panel (3)*/
margins,dydx(uni_rub) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_edu_red))
marginsplot
/*for Panel (4)*/
margins,dydx(uni_rub) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_dev_all))
marginsplot
/*for Panel (6)*/
margins,dydx(uni_rub) at (lindsay_st=(0 (4) 32)) predict (equation(lead_ln_all_red))
marginsplot


/* The following code is to produce the results in Table A1 in Appendix 2*/
ren gov_dem democratic_governor

keep lead_ln_edu_dev lead_ln_edu_all lead_ln_edu_red lead_ln_dev_all lead_ln_dev_red lead_ln_all_red ///
democratic_governor govpower_new uni_dem lindsay_st uni_rub ///
Squire folded_ranney_4yrs hvd_4yr inst6013_adacope citi6013 ln_revenue ln_f_edu ln_f_develop ln_f_allocation ln_f_redistri ///
termlimits pctscorefixed bienniel balance_stringency_scale ///
ln_local_aid ln_gdp_capita unemploymentrate d_edu s_d_dev s_d_all s_d_red year

outreg2 using Table_A1.doc, replace sum(log)

