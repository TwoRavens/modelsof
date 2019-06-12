

********************************************************************************
*** This data file decribes how we cleaned the PODES data **********************
********************************************************************************

/* 
Note that because of licencing reasons we cannot make the raw-data public.
   If you are interested in acquiring the PODES data please contact the Indonesian
   statistical agency (https://www.bps.go.id/#)
*/


*Set path to PODES data
global podes "SETYOURPODESPATH/Data"



do "$dofiles/Podes_waves/PODES 2000 clean.do"
do "$dofiles/Podes_waves/PODES 2003 clean.do"
do "$dofiles/Podes_waves/PODES 2005 clean.do"
do "$dofiles/Podes_waves/PODES 2011 clean.do"
do "$dofiles/Podes_waves/PODES 2014 clean.do"




********************************************************************************	
********************************************************************************
*****************************Shock Data*****************************************
********************************************************************************	
********************************************************************************	
	


	
	
*** PKH



use "$data/crosswalk_PKH_PODES2014.dta", clear


gen treat2007 = year==2007
gen treat2008 = year==2008
gen treat2009 = year==2009
gen treat2010 = year==2010
gen treat2011 = year==2011
gen treat2012 = year==2012
gen treat2013 = year==2013

gen treat0708 = (year==2007 | year==2008)
gen treat1011 = (year==2010 | year==2011)
gen treat1213 = (year==2012 | year==2013)

gen str2 dist = string(kabid,"%02.0f")
	gen str3 subd = string(kecid,"%03.0f")

egen kecid2010 = concat(provid dist subd)

egen kecid2011 = concat(provid dist subd)
duplicates drop kecid2011, force

keep nvillages2014 kecid2011 kecid2010 treat* n_suicides2014 suicideyes2014  anycrime2014 anycrime2014 n_crime2014 robbery2014 theft2014 looting2014 violence2014 rape2014 murder2014 childsale2014  drugtraficking2014 combustion2014 gotong2014  n_educ2014  Health2014 

tab nvillages2014

	
	
merge 1:n kecid2011 using "$data/kecamatanxwalk.dta"
	
	
	keep if _merge==3
	drop _merge
	
	duplicates drop kecid2011, force
	
	gen cou = 1
	
			tab nvillages2014

			tab nvillages2014, m
			tab n_suicides2014, m
	
	collapse (sum) nvillages2014 n_suicides2014 suicideyes2014  treat2007 treat2008 treat2009 treat2010 treat2011 treat2012 treat2013 treat0708 treat1011 treat1213  anycrime2014 n_crime2014 robbery2014 theft2014 looting2014 violence2014 rape2014 murder2014 childsale2014  drugtraficking2014 combustion2014 gotong2014  n_educ2014  Health2014  (count) n2014=cou, by(kecid2000)
		
			tab nvillages2014, m

		
	save "$temp/podes2014temp", replace
********************************************************************************	
********************************************************************************
****************************PODES 2000******************************************
********************************************************************************	
********************************************************************************	
	
	** Generate subdistrict name dataset **
	use "$data/podes2000", clear
	
	egen temp= concat(prop2000 kab2000 kec2000)
	duplicates tag temp, gen(tag)
	drop if tag==0
	drop tag
	
	unique kecaid2000
	keep if desa2000=="000" &kab2000!="00"&kec2000!="000"
	
	keep nama2000 kab2000 kec2000 prop2000  
	
	gen name_dec11 =nama
	gen name_dec00=nama
	
	egen kecid2000 = concat(prop2000 kab2000 kec2000)
	gen kecaid2000=kecid2000
	gen idu=_n
	
	sort nama
	
	*br kecid2000 nama
	*** Manual changes to match 2005 ids ***
	
	*Missing 2000 and 2003 *
	replace kecid2000="5313010" if kecid=="5312010"&nama=="KOMODO"
	replace kecid2000="5313150" if kecid=="5312150"&nama=="KUWUS"
	replace kecid2000="7502120" if kecid=="7101170"&nama=="SUWAWA"
	replace kecid2000="7502130" if kecid=="7101180"&nama=="BONEPANTAI"
	replace kecid2000="7571010" if kecid=="7171010"&nama=="KOTA BARAT"
	
	*Missing only 2000*
	replace kecid2000="3201240" if kecid=="3203240"&nama=="PARUNG"
	replace kecid2000="3201250" if kecid=="3203250"&nama=="GUNUNG SINDUR"
	replace kecid2000="3201300" if kecid=="3203300"&nama=="PARUNG PANJANG"
	replace kecid2000="3205250" if kecid=="3207250"&nama=="LEUWIGOONG"
	replace kecid2000="3205280" if kecid=="3207280"&nama=="KADUNGORA"
	replace kecid2000="3205300" if kecid=="3207300"&nama=="SELAAWI"
	replace kecid2000="7102170" if kecid=="7103170"&nama=="PINELENG"
	replace kecid2000="7102190" if kecid=="7103190"&nama=="TONDANO"
	replace kecid2000="7102210" if kecid=="7103210"&nama=="KAKAS"
	replace kecid2000="7102230" if kecid=="7103230"&nama=="ERIS"
	replace kecid2000="7102240" if kecid=="7103240"&nama=="KOMBI"
	replace kecid2000="7102250" if kecid=="7103250"&nama=="TOULIMAMBOT"
	*replace kecid2000="7171050" if kecid=="7103250"&nama=="MOLAS" //unclear
	*replace kecid2000="7171020" if kecid=="7171020"&nama=="KOTA SELATAN" //unclear
	*replace kecid2000="7171030" if kecid=="7171030"&nama=="WENANG" //unclear
	
	

	
	
	save "$temp/temp2000names", replace
	
	*Merge subdistrict cross-walk (fuzzy)
	use "$data/kecamatanxwalk.dta", clear

	
	gen id=_n	
	gen kab2000=substr(kecid2000, 3, 2)
	gen prop2000=substr(kecid2000, 1, 2)
	duplicates drop kecid2000, force
	save "$temp/temp2000xwalk" ,replace
	
	duplicates drop kecid2000, force
	
	merge 1:n kecid2000 using "$temp/temp2000names"
	
	preserve
	keep if _merge==3
	unique kecid2000
	
	save "$temp/temp2000matched" ,replace
	
	restore 
	
	keep if _merge ==2
	keep name* kab2000 kec2000 kecid2000 idu prop2000 kecaid2000
	
	save "$temp/temp2000unmatched" ,replace

	
	use "$temp/temp2000unmatched", clear
	ren kecid2000  Ukecid2000
	reclink   name_dec11 name_dec00 prop kab2000 using "$podes/temp2000xwalk", ///
	idm(idu) idu(id)  gen(match)  wmatch(1 1 10 5)
	
	sort match

	unique kecid2000
	

	gen prop_match=Uprop2000==prop2000
	gen kab_match=Ukab2000==kab2000
	gen name2011_match=name_dec11==Uname_dec11
	gen name2000_match=name_dec00==Uname_dec00
	
	
	drop if prop_match==0 //keep same province
	keep if kab_match==1&(name2011_match==1|name2000_match==1) //Keep if either Kabu id works or at least one name matches perfectly.
	
	unique kecid2000 
	
	
	duplicates drop kecid2000, force // Only keep one observation
	
	gen unmatched=1
	ren Ukecid2000 kecid2000_podes
	
	drop U* match _merge
	append using "$temp/temp2000matched"
	
	replace kecid2000_podes=kecaid2000 if unmatched==.
	unique kecid2000

	drop kecaid2000
	
	save "$temp/temp2000matched", replace
	
	use "$temp/temp2000matched", clear
	drop _merge
	gen kecaid2000=kecid2000_podes
	
	duplicates report kecaid2000
	
	merge 1:n kecaid2000 using  "$podes/podes2000"
	keep if _merge==3
	
		gen cou = 1
	tostring kecid2000, replace
	collapse (sum)  public_bank2000 villcoopunit2000 lendingsavingcoop2000 org_scouts2000 org_orph2000 org_eld2000 org_hand2000 org_rel2000 org_youth2000 org_PKK2000 SOC2000 social2000 gotong2000 sharing2000 suicideyes* pop_size* n_families* n_hospital* n_maternhosp* n_villmaternclinic* n_policlinic* n_healthfacilities* kindergar* SD* n_educ* (mean) nvillages2000 perc_farmers* asphaltroad* gravelroad* soillroad* otherroad* lighting* gov_light* nongov_light* nonelec_light* rural* perc_ele* , by(kecid2000)
	
	
	save "$temp/podes2000temp", replace


********************************************************************************	
********************************************************************************
****************************PODES 2003******************************************
********************************************************************************	
********************************************************************************	
		 
		** Generate subdistrict name dataset **
		use "$data/podes2003", clear
		egen temp = concat(prop kab kec)
		duplicates tag temp, gen(tag)
		drop if tag==0
		drop tag
		unique kecaid2003
		keep if desa=="000" &kab!="00"&kec!="000"
		
		replace kecaid2003=temp if kecaid2003==""
		keep nama kab kec prop kecaid2003
		
		gen name_dec11 =nama
		gen name_dec00=nama
		
		egen kecid2003 = concat(prop kab kec)
		gen idu=_n
		
		sort nama
		
		*br kecid2003 nama
		
		
				*Missing 2000 and 2003 *
	replace kecid2003="5315010" if kecid=="5313010"&nama=="KOMODO"
	replace kecid2003="5315040" if kecid=="5313150"&nama=="KUWUS"
	replace kecid2003="7504030" if kecid=="7502120"&nama=="SUWAWA"
	replace kecid2003="7504040" if kecid=="7502130"&nama=="BONEPANTAI"
	replace kecid2003="7571011" if kecid=="7571010"&nama=="KOTA BARAT"
	
	
	replace kecid2003="5304091" if kecid=="5304090"&nama=="KIE"
	replace kecid2003="7105010" if kecid=="7102010"&nama=="MODOINDING" 
	replace kecid2003="7102080" if kecid=="7102040"&nama=="MOTOLING" 
	replace kecid2003="7105130" if kecid=="7102150"&nama=="TUMPAAN" 
	replace kecid2003="7105100" if kecid=="7102050"&nama=="TENGA" 
	replace kecid2003="7105040" if kecid=="7102080"&nama=="RATAHAN" 
		
		

		

		
		save "$temp/temp2003names", replace
		
		*Merge subdistrict cross-walk (fuzzy)




use "$data/kecamatanxwalk.dta", clear
		
		gen id=_n	
		gen kab=substr(kecid2003, 3, 2)
		gen prop=substr(kecid2003, 1, 2)
		duplicates drop kecid2003 kecid2000, force
		save "$temp/temp2003xwalk" ,replace
		
		duplicates drop kecid2003 kecid2000, force
		
		merge n:1 kecid2003 using "$temp/temp2003names"
		
		preserve
		keep if _merge==3
		unique kecid2003
		
		save "$temp/temp2003matched" ,replace
		
		restore 
		
		keep if _merge ==2
		keep name* kab kec kecid2003 kecaid2003 kecid2000 idu prop
		
		save "$temp/temp2003unmatched" ,replace

		
		use "$temp/temp2003unmatched", clear
		ren kecid2003  Ukecid2003
		reclink   name_dec11 name_dec00 prop kab using "$temp/temp2003xwalk", ///
		idm(idu) idu(id)  gen(match)  wmatch(1 1 10 5)
		
		sort match
		
		*br match *kecid2000 *name* *kab *prop
		
		unique kecid2000
		

		gen prop_match=Uprop==prop
		gen kab_match=Ukab==kab
		gen name2011_match=name_dec11==Uname_dec11
		gen name2000_match=name_dec00==Uname_dec00
		
		
		drop if prop_match==0 //keep same province
		keep if kab_match==1&(name2011_match==1|name2000_match==1) //Keep if either Kabu id works or at least one name matches perfectly.
		
		unique kecid2000 kecid2003
		
		
		
		gen unmatched=1
		ren Ukecid2003 kecid2003_podes
		
		drop U* match _merge
		append using "$temp/temp2003matched"
		
		replace kecid2003_podes=kecaid2003 if unmatched==.
		unique kecid2003

	
		
		save "$temp/temp2003matched", replace
		
		use "$temp/temp2003matched", clear
		drop _merge kecaid2003

		gen kecaid2003=kecid2003_podes
		
		joinby  kecaid2003 using  "$podes/podes2003", _merge(merge)
		

		tostring kecid2003, replace
		collapse (sum) irrigation2003 public_bank2003 n_public_bank2003 n_rural_bank2003 org_scouts2003 org_youth2003 org_PKK2003 org_rel2003 org_orph2003 org_eld2003 org_hand2003 n_socorg2003 n_actinst2003 suicideyes* pop_size* n_families* n_hospital* n_maternhosp* n_villmaternclinic* n_policlinic* n_healthfacilities* kindergar* SD* n_educ* (mean) nvillages2003 perc_farmers* asphaltroad* gravelroad* soillroad* otherroad* lighting* gov_light* nongov_light* nonelec_light* rural* perc_ele* , by(kecid2003_podes kecid2000)
		
		gen cou = 1
		
		collapse (sum) nvillages2003 irrigation2003 public_bank2003 n_public_bank2003 n_rural_bank2003 org_scouts2003 org_youth2003 org_PKK2003 org_rel2003 org_orph2003 org_eld2003 org_hand2003 n_socorg2003 n_actinst2003 suicideyes* pop_size* n_families* n_hospital* n_maternhosp* n_villmaternclinic* n_policlinic* n_healthfacilities* kindergar* SD* n_educ* (mean) perc_farmers* asphaltroad* gravelroad* soillroad* otherroad* lighting* gov_light* nongov_light* nonelec_light* rural* perc_ele* (count) n2003= cou, by(kecid2000)

		
		save "$temp/podes2003temp", replace
	
		* New keca ids: 3,597
		* Old keca ids: 3,595
	
	

********************************************************************************	
********************************************************************************
****************************PODES 2005******************************************
********************************************************************************	
********************************************************************************	
		 
	** Generate subdistrict name dataset **
	use "$podes/podes2005", clear
	unique kecaid2005
	egen temp = concat(prop kabu keca)
	duplicates tag temp, gen(tag) // Drop kecids without village observations
	drop if tag==0
	
	keep if desa=="000" &kabu!="00"&keca!="000"
	
	keep nama kabu keca prop
	
	gen name_dec11 =nama
	gen name_dec00=nama
	
	egen kecid2005 = concat(prop kabu keca)
	gen idu=_n
	unique kecid2005
	save "$temp/temp2005names", replace
	
	
	*Merge subdistrict cross-walk (fuzzy)
	use "$data/kecamatanxwalk.dta", clear
	
	
	gen id=_n	
	gen kabu=substr(kecid2005, 3, 2)
	gen prop=substr(kecid2005, 1, 2)
	save "$temp/temp2005xwalk" ,replace
	
	duplicates drop kecid2005 kecid2000, force
	
	merge n:1 kecid2005 using "$temp/temp2005names"
	
	preserve
	keep if _merge==3
	
	save "$temp/temp2005matched" ,replace
	
	restore 
	
	keep if _merge ==2
	keep name* kabu keca kecid2005 idu prop
	
	save "$temp/temp2005unmatched" ,replace

	
	use "$temp/temp2005unmatched", clear
	
	ren kecid2005  Ukecid2005
	reclink   name_dec11 name_dec00 prop kabu using "$temp/temp2005xwalk", ///
	idm(idu) idu(id)  gen(match)  wmatch(1 1 10 5)
	
	sort match
	
	*br match *kecid2005 *name* *kabu *prop
	
	unique kecid2005 
	
	unique kecid2005 kecid2000
	
	
	gen prop_match=Uprop==prop
	gen kab_match=Ukabu==kabu
	gen name2011_match=name_dec11==Uname_dec11
	gen name2000_match=name_dec00==Uname_dec00
	
	
	drop if prop_match==0 //keep same province
	keep if kab_match==1&(name2011_match==1|name2000_match==1) //Keep if either Kabu id works or at least one name matches perfectly.
	
	unique kecid2005 
	unique kecid2005 kecid2000
	
	gen unmatched=1
	ren Ukecid2005 kecid2005_podes
	
	unique kecid2005_podes kecid2005 , gen(unique)
	
	duplicates drop kecid2005_podes kecid2000, force // Ids have same 2000 id
		
	drop U* match _merge
	append using "$temp/temp2005matched"
	
	replace kecid2005_podes= kecid2005 if unmatched==.
	unique kecid2005 
	unique kecid2005 kecid2000 kecid2005_podes
	unique kecid2005_podes kecid2000
	
	
	
	save "$temp/temp2005matched", replace
	
	use "$temp/temp2005matched", clear
	drop _merge
	gen kecaid2005=kecid2005_podes
	
	joinby kecaid2005 using  "$podes/podes2005", _merge(merge) unm(both)
	
	tostring kecid2005, replace
	collapse (sum) Health2005 irrigation2005 prostitution2005 theft2005 robbery2005 looting2005 violence2005 combustion2005 rape2005 drugabuse2005 drugtraficking2005 murder2005 childsale2005 other2005 anycrime2005   massfight2005 n_deathsmassfight2005 n_injuredmassfight2005 materialdamagemassfight2005 fightcommunitygroups2005 fightwithofficers2005 fightstudents2005 fightbetweenethnics2005 fightother2005 sec_post2005 sec_groups2005 sec_securitofficer2005 sec_screenguest2005 sec_other2005 security_post2005 police_post2005 distancepolice2005 n_securityofficers2005 n_crime2005 org_youth2005 rel_org2005 org_orph2005 org_eld2005 org_hand2005 funeralservice2005 NGO2005 n_socorg2005 n_actinst2005 gotong2005 eth_het2005 suicideyes* pop_size* n_families* n_hospital* n_maternhosp* n_villmaternclinic* n_policlinic* n_healthfacilities* kindergar* SD* n_educ* (mean) nvillages2005 perc_farmers* asphaltroad* gravelroad* soillroad* otherroad* lighting* gov_light* nongov_light* nonelec_light* rural* perc_ele* , by(kecid2005_podes kecid2000)
	
	*5,427 kecaids  in PODES data
	*Old match: 4,875
	*New match: 4,957/4952
	
	unique kecid2005

	
	gen cou = 1	
	
	collapse (sum) Health2005 nvillages2005 irrigation2005 prostitution2005 theft2005 robbery2005 looting2005 violence2005 combustion2005 rape2005 drugabuse2005 drugtraficking2005 murder2005 childsale2005 other2005 anycrime2005   massfight2005 n_deathsmassfight2005 n_injuredmassfight2005 materialdamagemassfight2005 fightcommunitygroups2005 fightwithofficers2005 fightstudents2005 fightbetweenethnics2005 fightother2005 sec_post2005 sec_groups2005 sec_securitofficer2005 sec_screenguest2005 sec_other2005 security_post2005 police_post2005 distancepolice2005 n_securityofficers2005 n_crime2005 org_youth2005 rel_org2005 org_orph2005 org_eld2005 org_hand2005 funeralservice2005 NGO2005 n_socorg2005 n_actinst2005 gotong2005 eth_het2005 suicideyes* pop_size* n_families* n_hospital* n_maternhosp* n_villmaternclinic* n_policlinic* n_healthfacilities* kindergar* SD* n_educ* (mean) perc_farmers* asphaltroad* gravelroad* soillroad* otherroad* lighting* gov_light* nongov_light* nonelec_light* rural* perc_ele* (count) n2005= cou, by(kecid2000)
	

	save "$temp/podes2005temp", replace
	

********************************************************************************	
********************************************************************************
****************************PODES 2011******************************************
********************************************************************************	
********************************************************************************	
		 
	
		 
	** Generate subdistrict name dataset **
	use "$podes/podes2011", clear
	
	gen temp =  kode_pro2011*100000+kode_kab2011*1000 + kode_kec2011
	duplicates tag temp, gen(tag) 
	drop if tag==0 // Drop kecids without village observations
	drop tag
	
	duplicates drop kecaid2011, force

	
	keep kode_pro2011 nama_kab2011 nama_kec2011 kode_kab2011  kode_kec2011
	
	ren kode_pro2011 prop
	ren kode_kab2011 kabu
	gen name_dec11 =nama_kec2011
	gen name_dec00 =nama_kec2011
	
	gen kecid2011 = prop*100000+ 1000*kabu+ kode_kec2011
	tostring kecid2011, replace
	gen idu=_n
	
	save "$temp/temp2011names", replace
	
	*Merge subdistrict cross-walk (fuzzy)
*	use "/Users/`c(username)'/Dropbox/Poverty and Mental Health/data/kecamatanxwalk.dta", clear
	

use "$data/kecamatanxwalk.dta", clear

	
	
	gen id=_n	
	gen kabu=substr(kecid2011, 3, 2)
	gen prop=substr(kecid2011, 1, 2)
	
	destring kabu prop, replace
	save "$temp/temp2011xwalk" ,replace
	
	duplicates drop kecid2011, force
	
	merge 1:n kecid2011 using "$temp/temp2011names"
	
	preserve
	keep if _merge==3
	drop _merge
	
	save "$temp/temp2011matched" ,replace
	
	restore 
	
	keep if _merge ==2
	keep name* kabu  kecid2011 idu prop
	
	save "$temp/temp2011unmatched" ,replace

	
	use "$temp/temp2011unmatched", clear
	ren kecid2011  Ukecid2011
	reclink   name_dec11 name_dec00 prop kabu using "$temp/temp2011xwalk", ///
	idm(idu) idu(id)  gen(match)  wmatch(2 5  10 1)
	
	sort match
	
	*br match *kecid2011 *name* *kabu *prop
	
	unique kecid2011
	
	unique kecid2011 kecid2000
	
	
	gen prop_match=Uprop==prop
	gen kab_match=Ukabu==kabu
	gen name2011_match=name_dec11==Uname_dec11
	gen name2000_match=name_dec00==Uname_dec00

	
	
	drop if prop_match==0 //keep same province
	keep if kab_match==1&(name2011_match==1|name2000_match==1) //Keep if  Kabu id works and at least one name matches perfectly.
	
	unique kecid2011 
	unique kecid2011 kecid2000
	
	gen unmatched=1
	ren Ukecid2011 kecid2011_podes
		


	drop U* match _merge
	append using "$temp/temp2011matched"
	
		
	replace kecid2011_podes= kecid2011 if unmatched==.
	
		unique kecid2011 
	unique kecid2011 kecid2000
	

	
	save "$temp/temp2011matched", replace
	
	use "$temp/temp2011matched", clear

	gen kecaid2011=kecid2011_podes
	destring kecaid, replace
	
	merge 1:n kecaid2011 using  "$podes/podes2011"
	
	
	collapse (sum) Health2011 n_suicides2011 irrigation2011 pollution2011 fieldburning2011 community_aid2011 safetyequip2011 gotong2011 safetycounseling2011 prostitution2011 neighboursecurity2011 neighbourshoodsecurity2011 civildefense2011 neighbourhoodsecfacility2011 n_fightcommgr2011 n_fightbetweenvillages2011 n_fightwithofficers2011 n_fightgov2011 n_fightbetweenethnics2011 n_fightother2011 n_fightstudents2011 theft2011 robbery2011 looting2011 violence2011 combustion2011 rape2011 drugabusetrafficking2011 drugtraficking2011 murder2011 childsale2011 sec_post2011 sec_groups2011 sec_securitofficer2011 sec_screenguest2011 sec_other2011 security_post2011 police_post2011 distancepolice2011 n_security2011 n_crime2011 anycrime2011 n_socorg2011 n_actinst2011 commorg2011 socorg2011 proforg2011 cultorg2011 rel_org2011 aidorg2011 suicideyes* pop_size* n_families* n_hospital* n_maternhosp* n_villmaternclinic* n_policlinic* n_healthfacilities* kindergar* SD* n_educ* (mean) nvillages2011 perc_farmers* asphaltroad* gravelroad* soillroad* otherroad* lighting* gov_light* nongov_light* nonelec_light* rural* perc_ele* , by(kecid2011_podes kecid2000)
	

	gen cou = 1	
	
	collapse (sum) Health2011 nvillages2011 n_suicides2011 irrigation2011 pollution2011 fieldburning2011 community_aid2011 safetyequip2011 gotong2011 safetycounseling2011 prostitution2011 neighboursecurity2011 neighbourshoodsecurity2011 civildefense2011 neighbourhoodsecfacility2011 n_fightcommgr2011 n_fightbetweenvillages2011 n_fightwithofficers2011 n_fightgov2011 n_fightbetweenethnics2011 n_fightother2011 n_fightstudents2011 theft2011 robbery2011 looting2011 violence2011 combustion2011 rape2011 drugabusetrafficking2011 drugtraficking2011 murder2011 childsale2011 sec_post2011 sec_groups2011 sec_securitofficer2011 sec_screenguest2011 sec_other2011 security_post2011 police_post2011 distancepolice2011 n_security2011 n_crime2011 anycrime2011 n_socorg2011 n_actinst2011 commorg2011 socorg2011 proforg2011 cultorg2011 rel_org2011 aidorg2011 suicideyes* pop_size* n_families* n_hospital* n_maternhosp* n_villmaternclinic* n_policlinic* n_healthfacilities* kindergar* SD* n_educ* (mean) perc_farmers* asphaltroad* gravelroad* soillroad* otherroad* lighting* gov_light* nongov_light* nonelec_light* rural* perc_ele* (count) n2011= cou, by(kecid2000)
	
	
	save "$temp/podes2011temp", replace
	

*****************************************************************
	
	use "$temp/podes2011temp", clear
	
	
	merge 1:1 kecid2000	using "$temp/podes2014temp"	
	drop _merge
	merge 1:1 kecid2000	using "$temp/podes2005temp"	
	drop _merge		
	merge 1:1 kecid2000	using "$temp/podes2003temp"	
	drop _merge		
	merge 1:1 kecid2000	using "$temp/podes2000temp"	
	drop _merge			 
	
	gen kabuid = substr(kecid2000,1,4)

	save "$temp/podes2000_2014temp", replace
	
	
use "$podes/exppl07.dta", clear //District level hh-expenditure data based SUSENAS
	
	gen str2 dist = string(b1r2,"%02.0f")
	egen kabuid = concat(b1r1 dist)
	
	collapse pcexp poor [pw=weind07], by(kabuid)	

merge 1:n kabuid using "$temp/podes2000_2014temp"

drop if _merge==1
*	keep if _merge==3
	drop _merge
		
save "$temp/suicideclean_pkhrollout2000borders", replace


use "$temp/suicideclean_pkhrollout2000borders", clear

********************************************************************************	
********************************************************************************
****************************collapsing data by 2000 ids*************************
********************************************************************************	
********************************************************************************	
	
	replace n_fightcommgr2011 = n_fightcommgr2011>0
	
	rename n_fightcommgr2011 fightcommunitygroups2011
	rename n_fightwithofficers2011 fightwithofficers2011
	rename n_fightgov2011 fightgov2011
	rename n_fightbetweenethnics2011 fightbetweenethnics2011
	rename n_fightother2011 fightother2011
	rename n_fightstudents2011 fightstudents2011
			 	
	rename drugabusetrafficking2011 drugabuse2011
	
		
	
	reshape long  Health n nvillages rel_org fightcommunitygroups fightwithofficers fightgov fightbetweenethnics fightother fightstudents irrigation robbery theft looting violence rape drugabuse murder childsale  drugtraficking combustion prostitution sec_post sec_groups sec_securitofficer sec_screenguest sec_other gotong anycrime n_crime n_actinst n_socorg suicideyes n_hospital n_maternhosp n_healthfacilities lighting asphaltroad rural pop_size earthquake perc_ele n_educ n_families SD, i(kecid2000) j(year)  
	 
	tab suicideyes

	sum perc_farmers2005	, d
 
  
********************************************************************************	
********************************************************************************
*****************************Cleaning the data**********************************
********************************************************************************	
********************************************************************************	
		
	
	gen suicide = suicideyes>0
	replace suicide=. if suicideyes==.
		
	*drop suicideyes
	tab suicide
	gen provid = substr(kecid2000,1,2)
	
	
	destring *, replace
	xtset kecid2000 year
	
	xtsum suicide
	
	
	

******************************************************************************** 
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
******************************************************************************** 
 
	egen kect = concat(kec* year)

	


		
	gen year2003 = year==2003
	gen year2005 = year==2005
	gen year2011 = year==2011
	gen year2014 = year==2014
		
	sum suicideyes
	
	gen pop_sizesq = pop_size^2
	gen pop_size3 = pop_size^3
	gen pop_size4 = pop_size^4	
	gen nsuicides = round(suicideyes,1)
	
	
	
	

	  
	gen t = 1 if year2003==1
	replace t = 2 if year2005==1
	replace t = 3 if year2011==1
	replace t = 4 if year2014==1
	replace t = 0 if t==.
 	 

	
	gen t_relativetotreatment = t - 2 if treat0708==1
	replace t_relativetotreatment = t - 2 if treat1011==1
	replace t_relativetotreatment = t - 3 if treat1213==1
	replace t_relativetotreatment = t - 4 if treat1213==0 & treat1011==0 & treat0708==0

	
*** Add rainfall data ***

merge n:1 kecid2000 year using "$data/rainfall_keca_5closest.dta" 



bys kecid2000: egen temppos=pctile(z_rain), p(90)
bys kecid2000: egen tempneg=pctile(z_rain), p(10)

gen shock_pos_90pc=z_rain>temppos if z_rain!=.
gen shock_neg_10pc=z_rain<tempneg if z_rain!=.

drop temp*

bys kecid2000: egen temppos=pctile(z_rain), p(85)
bys kecid2000: egen tempneg=pctile(z_rain), p(15)

gen shock_pos_85pc=z_rain>temppos if z_rain!=.
gen shock_neg_15pc=z_rain<tempneg if z_rain!=.
drop temp*
drop if _merge==2
drop _merge	

save "$temp/suicideclean_pkhrollout2000borders", replace


use "$data/subdistrict_coordinates.dta", clear
keep xcoord ycoord kecid

merge 1:n kecid using "$temp/suicideclean_pkhrollout2000borders", gen(merge)

drop if merge==1
drop merge

		

foreach var in rain_season z_rain sd_rain mean_rain lag1_z_rain lag2_z_rain lag3_z_rain for1_z_rain for2_z_rain for3_z_rain log_rain ycoord  xcoord{
bys kabuid year: egen temp=mean(`var')
replace `var'=temp if `var'==.
drop temp
}

*kabuid 6204 is unmatched


foreach var in rain_season z_rain sd_rain mean_rain lag1_z_rain lag2_z_rain lag3_z_rain for1_z_rain for2_z_rain for3_z_rain log_rain  ycoord  xcoord{
bys provid year: egen temp=mean(`var')
replace `var'=temp if `var'==.
drop temp
}




save "$temp/suicideclean_pkhrollout2000borders", replace

	
use "$data/pkh_xwalk_match.dta", clear //Match treatment indicators


		keep kecid2000
		destring kecid2000, replace
		duplicates drop kecid2000, force
		merge 1:n kecid2000 using  "$temp/suicideclean_pkhrollout2000borders.dta", force
		gen rctsample = _merge==3
		drop _merge

		save "$temp/suicideclean_pkhrollout2000borders", replace
		
		
use "$data/pkh_xwalk_match.dta", clear

	
		
		keep kecid  treat* tc
		
		gen treat_pkhrct=tc
		destring kecid2000, replace
		
		merge 1:n kecid2000 using  "$temp/suicideclean_pkhrollout2000borders.dta", force
		drop _merge
		
		gen treat_pkhrct_post=tc *(year==2011 |year==2014)
			
drop if	suicide==.
		
qbys kecid: gen n2 = _N 		


	 
*********************************************************************************	
*************************PREPARE TREATMENT VARIABLES: PKH************************
*********************************************************************************	
	

*********************************************************************************	
*********************************2011*******************************************
*********************************************************************************


	 gen n2011_2 = n if year==2011
qbys kecid:	egen n2011 = max(n2011_2)

		foreach var of varlist treat2007 treat2008 treat2010 treat2011 treat2012 treat2013{
		tab `var'
		replace  `var'=`var'/n2011
		tab `var'
}	
	
	
	drop treat0708 treat1011 treat1213
	gen treat0708 = treat2007 + treat2008
	gen treat1011 = treat2010 + treat2011
	gen treat1213 = treat2012 + treat2013
	
	
	gen treat_post = (treat2007 + treat2008 + treat2010 + treat2011)*year2011
	gen treat07_post = treat2007*year2011
	gen treat08_post = treat2008*year2011
	gen treat10_post = treat2010*year2011
	gen treat11_post = treat2011*year2011

	
	gen treat0708_post = treat0708*year2011
	gen treat1011_post = treat1011*year2011
	
*********************************************************************************	
*********************************2014*******************************************
*********************************************************************************
	gen year2000 =  year==2000

gen any_treat = 	treat2007 + treat2008 + treat2010 + treat2011+ treat2012 + treat2013
gen never_treat = any_treat==0

tab any_treat

	replace treat_post = (treat2007 + treat2008 + treat2010 + treat2011+ treat2012 + treat2013)*year2014 if year2014==1
	replace treat07_post = treat2007*year2014 if year2014==1
	replace treat08_post = treat2008*year2014 if year2014==1
	replace treat10_post = treat2010*year2014 if year2014==1
	replace treat11_post = treat2011*year2014 if year2014==1
	

	
	replace treat0708_post = treat0708*year2014 if year2014==1
	replace treat1011_post = treat1011*year2014 if year2014==1
	
	
********************************************************************************
********************************************************************************	
**********************pretreatmentvaraibles*************************************
********************************************************************************	
********************************************************************************	

	
	gen treat12_post = treat2012*year2014  
	gen treat13_post = treat2013*year2014  
	gen treat1213_post = (treat2012 + treat2013)*year2014  
	
	gen treat0708_2000 = treat0708*year2000
	gen treat0708_2003 = treat0708*year2003
	gen treat0708_2005 = treat0708*year2005
	gen treat0708_2011 = treat0708*year2011
	gen treat0708_2014 = treat0708*year2014
	
	
	gen treat1011_2000 = treat1011*year2000
	gen treat1011_2003 = treat1011*year2003
	gen treat1011_2005 = treat1011*year2005
	gen treat1011_2011 = treat1011*year2011
	gen treat1011_2014 = treat1011*year2014	
	
	gen treat1213_2000 = treat1213*year2000
	gen treat1213_2003 = treat1213*year2003
	gen treat1213_2005 = treat1213*year2005	
	gen treat1213_2011 = treat1213*year2011
	gen treat1213_2014 = treat1213*year2014	
	
	
	gen treat_2000 = treat0708_2000  + treat1011_2000 + treat1213_2000
	gen treat_2003 = treat0708_2003  + treat1011_2003 + treat1213_2003
	gen treat_2005 = treat0708_2005  + treat1011_2005 + treat1213_2005
	gen treat_2011 = treat0708_2011  + treat1011_2011 + treat1213_2011
	gen treat_2014 = treat0708_2014  + treat1011_2014 + treat1213_2014

	
	
	gen treat07_2000 = treat2007*year2000
	gen treat07_2003 = treat2007*year2003
	gen treat07_2005 = treat2007*year2005
	gen treat07_2011 = treat2007*year2011
	gen treat07_2014 = treat2007*year2014	
	
	gen treat08_2000 = treat2008*year2000
	gen treat08_2003 = treat2008*year2003
	gen treat08_2005 = treat2008*year2005
	gen treat08_2011 = treat2008*year2011
	gen treat08_2014 = treat2008*year2014	
		
	
	gen treat10_2000 = treat2010*year2000
	gen treat10_2003 = treat2010*year2003
	gen treat10_2005 = treat2010*year2005
	gen treat10_2011 = treat2010*year2011
	gen treat10_2014 = treat2010*year2014		
	
	
	gen treat11_2000 = treat2011*year2000
	gen treat11_2003 = treat2011*year2003
	gen treat11_2005 = treat2011*year2005
	gen treat11_2011 = treat2011*year2011
	gen treat11_2014 = treat2011*year2014		
	
	gen treat12_2000 = treat2012*year2000
	gen treat12_2003 = treat2012*year2003
	gen treat12_2005 = treat2012*year2005
	gen treat12_2011 = treat2012*year2011
	gen treat12_2014 = treat2012*year2014			
	
	gen treat13_2000 = treat2013*year2000
	gen treat13_2003 = treat2013*year2003
	gen treat13_2005 = treat2013*year2005
	gen treat13_2011 = treat2013*year2011
	gen treat13_2014 = treat2013*year2014
	

	gen treat_07081011_2000 = treat07_2000 + treat08_2000 + treat10_2000 + treat11_2000
	gen treat_07081011_2003 = treat07_2003 + treat08_2003 + treat10_2003 + treat11_2003
	gen treat_07081011_2005 = treat07_2005 + treat08_2005 + treat10_2005 + treat11_2005
	gen treat_07081011_2011 = treat07_2011 + treat08_2011 + treat10_2011 + treat11_2011
	gen treat_07081011_2014 = treat07_2014 + treat08_2014 + treat10_2014 + treat11_2014		
	
	gen treat_070810_2000 = treat07_2000 + treat08_2000 + treat10_2000
	gen treat_070810_2003 = treat07_2003 + treat08_2003 + treat10_2003
	gen treat_070810_2005 = treat07_2005 + treat08_2005 + treat10_2005
	gen treat_070810_2011 = treat07_2011 + treat08_2011 + treat10_2011
	gen treat_070810_2014 = treat07_2014 + treat08_2014 + treat10_2014
	
	gen treat_111213_2000 = treat11_2000 + treat12_2000 + treat13_2000
	gen treat_111213_2003 = treat11_2003 + treat12_2003 + treat13_2003
	gen treat_111213_2005 = treat11_2005 + treat12_2005 + treat13_2005
	gen treat_111213_2011 = treat11_2011 + treat12_2011 + treat13_2011
	gen treat_111213_2014 = treat11_2014 + treat12_2014 + treat13_2014	
	
	
gen treat_07081011_post = treat_07081011_2011 + treat_07081011_2014
gen post = treat_07081011_post + treat1213_2014 		
	
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************	
	
	gen intensity = 0
	replace intensity = 4 if treat2007 & year==2011
	replace intensity = 3 if treat2008 & year==2011
	replace intensity = 1 if treat2010 & year==2011
	replace intensity = 0 if treat2011 & year==2011
	replace intensity = 7 if treat2007 & year==2014
	replace intensity = 6 if treat2008 & year==2014
	replace intensity = 4 if treat2010 & year==2014
	replace intensity = 3 if treat2011 & year==2014	
	replace intensity = 2 if treat2012 & year==2014	
	replace intensity = 1 if treat2013 & year==2014	
	
	
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************	
		
		
		
	tab poor
	gen highpoverty = poor >= .1346154
	
	rename socorg2011  socorg
	replace socorg= n_socorg if year==2005
	
	
	*replace n_suicides = nsuicides if year==2005
	
	
    gen pop_size2000_2 = pop_size if year==2000
    qbys kecid2000: egen pop_size2000 = max(pop_size2000_2)	
	replace pop_size2000 = round(pop_size2000,1)
	
	  
	  foreach q in 2000 2003 2005 2011 2014{
	 cap  gen pop_`q' =pop_size if year==`q'
cap qbys kecid2000:	egen pop`q' = max(pop_`q')	
cap	gen nvillages_`q' =nvillages if year==`q'
cap qbys kecid2000:	egen nvillages`q' = max(nvillages_`q')

	  }
	  gen pop_size_alt=pop_size if year<2014
  	  replace pop_size_alt = (pop2011/nvillages2011 +  (3*(pop2011/nvillages2011 - pop2005/nvillages2005)/6))*nvillages2014 if year==2014

  	  replace pop_size = pop2011 +  (3*(pop2011 - pop2005)/6) if year==2014

		
	foreach var of  varlist Health gotong  n_educ asphaltroad n_hospital n_healthfacilities lighting  irrigation n_socorg n_actinst rel_org socorg{
	gen pc`var'= (`var'/pop_size)*100000
	}

	foreach var of  varlist  anycrime n_crime robbery theft looting prostitution violence rape drugabuse murder childsale  drugtraficking combustion fightcommunitygroups fightwithofficers  fightbetweenethnics fightother fightstudents{
	gen pc`var'= (`var'/pop_size)*100000
	}
	  
	
			foreach var of varlist pcn_socorg pcHealth pcn_crime  perc_farmers2005 suicide rural n_hospital n_maternhosp n_healthfacilities asphaltroad lighting  pop_size n_families perc_ele SD n_educ n_socorg n_actinst gotong rel_org n_crime{
			gen `var'2005 = `var' if year==2005
			qbys kecid2000: egen `var'baseline=max(`var'2005)
	}
		
			
	
	replace pcexp = pcexp*0.83/100000


	gen frac_suicide = suicideyes/nvillages

	sum  frac_suicide, d


	
	
		foreach var of varlist poor perc_farmers2005baseline pcexp pcHealthbaseline pcn_crimebaseline pcn_socorgbaseline pcn_educ{ 
		egen z`var' = std(`var')
		}
		
		foreach var of varlist poor perc_farmers2005baseline pcexp pcHealthbaseline pcn_crimebaseline pcn_socorgbaseline pcn_educ{ 
		gen t`var' = z`var'*year2011 + z`var'*year2014
		gen post_`var' = post*z`var'
		}
		
		
		  gen n_numberofsuicides = n_suicides2014 if year==2014
	  replace n_numberofsuicides = n_suicides2011 if year==2011
	  replace n_numberofsuicides = suicideyes if year==2005
	  replace n_numberofsuicides = suicideyes if year==2003
	  replace n_numberofsuicides = suicideyes if year==2000
	  
	  gen pop_sizebaseline20002 =pop_size if year==2000
	  qbys kecid:	egen pop_sizebaseline2000 = max(pop_sizebaseline20002)	
	  

	  
	  
	  
	  gen nsuicidespc2 = suicideyes/pop_size*100000  	
	  
	 gen n_numberofsuicidespc = n_numberofsuicides/pop_sizebaseline*100000 
	 gen nsuicidespc = n_numberofsuicides/pop_size*100000
	 gen nsuicidespc_alt = n_numberofsuicides/pop_size_alt*100000

	
	 gen n_numberofsuicides20052 = n_numberofsuicides if year==2005
	qbys kecid:	egen n_numberofsuicides2005 = max(n_numberofsuicides20052)	

	  
	 gen n_numberofsuicidespc20052 = n_numberofsuicidespc if year==2005
	qbys kecid:	egen n_numberofsuicidespc2005 = max(n_numberofsuicidespc20052)	

	foreach q in 2000 2003 2005 {
	 gen  nsuicidespc`q'2 = nsuicidespc  if year==`q'
	qbys kecid:	egen nsuicidespc`q' = max(nsuicidespc`q'2)	
	}


	foreach q in 2000 2003 2005 {
	 gen  suicideyes`q'2 = suicideyes  if year==`q'
	qbys kecid:	egen suicideyes`q' = max(suicideyes`q'2)	
	}

	foreach q in 2000 2003 2005 {
	 gen  nsuicidespc2`q'2 = nsuicidespc  if year==`q'
	qbys kecid:	egen nsuicidespc2`q' = max(nsuicidespc2`q'2)	
	}
	
	
	gen n_suicides_possion=-ln(1-frac_suicide)*nvillages
	
	*** Replace missing value for 1 observation when all villages have suicide ***
	gen temp1=n_suicides_possion/n_numberofsuicides
	bys kecid2000: egen temp=mean(temp1)
	replace  n_suicides_possion=temp*nvillages if n_suicides_possion==.
	drop temp*
	
        gen n_suicides_possionpc=n_suicides_possion/pop_size*100000

		
	
			foreach var of varlist nsuicidespc n_suicides_possion n_suicides_possionpc n_numberofsuicides n_numberofsuicidespc suicide nsuicidespc2{ 
			gen `var'_2005 = `var' if year==2005
			qbys kecid2000: egen `var'_baseline=max(`var'_2005)
	}	
	
	
	
	
		xtset kecid2000 year	
		keep if n2==5 // Restrict sample to balanced panel
	
		save "$data/podes_pkhrollout.dta", replace  

		

		

 
