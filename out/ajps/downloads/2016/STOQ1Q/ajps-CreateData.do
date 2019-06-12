// Do file that contains the code to create the dataset used for the main analyses.
// The data come from different registers held by Statistics Sweden. The original
// data are read in from SQL-tables using statas odbc load command. 

log using "\\micro.intra\projekt\P0559$\P0559_gem\Dofiles_AJPS\Logfiles\ajps-CreateData.log", text replace

// Read in data from the 1960 Census (FoB60)
clear all 
#delimit ;
	odbc load, exec ("SELECT 
		[LopNr]
		,[FodelseManad]
		,[Lan]
		,[Kommun]
		,[Forsamling]
		,[Civil]
		,[Yrke]
		,[TrangBo]
		,[Utbild]
		,[YrkeStall]
		,[Narg]
		,[Syss]
		,[Personbil]
		,[SEI]
		,[UpplForm]
		,[AgarKat]
		,[AntBoHh]
		,[AntalBarn_0_15] 
		FROM ArvPolitiker_Lev_FoB_1960") 
				dsn("P0559_UU_LISA_Adoption");
	#delimit cr
	
	destring _all, replace
	compress
	gen FoBAr=1960

	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FoB60.dta", replace
	
// Read in data from the 1965 Census (FoB65)
	clear all
	#delimit ;
	odbc load, exec ("SELECT 
		[LopNr]
      ,[FodelseManad]
      ,[Lan]
      ,[Kommun]
      ,[Forsamling]
      ,[Civil]
      ,[TrangBo1]
      ,[TrangBo2]
      ,[YrkeSt]
      ,[Narg]
      ,[Syss]
      ,[UpplForm]
      ,[AgarKat]
      ,[AntHhMedl]
      ,[AntalBarn_0_15]
	FROM ArvPolitiker_Lev_FoB_1965") 
				dsn("P0559_UU_LISA_Adoption");
	#delimit cr
	
	destring _all, replace
	compress
	gen FoBAr=1965
	
	append using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FoB60.dta"
	
	bysort LopNr FoBAr: egen cID=count(FoBAr)
	drop if cID>1
	drop cID
	
//Read in data from the 1970 Census (FoB70)
	
	preserve
	clear all 

	#delimit ;
	odbc load, exec ("SELECT 
		[LopNr]
      ,[FodelseManad]
      ,[Lan]
      ,[Kommun]
      ,[Forsamling]
      ,[Civil]
      ,[Yrke]
      ,[TrangBo1]
      ,[TrangBo2]
      ,[UtbNiva]
      ,[YrkeStall]
      ,[Sni4]
      ,[Syss]
      ,[AntBilar]
      ,[SEI]
      ,[UpplForm]
      ,[AgarKat]
      ,[ArbInk]
      ,[SamRakNetInk]
      ,[AntBoHh]
      ,[AntalBarn_0_15]
	  FROM ArvPolitiker_Lev_FoB_1970") 
				dsn("P0559_UU_LISA_Adoption");
	#delimit cr

	keep LopNr UtbNiva SamRakNetInk ArbInk FodelseManad
	rename UtbNiva Utb70 
	rename SamRakNetInk NetInk70 
	rename ArbInk ArbInk70
	rename FodelseManad FodelseManad70
	destring Utb70 FodelseManad70, replace
	bysort LopNr: egen cID=count(LopNr)
	drop if cID>1
	drop cID 
	
	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-UtbFob70.dta", replace
	restore
	
	merge m:1 LopNr using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-UtbFob70.dta"
	drop if _merge==2
	drop _merge
	
// Read in data with information on time and country of birth
	preserve 
	clear all
	#delimit ;
	odbc load, exec ("SELECT 
		[LopNr]
		,[FodelseManad]
		,[Kon]
		,[UtlSvBakg]
		,[Fodelseland_IFAU]
		,[AterPNr] 
		FROM ArvPolitiker_Lev_FodelseUppg") 
				dsn("P0559_UU_LISA_Adoption");
	#delimit cr
	rename FodelseManad RTBFodelseManad
	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FodelseUppg.dta", replace
	restore 
	
	merge m:1 LopNr using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FodelseUppg.dta"
	keep if _merge==3
	drop _merge
	
//In  about 4000 cases birthmonth is different in RTB and FoB, use RTB for these individuals
//in most cases the difference is only a one or two months.	
	destring RTBFodelseManad, replace
	replace FodelseManad=RTBFodelseManad if FodelseManad!=RTBFodelseManad
	drop RTBFodelseManad
	destring Fodelseland_IFAU UtlSvBakg Kon, replace

//Use the algorithm developed by Jan O Jonsson to map occupational codes to SEI82 codes
	include "\\micro.intra\projekt\P0559$\P0559_gem\Dofiles_AJPS\ajps-Yrke2SEI.do"
	
	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FoB6065.dta", replace

//Keep all individuals born 1938-1958 in FoB60 and FoB65	
	keep if inrange(FodelseManad, 193801, 195812)
	
	bysort LopNr: egen cID=count(FoBAr)
	
// Drop a couple of hundred individuals for which there are repeated obs in the FoBs
	drop if cID>2

	keep if FoBAr==1960
	drop cID
	compress
	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-GrundRefSample.dta", replace

//Read in file containing information om final reform status obtained from Helena Holmlund
	preserve
	insheet using "\\Mfso01\p0437_gem$\Datasets\SQLtoStata\slutgiltiga_reformkommuner_fob60.out", clear
	save \\Mfso01\p0437_gem$\Datasets\Temporary\x-HolmlundCoding.dta, replace
	restore
	
/*******************************Code reform status according to FOB60********************************/
	
	gen kommun60=Kommun
	gen forsamling60=Forsamling
	gen FoddAr=floor(FodelseManad/100)
	merge m:1 kommun60 using \\Mfso01\p0437_gem$\Datasets\Temporary\x-HolmlundCoding.dta
	
// Use Holmlund's stata code to assigne reform status

*Generate a dummy variable for each individual for reform participation.
*------------------------------------------------------------------------

	gen experiment=.
	replace experiment=1 if (FoddAr>=firstcohort60 & firstcohort60~=.)

	replace experiment=0 if (FoddAr<firstcohort60 & firstcohort60~=.)


*Drop unclear municipalities/parishes:
*----------------------------------------

	replace experiment=. if forsamling60==18017	/*hägersten*/
	replace experiment=. if forsamling60==18018	/*brännkyrka*/
	replace experiment=. if forsamling60==18019	/*vantör*/
	replace experiment=. if forsamling60==18020	/*enskede*/
	replace experiment=. if forsamling60==18021	/*skarpnäck*/
	replace experiment=. if forsamling60==18022	/*farsta*/

	replace experiment=. if kommun60==281	/*södertälje*/
	replace experiment=. if kommun60==283	/*sundbyberg*/
	replace experiment=. if kommun60==580	/*linköping*/
	replace experiment=. if kommun60==680	/*jönköping*/

	replace experiment=. if forsamling60==128007	/*limhamn*/
	replace experiment=. if kommun60==1283	/*hälsingborg*/

	replace experiment=. if forsamling60==148016	/*örgryte*/
	replace experiment=. if forsamling60==148017	/*lundby*/
	replace experiment=. if forsamling60==148019	/*brämaregården*/
	replace experiment=. if forsamling60==148003	/*gamlestads=st pauli*/
	replace experiment=. if forsamling60==148006	/*härlanda*/

	replace experiment=. if kommun60==2482		/*skellefteå*/

	rename experiment RefStatus13ar
	label var RefStatus13ar "Reform status based on FOB closest to 13 years"
	rename firstcohort60 firstcohort_13ar
	drop kommun60 _merge forsamling60
	
	bysort LopNr: egen cID=count(FoBAr)
	drop if cID>1
	drop cID
	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-GrundRefSample.dta", replace
	
// Get information on parents for the index persons
	clear all
	#delimit ;
	odbc load, exec ("SELECT 
	   [LopNr_AdBarn]
      ,[LopNr_AdMor]
      ,[LopNr_AdFar]
      ,[DatFranAdMor]
      ,[DatTillAdMor]
      ,[DatFranAdFar]
      ,[DatTillAdFar]
	  FROM ArvPolitiker_Lev_AdBarn") 
				dsn("P0559_UU_LISA_Adoption");
	#delimit cr
	
	keep LopNr_AdBarn LopNr_AdMor LopNr_AdFar
	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-AdBarn.dta", replace
	
	clear all
	#delimit ;
	odbc load, exec ("SELECT  
	   [LopNr_BioBarn]
      ,[LopNr_BioMor]
      ,[LopNr_BioFar]
      ,[OrdNrMor]
      ,[OrdNrFar] 
	  FROM ArvPolitiker_Lev_BioBarn") 
				dsn("P0559_UU_LISA_Adoption");
	#delimit cr
	
	append using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-AdBarn.dta"
	gen long LopNr=LopNr_BioBarn
	replace LopNr=LopNr_AdBarn if !mi(LopNr_AdBarn)
	bysort LopNr: egen cID=count(LopNr)

//Drop 1 individual that was adopted twice
	drop if cID==3
	
//Use adoptive parents as "parents" for adopted children
	bysort LopNr: egen long mBioMor=max(LopNr_BioMor)
	bysort LopNr: egen long mAdMor=max(LopNr_AdMor)
	bysort LopNr: egen long mBioFar=max(LopNr_BioFar)
	bysort LopNr: egen long mAdFar=max(LopNr_AdFar)
	
	gen LopNr_Mor=mBioMor 
	gen LopNr_Far=mBioFar
	replace LopNr_Mor=mAdMor if !mi(mAdMor)
	replace LopNr_Far=mAdFar if !mi(mAdFar)
	gen Adopterad=(mAdFar<. | mAdMor<.)
	duplicates drop LopNr LopNr_Mor LopNr_Far, force
	keep LopNr LopNr_Mor LopNr_Far Adopterad OrdNrMor OrdNrFar
	
	merge 1:1 LopNr using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-GrundRefSample.dta"
	keep if _merge==3
	drop _merge
	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-GrundRefSample.dta", replace
	
//Merge on data on parents occupation, SEI and Education from FoB60 (are not available in FoB65)
	preserve
		renvars _all, prefix(B) 
		rename BLopNr_Far LopNr
		rename BLopNr LopNrBarn
		rename BFoBAr FoBAr
		replace FoBAr=1960
		drop B*
		merge m:1 LopNr FoBAr using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FoB6065.dta"
		keep if _merge==3
		keep LopNr LopNrBarn FodelseManad Narg Syss UpplForm Yrke TrangBo Utb* YrkeStall Personbil SEI* ArbInk NetInk Fors Agar Ant* Civil
		renvars _all, postfix(_Far60)
		rename LopNr_Far60 LopNr_Far
		rename LopNrBarn_Far60 LopNr
		codebook LopNr, compact
		save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FarFob60.dta", replace
	restore	
	
	preserve
		renvars _all, prefix(B) 
		rename BLopNr_Mor LopNr
		rename BLopNr LopNrBarn
		rename BFoBAr FoBAr
		replace FoBAr=1960
		drop B*
		merge m:1 LopNr FoBAr using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FoB6065.dta"
		keep if _merge==3
		keep LopNr LopNrBarn FodelseManad Narg Syss UpplForm Yrke TrangBo Utb* YrkeStall Personbil SEI* ArbInk NetInk Fors Agar Ant* Civil
		renvars _all, postfix(_Mor60)
		rename LopNr_Mor60 LopNr_Mor
		rename LopNrBarn_Mor60 LopNr
		codebook LopNr, compact
		save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-MorFob60.dta", replace
	restore	
	
	merge 1:1 LopNr using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-FarFob60.dta"
	drop _merge
	merge 1:1 LopNr using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-MorFob60.dta"
	drop _merge
	compress
	save "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-GrundRefSample.dta", replace
	
// Merge on data from LISA for the years with general elections
	clear all
	include "\\micro.intra\projekt\P0559$\P0559_gem\Dofiles_AJPS\ajps-LisaValAr.do"
	renvars _all, prefix(L)
	rename LLopNr LopNr
	rename LAr Ar
	
	merge m:1 LopNr using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-GrundRefSample.dta" ///
		, keepusing(LopNr Kon Utl FodelseManad RefS firstcohort LopNr_Mor LopNr_Far Kommun AntBoHh FodelseManad_Far60 Civil_Far60 ///
		Syss_Far60 Yrke_Far60 TrangBo_Far60 Utbild_Far60 AntBoHh_Far60 Utb70_Far60 ArbInk70_Far60 ///
		NetInk70_Far60 SEI82_Far60 FodelseManad_Mor60 Civil_Mor60 Syss_Mor60 Yrke_Mor60 ///
		TrangBo_Mor60 Utbild_Mor60 AntBoHh_Mor60 Utb70_Mor60 ArbInk70_Mor60 NetInk70_Mor60 SEI82_Mor60) keep(3)
	
	keep if _merge==3
	drop _merge
	
//Merge on political candidacy data
	preserve
	include "\\micro.intra\projekt\P0559$\P0559_gem\Dofiles_AJPS\ajps-NomData" //combine and clean the candidacy data
	restore
	
	merge 1:m LopNr Ar using "\\micro.intra\projekt\P0559$\P0559_gem\Datasets\Temporary\x-Nom9110.dta"
	drop if _merge==2
	
	replace Nominerad=0 if Nom==.
	replace Vald=0 if Vald==.
	
	// Create a SEI measure on the household level based on FoB60 data.
// Here we follow the procedure described in SCB MIS 1982: 4
	
// If only one of the parents is working use the class belonging of that individual
	gen SEI82_hh=.
	replace SEI82_hh=SEI82_Far60 if inrange(Yrke_Far60,1,999) & !inrange(Yrke_Mor60,1,999)
	replace SEI82_hh=SEI82_Mor60 if !inrange(Yrke_Far60,1,999) & inrange(Yrke_Mor60,1,999)

// If both parents are working we need to use the dominance relationship described in MIS 1982: 4
	gen DomOrd_far=.
	replace DomOrd_far=1 if SEI82_Far60==60
	replace DomOrd_far=2 if SEI82_Far60==56
	replace DomOrd_far=3 if SEI82_Far60==89
	replace DomOrd_far=4 if SEI82_Far60==79
	replace DomOrd_far=5 if SEI82_Far60==46
	replace DomOrd_far=6 if SEI82_Far60==36
	replace DomOrd_far=7 if SEI82_Far60==21
	replace DomOrd_far=8 if SEI82_Far60==11
	
	gen DomOrd_mor=.
	replace DomOrd_mor=1 if SEI82_Mor60==60
	replace DomOrd_mor=2 if SEI82_Mor60==56
	replace DomOrd_mor=3 if SEI82_Mor60==89
	replace DomOrd_mor=4 if SEI82_Mor60==79
	replace DomOrd_mor=5 if SEI82_Mor60==46
	replace DomOrd_mor=6 if SEI82_Mor60==36
	replace DomOrd_mor=7 if SEI82_Mor60==21
	replace DomOrd_mor=8 if SEI82_Mor60==11
	
	replace SEI82_hh=SEI82_Far60 if DomOrd_far==DomOrd_mor & inrange(Yrke_Far60,1,999) & inrange(Yrke_Mor60,1,999)
	replace SEI82_hh=SEI82_Far60 if DomOrd_far<DomOrd_mor & inrange(Yrke_Far60,1,999) & inrange(Yrke_Mor60,1,999)
	replace SEI82_hh=SEI82_Mor60 if DomOrd_far>DomOrd_mor & inrange(Yrke_Far60,1,999) & inrange(Yrke_Mor60,1,999)
	
// Create variable that can be used to care of the fact that some individuals have multiple nominations the same year	
	bysort LopNr Ar: gen cID=_n 
	
	bysort LopNr Ar: egen maxVald=max(Vald)
	bysort LopNr Ar: egen maxNom=max(Nom)
	
// Create birth year variables
	gen FodelseAr=floor(FodelseManad/100)
	gen FodelseAr_far=floor(FodelseManad_Far60/100)
	gen FodelseAr_mor=floor(FodelseManad_Mor60/100)
	
// Create various aggregates of SEI82_hh
	gen Klass7=.
	replace Klass7=7 if inlist(SEI82_hh, 56, 60)
	replace Klass7=6 if inlist(SEI82_hh, 46)
	replace Klass7=5 if inlist(SEI82_hh, 79)
	replace Klass7=4 if inlist(SEI82_hh, 89)
	replace Klass7=3 if inlist(SEI82_hh, 36)
	replace Klass7=2 if inlist(SEI82_hh, 21)
	replace Klass7=1 if inlist(SEI82_hh, 11)
	
	label define klass7 7 "H_Tjm" 6 "M_Tjm" 5 "EgFor" 4 "Jbruk" 3 "L_Tjm" 2 "K_Arb" 1 "OK_Arb"
	label values Klass7 klass7
	
	gen Klass3=.
	replace Klass3=3 if inlist(SEI82_hh, 79, 89)
	replace Klass3=2 if inlist(SEI82_hh, 60, 56, 46, 36)
	replace Klass3=1 if inlist(SEI82_hh, 21, 11)
	
	label define klass3 3 "EgFor" 2 "Tjm" 1 "Arb"
	label values Klass3 klass3
	
	gen Klass2=.
	replace Klass2=1 if inlist(SEI82_hh, 79, 89, 60, 56, 46, 36)
	replace Klass2=0 if inlist(SEI82_hh, 21, 11)
	label define klass2 1 "EjArb" 0 "Arb"
	label values Klass2 klass2
	
//	Create a variable coding each cohort in relation to the timing of the reform
	gen ReformAr=FodelseAr-firstcohort
	
//	Create a variable with years of education
	destring LSun2000niva, replace
	gen UtbAr=7 if LSun2000niva<200
	replace UtbAr=9 if inrange(LSun2000niva,200,299)
	replace UtbAr=9.5 if LSun2000niva==204
	replace UtbAr=10 if inrange(LSun2000niva,310,319)
	replace UtbAr=11 if inrange(LSun2000niva,320,329)
	replace UtbAr=12 if inrange(LSun2000niva,330,339)
	replace UtbAr=13 if inrange(LSun2000niva,410,419)
	replace UtbAr=14 if inrange(LSun2000niva,520,529)
	replace UtbAr=15 if inrange(LSun2000niva,530,539)
	replace UtbAr=16 if inrange(LSun2000niva,540,549)
	replace UtbAr=17 if inrange(LSun2000niva,550,559)
	replace UtbAr=18 if inrange(LSun2000niva,600,629)
	replace UtbAr=19 if inrange(LSun2000niva,640,649)
	
	save "\\micro.intra\projekt\P0559$\P0559_gem\Data_AJPS\AJPSData.dta", replace

log close
