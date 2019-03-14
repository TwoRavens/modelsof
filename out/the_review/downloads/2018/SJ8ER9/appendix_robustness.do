


clear all
set mem 2000m
set maxvar 30000
set matsize 10000

program drop _all
estimates clear
capture log close
set more off


*Our model: 1995-2012


	
*up until what number do we have control models?
global nc = 0

global control_vars 

*estimation models

global est_models xtreg



global start_year 1995

clear

********************************************************




#delimit;

local which_thetas ste;





program define final_loop;


	*test out of sample;
	local sm 0;
	

	tsset countryid year;
	

	
	local m 0;
	
	
	foreach what in $est_models {;
	

	
		*logit;
		if "`what'" == "clogit" {;
			local cond if samp==1 & conflict!=`6' & total_conflict >= `5' & tokens>0 & tokens!=., group(countryid) r iterate(100);
			local fe 2;
		};
		if "`what'" == "xtlogit" {;
			local cond if samp==1 & conflict!=`6' & total_conflict >= `5' & tokens>0 & tokens!=., fe iterate(100);
			local fe 2;
		};
	
		*linear;
		if substr("`what'", length("`what'")-2, length("`what'")) == "reg" {;
			local cond if samp==1 & conflict!=`6' & total_conflict >= `5' & tokens>0 & tokens!=., fe r;
			local fe 1;
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
foreach gaga in  2 {;


	if "`gaga'" == "1" {;
		global included incidence;
		local cheat .;
	};
	if "`gaga'" == "2" {;
		global included onset;
		local cheat 1;
	};
	
	foreach j in 5 15 50 70 {;

	*foreach conflict_type in 1 2 3 4 5 6 7 8 {;
		local C 3;
		local C0 2;
		if `j' == 15 {;
			local C 8;
			local C0 1;
		};
		*forval c = `C0' / `C'  {;
		forval conflict_type = `C0' / `C'{;
	
	*foreach conflict_type in  5 6 {;
	


		set more off;
	

		local round 1;



		foreach k in 0 1 3 5 10 {;	

			foreach l in 001 {;
	

				*foreach w in both conflict {;
				foreach w in both  {;

					*foreach v in all triple WashingtonPost NYT Economist {;
					foreach v in all {;
				
					

						
						
							
						
							local s = (`j'-1) ;
						
						
														
							capture confirm file "thetas`j'_alpha`k'_beta`l'_`v'_`w'_collapsed2015.dta";
							


							display _rc;
							
							*display "thetas`j'_alpha`k'_beta`l'_`v'_`w'_collapsed2015.dta";


							if _rc==0  {;

								clear;

								use "thetas`j'_alpha`k'_beta`l'_`v'_`w'_collapsed2015.dta", clear;
								
															
								
						
								capture confirm variable year;
								if !_rc {;
							
								};
								else {;
									gen year = int(date/10000);
								};
						
								


						
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
						
						
								
								if `conflict_type' == 2 {;
						
									quietly gen conflict = bdbest25;
									
								};
						
								if `conflict_type' == 3 {;
															
									quietly gen conflict = bdbest1000;
							
								};
								
								if `j' == 15 {;
								
									if `conflict_type' == 1 {;
						
										quietly gen conflict = violence;
											
									};
							
								
									if `conflict_type' == 4 {;
															
										quietly gen conflict = conflictpc;
							
									};
								
									if `conflict_type' == 5 {;
															
										quietly gen conflict = 0 if refugees != .;
										quietly replace conflict = 1 if refugees != . & refugees > 30000;
							
									};
								
									if `conflict_type' == 6 {;
															
										quietly gen conflict = 0 if refugees != .;
										quietly replace conflict = 1 if refugees != . & refugees > 130000;
							
									};
								
									if `conflict_type' == 7 {;
															
										quietly gen conflict = max(conflict_int, bdbest25);
							
									};
								
									if `conflict_type' == 8 {;
															
										quietly gen conflict = max(conflict_int, bdbest1000);
							
									};
								
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
						
													saveold output/robust_predict_`x'_${included}_int`conflict_type'_to`j'_alpha`k'_beta`l'_`v'_`w', replace;
												};
												if `t1' > $start_year {;					
													append using output/robust_predict_`x'_${included}_int`conflict_type'_to`j'_alpha`k'_beta`l'_`v'_`w';
													saveold output/robust_predict_`x'_${included}_int`conflict_type'_to`j'_alpha`k'_beta`l'_`v'_`w', replace;
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
