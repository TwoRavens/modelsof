use ${dir_results}\smhazard_full_cpi_url_full_usa_all_100.dta, clear
 

*make NS plot
append using ${dir_data}\ns_hazards.dta
gen day=month*30

twoway line procfood day
label var procfood "NS (08) Processed Food"
sts graph , hazard noboundary kernel(gaussian)  level(99) tmax(250) width(1) xtitle("Days") addplot(line procfood day if day<250) title("Smoothed Hazard Estimate")

graph export ${dir_graphs}\survival_hazard_usa_all_100_cpi_url_NS.png , replace 

