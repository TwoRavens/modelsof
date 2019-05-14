*******************
***TABLE 8 PANEL A
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table8, replace

use main_part2_2, clear

collapse (mean) anyreb_pre govreb_pre alltax_pre meanprice minpriceh pop54 lpop54 z suitindex distlima centerxgd centerygd, by(provincia)

gen lz=log(z)
gen ldistlima = log(distlima)


	#delimit ;
	local replace replace;
	foreach var of varlist anyreb_pre govreb_pre alltax_pre {;
	nbreg `var' meanprice minpriceh lpop54 lz suitindex ldistlima centerxgd centerygd, r;
	sum `var' if e(sample);
	local mean = r(mean);
	outreg2 meanprice minpriceh using tab8A.tex, `replace' pvalue bdec(3) tdec(3) nocons nor noni adds("Mean DV", `mean');
	local replace;
	};
	# delimit cr


*******************
***TABLE 8 PANEL B
*******************

use main_part2_2, clear

collapse (mean) anyreb_post govreb_post alltax_post meanprice minpriceh pop54 lpop54 z suitindex distlima centerxgd centerygd, by(provincia)

gen lz=log(z)
gen ldistlima = log(distlima)


	#delimit ;
	local replace replace;
	foreach var of varlist anyreb_post govreb_post alltax_post {;
	nbreg `var' meanprice minpriceh lpop54 lz suitindex ldistlima centerxgd centerygd, r;
	sum `var' if e(sample);
	local mean = r(mean);
	outreg2 meanprice minpriceh using tab8B.tex, `replace' pvalue bdec(3) tdec(3) nocons nor noni adds("Mean DV", `mean');
	local replace;
	};
	# delimit cr

	log close
