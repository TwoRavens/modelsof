
* This do-file contains the commands for replicating all the tables in the paper, including the Online Appendix.

***************************
* Regional-level analysis *
***************************

use Replication_DB_Regional.dta,clear

*=========*
* Table 1 *
*=========*

reg leave_share import_shock i.nuts1, cluster(nuts2)

outreg2 using Table1.xls, nolabel bracket bdec(3) e(rkf) replace

xtmixed leave_share import_shock i.nuts1 ||nuts2:

outreg2  using Table1.xls, nolabel bracket bdec(3) e(rkf) append

xi:ivreg2 leave_share (import_shock=instrument_for_shock) i.nuts1, cluster(nuts2) 

outreg2  using Table1.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1, cluster(nuts2)

outreg2  using Table1.xls, nolabel bracket bdec(3) e(rkf) append

xtmixed leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 ||nuts2:

outreg2  using Table1.xls, nolabel bracket bdec(3) e(rkf) append

xi: ivreg2 leave_share immigrant_share immigrant_arrivals (import_shock=instrument_for_shock) i.nuts1, cluster(nuts2) 

outreg2  using Table1.xls, nolabel bracket bdec(3) e(rkf) append

*=========*
* Table 2 *
*=========*

reg leave_share import_shock immigrant_share immigrant_arrivals eu_access_imm_01 eu_access_imm_growth i.nuts1, cluster(nuts2)

outreg2 using Table2.xls, nolabel bracket bdec(3) e(rkf) replace

reg leave_share import_shock immigrant_share immigrant_arrivals eu_access_imm_01 eu_access_imm_growth eu_access_imm_01_int eu_access_imm_growth_int i.nuts1, cluster(nuts2)

outreg2 using Table2.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals fiscal_cuts cancer_62_days pub_empl_growth i.nuts1, cluster(nuts2)

outreg2 using Table2.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals fiscal_cuts cancer_62_days pub_empl_growth fiscal_cuts_int i.nuts1, cluster(nuts2)

outreg2 using Table2.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals eu_eco_dependence i.nuts1, cluster(nuts2)

outreg2 using Table2.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals change_rel_inc_med i.nuts1, cluster(nuts2)

outreg2 using Table2.xls, nolabel bracket bdec(3) e(rkf) append

*==========*
* Table A3 *
*==========*

reg leave_share import_shock immigrant_share immigrant_arrivals temporary_immigrants i.nuts1, cluster(nuts2)

outreg2 using TableA3.xls, nolabel bracket bdec(3) e(rkf) replace

reg leave_share import_shock immigrant_share immigrant_arrivals eu_access_imm_01 eu_access_imm_growth i.nuts1, cluster(nuts2)

outreg2 using TableA3.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals eu_access_imm_01 eu_access_imm_growth eu_access_imm_01_int eu_access_imm_growth_int i.nuts1, cluster(nuts2)

outreg2 using TableA3.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals eu_access_imm_01 eu_access_imm_growth eu_access_imm_01_int eu_access_imm_growth_int immigrant_share_int immigrant_arrivals_int i.nuts1, cluster(nuts2)

outreg2 using TableA3.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals eu_access_imm_01 eu_access_imm_growth eu_15_imm_01 eu_15_imm_growth other_imm_01 other_imm_growth i.nuts1, cluster(nuts2)

outreg2 using TableA3.xls, nolabel bracket bdec(3) e(rkf) append

*==========*
* Table A4 *
*==========*

reg leave_share import_shock immigrant_share immigrant_arrivals BNP_vote_share UKIP_vote_share LD_vote_share Labour_vote_share Green_vote_share Conservative_vote_share i.nuts1, cluster(nuts2)

outreg2 using TableA4.xls, nolabel bracket bdec(3) e(rkf) replace

reg leave_share import_shock immigrant_share immigrant_arrivals share_high_skill share_above_60 share_above_60_growth share_home_own share_home_own_growth share_council_rent share_council_rent_growth share_commuters_london, cluster(nuts2)

outreg2 using TableA4.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals fiscal_cuts cancer_62_days pub_empl_growth i.nuts1, cluster(nuts2)

outreg2 using TableA4.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals fiscal_cuts cancer_62_days pub_empl_growth fiscal_cuts_int i.nuts1, cluster(nuts2)

outreg2 using TableA4.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals fiscal_cuts cancer_62_days pub_empl_growth cancer_62_days_int i.nuts1, cluster(nuts2)

outreg2 using TableA4.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals fiscal_cuts cancer_62_days pub_empl_growth pub_empl_growth_int i.nuts1, cluster(nuts2)

outreg2 using TableA4.xls, nolabel bracket bdec(3) e(rkf) append

*==========*
* Table A5 *
*==========*

reg leave_share import_shock immigrant_share immigrant_arrivals agriculture agriculture_int i.nuts1, cluster(nuts2)

outreg2 using TableA5.xls, nolabel bracket bdec(3) e(rkf) replace

reg leave_share import_shock immigrant_share immigrant_arrivals eu_eco_dependence i.nuts1, cluster(nuts2)

outreg2 using TableA5.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals unemployment i.nuts1, cluster(nuts2)

outreg2 using TableA5.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals median_wage median_wage_growth i.nuts1, cluster(nuts2)

outreg2 using TableA5.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals change_rel_inc_med i.nuts1, cluster(nuts2)

outreg2 using TableA5.xls, nolabel bracket bdec(3) e(rkf) append

*==========*
* Table A6 *
*==========*

decode nuts1, gen(nuts1_code)

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) replace

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKC", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKD", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKE", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKF", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKG", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKH", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKJ", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKK", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append

reg leave_share import_shock immigrant_share immigrant_arrivals i.nuts1 if nuts1_code!="UKM"&nuts1_code!="UKI"&nuts1_code!="UKL", cluster(nuts2)

outreg2 using TableA6.xls, nolabel bracket bdec(3) e(rkf) append


*****************************
* Individual-level analysis *
*****************************

use Replication_DB_Individual_Wave8.dta,clear

*=========*
* Table 3 * 
*=========*

probit leave import_shock age gender i.nuts1code i.education [pweight=wt_full_W8], cluster(nuts3)

outreg2 using Table3.xls, nolabel bracket bdec(3) e(rkf) replace 

xtmixed leave import_shock age gender i.nuts1code i.education [pweight=wt_full_W8] ||nuts3:

outreg2 using Table3.xls, nolabel bracket bdec(3) e(rkf) append 

ivprobit leave age gender i.nuts1code i.education (import_shock=instrument_for_shock) [pweight=wt_full_W8], vce(cluster nuts3) 

outreg2 using Table3.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_full_W8], cluster(nuts3)

outreg2 using Table3.xls, nolabel bracket bdec(3) e(rkf) append 

xtmixed leave import_shock immigrant_share immigrant_arrival age gender  i.nuts1code i.education [pweight=wt_full_W8] ||nuts3:

outreg2 using Table3.xls, nolabel bracket bdec(3) e(rkf) append 

ivprobit leave immigrant_share immigrant_arrival age gender i.nuts1code i.education (import_shock=instrument_for_shock) [pweight=wt_full_W8], vce(cluster nuts3) 

outreg2 using Table3.xls, nolabel bracket bdec(3) e(rkf) append 

*=========*
* Table 4 * 
*=========*

probit leave import_shock retired retired_in immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_full_W8], cluster(nuts3)

outreg2 using Table4.xls, nolabel bracket bdec(3) e(rkf) replace 

probit leave import_shock student student_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_full_W8], cluster(nuts3)

outreg2 using Table4.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock unemployed unemployed_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_full_W8], cluster(nuts3)

outreg2 using Table4.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock manual manual_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_full_W7], cluster(nuts3)

outreg2 using Table4.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock selfemployed selfemployed_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_full_W8], cluster(nuts3)

outreg2 using Table4.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock  service service_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_full_W8], cluster(nuts3)

outreg2 using Table4.xls, nolabel bracket bdec(3) e(rkf) append 

*=========*
* Table 5 * 
*=========*

xtmixed immig_econ import_shock immigrant_share immigrant_arrival age gender i.nuts1code i.education ||nuts3:

outreg2 using Table5.xls, nolabel bracket bdec(3) e(rkf) replace 

xtmixed immig_cultural import_shock immigrant_share immigrant_arrival age gender i.nuts1code i.education ||nuts3:

outreg2 using Table5.xls, nolabel bracket bdec(3) e(rkf) append 

xtmixed immig_change import_shock immigrant_share immigrant_arrival age gender i.nuts1code i.education ||nuts3:

outreg2 using Table5.xls, nolabel bracket bdec(3) e(rkf) append 

xtmixed immig_policy import_shock immigrant_share immigrant_arrival age gender i.nuts1code i.education ||nuts3:

outreg2 using Table5.xls, nolabel bracket bdec(3) e(rkf) append 

*==========*
* Table A7 * 
*==========*

use Replication_DB_Individual_Wave9.dta,clear

probit leave import_shock age gender i.nuts1code i.education [pweight=wt_core_W9], cluster(nuts3)

outreg2 using TableA7.xls, nolabel bracket bdec(3) e(rkf) replace 

xtmixed leave import_shock age gender i.nuts1code i.education [pweight=wt_core_W9] ||nuts3:

outreg2 using TableA7.xls, nolabel bracket bdec(3) e(rkf) append 

ivprobit leave age gender i.nuts1code i.education (import_shock=instrument_for_shock) [pweight=wt_core_W9], vce(cluster nuts3) 

outreg2 using TableA7.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_core_W9], cluster(nuts3)

outreg2 using TableA7.xls, nolabel bracket bdec(3) e(rkf) append 

xtmixed leave import_shock immigrant_share immigrant_arrival age gender  i.nuts1code i.education [pweight=wt_core_W9] ||nuts3:

outreg2 using TableA7.xls, nolabel bracket bdec(3) e(rkf) append 

ivprobit leave immigrant_share immigrant_arrival age gender i.nuts1code i.education (import_shock=instrument_for_shock) [pweight=wt_core_W9], vce(cluster nuts3) 

outreg2 using TableA7.xls, nolabel bracket bdec(3) e(rkf) append 

*==========*
* Table A8 * 
*==========*

use Replication_DB_Individual_Wave9.dta,clear

probit leave import_shock retired retired_in immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_core_W9], cluster(nuts3)

outreg2 using TableA8.xls, nolabel bracket bdec(3) e(rkf) replace 

probit leave import_shock student student_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_core_W9], cluster(nuts3)

outreg2 using TableA8.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock unemployed unemployed_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_core_W9], cluster(nuts3)

outreg2 using TableA8.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock manual manual_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_full_W7], cluster(nuts3)

outreg2 using TableA8.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock selfemployed selfemployed_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_core_W9], cluster(nuts3)

outreg2 using TableA8.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock  service service_int immigrant_share immigrant_arrival age gender i.nuts1code i.education [pweight=wt_core_W9], cluster(nuts3)

outreg2 using TableA8.xls, nolabel bracket bdec(3) e(rkf) append 

*==========*
* Table A9 * 
*==========*

use Replication_DB_Individual_Wave8.dta,clear

probit leave import_shock i.nuts1code [pweight=wt_full_W8], cluster(nuts3)

outreg2 using TableA9.xls, nolabel bracket bdec(3) e(rkf) replace 

xtmixed leave import_shock i.nuts1code [pweight=wt_full_W8] ||nuts3:

outreg2 using TableA9.xls, nolabel bracket bdec(3) e(rkf) append 

ivprobit leave i.nuts1code (import_shock=instrument_for_shock) [pweight=wt_full_W8], vce(cluster nuts3) 

outreg2 using TableA9.xls, nolabel bracket bdec(3) e(rkf) append 

probit leave import_shock immigrant_share immigrant_arrival i.nuts1code [pweight=wt_full_W8], cluster(nuts3)

outreg2 using TableA9.xls, nolabel bracket bdec(3) e(rkf) append 

xtmixed leave import_shock immigrant_share immigrant_arrival i.nuts1code [pweight=wt_full_W8] ||nuts3:

outreg2 using TableA9.xls, nolabel bracket bdec(3) e(rkf) append 

ivprobit leave immigrant_share immigrant_arrival i.nuts1code (import_shock=instrument_for_shock) [pweight=wt_full_W8], vce(cluster nuts3) 

outreg2 using TableA9.xls, nolabel bracket bdec(3) e(rkf) append 



