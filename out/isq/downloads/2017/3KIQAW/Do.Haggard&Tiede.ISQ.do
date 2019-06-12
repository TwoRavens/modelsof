*/Haggard and Tiede.  The Rule of Law in Post Conflict Settings:  The Empirical Record
*/April 2, 2013


*/ALL T-TESTS LEAVING IN OUTLIERS/ ENSURING SAMPLE SIZE CONSISTENT. PAPER TABLES 1 TO 3
*/freedom house civil liberties
ttest fhcl_5prior=newfhcl_conflictavg if fhcl_5prior!=. & newfhcl_conflictavg!=. 
ttest newfhcl_conflictavg=fhcl_postavg if fhcl_5prior!=. & newfhcl_conflictavg!=. 
ttest fhcl_5prior=fhcl_postavg if fhcl_5prior!=. & newfhcl_conflictavg!=. 
ttest newfhcl_conflictavg=fhcl_postc10avg if fhcl_5prior!=. & newfhcl_conflictavg!=.  
ttest fhcl_5prior=fhcl_postc10avg if fhcl_5prior!=. & newfhcl_conflictavg!=. 

*/freedom house political rights
ttest fhpr_5prior=newfhpr_conflictavg if fhpr_5prior!=. & newfhpr_conflictavg!=. 
ttest newfhpr_conflictavg=fhpr_postavg if fhpr_5prior!=. &  newfhpr_conflictavg!=. 
ttest fhpr_5prior=fhpr_postavg if fhpr_5prior!=. & newfhpr_conflictavg!=. 
ttest newfhpr_conflictavg=fhpr_postc10avg if fhpr_5prior!=. &  newfhpr_conflictavg!=. 
ttest fhpr_5prior=fhpr_postc10avg if fhpr_5prior!=. &  newfhpr_conflictavg!=. 

*/Henisz ji
ttest hj_5prior=hj_conflictavg if hj_5prior!=. & hj_conflictavg!=. 
ttest hj_conflictavg=hj_postavg if hj_5prior!=. & hj_conflictavg!=. 
ttest hj_5prior=hj_postavg if hj_5prior!=. & hj_conflictavg!=. 
ttest hj_conflictavg=hj_post10cavg if hj_5prior!=. & hj_conflictavg!=. 
ttest hj_5prior=hj_post10cavg if hj_5prior!=. & hj_conflictavg!=. 

*/Henisz political constraints
ttest hpolon_5prior=hpolcon_conflictavg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=. 
ttest hpolcon_conflictavg=hpolconf_postavg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=.  
ttest hpolon_5prior=hpolconf_postavg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=. 
ttest hpolcon_conflictavg=hpolcon_postc10avg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=. 
ttest hpolon_5prior=hpolcon_postc10avg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=. 

*/Polity

ttest polity2_5prior=polity2_conflictavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. 
ttest polity2_conflictavg=polity2_postavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. 
ttest polity2_5prior=polity2_postavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. 
ttest polity2_conflictavg=polity_post10cavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. 
ttest polity2_5prior=polity_post10cavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. 
 
*/new variables

ttest hfprights_conflict=hfprights_10post if hfprights_conflict!=. & hfprights_10post!=. & hfprights_5post!=.  
ttest hfprights_conflict=hfprights_5post if hfprights_conflict!=. & hfprights_10post!=. & hfprights_5post!=.  




*/ALL T-TESTS. ENSURING SAMPLE SIZE CONSISTENT/LEAVING OUT OUTLIERS
*/freedom house civil liberties
ttest fhcl_5prior=newfhcl_conflictavg if fhcl_5prior!=. & newfhcl_conflictavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest newfhcl_conflictavg=fhcl_postavg if fhcl_5prior!=. & newfhcl_conflictavg!=. & countryname!="Croatia" & countryname!="Peru"
ttest fhcl_5prior=fhcl_postavg if fhcl_5prior!=. & newfhcl_conflictavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest newfhcl_conflictavg=fhcl_postc10avg if fhcl_5prior!=. & newfhcl_conflictavg!=.  & countryname!="Croatia" & countryname!="Peru" 
ttest fhcl_5prior=fhcl_postc10avg if fhcl_5prior!=. & newfhcl_conflictavg!=. & countryname!="Croatia" & countryname!="Peru" 

*/freedom house political rights
ttest fhpr_5prior=newfhpr_conflictavg if fhpr_5prior!=. & fhpr_5prior!=. & countryname!="Croatia" & countryname!="Peru" 
ttest newfhpr_conflictavg=fhpr_postavg if fhpr_5prior!=. &  fhpr_5prior!=. & countryname!="Croatia" & countryname!="Peru" 
ttest fhcl_5prior=fhpr_postavg if fhpr_5prior!=. & fhpr_5prior!=. & countryname!="Croatia" & countryname!="Peru" 
ttest newfhpr_conflictavg=fhpr_postc10avg if fhpr_5prior!=. &  fhpr_5prior!=. & countryname!="Croatia" & countryname!="Peru" 
ttest fhpr_5prior=fhpr_postc10avg if fhpr_5prior!=. &  fhpr_5prior!=. & countryname!="Croatia" & countryname!="Peru"

*/Henisz ji
ttest hj_5prior=hj_conflictavg if hj_5prior!=. & hj_conflictavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest hj_conflictavg=hj_postavg if hj_5prior!=. & hj_conflictavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest hj_5prior=hj_postavg if hj_5prior!=. & hj_conflictavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest hj_conflictavg=hj_post10cavg if hj_5prior!=. & hj_conflictavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest hj_5prior=hj_post10cavg if hj_5prior!=. & hj_conflictavg!=. & countryname!="Croatia" & countryname!="Peru" 

*/Henisz political constraints
ttest hpolon_5prior=hpolcon_conflictavg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest hpolcon_conflictavg=hpolconf_postavg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=.  & countryname!="Croatia" & countryname!="Peru" 
ttest hpolon_5prior=hpolconf_postavg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest hpolcon_conflictavg=hpolcon_postc10avg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest hpolon_5prior=hpolcon_postc10avg if hpolon_5prior!=. & hpolcon_conflictavg!=. & hpolcon_postc10avg!=. & hpolconf_postavg!=. & countryname!="Croatia" & countryname!="Peru" 

*/Polity

ttest polity2_5prior=polity2_conflictavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest polity2_conflictavg=polity2_postavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest polity2_5prior=polity2_postavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest polity2_conflictavg=polity_post10cavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. & countryname!="Croatia" & countryname!="Peru" 
ttest polity2_5prior=polity_post10cavg if polity2_5prior!=. & polity2_conflictavg!=. & polity_post10cavg!=. & countryname!="Croatia" & countryname!="Peru" 
 
*/new variables

ttest hfprights_conflict=hfprights_10post if hfprights_conflict!=. & hfprights_10post!=. & hfprights_5post!=.  & countryname!="Croatia" & countryname!="Peru"
ttest hfprights_conflict=hfprights_5post if hfprights_conflict!=. & hfprights_10post!=. & hfprights_5post!=.  & countryname!="Croatia" & countryname!="Peru" 



***************
*/regressions
*/PAPER TABLE 4
reg fhcl_postc10avg fhcl_5prior lnpwt_rgdpch_postcyr1 lndead_sum 
reg fhpr_postc10avg fhpr_5prior lnpwt_rgdpch_postcyr1 lndead_sum 
regress pxconst_postcavg10yr pxconst_5prior lnpwt_rgdpch_postcyr1  lndead_sum 
regress hpolcon_postc10avg  hpolon_5prior lnpwt_rgdpch_postcyr1 lndead_sum 


*/ONLINE APPENDIX 1.  TABLE OA1.1

reg fhcl_postc10avg fhcl_5prior lnpwt_rgdpch_postcyr1 duration_lt 
reg fhpr_postc10avg fhpr_5prior lnpwt_rgdpch_postcyr1 duration_lt
regress pxconst_postcavg10yr pxconst_5prior lnpwt_rgdpch_postcyr1  duration_lt
regress hpolcon_postc10avg  hpolon_5prior lnpwt_rgdpch_postcyr1 duration_lt



*/ONLINE APPENDIX 3.  SETTLEMENT TYPE.  TABLES OA3.1 TO OA3.4
reg fhcl_postc10avg fhcl_5prior lnpwt_rgdpch_postcyr1 lndead_sum   vgovt_lt settle_truce_lt
reg fhcl_postc10avg fhcl_5prior lnpwt_rgdpch_postcyr1 duration_lt vgovt_lt settle_truce_lt

reg fhpr_postc10avg fhpr_5prior lnpwt_rgdpch_postcyr1 lndead_sum  vgovt_lt settle_truce_lt
reg fhpr_postc10avg fhpr_5prior lnpwt_rgdpch_postcyr1 duration_lt vgovt_lt settle_truce_lt

reg hpolcon_postc10avg hpolon_5prior lnpwt_rgdpch_postcyr1 lndead_sum   vgovt_lt settle_truce_lt
reg hpolcon_postc10avg hpolon_5prior lnpwt_rgdpch_postcyr1 duration_lt vgovt_lt settle_truce_lt

reg pxconst_postcavg10yr pxconst_5prior lnpwt_rgdpch_postcyr1 lndead_sum  vgovt_lt settle_truce_lt
reg pxconst_postcavg10yr pxconst_5prior lnpwt_rgdpch_postcyr1 duration_lt vgovt_lt settle_truce_lt


*/ONLINE APPENDIX 4.  UN INTERVENTION TABLES OA4.1 TO OA4.4
reg fhcl_postc10avg fhcl_5prior lnpwt_rgdpch_postcyr1 lndead_sum unintrvn_lt
reg fhcl_postc10avg fhcl_5prior lnpwt_rgdpch_postcyr1 duration_lt unintrvn_lt

reg fhpr_postc10avg fhpr_5prior lnpwt_rgdpch_postcyr1 lndead_sum  unintrvn_lt
reg fhpr_postc10avg fhpr_5prior lnpwt_rgdpch_postcyr1 duration_lt unintrvn_lt

reg hpolcon_postc10avg hpolon_5prior lnpwt_rgdpch_postcyr1 lndead_sum  unintrvn_lt
reg hpolcon_postc10avg hpolon_5prior lnpwt_rgdpch_postcyr1 duration_lt unintrvn_lt

reg pxconst_postcavg10yr pxconst_5prior lnpwt_rgdpch_postcyr1 lndead_sum  unintrvn_lt
reg pxconst_postcavg10yr pxconst_5prior lnpwt_rgdpch_postcyr1 duration_lt unintrvn_lt


