/*
23 June 2016

Var description	2008 Variable	2013 Variable
km of national paved roads	B1	B1
km of regional paved roads	B2	B2
Km of local paved roads	B3	B3
Km of communal paved roads	B4	B4
Km of national dirt roads	B5	B5
Km of regional dirt roads	B6	B6
Presence of EDM electricity 	D1	D1
Localities with EDM electricity 	D2	D2
Presence of AMADER electricity	D11	D8
Localities with AMADER electricity	D12	D9
Presence of a multifunctional platform (MF)	D8	D5
Number of MF	D9	D6
Localities with MF	D10	D7
Covered by SOTELMA phone network	C1	C1
Number of localities SOTELMA	C2	C2
Covered by MALITEL phone network	C5	C3
Number of localities MALITEL	C6	C4
Covered by ORANGE phone network	C7	C5
Number of localities ORANGE	C8	C6

*/


capture cd "D:\Users\bholtemeyer\Dropbox (IFPRI)\Mali\Data\Commune data"	// change as necessary
capture cd "Dropbox\Research\Mali audit\Data\Commune data"	

qui {
cap  program drop genVarsV2
program genVarsV2, rclass
syntax, year(int)	road1(str) road2(str)  		boreh(str)   mayedu(str) ///
		school1(str) school2(str) school3(str)  ///
		clinic1(str) clinic2(str) clinic3(str)	///
		proj1(str) proj2(str) electr(str) paved(str) region(str) 	///
				///	new vars: 
		nat_paved_road(str)					///	
		reg_paved_road(str)					///			
		loc_paved_road(str)					///			
		com_paved_road(str)					///				
		nat_dirt_road(str)					///
		reg_dirt_road(str)					///
		EDM_elect(str)						///
		EDM_elect_locality(str)				///
		AMADER_elect(str)					///
		AMADER_elect_locality(str)			///
		MF(str)								///
		qty_MF(str)							///
		MF_locality(str)					///
		SOTELMA_phone(str) 					///
		SOTELMA_locality(str)				///
		MALITEL_phone(str)					///
		MALITEL_locality(str)				///
		ORANGE_phone(str) 					///
		ORANGE_locality(str)				
		
	g	boreh_`year'	= `boreh'
	g	road_`year'		= `road1'   + `road2'
	g	mayedu_`year'	= `mayedu' 
	
	g	school1_`year'	=	`school1'
	g	school2_`year'	=	`school2'
	g	school3_`year'	=	`school3'
	
	g	clinic1_`year'	=	`clinic1'
	g	clinic2_`year'	=	`clinic2'
	g	clinic3_`year'	=	`clinic3'

	g	road1_`year'	=	`road1'
	g	road2_`year'	=	`road2'
	
	g	region_`year'	= `region'
	g	proj_`year'		= `proj1' + `proj2'	
	g	electr_`year'	= `electr'	
	g	paved_`year'	= `paved'	

	lab var	boreh_`year'	"`year': boreholes"
	
	lab var	school1_`year'	"`year': public schools"
	lab var	school2_`year'	"`year': community schools"
	lab var	school3_`year'	"`year': adult literacy centers"
	
	lab var	clinic1_`year'	"`year': public clinics"
	lab var	clinic2_`year'	"`year': localities with a maternity"
	lab var	clinic3_`year'	"`year': CSCOM "
	
	lab var	road1_`year'	"`year': roads (km)"
	lab var	road2_`year'	"`year': paths (km)"
	
	lab var	mayedu_`year'	"`year': mayor's education"
		
	lab var region_`y'		"`year': region variable"
	lab var proj_`y' 		"`year': NGO or development projects"
	lab var electr_`y' 		"`year': level of electrification"
	lab var paved_`y'  		"`year': pct of kms of local roads paved"
	
	
	**new vars (added 6/23/2016)
	
	
	gen nat_paved_road_`year'				=	`nat_paved_road'
	gen reg_paved_road_`year'				=	`reg_paved_road'
	gen loc_paved_road_`year'				=	`loc_paved_road'
	gen com_paved_road_`year'				=	`com_paved_road'
	gen nat_dirt_road_`year'				=	`nat_dirt_road'
	gen reg_dirt_road_`year'				=	`reg_dirt_road'
	gen EDM_elect_`year'					=	`edm_elect'
	gen EDM_elect_locality_`year'			=	`edm_elect_locality'
	gen AMADER_elect_`year'					=	`amader_elect'
	gen AMADER_elect_locality_`year'		=	`amader_elect_locality'
	gen MF_`year'							=	`mf'
	gen qty_MF_`year'						=	`qty_MF'
	gen MF_locality_`year'					=	`mf_locality'
	gen SOTELMA_phone_`year' 				=	`sotelma_phone'
	gen SOTELMA_locality_`year'				=	`sotelma_locality'
	gen MALITEL_phone_`year'				=	`malitel_phone'
	gen MALITEL_locality_`year'				=	`malitel_locality'
	gen ORANGE_phone_`year' 				=	`orange_phone'
	gen ORANGE_locality_`year'				=	`orange_locality'
	
	lab var nat_paved_road_`year'				"`year': km of national paved roads"
	lab var reg_paved_road_`year'				"`year': km of regional paved roads"
	lab var loc_paved_road_`year'				"`year': Km of local paved roads"
	lab var com_paved_road_`year'				"`year': Km of communal paved roads"
	lab var nat_dirt_road_`year'				"`year': Km of national dirt roads"
	lab var reg_dirt_road_`year'				"`year': Km of regional dirt roads"
	lab var EDM_elect_`year'					"`year': Presence of EDM electricity"
	lab var EDM_elect_locality_`year'			"`year': Localities with EDM electricity"
	lab var AMADER_elect_`year'					"`year': Presence of AMADER electricity"
	lab var AMADER_elect_locality_`year'		"`year': Localities with AMADER electricity"
	lab var MF_`year'							"`year': Presence of a multifunctional platform (MF)"
	lab var qty_MF_`year'						"`year': Number of MF"
	lab var MF_locality_`year'					"`year': Localities with MF"
	lab var SOTELMA_phone_`year' 				"`year': Covered by SOTELMA phone network"
	lab var SOTELMA_locality_`year'				"`year': Number of localities SOTELMA"
	lab var MALITEL_phone_`year'				"`year': Covered by MALITEL phone network"
	lab var MALITEL_locality_`year'				"`year': Number of localities MALITEL"
	lab var ORANGE_phone_`year' 				"`year': Covered by ORANGE phone network"
	lab var ORANGE_locality_`year'				"`year': Number of localities ORANGE"

	#delimit ;
		return loc newvars = "
		school?_`year'	
		clinic?_`year' 	
		road?_`year'  		
		boreh_`year'   
		mayedu_`year' 
		region_`year' 
		proj_`year' 
		electr_`year' 
		paved_`year'
		
		nat_paved_road_`year'		
		reg_paved_road_`year'		
		loc_paved_road_`year'		
		com_paved_road_`year'		
		nat_dirt_road_`year'	
		reg_dirt_road_`year'		
		EDM_elect_`year'		
		EDM_elect_locality_`year'
		AMADER_elect_`year'
		AMADER_elect_locality_`year'
		MF_`year'
		qty_MF_`year'
		MF_locality_`year'
		SOTELMA_phone_`year'
		SOTELMA_locality_`year'
		MALITEL_phone_`year'
		MALITEL_locality_`year'
		ORANGE_phone_`year'
		ORANGE_locality_`year'";
	#delimit cr
	end
}
********************
//2013 data
********************
qui {
use "2013\BASE IPC 2013 Version du 31mars_Analyse.dta" ,clear
genVarsV2, 	year(2013)		///
				road1("B9")		///
				road2("B8")		///
			boreh("E7") 	///
				school1("H1_1")	///
				school2("H1_3")	///
				school3("H17") 	///
			clinic1("J3") 	///
			clinic2("J9") 	///
			clinic3("J13") 	///
				mayedu("MA5") 	///
				proj1("MA19") 		///
				proj2("MA20")    ///
				electr(".") 	///
				paved(".") 		///
				region("region") 	///
				///
		nat_paved_road("B1")				///	
		reg_paved_road("B2")				///			
		loc_paved_road("B3")				///			
		com_paved_road("B4")				///				
		nat_dirt_road("B5")					///
		reg_dirt_road("B6")					///
		edm_elect("D1")						///
		edm_elect_locality("D2")			///
		amader_elect("D8")					///
		amader_elect_locality("D9")			///
		mf("D5")							///
		qty_MF("D6")						///
		mf_locality("D7")					///
		sotelma_phone("C1")					///
		sotelma_locality("C2")				///
		malitel_phone("C3")					///
		malitel_locality("C4")				///
		orange_phone("C5") 					///
		orange_locality("C6")	
		
keep  	commune	`r(newvars)' 
drop electr paved
}
tempfile data_2013_tf
sa		`data_2013_tf'

********************
//2008 data
********************
qui {
use "2008\Base IPC2008_V3_calcul IPC.dta" , clear
genVarsV2, 	year(2008)				///
				road1("B11") 			///
				road2("B8") 			///
			boreh("E7") 			///
				school1("H1_PUBLIC") 	///
				school2("H1_COMMUNAUT") ///
				school3("H20") 			///
			clinic1("J3") 			///
			clinic2("J9") 			///
			clinic3("J18") 			///
				mayedu("M19")			///	
				proj1("M9") 		///
				proj2("M10") 		///
				electr("telect") 		///
				paved("tbitume") 		///
				region("region") 		///
							///
		nat_paved_road("B1")				///	
		reg_paved_road("B2")				///			
		loc_paved_road("B3")				///			
		com_paved_road("B4")				///				
		nat_dirt_road("B5")					///
		reg_dirt_road("B6")					///
		edm_elect("D1")						///
		edm_elect_locality("D2")			///
		amader_elect("D11")					///
		amader_elect_locality("D12")		///
		mf("D8")							///
		qty_MF("D9")						///
		mf_locality("D10")					///
		sotelma_phone("C1")					///
		sotelma_locality("C2")				///
		malitel_phone("C5")					///
		malitel_locality("C6")				///
		orange_phone("C7") 					///
		orange_locality("C8")	
		
g	commune = idcomm
g	dm_urban_2008= (A1==1)
lab var dm_urban_2008 "2008: dummy - urban"
keep  	commune	`r(newvars)' dm_urban
}
mer 1:1 commune using `data_2013_tf', assert(3) nogen





capture cd "D:\Users\bholtemeyer\Dropbox (IFPRI)\Brian\Mali\dta"	
cd "..\..\Analyses\final_do-files"

**drop the urban communes here (BEFORE constructing the Anderson index)
preserve
	keep commune dm_urban_2008
	ren commune	commune_int
	sa "urban_commune_dummy_6-23-2016", replace
restore

drop if dm_urban_2008==1


**put the same variables "by each other"
unab all: *
foreach k in `all' {
	loc k_new = subinstr("`k'"		, "2008","",.)
	loc k_new = subinstr("`k_new'"	, "2013","",.)
	order `k_new'*
}
order commune
fsum *, uselabel




********************
//Cleaning 
********************
fsum *,uselabel f(%9.1f )	stats(N min max mean) // issues: missing data and outliers!
** make copies of original values
unab all_DVs: boreh* mayedu* school* clinic* road* 
foreach k in `all_DVs' {
	g `k'_raw = `k'
	loc labb: var label `k'
	lab var `k'_raw "before cleaning: `labb'"
}



********************
//Cleaning road_2008: fix shifted decimals and implausible improvements
********************
forv z = 1/2 {	//clean road1 and road2 separately 
	di _newline(3)
	if `z'==1 di "roads:"
	if `z'==2 di "paths:"

	qui g		ratio = road`z'_2008/road`z'_2013

	//by using 8 instead of 10 I'm saying that I believe a 0.8 ratio is more plausible than a 8 ratio. 
	qui sum road`z'_2008,d
	replace road`z'_2008 = road`z'_2008/10 	if road`z'_2008>`r(p50)' & ratio>8		& ratio!=.		

	qui sum road`z'_2013,d
	replace road`z'_2008 = road`z'_2008*10 	if road`z'_2013>`r(p50)' & ratio<1/8	& ratio!=. 	
	drop ratio

	replace road`z'_2013 = . if road`z'_2008==0 & road`z'_2013>350 & road`z'_2013<.	
}


********************
//Fix implausible degregation for all vars: if the 2013 value is less than 1/4 of the 2008 value  AND the 2008 value exceeds the median (of the nonzero values), then recode the 2013 value as missing
********************
g		dm_cleaned_commune = 0
lab var dm_cleaned_commune "dummy - some DV for this commune was cleaned"

qui foreach k in boreh mayedu school1 school2 school3 clinic1 clinic2 clinic3 road1 road2 { //`all_DVs' {
	noi di _newline(1)
	g ratio = `k'_2013/`k'_2008
	replace ratio = 1 if  `k'_2013==0	&	`k'_2008==0
	sum `k'_2008 if `k'_2008!=0,d
	loc p50 = `r(p50)'
	noi di "`k': (the median is `p50')"
	/*
	if "`k'"=="school2"{	//look at one of the vars getting cleaned
		sort `k'_2013 `k'_2008
		br `k'_2013 `k'_2008 if ratio<0.25 & `k'_2008>`p50'
	}
	*/
	
	**Currently no "implausible degredation" cleaning is being done because the next line is "commented out"
	**noi replace `k'_2013 = . if ratio<0.25 & `k'_2008>`p50'
	replace dm_cleaned_commune = 1 if 	`k'_2008!= `k'_2008_raw | ///
										`k'_2013!= `k'_2013_raw 
	drop ratio
}

foreach y in 2008 2013 {
	gen school_`y' 	= school1_`y'	+	school2_`y'	+	school3_`y'
	gen clinic_`y' 	= clinic1_`y'	+	clinic2_`y'	+	clinic3_`y'
	gen road_`y' 	= road1_`y'		+	road2_`y'	
	
	lab var school_`y' 	"`y': total schools"
	lab var clinic_`y' 	"`y': total clinics"
	lab var road_`y' 	"`y': total roads"
}
drop school?_20?? clinic?_20?? road?_20??
drop *_raw
fsum *, uselabel





********************
//Start DV construction
********************
loc v = "road		boreh		clinic		school		mayedu"

foreach k in `v' {
	loc labb: var label `k'_2013
	loc labb = subinstr("`labb'", "2013:", "",.)
	g		`k'_dif = `k'_2013-`k'_2008
	lab var `k'_dif  "2013-2008: `labb'"
	order `k'*
}
order commune
fsum *,uselabel f(%9.1f )	stats(N min max mean) // issues: missing data and outliers!

/*
1.	Categorical variable reporting how many of the 4 index components *increased* over the 
	period, e.g. 0 means that all variables stay constant or decrease while 4 would mean 
	that all increase
2.	Categorical variable reporting how many of the 4 index components *decreased* over the 
	period, e.g. 0 means that all variables stay constant or increased while 4 would mean 
	that all decrease
*/

foreach k in `v'{
	g	dm_`k'_up		= (`k'_2013>`k'_2008)
	g	dm_`k'_down		= (`k'_2013<`k'_2008)
	replace dm_`k'_up 	= . if `k'_2013==. | `k'_2008==.
	replace dm_`k'_down = . if `k'_2013==. | `k'_2008==.
	
	assert 	dm_`k'_up	==0 if dm_`k'_down	==1
	assert 	dm_`k'_down	==0 if dm_`k'_up	==1
	assert `k'_2008==`k'_2013 if dm_`k'_up	==0 & dm_`k'_down	==0
}
gen	v1_up 	= dm_road_up	+	dm_boreh_up		+	dm_school_up		+	dm_clinic_up	
gen	v2_down = dm_road_down	+	dm_boreh_down	+	dm_school_down		+	dm_clinic_down
drop dm_*_up		dm_*_down
lab var v1_up 	"number of categories (road,borehole;clinic;school) increased 2008-2013"
lab var v2_down "number of categories (road,borehole;clinic;school) decreased 2008-2013"


/*
7.	Create an Anderson index using the variables computed in (5); this weights each component by 
	relative variation in the sample.  I have uploaded to Dropbox in the Analyses folder a nifty 
	little Stata program called genindex.do that produces this index (and others) for you.
*/
qui {
cap program drop genindexBH
program genindexBH

	syntax varlist [aw] , nv(string)
	center `varlist' , pre(z_) st
	// #1-a Mean of those zscores, 0/1 at median: M
		egen `nv'M = rowmean(z_*)
		if "`exp'" != "" {
			qui su `nv'M [weight `exp'] , de
			}
		if "`exp'" == "" {
			qui su `nv'M , de
			}
		gen `nv'M_B = (`nv'M > r(p50))
		
	// #1-b Factor, 0/1 at median: F
		factor z_*
		predict `nv'F
		su `nv'F , de
		gen `nv'F_B = (`nv'F > r(p50))
		
	// #1-c Anderson ('08) wgt'd by Var-Cov mat, 0/1 at median: A
	tempname R J T A
	mat accum `R' = `varlist' , nocons dev
	mat `R' = syminv(`R'/r(N))
	mat `J' = J(colsof(`R') , 1 , 1)

	local c = 1
	while `c' <= colsof(`R') {
		mat `T' = `R'[`c' , 1..colsof(`R')]
		mat `A' = `T'*`J'
		global wgt`c' = `A'[1 , 1]
		local ++c
		}
	
	tempvar samp1 outp1
	gen `samp1' = 0
	gen `outp1' = 0
	local c = 1
	foreach z in `varlist' {
		replace `samp1' = `samp1' + $wgt`c'
		replace z_`z' = 0 if missing(`z') 				//key line
		replace `outp1' = z_`z'*($wgt`c') + `outp1'
		local ++c
		}

	replace `outp1' = `outp1'/`samp1'
	rename `samp1' n_`nv'_var
	rename `outp1' `nv'A

	su `nv'A , de
	gen `nv'A_B = (`nv'A > r(p50))
	
	local ab M F A
	local ful Mean Factor Anderson
	forval n = 1/3 {
		local a : word `n' of `ab'
		local b : word `n' of `ful'
		lab var `nv'`a' "`nv'`a': `nv' `b'"
		lab var `nv'`a'_B "`nv'`a'_B: `nv' `b' 0/1"
		}
	
	drop z_*
	macro drop _all
end
}



loc anderson4_2008			= 	"road_2008 		boreh_2008 			school_2008 		clinic_2008"
loc anderson3_2008			= 	"road_2008 				 			school_2008 		clinic_2008"
loc anderson4_2013			= 	"road_2013 		boreh_2013 			school_2013 		clinic_2013"
loc anderson4_change08_13	=	"road_dif		boreh_dif			school_dif			clinic_dif"

qui { // anderson vars
	***********************
	loc k =  "anderson4_2013"  
	***********************
	qui genindexBH 	``k'' ,	nv(`k')
	unab andertodrop: *`k'*
	unab andertokeep: `k'A
	loc dif: list andertodrop - andertokeep
	drop `dif'			 // these are other vars created by -genindex- that I don't need
	rename `k'A `k'
	lab var `k'  "2013: Anderson level index (4 components)"


	***********************
	loc k =  "anderson4_2008"  
	***********************
	qui genindexBH 	``k'' ,	nv(`k')
	unab andertodrop: *`k'*
	unab andertokeep: `k'A
	loc dif: list andertodrop - andertokeep
	drop `dif'			 // these are other vars created by -genindex- that I don't need
	rename `k'A `k'
	lab var `k'  "2008: Anderson level index (4 components)"


	***********************
	**difference
	***********************
	gen		anderson4_dif =anderson4_2013	-	anderson4_2008
	lab var anderson4_dif "2013-2008: Anderson index (4 components)"


	***********************
	loc k =  "anderson3_2008"  
	***********************
	qui genindexBH 	``k'' ,	nv(`k')
	unab andertodrop: *`k'*
	unab andertokeep: `k'A
	loc dif: list andertodrop - andertokeep
	drop `dif'			 // these are other vars created by -genindex- that I don't need
	rename `k'A `k'
	lab var `k'  "2008: Anderson level index (3 components)"
}
qui { // PCA vars
	***********************
	loc k =  "anderson4_2013"  
	***********************
	pca 	``k'', components(1)
	predict PCA4_2013 , score
	lab var PCA4_2013 "2013: PCA index; first component (4 inputs)"


	***********************
	loc k =  "anderson4_2008"  
	***********************
	pca 	``k'', components(1)
	predict PCA4_2008 , score
	lab var PCA4_2008 "2008: PCA index; first component (4 inputs)"


	***********************
	**difference
	***********************
	gen		PCA4_dif =PCA4_2013	-	PCA4_2008
	lab var PCA4_dif "2013-2008: PCA index; first component (4 inputs)"
}




**switch commune IDs because the DV commune IDs are different from the RHS commune IDs
ren commune	commune_int

sa "DVs_2008_2013_6-23-2016", replace

exit
