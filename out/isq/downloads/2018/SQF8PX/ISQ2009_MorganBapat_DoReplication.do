*/Replication of “Multilateral Versus Unilateral Sanctions Reconsidered: A Test Using New Data”

set mem 100m

log using "C:\Users\bapat\Desktop\Directory\Sanctions_Institutions\replication4.smcl"

use "C:\Users\bapat\Desktop\Directory\Sanctions_Institutions\SANXINSTITUTIONPAPER_RR.dta", clear


tab finaloutcome

*/According to the codebook, any outcome that is lower than 6 represents something that occurs in the threat stage prior to 
*/sanctions imposition. We see that these erroneous cases represent 3.83% of the data, so these case are removed. 
*/This leaves 502 cases of sanctions imposition. The next step is to repeat the analysis done in Tables 1-3.


*/ Next step is to replicate Tables 1 - 3. Begin with Table 1. 

tab multilateral security_issue, row col chi2

*/The numbers are slightly different, but there is little change in the column percentages. 38.71% of the cases are 
*/multilateral (as opposed to 38% previously) due to dropped data. 49% of multilateral cases involve security disputes,
*/although security disputes only comprise about 18.5% of the data. 

tab success security_issue, row col chi2

*/This replicates Table 2 

tab success security_issue, row col chi2

*/This replicates Table 2. We see here that success occurs more often in security disputes. There is a 
*/47.3% success rate in security disputes as opposed to an 18.09% rate in non-security disputes, which is
*/a 162% increase.

sort HSE
sort security_issue
by security_issue: tab success multilateral, row col chi2


*/Notice the only changes are in the non-successes versus the successes. The results are comparable to 
*/the earlier ones. However, we do see that in security issues, 58% of multilateral sanctions succeed as 
*/opposed to 40.35% of unilateral ones.

*/Now replicate Table 4

sort HSE

by HSE: tab success multilateral, row col chi2

*/Now turn to public goods explanation - where the "-99" errors are particularly problematic. 
tab targetcosts
gen targetcosts_corrected = targetcosts
replace targetcosts_corrected=. if targetcosts==-99
tab targetcosts_corrected
*/36 cases are dropped.

tab sendercosts
gen sendercosts_corrected = sendercosts
replace sendercosts_corrected=. if sendercosts==-99
tab sendercosts_corrected

*/27 cases dropped

*/Now replicate Table 5

probit success multilateral Institut, robust
probit success multilateral Institut publicgood_optimal, robust

*/As in the first version, only institution is significant 
*/Now test with the corrected costs measures

probit success multilateral Institut publicgood_optimal security_issue targetcosts_corrected sendercosts_corrected, robust

*/ The public good interaction is no longer statistically significant - which contradicts the public goods hypothesis. 
*/ Although this removes the significant coefficient, it is consistent 
*/ with our conclusion that there is no support for the public goods hypothesis. On p. 1089, first and second line, 
*/ we state that "We therefore must reject the public goods explanation, and next move to our tests of the spatial hypotheses."

*/Now check again with controls...

probit success multilateral Institut publicgood_optimal security_issue targetcosts_corrected sendercosts_corrected gdpen_1 gdpen_2 lndurable2 jointdem s_wt_glo rpc_4 distance US coldwar duration, robust

*/Same result here - public goods doesn't hold. Now check without the interaction term...

probit success multilateral Institut  security_issue targetcosts_corrected sendercosts_corrected , robust

probit success multilateral Institut security_issue targetcosts_corrected sendercosts_corrected gdpen_1 gdpen_2 lndurable2 jointdem s_wt_glo rpc_4 distance US coldwar duration, robust

*/With no interaction and no controls, we see that multilateral is still significant, but this is not consistent with the public goods 
*/explanation - it should only work if coupled with an institution. So again, we must reject the public goods hypothesis.

*/Now turn to spatial theory

*/probit success multilateral multiissue noinstitution chaos, robust

*/With controls...

probit success multilateral multiissue noinstitution chaos security_issue targetcosts_corrected sendercosts_corrected, robust

*/Chaos interaction is still statistically significant even with the corrections. To be sure...

tab targetcosts_corrected

tab sendercosts_corrected

*/Now check the full model...

probit success multilateral multiissue noinstitution chaos security_issue targetcosts_corrected sendercosts_corrected gdpen_1 gdpen_2 lndurable2 jointdem s_wt_glo rpc_4 distance US coldwar duration, robust


by HSE: probit success multilateral multiissue noinstitution chaos security_issue targetcosts_corrected sendercosts_corrected gdpen_1 gdpen_2 lndurable2 jointdem s_wt_glo rpc_4 distance US coldwar duration, robust

*/Chaos holds in the HSE cases, but there are too few so the evidence is not strong. Examine the crosstab: 

gen optimal_spatial = 0
replace optimal_spatial = 1 if Institut==1 & multilateral==1 & multiissue==1

tab success optimal_spatial, row col chi2

*/Replicates Table 7, and we see the 20 drops are all in the (0,0) category. See again that 77.78% of cases where the optimal conditions are met produce success, 
*/whereas only 21.49% of the cases where  these conditions are not fulfilled produce success.




