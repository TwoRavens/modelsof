// This do-file contains the stata code used to construct the Analysis Dataset for 
// the analysis based on data from the European Social Survey (ESS).

clear 
set more off
version 13.1

	cd "C:/Users/lindgren_ko/Dropbox/Swedish Reform/GRRPaper/AJPSSub/AJPSRevision/AcceptedManuscript/ReplicationFiles/ESSAnalysis"
	
//The cumulative ESS file only includes a aggregated version of parental occupation, but 
//Harry Ganzeboom have used country specific info to provide isco88 codes for parents.
//We use these data to create EGP codes for parents in rounds 1-5 (codes for round 6 are
// at the time of writing not available).

// An SPSS version of this file was downloaded from Ganzeboom's homepage 
// http://www.harryganzeboom.nl/ESS-DEVO/index.htm at 2015-01-20. This file was then
// transferred to stata-format using R. 
	
	use ESS12345_fmisko_notext.dta, clear
		
//In Ireland there are 8 duplicates, drop these observations
	bysort cntry essround idno: egen cID=count(idno)	
	drop if cID>1
	drop cID
	
//Need to recode the variable indicating self-employment to fit the format in iskoegp.
//The variables fsempl and msempl seems to build on the variables emprf14 and emprm14
//in the ESS data. 1=Employed, 2=Self-employed, 3=Not employed. -1 seems to be refering
//to father dead/absent
	gen fSE=(fsempl==2) if fsempl>0 & fsempl<.
	gen mSE=(msempl==2) if msempl>0 & msempl<.
	
//Use iskoegp to obtain egp codes, fsupvis and msupvis seems to build on the info
//in the variables emplnof and emplnom.
	iskoegp fegp_ganz, isko(fisko) sempl(fSE) supvis(fsupvis)
	numlabel egp10, add
	
	iskoegp megp_ganz, isko(misko) sempl(mSE) supvis(msupvis)
	numlabel egp10, add
	
	label var fegp_ganz "EGP of father based on Ganzeboom's isco codes"
	label var megp_ganz "EGP of mother based on Ganzeboom's isco codes"
	
	keep cntry essround idno fisko misko fegp_ganz megp_ganz *supvis *sempl
	
//Recode the country codes to match the cumulative ESS file
	gen acntry="NA"
	replace acntry="AT" if cntry==1 
	replace acntry="BE" if cntry==2 
	replace acntry="BG" if cntry==3
	replace acntry="CH" if cntry==4
	replace acntry="CY" if cntry==5  
	replace acntry="CZ" if cntry==6
	replace acntry="DE" if cntry==7 
	replace acntry="DK" if cntry==8 
	replace acntry="EE" if cntry==9 
	replace acntry="ES" if cntry==10   
	replace acntry="FI" if cntry==11 
	replace acntry="FR" if cntry==12  
	replace acntry="GB" if cntry==13
	replace acntry="GR" if cntry==14  
	replace acntry="HR" if cntry==15 
	replace acntry="HU" if cntry==16 
	replace acntry="IE" if cntry==17 
	replace acntry="IL" if cntry==18  
	replace acntry="IS" if cntry==19 
	replace acntry="IT" if cntry==20   
	replace acntry="LT" if cntry==21
	replace acntry="LU" if cntry==23
	replace acntry="NL" if cntry==25
	replace acntry="NO" if cntry==26  
	replace acntry="PL" if cntry==27  
	replace acntry="PT" if cntry==28
	replace acntry="RU" if cntry==30  
	replace acntry="SE" if cntry==31  
	replace acntry="SI" if cntry==32
	replace acntry="SK" if cntry==33
	replace acntry="TR" if cntry==34  
	replace acntry="UA" if cntry==35 
	
	drop if acntry=="NA"
	
	drop cntry 
	rename acntry cntry	
	tempfile EGPData
	save `EGPData' 

//Read in the ESS cumulative file, rounds 1-6 downloaded from 
//http://www.europeansocialsurvey.org at 2015-01-21
	use ESS1-6e01_0_F1.dta, clear
	
//Merge on EGP data for rounds 1-5	
	merge 1:1 cntry essround idno using `EGPData'
	
//Drop all data from round 6 since we don't have information on parental occuptions
//for this round. 
	drop if essround==6
	
//Use the dominace order of Erikson to determine class position of the household
	gen fDom=.
	replace fDom=1 if fegp_ganz==1
	replace fDom=2 if fegp_ganz==11
	replace fDom=3 if fegp_ganz==4
	replace fDom=4 if fegp_ganz==5
	replace fDom=5 if fegp_ganz==2
	replace fDom=6 if fegp_ganz==3
	replace fDom=7 if fegp_ganz==7
	replace fDom=8 if fegp_ganz==8
	replace fDom=9 if fegp_ganz==9
	replace fDom=10 if fegp_ganz==10
	
	gen mDom=.
	replace mDom=1 if megp_ganz==1
	replace mDom=2 if megp_ganz==11
	replace mDom=3 if megp_ganz==4
	replace mDom=4 if megp_ganz==5
	replace mDom=5 if megp_ganz==2
	replace mDom=6 if megp_ganz==3
	replace mDom=7 if megp_ganz==7
	replace mDom=8 if megp_ganz==8
	replace mDom=9 if megp_ganz==9
	replace mDom=10 if megp_ganz==10
	
	gen hhegp_ganz=.
	replace hhegp=fegp_ganz if fegp_ganz<. & megp_ganz==.
	replace hhegp=megp_ganz if fegp_ganz==. & megp_ganz<.
	replace hhegp=fegp_ganz if emprf14==1 & emprm14>1 
	replace hhegp=megp_ganz if emprf14>1 & emprm14==1
	replace hhegp=fegp_ganz if emprf14==1 & emprm14==1 & fDom<=mDom
	replace hhegp=megp_ganz if emprf14==1 & emprm14==1 & fDom>mDom
	
	recode fegp (1 2 3 4 5 11 = 1) (7 8 9 10 = 0), gen(fClass2)
	recode fegp (1 2 3 4 5 11 = 1) (7 8 9 10 = 0), gen(mClass2)
	recode hhegp (1 2 3 4 5 11 = 1) (7 8 9 10 = 0), gen(hhClass2)
	recode hhegp (1 2 = 2) (3 4 5 11 =1) (7 8 9 10 = 0), gen(hhClass3)
	recode hhegp (1 2 = 4) (3 = 3) (4 5 = 2) (11 = 1) (7 8 9 10 = 0), gen(hhClass5)
			
//Recode the outcome variables to be used in the analysis
		gen PartyWork=100*(2-wrkprty)
		gen PartyMember=100*(2-mmbprty)
		
//Code compulsory School Reforms using the data presented in 
//Borgonovi, Francesca, Beatrice d'Hombres and Bryony Hoskins. 2010. "Voter Turnout,
//Information Acquisition and Education: Evidence from 15 European Countries." The
//B.E. Journal of Economic Analysis & Polic 10(1):1-31.
	
		gen Firstcohort=.
		replace Firstcohort=1947 if cntry=="AT"
		replace Firstcohort=1957 if cntry=="DK"
		replace Firstcohort=1953 if cntry=="FR"
		replace Firstcohort=1949 if cntry=="IT"
		replace Firstcohort=1963 if cntry=="GR"
		replace Firstcohort=1947 if cntry=="HU"
		replace Firstcohort=1959 if cntry=="NL"
		replace Firstcohort=1952 if cntry=="PL"
		replace Firstcohort=1951 if cntry=="PT"
		replace Firstcohort=1957 if cntry=="ES"
		replace Firstcohort=1958 if cntry=="GB"
		replace Firstcohort=1958 if cntry=="IE"
		replace Firstcohort=1950 if cntry=="SE"
		replace Firstcohort=1941 if cntry=="DE" & regionde==1
		replace Firstcohort=1934 if cntry=="DE" & regionde==2
		replace Firstcohort=1947 if cntry=="DE" & regionde==3
		replace Firstcohort=1943 if cntry=="DE" & regionde==4
		replace Firstcohort=1953 if cntry=="DE" & regionde==5
		replace Firstcohort=1953 if cntry=="DE" & regionde==6
		replace Firstcohort=1953 if cntry=="DE" & regionde==7
		replace Firstcohort=1953 if cntry=="DE" & regionde==8
		replace Firstcohort=1955 if cntry=="DE" & regionde==9
		replace Firstcohort=1949 if cntry=="DE" & regionde==10
		
		replace Firstcohort=1966 if cntry=="FI" & regioafi==1				 
		replace Firstcohort=1962 if cntry=="FI" & regioafi==2
		replace Firstcohort=1963 if cntry=="FI" & regioafi==3
		replace Firstcohort=1961 if cntry=="FI" & regioafi==4
		
//Construct variables used in the analysis.		
		gen Window=yrbrn-Firstcohort
		gen Reform=(Window>-1) if Firstcohort<.
		egen ncntry=group(cntry)
		egen nRegion=group(cntry regionde regioafi), missing

		fvset base 1943 yrbrn
		gen Male=-1*gndr+2
		
//Keep the variables to be used in the analysis
	keep PartyWork hhClass2 Male yrbrn ncntry essround cntry PartyMember brncntr ///
			 Reform Window idno

	label var hhClass2 "Parental class" 
	label var PartyWork "Did R do party work" 
	label var PartyMember "Is R a party member" 
	label var Window "Birth year of R in relation to the first affected cohort" 
	label var Reform "Was R subject to school reform" 
	label var Male	"Is R male"
	
	save ajps-DataTable3, replace		 
