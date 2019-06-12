





use "$podes/podes_desa_2014_d3_new.dta", clear

destring R1202A, replace

destring R101, gen(provid)
ren R101N prov_name 

destring R102, gen(kabid)

ren R102N kab_name 
 
destring R103, gen(kecid)
ren R103N kec_name 
 
keep *_name *id  R1202A

gen id_using= kecid+1000*kabid+100000*provid
 
collapse (sum) R1202A, by(id_using kecid kabid kec_name provid kab_name prov_name prov_name)	
 
 
save "$temp/temp.dta", replace


********************************************************************************	
**********Add suicide data   ***************************************************
********************************************************************************	
********************************************************************************


	use "$podes/podes_desa_2014_d1_new.dta", clear
	
	egen villid = concat(R101 R102 R103 R104)	
	
	duplicates report villid
	
	save "$temp/podes1.dta", replace
	
	use "$podes/podes_desa_2014_d2_new.dta", clear
	
	egen villid = concat(R101 R102 R103 R104)	
	
	duplicates report villid
	
	save "$temp/podes2.dta", replace
		
	use "$podes/podes_desa_2014_d3_new.dta", clear

	egen villid = concat(R101 R102 R103 R104)	
	
	duplicates report villid

	save "$temp/podes3.dta", replace
	
	 merge 1:1 villid using "$temp/podes2.dta", force
	drop _merge
	 merge 1:1 villid using "$temp/podes1.dta", force
	drop _merge
	
 
	egen kabid2014 = concat(R101 R102)
	egen kecid2014 = concat(R101 R102 R103)
	
	tab R1307, m
	
	gen n_suicides = R1307
			
	tab n_suicides
	
	gen suicideyes = n_suicides>=1
	tab suicideyes
	
	 foreach var of varlist *suicide*{
qbys kabid2014: egen kab`var' = total(`var')
qbys kecid2014: egen kec`var' = total(`var')
}

 

rename *,lower 

 destring *, replace
 
 	gen theft= r1303a01k3 ==1
	gen robbery= r1303a02k3 ==1
	gen looting= r1303a03k3 ==1
	gen violence= r1303a04k3 ==1
	gen combustion= r1303a05k3 ==1
	gen rape= r1303a06k3 ==1
	gen drugabusetrafficking= r1303a07k3 ==1
	gen drugtraficking= r1303a08k3 ==1
	gen murder= r1303a09k3 ==1
	gen childsale= r1303a10k3 ==1
 
	egen n_crime=rowtotal(theft robbery looting violence combustion rape drugabuse drugtraficking murder childsale)
	gen anycrime= n_crime>=1
 
 
 
	gen gotong = r807a==1
 	label var gotong "Gotong Royong"		
 
 
********************************************************************************	
**********************HEALTH FACILITIES*****************************************	
********************************************************************************	
		 		 
	gen n_hospital = r704a_k3 
	replace n_hospital=0 if n_hospital==.
	
	label var n_hospital "Number of Hospitals"

	gen n_healthpost = r704c_k3==1
	replace n_healthpost=0 if n_healthpost==.
	label var n_healthpost "Number of Health Posts"

	gen n_healthclinic = r704d_k3==1
	replace n_healthclinic=0 if n_healthclinic==.
	label var n_healthclinic "Number of Health Clinic"
	

	gen n_supphealthclinic = r704e_k3==1
	replace n_supphealthclinic=0 if n_supphealthclinic==.
	label var n_supphealthclinic "Number of Supporting Health Clinic"	
	

	
	egen Health = rowtotal(n_hospital n_healthclinic n_supphealthclinic)
	


********************************************************************************	
**********************SCHOOLING FACILITIES**************************************
********************************************************************************	
    
	
	
	gen kindergar_s =  r701a_k2
	label var kindergar_s "Number of State Kindergartens"

	gen kindergar_p =  r701a_k3
	label var kindergar_p "Number of Private Kindergartens"

	gen kindergar = kindergar_s + kindergar_p
	label var kindergar "Number of Kindergartens"

	gen SD_s = r701b_k2
	label var SD_s "Number of State Primary Schools"

	gen SD_p = r701b_k3
	label var SD_p "Number of Private Primary Schools"

	gen SD = SD_s + SD_p
	label var SD "Number of Primary Schools"

	gen SLTP_s = r701c_k2
	label var SLTP_s "Number of State Junior High Schools"

	gen SLTP_p = r701c_k3
	label var SLTP_p "Number of Private Junior High Schools"

	gen SLTP = SLTP_s + SLTP_p
	label var SLTP "Number of Junior High Schools"

	gen SMU_s = r701d_k2
	label var SMU_s "Number of State Senior High Schools"

	gen SMU_p = r701d_k3
	label var SMU_p "Number of Private Senior High Schools"

	gen SMU = SMU_s + SMU_p
	label var SMU "Number of Senior High Schools"

	gen SMK_s = r701e_k2
	label var SMK_s "Number of State Vocational Schools"

	gen SMK_p = r701e_k3
	label var SMK_p "Number of Private Vocational Schools"

	gen SMK = SMK_s + SMK_p
	label var SMK "Number of Vocational Schools"

	gen univ_s = r701f_k2
	label var univ_s "Number of State Universities"

	gen univ_p = r701f_k3
	label var univ_p "Number of Private Universities"

	gen univ = univ_s + univ_p
	label var univ "Number of Universities"


	gen school_dis_s = r701g_k2
	label var school_dis_s "Number of State Schools for disabled"

	gen school_dis_p = r701g_k3
	label var school_dis_p "Number of Private Schools for disabled"

	gen school_dis = school_dis_s + school_dis_p
	label var school_dis "Number of Schools for disabled"

	gen islamic_p = r701h_k3 + r701i_k3 
	lab var islamic_p "Number of Islamic Schools"

	gen seminary_p = r701j_k3
	label var seminary_p "Number of Seminaries"
	
	

	egen n_educ_s = rowtotal(SD_s SLTP_s  kindergar_s SMK_s SMU_s univ_s school_dis_s)
	label var n_educ_s "Number of Educational Facilities from the State"

	egen n_educ_p = rowtotal(SD_p SLTP_p kindergar_p SMK_p SMU_p univ_p school_dis_p islamic_p seminary_p)
	label var n_educ_p "Number of Private Educational Facilities"

	gen n_educ = n_educ_s + n_educ_p
	label var n_educ "Number of Educational Facilities"
	
 
 
  keep suicide* *id* anycrime gotong n_crime theft robbery looting violence combustion rape drugabuse drugtraficking murder childsale n_hospital n_healthpost n_healthclinic n_supphealthclinic Health kindergar_s kindergar_p SD_s SD_p SD SLTP_s SLTP_p SLTP SMU_s SMU_p SMU SMK_s SMK_p SMK univ_s univ_p univ school_dis_s school_dis_p school_dis islamic_p seminary_p n_educ

 
	foreach var of varlist *{
	rename `var' `var'2014
	}


 
 gen nvillages2014=1
 tab nvillages2014
 
collapse (sum) nvillages2014 gotong n_suicides suicideyes  anycrime n_crime theft robbery looting violence combustion rape drugabuse drugtraficking murder childsale n_hospital n_healthpost n_healthclinic n_supphealthclinic Health kindergar_s kindergar_p SD_s SD_p SLTP_s SLTP_p SMU_s SMU_p SMK_s SMK_p univ_s univ_p school_dis_s school_dis_p islamic_p seminary_p n_educ , by(kecid2014)	
	
	tab n_suicides, m
	tab nvillages2014, m
	
	duplicates drop kecid2014 , force
	gen id_using=kecid2014
	
	
	merge 1:n id_using using "$temp/temp.dta"
 drop if _merge!=3
 drop _merge
 
 	gen id_using2=_n
	
	
 save "$temp/temp.dta", replace

 
 
use "$data/administrativepkh.dta", clear //Load treatment assignments


ren namakabupaten kab_name
ren namakecamatan kec_name

gen id_master= kecid+1000*kabid+100000*provid

drop if id_master==. // Observations without kecids

replace kab_name = subinstr(kab_name, "KOTA", "", .)



reclink kec_name kecid kab_name provid kabid using "$temp/temp.dta" , idmaster(id_master) idusing(id_using2) ///
required(provid kabid)  gen(match_score) wmatch(5 1 1 1 1) _merge(_merge) // Fuzzy matching

sort _merge match_score

drop if _merge==1

drop _merge


drop  Ukecid Ukabid Uprovid Ukab_name Ukec_name 


save "$data/crosswalk_PKH_PODES2014.dta", replace 
















