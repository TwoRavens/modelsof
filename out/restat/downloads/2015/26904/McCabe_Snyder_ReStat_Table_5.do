 log using McCabe_Snyder_ReStat_Table_5, replace

**********************************************************************
*
* Program McCabe_Snyder_ReStat_Table_5.DO
* 
* Computes descriptive statistics for self-archiving of pre-prints
* in Table 5. Uses information collected by research assistants on 
* subsample of 1,500 articles.   
*
* McCabe & Snyder August 2013
*
**********************************************************************

* Set initial Stata parameters
version 12
set more 1

use McCabe_Snyder_ReStat_archiving

gen pre_archive = (pre_nber_ind + pre_cepr_ind + pre_ssrn_ind + pre_repec_ind + pre_inst_ind) > 0
gen pre_sole = (pre_nber_ind + pre_cepr_ind + pre_ssrn_ind + pre_repec_ind + pre_inst_ind) == 1
gen post_archive = (post_nber_ind + post_cepr_ind + post_ssrn_ind + post_repec_ind + post_inst_ind) > 0
gen post_sole = (post_nber_ind + post_cepr_ind + post_ssrn_ind + post_repec_ind + post_inst_ind) == 1

* Columns for percent in repository

sort pyear
by pyear: summ pre_*_ind pre_archive
by pyear: summ post_*_ind post_archive
summ pre_*_ind pre_archive
summ post_*_ind post_archive

* Columns for precent in repository solely
 
 foreach var in nber cepr ssrn repec inst {
   gen pre_`var'_ind_sole = pre_`var'_ind * pre_sole
   gen post_`var'_ind_sole = post_`var'_ind * post_sole
   }
 
gen pre_archive_sole = pre_archive * pre_sole
gen post_archive_sole = post_archive * post_sole
sort pyear
by pyear: summ pre_*_ind_sole pre_archive_sole
by pyear: summ post_*_ind_sole post_archive_sole
summ pre_*_ind_sole pre_archive_sole
summ post_*_ind_sole post_archive_sole
