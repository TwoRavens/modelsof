cd "~/Dropbox/Broockman-Skovron/Elite perceptions 2/Replication-Materials/Analysis Miller-Stokes"

use "MS recoded.dta", clear

summ dist_social_welfare dist_foreign_policy dist_civil_rights fp_preference - cr_perception

gen dist_foreign_policy_sqN = sqrt(dist_foreign_policy_N)
gen dist_civil_rights_sqN = sqrt(dist_civil_rights_N)
gen dist_social_welfare_sqN = sqrt(dist_social_welfare_N)

reg sw_perception sw_preference dist_social_welfare [aw=dist_social_welfare_sqN]
reg cr_perception cr_preference dist_civil_rights [aw=dist_social_welfare_sqN]
reg fp_perception fp_preference dist_foreign_policy [aw=dist_social_welfare_sqN]


gen fp_error = fp_perception - dist_foreign_policy
gen cr_error = cr_perception - dist_civil_rights
gen sw_error = sw_perception - dist_social_welfare

foreach area in fp cr sw {
	display "`area'"
	reg `area'_error
	quietly gen `area'_abs_error = abs(`area'_error)
	reg `area'_abs_error `area'_preference
}

label var fp_preference "MC Foreign Policy Attitude"
label var cr_preference "MC Civil Rights Attitude"
label var sw_preference "MC Social Welfare Attitude"

label define tothreescale 0 "0 - Most Conservative" 1 "0.33" 2 "0.67" 3 "1 - Most Liberal"
label define tofourscale 0 "0 - Most Conservative" 1 "0.25" 2 "0.50" 3 "0.75" 4 "1 - Most Liberal"

label values cr_preference tothreescale
label values fp_preference tofourscale
label values sw_preference tofourscale


twoway (scatter fp_perception dist_foreign_policy [w=dist_foreign_policy_sqN], ///
			msymbol(circle_hollow) jitter(3)) /// 	//(function y = x) ///
	(lpoly fp_perception dist_foreign_policy [w=dist_foreign_policy_sqN]), ///
	by(fp_preference) xsc(r(0 1)) xtitle(District Opinion) ytitle(MC Perception) scheme(plottig) ///
	ylabel(0 .5 1)  legend(off) //  titleg(1)	
gr export ms_fp.png, replace


twoway (scatter cr_perception dist_civil_rights [w=dist_civil_rights_sqN], ///
			msymbol(circle_hollow) jitter(3)) /// //(function y = x) ///
	(lpoly cr_perception dist_civil_rights [w=dist_civil_rights_sqN]), ///
	by(cr_preference) xsc(r(0 1)) xti(District Opinion) yti(MC Perception) scheme(plottig) ///
	ylabel(0 .5 1)  legend(off) //  titleg(1)
gr export ms_cr.png, replace
	

twoway (scatter sw_perception dist_social_welfare [w=dist_social_welfare_sqN], ///
			msymbol(circle_hollow) jitter(3)) /// //(function y = x) ///
	(lpoly sw_perception dist_social_welfare [w=dist_social_welfare_sqN]), ///
	by(sw_preference) xsc(r(0 1)) xti(District Opinion) yti(MC Perception) scheme(plottig) ///
	ylabel(0 .5 1)  legend(off) //  titleg(1)
gr export ms_sw.png, replace


recode sw_preference fp_preference (0/1=0) (2=.) (3/4=1)
recode cr_preference (0/1=0) (2/3=1)

label define dichot 0 "Conservative - 0, 0.25, or 0.33" 1 "Liberal - 0.67, 0.75, or 1"

label values cr_preference dichot
label values fp_preference dichot
label values sw_preference dichot

twoway (scatter fp_perception dist_foreign_policy [w=dist_foreign_policy_sqN], ///
			msymbol(circle_hollow) jitter(3)) /// //(function y = x) ///
	(lpoly fp_perception dist_foreign_policy [w=dist_foreign_policy_sqN]), ///
	by(fp_preference) xsc(r(0 1)) xtitle(District Opinion) ytitle(MC Perception) scheme(plottig) ///
	ylabel(0 .5 1)  legend(off) //  titleg(1)	
gr export ms_fp_dichot.png, replace


twoway (scatter cr_perception dist_civil_rights [w=dist_civil_rights_sqN], ///
			msymbol(circle_hollow) jitter(3)) /// //(function y = x) ///
	(lpoly cr_perception dist_civil_rights [w=dist_civil_rights_sqN]), ///
	by(cr_preference) xsc(r(0 1)) xti(District Opinion) yti(MC Perception) scheme(plottig) ///
	ylabel(0 .5 1)  legend(off) //  titleg(1)
gr export ms_cr_dichot.png, replace
	

twoway (scatter sw_perception dist_social_welfare [w=dist_social_welfare_sqN], ///
			msymbol(circle_hollow) jitter(3)) /// //(function y = x) ///
	(lpoly sw_perception dist_social_welfare [w=dist_social_welfare_sqN]), ///
	by(sw_preference) xsc(r(0 1)) xti(District Opinion) yti(MC Perception) scheme(plottig) ///
	ylabel(0 .5 1)  legend(off) //  titleg(1)
gr export ms_sw_dichot.png, replace
	
