
********************************************************************************	
********************************************************************************
*********************************PODES 2003 CLEAN*******************************
********************************************************************************
********************************************************************************	
 
use "$podes/podes2000_rand.dta", clear
	
********************************************************************************	
********************************************************************************
*****************************HEALTH FACILITIES**********************************
********************************************************************************
********************************************************************************


	replace b4br2b="." if b9ar1b1=="!"
	replace b4br2a="." if b9ar1b1=="!"

	replace b9br9="." if b9br9=="#"

 
  
rename *,upper 


	sum B4AR2A


 
gen suicideyes = B12R1H2=="1"

gen suicideincrease = B12R1H3=="3"
gen suicidenochange = B12R1H3=="3"
gen suicidedecrease = B12R1H3=="3"

foreach var of varlist suicid* {
tab `var'
}


	egen kabuid = concat(PROP KAB)
	egen kecaid = concat(PROP KAB KEC)
	egen villid = concat(PROP KAB KEC DESA)
  
 destring *, replace
 
  
	gen n_hospital = B8R1A2>=1
	label var n_hospital "Number of Hospitals"

	gen n_maternhosp = B8R1B2>=1
	label var n_maternhosp "Number of Materninty Hospitals"

 
	
	gen n_villmaternclinic = (B8R1C2>=1 | B8R1K2>=1)
	label var n_villmaternclinic "Number of Village Maternity Clinics"

	
	gen n_policlinic = B8R1D2>=1
	label var n_policlinic "Number of Policlinics"

	gen n_healthclinic = B8R1E2>=1
	label var n_healthclinic "Number of Health Clinic"

	gen n_supphealthclinic = B8R1F2>=1
	label var n_supphealthclinic "Number of Supporting Health Clinic"


	gen n_medicaltreatmentcenter = B8R1G2>=1
	label var n_medicaltreatmentcenter "Number of Medical Treatment Centers"
	
	
	gen n_privpractice = B8R1H2>=1
	label var n_privpractice "Number of Private Practices"

	gen n_midwife =  B8R1I2>=1
	label var n_midwife "Number of Midwives"

	gen n_healthpost = B8R1J2>=1
	label var n_healthpost "Number of Health Posts"

	gen n_pharm = B8R1L2>=1
	label var n_pharm "Number of Pharmacies"

	gen n_villmedic = B8R1M2>=1
	label var n_villmedic "Number of Village Medication"

	gen n_traddrugstore = B8R1N2>=1
	label var n_traddrugstore "Number of Tratidional Drug Stores"

	egen n_healthfacilities = rowtotal (n_hospital n_maternhosp n_policlinic n_healthclinic n_supphealthclinic n_privpractice n_midwife n_healthpost n_villmaternclinic n_pharm n_villmedic n_traddrugstore)
	label var n_healthfacilities "Number of Health Facilities"

	
	
********************************************************************************	
**********************MORE PUBLIC GOODS*****************************************	
********************************************************************************	
 		  
		  
 	
 	
	gen asphaltroad = B9AR1B1=="1"
	label var asphaltroad "Road: Asphalt"
	
	gen gravelroad = B9AR1B1=="2"
	label var gravelroad "Road: Gravel"
	
	gen soillroad = B9AR1B1=="3"
	label var soillroad "Road: Soil"
	
	gen otherroad = B9AR1B1=="4"
	label var otherroad "Road: Other"
		
	gen n_fixedlinephone = B9BR1	
	label var n_fixedlinephone "Fixed Line Phone: Number of Families"

	gen fixedlinephone =n_fixedlinephone>=1
	label var fixedlinephone "Fixed Line Phone: yes"
	
	
	gen publicphone = B9BR9==3
	label var publicphone "Public Phone: yes"
	
	
 
********************************************************************************	
********************************************************************************	
*********************************Public Goods***********************************
********************************************************************************	
********************************************************************************
	
	
	gen n_fam_ele = B4BR1A  + B4BR1B
	label var n_fam_ele "Number of Families with Electricity"
	
 	
	gen lighting = B4BR2A=="1"
	label var lighting "Lighting in Village"
	
 	
	gen gov_light = B4BR2B==1
	label var gov_light "Lighting in Village: Government"	
	
	gen nongov_light = B4BR2B==2
	label var nongov_light "Lighting in Village: Non-Government"	
	
	gen nonelec_light = B4BR2B==3		
 	label var nonelec_light "Lighting in Village: Non-electric"		
	 

********************************************************************************	
********************************************************************************	
**********General Information***************************************************
********************************************************************************	
********************************************************************************
	 



	drop _merge
	gen rural = B3R2==2
	label var rural "Rural Village"

	egen pop_size = rowtotal(B4AR2A)
	label var pop_size "Population Size"
	gen n_families = B4AR2B
	label var n_families "Number of Families"


	gen perc_ele = n_fam_ele/n_families
	label var perc_ele "Percentage of Families with Electricity"	
	

	gen perc_farmers = B4AR2C/B4AR2B
	label var perc_farmers "Percentage of Farmers"





	

********************************************************************************	
********************************************************************************	
**********************NATURAL DISASTERS*****************************************
********************************************************************************
********************************************************************************

 
	
	gen earthquake = B4BR15B1==1
	label var earthquake "Earthquake: yes" 
 
	gen expl = B4BR15B2==3
	label var expl "Mount Explision: yes"
 
	gen drought = B4BR15B3==5
	label var drought "Drought: yes"

	gen fire = B4BR15B4==7
	label var fire "Fire: yes"

	gen landslide = B4BR15B7==5
	label var landslide "Landslide: yes"

	gen flood = B4BR15B5 ==9
	label var flood "Flood: yes"

	gen smoke = B4BR15B6=="3"
	label var smoke "Smoke: yes"

	gen coast_abr = B4BR15B8==7
	label var coast_abr "Coast Abrasion: yes"

	gen tsunami = B4BR15B9==1
	label var tsunami "Tsunami: yes"
	
	gen other = B4BR1510==3
	label var other "Other disaster: yes"



********************************************************************************	
********************************************************************************	
*********************************Financial Institutions*************************
********************************************************************************	
********************************************************************************
	 
	
	  
	 gen public_bank = B11BR1 == 1
	 gen rural_bank = B11BR2 == 3
 	 gen villcoopunit = B11BR3A== "1"
	 gen lendingsavingcoop = B11BR3C== "5"

	 
	

********************************************************************************	
********************************************************************************	
*********************************Social Organisations***************************
********************************************************************************	
********************************************************************************
	 
	gen org_scouts = B6R2A1K2==1
	lab var org_scouts "Organisation: Scouts"

	gen org_orph = B6R2A2K2==1
	lab var org_scouts "Organisation: Orphanage"

	gen org_eld = B6R2A3K2==1
	lab var org_eld "Organisation: Home for Elderly"

	gen org_hand = B6R2A4K2==1
	lab var org_eld "Organisation: Handicap Rehabilitation"

	gen org_rel = B6R2A5K2==1
	lab var org_eld "Organisation: Religion"

	gen org_youth = B6R2A6K2==1
	lab var org_eld "Organisation: Youth Club"

	gen org_PKK = B6R2A7K2==1
	lab var org_eld "Organisation: PKK"


	egen SOC = rowtotal(B6R2A1K2 B6R2A2K2 B6R2A3K2 B6R2A4K2 B6R2A5K2 B6R2A6K2 B6R2A7K2)
	label var SOC "Social Organisations"
 
	gen social = B6R2B1K2==1
	lab var social "Social Activities"

	gen gotong = B6R2B2K2==1
	lab var social "Mutual Assitance"
 
	gen sharing = B6R2B3K2==1
	lab var social "Sharing Norms"
 

********************************************************************************	
********************************************************************************
****************************SCHOOLING FACILITIES********************************
********************************************************************************
********************************************************************************


	gen kindergar_s =  B5R1A2
	label var kindergar_s "Number of State Kindergartens"

	gen kindergar_p =  B5R1A3
	label var kindergar_p "Number of Private Kindergartens"

	gen kindergar = kindergar_s + kindergar_p
	label var kindergar "Number of Kindergartens"



	gen SD_s = B5R1B2
	label var SD_s "Number of State Primary Schools"

	gen SD_p = B5R1B3
	label var SD_p "Number of Private Primary Schools"

	gen SD = SD_s + SD_p
	label var SD "Number of Primary Schools"


	gen SLTP_s = B5R1C2
	label var SLTP_s "Number of State Junior High Schools"

	gen SLTP_p = B5R1C3
	label var SLTP_p "Number of Private Junior High Schools"

	gen SLTP = SLTP_s + SLTP_p
	label var SLTP "Number of Junior High Schools"


	gen SMK_s = B5R1D2
	label var SMK_s "Number of State Vocational Schools"

	gen SMK_p = B5R1D3
	label var SMK_p "Number of Private Vocational Schools"

	gen SMK = SMK_s + SMK_p
	label var SMK "Number of Vocational Schools"


	gen univ_s = B5R1E2
	label var univ_s "Number of State Universities"

	gen univ_p = B5R1E3
	label var univ_p "Number of Private Universities"

	gen univ = univ_s + univ_p
	label var univ "Number of Universities"

	gen school_dis_s = B5R1F2
	label var school_dis_s "Number of State Schools for disabled"

	gen school_dis_p = B5R1F3
	label var school_dis_p "Number of Private Schools for disabled"

	gen school_dis = B5R1F2 + B5R1F3
	label var school_dis "Number of Schools for disabled"

	gen islamic_p = B5R1G3 + B5R1H3
	label var islamic_p "Number of Islamic Schools"

	gen seminary_p = B5R1I3
	label var seminary_p "Number of Seminaries"

	egen n_educ_s = rowtotal(SD_s SLTP_s kindergar_s SMK_s univ_s school_dis_s)
	label var n_educ_s "Number of Educational Facilities from the State"

	egen n_educ_p = rowtotal(SD_p SLTP_p kindergar_p SMK_p univ_p school_dis_p islamic_p seminary_p)
	label var n_educ_p "Number of Private Educational Facilities"

	gen n_educ = n_educ_s + n_educ_p
	label var n_educ "Number of Educational Facilities"
 
	
		qbys kecaid: gen nvillages = _N
	
	foreach var of varlist *{
	rename `var' `var'2000
	}

save "$podes/podes2000", replace

use "$podes/2000/mfd_2000.dta", clear

	egen villid = concat(prop2000 kab2000 kec2000 desa2000)
	egen villid2000 = concat(prop2000 kab2000 kec2000 desa2000)

	gen vilname = nama2000

merge n:1 villid2000 using "$podes/podes2000"

	drop _merge

	

		
keep nvillages prop2000 kab2000 kec2000 desa2000 nama2000 suicideyes suicideincrease suicidenochange suicidedecrease kabuid2000 kecaid2000 n_hospital2000 n_maternhosp2000 n_villmaternclinic2000 n_policlinic2000 n_healthclinic2000 n_supphealthclinic2000 n_medicaltreatmentcenter2000 n_privpractice2000 n_midwife2000 n_healthpost2000 n_pharm2000 n_villmedic2000 n_traddrugstore2000 n_healthfacilities2000 asphaltroad2000 gravelroad2000 soillroad2000 otherroad2000 n_fixedlinephone2000 fixedlinephone2000 publicphone2000 n_fam_ele2000 lighting2000 gov_light2000 nongov_light2000 nonelec_light2000 rural2000 pop_size2000 n_families2000 perc_ele2000 perc_farmers2000 earthquake2000 expl2000 drought2000 fire2000 landslide2000 flood2000 smoke2000 coast_abr2000 tsunami2000 other2000 public_bank2000 rural_bank2000 villcoopunit2000 lendingsavingcoop2000 org_scouts2000 org_orph2000 org_eld2000 org_hand2000 org_rel2000 org_youth2000 org_PKK2000 SOC2000 social2000 gotong2000 sharing2000 kindergar_s2000 kindergar_p2000 kindergar2000 SD_s2000 SD_p2000 SD2000 SLTP_s2000 SLTP_p2000 SLTP2000 SMK_s2000 SMK_p2000 SMK2000 univ_s2000 univ_p2000 univ2000 school_dis_s2000 school_dis_p2000 school_dis2000 islamic_p2000 seminary_p2000 n_educ_s2000 n_educ_p2000 n_educ2000	
	
	save "$podes/podes2000", replace
 
