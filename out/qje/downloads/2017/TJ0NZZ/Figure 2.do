	clear
	*set mem 2g
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
	

	
	* 1) First create a data file for the elected municipal politicians and their siblings
		
*load data on siblings	
odbc load, exec("select * from BioSyskon") dsn("P0624") clear
*keep only siblings with the same mother and father
keep if Syskon=="Helsyskon"
		
ren LopNr p_id 
*generate family id
egen fam_id= group(p_id)

cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
*match with politician data. Note that we only keep data for those htat have a sibling
joinby p_id  using "ENGLISH politicians with pol and background data 1988-2011 limited.dta", unmatched(none)
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
*discard all years but the first in the election period
keep if year==electionyear+1
keep p_id LopNr_BioSyskon Syskontyp electionyear elected   fam_id
*only keep if mayor and election is after 1990
keep ifelection==1 & electionyear>1990
*give each sibling of a politicians a number starting at 1
bysort p_id electionyear: egen rank=rank (LopNr_Bio)

*reshape the data into wide form, each sibling of a politicians has its own variable number
reshape wide LopNr_BioSyskon@, j(rank) i(p_id electionyear)

* the politician is given an id number with rank 0	
gen LopNr_BioSyskon0= p_id 

*reshape the data set so that each individual in the data set has its own identifier	 
reshape long  LopNr_BioSyskon@, j(rank) i(p_id  electionyear)
		
drop elected p_id Syskontyp rank
	
	
ren LopNr_BioSysko p_id
keep if p_id!=.
*drop duplicates so that each inidiviual only appears once everyyear
duplicates drop  p_id electionyear, force
		
*join data on whose elected so that we know who the politicians are
joinby p_id electionyear using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\elected 1991-2010.dta", unmatched(master)
gen sib=1
	gen year =electionyear+1
	save "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison\sibling and elected.dta", replace
	

* Create a data file for the Mayors and their siblings

*load data on siblings	
odbc load, exec("select * from BioSyskon") dsn("P0624") clear
*keep only siblings with the same mother and fatehr
keep if Syskon=="Helsyskon"
		
ren LopNr p_id 
*generate family id
egen fam_id= group(p_id)

cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
*match with politician data. Note that we only keep data for those htat have a sibling
joinby p_id  using "ENGLISH politicians with pol and background data 1988-2011 limited.dta", unmatched(none)
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
*discard all years but the first in the election period
keep if year==electionyear+1
keep p_id LopNr_BioSyskon Syskontyp electionyear elected   fam_id
*only keep if mayor and election is after 1990
keep if chair_app==1 & electionyear>1990
*give each sibling of a politicians a number starting at 1
bysort p_id electionyear: egen rank=rank (LopNr_Bio)

*reshape the data into wide form, each sibling of a politicians has its own variable number
reshape wide LopNr_BioSyskon@, j(rank) i(p_id electionyear)

* the politician is given an id number with rank 0	
gen LopNr_BioSyskon0= p_id 

*reshape the data set so that each individual in the data set has its own identifier	 
reshape long  LopNr_BioSyskon@, j(rank) i(p_id  electionyear)
		
drop elected p_id Syskontyp rank
	
	
ren LopNr_BioSysko p_id
keep if p_id!=.
*drop duplicates so that each inidiviual only appears once everyyear
duplicates drop  p_id electionyear, force
		
*join data on whose elected so that we know who the politicians are
joinby p_id electionyear using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\elected 1991-2010.dta", unmatched(master)
gen sib=1
	gen year =electionyear+1
	save "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison\sibling and mayor.dta", replace
	
* First create a data file for the Mayors and their siblings

*load data on siblings	
odbc load, exec("select * from BioSyskon") dsn("P0624") clear
*keep only siblings with the same mother and fatehr
keep if Syskon=="Helsyskon"
		
ren LopNr p_id 
*generate family id
egen fam_id= group(p_id)

cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
*match with politician data. Note that we only keep data for those htat have a sibling
joinby p_id  using "ENGLISH politicians with pol and background data 1988-2011 limited.dta", unmatched(none)
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison"
*discard all years but the first in the election period
keep if year==electionyear+1
keep p_id LopNr_BioSyskon Syskontyp electionyear elected   fam_id
*only keep if mayor and election is after 1990
keep if elec_parl==1 & electionyear>1990
*give each sibling of a politicians a number starting at 1
bysort p_id electionyear: egen rank=rank (LopNr_Bio)

*reshape the data into wide form, each sibling of a politicians has its own variable number
reshape wide LopNr_BioSyskon@, j(rank) i(p_id electionyear)

* the politician is given an id number with rank 0	
gen LopNr_BioSyskon0= p_id 

*reshape the data set so that each individual in the data set has its own identifier	 
reshape long  LopNr_BioSyskon@, j(rank) i(p_id  electionyear)
		
drop elec_parl p_id Syskontyp rank
	
	
ren LopNr_BioSysko p_id
keep if p_id!=.
*drop duplicates so that each inidiviual only appears once everyyear
duplicates drop  p_id electionyear, force
		
*join data on whose elected so that we know who the politicians are
joinby p_id electionyear using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\elected parl 82_10.dta" , unmatched(master)

	gen year =electionyear+1
	gen sib=1
	save "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison\sibling and parl.dta", replace
	


*** Extract data set that contains level of education for entire population	
		
odbc load, exec("select Sun2000niva, p_id= Person_LopNr from P0624_Lisa_1992") dsn("P0624") clear
gen year=1992
save temp, replace

foreach year in 1995 1999 2003 2007 2011{
	odbc load, exec("select Sun2000niva, p_id= Person_LopNr from P0624_Lisa_`year'") dsn("P0624") clear
	gen year=`year'
	append using temp
	save temp, replace
}

*recode level of education ot years of education
replace Sun2000niva="" if Sun2000niva=="*" | Sun2000niva=="-"
destring Sun2000niva, replace force
replace  Sun2000niva=. if Sun2000niva>=999

gen educ_year=.
replace educ_year= 7.5 if Sun2000niva>=100 & Sun2000niva<200
replace educ_year= 9.4 if Sun2000niva>=200 & Sun2000niva<300
replace educ_year= 11.2 if Sun2000niva>=300 & Sun2000niva<330
replace educ_year= 12.4 if Sun2000niva>=330 & Sun2000niva<400
replace educ_year= 14.2 if Sun2000niva>=410& Sun2000niva<530
replace educ_year= 17 if Sun2000niva>=530 & Sun2000niva<600
replace educ_year= 20.4 if Sun2000niva>=600 & Sun2000niva<999

drop Sun2000niva
*Join with data on draft data
joinby p_id using "income residual new.dta", unmatched(none)
		

*Join and recode draft data	
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
joinby p_id using "enlistment base file.dta", unmatched(master)
ren pprf_befl leader
label variable leader "0-9 scale score on leadership evaluation"

ren pprf_pf basic_suit
label variable basic_suit "0-9 scale score on the basic military suitability test"
	
ren pprf_pgrp iq
label variable iq "0-9 scale score on written test"
	
foreach var of varlist leader basic_suit iq{
	replace `var'=. if `var'==0
}			

*join with data on birth year and sex
joinby p_id using "Birthyear_sex.dta"
ren FodelseAr birth_year
gen age = year-birth_year
drop if age <18
drop   age Kon  Kommun
drop if year==.

*add data on mayors and their sibilings
save temp, replace
		
joinby p_id year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison\sibling and may.dta", unmatched(master)
			 
matrix inc_res_C =J(13,6,.)
gen start=1
gen inc_res_1 = inc_res<-2.75 if inc_res!=. 
gen inc_res_13 = inc_res>=2.75 if inc_res!=.  

foreach level in  2 3 4 5 6 7 8 9 10 11 12{
		
gen inc_res_`level' = inc_res>(-3.25+`level'/2) & inc_res<=(-2.75+`level'/2)  if  inc_res!=. 
		}
			
		foreach level in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
			* population  
		
	
			* siblings 
			sum inc_res_`level' if sib==1   
			matrix inc_res_C[`level',1]=r(mean) 
			
			* nominerade och valda
			sum inc_res_`level' if elected==1  
			matrix inc_res_C[`level',2]=r(mean)
			
			sum inc_res_`level'  if sib!=1 & elected!=1
			matrix inc_res_C[`level',5]=r(mean)

			
			gen bas = `level'
			sum bas
			matrix inc_res_C[`level',3]=(-3.6+`level'/2)
			matrix inc_res_C[`level',4]=(-3.4+`level'/2)
			matrix inc_res_C[`level',6]=(-3.5+`level'/2)
			drop bas
	}
	*
	 

	svmat inc_res_C
	rename inc_res_C1 inc_res_prop_sib
	rename inc_res_C2 inc_res_prop_pol
	rename inc_res_C3 inc_res_pos_sib
	rename inc_res_C4 inc_res_pos_pol
	rename inc_res_C5 inc_res_prop_pop
	rename inc_res_C6 inc_res_pos_pop


	* Bar graph for the population, all politicians, and Mayors comparison
	twoway (bar inc_res_prop_sib inc_res_pos_sib, fc(gs8) barw(.2)) ///
	(bar inc_res_prop_pol inc_res_pos_pol, fc(gs4) barw(.2)) ///
		(bar inc_res_prop_pop inc_res_pos_pop,  lcolor(gs0) lwidth(medthick) fc(none)   barw(.4)) ///
		, xlabel(-3 -2 -1 0 1 2 3) ylabel(, angle(horizontal)) ///
		 ytitle(Share) ///
		title(Residual Ability)  scheme(s1mono)  ///
		legend(label(1 "Siblings of Mayors") label(2 "Mayors") label(3 "Population") row(2))
		
		
			gen stop=1
			drop start-stop
			cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
		graph save inc_res_sib_mayor.gph, replace
		* open data for each trait
		
		
			
*************enlistment data 

	foreach var in iq leader {
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
	

		
	
		matrix `var'_C =J(9,6,.)
	gen start=1
		foreach level in 1 2 3 4 5 6 7 8 9 {
		
			gen `var'_`level' = 1 if `var' == `level'
			replace `var'_`level' =0 if `var' != `level' & `var'!=. 
			
			* siblings 
			sum `var'_`level' if sib==1 & elected!=1 
			matrix `var'_C[`level',1]=r(mean)
			
			* nominerade och valda
			sum `var'_`level' if elected==1 
			matrix `var'_C[`level',2]=r(mean)
			
			sum `var'_`level' if sib!=1 & elected!=1
			matrix `var'_C[`level',5]=r(mean)
			
	
		
			* valda
	
			
			gen bas = `level'
			sum bas
			matrix `var'_C[`level',3]=r(mean)-.2
			matrix `var'_C[`level',4]=r(mean)+.2
			matrix `var'_C[`level',6]=r(mean)

			drop bas
	}
	*
	 
	svmat `var'_C
	rename `var'_C1 `var'_prop_sib
	rename `var'_C2 `var'_prop_pol
	rename `var'_C3 `var'_pos_sib
	rename `var'_C4 `var'_pos_pol
	rename `var'_C5 `var'_prop_pop
	rename `var'_C6 `var'_pos_pop


	* Bar graph for the population, all politicians, and Mayors comparison
	twoway (bar `var'_prop_sib `var'_pos_sib, fc(gs8) barw(.4))  ///
		(bar `var'_prop_pol `var'_pos_pol, fc(gs4) barw(.4)) ///
				(bar `var'_prop_pop `var'_pos_pop,  lcolor(gs0) lwidth(medthick) fc(none)   barw(.8)) ///
		, xlabel(1 2 3 4 5 6 7 8 9) ///
		 ytitle(Share) ///
		title(`var')  scheme(s1mono) ylabel(, angle(horizontal)) ///
		legend(label(1 "Siblings of Mayors") label(2 "Mayors") label(3 "Population")  row(2))
			
	* Save figure
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
	graph save `var'_sib_mayor, replace
	gen stop=1
	drop start-stop
	

}

**make figure for elected municipal politicians
use temp, clear
joinby p_id year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison\sibling and elected.dta", unmatched(master)

			 
				matrix inc_res_C =J(13,6,.)
				gen start=1
gen inc_res_1 = inc_res<-2.75 if inc_res!=. 
gen inc_res_13 = inc_res>=2.75 if inc_res!=.  

	foreach level in  2 3 4 5 6 7 8 9 10 11 12{
		
gen inc_res_`level' = inc_res>(-3.25+`level'/2) & inc_res<=(-2.75+`level'/2)  if  inc_res!=. 
		}
			
		foreach level in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
			* population  
		
	
			* siblings 
			sum inc_res_`level' if sib==1   
			matrix inc_res_C[`level',1]=r(mean) 
			
			* nominerade och valda
			sum inc_res_`level' if elected==1  
			matrix inc_res_C[`level',2]=r(mean)
			
			sum inc_res_`level'  if sib!=1 & elected!=1
			matrix inc_res_C[`level',5]=r(mean)

			
			gen bas = `level'
			sum bas
			matrix inc_res_C[`level',3]=(-3.6+`level'/2)
			matrix inc_res_C[`level',4]=(-3.4+`level'/2)
			matrix inc_res_C[`level',6]=(-3.5+`level'/2)
			drop bas
	}
	*
	 

	svmat inc_res_C
	rename inc_res_C1 inc_res_prop_sib
	rename inc_res_C2 inc_res_prop_pol
	rename inc_res_C3 inc_res_pos_sib
	rename inc_res_C4 inc_res_pos_pol
	rename inc_res_C5 inc_res_prop_pop
	rename inc_res_C6 inc_res_pos_pop


	* Bar graph for the population, all politicians, and Electeds comparison
	twoway (bar inc_res_prop_sib inc_res_pos_sib, fc(gs8) barw(.2)) ///
	(bar inc_res_prop_pol inc_res_pos_pol, fc(gs4) barw(.2)) ///
		(bar inc_res_prop_pop inc_res_pos_pop,  lcolor(gs0) lwidth(medthick) fc(none)   barw(.4)) ///
		, xlabel(-3 -2 -1 0 1 2 3) ylabel(, angle(horizontal)) ///
		 ytitle(Share) ///
		title(Residual Ability)  scheme(s1mono)  ///
		legend(label(1 "Siblings of Electeds") label(2 "Electeds") label(3 "Population") row(2))
		
		
			gen stop=1
			drop start-stop
			cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
		graph save inc_res_sib_Elected.gph, replace
		* open data for each trait
		
		
			
*************enlistment data 

	foreach var in iq leader {
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
	

		
	
		matrix `var'_C =J(9,6,.)
	gen start=1
		foreach level in 1 2 3 4 5 6 7 8 9 {
		
			gen `var'_`level' = 1 if `var' == `level'
			replace `var'_`level' =0 if `var' != `level' & `var'!=. 
			
			* siblings 
			sum `var'_`level' if sib==1 & elected!=1 
			matrix `var'_C[`level',1]=r(mean)
			
			* nominerade och valda
			sum `var'_`level' if elected==1 
			matrix `var'_C[`level',2]=r(mean)
			
			sum `var'_`level' if sib!=1 & elected!=1
			matrix `var'_C[`level',5]=r(mean)
			
	
		
			* valda
	
			
			gen bas = `level'
			sum bas
			matrix `var'_C[`level',3]=r(mean)-.2
			matrix `var'_C[`level',4]=r(mean)+.2
			matrix `var'_C[`level',6]=r(mean)

			drop bas
	}
	*
	 
	svmat `var'_C
	rename `var'_C1 `var'_prop_sib
	rename `var'_C2 `var'_prop_pol
	rename `var'_C3 `var'_pos_sib
	rename `var'_C4 `var'_pos_pol
	rename `var'_C5 `var'_prop_pop
	rename `var'_C6 `var'_pos_pop


	* Bar graph for the population, all politicians, and Electeds comparison
	twoway (bar `var'_prop_sib `var'_pos_sib, fc(gs8) barw(.4))  ///
		(bar `var'_prop_pol `var'_pos_pol, fc(gs4) barw(.4)) ///
				(bar `var'_prop_pop `var'_pos_pop,  lcolor(gs0) lwidth(medthick) fc(none)   barw(.8)) ///
		, xlabel(1 2 3 4 5 6 7 8 9) ///
		 ytitle(Share) ///
		title(`var')  scheme(s1mono) ylabel(, angle(horizontal)) ///
		legend(label(1 "Siblings of Electeds") label(2 "Electeds") label(3 "Population")  row(2))
			
	* Save figure
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
	graph save `var'_sib_Elected, replace
	gen stop=1
	drop start-stop
	

}

**make figure for parliamentarians
use temp, clear
joinby p_id year using "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Siblings comparison\sibling and elected.dta", unmatched(master)

				matrix inc_res_C =J(13,6,.)
				gen start=1
gen inc_res_1 = inc_res<-2.75 if inc_res!=. 
gen inc_res_13 = inc_res>=2.75 if inc_res!=.  

	foreach level in  2 3 4 5 6 7 8 9 10 11 12{
		
gen inc_res_`level' = inc_res>(-3.25+`level'/2) & inc_res<=(-2.75+`level'/2)  if  inc_res!=. 
		}
			
		foreach level in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
			* population  
		
	
			* siblings 
			sum inc_res_`level' if sib==1   
			matrix inc_res_C[`level',1]=r(mean) 
			
			* nominerade och valda
			sum inc_res_`level' if elected==1  
			matrix inc_res_C[`level',2]=r(mean)
			
			sum inc_res_`level'  if sib!=1 & elected!=1
			matrix inc_res_C[`level',5]=r(mean)

			
			gen bas = `level'
			sum bas
			matrix inc_res_C[`level',3]=(-3.6+`level'/2)
			matrix inc_res_C[`level',4]=(-3.4+`level'/2)
			matrix inc_res_C[`level',6]=(-3.5+`level'/2)
			drop bas
	}
	*
	 

	svmat inc_res_C
	rename inc_res_C1 inc_res_prop_sib
	rename inc_res_C2 inc_res_prop_pol
	rename inc_res_C3 inc_res_pos_sib
	rename inc_res_C4 inc_res_pos_pol
	rename inc_res_C5 inc_res_prop_pop
	rename inc_res_C6 inc_res_pos_pop


	* Bar graph for the population, all politicians, and Parliamentarians comparison
	twoway (bar inc_res_prop_sib inc_res_pos_sib, fc(gs8) barw(.2)) ///
	(bar inc_res_prop_pol inc_res_pos_pol, fc(gs4) barw(.2)) ///
		(bar inc_res_prop_pop inc_res_pos_pop,  lcolor(gs0) lwidth(medthick) fc(none)   barw(.4)) ///
		, xlabel(-3 -2 -1 0 1 2 3) ylabel(, angle(horizontal)) ///
		 ytitle(Share) ///
		title(Residual Ability)  scheme(s1mono)  ///
		legend(label(1 "Siblings of Parliamentarians") label(2 "Parliamentarians") label(3 "Population") row(2))
		
		
			gen stop=1
			drop start-stop
			cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
		graph save inc_res_sib_Parliamentarian.gph, replace
		* open data for each trait
		
		
			
*************enlistment data 

	foreach var in iq leader {
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
	

		
	
		matrix `var'_C =J(9,6,.)
	gen start=1
		foreach level in 1 2 3 4 5 6 7 8 9 {
		
			gen `var'_`level' = 1 if `var' == `level'
			replace `var'_`level' =0 if `var' != `level' & `var'!=. 
			
			* siblings 
			sum `var'_`level' if sib==1 & elected!=1 
			matrix `var'_C[`level',1]=r(mean)
			
			* nominerade och valda
			sum `var'_`level' if elected==1 
			matrix `var'_C[`level',2]=r(mean)
			
			sum `var'_`level' if sib!=1 & elected!=1
			matrix `var'_C[`level',5]=r(mean)
			
	
		
			* valda
	
			
			gen bas = `level'
			sum bas
			matrix `var'_C[`level',3]=r(mean)-.2
			matrix `var'_C[`level',4]=r(mean)+.2
			matrix `var'_C[`level',6]=r(mean)

			drop bas
	}
	*
	 
	svmat `var'_C
	rename `var'_C1 `var'_prop_sib
	rename `var'_C2 `var'_prop_pol
	rename `var'_C3 `var'_pos_sib
	rename `var'_C4 `var'_pos_pol
	rename `var'_C5 `var'_prop_pop
	rename `var'_C6 `var'_pos_pop


	* Bar graph for the population, all politicians, and Parliamentarians comparison
	twoway (bar `var'_prop_sib `var'_pos_sib, fc(gs8) barw(.4))  ///
		(bar `var'_prop_pol `var'_pos_pol, fc(gs4) barw(.4)) ///
				(bar `var'_prop_pop `var'_pos_pop,  lcolor(gs0) lwidth(medthick) fc(none)   barw(.8)) ///
		, xlabel(1 2 3 4 5 6 7 8 9) ///
		 ytitle(Share) ///
		title(`var')  scheme(s1mono) ylabel(, angle(horizontal)) ///
		legend(label(1 "Siblings of Parliamentarians") label(2 "Parliamentarians") label(3 "Population")  row(2))
			
	* Save figure
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons"
	graph save `var'_sib_Parliamentarian, replace
	gen stop=1
	drop start-stop
	

}
		 
