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

****M4
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


*This will store the results (lines 1-6, Panel A; lines 7-12, Panel B; lines 13-14, obs and R2
mat TA2=J(14,6,0)


capture log close
log using "logs\tableA2",text replace

* Total Income

	xtreg lincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' , i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		*M4
		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])
	
	mat TA2[1,1]=$ATE
	mat TA2[2,1]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2)))*vv[1,1])
	
	mat TA2[7,1]=$ATE
	mat TA2[8,1]=$sd_ATE

	*Observations
	mat TA2[13,1]=e(N)
	*R2 within
	mat TA2[14,1]=e(r2_w)


		*M4
		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[3,1]=$ATE
	mat TA2[4,1]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[9,1]=$ATE
	mat TA2[10,1]=$sd_ATE

	
		*M4
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2   ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[5,1]=$ATE
	mat TA2[6,1]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2   ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[11,1]=$ATE
	mat TA2[12,1]=$sd_ATE


* Per Capita Income

	xtreg lpcincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' , i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		*M4
		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TA2[1,3]=$ATE
	mat TA2[2,3]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2)))*vv[1,1])

	mat TA2[7,3]=$ATE
	mat TA2[8,3]=$sd_ATE

	*Observations
	mat TA2[13,3]=e(N)
	*R2 within
	mat TA2[14,3]=e(r2_w)


		*M4
		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])
	
	mat TA2[3,3]=$ATE
	mat TA2[4,3]=$sd_ATE

	
		*South
		global ATE=exp(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[9,3]=$ATE
	mat TA2[10,3]=$sd_ATE

		*M4
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[5,3]=$ATE
	mat TA2[6,3]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[11,3]=$ATE
	mat TA2[12,3]=$sd_ATE



* Net Income

	xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' , i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		*M4
		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TA2[1,5]=$ATE
	mat TA2[2,5]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2)))*vv[1,1])

	mat TA2[7,5]=$ATE
	mat TA2[8,5]=$sd_ATE

	*Observations
	mat TA2[13,5]=e(N)
	*R2 within
	mat TA2[14,5]=e(r2_w)


		*M4
		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[3,5]=$ATE
	mat TA2[4,5]=$sd_ATE


		*South
		global ATE=exp(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[9,5]=$ATE
	mat TA2[10,5]=$sd_ATE

		*M4
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[5,5]=$ATE
	mat TA2[6,5]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[11,5]=$ATE
	mat TA2[12,5]=$sd_ATE

log close




restore

*****ONLY AQUACULTURE
keep if _2002_s>0

*2) M6
*drop non M6 but keep South
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

sum _2002_s if year==2002 & _2002_s>0 & T==1,det
*local sh_mean=r(mean)
*local sh_med=r(p50)

sum _2002_s if year==2002 & _2002_s>0 & _2002_s>`sh_mean' & T==1,det
*local sh_upper=r(p50)

log using "logs\tableA2",text append

* Total Income

	xtreg lincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' , i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		*M4
		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])
	
	mat TA2[1,2]=$ATE
	mat TA2[2,2]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2)))*vv[1,1])
	
	mat TA2[7,2]=$ATE
	mat TA2[8,2]=$sd_ATE

	*Observations
	mat TA2[13,2]=e(N)
	*R2 within
	mat TA2[14,2]=e(r2_w)


		*M4
		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[3,2]=$ATE
	mat TA2[4,2]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[9,2]=$ATE
	mat TA2[10,2]=$sd_ATE

	
		*M4
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2   ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[5,2]=$ATE
	mat TA2[6,2]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2   ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[11,2]=$ATE
	mat TA2[12,2]=$sd_ATE


* Per Capita Income

	xtreg lpcincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' , i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		*M4
		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TA2[1,4]=$ATE
	mat TA2[2,4]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2)))*vv[1,1])

	mat TA2[7,4]=$ATE
	mat TA2[8,4]=$sd_ATE

	*Observations
	mat TA2[13,4]=e(N)
	*R2 within
	mat TA2[14,4]=e(r2_w)


		*M4
		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])
	
	mat TA2[3,4]=$ATE
	mat TA2[4,4]=$sd_ATE

	
		*South
		global ATE=exp(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[9,4]=$ATE
	mat TA2[10,4]=$sd_ATE

		*M4
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[5,4]=$ATE
	mat TA2[6,4]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[11,4]=$ATE
	mat TA2[12,4]=$sd_ATE



* Net Income

	xtreg lnetincome T_shcat_s T_shcat_s_2 T_P shcat_s shcat_s_2 lincome_02 `other_controls' , i(id) robust fe
	mat coef=e(b)
	mat var=e(V)

		*M4
		global ATE=exp(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_med')+coef[1,2]*(`sh_med'^2)))*vv[1,1])

	mat TA2[1,6]=$ATE
	mat TA2[2,6]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2))-1
		*Variance
		mat B = [`sh_med' \ `sh_med'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_med')+coef[1,5]*(`sh_med'^2)))*vv[1,1])

	mat TA2[7,6]=$ATE
	mat TA2[8,6]=$sd_ATE

	*Observations
	mat TA2[13,6]=e(N)
	*R2 within
	mat TA2[14,6]=e(r2_w)


		*M4
		global ATE=exp(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_mean')+coef[1,2]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[3,6]=$ATE
	mat TA2[4,6]=$sd_ATE


		*South
		global ATE=exp(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2))-1
		*Variance
		mat B = [`sh_mean' \ `sh_mean'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_mean')+coef[1,5]*(`sh_mean'^2)))*vv[1,1])

	mat TA2[9,6]=$ATE
	mat TA2[10,6]=$sd_ATE

		*M4
		global ATE=exp(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[1..2,1..2]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,1]*(`sh_upper')+coef[1,2]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[5,6]=$ATE
	mat TA2[6,6]=$sd_ATE

		*South
		global ATE=exp(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2))-1
		*Variance
		mat B = [`sh_upper' \ `sh_upper'^2  ]
		mat aux_vc = var[4..5,4..5]
		mat vv = B'  * aux_vc * B
		global sd_ATE=sqrt(exp(2*(coef[1,4]*(`sh_upper')+coef[1,5]*(`sh_upper'^2)))*vv[1,1])

	mat TA2[11,6]=$ATE
	mat TA2[12,6]=$sd_ATE

log close

drop _all
svmat TA2
save "results\TA2",replace


