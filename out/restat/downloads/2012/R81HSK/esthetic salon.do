insheet using "g:\esthetic_p.csv"
generate lnvapp_14=ln(va_14/emp_14)
generate msale_14=ssale_14/sale_14
generate part_14=empss_14/emps_14
generate dtype_14=type_14!=1
rename dtype_14 multidum_14
generate lnemp_14=ln(emp_14)
generate lnbed_14=ln(bed_14)
generate lnva_14=ln(va_14)
generate lnemp2_14=lnemp_14^2
generate lnbed2_14=lnbed_14^2
generate lnempbed_14=lnemp_14*lnbed_14
generate lnpopdens=ln(popdens)
generate lnppopdens=ln(ppopdens)
egen num_14=count(number), by(pcity_14)
generate user_14=usera_14+userb_14
generate lnuser_14=ln(user_14)
egen lnpopdensmean=mean(lnpopdens)
generate hpopdensdum=lnpopdens>lnpopdensmean
log using "g:\esthetic_final_p"
regress lnva_14 lnemp_14 lnbed_14 msale_14 multidum_14 lnpopdens
regress lnva_14 lnemp_14 lnbed_14 msale_14 multidum_14 lnpopdens num_14
regress lnva_14 lnemp_14 lnbed_14 msale_14 multidum_14 lnpopdens lnppopdens
regress lnuser_14 lnemp_14 lnbed_14 msale_14 multidum_14 lnpopdens
regress lnuser_14 lnemp_14 lnbed_14 msale_14 multidum_14 lnpopdens num_14
regress lnva_14 lnemp_14 lnbed_14 lnemp2_14 lnbed2_14 lnempbed_14 msale_14 multidum_14 lnpopdens
regress lnuser_14 lnemp_14 lnbed_14 lnemp2_14 lnbed2_14 lnempbed_14 msale_14 multidum_14 lnpopdens
tabstat lnemp_14, by(hpopdensdum) stat(count, var, sd, p10, p25, p50, p75, p90, iqr)
regress lnva_14 lnemp_14 lnbed_14 msale_14 multidum_14
predict lntfp_14, residuals
tabstat lntfp_14, by(hpopdensdum) stat(count, var, sd, p10, p25, p50, p75, p90, iqr)
clear
