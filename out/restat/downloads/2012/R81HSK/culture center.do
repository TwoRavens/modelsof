insheet using "g:\culture_p.csv"
generate lnvapp_17=ln(va_17/emp_17)
generate msale_17=ssale_17/sale_17
generate part_17=empss_17/emps_17
generate dtype_17=type_17!=1
rename dtype_17 multidum_17
generate lnemp_17=ln(emp_17)
generate lnfloor_17=ln(floor_17)
generate lnva_17=ln(va_17)
generate lnemp2_17=lnemp_17^2
generate lnfloor2_17=lnfloor_17^2
generate lnempfloor_17=lnemp_17*lnfloor_17
generate lnpopdens=ln(popdens)
generate lnppopdens=ln(ppopdens)
egen num_17=count(number), by(pcity_17)
generate userterm_17=usera_17*terma_17+userb_17*termb_17+userc_17*termc_17+userd_17*termd_17+usere_17*terme_17+userf_17*termf_17+userg_17*termg_17
generate lnuserterm_17=ln(userterm_17)
egen lnpopdensmean=mean(lnpopdens)
generate hpopdensdum=lnpopdens>lnpopdensmean
log using "g:\culture_final_p"
regress lnva_17 lnemp_17 lnfloor_17 msale_17 multidum_17 lnpopdens
regress lnva_17 lnemp_17 lnfloor_17 msale_17 multidum_17 lnpopdens num_17
regress lnva_17 lnemp_17 lnfloor_17 msale_17 multidum_17 lnpopdens lnppopdens
regress lnuserterm_17 lnemp_17 lnfloor_17 msale_17 multidum_17 lnpopdens
regress lnuserterm_17 lnemp_17 lnfloor_17 msale_17 multidum_17 lnpopdens num_17
regress lnva_17 lnemp_17 lnfloor_17 lnemp2_17 lnfloor2_17 lnempfloor_17 msale_17 multidum_17 lnpopdens
regress lnuserterm_17 lnemp_17 lnfloor_17 lnemp2_17 lnfloor2_17 lnempfloor_17 msale_17 multidum_17 lnpopdens
tabstat lnemp_17, by(hpopdensdum) stat(count, var, sd, p10, p25, p50, p75, p90, iqr)
regress lnva_17 lnemp_17 lnfloor_17 msale_17 multidum_17
predict lntfp_17, residuals
tabstat lntfp_17, by(hpopdensdum) stat(count, var, sd, p10, p25, p50, p75, p90, iqr)
clear
