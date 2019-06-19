*==================================================================
*			    Vietnam CATFISH	 		   
*==================================================================
*version 9
drop _all
set mem 200m
set more off

use "data\data_rstat_control_last"

preserve

***M4

*Catfish Provinces: An Giang=805; Tien Giang=807; Vinh Long=809; can Tho=815; Soc Trang=819
*drop non M4 & M6 but keep South
drop if tinh02>800 & (tinh02~=805 & tinh02~=809 & tinh02~=815)
drop if tinh02<500
drop if rural_02==0 & _2002_s==0

gen T=(tinh02==805 | tinh02==809 |tinh02==815)

gen T_P=T*year_d
gen T_P_nonaqua=T_P*nonaqua

*Share of catfish in total income*T
gen T_shcat_s=T*_2002_s*year_d
gen T_shcat_s_2=T*(_2002_s)^2*year_d
gen T_shcat_s_3=T*(_2002_s)^3*year_d

*Define controls for the regression: demographics, year effect, education
loc other_controls "year_d hhsize age age2 marital wa_males _I_* T_P_nonaqua"

* This computes the values of the shares: mean, median and upper tail

sum _2002_s if year==2002 & _2002_s>0,det
local sh_mean=r(mean)
local sh_med=r(p50)

sum _2002_s if year==2002 & _2002_s>0 & _2002_s>`sh_mean',det
local sh_upper=r(p50)

*This will store the results
mat TAppA1=J(8,20,0)

capture log close
log using "logs\TableAppA1",text replace


* Net Income

** catfish income sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_laqfish==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,1]=$ATE
	mat TAppA1[2,1]=$sd_ATE

	*Observations
	mat TAppA1[7,1]=e(N)
	*R2 within
	mat TAppA1[8,1]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,1]=$ATE
	mat TAppA1[4,1]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,1]=$ATE
	mat TAppA1[6,1]=$sd_ATE


** wage income sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lwages==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,3]=$ATE
	mat TAppA1[2,3]=$sd_ATE

	*Observations
	mat TAppA1[7,3]=e(N)
	*R2 within
	mat TAppA1[8,3]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,3]=$ATE
	mat TAppA1[4,3]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,3]=$ATE
	mat TAppA1[6,3]=$sd_ATE



** ag sales income
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lagsold==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,5]=$ATE
	mat TAppA1[2,5]=$sd_ATE

	*Observations
	mat TAppA1[7,5]=e(N)
	*R2 within
	mat TAppA1[8,5]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,5]=$ATE
	mat TAppA1[4,5]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,5]=$ATE
	mat TAppA1[6,5]=$sd_ATE



** ag own sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lagown==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,7]=$ATE
	mat TAppA1[2,7]=$sd_ATE

	*Observations
	mat TAppA1[7,7]=e(N)
	*R2 within
	mat TAppA1[8,7]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,7]=$ATE
	mat TAppA1[4,7]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,7]=$ATE
	mat TAppA1[6,7]=$sd_ATE



** misc other income 2 sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lotherinc2==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,9]=$ATE
	mat TAppA1[2,9]=$sd_ATE

	*Observations
	mat TAppA1[7,9]=e(N)
	*R2 within
	mat TAppA1[8,9]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,9]=$ATE
	mat TAppA1[4,9]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,9]=$ATE
	mat TAppA1[6,9]=$sd_ATE




** hours worked sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lhours==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,11]=$ATE
	mat TAppA1[2,11]=$sd_ATE

	*Observations
	mat TAppA1[7,11]=e(N)
	*R2 within
	mat TAppA1[8,11]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,11]=$ATE
	mat TAppA1[4,11]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,11]=$ATE
	mat TAppA1[6,11]=$sd_ATE




** catfish investment sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lcatfishinv==2 & _2002_s>0, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,13]=$ATE
	mat TAppA1[2,13]=$sd_ATE

	*Observations
	mat TAppA1[7,13]=e(N)
	*R2 within
	mat TAppA1[8,13]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,13]=$ATE
	mat TAppA1[4,13]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,13]=$ATE
	mat TAppA1[6,13]=$sd_ATE



** total investment sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_linvestment==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,15]=$ATE
	mat TAppA1[2,15]=$sd_ATE

	*Observations
	mat TAppA1[7,15]=e(N)
	*R2 within
	mat TAppA1[8,15]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,15]=$ATE
	mat TAppA1[4,15]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,15]=$ATE
	mat TAppA1[6,15]=$sd_ATE



** ag investment sample
	xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_laginvest==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,17]=$ATE
	mat TAppA1[2,17]=$sd_ATE

	*Observations
	mat TAppA1[7,17]=e(N)
	*R2 within
	mat TAppA1[8,17]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,17]=$ATE
	mat TAppA1[4,17]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,17]=$ATE
	mat TAppA1[6,17]=$sd_ATE



** misc investment income sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lotherinvest1==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,19]=$ATE
	mat TAppA1[2,19]=$sd_ATE

	*Observations
	mat TAppA1[7,19]=e(N)
	*R2 within
	mat TAppA1[8,19]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,19]=$ATE
	mat TAppA1[4,19]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,19]=$ATE
	mat TAppA1[6,19]=$sd_ATE



log close




restore

***M6
*Catfish Provinces: An Giang=805; Tien Giang=807; Vinh Long=809; can Tho=815; Soc Trang=819
*drop non M4 & M6 but keep South
drop if tinh02>800 & (tinh02~=805 & tinh02~=809 & tinh02~=815 & tinh02~=819 & tinh02~=807)

drop if tinh02<500
drop if rural_02==0 & _2002_s==0

gen T=(tinh02==805 | tinh02==809 |tinh02==815 | tinh02==819 | tinh02==807)

gen T_P=T*year_d
gen T_P_nonaqua=T_P*nonaqua

*Share of catfish in total income*T
gen T_shcat_s=T*_2002_s*year_d
gen T_shcat_s_2=T*(_2002_s)^2*year_d
gen T_shcat_s_3=T*(_2002_s)^3*year_d

* This computes the values of the shares: mean, median and upper tail

*sum _2002_s if year==2002 & _2002_s>0 & T==1,det
*local sh_mean=r(mean)
*local sh_med=r(p50)

*sum _2002_s if year==2002 & _2002_s>0 & _2002_s>`sh_mean' & T==1,det
*local sh_upper=r(p50)

log using "logs\TableAppA1",text append

* Net Income

** catfish income sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_laqfish==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,2]=$ATE
	mat TAppA1[2,2]=$sd_ATE

	*Observations
	mat TAppA1[7,2]=e(N)
	*R2 within
	mat TAppA1[8,2]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,2]=$ATE
	mat TAppA1[4,2]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,2]=$ATE
	mat TAppA1[6,2]=$sd_ATE


** wage income sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lwages==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,4]=$ATE
	mat TAppA1[2,4]=$sd_ATE

	*Observations
	mat TAppA1[7,4]=e(N)
	*R2 within
	mat TAppA1[8,4]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,4]=$ATE
	mat TAppA1[4,4]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,4]=$ATE
	mat TAppA1[6,4]=$sd_ATE



** ag sales income
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lagsold==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,6]=$ATE
	mat TAppA1[2,6]=$sd_ATE

	*Observations
	mat TAppA1[7,6]=e(N)
	*R2 within
	mat TAppA1[8,6]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,6]=$ATE
	mat TAppA1[4,6]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,6]=$ATE
	mat TAppA1[6,6]=$sd_ATE



** ag own sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lagown==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,8]=$ATE
	mat TAppA1[2,8]=$sd_ATE

	*Observations
	mat TAppA1[7,8]=e(N)
	*R2 within
	mat TAppA1[8,8]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,8]=$ATE
	mat TAppA1[4,8]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,8]=$ATE
	mat TAppA1[6,8]=$sd_ATE



** misc other income 2 sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lotherinc2==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,10]=$ATE
	mat TAppA1[2,10]=$sd_ATE

	*Observations
	mat TAppA1[7,10]=e(N)
	*R2 within
	mat TAppA1[8,10]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,10]=$ATE
	mat TAppA1[4,10]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,10]=$ATE
	mat TAppA1[6,10]=$sd_ATE




** hours worked sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lhours==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,12]=$ATE
	mat TAppA1[2,12]=$sd_ATE

	*Observations
	mat TAppA1[7,12]=e(N)
	*R2 within
	mat TAppA1[8,12]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,12]=$ATE
	mat TAppA1[4,12]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,12]=$ATE
	mat TAppA1[6,12]=$sd_ATE




** catfish investment sample
	xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lcatfishinv==2 & _2002_s>0, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,14]=$ATE
	mat TAppA1[2,14]=$sd_ATE

	*Observations
	mat TAppA1[7,14]=e(N)
	*R2 within
	mat TAppA1[8,14]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,14]=$ATE
	mat TAppA1[4,14]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,14]=$ATE
	mat TAppA1[6,14]=$sd_ATE



** total investment sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_linvestment==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,16]=$ATE
	mat TAppA1[2,16]=$sd_ATE

	*Observations
	mat TAppA1[7,16]=e(N)
	*R2 within
	mat TAppA1[8,16]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,16]=$ATE
	mat TAppA1[4,16]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,16]=$ATE
	mat TAppA1[6,16]=$sd_ATE



** ag investment sample
xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_laginvest==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,18]=$ATE
	mat TAppA1[2,18]=$sd_ATE

	*Observations
	mat TAppA1[7,18]=e(N)
	*R2 within
	mat TAppA1[8,18]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,18]=$ATE
	mat TAppA1[4,18]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,18]=$ATE
	mat TAppA1[6,18]=$sd_ATE



** misc investment income sample
	xtreg lnetincome    T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lotherinvest1==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

	global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TAppA1[1,20]=$ATE
	mat TAppA1[2,20]=$sd_ATE

	*Observations
	mat TAppA1[7,20]=e(N)
	*R2 within
	mat TAppA1[8,20]=e(r2_w)


	global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TAppA1[3,20]=$ATE
	mat TAppA1[4,20]=$sd_ATE


	global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
	global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TAppA1[5,20]=$ATE
	mat TAppA1[6,20]=$sd_ATE


log close


drop _all
svmat TAppA1

keep TAppA11 TAppA12 TAppA13 TAppA14 TAppA15 TAppA16 TAppA17 TAppA18 TAppA19 TAppA110
save "results\TAppA1a",replace

drop _all
svmat TAppA1

keep TAppA111 TAppA112 TAppA113 TAppA114 TAppA115 TAppA116 TAppA117 TAppA118 TAppA119 TAppA120
ren TAppA111 TAppA11
ren TAppA112 TAppA12
ren TAppA113 TAppA13
ren TAppA114 TAppA14
ren TAppA115 TAppA15
ren TAppA116 TAppA16
ren TAppA117 TAppA17
ren TAppA118 TAppA18
ren TAppA119 TAppA19
ren TAppA120 TAppA110

save "results\TAppA1b",replace
