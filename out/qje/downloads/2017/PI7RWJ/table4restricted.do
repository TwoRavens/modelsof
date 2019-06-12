/* 

from table4_trustR2
NB: balanced sample across outcomes of age>=10 in 1972 

*/

/*set macros*/
global trustcontrols = "black_male_closetuskegee black_closetuskegee male_closetuskegee i.fips_st_current i.black#i.male i.age_cat i.married i.educ_cat"


/*ols*/
reg binary_mistrust $trustcontrols  , vce(cluster fips_st_current)
reg binary_deny $trustcontrols , vce(cluster fips_st_current)
reg notrust $trustcontrols  , vce(cluster fips_st_current) 
