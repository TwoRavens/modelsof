*******************
***TABLE 11
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table11, replace

use main_part2_2, clear

gen sample = 0
replace sample = 1 if shindig80!=. & shindig !=.

*COLUMNS 1 AND 2

	#delimit ;
	local replace replace;
	foreach var of varlist shindig80 shindig {;
	reg `var' meanprice minpriceh suitindex lz ldistlima centerxgd centerygd if sample==1, cluster(provincia);
	sum `var' if e(sample);
	local mean = r(mean);
	outreg2 meanprice minpriceh using tab11.tex, `replace' pvalue bdec(3) tdec(3) nocons nor noni adds("Mean DV", `mean');
	local replace;
	};
	# delimit cr

	
*COLUMNS 3 AND 4

merge 1:m ubigeo using main_part2_1
keep if _merge==3
drop _merge


	#delimit ;
	local replace append;
	foreach var of varlist QUE peasant_id {;
	reg `var' meanprice minpriceh adults infants kids age male suitindex lz ldistlima centerxgd centerygd if sample==1, cluster(provincia);
	sum `var' if e(sample);
	local mean = r(mean);
	outreg2 meanprice minpriceh using tab11.tex, `replace' pvalue bdec(3) tdec(3) nocons nor noni adds("Mean DV", `mean');
	local append;
	};
	# delimit cr

log close
	
	

