
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"


*************************************************************************************
**************** FOUR PANEL PLOT FOR COMPETENCE MEASURES, POOLED DATA ***************
*************************************************************************************
	


* 1) Extract data set that contains level of education for entire population	
		
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
drop   age Kon _merge
drop if year==.

*join with data on politicians		
joinby p_id year using "ENGLISH politicians with pol and background data 1988-2011 limited.dta", unmatched(master)
keep p_id- iq electionyear nominated chair elec_parl elected
*define dummy for being nominated but not elected 			 
gen nom=1 if nominated==1 & elected!=1

compress

matrix inc_res_C =J(13,10,.)

*define dummies for having earnings power with a certain interval 
gen inc_res_1 = inc_res<-2.75 if inc_res!=. 
gen inc_res_13 = inc_res>=2.75 if inc_res!=.
foreach level in  2 3 4 5 6 7 8 9 10 11 12{
	gen inc_res_`level' = inc_res>(-3.25+`level'/2) & inc_res<=(-2.75+`level'/2)
}
*for each interval and population we calculte the share of individuals who have
* earnings power within a certain internval
*áll the values are save with i matrix

foreach level in 1 2 3 4 5 6 7 8 9 10 11 12 13{
			* population  
	sum inc_res_`level' if inc_res!=.
	matrix inc_res_C[`level',1]=r(mean)
			
	* Politicians
	sum inc_res_`level' if nom==1 & inc_res!=.
	matrix inc_res_C[`level',2]=r(mean)

	sum inc_res_`level' if elected==1  & inc_res!=.
	matrix inc_res_C[`level',3]=r(mean)
	
	sum inc_res_`level' if chair_app==1  & inc_res!=.
	matrix inc_res_C[`level',4]=r(mean)
	
	sum inc_res_`level' if elec_parl==1  & inc_res!=.
	matrix inc_res_C[`level',5]=r(mean)
			
	gen bas = `level'
	sum bas
	matrix inc_res_C[`level',6]=(-3.5+`level'/2)
	matrix inc_res_C[`level',7]=(-3.66875+`level'/2)
	matrix inc_res_C[`level',8]=(-3.55625+`level'/2)
	matrix inc_res_C[`level',9]=(-3.44375+`level'/2)
	matrix inc_res_C[`level',10]=(-3.33125+`level'/2)
	drop bas
	}
	*
	 
svmat inc_res_C
rename inc_res_C1 inc_res_prop_pop
rename inc_res_C2 inc_res_prop_pol
rename inc_res_C3 inc_res_prop_ele
rename inc_res_C4 inc_res_prop_chair
rename inc_res_C5 inc_res_prop_parl
rename inc_res_C6 inc_res_pos_pop
rename inc_res_C7 inc_res_pos_pol
rename inc_res_C8 inc_res_pos_ele
rename inc_res_C9 inc_res_pos_chair
rename inc_res_C10 inc_res_pos_parl

* Bar graph for the population, all politicians, and elected politicians comparison
twoway (bar inc_res_prop_pol inc_res_pos_pol, fc(gs12) barw(.1125)) (bar inc_res_prop_ele inc_res_pos_ele, fc(gs9) barw(.1125)) ///
	(bar inc_res_prop_chair inc_res_pos_chair, fc(gs6) barw(.1125)) (bar inc_res_prop_parl inc_res_pos_parl, fc(gs3) barw(.1125))  ///
	(bar inc_res_prop_pop inc_res_pos_pop, lcolor(gs0) lwidth(medthick) fc(none) barw(.45)) ///
	, xlabel(-3 -2 -1 0 1 2 3)  ///
	title(inc_res score distribution) ytitle(Proportion with score) ///
	xtitle(inc_res)  scheme(s1mono) xtitle("") ///
	legend(label (1 "Nominated (non-elected)") label(2 "Elected") label(3 "Mayors") ///
	label(4 "Parliamentarians") label(5 "Population proportion") row(3))
		
			
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\combination valance"
graph save "valance_incres.gph", replace
	
	


foreach var in iq leader {

	matrix `var'_C =J(9,10,.)
	
	foreach level in 1 2 3 4 5 6 7 8 9 {
		
		gen `var'_`level' = 1 if `var' == `level'
		replace `var'_`level' =0 if `var' != `level' & `var'!=.
			
		* population  
		sum `var'_`level' 
		matrix `var'_C[`level',1]=r(mean)
			
		*all levels of politicians
		sum `var'_`level' if nom==1
		matrix `var'_C[`level',2]=r(mean)
		
		sum `var'_`level' if elected==1
		matrix `var'_C[`level',3]=r(mean)
			
		sum `var'_`level' if chair_app==1
		matrix `var'_C[`level',4]=r(mean)
			
		sum `var'_`level' if elec_parl==1
		matrix `var'_C[`level',5]=r(mean)
			
		gen bas = `level'
		sum bas
		matrix `var'_C[`level',6]=r(mean)
		matrix `var'_C[`level',7]=r(mean)-0.3375
		matrix `var'_C[`level',8]=r(mean)-0.1125
		matrix `var'_C[`level',9]=r(mean)+0.1125
		matrix `var'_C[`level',10]=r(mean)+0.3375
		drop bas
	}
	*
	 
	svmat `var'_C
	rename `var'_C1 `var'_prop_pop
	rename `var'_C2 `var'_prop_pol
	rename `var'_C3 `var'_prop_ele
	rename `var'_C4 `var'_prop_chair
	rename `var'_C5 `var'_prop_parl
	rename `var'_C6 `var'_pos_pop
	rename `var'_C7 `var'_pos_pol
	rename `var'_C8 `var'_pos_ele
	rename `var'_C9 `var'_pos_chair
	rename `var'_C10 `var'_pos_parl

	* Bar graph for the population, all politicians, and elected politicians comparison
	twoway (bar `var'_prop_pol `var'_pos_pol, fc(gs12) barw(.225)) (bar `var'_prop_ele `var'_pos_ele, fc(gs9) barw(.225)) ///
		(bar `var'_prop_chair `var'_pos_chair, fc(gs6) barw(.225)) ///
		(bar `var'_prop_parl `var'_pos_parl, fc(gs3) barw(.225)) ///
		(bar `var'_prop_pop `var'_pos_pop,  lcolor(gs0) lwidth(medthick) fc(none) barw(.9)) ///
		, xlabel(1 2 3 4 5 6 7 8 9) ///
		title(`var' score distribution) ytitle(Proportion with score) ///
		xtitle(`var')  scheme(s1mono) xtitle("") ///
		legend(label (1 "Nominated (non-elected)") label(2 "Elected") label(3 "Mayors") label(4 "Parliamentarians") label(5 "Population proportion") row(3))
		
		
	* Save figure
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\combination valance"
	graph save "valance_`var'.gph", replace
	}
}
	*
	
	
	**** Education *****
	
	
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
	use "13 ENGLISH politicians with pol and background data 1988-2011.dta", clear

	
	foreach var in educ {

		gen nom = 1 if nominated ==1 & elected !=1
		matrix `var'_C =J(7,10,.)
	
		foreach level in 1 2 3 4 5 6 7 {
		
			gen `var'_`level' = 1 if `var' == `level'
			replace `var'_`level' =0 if `var' != `level' & `var'!=.
			
			sum `var'_`level'
			matrix `var'_C[`level',1]=r(mean)
			
			* nominerade och valda
			sum `var'_`level' if nom==1
			matrix `var'_C[`level',2]=r(mean)
		
			* valda
			sum `var'_`level' if elected==1
			matrix `var'_C[`level',3]=r(mean)
			
			sum `var'_`level' if chair_app==1
			matrix `var'_C[`level',4]=r(mean)
			
			sum `var'_`level' if elec_parl==1
			matrix `var'_C[`level',5]=r(mean)
			
			
			gen bas = `level'
			sum bas
			matrix `var'_C[`level',6]=r(mean)
			matrix `var'_C[`level',7]=r(mean)-0.3375
			matrix `var'_C[`level',8]=r(mean)-0.1125
			matrix `var'_C[`level',9]=r(mean)+0.1125
			matrix `var'_C[`level',10]=r(mean)+0.3375
			drop bas
	}
	*
	 
	svmat `var'_C
	rename `var'_C1 `var'_prop_pop
	rename `var'_C2 `var'_prop_pol
	rename `var'_C3 `var'_prop_ele
	rename `var'_C4 `var'_prop_chair
	rename `var'_C5 `var'_prop_parl
	rename `var'_C6 `var'_pos_pop
	rename `var'_C7 `var'_pos_pol
	rename `var'_C8 `var'_pos_ele
	rename `var'_C9 `var'_pos_chair
	rename `var'_C10 `var'_pos_parl


	* Bar graph for the population, all politicians, and elected politicians comparison
	twoway (bar `var'_prop_pol `var'_pos_pol, fc(gs12) barw(.225)) (bar `var'_prop_ele `var'_pos_ele, fc(gs9) barw(.225)) ///
		(bar `var'_prop_chair `var'_pos_chair, fc(gs6) barw(.225)) (bar `var'_prop_parl `var'_pos_parl, fc(gs3) barw(.225))  ///
		(bar `var'_prop_pop `var'_pos_pop,  lcolor(gs0) lwidth(medthick) fc(none) barw(.9)) ///
		, xlabel(1 2 3 4 5 6 7) ///
		title(`var' score distribution) ytitle(Proportion with score) ///
		xtitle(`var')  scheme(s1mono) xtitle("") ///
					legend(label (1 "Nominated (non-elected)") label(2 "Elected") label(3 "Mayors") label(4 "Parliamentarians") label(5 "Population proportion") row(3))
		
		
		
	* Save figure
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\combination valance"
	graph save "valance_`var'.gph", replace
	}
	}
	*
	* Combine the four valance figures
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\combination valance"	
	graph combine  valance_leader.gph valance_iq.gph  valance_incres.gph valance_educ.gph,  scheme(s1mono)  ysize(12) xsize(20) iscale(.8)
		
