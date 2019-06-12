cd "~/Dropbox/Broockman-Skovron/Elite perceptions 2/Replication-Materials/Analysis Miller-Stokes"

use "Stata Data.dta", clear

// DISTRICT OPINION

// See page 696 of the ICPSR codebook for number of items in each index
// As we noted in the paper, how to code these variables is not entirely clear.
// We thank Nick Carnes for providing most of this code.

// Social welfare 
gen dist_social_welfare_N = .
replace dist_social_welfare_N = V748 		if V748!=99 & V793==99 & V1457==99
replace dist_social_welfare_N = V793 		if V748==99 & V793!=99 & V1457==99
replace dist_social_welfare_N = V1457 		if V748==99 & V793==99 & V1457!=99
replace dist_social_welfare_N = V748+V793  	if V748!=99 & V793!=99 & V1457==99
replace dist_social_welfare_N = V748+V1457 	if V748!=99 & V793==99 & V1457!=99
replace dist_social_welfare_N = V793+V1457 	if V748==99 & V793!=99 & V1457!=99
replace dist_social_welfare_N = V748+ V793+V1457 if V748!=99 & V793!=99 & V1457!=99
tab V1 if V748==99 & V793==99 & V1457==99
tab V1 if dist_social_welfare_N==.

	tab V746
	gen sw1drop = V746 / 3 if V746 < 9

	tab V791
	gen sw2drop = V791 / 2 if V791 < 9

	tab V1455
	gen sw3drop = V1455 / 3 if V1455 < 9

gen dist_social_welfare = .
replace dist_social_welfare = sw1 				if V748!=99 & V793==99 & V1457==99
replace dist_social_welfare = sw2 				if V748==99 & V793!=99 & V1457==99
replace dist_social_welfare = sw3 				if V748==99 & V793==99 & V1457!=99
replace dist_social_welfare = (sw1*V748+ sw2*V793) / (V748+V793) if V748!=99 & V793!=99 & V1457==99
replace dist_social_welfare = (sw1*V748+ sw3*V1457) / (V748+V1457) if V748!=99 & V793==99 & V1457!=99
replace dist_social_welfare = (sw2*V793+ sw3*V1457) / (V793+V1457) if V748==99 & V793!=99 & V1457!=99
replace dist_social_welfare = (sw1*V748 + sw2*V793+ sw3*V1457) / (V748 + V793+V1457) 	if V748!=99 & V793!=99 & V1457!=99


//  Foreign Policy
gen dist_foreign_policy_N = .
replace dist_foreign_policy_N = V751 		if V751!=99 & V796==99 & V1460==99
replace dist_foreign_policy_N = V796 		if V751==99 & V796!=99 & V1460==99
replace dist_foreign_policy_N = V1460 		if V751==99 & V796==99 & V1460!=99
replace dist_foreign_policy_N = V751+V796  	if V751!=99 & V796!=99 & V1460==99
replace dist_foreign_policy_N = V751+V1460 	if V751!=99 & V796==99 & V1460!=99
replace dist_foreign_policy_N = V796+V1460 	if V751==99 & V796!=99 & V1460!=99
replace dist_foreign_policy_N = V751+ V796+V1460 if V751!=99 & V796!=99 & V1460!=99
tab V1 if V751==99 & V796==99 & V1460==99
tab V1 if dist_foreign_policy_N==.

	tab V749
	gen fp1drop = V749 / 4 if V749 < 9

	tab V794
	gen fp2drop = V794 / 3 if V794 < 9
	
	tab V1458
	gen fp3drop = V1458 / 2 if V1458 < 9

gen dist_foreign_policy = .
replace dist_foreign_policy = fp1 				if V751!=99 & V796==99 & V1460==99
replace dist_foreign_policy = fp2 				if V751==99 & V796!=99 & V1460==99
replace dist_foreign_policy = fp3 				if V751==99 & V796==99 & V1460!=99
replace dist_foreign_policy = (fp1*V751+ fp2*V796) / (V751+V796) if V751!=99 & V796!=99 & V1460==99
replace dist_foreign_policy = (fp1*V751+ fp3*V1460) / (V751+V1460) if V751!=99 & V796==99 & V1460!=99
replace dist_foreign_policy = (fp2*V796+ fp3*V1460) / (V796+V1460) if V751==99 & V796!=99 & V1460!=99
replace dist_foreign_policy = (fp1*V751 + fp2*V796+ fp3*V1460) / (V751 + V796+V1460) 	if V751!=99 & V796!=99 & V1460!=99


// Civil Rights
gen dist_civil_rights_N = .
replace dist_civil_rights_N = V754 		if V754!=99 & V799==99 & V1463==99
replace dist_civil_rights_N = V799 		if V754==99 & V799!=99 & V1463==99
replace dist_civil_rights_N = V1463 		if V754==99 & V799==99 & V1463!=99
replace dist_civil_rights_N = V754+V799  	if V754!=99 & V799!=99 & V1463==99
replace dist_civil_rights_N = V754+V1463 	if V754!=99 & V799==99 & V1463!=99
replace dist_civil_rights_N = V799+V1463 	if V754==99 & V799!=99 & V1463!=99
replace dist_civil_rights_N = V754+ V799+V1463 if V754!=99 & V799!=99 & V1463!=99
tab V1 if V754==99 & V799==99 & V1463==99
tab V1 if dist_civil_rights_N==.

	gen cr1drop = V752 / 2 if V752 < 9

	gen cr2drop = V797 / 2 if V797 < 9

	gen cr3drop = V1461 / 2 if V1461 < 9

gen dist_civil_rights = .
replace dist_civil_rights = cr1 				if V754!=99 & V799==99 & V1463==99
replace dist_civil_rights = cr2 				if V754==99 & V799!=99 & V1463==99
replace dist_civil_rights = cr3 				if V754==99 & V799==99 & V1463!=99
replace dist_civil_rights = (cr1*V754+ cr2*V799) / (V754+V799) if V754!=99 & V799!=99 & V1463==99
replace dist_civil_rights = (cr1*V754+ cr3*V1463) / (V754+V1463) if V754!=99 & V799==99 & V1463!=99
replace dist_civil_rights = (cr2*V799+ cr3*V1463) / (V799+V1463) if V754==99 & V799!=99 & V1463!=99
replace dist_civil_rights = (cr1*V754 + cr2*V799+ cr3*V1463) / (V754 + V799+V1463) 	if V754!=99 & V799!=99 & V1463!=99

summ *drop

drop *drop

summ dist_social_welfare dist_foreign_policy dist_civil_rights
		
/*In everything that follows, higher values signify either (1) more liberal attitudes on social welfare, (2) more 
activist attitudes on foreign policy, or (3) more liberal attitudes on civil rights.*/



/*### Legislator Attitudes ###

The DTA File already has a nice social welfare attitude scale variable. For some reason, it doesn't 
have the same scale for foreign policy and civil rights (although the code for those is in one of
the code files -- I may not have saved). So I re-ran that code*/

// FP = 0-4 scale
// CR = 0-3 scale
// SW = 0-4 scale

gen social_welfare_scale = V106 if V106!=9

gen fp_preference = .
replace fp_preference = V82 if V82 < 9

gen cr_preference = .
replace cr_preference = V128 if V128 < 9

gen sw_preference = V106 if V106 < 9

summarize sw_preference
summarize fp_preference
summarize cr_preference



/*### Legislator Perceptions ###*/
generate fp_perception = V392 if V392 != 9
generate sw_perception = V394 if V394 != 9
generate cr_perception = V396 if V396 != 9

recode *_perception (1 = 0) (2 = 0.5) (3 = 1)

keep V6 *_preference dist_* *_perception


save "MS recoded.dta", replace

