*****************************************************
***APPENDIX PART 2 (Wild cluster bootstrap p-values)
*****************************************************

capture log close
clear 
cd  "C:\Users\jenny\Dropbox\Replication Office-selling\Supplementary"

log using wildboot_app2, replace

***************************************************************************
*****Table A.21: Alternative Measures of Office Prices
***************************************************************************

use main_part2_1, clear

*PANEL A

*COLUMN 1 AND 2

#delimit ;
xi: cgmwildboot lhhequiv meanprice meanpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr	
	
#delimit ;
xi: cgmwildboot schoolyears meanprice meanpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*COLUMN 3 AND 4

use main_part2_2, clear

#delimit ;
xi: cgmwildboot toilethouse meanprice meanpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot mud meanprice meanpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0);
# delimit cr		


*PANEL B

use main_part2_1, clear

*COLUMN 1 AND 2

#delimit ;
xi: cgmwildboot lhhequiv meanprice firstpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		

#delimit ;
xi: cgmwildboot schoolyears meanprice firstpriceh adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr	

	
*COLUMN 3 AND 4

use main_part2_2, clear

	
#delimit ;
xi: cgmwildboot toilethouse meanprice firstpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot mud meanprice firstpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0);
# delimit cr		


**************************************************************************************
*****Table A.22: Office Prices and Contemporary Development Outcomes: Other Controls
**************************************************************************************

use main_part2_1, clear

*PANEL A

*COLUMN 1 AND 2

#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh mita adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		

#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh mita adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		


*COLUMN 3 AND 4

use main_part2_2, clear

#delimit ;
xi: cgmwildboot toilethouse meanprice minpriceh mita lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr		

#delimit ;
xi: cgmwildboot mud meanprice minpriceh mita lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr		
			

*PANEL B
	
use main_part2_1, clear

*COLUMN 1 AND 2

#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh mine adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		

#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh mine adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		


*COLUMN 3 AND 4

use main_part2_2, clear

#delimit ;
xi: cgmwildboot toilethouse meanprice minpriceh mine lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot mud meanprice minpriceh mine lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr	


*PANEL C

use main_part2_1, clear

*COLUMN 1 AND 2

#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh bishop adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh bishop adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		
		
		
*COLUMN 3 AND 4

use main_part2_2, clear

#delimit ;
xi: cgmwildboot toilethouse meanprice minpriceh bishop lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot mud meanprice minpriceh bishop lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr	
		

*PANEL D
	
use main_part2_1, clear

*COLUMN 1 AND 2

#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh wage adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh wage adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		
		
		
*COLUMN 3 AND 4

use main_part2_2, clear


#delimit ;
xi: cgmwildboot toilethouse meanprice minpriceh wage lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot mud meanprice minpriceh wage lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr	
		
	
*PANEL 3
	
use main_part2_1, clear

*COLUMN 1 AND 2

#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh ind54 adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh ind54 adults infants kids age male lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr	
	

*COLUMN 3 AND 4

use main_part2_2, clear

#delimit ;
xi: cgmwildboot toilethouse meanprice minpriceh ind54 lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr		


#delimit ;
xi: cgmwildboot mud meanprice minpriceh ind54 lz suitindex ldistlima centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0);
# delimit cr	
			
	
		
**************************************************************************************
*****Table A.28: Office Prices and 1754 Migrants and Foreigners
**************************************************************************************

use main_part2_2, clear

gen perc_orig = orig/tribut
gen perc_forast = forastero/tribut
replace tribut = log(tribut)

keep if minpriceh!=. & meanprice!=.

collapse (firstnm) perc_orig perc_forast tribut soldpc meanprice minpriceh (mean) z suitindex distlima centerxgd centerygd, by(provincia)

gen lz = log(z)
gen ldistlima = log(distlima)

encode provincia, gen(provcode)

*COLUMNS 1 TO 3

#delimit ;
xi: cgmwildboot perc_orig meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0);
# delimit cr	

#delimit ;
xi: cgmwildboot perc_forast meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0);
# delimit cr	

#delimit ;
xi: cgmwildboot tribut meanprice minpriceh lz suitindex ldistlima centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0);
# delimit cr	

	
**************************************************************************************
*****Table A.29: Office prices and contemporary migration
**************************************************************************************

*COLUMN 1
use main_part2_1, clear
merge m:1 ubigeo using mig_districts
drop _merge
*Eliminating bottom 25th pct (high share of migrants)
drop if migp25==1

*PANEL A
#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*PANEL B
#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*COLUMN 2

use main_part2_1, clear
merge m:1 ubigeo using mig_districts
drop _merge
*Eliminating 25th-50th pct (medium high levels of migrants)
drop if migp50==1

*PANEL A
#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*PANEL B
#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*COLUMN 3

use main_part2_1, clear
merge m:1 ubigeo using mig_districts
drop _merge
*Eliminating  50th-75th pct (medium low levels of migrants)
drop if migp75==1

*PANEL A
#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*PANEL B
#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*COLUMN 4
use main_part2_1, clear
merge m:1 ubigeo using mig_districts
drop _merge
*Eliminating  top 75th pct (low evels of migrants)
drop if migp00==1

*PANEL A
#delimit ;
xi: cgmwildboot lhhequiv meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*PANEL B
#delimit ;
xi: cgmwildboot schoolyears meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provcode) bootcluster(provcode) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr
	
	
*****************************************************************************************
***Table: A.30: TRUST IN THE POPULATION
*****************************************************************************************

use main_part2_1, clear

gen num_trust = trust_jne + trust_onpe+ trust_distrit + trust_munic + trust_government + trust_police + trust_army + trust_judic + trust_paper + trust_radtv
 
gen trust1 = trust_distrit + trust_munic + trust_government 
gen trust2 = trust_jne + trust_onpe
gen trust3 = trust_police + trust_army + trust_judic
gen trust4 = trust_paper + trust_radtv

*COLUMN 1	
#delimit ;
xi: cgmwildboot num_trust meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*COLUMN 2
#delimit ;
xi: cgmwildboot trust1 meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*COLUMN 3
#delimit ;
xi: cgmwildboot trust2 meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0);
# delimit cr

*COLUMN 4
#delimit ;
xi: cgmwildboot trust3 meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 );
# delimit cr

*COLUMN 5
#delimit ;
xi: cgmwildboot trust4 meanprice minpriceh adults infants kids age male ldistlima suitindex lz centerxgd centerygd, cluster(provincia) bootcluster(provincia) seed(1984) 
null(0 0 0 0 0 0 0 0 0 0 0 0 );
# delimit cr


log close








