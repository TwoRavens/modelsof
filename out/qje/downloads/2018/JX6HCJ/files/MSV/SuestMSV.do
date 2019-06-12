
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* xxx* Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
	if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
	quietly generate Ssample$i = e(sample)
	if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
	if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
	quietly predict double yyy$i if Ssample$i, resid
	local newtestvars = ""
	foreach var in `testvars' {
		if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
		quietly predict double xxx`var'$i if Ssample$i, resid
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	quietly reg yyy$i `newtestvars', noconstant
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}

	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

matrix B = J(164,2,.)
global j = 1

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

matrix SSS = J(30,168,0)

matrix S = J(3,22,0)
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

matrix SSS[1,1] = S
matrix SSS[4,21] = SS
matrix SSS[10,41] = S
matrix SSS[13,61] = S

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

matrix SSS[16,81] = S
matrix SSS[19,103] = SS
matrix SSS[25,125] = S
matrix SSS[28,147] = S

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); b = b, sqrt(diagonal(V)); st_matrix("b",b)
mata V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), b[1...,1]'*v*b[1...,1]; st_matrix("test",test)
matrix B[$j,1] = b
matrix F = F \ (chi2tail(test[1,1],test[1,2]), 1, test[1,1], test[1,2], 4)

global j = $j + 30

*Table 5 
global i = 0
mycmd (T) regress lnpce_06 T if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_06 T $controls6ha if cp06==mincp06 & cp06!=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T if cp==mincp08 & cp~=., robust cluster(unique_05)
mycmd (T) regress lnpce_08 T $controls6ha if cp==mincp08 & cp~=., robust cluster(unique_05)

quietly suest $M, cluster(unique_05)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

********************************

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

matrix SSS = J(12,84,0)
matrix S = J(3,20,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)/10
matrix S[2,1] = (1,0,1,0,1,0,1,0,1,0)/5
matrix S[3,11] = (1,0,1,0,1,0,1,0,1,0)/5

matrix SSS[1,1] = S
matrix SSS[4,21] = S

matrix S = J(3,22,0)
matrix S[1,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0)/11
matrix S[2,1] = (1,0,1,0,1,0,1,0,1,0,1,0)/6
matrix S[3,13] = (1,0,1,0,1,0,1,0,1,0)/5

matrix SSS[7,41] = S
matrix SSS[10,63] = S

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); b = b, sqrt(diagonal(V)); st_matrix("b",b)
mata V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), b[1...,1]'*v*b[1...,1]; st_matrix("test",test)
matrix B[$j,1] = b
matrix F = F \ (chi2tail(test[1,1],test[1,2]), 1, test[1,1], test[1,2], 6)

global j = $j + 12

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

matrix SSS = J(76,112,0)
matrix S = J(19,28,0)
forvalues i = 1/14 {
	matrix S[`i',(`i'-1)*2+1] = 1
	}
matrix S[15,1] = (1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,2,0,2,0)/16
matrix S[16,1] = (1,0,1,0,1,0,1,0)/4
matrix S[17,9] = (1,0,1,0,1,0,1,0)/4
matrix S[18,17] = (1,0,1,0,1,0,1,0)/4
matrix S[19,25] = (1,0,1,0)/2

matrix SSS[1,1] = S
matrix SSS[20,29] = S
matrix SSS[39,57] = S
matrix SSS[58,85] = S

matrix b = SSS*b'
matrix V = SSS*V*SSS'

mata b = st_matrix("b"); V = st_matrix("V"); b = b, sqrt(diagonal(V)); st_matrix("b",b)
mata V = st_matrix("V"); v = invsym(V); test = sum(rowsum(abs(v)):>0), b[1...,1]'*v*b[1...,1]; st_matrix("test",test)
matrix B[$j,1] = b
matrix F = F \ (chi2tail(test[1,1],test[1,2]), 1, test[1,1], test[1,2], 8)

drop _all
svmat double F
svmat double B
save results/SuestMSV, replace






