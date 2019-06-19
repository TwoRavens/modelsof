insheet using "g:\golf_p.csv"
generate lnvapp_16=ln(va_16/emp_16)
generate msale_16=ssale_16/sale_16
generate part_16=empss_16/emps_16
generate dtype_16=type_16!=1
rename dtype_16 multidum_16
generate lnemp_16=ln(emp_16)
generate lnhole_16=ln(hole_16)
generate lnva_16=ln(va_16)
generate lnemp2_16=lnemp_16^2
generate lnhole2_16=lnhole_16^2
generate lnemphole_16=lnemp_16*lnhole_16
generate lnpopdens=ln(popdens)
generate lnppopdens=ln(ppopdens)
egen num_16=count(number), by(pcity_16)
generate lnuser_16=ln(user_16)
egen lnpopdensmean=mean(lnpopdens)
generate hpopdensdum=lnpopdens>lnpopdensmean
log using "g:\golf_final_p"
regress lnva_16 lnemp_16 lnhole_16 msale_16 multidum_16 lnpopdens
regress lnva_16 lnemp_16 lnhole_16 msale_16 multidum_16 lnpopdens num_16
regress lnva_16 lnemp_16 lnhole_16 msale_16 multidum_16 lnpopdens lnppopdens
regress lnuser_16 lnemp_16 lnhole_16 msale_16 multidum_16 lnpopdens
regress lnuser_16 lnemp_16 lnhole_16 msale_16 multidum_16 lnpopdens num_16
regress lnva_16 lnemp_16 lnhole_16 lnemp2_16 lnhole2_16 lnemphole_16 msale_16 multidum_16 lnpopdens
regress lnuser_16 lnemp_16 lnhole_16 lnemp2_16 lnhole2_16 lnemphole_16 msale_16 multidum_16 lnpopdens
tabstat lnemp_16, by(hpopdensdum) stat(count, var, sd, p10, p25, p50, p75, p90, iqr)
regress lnva_16 lnemp_16 lnhole_16 msale_16 multidum_16
predict lntfp_16, residuals
tabstat lntfp_16, by(hpopdensdum) stat(count, var, sd, p10, p25, p50, p75, p90, iqr)
clear
