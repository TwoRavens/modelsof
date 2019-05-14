*******************
***TABLE 10
*******************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using Table10, replace

use main_part2_2, clear

	#delimit ;
	local replace replace;
	foreach var of varlist cases83 guerrilla83 authority83{;
	nbreg `var' meanprice minpriceh lpop90 suitindex lz ldistlima centerxgd centerygd, cluster(provincia);
	sum `var' if e(sample);
	local mean = r(mean);
	outreg2 meanprice minpriceh using tab10.tex, `replace' pvalue bdec(3) tdec(3) nocons nor noni 
	adds("Mean DV", `mean');
	local replace;
	};
	# delimit cr

log close
