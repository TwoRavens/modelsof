*********************************************
***TABLE 7 (Wild cluster bootstrap p-values)
*********************************************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using wildboot_table7, replace

use main_part2_2, clear

keep if meanprice!=. & minpriceh!=.

collapse (mean) pop1827 grossinc1827 pcinc1827 meanprice minpriceh z suitindex distlima centerxgd centerygd, by(provincia)

gen lz = log(z)
gen ldistlima = log(distlima)


*COLUMNS 1, 2, AND 3 (province level data)

*1827 Estimated provincial income

	foreach var of varlist pop1827 pcinc1827 grossinc1827 { 
	qui reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, r
	}
	
#delimit ;
xi: cgmwildboot pop1827 meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0  0  0);
# delimit cr

#delimit ;
xi: cgmwildboot grossinc1827 meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0  0  0);
# delimit cr

#delimit ;
xi: cgmwildboot pcinc1827 meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0  0  0);
# delimit cr




*COLUMN 4 (district level data)
	
use main_part2_2, clear

keep if pop1827!=. &  meanprice!=. & minpriceh!=.

*1876 district illiteracy

	foreach var of varlist shnonlit { 
	qui reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	}

#delimit ;
xi: cgmwildboot shnonlit meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0  0  0);
# delimit cr

log close
