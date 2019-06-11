*Open data set that contains entire population
use "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files\municipality 1990-2012.dta", clear
*Keep relevant years
keep if year == 2003 | year ==2007 | year ==2011 
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
*add data on earnings power	
joinby p_id using "income residual new.dta", unmatched(master)
	
*add data on sex and birthyear
joinby p_id using "Birthyear_sex.dta"
ren FodelseAr birth_year
gen age = year-birth_year
		
drop if age <18
drop  _merge age Kon  Kommun	
		
drop if year==.
*Add data on politicians
joinby p_id year using "ENGLISH politicians with pol and background data 1988-2011 limited.dta", unmatched(master)
gen nom=1 if nominated==1 & elected!=1
drop municipality - iq
*Add and clean data on parental sei
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Political dynasties\Occupational following"	
drop _merge
joinby p_id using "sei parents 1982.dta", unmatched(master)
replace sei_father=int(sei_father/10)
replace sei_father=sei_father+1 if sei_father>3 & sei_father!=.
replace sei_father=4 if sei_father==9

	gen sei_10 =int((parpct_father-1)/10) +1
	
gen sei_4=int((parpct_father-1)/25) +1

*Add data on parental income in 1979
drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Parents-politicians comparison"
joinby p_id using "Parents income 1979.dta", unmatched(master)

*add and clean draft data	
drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
joinby p_id using "enlistment base file.dta", unmatched(master)
drop _merge
ren pprf_befl leader
ren pprf_pgrp iq
drop  pprf_pf 	
replace iq=. if iq==0
replace leader=. if leader==0

**make graps that show avarages for each quartile of parental sei

	
		foreach var in leader iq inc_res{
gen start=1
		matrix `var'_C =J(4,10,.)

		foreach level in 1 2 3 4{
		

			* population  
			sum `var' if nom!=1 & elected!=1 & elec_parl!=1 & sei_4==`level'
			matrix `var'_C[`level',1]=r(mean)
			
			* nominated
			sum `var' if nom==1 & sei_4==`level'
			matrix `var'_C[`level',2]=r(mean)
		
			* elected
			sum `var' if elected==1  & sei_4==`level'
			matrix `var'_C[`level',3]=r(mean)
			
			sum `var' if chair_app==1  & sei_4==`level'
			matrix `var'_C[`level',4]=r(mean)
			
			sum `var' if elec_parl==1  & sei_4==`level'
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
		, xlabel(1 2 3 4) ///
		title(`var' score distribution) ytitle(Average score) ///
		xtitle(Father's income decile)  scheme(s1mono) xtitle("") ///
		legend(label (1 "Nominated (non-elected)") label(2 "Elected") label(3 "Mayors") label(4 "Parliamentarians") label(5 "Population proportion") row(3))
		
		
	* Save figure
	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\"
	graph save "valance_seiinc4_`var'.gph", replace
		gen stop=1
	drop start-stop
	}

	
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\
graph combine valance_seiocc_iq.gph valance_seiocc_leader.gph  valance_seiocc_inc_res.gph,  scheme(s1mono)  ysize(12) xsize(20) iscale(.8) col(2)
		
graph save "valance_seiocc.gph", replace
	
graph combine valance_seiinc_iq.gph valance_seiinc_leader.gph  valance_seiinc_inc_res.gph,  scheme(s1mono)  ysize(12) xsize(20) iscale(.8) col(2)
		
graph save "valance_seiinc.gph", replace
	
graph combine valance_seiinc4_iq.gph valance_seiinc4_leader.gph  valance_seiinc4_inc_res.gph,  scheme(s1mono)  ysize(12) xsize(20) iscale(.8) col(2)
		
graph save "valance_seiinc4.gph", replace
	
