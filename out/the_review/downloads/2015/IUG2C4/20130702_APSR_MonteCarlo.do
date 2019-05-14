clear
clear matrix
set mem 1300m
set matsize 2000
set more off
set seed 123456789
	
quietly forval i = 1/1000 {
	
	dis `i'
	
	* Simulation data
	use "E:\Cuong - paper\HDND Huyen\ma huyen.dta", clear
	
		gen huyen=huyen_new
		sort huyen
		merge huyen using "E:\Cuong - paper\HDND Huyen\urban share of districts 2009.dta"
		tab _m
		keep if _m==3
		drop if urban==100
		gen reg8=int(tinh_old/100)
		drop if reg8==6
		bsample 67
		
	save E:\selected_district.dta, replace
		gen treatment_new=1
		keep treatment huyen_new
		ren huyen_new huyen
		gen year=2010
		sort year huyen
	save E:\selected_district_new_code.dta, replace
	
	use E:\selected_district.dta, clear
		gen treatment_old=1
		keep treatment tinh_new huyen_old
		ren huyen_old huyen
		ren tinh_new tinh
		gen year=2008
		sort year tinh huyen
	save E:\selected_district_old_code.dta, replace
	
		
	use "E:\Cuong - paper\HDND Huyen\panel_commune_2008_2010.dta", clear
		drop treatment
		sort year huyen
		merge year huyen using E:\selected_district_new_code.dta
		tab _m
		drop if _m==2
		drop _m
		
		sort year tinh huyen
		merge year tinh huyen using E:\selected_district_old_code.dta
		tab _m
		drop if _m==2
		drop _m

		gen treatment=(treatment_new==1 | treatment_old==1)
		drop treatment_old treatment_old
		tab treatment
		
		* regression
		gen time_treatment=time*treatment
	
		* Drop Central Highland
		drop if reg8==6

		* National city
		gen hanoi=(tinh==1)
		gen haiphong=(tinh==31)
		gen danang=(tinh==48)
		gen cantho=(tinh==92)
		gen hcm=(tinh==79)
				
		gen city=(tinh==1 | tinh==31 | tinh==48 | tinh==92 | tinh==79)
		
		* Other variables
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
	
	
		global inde time treatment time_treatment lnarea lnpopden city i.reg8 
				
	
		* Store estimates
		scalar s10=0
		scalar s5=0
		scalar s1=0
	
		scalar s10p=0
		scalar s5p=0
		scalar s1p=0
		
		* Store t-statistics and coefficients
		matrix T = J(1, 30, 0)
		matrix C = J(1, 30, 0)
		local j=0 
		
		# delimit ;
	
		foreach x in 
		goodroadv transport pro3 tapwater roadv
		rm2c7d	rm2c7e rm2c7g animal_s agrvisit	plant_s	agrext	irrigation
		rm2c7c	pro5
		pro4 rm2c7b useschool kgarten v_prischool
		broadcast post vpost
		rm2c7a	rm2c7f market nonfarm vmarket1 vmarket2 vmarket3	
		{;  
	
		# delimit cr
		
			xi: ivreg2 `x' $inde, cluster(tinh huyen)

			matrix b=e(b)
			matrix v=e(V)
	
			local t = abs(b[1,3]/(v[3,3]^0.5))
			local t0 = (b[1,3]/(v[3,3]^0.5))
			display `t'
			
			local j = `j'+1
			matrix T[1,`j'] =  `t0'
			matrix C[1,`j'] =  b[1,3]
		
			if `t' >=1.645 	{
				scalar s10 = s10 + 1
			}	
	
			if `t' >=1.96 	{
				scalar  s5 = s5 + 1
			}	
			
			if `t' >=2.576 	{
				scalar  s1 = s1 + 1
			}	
	
			* Significant & positive
			if `t' >=1.645 & b[1,3]>0	{
				scalar  s10p = s10p + 1
			}	
	
			if `t' >=1.96 & b[1,3]>0	{
				scalar  s5p = s5p + 1
			}	
			
			if `t' >=2.576 & b[1,3]>0	{
				scalar  s1p = s1p + 1
			}	
	
	}
	
	matrix A = (nullmat(A)\s10, s10p, s5, s5p, s1, s1p)
	matrix TT = (nullmat(TT)\T)
	matrix CC = (nullmat(CC)\C)
			
}
	
drop *
svmat A
	save E:\significant_outcome.dta, replace
	drop *
	
svmat TT
	save E:\t_statistic_outcome.dta, replace
	drop *
		
svmat CC
	save E:\coefficient_outcome.dta, replace
