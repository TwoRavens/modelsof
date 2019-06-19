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

sum _2002_s if year==2002 & _2002_s>0 & T==1,det
local sh_mean=r(mean)
local sh_med=r(p50)

sum _2002_s if year==2002 & _2002_s>0 & _2002_s>`sh_mean' & T==1,det
local sh_upper=r(p50)

*This will store the results
mat TA4=J(8,10,0)


capture log close
log using "logs\tableA4b",text replace

* Hours Worked

	xtreg lhours T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lhours==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])
	
	mat TA4[1,1]=$ATE
	mat TA4[2,1]=$sd_ATE

	*Observations
	mat TA4[7,1]=e(N)
	*R2 within
	mat TA4[8,1]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,1]=$ATE
	mat TA4[4,1]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,1]=$ATE
	mat TA4[6,1]=$sd_ATE

* Catfish Investment

	xtreg lcatfish_invest T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lcatfishinv==2 & _2002_s>0, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])
	
	mat TA4[1,3]=$ATE
	mat TA4[2,3]=$sd_ATE

	*Observations
	mat TA4[7,3]=e(N)
	*R2 within
	mat TA4[8,3]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,3]=$ATE
	mat TA4[4,3]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2   ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,3]=$ATE
	mat TA4[6,3]=$sd_ATE



* Total investment

	xtreg linvestment T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_linvestment==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat TA4[1,5]=$ATE
	mat TA4[2,5]=$sd_ATE

	*Observations
	mat TA4[7,5]=e(N)
	*R2 within
	mat TA4[8,5]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,5]=$ATE
	mat TA4[4,5]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,5]=$ATE
	mat TA4[6,5]=$sd_ATE



* Agricultural Investment

	xtreg lag_invest T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_laginvest==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat TA4[1,7]=$ATE
	mat TA4[2,7]=$sd_ATE

	*Observations
	mat TA4[7,7]=e(N)
	*R2 within
	mat TA4[8,7]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,7]=$ATE
	mat TA4[4,7]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,7]=$ATE
	mat TA4[6,7]=$sd_ATE


* Other Investment

	xtreg lother_invest1 T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lotherinvest1==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat TA4[1,9]=$ATE
	mat TA4[2,9]=$sd_ATE

	*Observations
	mat TA4[7,9]=e(N)
	*R2 within
	mat TA4[8,9]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,9]=$ATE
	mat TA4[4,9]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,9]=$ATE
	mat TA4[6,9]=$sd_ATE


log close




restore

*****ONLY AQUACULTURE
keep if _2002_s>0

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

log using "logs\tableA4b",text append

* Hours Worked

	xtreg lhours T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lhours==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])
	
	mat TA4[1,2]=$ATE
	mat TA4[2,2]=$sd_ATE

	*Observations
	mat TA4[7,2]=e(N)
	*R2 within
	mat TA4[8,2]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,2]=$ATE
	mat TA4[4,2]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,2]=$ATE
	mat TA4[6,2]=$sd_ATE

* Catfish Investment

	xtreg lcatfish_invest T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lcatfishinv==2 & _2002_s>0, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])
	
	mat TA4[1,4]=$ATE
	mat TA4[2,4]=$sd_ATE

	*Observations
	mat TA4[7,4]=e(N)
	*R2 within
	mat TA4[8,4]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,4]=$ATE
	mat TA4[4,4]=$sd_ATE

	
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2   ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,4]=$ATE
	mat TA4[6,4]=$sd_ATE



* Total investment

	xtreg linvestment T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_linvestment==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat TA4[1,6]=$ATE
	mat TA4[2,6]=$sd_ATE

	*Observations
	mat TA4[7,6]=e(N)
	*R2 within
	mat TA4[8,6]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,6]=$ATE
	mat TA4[4,6]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,6]=$ATE
	mat TA4[6,6]=$sd_ATE


* Agricultural Investment

	xtreg lag_invest T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_laginvest==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat TA4[1,8]=$ATE
	mat TA4[2,8]=$sd_ATE

	*Observations
	mat TA4[7,8]=e(N)
	*R2 within
	mat TA4[8,8]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,8]=$ATE
	mat TA4[4,8]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,8]=$ATE
	mat TA4[6,8]=$sd_ATE


* Other Investment

	xtreg lother_invest1 T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' if c_lotherinvest1==2, i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) )-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2) ))*vv[1,1])

	mat TA4[1,10]=$ATE
	mat TA4[2,10]=$sd_ATE

	*Observations
	mat TA4[7,10]=e(N)
	*R2 within
	mat TA4[8,10]=e(r2_w)


		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) )-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2) ))*vv[1,1])

	mat TA4[3,10]=$ATE
	mat TA4[4,10]=$sd_ATE


		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) )-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2) ))*vv[1,1])

	mat TA4[5,10]=$ATE
	mat TA4[6,10]=$sd_ATE

log close

drop _all
svmat TA4
save "results\TA4b",replace


