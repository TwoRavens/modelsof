use NASM_base2, clear

scatter lrgdpchWB lrgdpchsurveys lrgdpchlight if base_sample==1 & lrgdpchlight>=12.5 & lrgdpchlight<=18.5 ///
|| lfit lrgdpchWB lrgdpchlight if base_sample==1, lc(blue) range(12.6 18.5) ///
|| lfit lrgdpchsurveys lrgdpchlight if base_sample==1, lc(red)  range(12.6 18.5) ///
 title("National Accounts, Survey Means and Lights") ytitle("Log GDP per Capita / Log Survey Mean") ///
 ylabel(,angle(horiz)) xtitle("Log Lights per Capita") legend(order(1 2) label(1 "Log GDP per Capita") label(2 "Log Survey Means")) ///
 note("Lines are regressions of measurement variable on log nighttime lights per capita")
