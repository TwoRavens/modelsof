*********************************************
***TABLE 11 (Wild cluster bootstrap p-values)
*********************************************

capture log close
clear 
cd "C:\Users\jenny\Dropbox\Replication Office-selling\Main"
log using wildboot_table11, replace

use main_part2_2, clear

*COLUMNS 1 AND 2

gen sample = 0
replace sample = 1 if shindig80!=. & shindig !=.


	#delimit ;
	foreach var of varlist shindig80 shindig {;
	qui reg `var' meanprice minpriceh suitindex lz ldistlima centerxgd centerygd if sample==1, cluster(provincia);
	};
	# delimit cr


keep if sample==1
	
#delimit ;
xi: cgmwildboot shindig80 meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null( 0  0   0   0  0  0 0 );
# delimit cr


#delimit ;
xi: cgmwildboot shindig meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null( 0  0   0   0  0  0 0 );
# delimit cr


*COLUMNS 3 AND 4

merge 1:m ubigeo using main_part2_1
keep if _merge==3
drop _merge


	#delimit ;
	qui reg `var' meanprice minpriceh adults infants kids age male suitindex lz ldistlima centerxgd centerygd if sample==1, cluster(provincia);
	# delimit cr


#delimit ;
xi: cgmwildboot QUE meanprice minpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0  0  0   0   0  0  0 0 );
# delimit cr


#delimit ;
xi: cgmwildboot peasant_id meanprice minpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0	0	0	0	0  0  0   0   0  0  0 0 );
# delimit cr	
		
log close

	
	

