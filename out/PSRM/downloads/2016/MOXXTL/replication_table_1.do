*******************************************************************************
* do file for "The perverse consequences of policy restrictions in the presence 
*              of asymmetric information"
* replications of table 1
*******************************************************************************

clear
ssc install outreg
set mem 200m

cd "C:\Users\hortalav\Dropbox\Research\_Submitted\RestrictChoice\RestrictChoice (shared)\NewApproach(June2013)\Replication files"

log using replication_table_1

** IMPORT TEXT DATA CREATED BY MATLAB **
import delimited results_simulation_RC_bootstrap_A2.txt, delimiter(comma) varnames(1) case(preserve) clear
save results_simulation_RC_bootstrap_A2.dta, replace
import delimited results_simulation_RC_bootstrap_B2.txt, delimiter(comma) varnames(1) case(preserve) clear
save results_simulation_RC_bootstrap_B2.dta, replace
use results_simulation_RC_bootstrap_A2.dta, clear
merge 1:1 step using results_simulation_RC_bootstrap_B2.dta
drop _merge
save results_simulation_RC_bootstrap_2.dta, replace

** CREATE AND RENAME VARIABLES **
use results_simulation_RC_bootstrap_2.dta, clear
rename cost OLD_cost
gen cost = round(p*alpha*ln(T1_NR)+(1-p)*alpha*ln(T2_NR)-p*alpha*ln(T1_R)-(1-p)*alpha* ln(T2_R),0.000000001)
gen cost_d = (cost>0)
replace cost_d =  -1 if cost<0
tab cost_d
gen sigma_dif = abs(sigma_1-sigma_2)
gen mu_dif    = abs(   mu_1-   mu_2)
gen w_1=mu_1+(sigma_1^2)/2
gen w_2=mu_2+(sigma_2^2)/2
gen w_dif = abs(w_1-w_2)
gen y2 = y^2
gen no_diff_NR  = (t1_NR==t2_NR)
gen no_diff_R  = (t1_R==t2_R)
tab cost_d no_diff_NR
tab no_diff_NR no_diff_R

/* In 55% of our observations there is no difference between the policies 
adopted by the median voter in the two states of the worls (when no restr.). 
This almost  perfectly coincides with the observations when the costs of restr
is zero (there are 12 observations in which it is not). */
 

** TABLE 1 **
sum cost y y2 alpha abst_1 p  mu_1 mu_2 sigma_1 sigma_2 A B w_dif if cost!=0
corr cost y y2 alpha abst_1 p  mu_1 mu_2 sigma_1 sigma_2 A B w_dif if cost!=0
reg cost  y alpha abst_1 p  mu_1 mu_2 sigma_1 sigma_2 A B if cost!=0
outreg using RestrictChoice_Simulation.tex, replace bdec(4) se tex varlabels starlevels(10 5 1) sigsymbols(+,*,**) ctitle("", "(1)") 
reg cost y y2 alpha abst_1 p  mu_1 mu_2 sigma_1 sigma_2 A B  if cost!=0
outreg using RestrictChoice_Simulation.tex, merge bdec(4) se tex varlabels starlevels(10 5 1) sigsymbols(+,*,**) ctitle("", "(2)") 
reg cost y y2 alpha abst_1 p  mu_1 mu_2 sigma_1 sigma_2 A B w_dif if cost!=0
outreg using RestrictChoice_Simulation.tex, merge bdec(4) se tex varlabels starlevels(10 5 1) sigsymbols(+,*,**) ctitle("", "(3)") 

log close
translate replication_table_1.smcl replication_table_1.log 
translate replication_table_1.smcl replication_table_1.pdf



