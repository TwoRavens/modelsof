
********************************************************************************
*********************************PODES 2011 CLEAN*******************************
********************************************************************************



use "$podes/podes2011-desakor.dta", clear
 

********************************************************************************	
********************************************************************************	
**********General Information***************************************************
********************************************************************************	
********************************************************************************
	 
 
	egen kabuid = concat(kode_pro kode_kab)
	egen kecaid = concat(kode_pro kode_kab kode_kec)
	egen villid = concat(kode_pro kode_kab kode_kec kode_des)

	destring *, replace

	gen rural = s_desa==1
	label var rural "Rural Village"

	egen pop_size = rowtotal(r401a r401b) 
	label var pop_size "Population Size"

	gen n_families = r401c
	label var n_families "Number of Families"

	gen perc_farmers = r401d
	label var perc_farmers "Percentage of Farmers"


	
	
********************************************************************************	
********************************************************************************	
**********Public Goods + Social Organisarions***********************************
********************************************************************************	
********************************************************************************

	
	gen n_fam_ele = r501a + r501b
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
		 
	
	gen river = r506ak2==1
 	label var river "River"		
	
	gen irrigation = r506ak3==1
 	label var irrigation "Irrigation"		
	
	gen pollution = r511ak2==1 | r511bk2==1 | r511ck2==1
 	label var pollution "Pollution"			
	
	gen fieldburning =r512a ==1
 	label var fieldburning "Field and Wood Burning"			
	
	gen community_aid = (r602b08k==1 | r602b10k==1)
 	label var community_aid "Community Aid"		
	
	gen safetyequip = r603a3==3
 	label var safetyequip "Safety Equipment"		
	
	gen gotong = r603a3==5
 	label var gotong "Gotong Royong"		
	
	gen safetycounseling = r603a4==7
	gen community_aid2 = (r603b8==1 | r603b10==1)
 	label var community_aid2 "Community Aid: 2"		
	
	
	gen prostitution = r1307 ==1
	label var prostitution "Prostitution"
	
	
	egen n_socorg = rowtotal(r804ak2  r804bk2  r804ck2 r804dk2 r804ek2 r804fk2  r804gk2)
	label var n_socorg "Number of Social Organisations"

	egen n_actinst = rowtotal(r804ak3 r804bk3 r804ck3 r804dk3 r804ek3 r804fk3 r804gk3)
	label var n_actinst "Number of Active Social Organisations"
	
	gen commorg = r804ak3==1
	gen socorg = r804bk3==1
	gen proforg = r804ck3==1
	gen cultorg = r804dk3==1
	gen ngo = r804ek3==1
	gen rel_org = r804fk3==1
	gen aidorg = r804gk2
	gen neighboursecurity = r1308a==1
	gen neighbourshoodsecurity = r1308b==1
	gen civildefense = r1308c==1
	gen neighbourhoodsecfacility = r1309ak2==1


	
	
	
********************************************************************************	
**********************NATURAL DISASTERS*****************************************
********************************************************************************


	gen landslide = r60101k2==1
	label var landslide "Landslide: yes"

	gen flood = (r60102k2 ==1 | r60103k2==1)
	label var flood "Flood: yes"

	gen earthquake = (r60104k2==1)
	label var earthquake "Earthquake: yes"

	gen tsunami = (r60105k2==1)
	label var tsunami "Tsunami: yes"

	gen typhoon = (r60107k2==1)
	label var typhoon "Typhoon: yes"

	gen risingtides = (r60106k2==1)
	label var risingtides "Rising tides: yes"

	gen volc = (r60108k2==1)
	label var volc "Typhoon: yes"

	gen fire = (r60109k2==1)
	label var fire "Fire: yes"

	gen drought = (r60110k2==1)
	label var drought "Drought: yes"


********************************************************************************	
**********************SCHOOLING FACILITIES**************************************
********************************************************************************	
    
	gen kindergar_s =  r701ak2
	label var kindergar_s "Number of State Kindergartens"

	gen kindergar_p =  r701ak3
	label var kindergar_p "Number of Private Kindergartens"

	gen kindergar = kindergar_s + kindergar_p
	label var kindergar "Number of Kindergartens"

	gen SD_s = r701bk2
	label var SD_s "Number of State Primary Schools"

	gen SD_p = r701bk3
	label var SD_p "Number of Private Primary Schools"

	gen SD = SD_s + SD_p
	label var SD "Number of Primary Schools"

	gen SLTP_s = r701ck2
	label var SLTP_s "Number of State Junior High Schools"

	gen SLTP_p = r701ck3
	label var SLTP_p "Number of Private Junior High Schools"

	gen SLTP = SLTP_s + SLTP_p
	label var SLTP "Number of Junior High Schools"

	gen SMU_s = r701dk2
	label var SMU_s "Number of State Senior High Schools"

	gen SMU_p = r701dk3
	label var SMU_p "Number of Private Senior High Schools"

	gen SMU = SMU_s + SMU_p
	label var SMU "Number of Senior High Schools"

	gen SMK_s = r701ek2
	label var SMK_s "Number of State Vocational Schools"

	gen SMK_p = r701ek3
	label var SMK_p "Number of Private Vocational Schools"

	gen SMK = SMK_s + SMK_p
	label var SMK "Number of Vocational Schools"

	gen univ_s = r701fk2
	label var univ_s "Number of State Universities"

	gen univ_p = r701fk3
	label var univ_p "Number of Private Universities"

	gen univ = univ_s + univ_p
	label var univ "Number of Universities"


	gen school_dis_s = r701gk2
	label var school_dis_s "Number of State Schools for disabled"

	gen school_dis_p = r701gk3
	label var school_dis_p "Number of Private Schools for disabled"

	gen school_dis = school_dis_s + school_dis_p
	label var school_dis "Number of Schools for disabled"

	gen islamic_p = r701hk3 + r701ik3 
	lab var islamic_p "Number of Islamic Schools"

	gen seminary_p = r701jk3
	label var seminary_p "Number of Seminaries"

	egen n_educ_s = rowtotal(SD_s SLTP_s  kindergar_s SMK_s SMU_s univ_s school_dis_s)
	label var n_educ_s "Number of Educational Facilities from the State"

	egen n_educ_p = rowtotal(SD_p SLTP_p kindergar_p SMK_p SMU_p univ_p school_dis_p islamic_p seminary_p)
	label var n_educ_p "Number of Private Educational Facilities"

	gen n_educ = n_educ_s + n_educ_p
	label var n_educ "Number of Educational Facilities"

********************************************************************************	
**********************HEALTH FACILITIES*****************************************	
********************************************************************************	
		 
		 
	gen n_hospital = r704ak3
	replace n_hospital=0 if n_hospital==.	
	label var n_hospital "Number of Hospitals"

	gen n_maternhosp = r704bk3
	replace n_maternhosp=0 if n_maternhosp==.
	
	label var n_maternhosp "Number of Materninty Hospitals"

	gen n_policlinic = r704ck3
	replace n_policlinic=0 if n_policlinic==.
	label var n_policlinic "Number of Policlinics"

	gen n_healthclinic = r704dk3
	replace n_healthclinic=0 if n_healthclinic==.
	label var n_healthclinic "Number of Health Clinic"
	
	gen n_supphealthclinic = r704ek3
	replace n_supphealthclinic=0 if n_supphealthclinic==.
	label var n_supphealthclinic "Number of Supporting Health Clinic"

	gen n_privpractice = r704fk3
	replace n_privpractice=0 if n_privpractice==.
	label var n_privpractice "Number of Private Practices"

	gen n_midwife =  r704gk3
	replace n_midwife=0 if n_midwife==.
	label var n_midwife "Number of Midwives"

	gen n_healthpost = r704hk3
	replace n_healthpost=0 if n_healthpost==.
	label var n_healthpost "Number of Health Posts"

	gen n_villmaternclinic = r704ik3
	replace n_villmaternclinic=0 if n_villmaternclinic==.
	label var n_villmaternclinic "Number of Village Maternity Clinics"

	gen n_pharm = r704kk3
	replace n_pharm=0 if n_pharm==.
	label var n_pharm "Number of Pharmacies"


	egen n_healthfacilities = rowtotal (n_hospital n_maternhosp n_policlinic n_healthclinic n_supphealthclinic n_privpractice n_midwife n_healthpost n_villmaternclinic n_pharm)
	label var n_healthfacilities "Number of Health Facilities"

	gen eth_het = r806==1
	label var eth_het "Ethnically Heterogeneous"


		egen Health = rowtotal(n_hospital n_healthclinic n_supphealthclinic)

	

	gen kabuname = nama_kab
	gen kecnama = nama_kec
	gen vilname = nama_des


	foreach var of varlist r1402a1k r1402a2k r1402a3k r1402a4k r1402b1k r1402b2k r1402b3k r1402c1k r1402c2k r1402c3k{
	tab `var'
	replace `var'=0 if `var'==2
	}

	egen other_aid = rowtotal( r1402a1k r1402a2k r1402a3k r1402a4k r1402b1k r1402b2k r1402b3k r1402c1k r1402c2k r1402c3k)
	gen d_other_aid = other_aid>=1

	

********************************************************************************	
**********************MORE PUBLIC GOODS*****************************************	
********************************************************************************	
	  
	gen asphaltroad = r1001b1==1
	label var asphaltroad "Road: Asphalt"
	
	gen gravelroad = r1001b1==2
	label var gravelroad "Road: Gravel"
	
	gen soillroad = r1001b1==3
	label var soillroad "Road: Soil"
	
	gen otherroad = r1001b1==4
	label var otherroad "Road: Other"
	
	gen fixedlinephone =r1005a==1
	label var fixedlinephone "Fixed Line Phone: yes"
	gen n_fixedlinephone = r1005b
	
	replace n_fixedlinephone=0 if r1005a==2
	label var n_fixedlinephone "Fixed Line Phone: Number of Families"
	
	gen publicphone = r1006==1
	label var publicphone "Public Phone: yes"
	

	gen n_fightcommgr = r1301b1k
	gen n_fightbetweenvillages = r1301b2k
	gen n_fightwithofficers = r1301b3k
	gen n_fightgov = r1301b4k
	gen n_fightbetweenethnics = r1301b6k
	gen n_fightother = r1301b7k
	gen n_fightstudents = r1301b5k 

	gen theft= r130301k ==1
	gen robbery= r130302k ==1
	gen looting= r130303k ==1
	gen violence= r130304k ==1
	gen combustion= r130305k ==1
	gen rape= r130306k ==1
	gen drugabusetrafficking= r130307k ==1
	gen drugtraficking= r130308k ==1
	gen murder= r130309k ==1
	gen childsale= r130310k ==1
 
	egen n_crime=rowtotal(theft robbery looting violence combustion rape drugabuse drugtraficking murder childsale)
	gen anycrime= n_crime>=1
	gen n_suicides = r1304
	
	tab n_suicides
	
	gen suicideyes = n_suicides>=1
	tab suicideyes
	
	 foreach var of varlist suicide*{
qbys kabuid: egen kab`var' = mean(`var')
qbys kecaid: egen kec`var' = mean(`var')

}

tab kecsuicideyes
	
	foreach var of varlist r1308a r1308b r1308c r1308d r1308e{
	tab `var'
	tostring `var', replace
	}

	gen sec_post=r1308a=="1"
	gen sec_groups= r1308b=="3"
	gen sec_securitofficer= r1308c =="5"
	gen sec_screenguest = r1308d=="7"
	gen sec_other = r1308e=="1"

 
	gen security_post= r1309ak2 ==1
	gen police_post= r1309bk2 ==1
	gen distancepolice= r1309bk3
	gen n_security=r1310
  
	foreach var of varlist n_fightcommgr n_fightbetweenvillages n_fightwithofficers n_fightgov n_fightbetweenethnics n_fightother n_fightstudents{
	replace `var'=0 if `var'==.
	tab `var'
	}
	
	qbys kecaid: gen nvillages = _N
	
	
	
	foreach var of varlist *{
	rename `var' `var'2011
	}

	gen kabunama = nama_kab2011
	gen kecnama = nama_kec2011
	gen vilname = nama_des2011




save "$podes/podes2011", replace
