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
*keep only M4
drop if tinh02>800 & (tinh02~=805 & tinh02~=809 & tinh02~=815)

drop if tinh02<800

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

*This will store the results: 1-8, Mekong Sample; 9-16: Mekong & South Sample
mat T8=J(16,10,0)


capture log close
log using "logs\table8a",text replace

* Hours Worked

	xtreg lhours shcat_s shcat_s_2 lincome_02 `other_controls' if c_lhours==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])
	
	mat T8[1,1]=$ATE
	mat T8[2,1]=$sd_ATE

	*Observations
	mat T8[7,1]=e(N)
	*R2 within
	mat T8[8,1]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,1]=$ATE
	mat T8[4,1]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,1]=$ATE
	mat T8[6,1]=$sd_ATE

* Catfish Investment

	xtreg lcatfish_invest shcat_s shcat_s_2 lincome_02 `other_controls' if c_lcatfishinv==2 & _2002_s>0, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])
	
	mat T8[1,3]=$ATE
	mat T8[2,3]=$sd_ATE

	*Observations
	mat T8[7,3]=e(N)
	*R2 within
	mat T8[8,3]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,3]=$ATE
	mat T8[4,3]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2   ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,3]=$ATE
	mat T8[6,3]=$sd_ATE



* Total investment

	xtreg linvestment shcat_s shcat_s_2 lincome_02 `other_controls' if c_linvestment==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat T8[1,5]=$ATE
	mat T8[2,5]=$sd_ATE

	*Observations
	mat T8[7,5]=e(N)
	*R2 within
	mat T8[8,5]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,5]=$ATE
	mat T8[4,5]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,5]=$ATE
	mat T8[6,5]=$sd_ATE



* Agricultural Investment

	xtreg lag_invest shcat_s shcat_s_2 lincome_02 `other_controls' if c_laginvest==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat T8[1,7]=$ATE
	mat T8[2,7]=$sd_ATE

	*Observations
	mat T8[7,7]=e(N)
	*R2 within
	mat T8[8,7]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,7]=$ATE
	mat T8[4,7]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,7]=$ATE
	mat T8[6,7]=$sd_ATE


* Other Investment

	xtreg lother_invest1 shcat_s shcat_s_2 lincome_02 `other_controls' if c_lotherinvest1==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat T8[1,9]=$ATE
	mat T8[2,9]=$sd_ATE

	*Observations
	mat T8[7,9]=e(N)
	*R2 within
	mat T8[8,9]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,9]=$ATE
	mat T8[4,9]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,9]=$ATE
	mat T8[6,9]=$sd_ATE


log close




restore

***M6
*Catfish Provinces: An Giang=805; Tien Giang=807; Vinh Long=809; can Tho=815; Soc Trang=819
*keep M6
drop if tinh02>800 & (tinh02~=805 & tinh02~=809 & tinh02~=815 & tinh02~=819 & tinh02~=807)

drop if tinh02<800

gen T=(tinh02==805 | tinh02==809 |tinh02==815 | tinh02==819 | tinh02==807)

gen T_P=T*year_d

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

log using "logs\table8a",text append

* Hours Worked

	xtreg lhours shcat_s shcat_s_2 lincome_02 `other_controls' if c_lhours==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])
	
	mat T8[1,2]=$ATE
	mat T8[2,2]=$sd_ATE

	*Observations
	mat T8[7,2]=e(N)
	*R2 within
	mat T8[8,2]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,2]=$ATE
	mat T8[4,2]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,2]=$ATE
	mat T8[6,2]=$sd_ATE

* Catfish Investment

	xtreg lcatfish_invest shcat_s shcat_s_2 lincome_02 `other_controls' if c_lcatfishinv==2 & _2002_s>0, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])
	
	mat T8[1,4]=$ATE
	mat T8[2,4]=$sd_ATE

	*Observations
	mat T8[7,4]=e(N)
	*R2 within
	mat T8[8,4]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,4]=$ATE
	mat T8[4,4]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2   ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,4]=$ATE
	mat T8[6,4]=$sd_ATE



* Total investment

	xtreg linvestment shcat_s shcat_s_2 lincome_02 `other_controls' if c_linvestment==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat T8[1,6]=$ATE
	mat T8[2,6]=$sd_ATE

	*Observations
	mat T8[7,6]=e(N)
	*R2 within
	mat T8[8,6]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,6]=$ATE
	mat T8[4,6]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,6]=$ATE
	mat T8[6,6]=$sd_ATE


* Agricultural Investment

	xtreg lag_invest shcat_s shcat_s_2 lincome_02 `other_controls' if c_laginvest==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat T8[1,8]=$ATE
	mat T8[2,8]=$sd_ATE

	*Observations
	mat T8[7,8]=e(N)
	*R2 within
	mat T8[8,8]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,8]=$ATE
	mat T8[4,8]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,8]=$ATE
	mat T8[6,8]=$sd_ATE


* Other Investment

	xtreg lother_invest1 shcat_s shcat_s_2 lincome_02 `other_controls' if c_lotherinvest1==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat T8[1,10]=$ATE
	mat T8[2,10]=$sd_ATE

	*Observations
	mat T8[7,10]=e(N)
	*R2 within
	mat T8[8,10]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat T8[3,10]=$ATE
	mat T8[4,10]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat T8[5,10]=$ATE
	mat T8[6,10]=$sd_ATE

log close

drop _all
svmat T8
save "results\T8a",replace


