****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		`anything' `if' `in', absorb(`absorb') cluster(`cluster') `robust'
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, absorb(string) cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		quietly `anything' `if' `in', absorb(`absorb') cluster(`cluster') `robust'
		}
	else {
		quietly `anything' `if' `in', cluster(`cluster') `robust'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

*Part 1: Tables 3, 4 & 5

use DatMSV1, clear

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

matrix F = J(54,4,.)
matrix B = J(76,2,.)

global i = 1
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

mata t1 = (0,1,0) \ (0,0,1); t2 = (0,1,0,0,0,0) \ (0,0,1,0,0,0) \ (0,0,0,0,1,0) \ (0,0,0,0,0,1)

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..3,1]'*t1'*`test'*t1*`B'[1..3,1]; st_matrix("test",`test')
	matrix B[$j,1] = coef
	matrix F[$i,1] = chi2tail(test[1,1],test[1,2]), 2-test[1,1], ., 3
	global j = $j + 3
	global i = $i + 1
end

capture program drop suestsb
prog define suestsb
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sb*`V'*Sb'; `B' = Sb*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t2*`V'*t2'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..6,1]'*t2'*`test'*t2*`B'[1..6,1]; st_matrix("test",`test')
	matrix B[$j,1] = coef
	matrix F[$i,1] = chi2tail(test[1,1],test[1,2]), 4-test[1,1], ., 6
	global j = $j + 6
	global i = $i + 1
end

capture program drop suests1a
prog define suests1a
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1a*`V'*S1a'; `B' = S1a*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..3,1]'*t1'*`test'*t1*`B'[1..3,1]; st_matrix("test",`test')
	matrix B[$j,1] = coef
	matrix F[$i,1] = chi2tail(test[1,1],test[1,2]), 2-test[1,1], ., 3
	global j = $j + 3
	global i = $i + 1
end

capture program drop suests1b
prog define suests1b
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1b*`V'*S1b'; `B' = S1b*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t2*`V'*t2'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..6,1]'*t2'*`test'*t2*`B'[1..6,1]; st_matrix("test",`test')
	matrix B[$j,1] = coef
	matrix F[$i,1] = chi2tail(test[1,1],test[1,2]), 4-test[1,1], ., 6
	global j = $j + 6
	global i = $i + 1
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

generate Order = _n
generate double U = .
global N = 106
mata Y = st_data((1,$N),"Y2")

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..3,1]'*t1'*`test'*t1*`B'[1..3,1]; st_matrix("test",`test')
	matrix BB[$j,1] = coef
	matrix FF[$i,1] = chi2tail(test[1,1],test[1,2]), 2-test[1,1], .
	global j = $j + 3
	global i = $i + 1
end

capture program drop suestsb
prog define suestsb
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sb*`V'*Sb'; `B' = Sb*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t2*`V'*t2'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..6,1]'*t2'*`test'*t2*`B'[1..6,1]; st_matrix("test",`test')
	matrix BB[$j,1] = coef
	matrix FF[$i,1] = chi2tail(test[1,1],test[1,2]), 4-test[1,1], .
	global j = $j + 6
	global i = $i + 1
end

capture program drop suests1a
prog define suests1a
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1a*`V'*S1a'; `B' = S1a*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..3,1]'*t1'*`test'*t1*`B'[1..3,1]; st_matrix("test",`test')
	matrix BB[$j,1] = coef
	matrix FF[$i,1] = chi2tail(test[1,1],test[1,2]), 2-test[1,1], .
	global j = $j + 3
	global i = $i + 1
end

capture program drop suests1b
prog define suests1b
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1b*`V'*S1b'; `B' = S1b*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t2*`V'*t2'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..6,1]'*t2'*`test'*t2*`B'[1..6,1]; st_matrix("test",`test')
	matrix BB[$j,1] = coef
	matrix FF[$i,1] = chi2tail(test[1,1],test[1,2]), 4-test[1,1], .
	global j = $j + 6
	global i = $i + 1
end

mata ResF = J($reps,54,.); ResD = J($reps,54,.); ResDF = J($reps,54,.); ResB = J($reps,76,.); ResSE = J($reps,76,.)
forvalues c = 1/$reps {
	matrix FF = J(54,3,.)
	matrix BB = J(76,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace T = Y2[`i'] if unique_05 == Y3[`i']
		}

global i = 1
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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..54] = FF[.,1]'; ResD[`c',1..54] = FF[.,2]'; ResDF[`c',1..54] = FF[.,3]'
mata ResB[`c',1..76] = BB[.,1]'; ResSE[`c',1..76] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/54 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/76 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherMSV1, replace

********************************


*Part 2: Table 6, randomization analysis will be limited to treatments in the table (sub unique treatments) - other (sub unique) treatments don't appear in any regression

use DatMSV2, clear
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter   tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"

*These lines missing from do file for this table, can't execute without them
mac def C2006_vars1z  "z_tvip_06 z_language_06 z_memory_06 z_social_06 z_behavior_06"
mac def C2006_vars2z  "z_grmotor_06 z_finmotor_06 z_legmotor_06 z_height_06 z_weight_06"
mac def C2008_vars1z  "z_tvip_08 z_language_08 z_memory_08 z_martians_08 z_social_08 z_behavior_08"
mac def C2008_vars2z  "z_grmotor_08 z_finmotor_08 z_legmotor_08 z_height_08 z_weight_08"
mac def Cvars_06z "$C2006_vars1z $C2006_vars2z"
mac def Cvars_08z "$C2008_vars1z $C2008_vars2z"

global i = 1
global j = 1
matrix F = J(4,4,.)
matrix B = J(12,2,.)

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

mata t1 = (0,1,0) \ (0,0,1)

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..3,1]'*t1'*`test'*t1*`B'[1..3,1]; st_matrix("test",`test')
	matrix B[$j,1] = coef
	matrix F[$i,1] = chi2tail(test[1,1],test[1,2]), 2-test[1,1], ., 3
	global j = $j + 3
	global i = $i + 1
end

capture program drop suests1a
prog define suests1a
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1a*`V'*S1a'; `B' = S1a*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..3,1]'*t1'*`test'*t1*`B'[1..3,1]; st_matrix("test",`test')
	matrix B[$j,1] = coef
	matrix F[$i,1] = chi2tail(test[1,1],test[1,2]), 2-test[1,1], ., 3
	global j = $j + 3
	global i = $i + 1
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


capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..3,1]'*t1'*`test'*t1*`B'[1..3,1]; st_matrix("test",`test')
	matrix BB[$j,1] = coef
	matrix FF[$i,1] = chi2tail(test[1,1],test[1,2]), 2-test[1,1], .
	global j = $j + 3
	global i = $i + 1
end

capture program drop suests1a
prog define suests1a
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1a*`V'*S1a'; `B' = S1a*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..3,1]'*t1'*`test'*t1*`B'[1..3,1]; st_matrix("test",`test')
	matrix BB[$j,1] = coef
	matrix FF[$i,1] = chi2tail(test[1,1],test[1,2]), 2-test[1,1], .
	global j = $j + 3
	global i = $i + 1
end


*Randomization analysis here is limited to treatment within the treatment villages amongst households with young children
*These regressions are for only treatment villages, amongst households with young children
gen N = _n
sort unique_05 N
drop N
generate Order = _n
generate double U = .
mata Y = st_data(.,"T")

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,12,.); ResSE = J($reps,12,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(12,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort unique_05 U 
	mata st_store(.,"T",Y)

global i = 1
global j = 1

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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..12] = BB[.,1]'; ResSE[`c',1..12] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/12 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherMSV2, replace

********************************


*Part 3: Table 8

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

matrix F = J(4,4,.)
matrix B = J(76,2,.)

global i = 1
global j = 1

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
mata t1 = I(14), J(14,5,0)

capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..19,1]'*t1'*`test'*t1*`B'[1..19,1]; st_matrix("test",`test')
	matrix B[$j,1] = coef
	matrix F[$i,1] = chi2tail(test[1,1],test[1,2]), 14-test[1,1], ., 19
	global j = $j + 19
	global i = $i + 1
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


capture program drop suestsa
prog define suestsa
	tempname V B test
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B')
	mata `test' = invsym(t1*`V'*t1'); `test' = sum(rowsum(abs(`test')):>0), `B'[1..19,1]'*t1'*`test'*t1*`B'[1..19,1]; st_matrix("test",`test')
	matrix BB[$j,1] = coef
	matrix FF[$i,1] = chi2tail(test[1,1],test[1,2]), 14-test[1,1], .
	global j = $j + 19
	global i = $i + 1
end


generate Order = _n
generate double U = .
global N = 106
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,76,.); ResSE = J($reps,76,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(76,2,.)
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace T = Y2[`i'] if unique_05 == Y3[`i']
		}

global i = 1
global j = 1

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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..76] = BB[.,1]'; ResSE[`c',1..76] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/76 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherMSV3, replace

************************

*Combine files

drop _all
use ip\FisherMSV1
sum B1
global k = r(N)
sum F1
global N = r(N)
mkmat F1-F4 in 1/$N, matrix(F)
mkmat B1 B2 in 1/$k, matrix(B)

use ip\FisherMSV2, clear
quietly sum B1
global k1 = r(N)
quietly sum F1
global N1 = r(N)
mkmat F1-F4 in 1/$N1, matrix(FF)
mkmat B1 B2 in 1/$k1, matrix(BB)
drop F1-F4 B1-B2 
forvalues i = $k1(-1)1 {
	local k = `i' + $k
	rename ResB`i' ResB`k'
	rename ResSE`i' ResSE`k'
	}
forvalues i = $N1(-1)1 {
	local k = `i' + $N
	rename ResF`i' ResF`k'
	rename ResDF`i' ResDF`k'
	rename ResD`i' ResD`k'
	}
sort N
save a2, replace

use ip\FisherMSV3, clear
quietly sum B1
global k2 = r(N)
quietly sum F1
global N2 = r(N)
mkmat F1-F4 in 1/$N2, matrix(FFF)
mkmat B1 B2 in 1/$k2, matrix(BBB)
drop F1-F4 B1-B2 
forvalues i = $k2(-1)1 {
	local k = `i' + $k + $k1
	rename ResB`i' ResB`k'
	rename ResSE`i' ResSE`k'
	}
forvalues i = $N2(-1)1 {
	local k = `i' + $N + $N1
	rename ResF`i' ResF`k'
	rename ResDF`i' ResDF`k'
	rename ResD`i' ResD`k'
	}
sort N
save a3, replace

use ip\FisherMSV1, clear
drop F1-F4 B1-B2
merge 1:1 N using a2, nogenerate
merge 1:1 N using a3, nogenerate
sort N
aorder
matrix F = F \ FF \ FFF
matrix B = B \ BB \ BBB
svmat double F
svmat double B
save results\FisherMSV, replace

capture erase a2.dta
capture erase a3.dta

