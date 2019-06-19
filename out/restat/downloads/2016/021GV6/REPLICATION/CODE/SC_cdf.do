*Generate CDF for the Appendix
************************************************************************************************
use "${dir_temp}\temp_${sales}_${database}.dta", clear

*first drop those obs with no price changes
drop if c_mprice!=1

cumul gr_mprice, gen(cum)

sort cum
line cum gr_mprice, ylab(, grid) ytitle("") xlab(, grid) title("Cumulative Distribution") 

keep cum gr_mprice
gen id="${database}"
save ${dir_results}\cumm_main_${sales}_${database}.dta, replace

*******************************************************

