clear
clear matrix
set mem 600m
set more off


cd "C:\Users\ejm5\Dropbox\District People Councils\Statafiles"

capture log close
log using "27092012\commune_HDND_2006_2008.smcl", replace

use panel_commune_2008_2010.dta, clear
	
	gen time_treatment=time*treatment
	
	* Drop Central Highland
	drop if reg8==6
	egen mahuyen=group(tinh huyen)
	
	replace agrvisit=agrvisit/100
			
	egen index1=rsum(goodroadv transport pro3 tapwater roadv)
	egen index2=rsum(rm2c7d	rm2c7e rm2c7g animal_s agrvisit	plant_s	agrext	irrigation)
	egen index3=rsum(rm2c7c	pro5)
	egen index4=rsum(pro4 rm2c7b useschool kgarten	v_prischool)
	egen index5=rsum(broadcast	post vpost)
	egen index6=rsum(rm2c7a	rm2c7f market nonfarm vmarket1 vmarket2 vmarket3)
	
	label var index1 "Infrastruture index"
	label var index2 "Agricultural Services index"
	label var index3 "Health Service index"
	label var index4 "Education index"
	label var index5 "Communication index"
	label var index6 "Household business development index"
	
	* National city
	gen hanoi=(tinh==1)
	gen haiphong=(tinh==31)
	gen danang=(tinh==48)
	gen cantho=(tinh==92)
	gen hcm=(tinh==79)
	gen city=(tinh==1 | tinh==31 | tinh==48 | tinh==92 | tinh==79)
	
	* global inde time treatment time_treatment lnarea lnpopden rnongnghiep rcongnghiep rdichvu city i.reg8 
	global inde time treatment time_treatment lnarea lnpopden city i.reg8 
	
set more off
	reg transport treatment
	outreg2 using HDND_regression2008.xls, bdec(3) tdec(3) e(rmse)  replace
	
	* REGRESSION
	xi: ivreg2 goodroadv $inde, cluster(tinh huyen)
	
	outreg2 using HDND_regression2008.xls,  bdec(3) tdec(3) e(rmse) 
	
	# delimit ;
	set more off;
	
		foreach x in 
		transport pro3 tapwater roadv
		rm2c7d	rm2c7e rm2c7g animal_s agrvisit	plant_s	agrext	irrigation
		rm2c7c	pro5
		pro4 rm2c7b useschool kgarten v_prischool
		broadcast post vpost
		rm2c7a	rm2c7f market nonfarm vmarket1 vmarket2 vmarket3
		index1 index2 index3 index4 index5 index6
		{;  
		
		xi: ivreg2 `x' $inde, cluster(tinh huyen); 
		outreg2 using HDND_regression2008.xls,  bdec(3) tdec(3) e(rmse);
	};
	
	# delimit cr
	
	reg transport treatment
	outreg2 using HDND_regression2008.xls, bdec(3) tdec(3) e(rmse)  excel
	
	
#delimit;
mean 	goodroadv transport pro3 tapwater roadv
		rm2c7d	rm2c7e rm2c7g animal_s agrvisit	plant_s	agrext	irrigation
		rm2c7c	pro5
		pro4 rm2c7b useschool kgarten v_prischool
		broadcast post vpost
		rm2c7a	rm2c7f market nonfarm vmarket1 vmarket2 vmarket3
		index1 index2 index3 index4 index5 index6 if year==2008;
		
		
#delimit;
describe 	goodroadv transport pro3 tapwater roadv
		rm2c7d	rm2c7e rm2c7g animal_s agrvisit	plant_s	agrext	irrigation
		rm2c7c	pro5
		pro4 rm2c7b useschool kgarten v_prischool
		broadcast post vpost
		rm2c7a	rm2c7f market nonfarm vmarket1 vmarket2 vmarket3
		index1 index2 index3 index4 index5 index6;
		
#delimit;
collapse index1 index2 index3 index4 index5 index6 time treatment time_treatment lnarea lnpopden city reg8, by(tinh year);
#delimit;		
reg index1 time treatment time_treatment  city i.reg8, robust cluster(tinh) ;
outreg2 using HDND_province_regression2008.xls,  bdec(3) tdec(3) e(rmse) replace;
reg index2 time treatment time_treatment  city i.reg8, robust cluster(tinh) ;
outreg2 using HDND_province_regression2008.xls,  bdec(3) tdec(3) e(rmse);
reg index3 time treatment time_treatment  city i.reg8, robust cluster(tinh) ;
outreg2 using HDND_province_regression2008.xls,  bdec(3) tdec(3) e(rmse);
reg index4 time treatment time_treatment  city i.reg8, robust cluster(tinh);
outreg2 using HDND_province_regression2008.xls,  bdec(3) tdec(3) e(rmse); 
reg index5 time treatment time_treatment  city i.reg8, robust cluster(tinh) ;
outreg2 using HDND_province_regression2008.xls,  bdec(3) tdec(3) e(rmse);
reg index6 time treatment time_treatment  city i.reg8, robust cluster(tinh) ;
outreg2 using HDND_province_regression2008.xls,  bdec(3) tdec(3) e(rmse) excel;
		
mean index* if year==2008;

		
/* Note: full outcome list*/
	# delimit ;
	
		foreach x in povrate pro1 pro2 pro3 pro4 pro5 pro6 
			rm2c7b rm2c7c rm2c7a rm2c7d rm2c7e rm2c7f rm2c7g 
			agrext roadv goodroadv transport post market electricity culture broadcast  irrigation  prischool 
			lseschool useschool kgarten nonfarm nonfarme 
			hecenter1 hecenter2 hecenter3 hecenter4 hecenter5 hecenter 
			d_hecenter1 d_hecenter2 d_hecenter3 d_hecenter4 d_hecenter5
			lender1 lender2 lender3 lender4 lender5 lender6 lender7 
			d_lender1 d_lender2 d_lender3 d_lender4 d_lender5 d_lender6 d_lender7
			land1_irr land2_irr land1_cer land2_cer land3_cer land4_cer land5_cer  migration_in migration_out 
			villbusi numbusi agrrise cleanwater 
			polluted tapwater agrvisit plant_s animal_s
			dmarket1 dmarket2 dmarket3 dpeocom dpost dbank dtown 
			d_prischool d_lseschool d_useschool
			vmarket1 vmarket2 vmarket3 vpeocom vpost 
			vbank  v_prischool v_lseschool v_useschool sland1 sland2 sland3 sland4 sland5 
		{;  
		
		xi: xtreg `x' time treatment time_treatment lnarea lnpopden rnongnghiep rcongnghiep rdichvu, i(tinh) fe;
		outreg using E:\HDND_regression.xls, se bdec(3) tdec(3) coefastr append label 3aster; 
	};
	
	# delimit cr
	

