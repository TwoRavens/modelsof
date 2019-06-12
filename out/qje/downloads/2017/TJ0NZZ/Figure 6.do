
clear
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
***First calculate the municipal means of the parental bacckground variables for each year of data that we use, starting with 1999	
*Load data with municipal recidence
odbc load, exec("select p_id=Person_LopNr, m_id=Kommun from P0624_Lisa_1999") dsn("P0624") clear

*Add parental SEI
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Political dynasties\Occupational following"	
joinby p_id using "parent occupations 1982.dta", unmatched(master)
drop _merge

*Add parental income
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Parents-politicians comparison"
joinby p_id using "Parents income 1979.dta", unmatched(master)
drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Political dynasties\Occupational following"
gen electionyear=1998

*Add data on earnings score
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
	

*Add data on politicians
joinby p_id  electionyear using "pol.dta", unmatched(master)

*Recode parental sei into numerical values
replace sei_father=int(sei_father/10)
replace sei_father=sei_father+1 if sei_father>3 & sei_father!=.
replace sei_father=4 if sei_father==9
replace sei_mother=int(sei_mother/10)
replace sei_mother=sei_mother+1 if sei_mother>3 & sei_mother!=.
replace sei_mother=4 if sei_mother==9

tab sei_father if sei_father!=., gen (sei_f_d_)
tab sei_mother if sei_mother!=., gen (sei_m_d_)

destring m_id, replace force
*Subsribe politicians to the municipalties where they are elected rahter than where they live (this is almost always the same)
replace m_id= m_id_pol if m_id_pol!=.

egen sei=rowmax(sei_mother sei_father)
tab sei if sei, gen (sei_d_)

*** Calculate means for population, as well as all municipal politicians, elected and nominated
gen group= "p" if vald==.
replace group="n" if vald!=.
replace group="e" if vald==1

foreach g in p n e{

gen sei_`g' = sei if  group=="`g'"

gen sei_f_`g' = sei_father if  group=="`g'"
gen sei_m_`g' = sei_mother if  group=="`g'"
gen pct_f_`g' = parpct_father if  group=="`g'"
gen pct_m_`g' = parpct_mother if  group=="`g'"

foreach var in iq leader inc_res{
gen `var'_`g' = `var' if  group=="`g'"
}
}



collapse (mean) sei_p-inc_res_e, by(m_id electionyear)

*calculate differences bettwen politicians and the population, which is the selection index

gen i_sei_f=sei_f_e-sei_f_p
gen i_sei=sei_e-sei_p
gen pct_f_rep=0
gen i_pct_f=pct_f_e-pct_f_p
foreach var in iq leader inc_res{
gen i_`var'_e = -`var'_e-`var'_p if  group=="`g'"
}
}


save sei_mun, replace

*repear process for 2003,2007 and 2011
foreach year in 2003 2007 2011{
clear
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"

odbc load, exec("select p_id=Person_LopNr, m_id=Kommun from P0624_Lisa_`year'") dsn("P0624") clear

*Add parental SEI
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Political dynasties\Occupational following"	
joinby p_id using "parent occupations 1982.dta", unmatched(master)
drop _merge

*Add parental income
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Parents-politicians comparison"
joinby p_id using "Parents income 1979.dta", unmatched(master)
drop _merge
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Political dynasties\Occupational following"
gen electionyear=1998

*Add data on earnings score
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
	

*Add data on politicians
joinby p_id  electionyear using "pol.dta", unmatched(master)

*Recode parental sei into numerical values
replace sei_father=int(sei_father/10)
replace sei_father=sei_father+1 if sei_father>3 & sei_father!=.
replace sei_father=4 if sei_father==9
replace sei_mother=int(sei_mother/10)
replace sei_mother=sei_mother+1 if sei_mother>3 & sei_mother!=.
replace sei_mother=4 if sei_mother==9

tab sei_father if sei_father!=., gen (sei_f_d_)
tab sei_mother if sei_mother!=., gen (sei_m_d_)

destring m_id, replace force
*Subsribe politicians to the municipalties where they are elected rahter than where they live (this is almost always the same)
replace m_id= m_id_pol if m_id_pol!=.

egen sei=rowmax(sei_mother sei_father)
tab sei if sei, gen (sei_d_)

*** Calculate means for population, as well as all municipal politicians, elected and nominated
gen group= "p" if vald==.
replace group="n" if vald!=.
replace group="e" if vald==1

foreach g in p n e{

gen sei_`g' = sei if  group=="`g'"

gen sei_f_`g' = sei_father if  group=="`g'"
gen sei_m_`g' = sei_mother if  group=="`g'"
gen pct_f_`g' = parpct_father if  group=="`g'"
gen pct_m_`g' = parpct_mother if  group=="`g'"

foreach var in iq leader inc_res{
gen `var'_`g' = `var' if  group=="`g'"
}
}



collapse (mean) sei_p-inc_res_e, by(m_id electionyear)

*calculate differences bettwen politicians and the population, which is the selection index

gen i_sei_f=sei_f_e-sei_f_p
gen i_sei=sei_e-sei_p
gen pct_f_rep=0
gen i_pct_f=pct_f_e-pct_f_p
foreach var in iq leader inc_res{
gen i_`var'_e = -`var'_e-`var'_p if  group=="`g'"
}
}

append using sei_mun
save sei_mun, replace
}

gen electionperiod=electionyear
joinby m_id electionperiod using "\\micro.intra\Projekt\P0624$\P0624_Gem\Political dynasties\Occupational following\comp mun.dta", unmatched(master) _merge(_merge2)

***Install graph program for making binned average graphs

capture program drop vsssfz
program vsssfz

	*******the arguments are the outcome variable, the forcing variable, restriction on the sample used, ***
	*****restriction on the distance from the threshold, Y axis title, X axis title**************
	args ss vs  bin lim  tit1 tit2 grtit grstit
		
		********define ranks to construct bins****************
		gen  posdis= `vs' if `lim' &`ss'!=. &`vs'!=.
		egen rankpos=  rank (posdis) if   `lim' &`ss'!=. &`vs'!=. , unique



		********define integrers to construct bins****************
		gen int`vs'pos=  int(rankpos/`bin') if  `lim' &`ss'!=. &`vs'!=.

		egen max= max (int`vs'pos)
		replace int`vs'pos=. if int`vs'pos==max
		
		************create bin averages of both forcing variable and outcome*************
		sort int`vs'pos
		by int`vs'pos: egen mean`vs'pos=mean(`vs') if  int`vs'pos!=. & `lim'
		by int`vs'pos: egen mean`ss'pos=mean(`ss') if `ss'!=. & int`vs'pos!=. & `lim'

		************create single binned variables of forcing variable and outcome**************
		gen mean`vs'=mean`vs'pos if  `lim'

		gen mean`ss'=mean`ss'pos if  `lim'

		


 

twoway   (scatter mean`ss' mean`vs' , msize(medium))(lfit `ss' `vs' if `lim',  ) ,title(`grtit') subtitle(`grstit')  ytitle(`tit1') xtitle(`tit2')legend(off)     ylabel(#5) xlabel(#5) scheme(s1color)

***************drop all generated variables*********************************
drop  posdis - mean`ss' 


end

***********************************
*Make the graphs

vsssfz i_iq i_sei_f  50 "sei_rep !=." "Index Cognitive Score" "SEI Index"
graph save iq_sei, replace

vsssfz i_leader i_sei_f 50 "sei_rep !=." "Index Leadership Score" "SEI Index"
graph save leader_sei, replace

vsssfz i_inc_res i_sei_f 50 "sei_rep !=." "Index Income Residual" "SEI Index"
graph save incres_sei, replace


vsssfz i_iq i_pct_f 50 "pct_f_rep !=." "Index Cognitive Score" "Parental Income Index"
graph save iq_pct, replace
graph export iq_pct.tif, replace

vsssfz i_leader  i_pct_f 50 "pct_f_rep!=." "Index Leadership Score" "Parental Income Index"
graph save leader_pct, replace
graph export leader_pct.tif, replace

vsssfz i_inc_res  i_pct_f 50 "pct_f_rep !=."  "Index Income Residual" "Parental Income Index"
graph save incres_pct, replace
graph export incres_pct.tif, replace 

graph combine leader_sei.gph leader_pct.gph iq_sei.gph iq_pct.gph incres_sei.gph incres_pct.gph, ysize(20) xsize(20) col(2) row(3) scheme(s1mono) 
graph save rep_comp, replace
graph export rep_comp.tif, replace 


*run regressions for which we manually write the estimates in the graphs 
log using rep_comp, replace

reg  i_iq i_sei_f ,cluster(m_id)
reg  i_leader i_sei_f ,  cluster(m_id)
reg  i_inc_res i_sei_f ,  cluster(m_id)

reg  i_iq i_pct_f, cluster(m_id)
reg  i_leader i_pct_f,  cluster(m_id)
reg  i_inc_res i_pct_f,  cluster(m_id)

reg  i_iq i_sei_f ,robust beta
reg  i_leader i_sei_f ,  robust beta
reg  i_inc_res i_sei_f ,  robust beta

reg  i_iq i_pct_f, robust beta
reg  i_leader i_pct_f,  robust beta
reg  i_inc_res i_pct_f,  robust beta
log close
