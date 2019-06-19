*==================================================================
*			    Vietnam CATFISH	 		   
*==================================================================
*version 9
drop _all
set mem 200m
set more off

use "data\data_rstat_control_last"

preserve


*****ONLY AQUACULTURE
keep if _2002_s>0

*** All Farmers in M4

*Catfish Provinces: An Giang=805; Tien Giang=807; Vinh Long=809; can Tho=815; Soc Trang=819
*HERE IS M4: MEKONG 4
keep if tinh02==805 | tinh02==809 | tinh02==815
*Here we drop urban households
drop if rural_02==0 & _2002_s==0

gen T=(tinh02==805 | tinh02==809 |tinh02==815)

gen T_P=T*year_d

*Share of catfish in total income*T
gen T_shcat_s=T*_2002_s*year_d
gen T_shcat_s_2=T*(_2002_s)^2*year_d
gen T_shcat_s_3=T*(_2002_s)^3*year_d

*Define controls for the regression: demographics, year effect, education
loc other_controls "year_d hhsize age age2 marital wa_males _I_* nonaqua"

* This computes the values of the shares: mean, median and upper tail

sum _2002_s if year==2002 & _2002_s>0 & T==1,det
local sh_mean=r(mean)
local sh_med=r(p50)

sum _2002_s if year==2002 & _2002_s>0 & _2002_s>`sh_mean' & T==1,det
local sh_upper=r(p50)

*This will store the results
mat TA1a=J(8,6,0)

capture log close
log using "logs\tableA1a",text append

* Total Income

	xtreg lincome shcat_s shcat_s_2 lincome_02 `other_controls', i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])
	
	mat TA1a[1,1]=$ATE
	mat TA1a[2,1]=$sd_ATE

	*Observations
	mat TA1a[7,1]=e(N)
	*R2 within
	mat TA1a[8,1]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA1a[3,1]=$ATE
	mat TA1a[4,1]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA1a[5,1]=$ATE
	mat TA1a[6,1]=$sd_ATE


* Per Capita Income

	xtreg lpcincome shcat_s shcat_s_2 lincome_02 `other_controls'  if c_lpcinc==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TA1a[1,3]=$ATE
	mat TA1a[2,3]=$sd_ATE

	*Observations
	mat TA1a[7,3]=e(N)
	*R2 within
	mat TA1a[8,3]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA1a[3,3]=$ATE
	mat TA1a[4,3]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA1a[5,3]=$ATE
	mat TA1a[6,3]=$sd_ATE



* Net Income

	xtreg lnetincome shcat_s shcat_s_2 lincome_02 `other_controls'  if c_lnetinc==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TA1a[1,5]=$ATE
	mat TA1a[2,5]=$sd_ATE

	*Observations
	mat TA1a[7,5]=e(N)
	*R2 within
	mat TA1a[8,5]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA1a[3,5]=$ATE
	mat TA1a[4,5]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA1a[5,5]=$ATE
	mat TA1a[6,5]=$sd_ATE


log close




restore

*****ONLY AQUACULTURE
keep if _2002_s>0

*4) all catfish province in M6
*Catfish Provinces: An Giang=805; Tien Giang=807; Vinh Long=809; can Tho=815; Soc Trang=819
*HERE IS M6: MEKONG 6
keep if tinh02==805 | tinh02==809 | tinh02==815 | tinh02==819 | tinh02==807
drop if rural_02==0 & _2002_s==0


gen T=(tinh02==805 | tinh02==809 |tinh02==815 | tinh02==819 | tinh02==807)

gen T_P=T*year_d

*Share of catfish in total income*T
gen T_shcat_s=T*_2002_s*year_d
gen T_shcat_s_2=T*(_2002_s)^2*year_d
gen T_shcat_s_3=T*(_2002_s)^3*year_d



log using "logs\tableA1a",text append

* Total Income

	xtreg lincome shcat_s shcat_s_2 lincome_02 `other_controls'  if c_linc==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])
	
	mat TA1a[1,2]=$ATE
	mat TA1a[2,2]=$sd_ATE

	*Observations
	mat TA1a[7,2]=e(N)
	*R2 within
	mat TA1a[8,2]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA1a[3,2]=$ATE
	mat TA1a[4,2]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA1a[5,2]=$ATE
	mat TA1a[6,2]=$sd_ATE


* Per Capita Income

	xtreg lpcincome shcat_s shcat_s_2 lincome_02 `other_controls'  if c_lpcinc==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TA1a[1,4]=$ATE
	mat TA1a[2,4]=$sd_ATE

	*Observations
	mat TA1a[7,4]=e(N)
	*R2 within
	mat TA1a[8,4]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA1a[3,4]=$ATE
	mat TA1a[4,4]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA1a[5,4]=$ATE
	mat TA1a[6,4]=$sd_ATE



* Net Income

	xtreg lnetincome shcat_s shcat_s_2 lincome_02 `other_controls'  if c_lnetinc==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TA1a[1,6]=$ATE
	mat TA1a[2,6]=$sd_ATE

	*Observations
	mat TA1a[7,6]=e(N)
	*R2 within
	mat TA1a[8,6]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA1a[3,6]=$ATE
	mat TA1a[4,6]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA1a[5,6]=$ATE
	mat TA1a[6,6]=$sd_ATE


log close

drop _all
svmat TA1a
save "results\TA1a",replace
