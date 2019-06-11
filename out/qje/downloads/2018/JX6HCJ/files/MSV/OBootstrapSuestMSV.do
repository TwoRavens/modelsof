

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		matrix B = J(1,100,.)
		estimates clear
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture `cmd' `dep' `newtestvars' `anything' `if' `in', 
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************

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

*Table 3 - 2006 and 2008 panels
global i = 0
foreach x in $Cvars_06z $Cvars_08z {
	mycmd (T) areg `x' T male, robust cluster(unique_05)  absorb(age_transfer1)
	mycmd (T) areg `x' T $controls6a, robust cluster(unique_05) absorb(age_transfer1)
	}

quietly suest $M, cluster(unique_05)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

*Table 4
*Row 1  
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' male , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T male if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Rows 2 & 3
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 4 
foreach x of global Cvars_06zm {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
  	est store M$count
  	mac def count=$count+1
	}

*Row 5 
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a if  titmom_06 == 1 & mominhouse_06 == 1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 6 
foreach x of global Cvars_08z {
	quietly areg `x' male , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T male if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Rows 7 & 8
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 9 
foreach x of global Cvars_08zm {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
  	est store M$count
  	mac def count=$count+1
	}

*Row 10 
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a if titmom_08 == 1 & mominhouse_08 == 1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M28 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M50 M51 M52 M53 M54 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84, cluster(unique_05)
matrix V = e(V)
matrix b = e(b)

matrix SSS = J(20,168,0)

matrix S = J(2,22,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0)/5
matrix S[2,11] = (1,0,1,0,1,0,1,0,1,0)/5

matrix SS = J(4,20,0)
matrix SS[1,1] = (1,0,1,0,1,0,1,0,1,0)/5
matrix SS[2,11] = (1,0,1,0,1,0,1,0,1,0)/5
matrix SS[3,1] = (1,0,0,0,1,0)/2
matrix SS[4,15] = (1,0,1,0,1,0)/3

matrix SSS[1,1] = S
matrix SSS[3,21] = SS
matrix SSS[7,41] = S
matrix SSS[9,61] = S

matrix S = J(2,22,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0)/6
matrix S[2,13] = (1,0,1,0,1,0,1,0,1,0)/5

matrix SS = J(4,22,0)
matrix SS[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0)/6
matrix SS[2,13] = (1,0,1,0,1,0,1,0,1,0)/5
matrix SS[3,1] = (1,0,0,0,1,0,1,0)/3
matrix SS[4,17] = (1,0,1,0,1,0)/3

matrix SSS[11,81] = S
matrix SSS[13,103] = SS
matrix SSS[17,125] = S
matrix SSS[19,147] = S

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), b'*v*b; st_matrix("test",test)
matrix F = F \ (chi2tail(test[1,1],test[1,2]), 20-test[1,1], test[1,1], test[1,2], 4)
mata b4 = b

*Table 5 
global i = 0
mycmd (T) regress lnpce_06 T if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_06 T $controls6ha if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T if cp==mincp08 & cp~=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T $controls6ha if cp==mincp08 & cp~=., robust cluster(unique_05)

quietly suest $M, cluster(unique_05)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

gen Order = _n
sort unique_05 Order
gen N = 1
gen Dif = (unique_05 ~= unique_05[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace


mata ResF = J($reps,15,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop unique_05
	rename obs unique_05

*Table 3 - 2006 and 2008 panels
global i = 0
foreach x in $Cvars_06z $Cvars_08z {
	mycmd (T) areg `x' T male, robust cluster(unique_05)  absorb(age_transfer1)
	mycmd (T) areg `x' T $controls6a, robust cluster(unique_05) absorb(age_transfer1)
	}

capture suest $M, cluster(unique_05)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 4
*Row 1  
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
	quietly areg `x' male , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T male if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Rows 2 & 3
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 4 
foreach x of global Cvars_06zm {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
  	est store M$count
  	mac def count=$count+1
	}

*Row 5 
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a if  titmom_06 == 1 & mominhouse_06 == 1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 6 
foreach x of global Cvars_08z {
	quietly areg `x' male , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T male if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Rows 7 & 8
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 9 
foreach x of global Cvars_08zm {
	quietly areg `x' $controls6a , absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
  	est store M$count
  	mac def count=$count+1
	}

*Row 10 
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a if titmom_08 == 1 & mominhouse_08 == 1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M28 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M50 M51 M52 M53 M54 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84, cluster(unique_05)
matrix V = e(V)
matrix b = e(b)

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), (b-b4)'*v*(b-b4)
mata ResF[`c',6..10] = (chi2tail(test[1,1],test[1,2]), 20-test[1,1], test[1,1], test[1,2], 4)

*Table 5 
global i = 0
mycmd (T) regress lnpce_06 T if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_06 T $controls6ha if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T if cp==mincp08 & cp~=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T $controls6ha if cp==mincp08 & cp~=., robust cluster(unique_05)

capture suest $M, cluster(unique_05)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/15 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestMSV1, replace

*****************************
*****************************

use DatMSV2, clear
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter   tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"

*These lines missing from do file for this table, can't execute without them
mac def C2006_vars1z  "z_tvip_06 z_language_06 z_memory_06 z_social_06 z_behavior_06"
mac def C2006_vars2z  "z_grmotor_06 z_finmotor_06 z_legmotor_06 z_height_06 z_weight_06"
mac def C2008_vars1z  "z_tvip_08 z_language_08 z_memory_08 z_martians_08 z_social_08 z_behavior_08"
mac def C2008_vars2z  "z_grmotor_08 z_finmotor_08 z_legmotor_08 z_height_08 z_weight_08"
mac def Cvars_06z "$C2006_vars1z $C2006_vars2z"
mac def Cvars_08z "$C2008_vars1z $C2008_vars2z"

*Table 6

*Row 1
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
 	quietly areg `x' male, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T male if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 2
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a, absorb(age_transfer1)  
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 3
foreach x of global Cvars_08z {
	quietly areg `x' male, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T male if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 4
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a, absorb(age_transfer1)  
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M28 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M40 M41 M42, cluster(unique_05)
matrix V = e(V)
matrix b = e(b)

matrix SSS = J(8,84,0)
matrix S = J(2,20,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0)/5
matrix S[2,11] = (1,0,1,0,1,0,1,0,1,0)/5

matrix SSS[1,1] = S
matrix SSS[3,21] = S

matrix S = J(2,22,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0)/6
matrix S[2,13] = (1,0,1,0,1,0,1,0,1,0)/5

matrix SSS[5,41] = S
matrix SSS[7,63] = S

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), b'*v*b; st_matrix("test",test)
matrix F = F \ (chi2tail(test[1,1],test[1,2]), 8-test[1,1], test[1,1], test[1,2], 6)
mata b6 = b

gen Order = _n
sort unique_05 Order
gen N = 1
gen Dif = (unique_05 ~= unique_05[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save bb, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop unique_05
	rename obs unique_05

*Table 6

*Row 1
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_06z {
 	quietly areg `x' male, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T male if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 2
foreach x of global Cvars_06z {
	quietly areg `x' $controls6a, absorb(age_transfer1)  
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 3
foreach x of global Cvars_08z {
	quietly areg `x' male, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T male if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*Row 4
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a, absorb(age_transfer1)  
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M28 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M40 M41 M42, cluster(unique_05)
matrix V = e(V)
matrix b = e(b)

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), (b-b6)'*v*(b-b6)
mata ResF[`c',1..5] = (chi2tail(test[1,1],test[1,2]), 8-test[1,1], test[1,1], test[1,2], 6)

}

drop _all
set obs $reps
forvalues i = 16/20 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestMSV2, replace

*****************************
*****************************

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

*Table 8

*2008 - column 1 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
 	quietly areg `x' $controls6a if sample08==1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*2008 - column 2 
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a ln_pce08 ln_pce08sq if sample08==1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a ln_pce08 ln_pce08sq if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*2006 - column 1 
foreach x of global Cvars_06z {
  	quietly areg `x' $controls6a if sample06==1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*2006 - column 2 
foreach x of global Cvars_06z {
  	quietly areg `x' $controls6a ln_pce06 ln_pce06sq if sample06==1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a ln_pce06 ln_pce06sq if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M28 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M50 M51 M52 M53 M54 M55 M56, cluster(unique_05)
matrix V = e(V)
matrix b = e(b)

matrix SSS = J(56,112,0)
matrix S = J(14,28,0)
forvalues i = 1/14 {
	matrix S[`i',(`i'-1)*2+1] = 1
	}
matrix SSS[1,1] = S
matrix SSS[15,29] = S
matrix SSS[29,57] = S
matrix SSS[43,85] = S

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), b'*v*b; st_matrix("test",test)
matrix F = F \ (chi2tail(test[1,1],test[1,2]), 56-test[1,1], test[1,1], test[1,2], 8)
mata b8 = b

gen Order = _n
sort unique_05 Order
gen N = 1
gen Dif = (unique_05 ~= unique_05[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save cc, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop unique_05
	rename obs unique_05

*Table 8
*2008 - column 1 
est clear
mac def count=1
capture drop X*
foreach x of global Cvars_08z {
 	quietly areg `x' $controls6a if sample08==1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*2008 - column 2 
foreach x of global Cvars_08z {
	quietly areg `x' $controls6a ln_pce08 ln_pce08sq if sample08==1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a ln_pce08 ln_pce08sq if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*2006 - column 1 
foreach x of global Cvars_06z {
  	quietly areg `x' $controls6a if sample06==1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

*2006 - column 2 
foreach x of global Cvars_06z {
  	quietly areg `x' $controls6a ln_pce06 ln_pce06sq if sample06==1, absorb(age_transfer1)
	quietly predict double X`x'$count if e(sample), resid
	quietly areg T $controls6a ln_pce06 ln_pce06sq if X`x'$count ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x'$count XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}

quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M28 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M50 M51 M52 M53 M54 M55 M56, cluster(unique_05)
matrix V = e(V)
matrix b = e(b)

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), (b-b8)'*v*(b-b8)
mata ResF[`c',1..5] = (chi2tail(test[1,1],test[1,2]), 56-test[1,1], test[1,1], test[1,2], 8)

}

drop _all
set obs $reps
forvalues i = 21/25 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestMSV3, replace


*****************************
*****************************

use ip\OBootstrapSuestMSV1, clear
merge 1:1 N using ip\OBootstrapSuestMSV2, nogenerate
merge 1:1 N using ip\OBootstrapSuestMSV3, nogenerate
drop F*
svmat double F
aorder
save results\OBootstrapSuestMSV, replace

capture erase aaa.dta
capture erase aa.dta
capture erase bb.dta
capture erase cc.dta


