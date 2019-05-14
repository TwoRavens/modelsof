*********************************************
***TABLE 5 (Wild cluster bootstrap p-values)
*********************************************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using wildboot_table5, replace

********************************************
***PANEL A
********************************************

*COLUMNS 1 AND 2

use main_part2_1, clear

	foreach var of varlist lhhequiv schoolyears { 
	qui xi: reg `var' meanprice minpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	}

	
#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 );
# delimit cr

	
#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

	
*COLUMNS 3 AND 4

use main_part2_2, clear

	foreach var of varlist toilethouse mud { 
	qui xi: reg `var' meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	}

	
#delimit ;
xi: cgmwildboot toilethouse meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0  0);
# delimit cr


#delimit ;
xi: cgmwildboot mud meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0	0);
# delimit cr

	
********************************************
***PANEL B
********************************************

*COLUMNS 1 AND 2

use main_part2_1, clear

keep if meanprice!=. & minpriceh!=.

	foreach var of varlist lhhequiv schoolyears { 
	qui xi: reg `var' soldpc adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	}
	

#delimit ;
xi: cgmwildboot lhhequiv soldpc adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0);
# delimit cr


#delimit ;
xi: cgmwildboot schoolyears soldpc adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

	
	
*COLUMNS 3 AND 4

use main_part2_2, clear

keep if meanprice!=. & minpriceh!=.

	foreach var of varlist toilethouse mud { 
	qui xi: reg `var' soldpc lz suitindex ldistlima centerxgd centerygd, cluster(provincia)
	}


#delimit ;
xi: cgmwildboot toilethouse soldpc lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0  0);
# delimit cr

#delimit ;
xi: cgmwildboot mud soldpc lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0	0);
# delimit cr

log close
