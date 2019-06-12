

clear all

set more off 


***************************************
***************************************
***SPECIFY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
***************************************
***************************************


global estimators xtreg

*is it onset (=1) or incidence(=.)?
local cheat 1

if "`cheat'" == "." {
	local on_or_in incidence
}
if "`cheat'" == "1" {
	local on_or_in onset
}

***************************************
***************************************

******************************************
******************************************
*don't touch code as of here
******************************************
******************************************

global models 
foreach v in 21 {
	global models $models `v' `v'w
}


program prepare_roc

	
	local which_thetas ste
	*foreach x in one two {
	foreach x in two {
	
		if "`x'" == "one" {
			local before 1
		}
		if "`x'" == "two" {
			local before 2
		}
																
		*****ll=0 is all countries, 1 only countries that ever had conflict
		forvalues ll = 0/0 {
												

			local model 0
			foreach vv in $models {
				
				clear
				use tempx
					
				keep if conflict != `2'
				drop if p_`x'_model`vv' == .
				drop if  `x'_before  == .
					
				keep  p_`x'_model`vv' `x'_before total_conflict conflict
				
				local model = `model' + 1 


				sort p_`x'_model`vv'									
					
				egen rank = rank(p_`x'_model`vv') if  p_`x'_model`vv' != .
							
					
				sum rank
					
				local max_rank `r(max)'
					
					
				if `r(N)' > 0 {
																
					
					forval cut = 1 / `max_rank' {
					
						local tpn 0
						local fpn 0
						local tpd 0
						local fpd 0
						
			
						*true positive
						 gen tp = 1 if  rank>= `cut' & rank!= . &  `x'_before == 1 &  total_conflict >= `1' & conflict!=`2' 
						*false positive						
						 gen fp = 1 if   rank>= `cut' & rank!= . &  `x'_before == 0 &  total_conflict >= `1' & conflict!=`2' 
						*wars
						 sum `x'_before if    rank!= . & total_conflict >= `1' & conflict!=`2'
						if `r(N)'!= 0 {
							*total `x'_before within evaluation sample
							local tpd = `r(N)' * `r(mean)'
							local fpd = `r(N)' * (1 - `r(mean)')
						}
			
						*warning bell rang when war
						cap sum tp if   rank!= . &  total_conflict >= `1' & conflict!=`2'
						if `r(N)'!= 0 {
							local tpn = `r(N)' * `r(mean)'							
						}
					
						*warning bell rang when no war
						 sum fp if   rank!= . &  total_conflict >= `1' & conflict!=`2'
						if `r(N)'!= 0 {
							local fpn = `r(N)' * `r(mean)'							
						}
		
					
							
							
						drop tp fp
						display "`vv'"
						post buffer (`cut') (`model') (`before') (`2')  (`tpn') (`fpn') (`tpd') (`fpd')
						*file write buffer (`cut') ("`vv'") ("`x'") (`2')  (`tpn') (`fpn') (`tpd') (`fpd')
				
							
					}
					
				}
					
				drop rank
				
									
				display "`vv'"
				
				
			}
			
		}
	}

end



local runs = 0
forval c = 3(-1)2  {

	local runs = `runs' + 1
	
	use "output/chris_predict_two_`on_or_in'_int`c'_to15_alpha3_beta001_all_both", clear

	drop conflict
	merge 1:1 countryid year using "complete_main_new.dta", keepusing(bdbest25 bdbest1000)
	
	
						
	if `c' == 2 {
						
		quietly gen conflict = bdbest25
							
	}
						
	if `c' == 3 {
							

		quietly gen conflict = bdbest1000
							
	}

	*drop if country == ""

	sort countryid year
	
	gen total_conflict = 0	
	
	tsset countryid year
	generate one_before=conflict==0&F1.conflict==1
	generate two_before=conflict==0&(F1.conflict==1|F2.conflict==1)
	
	if "`cheat'" == "." {
		replace one_before= 1 if conflict==1&F1.conflict==1
		replace two_before= 1 if conflict==1&(F1.conflict==1|F2.conflict==1)
	}
	
	
	drop if year < 1975	
	
	

	save tempx, replace
	
	postfile buffer cut model before conftype tpn fpn tpd fpd using output/for_roc_two_`on_or_in'`runs', replace
	prepare_roc 0 `cheat'
	postclose buffer
	
}






erase tempx.dta


forval r = 1 / `runs' {
 
	clear
	use output/for_roc_two_`on_or_in'`r'
	
	gen modelname = ""
	local x = 1
	foreach j in $models {
		 replace modelname = "`j'" if model == `x'
		 local x = `x' + 1
	}
	drop model

	
	gen tpr = tpn / tpd
	gen fpr = fpn / fpd	
	
	
	foreach j in $models {
		forval y = 0 / 1 {
			local new = _N + 1
	    	set obs `new'
	    	replace tpr = `y' if _n == _N
   	 		replace fpr = `y' if _n == _N
   	 		replace modelname = "`j'" if _n == _N
   	 	}
   	}

	save output/blub, replace
	collapse (max) tpr, by(fpr modelname)
	save output/blub1, replace
	use output/blub
	collapse (min) tpr, by(fpr modelname)
	append using output/blub1
	save output/blub, replace
	collapse (max) fpr, by(tpr modelname)
	save output/blub1, replace
	use output/blub
	collapse (min) fpr, by(tpr modelname)
	append using output/blub1
	


	sort modelname fpr tpr
	
	
	
	duplicates drop
	
	
	
	
	*compute AUC
	
	
	sort modelname fpr tpr
	gen fpr_dif = fpr - fpr[_n-1] if modelname == modelname[_n-1]
	gen tpr_dif = tpr - tpr[_n-1] if modelname == modelname[_n-1]
	*gen area = tpr * fpr_dif
	gen area = 0.5 * tpr_dif * fpr_dif + tpr[_n-1] * fpr_dif if modelname == modelname[_n-1]
	by modelname: egen auc = sum(area)
	
	
	save output/for_roc_two_`on_or_in'`r', replace
	
}



*local on_or_in onset
*local on_or_in incidence

***plotting
local title_left Civil War
local title_right Armed Conflict

local left_solid_name Overall Model
local left_dash_name Within Model

local right_solid_name Overall Model
local right_dash_name Within Model





foreach j in thetas {
	foreach k in hachris {
		*foreach x in xtreg xtlogit clogit {
		foreach x in $estimators {

			display "`j'"
			display "`k'"
			display "`x'"

			clear

			*graph of war
			use output/for_roc_two_`on_or_in'1

			rename modelname model
			sort model
			merge model using model_names
			sort id fpr tpr

			graph drop _all
			


			sum auc if what == "overall" & init == "`j'" & controls == "`k'" & estimation == "`x'"
			
			if `r(N)' > 0 {
				local auc1 = substr(string(round(`r(max)',.01)), 1, 3)
				sum auc if what == "within" & init == "`j'" & controls == "`k'" & estimation == "`x'"
				local auc2 = substr(string(round(`r(max)',.01)), 1, 3)

				twoway (line tpr fpr if what == "overall" & init == "`j'" & controls == "`k'" & estimation == "`x'",  lwidth(medthick) lpattern(solid)  sort) ///
				(line tpr fpr if what == "within" & init == "`j'" & controls == "`k'" & estimation == "`x'",  lwidth(medthick) lpattern(dash)  sort) ///
				 (line fpr fpr if what == "overall" & init == "`j'" & controls == "`k'" & estimation == "`x'", color(gs10) lpattern(dash) sort), ///
				subtitle("a) `title_left'", color(black)) ytitle(`"True Positive Rate"') xtitle(`"False Positive Rate"') legend( order(1 "`left_solid_name'" 2 "`left_dash_name'") size(small)) xlabel(,grid) ///
				plotregion(fcolor(white)) graphregion(fcolor(white)) name(fig1) aspectratio(1) ///	
				caption( "AUC: `left_solid_name' `auc1', `left_dash_name' `auc2'", size(small) color(black) ring(0)  placement(se))


				clear	
				*graph of armed conflict
				use output/for_roc_two_`on_or_in'2

				rename modelname model
				sort model
				merge model using model_names
				sort id fpr tpr


				sum auc if what == "overall" & init == "`j'" & controls == "`k'" & estimation == "`x'"
				local auc1 = substr(string(round(`r(max)',.01)), 1, 3)
				sum auc if what == "within" & init == "`j'" & controls == "`k'" & estimation == "`x'"
				local auc2 = substr(string(round(`r(max)',.01)), 1, 3)

				twoway (line tpr fpr if what == "overall" & init == "`j'" 	& controls == "`k'" & estimation == "`x'",  lwidth(medthick) lpattern(solid)  sort) ///
				(line tpr fpr if what == "within" & init == "`j'" & controls == "`k'" & estimation == "`x'",  lwidth(medthick) lpattern(dash)  sort) ///	
				 (line fpr fpr if what == "overall" & init == "`j'" & controls == "`k'" & estimation == "`x'", color(gs10) lpattern(dash) sort), ///
				subtitle("b) `title_right'", color(black)) ytitle(`"True Positive Rate"') xtitle(`"False Positive Rate"') legend( order(1 "`right_solid_name'" 2 "`right_dash_name'") size(small)) xlabel(,grid) ///
				plotregion(fcolor(white)) graphregion(fcolor(white)) name(fig2) aspectratio(1) ///
				caption( "AUC: `right_solid_name' `auc1', `right_dash_name' `auc2'", size(small) color(black) ring(0)  placement(se))


				grc1leg fig1 fig2 , legendfrom(fig1) title("", color(black)  size(small)) subtitle("", color(black) size(small)) plotregion(fcolor(white)) graphregion(fcolor(white)) 

				graph export output/FigE12.eps ,replace
				*graph export figures/`k'_`j'_`x'_`on_or_in'.eps ,replace
				
			}


		}
	}
}










