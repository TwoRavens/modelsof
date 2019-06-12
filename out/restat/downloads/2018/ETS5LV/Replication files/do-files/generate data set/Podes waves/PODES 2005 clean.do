
********************************************************************************	
********************************************************************************
*********************************PODES 2005 CLEAN*******************************
********************************************************************************
********************************************************************************	


use "$podes/podes05a.dta", clear



 
********************************************************************************	
********************************************************************************	
**********General Information***************************************************
********************************************************************************	
********************************************************************************
	 
	 
	 
	rename r101b provid
	destring r102b r103b r104b, replace
	gen str2 dist = string(r102b,"%02.0f")
	gen str3 subd = string(r103b,"%03.0f")
	gen str3 des = string(r104b,"%03.0f")

	egen kabuid = concat(provid dist)
	egen kecaid = concat(provid dist subd)
	egen villid = concat(provid dist subd des)

	gen rural = r301==1
	label var rural "Rural Village"

	egen pop_size = rowtotal(r401a r401b)
	label var pop_size "Population Size"

	gen n_families = r401c
	label var n_families "Number of Families"

	gen perc_farmers = r401d
	label var perc_farmers "Percentage of Farmers"

	gen n_poorfamilies = r401e
	label var n_poorfamilies "Number of Poor Families"


********************************************************************************	
********************************************************************************	
*********************************Public Goods***********************************
********************************************************************************	
********************************************************************************
	
	
		
	gen n_fam_ele = r501b1 + r501b2
	label var n_fam_ele "Number of Families with Electricity"
	
	gen perc_ele = n_fam_ele/n_families
	label var perc_ele "Percentage of Families with Electricity"	
	
	gen lighting = r502a==1
	label var lighting "Lighting in Village"
	
	gen gov_light = r502b==1
	label var gov_light "Lighting in Village: Government"	
	
	gen nongov_light = r502b==2
	label var nongov_light "Lighting in Village: Non-Government"	
	
	gen nonelec_light = r502b==3		
 	label var nonelec_light "Lighting in Village: Non-electric"		
	
	gen river = r506a==1
 	label var river "River"		
	
	gen irrigation = r506b4==7	
 	label var irrigation "Irrigation"		
		
	gen pollution = r510ak2==1 | r510bk2==1 | r510ck2==1 | r510dk2==1	
 	label var pollution "Pollution"			
	
	
********************************************************************************	
********************************************************************************	
**********************NATURAL DISASTERS*****************************************
********************************************************************************
********************************************************************************

	gen prone_disasters = r512==1
	label var prone_disasters "Proneness to Natural Disasters"

	gen prone_earthquake = r512dk2==1
	label var prone_earthquake "Proneness to Earthquake"

	gen n_prone_earthquake = r512dk3
	label var prone_earthquake "Number of Families endangered by Earthquake"

	gen perc_prone_earthquake = n_prone_earthquake/n_families
	label var prone_earthquake "Number of Families endangered by Earthquake"

	gen prone_landslide = r512ak2==1
	label var prone_earthquake "Proneness to Landslide"

	gen n_prone_landslide = r512ak3
	label var prone_earthquake "Number of Families endangered by Landslide"

	gen perc_pronelandslide =n_prone_landslide/n_families
	label var perc_pronelandslide "Percentage of Families endangered by Landslide"

	gen prone_flood = (r512bk2==1 | r512ck2==1)
	label var prone_flood "Proneness to Flood"

	egen n_prone_flood = rowtotal(r512bk3 r512ck3)
	label var prone_flood "Number of Families endangered by Flood"

	gen perc_proneflood = n_prone_flood/n_families
	label var perc_proneflood "Percentage of Families endangered by Flood"

	gen prone_coastalabrasion = r512ek2==1
	label var prone_coastalabrasion "Proneness to Coastal Abrasion"

	gen n_prone_coastalabrasion = r512ek3
	label var n_prone_coastalabrasion "Number of Families endangered by Coastal Abrasion"

	gen perc_prone_coastalabrasion = n_prone_flood/n_families
	label var perc_prone_coastalabrasion "Percentage of Families endangered by Coastal Abrasion"

	gen earthquake = (r513d==7 | r513e==1)
	label var earthquake "Earthquake: yes"

	gen landslide = r513a==1
	label var landslide "Landslide: yes"

	gen flood = (r513b ==3 | r513c==5)
	label var flood "Flood: yes"

	gen fire = (r513f==3 | r513g==5)
	label var fire "Fire: yes"

	gen other_dis = r513h==7
	label var fire "Other Disaster: yes"


********************************************************************************	
********************************************************************************
****************************SCHOOLING FACILITIES********************************
********************************************************************************
********************************************************************************



	gen kindergar_s =  r601ak2
	label var kindergar_s "Number of State Kindergartens"

	gen kindergar_p =  r601ak3
	label var kindergar_p "Number of Private Kindergartens"

	gen kindergar = kindergar_s + kindergar_p
	label var kindergar "Number of Kindergartens"

	gen SD_s = r601bk2
	label var SD_s "Number of State Primary Schools"

	gen SD_p = r601bk3
	label var SD_p "Number of Private Primary Schools"

	gen SD = SD_s + SD_p
	label var SD "Number of Primary Schools"

	gen SLTP_s = r601ck2
	label var SLTP_s "Number of State Junior High Schools"

	gen SLTP_p = r601ck3
	label var SLTP_p "Number of Private Junior High Schools"

	gen SLTP = SLTP_s + SLTP_p
	label var SLTP "Number of Junior High Schools"

	gen SMU_s = r601dk2
	label var SMU_s "Number of State Senior High Schools"

	gen SMU_p = r601dk3
	label var SMU_p "Number of Private Senior High Schools"

	gen SMU = SMU_s + SMU_p
	label var SMU "Number of Senior High Schools"

	gen SMK_s = r601ek2
	label var SMK_s "Number of State Vocational Schools"

	gen SMK_p = r601ek3
	label var SMK_p "Number of Private Vocational Schools"

	gen SMK = SMK_s + SMK_p
	label var SMK "Number of Vocational Schools"

	gen univ_s = r601fk2
	label var univ_s "Number of State Universities"

	gen univ_p = r601fk3
	label var univ_p "Number of Private Universities"

	gen univ = r601fk2 + r601fk3
	label var univ "Number of Universities"

	gen school_dis_s = r601gk2
	label var school_dis_s "Number of State Schools for disabled"

	gen school_dis_p = r601gk3
	label var school_dis_p "Number of Private Schools for disabled"

	gen school_dis = r601gk2 + r601gk3
	label var school_dis "Number of Schools for disabled"

	gen islamic_p = r601hk3
	label var islamic_p "Number of Islamic Schools"

	gen seminary_p = r601ik3
	label var seminary_p "Number of Seminaries"

	egen n_educ_s = rowtotal(SD_s SLTP_s SMU_s kindergar_s SMK_s univ_s school_dis_s)
	label var n_educ_s "Number of Educational Facilities from the State"

	egen n_educ_p = rowtotal(SD_p SLTP_p SMU_p kindergar_p SMK_p univ_p school_dis_p islamic_p seminary_p)
	label var n_educ_p "Number of Private Educational Facilities"

	gen n_educ = n_educ_s + n_educ_p
	label var n_educ "Number of Educational Facilities"

	
********************************************************************************	
********************************************************************************
*****************************HEALTH FACILITIES**********************************
********************************************************************************
********************************************************************************
	          
gen n_hospital = r603ak2 
label var n_hospital "Number of Hospitals"

gen n_maternhosp = r603bk2 
label var n_maternhosp "Number of Materninty Hospitals"

gen n_policlinic = r603ck2 
label var n_policlinic "Number of Policlinics"

gen n_healthclinic = r603dk2 
label var n_healthclinic "Number of Health Clinic"

gen n_supphealthclinic = r603ek2 
label var n_supphealthclinic "Number of Supporting Health Clinic"

gen n_privpractice = r603fk2 
label var n_privpractice "Number of Private Practices"

gen n_midwife =  r603gk2 
label var n_midwife "Number of Midwives"

gen n_healthpost = r603hk2 
label var n_healthpost "Number of Health Posts"

gen n_villmaternclinic = r603ik2 
label var n_villmaternclinic "Number of Village Maternity Clinics"

gen n_pharm = r603jk2 
label var n_pharm "Number of Pharmacies"


egen n_healthfacilities = rowtotal (n_hospital n_maternhosp n_policlinic n_healthclinic n_supphealthclinic n_privpractice n_midwife n_healthpost n_villmaternclinic n_pharm)
label var n_healthfacilities "Number of Health Facilities"

	egen Health = rowtotal(n_hospital n_healthclinic n_supphealthclinic)


save "$podes/podes2005_01", replace
	
use "$podes/2005/podes05b.dta", clear

	destring *, replace
	rename r101b provid
	gen str2 dist = string(r102b,"%02.0f")
	gen str3 subd = string(r103b,"%03.0f")
	gen str3 des = string(r104b,"%03.0f")

	egen kabuid = concat(provid dist)
	egen kecaid = concat(provid dist subd)
	egen villid = concat(provid dist subd des)

	
	
********************************************************************************	
********************************************************************************
**********************************SOCIAL ORGANISATIONS**************************
********************************************************************************
********************************************************************************


	
	gen org_youth = r704a4k3==1
	lab var org_youth "Organisation: Youth Club"

	gen rel_org = r704b1k3==1
	lab var rel_org "Organisation: Religion"

	gen org_orph = r704a1k3==1
	lab var org_orph "Organisation: Orphanage"

	gen org_eld = r704a2k3==1
	lab var org_eld "Organisation: Home for Elderly"

	gen org_hand = r704a3k3==1
	lab var org_hand "Organisation: Handicap Rehabilitation"

	gen funeralservice = r704b2k3==1
	lab var funeralservice "Organisation: Funeral Service"

	gen NGO = r704b3k3==1
	lab var NGO "Organisation: NGO"

	
	egen n_socorg = rowtotal(r704a1k2 r704a2k2 r704a3k2 r704a4k2 r704a5k2 r704a6k2 r704b1k2 r704b2k2 r704b3k2)
	label var n_socorg "Number of Social Organisations"


	egen n_actinst = rowtotal(r704a1k3 r704a2k3 r704a3k3 r704a4k3 r704a5k3 r704a6k3 r704b1k3 r704b2k3 r704b3k3)
	label var n_actinst "Number of Active Social Organisations"	
	
	gen gotong = r707==1
	lab var gotong "Mutual Assitance"

	gen prostitution = r709 ==1
	lab var prostitution "Prostitution"

	gen eth_het = r710==1
	label var eth_het "Ethnically Heterogeneous"

	gen TVRI = r910a==1
	label var TVRI "State Television"


	egen n_privatetelevision = rowtotal(r910b*)
	label var n_privatetelevision "Number of Private Television Channels"

	gen foreigntv = r910c==1
	label var foreigntv "Forgein TV"

	gen private_tv = n_privatetelevision>=1
	label var private_tv "Private Television"

	
	
	 
********************************************************************************	
**********************MORE PUBLIC GOODS*****************************************	
********************************************************************************	
 		  
	replace r904=. if r904==9998
	
	gen asphaltroad = r901b1==1
	label var asphaltroad "Road: Asphalt"
	
	gen gravelroad = r901b1==2
	label var gravelroad "Road: Gravel"
	
	gen soillroad = r901b1==3
	label var soillroad "Road: Soil"
	
	gen otherroad = r901b1==4
	label var otherroad "Road: Other"
		
	gen n_fixedlinephone = r904	
	label var n_fixedlinephone "Fixed Line Phone: Number of Families"

	gen fixedlinephone =n_fixedlinephone>=1
	label var fixedlinephone "Fixed Line Phone: yes"
	
	gen publicphone = r905==1
	label var publicphone "Public Phone: yes"
	
save "$podes/podes2005_02", replace
	
	
********************************************************************************
*********************CRIME******************************************************	
********************************************************************************
	
	
use "$podes/2005/podes05c.dta", clear

	destring *, replace
	rename r101b provid
	gen str2 dist = string(r102b,"%02.0f")
	gen str3 subd = string(r103b,"%03.0f")
	gen str3 des = string(r104b,"%03.0f")

	egen kabuid = concat(provid dist)
	egen kecaid = concat(provid dist subd)
	egen villid = concat(provid dist subd des)

	
gen theft=r1204a1k2==1
gen robbery= r1204a2k2==1
gen looting=r1204a3k2==1
gen violence=r1204a4k2==1
gen combustion=r1204a5k2==1
gen rape=r1204a6k2==1
gen drugabuse=r1204a7k2==1
gen drugtraficking=r1204a8k2==1
gen murder=r1204a9k2==1
gen childsale=r1204a10k2==1
gen other=r1204a11k2==1

egen n_crime=rowtotal(theft robbery looting violence combustion rape drugabuse drugtraficking murder childsale other)

gen anycrime= n_crime>=1

tab r1205

gen suicideyes = r1205==1


	 foreach var of varlist suicide*{
qbys kabuid: egen kab`var' = mean(`var')
qbys kecaid: egen kec`var' = mean(`var')

}

tab kecsuicideyes
 

foreach var of varlist r1202a r1202b1 r1202b2 r1202b3{
tab `var'
destring `var', replace
}

gen massfight= r1202a==1

gen n_deathsmassfight=r1202b1
gen n_injuredmassfight = r1202b2
gen materialdamagemassfight = r1202b3


tab r1203a
gen fightcommunitygroups= r1203a==1
gen fightwithofficers= r1203a==2
gen fightstudents= r1203a==3
gen fightbetweenethnics = r1203a==4
gen fightother = r1203a==5

 
gen sec_post=r1206a==1
gen sec_groups= r1206b==3
gen sec_securitofficer= r1206c ==5
gen sec_screenguest = r1206d==7
gen sec_other = r1206e==1
 
 
gen security_post=r1207ak2==1
gen police_post=r1207bk2==1
gen distancepolice= r1207bk31

destring distancepolice, replace


gen n_securityofficers=r1208

 

	duplicates report villid
	duplicates drop villid, force

merge 1:n villid using "$podes/podes2005_01"

	drop _merge
	duplicates drop villid, force

merge 1:n villid using "$podes/podes2005_02"
	
	drop _merge
	
			qbys kecaid: gen nvillages = _N


	foreach var of varlist *{
	rename `var' `var'2005
	}
	
gen  kabuid  = kabuid2005	
gen kecaid = kecaid2005  	

save  "$podes/podes2005", replace

use "$podes/2003/mfd06.dta", clear


	gen vilname = nama
	gen vilname2005 = nama

	egen villid = concat(prop kabu keca desa)
	egen villid2005 = concat(prop kabu keca desa)
	egen villid2003 = concat(prop_old kabu_old keca_old desa_old)
	gen vilname2003 = nama_old


merge 1:n villid2005 using "$podes/podes2005"
	
	drop _merge

	
save  "$podes/podes2005", replace

