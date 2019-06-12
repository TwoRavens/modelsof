
********************************************************************************	
********************************************************************************
*********************************PODES 2003 CLEAN*******************************
********************************************************************************
********************************************************************************	

use "$podes/pds03_a.dta", clear

********************************************************************************	
********************************************************************************	
**********General Information***************************************************
********************************************************************************	
********************************************************************************
	 
sum b4r402a 
sum b4r402b

egen kabuid = concat(prop kab)
egen kecaid =  concat(prop kab kec)
egen villid = concat(prop kab kec desa)

***
destring *, replace
gen rural = b3r303==2
label var rural "Rural Village"

egen pop_size = rowtotal(b4r402a b4r402b)
label var pop_size "Population Size"
gen n_families = b4r402c
label var n_families "Number of Families"

gen perc_farmers = b4r402d
label var perc_farmers "Percentage of Farmers"

gen n_unemployed = b4r406
label var n_unemployed "Number of Unemployed"

gen perc_unempl = n_unemployed/pop_size
label var perc_unempl "Percentage of Unemployed"


********************************************************************************	
********************************************************************************	
*********************************Public Goods***********************************
********************************************************************************	
********************************************************************************
	
	
	gen n_fam_ele = b5r501b1 + b5r501b2
	label var n_fam_ele "Number of Families with Electricity"
	
	gen perc_ele = n_fam_ele/n_families
	label var perc_ele "Percentage of Families with Electricity"	
	
	gen lighting = b5r502a==1
	label var lighting "Lighting in Village"
	
	gen gov_light = b5r502b==1
	label var gov_light "Lighting in Village: Government"	
	
	gen nongov_light = b5r502b==2
	label var nongov_light "Lighting in Village: Non-Government"	
	
	gen nonelec_light = b5r502b==3		
 	label var nonelec_light "Lighting in Village: Non-electric"		
	
	gen river = b5r508a==1
 	label var river "River"		
	
	gen irrigation = b5r508b4==1	
 	label var irrigation "Irrigation"		
			    			
	gen pollution = (b5r513a2==1 | b5r513b2==1 | b5r513c2==1 | b5r513d2==1	| b5r513e2==1)	
 	label var pollution "Pollution"			
	
	
********************************************************************************	
********************************************************************************	
**********************NATURAL DISASTERS*****************************************
********************************************************************************
********************************************************************************

 
	gen earthquake = b5r514a2==1
	label var earthquake "Earthquake: yes"

	gen n_earthquakes = b5r514a3
	label var n_earthquakes "Number of Earthquakes"

	gen landslide = b5r514b2==1
	label var landslide "Landslide: yes"

	gen n_landslides = b5r514b3
	label var n_landslides "Number of Landslides"

	gen flood = b5r514c2 ==1
	label var flood "Flood: yes"

	gen n_flood = b5r514c3
	label var n_flood "Number of Floods"

	gen prone_earthquake = b5r515a==1
	label var prone_earthquake "Proneness to Earthquake"

	gen prone_landslide = b5r515b1==1
	label var prone_earthquake "Proneness to Landslide"

	gen n_prone_landslide = b5r515b2
	label var prone_earthquake "Number of Families endangered by Landslide"

	gen perc_pronelandslide =n_prone_landslide/n_families
	label var perc_pronelandslide "Percentage of Families endangered by Landslide"

	gen prone_flood = b5r515c1==1
	label var prone_flood "Proneness to Flood"

	gen n_prone_flood = b5r515c2
	label var prone_flood "Number of Families endangered by Flood"

	gen perc_proneflood = n_prone_flood/n_families
	label var perc_proneflood "Percentage of Families endangered by Flood"
 
 
 

 
********************************************************************************	
********************************************************************************
****************************SCHOOLING FACILITIES********************************
********************************************************************************
********************************************************************************

 
	gen kindergar_s =  b6r601a2
	label var kindergar_s "Number of State Kindergartens"

	gen kindergar_p =  b6r601a3
	label var kindergar_p "Number of Private Kindergartens"

	gen kindergar = kindergar_s + kindergar_p
	label var kindergar "Number of Kindergartens"

	gen SD_s = b6r601b2
	label var SD_s "Number of State Primary Schools"

	gen SD_p = b6r601b3
	label var SD_p "Number of Private Primary Schools"

	gen SD = SD_s + SD_p
	label var SD "Number of Primary Schools"

	gen SLTP_s = b6r601c2
	label var SLTP_s "Number of State Junior High Schools"

	gen SLTP_p = b6r601c3
	label var SLTP_p "Number of Private Junior High Schools"

	gen SLTP = SLTP_s + SLTP_p
	label var SLTP "Number of Junior High Schools"

	gen SMU_s = b6r601d2
	label var SMU_s "Number of State Senior High Schools"

	gen SMU_p = b6r601d3
	label var SMU_p "Number of Private Senior High Schools"

	gen SMU = SMU_s + SMU_p
	label var SMU "Number of Senior High Schools"

	gen SMK_s = b6r601e2
	label var SMK_s "Number of State Vocational Schools"

	gen SMK_p = b6r601e3
	label var SMK_p "Number of Private Vocational Schools"

	gen SMK = SMK_s + SMK_p
	label var SMK "Number of Vocational Schools"

	gen univ_s = b6r601f2
	label var univ_s "Number of State Universities"

	gen univ_p = b6r601f3
	label var univ_p "Number of Private Universities"

	gen univ = b6r601f2 + b6r601f3
	label var univ "Number of Universities"

	gen school_dis_s = b6r601g2
	label var school_dis_s "Number of State Schools for disabled"

	gen school_dis_p = b6r601g3
	label var school_dis_p "Number of Private Schools for disabled"

	gen school_dis = b6r601g2 + b6r601g3
	label var school_dis "Number of Schools for disabled"

	gen islamic_p = b6r601h3
	label var islamic_p "Number of Islamic Schools"

	gen seminary_p = b6r601i3
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

	
	gen n_hospital = b7r701a2>=1
	label var n_hospital "Number of Hospitals"

	gen n_maternhosp = b7r701b2>=1
	label var n_maternhosp "Number of Materninty Hospitals"

	gen n_policlinic = b7r701c2>=1
	label var n_policlinic "Number of Policlinics"

	gen n_healthclinic = b7r701d2>=1
	label var n_healthclinic "Number of Health Clinic"

	gen n_supphealthclinic = b7r701e2>=1
	label var n_supphealthclinic "Number of Supporting Health Clinic"

	gen n_privpractice = b7r701f2>=1
	label var n_privpractice "Number of Private Practices"

	gen n_midwife =  b7r701g2>=1
	label var n_midwife "Number of Midwives"

	gen n_healthpost = b7r701h2>=1
	label var n_healthpost "Number of Health Posts"

	gen n_villmaternclinic = b7r701i2>=1
	label var n_villmaternclinic "Number of Village Maternity Clinics"

	gen n_pharm = b7r701j2>=1
	label var n_pharm "Number of Pharmacies"

	gen n_villmedic = b7r701k2>=1
	label var n_villmedic "Number of Village Medication"

	gen n_traddrugstore = b7r701l2>=1
	label var n_traddrugstore "Number of Tratidional Drug Stores"

	egen n_healthfacilities = rowtotal (n_hospital n_maternhosp n_policlinic n_healthclinic n_supphealthclinic n_privpractice n_midwife n_healthpost n_villmaternclinic n_pharm n_villmedic n_traddrugstore)
	label var n_healthfacilities "Number of Health Facilities"

	gen n_fam_healthcards = b7r705
	label var n_fam_healthcards "Number of Families with Healthcards"

save "$podes/pds2003_1", replace



use "$podes/2003/pds03_b.dta", clear


	egen kabuid = concat(prop kab)
	egen kecaid =  concat(prop kab kec)
	egen villid = concat(prop kab kec desa)

	destring *, replace

	gen org_scouts = b8r802a1==1
	lab var org_scouts "Organisation: Scouts"

	gen org_youth = b8r802a2==1
	lab var org_youth "Organisation: Youth Club"

	gen org_PKK = b8r802a3==1
	lab var org_PKK "Organisation: PKK"

	gen org_rel = b8r802a4==1
	lab var org_rel "Organisation: Religion"

	gen org_orph = b8r802a5==1
	lab var org_orph "Organisation: Orphanage"

	gen org_eld = b8r802a6==1
	lab var org_eld "Organisation: Home for Elderly"

	gen org_hand = b8r802a7==1
	lab var org_hand "Organisation: Handicap Rehabilitation"

	egen n_socorg = rowtotal(b8r805a2 b8r805b2 b8r805c2 b8r805d2 b8r805e2)
	label var n_socorg "Number of Social Organisations"

	egen n_actinst = rowtotal(b8r805a3 b8r805b3 b8r805c3 b8r805d3 b8r805e3)
	label var n_actinst "Number of Active Social Organisations"	

	gen social = b8r802b1==1
	lab var social "Social Activities"

	gen gotong = b8r802b2==1
	lab var gotong "Mutual Assitance"

	gen sharing = b8r802b3==1
	lab var sharing "Sharing Norms"
 
	gen com_org_env_e = b8r805a2==1
	label var com_org_env_e "Existing Environmental Organisation"
	gen com_org_env_a = b8r805a3==1
	label var com_org_env_a "Active Environmental Organisation"

	gen com_org_wom_e = b8r805b2==1
	label var com_org_wom_e "Existing Women Organisation"

	gen com_org_wom_a = b8r805b3==1
	label var com_org_wom_a "Active Women Organisation"

	gen com_org_chil_e = b8r805c2==1
	label var com_org_chil_e "Existing Children Organisation"

	gen com_org_chil_a = b8r805c3==1
	label var com_org_chil_a "Active Children Organisation"

	gen com_org_lawhumanrights_e = b8r805d2==1
	label var com_org_lawhumanrights_e "Active Law and Human Rights Organisations"

	gen com_org_lawhumanrights_a = b8r805d3==1
	label var com_org_lawhumanrights_a "Active Law and Human Rights Organisations"

	gen com_org_oth_e = b8r805e2==1
	label var com_org_oth_e "Existing Other Organisations"

	gen com_org_oth_a = b8r805e3==1
	label var com_org_oth_a "Active Other Organisations"

	gen eth_het = b8r809==1
	label var eth_het "Ethnically Heterogeneous"

	gen TVRI = b11r1108a==1
	label var TVRI "State Television"

	gen pr_TPI = b11r1108b1==1
	label var pr_TPI "Private Television: TVRI"

	gen pr_RCTI = b11r1108b2==1
	label var pr_RCTI "Private Television: RCTI"

	gen pr_SCTV = b11r1108b3==1
	label var pr_SCTV "Private Television: SCTV"

	gen pr_INDIO = b11r1108b4==1
	label var pr_INDIO "Private Television: INDIOSAR"

	gen foreigntv = b11r1108c==1
	label var foreigntv "Forgein TV"

	gen private_tv = (pr_TPI==1 | pr_RCTI==1 | pr_SCTV==1 | pr_INDIO==1)
	label var private_tv "Private Television"

	
********************************************************************************	
******************Some OTHER PUBLIC GOODS***************************************	
********************************************************************************	


********************************************************************************	
**********************MORE PUBLIC GOODS*****************************************	
********************************************************************************	
 		  
	replace b11r1101=. if (b11r1101==9998 | b11r1101==9997)
	
	gen asphaltroad = b10r1001b1==1
	label var asphaltroad "Road: Asphalt"
	
	gen gravelroad = b10r1001b1==2
	label var gravelroad "Road: Gravel"
	
	gen soillroad = b10r1001b1==3
	label var soillroad "Road: Soil"
	
	gen otherroad = b10r1001b1==4
	label var otherroad "Road: Other"
		
	gen n_fixedlinephone = b11r1101	
	label var n_fixedlinephone "Fixed Line Phone: Number of Families"

	gen fixedlinephone =n_fixedlinephone>=1
	label var fixedlinephone "Fixed Line Phone: yes"
	
	gen publicphone = b11r1102==1
	label var publicphone "Public Phone: yes"
	
	
 

	 
	
	
	duplicates report villid

merge 1:n villid using "$podes/pds2003_1"

	drop _merge


	
save "$podes/pds2003_2", replace



use "$podes/2003/pds03_c.dta", clear


	egen kabuid = concat(prop kab)
	egen kecaid =  concat(prop kab kec)
	egen villid = concat(prop kab kec desa)

********************************************************************************	
********************************************************************************	
*********************************Financial Institutions*************************
********************************************************************************	
********************************************************************************
	 
	 
	 	destring *, replace

 
 	  
	 gen public_bank = b15r1513 >= 1
	 gen n_public_bank = b15r1513	 
	 gen rural_bank = b15r1514 >= 1
	 gen n_rural_bank = b15r1514
	 gen credit = b15r1515a==1
	 gen foodcredit = b15r1515b1==1
	 gen busncredit = b15r1515b2==1
	 gen homecredit = b15r1515b3==1
	 gen sugarcanecredit = b15r1515b4==1
	 gen othercredit = b15r1515b5==1	 
 	 gen villcoopunit = b15r1516a>= 1
	 gen n_villcoopunit = b15r1516a
	 

	 	duplicates report villid

merge 1:n villid using "$podes/pds2003_2"

	drop _merge


save "$podes/podes2003", replace


use "$podes/2003/pds03_d.dta", clear


tab b17r1706

gen suicideyes = b17r1706=="1"
tab suicideyes

gen suicidechild = b17r1706a2 + b17r1706a3
gen suicideteenagers = b17r1706b2 + b17r1706b3
gen suicideadults = b17r1706c2 + b17r1706c3


gen suicidechild_m = b17r1706a2  
gen suicideteenagers_m = b17r1706b2  
gen suicideadults_m = b17r1706c2  


gen suicidechild_f =  b17r1706a3
gen suicideteenagers_f =  b17r1706b3
gen suicideadults_f =  b17r1706c3


destring b17r1706a2 b17r1706a3 b17r1706b2 b17r1706b3 b17r1706c2 b17r1706c3, replace
 
 foreach var of varlist suicide*{
 tab `var'
 }

 	 


	egen kabuid = concat(prop kab)
	egen kecaid =  concat(prop kab kec)
	egen villid = concat(prop kab kec desa)
		destring villid, replace

	
merge 1:n villid using "$podes/podes2003", force
	
	
			qbys kecaid: gen nvillages = _N

	
	foreach var of varlist *{
	rename `var' `var'2003
	}

save "$podes/podes2003", replace
	

use "$podes/2003/mfd03.dta", clear

	egen villid =  concat(prop2002 kab2002 kec2002 desa2002)
	egen villid2002 = concat(prop2002 kab2002 kec2002 desa2002)
	egen villid2003 = concat(prop kab kec desa)
	destring villid2003 villid2002 villid, replace
	gen vilname = nama
	gen vilname2003 = nama

merge n:1 villid2003 using "$podes/podes2003"

	drop _merge


	
save "$podes/podes2003", replace


	
 
	

