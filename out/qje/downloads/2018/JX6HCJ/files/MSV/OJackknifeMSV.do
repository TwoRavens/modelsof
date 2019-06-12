
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		capture `anything' `if' `in', absorb(`absorb')
		}
	else {
		capture `anything' `if' `in', 
		}
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		capture `anything' `if' `in', absorb(`absorb')
		}
	else {
		capture `anything' `if' `in', 
		}
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 76

use DatMSV1, clear

matrix B = J(164,1,.)

mac def C2006_vars1z  "z_tvip_06 z_language_06 z_memory_06 z_social_06 z_behavior_06"
mac def C2006_vars2z  "z_grmotor_06 z_finmotor_06 z_legmotor_06 z_height_06 z_weight_06"
mac def C2008_vars1z  "z_tvip_08 z_language_08 z_memory_08 z_martians_08 z_social_08 z_behavior_08"
mac def C2008_vars2z  "z_grmotor_08 z_finmotor_08 z_legmotor_08 z_height_08 z_weight_08"
mac def Cvars_06z "$C2006_vars1z $C2006_vars2z"
mac def Cvars_08z "$C2008_vars1z $C2008_vars2z"
mac def C2006_vars1zm  "z_tvip_06m z_language_06m z_memory_06m z_social_06m z_behavior_06m"
mac def C2006_vars2zm  "z_grmotor_06m z_finmotor_06m z_legmotor_06m z_height_06m z_weight_06m"
mac def C2008_vars1zm  "z_tvip_08m z_language_08m z_memory_08m z_martians_08m  z_social_08m z_behavior_08m"
mac def C2008_vars2zm  "z_grmotor_08m z_finmotor_08m z_legmotor_08m z_height_08m z_weight_08m"
mac def Cvars_06zm "$C2006_vars1zm $C2006_vars2zm"
mac def Cvars_08zm "$C2008_vars1zm $C2008_vars2zm"

mac def controls6 "CEDAD* male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"
mac def controls6h "s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05  MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip lnpce_05"

*Define shortened controls that eliminate drops
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"
mac def controls6ha "s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip lnpce_05"

global j = 1

*Table 3 - 2006 and 2008 panels
foreach x in $Cvars_06z $Cvars_08z {
	mycmd (T) areg `x' T male, robust cluster(unique_05)  absorb(age_transfer1)
	mycmd (T) areg `x' T $controls6a, robust cluster(unique_05) absorb(age_transfer1)
	}

matrix S = J(3,20,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)/10
matrix S[2,1] = (1,0,1,0,1,0,1,0,1,0)/5
matrix S[3,11] = (1,0,1,0,1,0,1,0,1,0)/5

matrix SS = J(6,20,0)
matrix SS[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)/10
matrix SS[2,1] = (1,0,1,0,1,0,1,0,1,0)/5
matrix SS[3,11] = (1,0,1,0,1,0,1,0,1,0)/5
matrix SS[4,1] = (1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0)/5
matrix SS[5,1] = (1,0,0,0,1,0)/2
matrix SS[6,15] = (1,0,1,0,1,0)/3

mata Sa = st_matrix("S"); Sb = st_matrix("SS")

matrix S = J(3,22,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)/11
matrix S[2,1] = (1,0,1,0,1,0,1,0,1,0,1,0)/6
matrix S[3,13] = (1,0,1,0,1,0,1,0,1,0)/5

matrix SS = J(6,22,0)
matrix SS[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)/11
matrix SS[2,1] = (1,0,1,0,1,0,1,0,1,0,1,0)/6
matrix SS[3,13] = (1,0,1,0,1,0,1,0,1,0)/5
matrix SS[4,1] = (1,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0)/6
matrix SS[5,1] = (1,0,0,0,1,0,1,0)/3
matrix SS[6,17] = (1,0,1,0,1,0)/3

mata S1a = st_matrix("S"); S1b = st_matrix("SS")

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = Sa*`B''; st_matrix("coef",`B')
	matrix B[$j,1] = coef
	global j = $j + 3
end

capture program drop suestsb
prog define suestsb
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = Sb*`B''; st_matrix("coef",`B')
	matrix B[$j,1] = coef
	global j = $j + 6
end

capture program drop suests1a
prog define suests1a
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = S1a*`B''; st_matrix("coef",`B')
	matrix B[$j,1] = coef
	global j = $j + 3
end

capture program drop suests1b
prog define suests1b
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = S1b*`B''; st_matrix("coef",`B')
	matrix B[$j,1] = coef
	global j = $j + 6
end


*Table 4 

*Row 1  
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' male , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T male if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*Rows 2 & 3
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsb

*Row 4 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06zm {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
  	est store M$count
  	mac def count=$count+1
	}
suestsa

*Row 5 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a if  titmom_06 == 1 & mominhouse_06 == 1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*Row 6 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' male , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T male if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a

*Rows 7 & 8
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1b

*Row 9 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08zm {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
  	est store M$count
  	mac def count=$count+1
	}
suests1a

*Row 10 
est clear	
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a if titmom_08 == 1 & mominhouse_08 == 1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a

*Table 5 
mycmd (T) regress lnpce_06 T if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_06 T $controls6ha if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T if cp==mincp08 & cp~=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T $controls6ha if cp==mincp08 & cp~=., robust cluster(unique_05)

egen M = group(unique_05)
sum M
global reps = r(max)

preserve
	collapse (mean) M, by(unique_05)
	save aaa, replace
restore

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = Sa*`B''; st_matrix("coef",`B')
	matrix BB[$j,1] = coef
	global j = $j + 3
end

capture program drop suestsb
prog define suestsb
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = Sb*`B''; st_matrix("coef",`B')
	matrix BB[$j,1] = coef
	global j = $j + 6
end

capture program drop suests1a
prog define suests1a
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = S1a*`B''; st_matrix("coef",`B')
	matrix BB[$j,1] = coef
	global j = $j + 3
end

capture program drop suests1b
prog define suests1b
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = S1b*`B''; st_matrix("coef",`B')
	matrix BB[$j,1] = coef
	global j = $j + 6
end

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
	set seed `c'

preserve

drop if M == `c'

global j = 1

*Table 3 - 2006 and 2008 panels
foreach x in $Cvars_06z $Cvars_08z {
	mycmd1 (T) areg `x' T male, robust cluster(unique_05)  absorb(age_transfer1)
	mycmd1 (T) areg `x' T $controls6a, robust cluster(unique_05) absorb(age_transfer1)
	}

*Table 4 

*Row 1  
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' male , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T male if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*Rows 2 & 3
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsb

*Row 4 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06zm {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
  	est store M$count
  	mac def count=$count+1
	}
suestsa

*Row 5 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a if  titmom_06 == 1 & mominhouse_06 == 1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*Row 6 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' male , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T male if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a

*Rows 7 & 8
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1b

*Row 9 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08zm {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
  	est store M$count
  	mac def count=$count+1
	}
suests1a

*Row 10 
est clear	
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a if titmom_08 == 1 & mominhouse_08 == 1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a

*Table 5 
mycmd1 (T) regress lnpce_06 T if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd1 (T) regress lnpce_06 T $controls6ha if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd1 (T) regress lnpce_08 T if cp==mincp08 & cp~=., robust cluster(unique_05)
mycmd1 (T) regress lnpce_08 T $controls6ha if cp==mincp08 & cp~=., robust cluster(unique_05)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeMSV1, replace

*****************************
*****************************

global b = 12

use DatMSV2, clear
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter   tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"

*These lines missing from do file for this table, can't execute without them
mac def C2006_vars1z  "z_tvip_06 z_language_06 z_memory_06 z_social_06 z_behavior_06"
mac def C2006_vars2z  "z_grmotor_06 z_finmotor_06 z_legmotor_06 z_height_06 z_weight_06"
mac def C2008_vars1z  "z_tvip_08 z_language_08 z_memory_08 z_martians_08 z_social_08 z_behavior_08"
mac def C2008_vars2z  "z_grmotor_08 z_finmotor_08 z_legmotor_08 z_height_08 z_weight_08"
mac def Cvars_06z "$C2006_vars1z $C2006_vars2z"
mac def Cvars_08z "$C2008_vars1z $C2008_vars2z"

global j = 77

matrix S = J(3,20,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)/10
matrix S[2,1] = (1,0,1,0,1,0,1,0,1,0)/5
matrix S[3,11] = (1,0,1,0,1,0,1,0,1,0)/5
mata Sa = st_matrix("S")

matrix S = J(3,22,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)/11
matrix S[2,1] = (1,0,1,0,1,0,1,0,1,0,1,0)/6
matrix S[3,13] = (1,0,1,0,1,0,1,0,1,0)/5
mata S1a = st_matrix("S")

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = Sa*`B''; st_matrix("coef",`B')
	matrix B[$j,1] = coef
	global j = $j + 3
end

capture program drop suests1a
prog define suests1a
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = S1a*`B''; st_matrix("coef",`B')
	matrix B[$j,1] = coef
	global j = $j + 3
end

*Table 6

*Row 1
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
 	quietly areg `x' male, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T male if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*Row 2
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a, absorb(age_transfer1)  
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*Row 3
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' male, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T male if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a

*Row 4
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a, absorb(age_transfer1)  
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a

merge m:1 unique_05 using aaa, nogenerate

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = Sa*`B''; st_matrix("coef",`B')
	matrix BB[$j,1] = coef
	global j = $j + 3
end

capture program drop suests1a
prog define suests1a
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = S1a*`B''; st_matrix("coef",`B')
	matrix BB[$j,1] = coef
	global j = $j + 3
end

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1

*Table 6

*Row 1
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
 	quietly areg `x' male, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T male if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*Row 2
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a, absorb(age_transfer1)  
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*Row 3
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' male, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T male if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a

*Row 4
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a, absorb(age_transfer1)  
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 77/88 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeMSV2, replace

*****************************
*****************************

global b = 76

use DatMSV3, clear

mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss tvip_05_miss tvip_05_inter height_05_miss height_05_inter weight_05_miss weight_05_inter bweight_miss bweight_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"

mac def C2008_vars1fz  "z_propfood_08  z_prstap_f_08  z_pranimalprot_f_08 z_prfruitveg_f_08"
mac def C2008_vars2sz  "z_a3lapiz_08 z_a3stories_08  z_nrhourread_08 z_e1bp3_toy"
mac def C2008_vars3hz  "z_weighted_08 z_vitamiron_08 z_s4p7_parasite_i_08 z_s4p39_daysbed_i_08"
mac def C2008_vars4ez  "z_a13cesd_08 z_e5home_08  "
mac def Cvars_08z "$C2008_vars1fz $C2008_vars2sz $C2008_vars3hz $C2008_vars4ez"
mac def C2006_vars1fz  "z_propfood_06 z_prstap_f_06  z_pranimalprot_f_06 z_prfruitveg_f_06"
mac def C2006_vars2sz  "z_a3lapiz_06 z_a3stories_06  z_nrhourread_06 z_a3toy6M"
mac def C2006_vars3hz  "z_weighted_06 z_vitamiron_06 z_s4p7_parasite_i_06 z_s4p39_06"
mac def C2006_vars4ez  "z_a13cesd_06 z_a14home_06 "
mac def Cvars_06z "$C2006_vars1fz $C2006_vars2sz $C2006_vars3hz $C2006_vars4ez"

global j = 89

matrix S = J(19,28,0)
forvalues i = 1/14 {
	matrix S[`i',(`i'-1)*2+1] = 1
	}
matrix S[15,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,2,0,2,0)/16
matrix S[16,1] = (1,0,1,0,1,0,1,0)/4
matrix S[17,9] = (1,0,1,0,1,0,1,0)/4
matrix S[18,17] = (1,0,1,0,1,0,1,0)/4
matrix S[19,25] = (1,0,1,0)/2
mata Sa = st_matrix("S")

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = Sa*`B''; st_matrix("coef",`B')
	matrix B[$j,1] = coef
	global j = $j + 19
end

*Table 8

*2008 - column 1 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
 	quietly areg `x' $controls6a if sample08==1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*2008 - column 2 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a ln_pce08 ln_pce08sq if sample08==1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a ln_pce08 ln_pce08sq if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*2006 - column 1 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
  	quietly areg `x' $controls6a if sample06==1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
}
suestsa

*2006 - column 2 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
  	quietly areg `x' $controls6a ln_pce06 ln_pce06sq if sample06==1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a ln_pce06 ln_pce06sq if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

egen M = group(unique_05)

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14, cluster(unique_05) 
	mata `B' = st_matrix("e(b)"); `B' = Sa*`B''; st_matrix("coef",`B')
	matrix BB[$j,1] = coef
	global j = $j + 19
end

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if M == `c'

global j = 1

*Table 8

*2008 - column 1 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
 	quietly areg `x' $controls6a if sample08==1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*2008 - column 2 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a ln_pce08 ln_pce08sq if sample08==1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a ln_pce08 ln_pce08sq if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

*2006 - column 1 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
  	quietly areg `x' $controls6a if sample06==1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
}
suestsa

*2006 - column 2 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
  	quietly areg `x' $controls6a ln_pce06 ln_pce06sq if sample06==1, absorb(age_transfer1)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a ln_pce06 ln_pce06sq if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suestsa

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 89/164 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeMSV3, replace

*****************************
*****************************

use ip\OJackknifeMSV1, clear
merge 1:1 N using ip\OJackknifeMSV2, nogenerate
merge 1:1 N using ip\OJackknifeMSV3, nogenerate
aorder
svmat double B
save results\OJackknifeMSV, replace

