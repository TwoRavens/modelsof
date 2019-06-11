


	clear
	*set mem 2g
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"

	
********** CREATE A CROSS-SECTION FOR THE FIRST PANEL YEAR ********************
	
	* 1) Extract a cross section from the first year in the panel	
	
		odbc load, exec("select ink=DispInk , ast=AstSNI92, labink=ForvErs, Sun2000niva, StudTyp, p_id=Person_LopNr, m_id=Kommun from P0624_Lisa_1990") dsn("P0624") clear
*drop students
		drop if StudTyp=="1"
		drop StudTyp
		gen year=1990
		*add data on political employemnt. Drop those that are, or have been, politically employed
		joinby p_id year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\post_pol_emp.dta", unmatched(master)
		drop if emp_pol_post==1
		drop _merge emp_pol_post
	
*transform income variables to real values
	gen ink_real= ink/0.795905 if year==1990
 	gen labink_real= labink/0.795905 if year==1990

*define dummy for tertiary education
	replace Sun2000niva="" if Sun2000niva=="*" | Sun2000niva=="-"
	destring Sun2000niva, replace force
	replace  Sun2000niva=. if Sun2000niva>=999

gen dum_educ_4=  Sun2000niva>=410 if Sun2000niva!=.

*define industry categories
destring ast, replace

gen     anst_15kat=.
replace anst_15kat= 1 if (ast>=1000 & ast<5000) 
replace anst_15kat= 2 if ast>=5000 & ast<10000
replace anst_15kat= 3 if ast>=10000 & ast<15000
replace anst_15kat= 4 if ast>=15000 & ast<40000
replace anst_15kat= 5 if ast>=40000 & ast<45000
replace anst_15kat= 6 if ast>=45000 & ast<50000
replace anst_15kat= 7 if ast>=50000 & ast<55000
replace anst_15kat= 8 if ast>=55000 & ast<60000
replace anst_15kat= 9 if ast>=60000 & ast<65000
replace anst_15kat= 10 if ast>= 65000 & ast<70000
replace anst_15kat= 11 if ast>= 70000 & ast<75000
replace anst_15kat= 12 if ast>=75000 & ast<80000
replace anst_15kat= 13 if ast>=80000 & ast<85000
replace anst_15kat= 14 if ast>=85000 & ast<90000
replace anst_15kat= 15 if ast>=90000 & ast<96000
replace anst_15kat= 12 if ast==99000


*add data on sex and birthyear, define variable for age and gender
joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\Birthyear_sex.dta", unmatched(master) _merge(_merge)
	
foreach var of varlist Kon  FodelseAr{
	destring `var', replace force
 }
 
gen kvinna=Kon==2
gen alder= year- FodelseAr
drop if alder<18


*define age catoegies, municipal dummies and dummies for the interaction betweeen education, age and industry
gen alder_5cat_ep=int(alder/5) if alder<65 
gen alder_5cat_p=int(alder/5) if alder>=65
egen ald_ed=group (alder_5cat educ_year)
tab m_id, gen(dum_k)
egen ast3_hog= group (anst_15kat educ_year alder_5cat_ep)

*define natural log of income
gen ln_labink_real=ln(labink_real)

*** run regression for men under 65
gen ink_aae_y10_emp_res=.
xi: areg ln_labink_real    dum_k*  if kvinna==0 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
*standardice residual
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid


*** run regression for women under 65
xi: areg ln_labink_real    dum_k* if kvinna==1 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
*standardice residual
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

****nothing for retired in this year since we do not have any observations of their occupation prior to retirement


save ink_res_yearly, replace
**********
*for the rest of the years we run the exact same code as for 1990 with the exeption for adding those retired to the analysys. This means that we 
*we will only provide descriptions for that part of the analysis
forvalues year=1991/2001 {
clear
		odbc load, exec("select ink=DispInk, labink=ForvErs , ast=AstSNI92, Sun2000niva, StudTyp, p_id=Person_LopNr, m_id=Kommun from P0624_Lisa_`year'") dsn("P0624") clear

		drop if StudTyp=="1"
		drop StudTyp
		gen year=`year'
		joinby p_id year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\post_pol_emp.dta", unmatched(master)
		drop if emp_pol_post==1
		drop _merge emp_pol_post
	
gen  ink_real= ink/0.8715 if year==1991
replace ink_real= ink/0.891446 if year==1992
replace ink_real= ink/0.932873 if year==1993
replace ink_real= ink/0.953203 if year==1994
replace ink_real= ink/0.977369 if year==1995
replace ink_real= ink/0.981972 if year==1996
replace ink_real= ink/0.986958 if year==1997
replace ink_real= ink/0.985807 if year==1998
replace ink_real= ink/0.990027 if year==1999
replace ink_real= ink/1 if year==2000
replace ink_real= ink/1.024549 if year==2001


gen  labink_real= labink/0.8715 if year==1991
replace labink_real= labink/0.891446 if year==1992
replace labink_real= labink/0.932873 if year==1993
replace labink_real= labink/0.953203 if year==1994
replace labink_real= labink/0.977369 if year==1995
replace labink_real= labink/0.981972 if year==1996
replace labink_real= labink/0.986958 if year==1997
replace labink_real= labink/0.985807 if year==1998
replace labink_real= labink/0.990027 if year==1999
replace labink_real= labink/1 if year==2000
replace labink_real= labink/1.024549 if year==2001


	replace Sun2000niva="" if Sun2000niva=="*" | Sun2000niva=="-"
	destring Sun2000niva, replace force
	replace  Sun2000niva=. if Sun2000niva>=999


gen dum_educ_4=  Sun2000niva>=410 if Sun2000niva!=.

destring ast, replace

gen     anst_15kat=.
replace anst_15kat= 1 if (ast>=1000 & ast<5000) 
replace anst_15kat= 2 if ast>=5000 & ast<10000
replace anst_15kat= 3 if ast>=10000 & ast<15000
replace anst_15kat= 4 if ast>=15000 & ast<40000
replace anst_15kat= 5 if ast>=40000 & ast<45000
replace anst_15kat= 6 if ast>=45000 & ast<50000
replace anst_15kat= 7 if ast>=50000 & ast<55000
replace anst_15kat= 8 if ast>=55000 & ast<60000
replace anst_15kat= 9 if ast>=60000 & ast<65000
replace anst_15kat= 10 if ast>= 65000 & ast<70000
replace anst_15kat= 11 if ast>= 70000 & ast<75000
replace anst_15kat= 12 if ast>=75000 & ast<80000
replace anst_15kat= 13 if ast>=80000 & ast<85000
replace anst_15kat= 14 if ast>=85000 & ast<90000
replace anst_15kat= 15 if ast>=90000 & ast<96000
replace anst_15kat= 12 if ast==99000


joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\Birthyear_sex.dta", unmatched(master) _merge(_merge)
	
	 foreach var of varlist Kon  FodelseAr{
 destring `var', replace force
 }
gen kvinna=Kon==2
gen alder= year- FodelseAr
drop if alder<18


gen alder_5cat_ep=int(alder/5) if alder<65 
gen alder_5cat_p=int(alder/5) if alder>=65

tab m_id, gen(dum_k)

egen ast3_hog= group (anst_15kat educ_year alder_5cat_ep)
egen topp_1pc=pctile(ink_real) , p(99)
gen ln_ink_real=ln(ink_real)
gen ln_labink_real=ln(labink_real)

***men under 65
gen ink_aae_y10_emp_res=.
xi: areg ln_labink_real    dum_k*  if kvinna==0 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid


***women under 65
xi: areg ln_labink_real    dum_k*  if kvinna==1 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

*****change code for retired
drop  ast3_hog _merge

*add data on main industrywhile working
joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\main occupation.dta", unmatched(master) 

*define new indicator for interaction between industry age and education
egen ast3_hog= group (ast_pens educ_year alder_5cat_p)

***** retired men

xi: areg ln_ink_real    dum_k* if kvinna==0  & alder>64 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

******retired women
xi: areg ln_ink_real    dum_k* if kvinna==1 & alder>64 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid





	 keep p_id year ink_aae_y10_emp_res 
 append using ink_res_yearly
save ink_res_yearly, replace
}

forvalues year=2002/2004 {
clear
		odbc load, exec("select ink=DispInk, labink=ForvErs , ast=AstSNI2002, Sun2000niva, StudTyp, p_id=Person_LopNr, m_id=Kommun from P0624_Lisa_`year'") dsn("P0624") clear

		drop if StudTyp=="1"
		drop StudTyp
	gen year=`year'
		joinby p_id year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\post_pol_emp.dta", unmatched(master)
		drop if emp_pol_post==1
		drop _merge emp_pol_post
	

gen ink_real= ink/1.046414 if year==2002
replace ink_real= ink/1.066743 if year==2003
replace ink_real= ink/1.070963 if year==2004

gen labink_real= labink/1.046414 if year==2002
replace labink_real= labink/1.066743 if year==2003
replace labink_real= labink/1.070963 if year==2004

	replace Sun2000niva="" if Sun2000niva=="*" | Sun2000niva=="-"
	destring Sun2000niva, replace force
	replace  Sun2000niva=. if Sun2000niva>=999


gen dum_educ_4=  Sun2000niva>=410 if Sun2000niva!=.

destring ast, replace

gen     anst_15kat=.
replace anst_15kat= 1 if (ast>=1000 & ast<5000) 
replace anst_15kat= 2 if ast>=5000 & ast<10000
replace anst_15kat= 3 if ast>=10000 & ast<15000
replace anst_15kat= 4 if ast>=15000 & ast<40000
replace anst_15kat= 5 if ast>=40000 & ast<45000
replace anst_15kat= 6 if ast>=45000 & ast<50000
replace anst_15kat= 7 if ast>=50000 & ast<55000
replace anst_15kat= 8 if ast>=55000 & ast<60000
replace anst_15kat= 9 if ast>=60000 & ast<65000
replace anst_15kat= 10 if ast>= 65000 & ast<70000
replace anst_15kat= 11 if ast>= 70000 & ast<75000
replace anst_15kat= 12 if ast>=75000 & ast<80000
replace anst_15kat= 13 if ast>=80000 & ast<85000
replace anst_15kat= 14 if ast>=85000 & ast<90000
replace anst_15kat= 15 if ast>=90000 & ast<96000
replace anst_15kat= 12 if ast==99000


joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\Birthyear_sex.dta", unmatched(master) _merge(_merge)
	
foreach var of varlist Kon  FodelseAr{
 destring `var', replace force
 }
gen kvinna=Kon==2
gen alder= year- FodelseAr
drop if alder<18

gen alder_5cat_ep=int(alder/5) if alder<65 
gen alder_5cat_p=int(alder/5) if alder>=65

tab m_id, gen(dum_k)

egen ast3_hog= group (anst_15kat educ_year alder_5cat_ep)

gen ln_ink_real=ln(ink_real)
gen ln_labink_real=ln(labink_real)

***men under 65
gen ink_aae_y10_emp_res=.
xi: areg ln_labink_real    dum_k*  if kvinna==0 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid


***women under 65
xi: areg ln_labink_real    dum_k*  if kvinna==1 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

*****change code for retired
drop  ast3_hog _merge

joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\main occupation.dta", unmatched(master) 

egen ast3_hog= group (ast_pens educ_year alder_5cat_p)

***** retired men

xi: areg ln_ink_real    dum_k* if kvinna==0  & alder>64 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

******retired women
xi: areg ln_ink_real    dum_k*  if kvinna==1 & alder>64 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid


gen pens = alder>64


	 keep p_id year ink_aae_y10_emp_res 
 append using ink_res_yearly
save ink_res_yearly, replace
}

forvalues year=2004/2010 {
clear
		odbc load, exec("select ink=DispInk04 , labink=ForvErs, ast=AstSNI2002, Sun2000niva, StudTyp, p_id=Person_LopNr, m_id=Kommun from P0624_Lisa_`year'") dsn("P0624") clear

		drop if StudTyp=="1"
		drop StudTyp
		gen year=`year'
		joinby p_id year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\post_pol_emp.dta", unmatched(master)
		drop if emp_pol_post==1
		drop _merge emp_pol_post
	

gen ink_real= ink/1.070963 if year==2004
replace ink_real= ink/1.075566 if year==2005
replace ink_real= ink/1.090219 if year==2006
replace ink_real= ink/1.114346 if year==2007
replace ink_real= ink/1.153088 if year==2008
replace ink_real= ink/1.149444 if year==2009
replace ink_real= ink/1.1641 if year==2010


gen labink_real= labink/1.070963 if year==2004
replace labink_real= labink/1.075566 if year==2005
replace labink_real= labink/1.090219 if year==2006
replace labink_real= labink/1.114346 if year==2007
replace labink_real= labink/1.153088 if year==2008
replace labink_real= labink/1.149444 if year==2009
replace labink_real= labink/1.1641 if year==2010


	replace Sun2000niva="" if Sun2000niva=="*" | Sun2000niva=="-"
	destring Sun2000niva, replace force
	replace  Sun2000niva=. if Sun2000niva>=999



gen dum_educ_4=  Sun2000niva>=410 if Sun2000niva!=.

destring ast, replace

gen     anst_15kat=.
replace anst_15kat= 1 if (ast>=1000 & ast<5000) 
replace anst_15kat= 2 if ast>=5000 & ast<10000
replace anst_15kat= 3 if ast>=10000 & ast<15000
replace anst_15kat= 4 if ast>=15000 & ast<40000
replace anst_15kat= 5 if ast>=40000 & ast<45000
replace anst_15kat= 6 if ast>=45000 & ast<50000
replace anst_15kat= 7 if ast>=50000 & ast<55000
replace anst_15kat= 8 if ast>=55000 & ast<60000
replace anst_15kat= 9 if ast>=60000 & ast<65000
replace anst_15kat= 10 if ast>= 65000 & ast<70000
replace anst_15kat= 11 if ast>= 70000 & ast<75000
replace anst_15kat= 12 if ast>=75000 & ast<80000
replace anst_15kat= 13 if ast>=80000 & ast<85000
replace anst_15kat= 14 if ast>=85000 & ast<90000
replace anst_15kat= 15 if ast>=90000 & ast<96000
replace anst_15kat= 12 if ast==99000


joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\Birthyear_sex.dta", unmatched(master) _merge(_merge)
	
	 foreach var of varlist Kon  FodelseAr{
 destring `var', replace force
 }
gen kvinna=Kon==2
gen alder= year- FodelseAr
drop if alder<18


gen alder_5cat_ep=int(alder/5) if alder<65 
gen alder_5cat_p=int(alder/5) if alder>=65

tab m_id, gen(dum_k)

egen ast3_hog= group (anst_15kat educ_year alder_5cat_ep)

gen ln_ink_real=ln(ink_real)
gen ln_labink_real=ln(labink_real)

***men under 65
gen ink_aae_y10_emp_res=.
xi: areg ln_labink_real    dum_k*  if kvinna==0 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid


***women under 65
xi: areg ln_labink_real    dum_k*  if kvinna==1 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

*****change code for retired
drop  ast3_hog _merge

joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\main occupation.dta", unmatched(master) 

egen ast3_hog= group (ast_pens educ_year alder_5cat_p)

***** retired men

xi: areg ln_ink_real    dum_k*  if kvinna==0  & alder>64 & ink_real>0 , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

******retired women
xi: areg ln_ink_real    dum_k* dum_e* if kvinna==1 & alder>64 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid


 keep p_id year ink_aae_y10_emp_res 
 append using ink_res_yearly
save ink_res_yearly, replace
}
forvalues year=2011/2012 {
clear
		odbc load, exec("select ink=DispInk04 , labink=ForvErs, ast=AstSNI2007, Sun2000niva, StudTyp, p_id=Person_LopNr, m_id=Kommun from P0624_Lisa_`year'") dsn("P0624") clear

		drop if StudTyp=="1"
		drop StudTyp
		gen year=`year'
		joinby p_id year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\post_pol_emp.dta", unmatched(master)
		drop if emp_pol_post==1
		drop _merge emp_pol_post
	

	gen  ink_real= ink/1.1945 if year==2011
	replace ink_real= ink/1.205 if year==2012
	
	gen  labink_real= labink/1.1945 if year==2011
	replace labink_real= labink/1.205 if year==2012


	replace Sun2000niva="" if Sun2000niva=="*" | Sun2000niva=="-"
	destring Sun2000niva, replace force
	replace  Sun2000niva=. if Sun2000niva>=999


gen dum_educ_4=  Sun2000niva>=410 if Sun2000niva!=.

destring ast, replace

gen     anst_15kat=.
replace anst_15kat= 1 if (ast>=1000 & ast<5000) 
replace anst_15kat= 2 if ast>=5000 & ast<10000
replace anst_15kat= 3 if ast>=10000 & ast<15000
replace anst_15kat= 4 if ast>=15000 & ast<40000
replace anst_15kat= 5 if ast>=40000 & ast<45000
replace anst_15kat= 6 if ast>=45000 & ast<50000
replace anst_15kat= 7 if ast>=50000 & ast<55000
replace anst_15kat= 8 if ast>=55000 & ast<60000
replace anst_15kat= 9 if ast>=60000 & ast<65000
replace anst_15kat= 10 if ast>= 65000 & ast<70000
replace anst_15kat= 11 if ast>= 70000 & ast<75000
replace anst_15kat= 12 if ast>=75000 & ast<80000
replace anst_15kat= 13 if ast>=80000 & ast<85000
replace anst_15kat= 14 if ast>=85000 & ast<90000
replace anst_15kat= 15 if ast>=90000 & ast<96000
replace anst_15kat= 12 if ast==99000


joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\Birthyear_sex.dta", unmatched(master) _merge(_merge)
	
	 foreach var of varlist Kon  FodelseAr{
 destring `var', replace force
 }
gen kvinna=Kon==2
gen alder= year- FodelseAr
drop if alder<18


gen alder_5cat_ep=int(alder/5) if alder<65 
gen alder_5cat_p=int(alder/5) if alder>=65
egen ald_ed=group (alder_5cat educ_year)
tab m_id, gen(dum_k)


egen ast3_hog= group (anst_15kat educ_year alder_5cat_ep)
egen topp_1pc=pctile(ink_real) , p(99)
gen ln_ink_real=ln(ink_real)
gen ln_labink_real=ln(labink_real)


***men under 65
gen ink_aae_y10_emp_res=.
xi: areg ln_labink_real    dum_k*  if kvinna==0 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid


***women under 65
xi: areg ln_labink_real    dum_k*  if kvinna==1 & ast!=75111 & ast!=0 & alder<65 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

*****change code for retired
drop  ast3_hog _merge

joinby p_id using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\main occupation.dta", unmatched(master) 

egen ast3_hog= group (ast_pens educ_year alder_5cat_p)

***** retired men

xi: areg ln_ink_real    dum_k* dum_e* if kvinna==0  & alder>64 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid

******retired women
xi: areg ln_ink_real    dum_k* dum_e* if kvinna==1 & alder>64 & ink_real>0  , abs( ast3_hog )
predict resid, resid
egen z_resid=std(resid)
replace ink_aae_y10_emp_res=z_resid if  ink_aae_y10_emp_res==. &z_resid!=.
drop resid z_resid


	 keep p_id year ink_aae_y10_emp_res 
 append using ink_res_yearly
save ink_res_yearly, replace
}

***in the final step we first remove outliers.
drop if ink_aae_y10_emp_res==. & ink_res_pens==.
replace ink_aae_y10_emp_res=. if abs(ink_aae_y10_emp_res)>5
replace ink_res_pens=. if abs(ink_res_pens)>5
gen inc_res_b=ink_aae_y10_emp_res
replace inc_res_b= ink_res_pens if inc_res_b==.

drop if ink_aae_y10_emp_res==. & ink_res_pens==.

*we then take average of income residual for each individual across all non-missing years
collapse (mean) inc_res_b, by (p_id)


*standardize income residual

egen inc_res=std( inc_res_b)


keep p_id  inc_res
save "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\income residual new.dta", replace

