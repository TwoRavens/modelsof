
use "${dir_temp}\temp_${sales}_${database}.dta", clear

*first drop those obs with no price changes
drop if c_mprice!=1

*use this in tables
histogram gr_mprice if gr_mprice>=-50 & gr_mprice<=50, width(0.1)   percent kdensity scale(1) ytitle(% of changes) xtitle(Size of price change (%)) xlabel(#10) title(Distribution of Price Changes)
graph export ${dir_graphs}\distributionchanges3_${sales}_${database}.png, replace
graph export ${dir_graphs}\kernel_test_${sales}_${database}.png, replace
graph save ${dir_graphs}\kernel_main_${sales}_${database}, replace

*Keep density
kdensity gr_mprice if gr_mprice>=-50 & gr_mprice<=50, bwidth(1) normal recast(line) generate(x d)  
preserve
keep x d
drop if x==.
gen id="${simulation}"
save ${dir_results}\kernel_main_${sales}_${database}.dta, replace
restore

drop x d

clear
