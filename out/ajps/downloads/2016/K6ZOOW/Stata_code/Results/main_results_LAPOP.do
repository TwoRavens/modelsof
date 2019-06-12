***************************************************************************
* File:               main_results_LAPOP.do
* Author:             Miguel R. Rueda
* Description:        Presents main results using Latin American Public Opinion (LAPOP) data. 
* Created:            September - 22 - 2015
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************

use final_LAPOP.dta, clear

*Table 4 (appendix) and Table 1 third row (see summary stats of VB_self in the following output) 
quietly: logit  VB_self age female registered ed q10 reli news trust_c disint_pol help_c rural supporter llpob_mesa_av lown_resources lnbi_i lpopulation l2margin_index2_av l2lsize_av armed_actor i.muni_code  if year~=2007,cluster(muni_code)
sum VB_self turnouts_self lpob_mesa_av armed_actor l2size_av lown_resources l2margin_index2_av lnbi_i population age corrupt crime disint_pol ed female q10 help_c news supporter registered reli trust_c if e(sample)

*Table 4 and table 7 (appendix without misreporting models)
logit  VB_self age female ed q10 rural llpob_mesa_av lpopulation  if e(sample),cluster(muni_code)
logit  VB_self age female registered ed q10 reli news trust_c int_pol help_c rural supporter llpob_mesa_av lpopulation if e(sample),cluster(muni_code)
logit  VB_self age female registered ed q10 reli news trust_c int_pol help_c rural supporter llpob_mesa_av lown_resources lnbi_i lpopulation l2margin_index2_av l2lsize_av armed_actor i.muni_code  if year~=2007,cluster(muni_code)


*Computations of predicted probabilities in Cartagena (discussion in paper page 20)
logit VB_self age female registered ed q10 reli news trust_c int_pol help_c rural llpob_mesa_av lown_resources lnbi_i lpopulation l2margin_index2_av l2lsize_av armed_actor supporter i.muni_code if year~=2007,cluster(muni_code)
margins, at(age=35 female=0 ed=12 q10=5 registered=1 reli=3 news=4 rural=0 trust_c=3 supporter=1 int_pol=-3 help_c=2 l2margin_index2_av=.1422 lnbi_i=23 lown_resources=43.33 muni_code=13001 lpopulation=13.7564 armed_actor=0 l2lsize_av=14.83 llpob_mesa_av=5.7037825) 
margins, at(age=35 female=0 ed=12 q10=5 registered=1 reli=3 news=4 rural=0 trust_c=3 supporter=1 int_pol=-3 help_c=2 l2margin_index2_av=.1422 lnbi_i=23 lown_resources=43.33 muni_code=13001 lpopulation=13.7564 armed_actor=0 l2lsize_av=14.83 llpob_mesa_av=6.3969297) 

*Table 6, 5th column
logit turnouts_self age female registered ed q10 reli news trust_c int_pol help_c rural llpob_mesa_av lown_resources lnbi_i lpopulation l2margin_index2_av l2lsize_av armed_actor i.muni_code  if year~=2007,cluster(muni_code)

*Table 8 (appendix)
xi: sureg (VB_self age female registered ed q10 reli news trust_c int_pol help_c rural llpob_mesa_av lown_resources lnbi_i lpopulation l2margin_index2_av l2lsize_av armed_actor i.muni_code) (turnouts_self age female registered ed q10 reli news trust_c disint_pol help_c rural llpob_mesa_av lown_resources lnbi_i lpopulation l2margin_index2_av l2lsize_av armed_actor i.muni_code) if year~=2007 
test [turnouts_self]llpob_mesa_av=[VB_self]llpob_mesa_av
quietly: regress VB_self age if e(sample), cluster(muni_code) 
*Number of municipalities
display e(N_clust)


*For Table 7, column 2 (appendix) run panel_results_LAPOP_Table7_appendix.m in Matlab. 
*Matlab reports coefficient on lack of interest in politics. Multiply by -1 to obtain coefficient on interest in politics in Table 7.

