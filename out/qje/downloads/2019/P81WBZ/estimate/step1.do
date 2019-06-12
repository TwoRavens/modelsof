#delimit ;

clear ;


* For the main specification ;

* The noconstant option does not change the coef/var of log distance. ;
local path = "./estimate/results/ancient/v20170924/twostep/noc/qa01Dropma02Known/main/step1/" ;

import delimited "`path'step1_processed.csv", clear ;
ppml s_ij ln_dist origin_dummy* destination_dummy* ;

* Save dataset with variables that were kept ;
keep id_i id_j s_ij `e(included)' ;

* Add that constant ;
gen const = 1 ;

export delimited "`path'step1_data.csv", replace ;

* Save coefficient vector and variance-covariance matrix ;
clear ;
matrix coefs = e(b)' ;
svmat coefs ;
export delimited "`path'coefs.csv", replace novarnames ;

clear ;
matrix var = e(V) ;
svmat var ;
export delimited "`path'var.csv", replace novarnames ;


/*
* For the proof of concept ;

* The noconstant option does not change the coef/var of log distance. ;
foreach t in "lose/ha03Unknown"
	     "lose/ka01Unknown"
	     "lose/ka02Unknown"
	     "lose/ta01Unknown"
	     "lose/ha02Unknown"
	     "lose/hu01Unknown"
	     "lose/ma01Unknown"
	     "lose/ma02Unknown"
	     "lose/sa02Unknown"
	     "lose/sa03Unknown"
	     "lose/ti01Unknown"
	     "lose/ul01Unknown"
	     "lose/un01Unknown"
	     "lose/wa01Unknown"
	     "lose/zi01Unknown" { ;
	local path = "./estimate/results/ancient/v20170924/twostep/noc/qa01Dropma02Known/`t'/step1/" ;
	import delimited "`path'step1_processed.csv", clear ;
	ppml s_ij ln_dist origin_dummy* destination_dummy* ;

	* Save dataset with variables that were kept ;
	keep id_i id_j s_ij `e(included)' ;
	ppml s_ij ln_dist origin_dummy* destination_dummy* ;

	* Add that constant ;
	gen const = 1 ;

	export delimited "`path'step1_data.csv", replace ;

	* Save coefficient vector and variance-covariance matrix ;
	clear ;
	matrix coefs = e(b)' ;
	svmat coefs ;
	export delimited "`path'coefs.csv", replace novarnames ;

	clear ;
	matrix var = e(V) ;
	svmat var ;
	export delimited "`path'var.csv", replace novarnames ;
} ;
*/
