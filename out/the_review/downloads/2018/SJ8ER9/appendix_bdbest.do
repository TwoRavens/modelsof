

clear all
set mem 2000m
set maxvar 30000
set matsize 10000

program drop _all
estimates clear
capture log close
set more off


*Our model: 1995-2012

local l 1
*Events: 2000-2012
global controls`l' high low autoc democ excludedshare excludedshare_sq lnchildmortality  armedconf4 discrimshare 
global name`l' ward
global fy`l' 2000
global ly`l' 2012

local l = `l' + 1

*bdbest
global controls`l'
global name`l' bdbest
global fy`l' 1995
global ly`l' 2012



	
*up until what number do we have control models?
global nc = `l'

global control_vars 
forval c = 1 / $nc {
	global control_vars $control_vars ${controls`c'}
}

*estimation models

global est_models xtreg



global start_year 1995


*
clear
*three estimations (xtreg,...), three model combos, overall+within
local new = $nc * 2 * 1 * 2 + 1 * 2
set obs `new'
gen model = ""
gen controls = ""
gen estimation = ""
gen init = ""
gen what = ""
local k 0
local u 1
	
foreach p in $est_models {
	forval c = 1 / $nc {
		foreach j in controls controls+thetas {
			forval x = 0 / 1 {
				display "${name`c'}"
				display "`k'"
				local k = `k' + 1
				replace init = "`j'" if _n == `k'
				replace controls = "${name`c'}" if _n == `k'
				replace estimation = "`p'" if _n == `k'
				if `x' == 0 {
				
					replace model = "`u'" if _n == `k'
					replace what = "overall" if _n == `k'
				}
				if `x' == 1 {
					local u = `k'/2 
					*local u = `k' - 1
					replace model = "`u'w" if _n == `k'
					replace what = "within" if _n == `k'
					local u = `k'/2  + 1
				}
			}
		}
	}
	foreach j in thetas {
			forval x = 0 / 1 {
				display "hachris"
				display "`k'"
				local k = `k' + 1
				replace init = "`j'" if _n == `k'
				replace controls = "hachris" if _n == `k'
				replace estimation = "`p'" if _n == `k'
				if `x' == 0 {
				
					replace model = "`u'" if _n == `k'
					replace what = "overall" if _n == `k'
				}
				if `x' == 1 {
					local u = `k'/2 
					*local u = `k' - 1
					replace model = "`u'w" if _n == `k'
					replace what = "within" if _n == `k'
					local u = `k'/2  + 1
				}
			}
		}
}
gen id = _n
sort model
save model_names_bdbest, replace
outsheet using model_names_bdbest.csv, comma replace
	
	
clear

********************************************************




#delimit;

local which_thetas ste;

*XXX;
*local who_uses hannesmueller;
local who_uses christopherINET;





program define final_loop;


	*test out of sample;
	local sm 0;
	

	tsset countryid year;
	

	
	local m 0;
	
	
	foreach what in $est_models {;
	

	
		*logit;
		if "`what'" == "clogit" {;
			local cond bdbest25 if samp==1 & conflict!=`6' & total_conflict >= `5' & tokens>0 & tokens!=., group(countryid) r iterate(100);
			local fe 2;
		};
		if "`what'" == "xtlogit" {;
			local cond bdbest25 if samp==1 & conflict!=`6' & total_conflict >= `5' & tokens>0 & tokens!=., fe iterate(100);
			local fe 2;
		};
	
		*linear;
		if substr("`what'", length("`what'")-2, length("`what'")) == "reg" {;
			local cond bdbest25 if samp==1 & conflict!=`6' & total_conflict >= `5' & tokens>0 & tokens!=., fe r;
			local fe 1;
		};
				
			
		forval c = 1 / $nc {;
					


			local m = `m' + 1;
			
			
			
			if `4' >= ${fy`c'} & `4' <= ${ly`c'} {;
						
	
				local controls ${controls`c'};
				
					
			
				*display "`controls'";
				
				*controls;	
				cap quietly `what' `1'_before `controls' `cond';			
			
				if !_rc {;
			
					if `fe' == 1 {;
						cap predict model`m' if tokens>0 & tokens!=., xb;
						cap predict model`m'_fe if tokens>0 & tokens!=., u;
					};
					if `fe' == 2 {;
						cap predict model`m' if tokens>0 & tokens!=.;
						cap predict model`m'w if tokens>0 & tokens!=., pu0;
					};
					if `fe' == 0 {;
						cap predict model`m' if tokens>0 & tokens!=.;				
					};
				};
				
			};
			
					
			
			local m = `m' + 1;
			
			if `4' >= ${fy`c'} & `4' <= ${ly`c'} {;
	
				*controls + thetas;				
				cap quietly `what' `1'_before `controls' `3'_theta1-`3'_theta`2' `cond';


				if !_rc {;
					if `fe' == 1 {;
						cap predict model`m' if tokens>0 & tokens!=., xb;
						cap predict model`m'_fe if tokens>0 & tokens!=., u;
					};
					if `fe' == 2 {;
						cap predict model`m' if tokens>0 & tokens!=.;
						cap predict model`m'w if tokens>0 & tokens!=., pu0;
					};
					if `fe' == 0 {;
						cap predict model`m' if tokens>0 & tokens!=.;				
					};
				};
			};
	
			
		*end control models;	
		};
		
		local m = `m' + 1;
		

		*only thetas;		
		cap quietly `what' `1'_before `3'_theta1-`3'_theta`2' `cond';		
			
		

		if !_rc {;
			if `fe' == 1 {;
				cap predict model`m' if tokens>0 & tokens!=., xb;
				cap predict model`m'_fe if tokens>0 & tokens!=., u;
			};
			if `fe' == 2 {;
				cap predict model`m' if tokens>0 & tokens!=.;
				cap predict model`m'w if tokens>0 & tokens!=., pu0;
			};
			if `fe' == 0 {;
				cap predict model`m' if tokens>0 & tokens!=.;				
			};
		};
	
	*end estimation models;
	};
	

	
	
	*creating with fixed effect;
	sort countryid;
	
	local models;
	
	forval b = 1 / `m' {;
	
		local models `models' model`b';
		
		capture confirm variable model`b'w;
		
		if !_rc {;
		
			local models `models' model`b'w;
			
		};
	
		capture confirm variable model`b'_fe;
		
		if !_rc {;
		
			local models `models' model`b'w;

			cap by countryid: egen fixed = mean(model`b'_fe);
		
			cap replace fixed=0 if fixed == . & model`b' != .;
			
			rename model`b' model`b'w ; 
	
			cap gen model`b' = model`b'w + fixed;
	
			cap drop fixed;
			
		};
		
	};
		
			



		
	******testing prediction;
	
	keep if year == `4' + 1;
		
	foreach vv in `models' {;
	
		
		cap gen p_`1'_`vv' = `vv' if samp == 0 & year == `4' + 1;
				
	
		
	};
	
	keep  p_`1'_* year country countryid conflict;
	
	

end;
  
  
  
 


*foreach gaga in 1 2 {;
foreach gaga in 2 {;


	if "`gaga'" == "1" {;
		global included incidence;
		local cheat .;
	};
	if "`gaga'" == "2" {;
		global included onset;
		local cheat 1;
	};

	foreach conflict_type in  3 {;
	

		*local models tok not noc bas lag lgg pan puf wib wit wic wiw  pab pam;


		set more off;
				
		local j 25;
		local k 10;
		local l 0025;
		local v all;
		local w both;
					
		local trials 10;


		local round 1;

		local trials 100;
 

		foreach k in  3 {;	

			foreach l in 001 {;
	

				*foreach w in both conflict {;
				foreach w in both  {;

					*foreach v in all triple WashingtonPost NYT Economist {;
					foreach v in all {;
				
						*foreach j in 5 10 15 25 30 {;
						foreach j in 15  {;
								
							display  "thetas`j'_alpha`k'_beta`l'_`v'_`w'_collapsed2015.dta";
					



							capture confirm file "thetas`j'_alpha`k'_beta`l'_`v'_`w'_collapsed2015.dta";

							display _rc;

							if _rc==0  {;

								clear;

								display  "thetas`j'_alpha`k'_beta`l'_`v'_`w'_collapsed2015.dta";
						

	
								use "thetas`j'_alpha`k'_beta`l'_`v'_`w'_collapsed2015.dta", clear;
						
								capture confirm variable year;
								if !_rc {;
							
								};
								else {;
									gen year = int(date/10000);
								};
						
								local s = (`j'-1) ;


						
								if "`k'" == "10" {;
									local real_alpha 10;
								};
						
								if "`k'" == "5" {;
									local real_alpha 5;
								};
						
								if "`k'" == "3" {;
									local real_alpha = 50/`j';
								};
							
								if "`k'" == "0" {;
									local real_alpha = 50/`j';
								};
						
								if "`k'" == "2" {;
									local real_alpha 2;
								};
							
								if "`k'" == "025" {;
									local real_alpha 0.25;
								};
						
								if "`k'" == "05" {;
									local real_alpha 0.5;
								};
						
								if "`k'" == "1" {;
									local real_alpha 1;
								};
							
								if "`k'" == "01" {;
									local real_alpha 0.1;
								};
						
					
					

					
								sort countryid year;
					
								merge 1:1 countryid year using complete_main_new.dta;
					
						
								drop _merge;
						

								generate conflictpc = bdbest34/pop>0.08;
								replace conflictpc = . if bdbest34==. | pop==.;
	

								tsset countryid year;
						
						
								if `conflict_type' == 1 {;
						
									quietly gen conflict = violence;
											
								};
							
								if `conflict_type' == 2 {;
						
									quietly gen conflict = bdbest25;
									
								};
						
								if `conflict_type' == 3 {;
															
									quietly gen conflict = bdbest1000;
							
								};

                        
                        
								generate one_before=conflict==0&F1.conflict==1;
								generate two_before=conflict==0&(F1.conflict==1|F2.conflict==1);
							
							
								if "`cheat'" == "." {;
									replace one_before= 1 if conflict==1&F1.conflict==1;
									replace two_before= 1 if conflict==1&(F1.conflict==1|F2.conflict==1);
								};
						
								generate sincelast = conflict==0;
								replace sincelast = L1.sincelast+1 if L1.sincelast>0 & l1.sincelast!=. & conflict==0;
						
								generate sincelast_sq = sincelast*sincelast;
								generate sincelast_cu = sincelast_sq*sincelast;

						
								by countryid: egen total_conflict = sum(conflict);
						
						
								drop country;
								merge m:1 countryid using countryids.dta;
								drop _merge;

						
						

								gen xconsthigh =xconst==7;
								gen xrcomphigh =xrcomp==3;
								gen xropenhigh =xropen==4;
								replace polity2 =0 if polity2==. & xconst!=.;
								tabulate democracy, gen(democ_);
								generate armedconf4 = contig_bdbest25>3;
								replace armedconf4 = . if contig_bdbest25==.;
						
								generate lngdp = ln(rgdpl);
			
								tsset countryid year;    
								generate growth = (rgdpl-L1.rgdpl)/L1.rgdpl;

						
													
								
								
								foreach there in $control_vars {;
									sum `there';
								};
																	
								*one and two years before conflict;
								*foreach x in one two {;
								foreach x in one {;
															
									*****ll=0 is all countries, 1 only countries that ever had conflict;
									forvalues ll = 0/0 {;
									
										display "`ll'";
															
										***random years as sample criterium;

										local so y;
										

										foreach h in `which_thetas' {;
										
												
								
			

											forval t1 = $start_year / 2012 {;
												
												drop token* *theta*;
													
												sort countryid year;
												local ttime = `t1' + 1;
													


												merge 1:1 countryid year using "thetas`j'_alpha`k'_beta`l'_`v'_`w'_collapsed`ttime'.dta";

													
													
												drop _merge;
												
												drop avpop pop;
												
												sort countryid year;												
												merge 1:1 countryid year using complete_main_new.dta, keepusing(pop);	
												
												drop _merge;
												
												bysort countryid: egen avpop=mean(pop);
												drop if avpop==.;
												drop if avpop<1000;
												replace pop = ln(pop);
												
												quietly gen samp = 0;
												quietly replace samp = 1 if year <= `t1';
													
												sort countryid year;
											
												forval t = 0 / `s' {;
													replace ste_theta`t'=L1.ste_theta`t' if L1.ste_theta`t'!=. & ste_theta`t'==. & year <= `t1'+1;
			
												};
														
											
												replace tokens=L1.tokens if L1.tokens!=. & tokens==. & year <= `t1'+1;
												replace tokens_sq = L1.tokens_sq if L1.tokens_sq!=. & tokens_sq==.& year <= `t1'+1;
			
					
												foreach ja in topics beta alpha paper selected conf years {;
						
													cap replace `ja'=L1.`ja' if L1.`ja'!=. & `ja'==. & year<2011;
													cap replace `ja'=L1.`ja' if L1.`ja'!="" & `ja'=="" & year<2011;
						
												};
				
												save tempo, replace;
												final_loop `x' `s' `h' `t1' `ll' `cheat' `conflict_type';
													
												if `t1' == $start_year {;					
						
													saveold output/bdbest_predict_`x'_${included}_int`conflict_type'_to`j'_alpha`k'_beta`l'_`v'_`w', replace;
												};
												if `t1' > $start_year {;					
													append using output/bdbest_predict_`x'_${included}_int`conflict_type'_to`j'_alpha`k'_beta`l'_`v'_`w';
													saveold output/bdbest_predict_`x'_${included}_int`conflict_type'_to`j'_alpha`k'_beta`l'_`v'_`w', replace;
												};	
												
												clear;
												use tempo;
												drop samp;
													
											};
												
																						
			
												
										};
											
											


									};
								
						
								};
						
							
							
							
					
								
						
							
							};
						
						
						};
			
			
					};
				};
			};

		};
	};

};


erase tempo.dta;
