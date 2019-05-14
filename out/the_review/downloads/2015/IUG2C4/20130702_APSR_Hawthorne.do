clear
clear matrix
set mem 600m
set more off

cd "C:\Users\ejm5\Dropbox\District People Councils\Statafiles"

capture log close
log using commune_HDND.smcl, replace

use panel_commune_2008_2010.dta, clear
	
	replace agrvisit=agrvisit/100
	
	gen time_treatment=time*treatment
	gen time_steering=time*steering
	gen time_surveyed=time*surveyed
	
	for var surveyed steering: gen treatment_X=treatment*X
	for var steering surveyed: gen time_treatment_X=time_treatment*X
	
	* Drop Central Highland
	drop if reg8==6
	egen mahuyen=group(tinh huyen)
	
	* National city
	gen hanoi=(tinh==1)
	gen haiphong=(tinh==31)
	gen danang=(tinh==48)
	gen cantho=(tinh==92)
	gen hcm=(tinh==79)
	gen city=(tinh==1 | tinh==31 | tinh==48 | tinh==92 | tinh==79)
	
	label var steering "Steering"
	label var surveyed "Surveyed"
	
	* global inde time treatment time_treatment time_treatment_steering steering time_steering lnarea lnpopden city i.reg8  
	global inde time treatment time_treatment time_treatment_surveyed surveyed time_surveyed treatment_surveyed lnarea lnpopden city i.reg8  
		
		
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
	
	* REGRESSION
	set more off
	xi: ivreg2 goodroadv $inde, cluster(tinh huyen)
	
	outreg2 using HDND_regression_steering2, excel bdec(3) tdec(3)  replace  e(rmse)

	
	# delimit ;
	
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
		outreg2 using HDND_regression_steering2,  bdec(3) tdec(3) e(rmse); 
	};
	
	xi: ivreg2 goodroadv $inde, cluster(tinh huyen);
	
	outreg2 using HDND_regression_steering2, excel bdec(3) tdec(3)  e(rmse);
	
	
	# delimit cr
		
