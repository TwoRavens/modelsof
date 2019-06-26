* This is the replication file for the article 						*
* "Leave None to Claim the Land: A Malthusian Catastrophe in Rwanda?" 		*
* Author: Marijke Verpoorten 									*
* Date: November 2011 										* 
*******************************************************************************

clear all
set memory 200000

use "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\Data_LNTCL_Verpoorten_JPR.dta", replace

* online appendix: calculation of death toll *
*--------------------------------------------*

generate  deathtoll=(1 - ( (male_survivors+female_survivors) / (((1-nat_deathrate)^11)*tutsipop94))-nat_deathrate)
label variable deathtoll "estimated genocide death toll = proportion of Tutsi killed"

* anomalous values *
summarize deathtoll
summarize deathtoll if deathtoll<0
* we find 96 observations for which the deathtoll is negative *
generate  anomaly_deathtoll=0
replace anomaly_deathtoll=1 if deathtoll<0
label variable anomaly_deathtoll "negative values of deathtoll"

* Verpoorten (2005) provides evidence for 40% under-reporting of Tutsi in 1991 population census *
generate  ptutsi91_pref_c=ptutsi91_pref*1.4
generate  ptutsi91_com_c=ptutsi91_com*1.4
generate tutsipop94_c=tutsipop94*1.4
generate  deathtoll_c=(1 - ( (male_survivors+female_survivors) / (((1-nat_deathrate)^11)*tutsipop94_c))-nat_deathrate)
summarize deathtoll_c if deathtoll_c<0
generate  anomaly_deathtoll_c=0
replace anomaly_deathtoll_c=1 if deathtoll_c<0
label variable anomaly_deathtoll_c "negative values of deathtoll after correcting for under-reporting of Tutsi"
label variable deathtoll_c "estimated genocide death toll after correcting for under-reporting of Tutsi"
label variable ptutsi91_pref_c "province level % Tutsi after correcting for under-reporting of Tutsi in 1991 census"
label variable ptutsi91_com_c "commune level % of Tutsi after correcting for under-reporting of Tutsi in 1991 census"
label variable tutsipop94_c "sector level Tutis population after correcting for under-reporting of Tutsi in 1991 census"

* implications for regression analysis *
* in the main results, I remove the anomalous values from the sample *
generate deathtoll_rem=deathtoll
generate deathtollc_rem=deathtoll_c
replace deathtoll_rem=. if deathtoll<0&deathtoll~=.
replace deathtollc_rem=. if deathtoll_c<0&deathtoll_c~=.
* in a robustness check , I keep all observations, but censor the death toll to zero*
generate deathtoll_cen=deathtoll
generate deathtollc_cen=deathtoll_c
replace deathtoll_cen=0 if deathtoll<0&deathtoll~=.
replace deathtollc_cen=0 if deathtoll_c<0&deathtoll_c~=.
label variable deathtoll_rem "genocide death toll, anomalous values removed"
label variable deathtollc_rem "corrected for under-reporting of Tutsi, anomalous values removed"
label variable deathtoll_cen "genocide death toll, censored to zero"
label variable deathtollc_cen "corrected for under-reporting of Tutsi, censored to zero"

* commune level death toll *
sort com91
by com91: egen tutsipop94_com=sum(tutsipop94)
by com91: egen male_survivors_com=sum(male_survivors)
by com91: egen female_survivors_com=sum(female_survivors)
generate  deathtoll_com=(1 - ( (male_survivors_com+female_survivors_com) / (((1-nat_deathrate)^11)*tutsipop94_com))-nat_deathrate)
label variable deathtoll_com "estimated genocide death toll, commune level"
* anomalous values *
summarize deathtoll_com
summarize deathtoll_com if deathtoll_com<0
generate deathtollcom_rem=deathtoll_com
replace deathtollcom_rem=. if deathtoll_com<0&deathtoll_com~=.

save "C:\RwandaResearchProject\Repl_Verpoorten2011_JPR\dataset.dta", replace


