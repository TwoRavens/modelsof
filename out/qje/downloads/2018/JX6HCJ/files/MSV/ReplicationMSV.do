

*Extracting treatment vector using stratification creation programme kindly provided by Karen Macours

use macoursetal_main, clear
do MacoursProvidedcode_stratification_var
rename block_05 Strata
sum unique_05 Strata if T == .
drop if T == .
collapse (mean) Strata T, by(unique_05) fast
sort Strata unique_05
mkmat Strata T unique_05, matrix(Y)
global N = 106
keep unique_05
sort unique_05
save Sample1, replace

*******************************************************

*Part 1:  Tables 3, 4 & 5

use macoursetal_main, clear

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

gen age_transfer1 = age_transfer+40
qui tab age_transfer1, gen(CEDAD)

mac def controls6 "CEDAD* male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"
mac def controls6h "s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05  MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip lnpce_05"

*Define shortened controls that eliminate drops
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"
mac def controls6ha "s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip lnpce_05"

gen lnpce_05 =ln(cons_tot_pc_05)
gen lnpce_08 =ln(cons_tot_pc_08)
gen lnpce_06 =ln(cons_tot_pc_06)
gen basico = T
replace basico = . if inlist(itt_all_i,3,4)
gen grant = T
replace grant = . if inlist(itt_all_i,3,2)
gen training = T
replace training = . if inlist(itt_all_i,2,4)
gen basicod = (itt_all_i==2)
gen trainingd = (itt_all_i==3)
gen grantd = (itt_all_i==4)
gen cp2 = cp06 if z_all_06~=.
bysort hogarid06 i06 : egen mincp06 = min(cp2) if lnpce_06~=.  
gen cp3 = cp if z_all_08~=.
bysort hogarid08 : egen mincp08 = min(cp3)  if lnpce_08~=. 

drop if T == .

cap program drop _all
prog def suests
	quietly suest  M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) dir
	display "ALL VARIABLES"
	lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T+[M6_mean]T+[M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T)/10
	display "COGNITIVE AND SOCIO-EMOTIONAL VARIABLES"
	lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T)/5
	display "PHYSICAL VARIABLES"
	lincom ([M6_mean]T+[M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T)/5
	display "ALL VARIABLES--EXCLUDING PARENT REPORTS"
	lincom ([M1_mean]T+[M3_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T)/5
	display "COGNITIVE AND SOCIO-EMOTIONAL VARIABLES--EXCLUDING PARENT REPORTS"
	lincom ([M1_mean]T+[M3_mean]T)/2
	display "PHYSICAL VARIABLES--EXCLUDING PARENT REPORTS"
	lincom ([M8_mean]T+[M9_mean]T+[M10_mean]T)/3 
end

prog def suests1
	quietly suest  M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) dir
	display "ALL VARIABLES"
	lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T+[M6_mean]T+[M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T+[M11_mean]T)/11
	display "ALL VARIABLES WITHOUT MARTIANS TEST"
	lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M5_mean]T+[M6_mean]T+[M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T+[M11_mean]T)/10
	display "COGNITIVE AND SOCIO-EMOTIONAL VARIABLES"
	lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T+[M6_mean]T)/6
	display "COGNITIVE AND SOCIO-EMOTIONAL VARIABLES WITHOUT MARTIANS TEST"
	lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M5_mean]T+[M6_mean]T)/5
	display "PHYSICAL VARIABLES"
	lincom ([M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T+[M11_mean]T)/5
	display "ALL VARIABLES--EXCLUDING PARENT REPORTS"
	lincom ([M1_mean]T+[M3_mean]T+[M4_mean]T+[M9_mean]T+[M10_mean]T +[M11_mean]T)/6
	display "COGNITIVE AND SOCIO-EMOTIONAL VARIABLES--EXCLUDING PARENT REPORTS"
	lincom ([M1_mean]T+[M3_mean]T+[M4_mean]T)/3
	display "PHYSICAL VARIABLES--EXCLUDING PARENT REPORTS"
	lincom ([M9_mean]T+[M10_mean]T +[M11_mean]T)/3 
end



*Table 3 - numerous rounding errors - sample sizes all correct

*2006 panel of Table 3
foreach x of global Cvars_06z {
	regress `x' T CEDAD* male, robust cluster(unique_05)  
	regress `x' T $controls6, robust cluster(unique_05)
	}

*2008 panel of Table 3 - Two rounding errors
foreach x of global Cvars_08z {
	regress `x'  T CEDAD* male, robust cluster(unique_05)
 	regress `x'  T $controls6, robust cluster(unique_05)
	}



*Table 4 - rounding errors and mixed up coefficients

*Row 1 - All okay
est clear
mac def count=1
foreach x of global Cvars_06z {
	quietly regress `x'  T CEDAD* male    
	est store M$count
	mac def count=$count+1
	}
suests

*Row 2 - All okay
est clear
mac def count=1
foreach x of global Cvars_06z {
	quietly regress `x'  T $controls6
	est store M$count
	mac def count=$count+1
	}
suests

*Row 3 - a different linear combination of results in Row 2

*Row 4 - All okay
est clear
mac def count=1
foreach x of global Cvars_06zm {
 	quietly regress `x'  T $controls6  
  	est store M$count
  	mac def count=$count+1
	}
suests

*Row 5 - All okay
est clear
mac def count=1
foreach x of global Cvars_06z {
	quietly regress `x'  T $controls6 if titmom_06==1 & mominhouse_06==1
	est store M$count
	mac def count=$count+1
	}
suests

*Row 6 - All okay
est clear
mac def count=1
foreach x of global Cvars_08z {
	quietly regress `x'  T CEDAD* male
	est store M$count
	mac def count=$count+1
	}
suests1

*Row 7 - Two rounding errors
est clear
mac def count=1
foreach x of global Cvars_08z {
	quietly regress `x'  T $controls6  
	est store M$count
	mac def count=$count+1
	}
suests1

*Row 8 - a different linear combination of results in Row 7 - with a rounding error


*Row 9 - Mixed up coefficients in reporting results (drew the wrong coefficients from the reported results), observation count wrong
est clear
mac def count=1
foreach x of global Cvars_08zm {
	quietly regress `x'  T $controls6  
	est store M$count
	mac def count=$count+1
	}
suests1

*Row 10 - All okay
est clear	
mac def count=1
foreach x of global Cvars_08z {
	quietly regress `x'  T $controls6 if titmom_08==1 & mominhouse_08==1
	est store M$count
	mac def count=$count+1
	}
suests1

*Recoding

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
	tempname V B
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B'); `B'
end

capture program drop suestsb
prog define suestsb
	tempname V B
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sb*`V'*Sb'; `B' = Sb*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B'); `B'
end

capture program drop suests1a
prog define suests1a
	tempname V B
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1a*`V'*S1a'; `B' = S1a*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B'); `B'
end

capture program drop suests1b
prog define suests1b
	tempname V B
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1b*`V'*S1b'; `B' = S1b*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B'); `B'
end


*Table 4 - rounding errors and mixed up coefficients

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
	quietly areg `x' $controls6a , absorb(age_transfer)
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
	quietly areg `x' $controls6a , absorb(age_transfer)
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
	quietly areg `x' $controls6a if  titmom_06 == 1 & mominhouse_06 == 1, absorb(age_transfer)
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
	quietly areg `x' $controls6a , absorb(age_transfer)
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
	quietly areg `x' $controls6a , absorb(age_transfer)
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
	quietly areg `x' $controls6a if titmom_08 == 1 & mominhouse_08 == 1, absorb(age_transfer)
	quietly predict double X`x' if e(sample), resid
	quietly areg T $controls6a if X`x' ~= ., absorb(age_transfer1)
	quietly predict double XT$count if e(sample), resid
	quietly reg X`x' XT$count, noconstant
	est store M$count
	mac def count=$count+1
	}
suests1a


*Table 5 - All okay

foreach x in lnpce {
	regress `x'_06  T if cp06==mincp06 & cp06!=., robust cluster(unique_05)  
	regress `x'_06 basicod trainingd grantd if cp06==mincp06 & cp06!=., robust cluster(unique_05)
	regress `x'_06  T $controls6h if cp06==mincp06 & cp06!=., robust cluster(unique_05)
     	regress `x'_06 basicod trainingd grantd $controls6h if cp06==mincp06 & cp06!=., robust cluster(unique_05)
	}
  
foreach x in lnpce {
	regress `x'_08  T if cp==mincp08 & cp~=., robust cluster(unique_05)
	regress `x'_08 basicod trainingd grantd if cp==mincp08 & cp~=., robust cluster(unique_05)
	regress `x'_08  T $controls6h if cp==mincp08 & cp~=., robust cluster(unique_05)
    	regress `x'_08  basicod trainingd grantd $controls6h if cp==mincp08 & cp~=., robust cluster(unique_05)
  	}


*Only test equations with T as randomization within villages problematic (don't have full randomization sample, authors unable to provide)

	regress lnpce_06 T if cp06==mincp06 & cp06!=., robust cluster(unique_05)
	regress lnpce_06 T $controls6ha if cp06==mincp06 & cp06!=., robust cluster(unique_05)
	regress lnpce_08 T if cp==mincp08 & cp~=., robust cluster(unique_05)
	regress lnpce_08 T $controls6ha if cp==mincp08 & cp~=., robust cluster(unique_05)

svmat double Y
save DatMSV1, replace

********************************

*Part 2: Table 6, randomization analysis will be limited to treatments in the table (sub unique treatments) - other (sub unique) treatments don't appear in any regression

use macoursetal_t13, clear
gen age_transfer1 = age_transfer+40
qui tab age_transfer1, gen(CEDAD)
drop age_transfer1
mac def controls6 "CEDAD* male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter   tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter   tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN2-MUN6 com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"

*These lines missing from do file for this table, can't execute without them
mac def C2006_vars1z  "z_tvip_06 z_language_06 z_memory_06 z_social_06 z_behavior_06"
mac def C2006_vars2z  "z_grmotor_06 z_finmotor_06 z_legmotor_06 z_height_06 z_weight_06"
mac def C2008_vars1z  "z_tvip_08 z_language_08 z_memory_08 z_martians_08 z_social_08 z_behavior_08"
mac def C2008_vars2z  "z_grmotor_08 z_finmotor_08 z_legmotor_08 z_height_08 z_weight_08"
mac def Cvars_06z "$C2006_vars1z $C2006_vars2z"
mac def Cvars_08z "$C2008_vars1z $C2008_vars2z"

cap program drop _all
prog def suests
   qui suest  M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) dir
   display "ALL VARIABLES"
   lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T+[M6_mean]T+[M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T)/10
   display "COGNITIVE AND SOCIO-EMOTIONAL VARIABLES"
   lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T)/5
   display "PHYSICAL VARIABLES"
   lincom ([M6_mean]T+[M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T)/5
end

prog def suests1
   qui suest  M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) dir
   display "ALL VARIABLES"
   lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T+[M6_mean]T+[M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T+[M11_mean]T)/11
   display "COGNITIVE AND SOCIO-EMOTIONAL VARIABLES"
   lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T+[M6_mean]T)/6
   display "PHYSICAL VARIABLES"
   lincom ([M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T+[M11_mean]T)/5
end

*Table 6

*Row 1 - All okay
est clear
mac def count=1
foreach x of global Cvars_06z {
 	quietly regress `x'  T CEDAD* male    
	est store M$count
	mac def count=$count+1
	}
suests

ereturn list

*Row 2 - All okay
est clear
mac def count=1
foreach x of global Cvars_06z {
	quietly regress `x'  T $controls6  
	est store M$count
	mac def count=$count+1
	}
suests

ereturn list

*Row 3 - Observations number slightly incorrect (2113 not 2114)
est clear
mac def count=1
foreach x of global Cvars_08z {
	quietly regress `x'  T CEDAD* male    
	est store M$count
	mac def count=$count+1
	}
suests1

ereturn list

*Row 4 - Observations number slightly incorrect (2113 not 2114)
est clear
mac def count=1
foreach x of global Cvars_08z {
	quietly regress `x'  T $controls6  
	est store M$count
	mac def count=$count+1
	}
suests1

ereturn list

*Recoding

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
	tempname V B
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B'); `B'
end

capture program drop suests1a
prog define suests1a
	tempname V B
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = S1a*`V'*S1a'; `B' = S1a*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B'); `B'
end

drop if T == .
rename age_transfer age_transfer1

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

svmat double Y
save DatMSV2, replace

********************************************************************************


*Can't do randomization analysis for these regressions
*Treat4 variable is a subvillage variable versus all other treatments, including control
*To randomize, would have to first randomize at village level (control versus any treatment), and then randomize at subvillage level (between different types of treatments)
*But, no sense of how to rerandomize subvillage treatment in villages which were control (because different numbers of households in each village and no data files on households without children so can't examine full randomization scheme)
*So, no coherent way to reallocate treatment to control villages, and then randomize subvillage treatments
*Hence, this part not analysed
*Note contrast with Table 6, where treatment variable is only within treatment villages, contrasting two sub-treatments.  This can be rerandomized, because re-randomize
*within the treated village across households with children (which is the data they report) - taking as given exchangeability across these households.


use macoursetal_main, clear
gen age_transfer1 = age_transfer+40
qui tab age_transfer1, gen(CEDAD)
drop age_transfer1
mac def controls6 "CEDAD* male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss bweight_miss bweight_inter   tvip_05_miss tvip_05_inter  height_05_miss height_05_inter weight_05_miss weight_05_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"         
mac def controls6h " s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"


*Table 7

*2006 results - All okay

bysort hogarid06 i06 cpmom_06: egen mincpch_06 = min(cp06) if cpmom_06<77
foreach var in   s6wrkdys_agwa_i_06 s6wrkdys_nonagwa_i_06 s6wrkdys_nonagslf_i_06 s6wrkdys_prof_i_06  s6p14_indays_i_06 s6totwrkdays_06 {
	regress `var'_mom TREAT4 $controls6h if mincpch_06 == cp06 & cp06~=. & inlist(itt_all_i, 2,4) & sample06==1, cluster(unique_05)
	}

foreach var in a3stories_06 a3leerdummy_06 nrhourread_06  {
	regress `var' TREAT4 $controls6 if inlist(itt_all_i, 2,4) & sample06==1 & guardianmom_06 ==1, cluster(unique_05)
	}

bysort hogarid06 i06 cpmom_06: egen mincpch_06g2 = min(cp06) if guardianmom_06 ==1 & a13cesd_06mom~=.
foreach var in a13cesd_06mom  a14home_06mom {
	regress `var' TREAT4 $controls6 if inlist(itt_all_i, 2,4) & sample06==1 & guardianmom_06 ==1 & cp06== mincpch_06g2, cluster(unique_05)
	}


*2008 results - All okay

bysort hogarid08 cpmom_08: egen mincpch_08 = min(cp) if cpmom_08<77 & sample08==1
foreach var in  s6wrkdys_agwa_i_08 s6wrkdys_nonagwa_i_08 s6wrkdys_nonagslf_i_08 s6wrkdys_prof_i_08  s6p14_indays_i_08 s6totwrkdays_08 {
	regress `var'_mom TREAT4 $controls6h if mincpch_08 == cp & cp~=. &    inlist(itt_all_i, 2,4) & sample08==1, cluster(unique_05)
	}

foreach var in a3stories_08 a3leerdummy_08 nrhourread_08 hourstotalc_08 hourscuida_08 hourstrabcuida_08 {
	regress `var' TREAT4 $controls6 if inlist(itt_all_i, 2,4) & sample08==1 & guardianmom_08 ==1, cluster(unique_05)
	}

bysort hogarid08 cpmom_08: egen mincpch_08g = min(cp) if guardianmom_08 ==1
foreach var in a13cesd_08mom e5home_08mom {
	regress `var' TREAT4 $controls6 if inlist(itt_all_i, 2,4) & sample08==1 & guardianmom_08 ==1 & cp== mincpch_08g, cluster(unique_05)
	}

*************************************************************************

*Part 3: Table 8

use macoursetal_main, clear
gen age_transfer1 = age_transfer+40
qui tab age_transfer1, gen(CEDAD)

mac def controls6 "CEDAD* male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss tvip_05_miss tvip_05_inter height_05_miss height_05_inter weight_05_miss weight_05_inter bweight_miss bweight_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"
mac def controls6a "male s1age_head_05 s1hhsize_05 s1hhsz_undr5_05 s1hhsz_5_14_05 s1hhsz_15_24_05 s1hhsz_25_64_05 s1hhsz_65plus_05 s1male_head_05 ed_mom_inter ed_mom_miss tvip_05_miss tvip_05_inter height_05_miss height_05_inter weight_05_miss weight_05_inter bweight_miss bweight_inter MUN* com_haz_05 com_waz_05 com_tvip_05 com_control_05 com_vit_05 com_deworm_05 com_notvip"

gen ln_pce08 =ln(cons_tot_pc_08)
gen ln_pce06 =ln(cons_tot_pc_06)
gen ln_pce08sq = ln_pce08^2
gen ln_pce06sq = ln_pce06^2

*** CALCULATE Z-SCORES FOR SUREST***
foreach var in prstap_f_08 prstap_f_06 a13cesd_08 a13cesd_06  e5home_08  s4p39_daysbed_i_08 a14home_06  s4p39_06 {
	replace `var' = `var'*-1
	}
     
foreach var in propfood_08  prstap_f_08 pranimalprot_f_08 prfruitveg_f_08 a3lapiz_08 a3stories_08  nrhourread_08 e1bp3_toy weighted_08 vitamiron_08 s4p7_parasite_i_08 s4p39_daysbed_i_08 a13cesd_08 e5home_08 {
	gen C`var' = `var' if T==0
	egen mean_`var'=mean(C`var') 
	egen sd_`var'=sd(C`var') 
	gen z_`var'=(`var'-mean_`var')/sd_`var'
	drop mean_`var' sd_`var'
	}

foreach var in propfood_06 prstap_f_06 pranimalprot_f_06 prfruitveg_f_06 a3lapiz_06 a3stories_06  nrhourread_06 a3toy6M weighted_06 vitamiron_06 s4p7_parasite_i_06 s4p39_06 a13cesd_06 a14home_06 {
	gen C`var' = `var' if T==0
	egen mean_`var'=mean(C`var') 
	egen sd_`var'=sd(C`var') 
	gen z_`var'=(`var'-mean_`var')/sd_`var'
	drop mean_`var' sd_`var'
	}

*Replace variables to original values
foreach var in prstap_f_08 prstap_f_06 a13cesd_08 a13cesd_06  e5home_08  s4p39_daysbed_i_08 a14home_06 s4p39_06 {
	replace `var' = `var'*-1
	}

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
gen Tmale = T*male

*As above, only do randomization distribution for village level treatment, given difficulties in reproducing sub-village treatment

*Table 8 - 2006 - Column 1 (excluding standardized indices) - A few rounding errors
foreach x of varlist propfood_06 prstap_f_06 pranimalprot_f_06 prfruitveg_f_06 a3lapiz_06 a3stories_06  nrhourread_06 a3toy6M weighted_06 vitamiron_06 s4p7_parasite_i_06 s4p39_06 a13cesd_06 a14home_06 {
	regress `x' T $controls6 if sample06==1, cluster(unique_05)
	}

*Table 8 - 2006 - Column 2 (excluding standardized indices) - A few rounding errors - This code not in do file, had to create myself
foreach x of varlist propfood_06 prstap_f_06 pranimalprot_f_06 prfruitveg_f_06 a3lapiz_06 a3stories_06  nrhourread_06 a3toy6M weighted_06 vitamiron_06 s4p7_parasite_i_06 s4p39_06 a13cesd_06 a14home_06 {
	regress `x' T $controls6 ln_pce06 ln_pce06sq if sample06==1, cluster(unique_05)
	}

*Table 8 - 2006 - Column 3 (excluding standardized indices) - A few rounding errors 
foreach x of varlist propfood_06 prstap_f_06 pranimalprot_f_06 prfruitveg_f_06 a3lapiz_06 a3stories_06   nrhourread_06  a3toy6M weighted_06 vitamiron_06 s4p7_parasite_i_06 s4p39_06 a13cesd_06 a14home_06 {
	regress `x' T $controls6 if inlist(itt_all_i,1,2) &  sample06==1, cluster(unique_05)
	}

*Table 8 - 2008 - Column 1 (excluding standardized indices) - All okay
foreach x of varlist propfood_08  prstap_f_08 pranimalprot_f_08 prfruitveg_f_08 a3lapiz_08 a3stories_08  nrhourread_08  e1bp3_toy weighted_08 vitamiron_08 s4p7_parasite_i_08 s4p39_daysbed_i_08 a13cesd_08 e5home_08 {
	regress `x' T $controls6 if sample08==1, cluster(unique_05)
	}

*Table 8 - 2008 - Column 2 (excluding standardized indices) - A few rounding errors
foreach x of varlist propfood_08  prstap_f_08 pranimalprot_f_08 prfruitveg_f_08 a3lapiz_08 a3stories_08  nrhourread_08 e1bp3_toy weighted_08 vitamiron_08 s4p7_parasite_i_08 s4p39_daysbed_i_08 a13cesd_08 e5home_08 { 
	regress `x' T $controls6 ln_pce08 ln_pce08sq if sample08==1, cluster(unique_05)
	}

*Table 8 - 2008 - Column 3 (excluding standardized indices) - All okay
foreach x of varlist propfood_08  prstap_f_08 pranimalprot_f_08 prfruitveg_f_08 a3lapiz_08 a3stories_08 nrhourread_08  e1bp3_toy weighted_08 vitamiron_08 s4p7_parasite_i_08 s4p39_daysbed_i_08 a13cesd_08 e5home_08 {
	regress `x' T $controls6 if inlist(itt_all_i,1,2) &  sample08==1, cluster(unique_05)
	}

cap program drop _all
prog def suests
	quietly suest  M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 , cluster(unique_05) dir
	display "T  ALL  VARIABLES"
	lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T+[M5_mean]T+[M6_mean]T+[M7_mean]T+[M8_mean]T+[M9_mean]T+[M10_mean]T+[M11_mean]T+[M12_mean]T+2*[M13_mean]T+2*[M14_mean]T)/16
	display "T  FOOD VARIABLES"
	lincom ([M1_mean]T+[M2_mean]T+[M3_mean]T+[M4_mean]T)/4
	display "T  STIMULUS VARIABLES"
	lincom ([M5_mean]T+[M6_mean]T+[M7_mean]T+[M8_mean]T)/4 
	display "T HEALTH VARIABLES"
	lincom ([M10_mean]T+[M11_mean]T+[M12_mean]T+[M9_mean]T)/4 
	display "T ENVIRONMENT VARIABLES"
	lincom ([M14_mean]T+[M13_mean]T)/2 
end

*2008 - column 1 - All okay 
est clear
mac def count=1
foreach x of global Cvars_08z {
 	quietly regress `x'  T $controls6 if sample08==1
	est store M$count
	mac def count=$count+1
	}
suests

*2008 - column 2 - rounding errors
est clear
mac def count=1
foreach x of global Cvars_08z {
	quietly regress `x'  T $controls6 ln_pce08 ln_pce08sq if sample08==1
	est store M$count
	mac def count=$count+1
	}
suests

*2008 - column 3 - All okay
est clear
mac def count=1
foreach x of global Cvars_08z {
	quietly regress `x'  T  $controls6 if inlist(itt_all_i,1,2) & sample08==1
	est store M$count
	mac def count=$count+1
	}
suests

*2006 - column 1 - All okay
est clear
mac def count=1
foreach x of global Cvars_06z {
  	quietly regress `x'  T $controls6 if sample06==1
	est store M$count
	mac def count=$count+1
}
suests

*2006 - column 2 - All okay
est clear
mac def count=1
foreach x of global Cvars_06z {
  	quietly regress `x'  T  $controls6 ln_pce06 ln_pce06sq if sample06==1
	est store M$count
	mac def count=$count+1
	}
suests

*2006 - column 3 - All okay
est clear
mac def count=1
foreach x of global Cvars_06z {
	quietly regress `x'  T  $controls6 if inlist(itt_all_i,1,2) & sample06==1
	est store M$count
	mac def count=$count+1
	}
suests


*Recoding - for individually reported coefficients can use z-transformed variables since significance (even though they change
*sign in above for some) is unaffected by this transformation.  This allows me to consistently treat all the coefficients reported
*in a column as one estimation procedure, linking the suest calculations to the individual coefficient calculations

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
	tempname V B
	quietly suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14, cluster(unique_05) 
	mata `V' = st_matrix("e(V)"); `B' = st_matrix("e(b)")
	mata `V' = Sa*`V'*Sa'; `B' = Sa*`B''; `B' = `B', sqrt(diagonal(`V')); st_matrix("coef",`B'); `B'
end

drop if T == .

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

svmat double Y
save DatMSV3, replace



