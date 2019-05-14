*******************
***TABLE 7 
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table7, replace

use main_part2_2, clear

keep if meanprice!=. & minpriceh!=.

collapse (mean) pop1827 grossinc1827 pcinc1827 meanprice minpriceh z suitindex distlima centerxgd centerygd, by(provincia)

gen lz = log(z)
gen ldistlima = log(distlima)


*COLUMNS 1, 2, AND 3 (province level data)

*1827 Estimated provincial income
	local replace replace 
	foreach var of varlist pop1827 pcinc1827 grossinc1827 { 
	reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, r
	outreg2 meanprice minpriceh using tab7.tex, `replace' pvalue bdec(3) tdec(3) nocons noni nor adds("R2",  e(r2))
	local replace
	}
	
	
	
*COLUMN 4 (district level data)
	
use main_part2_2, clear

keep if pop1827!=. & meanprice!=. & minpriceh!=.

*1876 district illiteracy
	local replace append
	foreach var of varlist shnonlit { 
	reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	outreg2 meanprice minpriceh using tab7.tex, `replace' pvalue bdec(3) tdec(3) nocons noni nor adds("Clusters", e(N_clust), "R2",  e(r2))
	local append
	}
	

log close
