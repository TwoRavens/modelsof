/* Stata Codes for Reconstructing the Variables Used in the Analysis Dataset */

/* Notes: 
1. The following codes show how select variables are transformed prior to data analysis. This does not include the variables for which
no data transformation is involved. For more information about each variable, see the Codebook. 
2. Using the variables in the Source Dataset, one can implement the following Stata codes to generate the variables used in the Analysis Dataset. 
Though the two datasets can then be merged together with two identifiers of stateid and year, there is no need to do so to reproduce results
using the Analysis Dataset. The Analysis Dataset has all the variables needed in the final data analysis, including those generated from the Source Dataset.*/


/* Part A: Constructing the Dependent Variables*/ 

/* First, the following codes assign state expenditures in different functional areas to three categories based on Peterson's (1981) theory. 
Note that education is an independent category, so there is no need to group multiple categories.*/

use "C:\Users\Desktop\Source_Dataset.dta"

egen develop_i=rowtotal( highway_i parks_nr)

egen allocation_i=rowtotal( govt_adm law_enf correct)

egen redistribute_i=rowtotal( welfare_i health_i hospitals)

/* Second, the following codes generate log ratios for each of the six pairs of state expenditures in education, development, redistribution,
and allocation.*/
gen ln_edu_dev=ln(education_i/develop_i)

gen ln_edu_all=ln(education_i/allocation_i)

gen ln_edu_red=ln(education_i/redistribute_i)

gen ln_dev_all=ln(develop_i/allocation_i)

gen ln_dev_red=ln(develop_i/redistribute_i)

gen ln_all_red=ln(allocation_i/redistribute_i)

/* Third, a one-year lead is taken for the dependent variables, which is equivalent to a one-year lag for all independent variables. */
gen lead_ln_edu_dev=F.ln_edu_dev

gen lead_ln_edu_all=F.ln_edu_all

gen lead_ln_edu_red=F.ln_edu_red

gen lead_ln_dev_all=F.ln_dev_all

gen lead_ln_dev_red=F.ln_dev_red

gen lead_ln_all_red=F.ln_all_red


/* Part B: Constructing Variables of Federal Grants*/

/* In general, it takes three steps to generate variables of federal grants. First, CPI is adjusted to account for inflation. The CPI transformation
are not shown for some variables because they have already been completed in original data. Second, federal grants in different functional areas are 
grouped into four categories of development, allocation, redistribution, and education based on Peterson's (1981) theory. Third, the natural log transformation
is taken for each variable. */

gen f_parks_cpi=f_parks*cpi
egen f_develop=rowtotal(f_highway f_parks_cpi)
gen ln_f_develop=ln(f_develop)

egen f_allocation=rowtotal(f_gov_admin f_law f_corrections)
gen f_allocation_cpi=f_allocation*cpi
gen ln_f_allocation=ln(f_allocation_cpi)

gen f_hospital_cpi=f_hospital*cpi
egen f_redistri=rowtotal(f_welfare f_health f_hospital_cpi)
gen ln_f_redistri=ln(f_redistri)

gen ln_f_edu=ln(f_edu)


/* Part C: Constructing Demand Indicators*/

/* Except for education, it takes two steps to generate such measures. First, the demand indicator in each functional area is standardized.*/
egen s_d_highway=std(d_highway)
egen s_d_park=std(d_park)
egen s_d_govt=std(d_govt)
egen s_d_law=std(d_law)
egen s_d_correct=std(d_correct)
egen s_d_hospital=std(d_hospital)
egen s_d_wel=std(d_wel)
egen s_d_health=std(d_health)

/* Second, the standardized demand indicators in different functional areas are grouped into three categories of development, allocation, and redistribution
based on Peterson's (1981) theory.*/
egen s_d_dev=rowtotal(s_d_highway s_d_park)
egen s_d_all=rowtotal( s_d_govt s_d_law s_d_correct)
egen s_d_red=rowtotal( s_d_hospital s_d_wel s_d_health)

/* Part D: Constructing Other Control Variables*/

/* It takes two steps to generate the variables of own source revenue, grants to local governments, and GDP per capita. 
First, the original variable is adjusted for CPI. Second, the natural log transformation is taken. */
gen revenue_cpi=total_rev_own_sources_i*cpi
gen ln_revenue=ln(revenue_cpi)

gen local_aid_cpi=local_aid*cpi
gen ln_local_aid_cpi=ln(local_aid_cpi)

gen gdp_capita_cpi= gdp_capita_i*cpi
gen ln_gdp_capita=ln( gdp_capita_cpi)


/* One can merge this Source Dataset and the Analysis Dataset with the following code*/
merge 1:1 stateid year using "C:\Users\Desktop\Analysis_Dataset.dta" 

