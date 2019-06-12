

*******************************************************************************
**Impact of IMF Programs on Perceived Creditworthiness of Emerging Market *****
**Countries: Is there a "Nixon-Goes-to-China" effect? *************************
*******************************************************************************

*** regression replication codes


qui tabulate cnumber, gen (country_dum)
qui tabulate year, gen (year_dum)
 

 
*** Table1*** 
xtreg logii imf_lag left_lag imf_left_lag polity_lag budget_lag ///
capcon_lag gdpgrowth_lag inf_lag current_lag linvest_lag fixed_lag ///
lreserve_lag ldebt_lag logii_lag year_dum*, fe i(cnumber) robust


*** Table3*** 
xi: reg logii_change signed_lag left_lag signed_left_lag /// 
polity_lag budget_change capcon_lag gdpgrowth  inf_change  ///
current_change fixed_lag linvest_change lres_change ldebt_change ///
logii_lag year_dum* i.cnumber, robust 


*** Table5*** 
xtreg logii imf_lag left_lag imf_left_lag yearoffice_lag  ///
polity_lag budget_lag capcon_lag gdpgrowth_lag inf_lag current_lag ///
linvest_lag fixed_lag lreserve_lag ldebt_lag logii_lag year_dum*, ///
fe i(cnumber) robust


xtreg logii imf_lag left_lag imf_left_lag noncomp_lag polity_lag ///
budget_lag capcon_lag gdpgrowth_lag inf_lag current_lag linvest_lag ///
fixed_lag lreserve_lag ldebt_lag logii_lag year_dum*, fe i(cnumber) robust


xtreg logii imf_lag left_lag imf_left_lag unvote_lag  imf_unvote_lag ///
 polity_lag budget_lag capcon_lag gdpgrowth_lag inf_lag current_lag ///
 linvest_lag fixed_lag lreserve_lag ldebt_lag logii_lag year_dum*, ///
 fe i(cnumber) robust 
