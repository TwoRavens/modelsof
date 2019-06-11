
***Programs to rename variables
capture program drop rename_2vars
program define rename_2vars
	args mod11 mod12 mod2
	rename `mod11'_num mod11_num
	rename `mod12'_num mod12_num
	rename `mod2' mod2
	drop if (mod2=="N")
end

capture program drop rename_3vars
program define rename_3vars
	args mod11 mod12 mod13 mod2
	rename `mod11'_num mod11_num
	rename `mod12'_num mod12_num
	rename `mod13'_num mod13_num
	rename `mod2' mod2
	drop if (mod2=="N")
end

***Program to calculate letter grades from numerical scores
capture program drop letter_grade
program define letter_grade
	args contvar stubname

	quietly g `contvar'_`stubname'=""
	replace `contvar'_`stubname'="A" if (`contvar'>=4.5 & `contvar'!=.)
	replace `contvar'_`stubname'="B" if (`contvar'>=3.5 & `contvar'<4.5)
	replace `contvar'_`stubname'="C" if (`contvar'>=2.5 & `contvar'<3.5)
	replace `contvar'_`stubname'="D" if (`contvar'>=1.5 & `contvar'<2.5)
	replace `contvar'_`stubname'="E" if (`contvar'<1.5)
	replace `contvar'_`stubname'="N" if (`contvar'==.)
end

***Program to merge in the 2-way/3-way score and rename vars accordingly. This is useful when you first combine mod1 scores via the 2-way/3-way, before combining again to get the actual mod score. In this case, the grade for the intermediate combination is not in the original data2set and needs to be merged in. It is also useful for merging in the grade at the nearest point on the threshold. 

capture program drop merge_2way
program define merge_2way
	args mod11 mod12 output
	insheet using hes70_dectab_2way.csv, comma clear names
	rename input1 `mod11'
	rename input2 `mod12'
	rename output `output'
	merge 1:n `mod11' `mod12' using temp2
	drop if _merge==1
	drop _merge
end 

capture program drop merge_3way
program define merge_3way
	args mod11 mod12 mod13 output
	insheet using hes70_dectab_3way.csv, comma clear names
	rename input1 `mod11'
	rename input2 `mod12'
	rename input3 `mod13'	
	rename output `output'
	merge 1:n `mod11' `mod12' `mod13' using temp2
	drop if _merge==1
	drop _merge
end 

*calculates the distance moved to the threshold when combining mod1 scores
*this distance depends where you are at - an A would move down to the 4.5 B threshold, whereas a B would move up to the 4.5 A threshold. Each grade has two thresholds, from above and below. If the mod already has that grade, than the distance to that grade threshold is set to missing
capture program drop dist_mod1
program define dist_mod1
	args modin
	* A threshold (from below)
	
	g m_`modin'_5=.
	replace m_`modin'_5=4.501-`modin'_num if `modin'_num<4.5
	* B threshold (from above & below)
	g m_`modin'_4=.
	replace m_`modin'_4=4.499-`modin'_num if `modin'_num>=4.5
	replace m_`modin'_4=3.501-`modin'_num if `modin'_num<3.5
	* C threshold (from above & below)
	g m_`modin'_3=.
	replace m_`modin'_3=3.499-`modin'_num if `modin'_num>=3.5
	replace m_`modin'_3=2.501-`modin'_num if `modin'_num<2.5	
	* D threshold (from above & below)
	g m_`modin'_2=.
	replace m_`modin'_2=2.499-`modin'_num if `modin'_num>=2.5
	replace m_`modin'_2=1.501-`modin'_num if `modin'_num<1.5		
	* E threshold (from above)
	g m_`modin'_1=.
	replace m_`modin'_1=1.499-`modin'_num if `modin'_num>=1.5			
end

*calculates the distance to the nearest threshold in cases where it hasn't already been calculated (i.e. in the first layer of model combinations)
*mod_id = A, B or C
capture program drop dist_thresh1
program define dist_thresh1
	args mod_id modin
	* A threshold (from below)
	g mod`mod_id'_d_5=m_`modin'_5
	* B threshold (from above & below)
	g mod`mod_id'_d_4=m_`modin'_4
	* C threshold (from above & below)
	g mod`mod_id'_d_3=m_`modin'_3
	* D threshold (from above & below)
	g mod`mod_id'_d_2=m_`modin'_2	
	* E threshold (from above)
	g mod`mod_id'_d_1=m_`modin'_1
end

***Program to caclulate pertubations using the two way table
*opp is <= if perturbing up and >= if perturbing down
*ctr (counter) starts at 1 and equals 2, 3, 4, 5 (B, C ,D, E) for perturbing up and at 0 (values 1, 2, 3, 4 for E, D, C, B) for perturbing down
*fname is the filename - "up" for perturbing up and "down" for perturbing down
capture program drop combine_2way
program define combine_2way
	args a1 a2 a3 a4 a5 a6 a7 a8 ctr opp fname

	use data2, clear
	
	local a=`ctr'
	local b=`ctr'
	foreach A in `a1' `a2' `a3' `a4' {
		local a=`a'+1
		local b=`ctr'
		foreach B in `a5' `a6' `a7' `a8' {
			local b=`b'+1
			
			di "`a' `A'"
			di "`b' `B'"
		
			**Changing 1 score at a time
			di "changing mod11"
			capture g p1_`a'9=`A'
			capture g p2_`a'9=mod12_num
			capture g d_`a'9=abs(modA_d_`a')

			foreach M in $submodA {
				capture quietly g m_`M'_`a'9=m_`M'_`a'
			}
	
			foreach M in $submodB {
				capture quietly g m_`M'_`a'9=0
			}
								
			foreach V of varlist p1_`a'9 p2_`a'9 d_`a'9 m_*_`a'9 {
				replace `V'=. if (`A' `opp' mod11_num | mod11_num==.)
			}
			
			di "changing mod12"
			capture g p1_9`b'=mod11_num
			capture g p2_9`b'=`B'
			capture g d_9`b'=abs(modB_d_`b')

			foreach M in $submodA {
				capture quietly g m_`M'_9`b'=0
			}
	
			foreach M in $submodB {
				capture quietly g m_`M'_9`b'=m_`M'_`b'
			}
				
			foreach V of varlist p1_9`b' p2_9`b' d_9`b' m_*_9`b' {
				replace `V'=. if (`B' `opp' mod12_num | mod12_num==.)
			}	
						
			**Changing 2 scores at a time
			di "changing both mods"
			capture g p1_`a'`b'=`A'
			capture g p2_`a'`b'=`B'
			capture g d_`a'`b'=sqrt((modA_d_`a')^2+(modB_d_`b')^2)


			foreach M in $submodA {
				capture quietly g m_`M'_`a'`b'=m_`M'_`a'
			}
	
			foreach M in $submodB {
				capture quietly g m_`M'_`a'`b'=m_`M'_`b'
			}
						
			foreach V of varlist p1_`a'`b' p2_`a'`b' d_`a'`b' m_*_`a'`b' {
				replace `V'=. if (`A' `opp' mod11_num | `B' `opp' mod12_num | mod11_num==. | mod12_num==.)
			}		
		}
	}

	drop m_mod1*_1 m_mod1*_2 m_mod1*_3 m_mod1*_4 m_mod1*_5
	keep mod2 corps-date ham p1_* p2_* d_* m_mod1*
	reshape long p1_ p2_ d_ $submodA_ $submodB_, i(mod2 corps-date ham) j(pert)

	drop if d_==.
	
	*drop pert
	save `fname', replace
end


**Calculate distance to each possible point on a higher threshold
***Program to caclulate pertubations using the three way table
*opp is <= if perturbing up and >= if perturbing down
*ctr (counter) starts at 1 and equals 2, 3, 4, 5 (B, C ,D, E) for perturbing up and at 0 (values 1, 2, 3, 4 for E, D, C, B) for perturbing down
*fname is the filename - "up" for perturbing up and "down" for perturbing down
capture program drop combine_3way
program define combine_3way
	args a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 ctr opp fname

	use data2, clear
	local a=`ctr'
	local b=`ctr'
	local c=`ctr'
	foreach A in `a1' `a2' `a3' `a4' {
		local a=`a'+1
		local b=`ctr'
		foreach B in `a5' `a6' `a7' `a8' {
			local b=`b'+1
			local c=`ctr'
			foreach C in `a9' `a10' `a11' `a12' {
				local c=`c'+1	
				
				di "`a' `b' `c'"
				di "`A' `B' `C'"
				
				**Changing 1 score at a time - mod11
				di "Changing 1 score at a time - mod11"
				capture g p1_`a'99=`A'
				capture g p2_`a'99=mod12_num
				capture g p3_`a'99=mod13_num 
				capture g d_`a'99=abs(modA_d_`a')
				
				foreach M in $submodA {
					capture quietly g m_`M'_`a'99=m_`M'_`a'
				}
		
				foreach M in $submodB {
					capture quietly g m_`M'_`a'99=0
				}

				foreach M in $submodC {
					capture quietly g m_`M'_`a'99=0
				}
													
				foreach V of varlist p1_`a'99 p2_`a'99 d_`a'99 m_*_`a'99 {
					replace `V'=. if (`A' `opp' mod11_num | mod11_num==.)
				}
				
				**Changing 1 score at a time - mod12	
				di "Changing 1 score at a time - mod12"	
				capture g p1_9`b'9=mod11_num
				capture g p2_9`b'9=`B'
				capture g p3_9`b'9=mod13_num
				capture g d_9`b'9=abs(modB_d_`b')
				
				foreach M in $submodA {
					capture quietly g m_`M'_9`b'9=0
				}
		
				foreach M in $submodB {
					capture quietly g m_`M'_9`b'9=m_`M'_`b'
				}

				foreach M in $submodC {
					capture quietly g m_`M'_9`b'9=0
				}
					
				foreach V of varlist p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 m_*_9`b'9 {
					replace `V'=. if (`B' `opp' mod12_num | mod12_num==.)
				}

				**Changing 1 score at a time - mod13	
				di "Changing 1 score at a time - mod13"
				capture g p1_99`c'=mod11_num
				capture g p2_99`c'=mod12_num
				capture g p3_99`c'=`C'
				capture g d_99`c'=abs(modC_d_`c')
				
				foreach M in $submodA {
					capture quietly g m_`M'_99`c'=0
				}
		
				foreach M in $submodB {
					capture quietly g m_`M'_99`c'=0
				}

				foreach M in $submodC {
					capture quietly g m_`M'_99`c'=m_`M'_`c'
				}
					
				foreach V of varlist p1_99`c' p2_99`c' p3_99`c' d_99`c' m_*_99`c' {
					replace `V'=. if (`C' `opp' mod13_num | mod13_num==.)
				}
							
				**Changing 2 scores at a time - mod11 and mod12
				di "Changing 2 scores at a time - mod11 and mod12"
				capture g p1_`a'`b'9=`A'
				capture g p2_`a'`b'9=`B'
				capture g p3_`a'`b'9=mod13_num
				capture g d_`a'`b'9=sqrt((modA_d_`a')^2+(modB_d_`b')^2)

				foreach M in $submodA {
					capture quietly g m_`M'_`a'`b'9=m_`M'_`a'
				}
		
				foreach M in $submodB {
					capture quietly g m_`M'_`a'`b'9=m_`M'_`b'
				}

				foreach M in $submodC {
					capture quietly g m_`M'_`a'`b'9=0
				}
					
				foreach V of varlist p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 m_*_`a'`b'9 {
					replace `V'=. if (`A' `opp' mod11_num | `B' `opp' mod12_num | mod11_num==. | mod12_num==.)
				}
						
				**Changing 2 scores at a time - mod11 and mod13	
				di "Changing 2 scores at a time - mod11 and mod13"		
				capture g p1_`a'9`c'=`A'
				capture g p2_`a'9`c'=mod12_num
				capture g p3_`a'9`c'=`C'
				capture g d_`a'9`c'=sqrt((modA_d_`a')^2+(modC_d_`c')^2)

				foreach M in $submodA {
					capture quietly g m_`M'_`a'9`c'=m_`M'_`a'
				}
		
				foreach M in $submodB {
					capture quietly g m_`M'_`a'9`c'=0
				}

				foreach M in $submodC {
					capture quietly g m_`M'_`a'9`c'=m_`M'_`c'
				}
					
				foreach V of varlist p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' m_*_`a'9`c' {
					replace `V'=. if (`A' `opp' mod11_num | `C' `opp' mod13_num | mod11_num==. | mod13_num==.)
				}
				
				**Changing 2 scores at a time - mod12 and mod13
				di "Changing 2 scores at a time - mod12 and mod13"			
				capture g p1_9`b'`c'=mod11_num
				capture g p2_9`b'`c'=`B'
				capture g p3_9`b'`c'=`C'
				capture g d_9`b'`c'=sqrt((modB_d_`b')^2+(modC_d_`c')^2)
				
				foreach M in $submodA {
					capture quietly g m_`M'_9`b'`c'=0
				}
		
				foreach M in $submodB {
					capture quietly g m_`M'_9`b'`c'=m_`M'_`b'
				}

				foreach M in $submodC {
					capture quietly g m_`M'_9`b'`c'=m_`M'_`c'
				}
					
				foreach V of varlist p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' m_*_9`b'`c' {
					replace `V'=. if (`B' `opp' mod12_num | `C' `opp' mod13_num | mod12_num==. | mod13_num==.)
				}
							
				**Changing 3 scores at a time - mod11, mod12, and mod13
				di "Changing 3 scores at a time - mod11, mod12, and mod13"
				capture g p1_`a'`b'`c'=`A'
				capture g p2_`a'`b'`c'=`B'
				capture g p3_`a'`b'`c'=`C'
				capture g d_`a'`b'`c'=sqrt((modA_d_`a')^2+(modB_d_`b')^2+(modC_d_`c')^2)
				
				foreach M in $submodA {
					capture quietly g m_`M'_`a'`b'`c'=m_`M'_`a'
				}
		
				foreach M in $submodB {
					capture quietly g m_`M'_`a'`b'`c'=m_`M'_`b'
				}

				foreach M in $submodC {
					capture quietly g m_`M'_`a'`b'`c'=m_`M'_`c'
				}
								
				foreach V of varlist p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' m_*_`a'`b'`c' {
					replace `V'=. if (`A' `opp' mod11_num | `B' `opp' mod12_num | `C' `opp' mod13_num | mod11_num==. | mod12_num==. | mod13_num==.)
				}			
			}
		}
	}
	drop m_mod1*_1 m_mod1*_2 m_mod1*_3 m_mod1*_4 m_mod1*_5
	keep mod2 corps-date ham p1_* p2_* p3* d_* m_mod1*
	reshape long p1_ p2_ p3_ d_ $submodA_ $submodB_ $submodC_, i(mod2 corps-date ham) j(pert)

	drop if d_==.
	drop pert
	save `fname', replace
end

***Calculate the min distance to each threshold
capture program drop min_dist
program define min_dist
	 args modname
	 
	*drop if grade at near point is the same as grade at the original point
	drop if mod2==mod2pert

	*keep min dis5ance movement
	egen min_dist=min(d_), by(corps-date ham mod2pert)
	keep if min_dist==d_
	
	keep corps-date ham mod2 mod2pert d_ $points  $submodA_ $submodB_ $submodC_
	duplicates drop d_ corps-date ham mod2  mod2pert, force /*there are a very small # of observations that are equidistant from two different points on the same threshold; keep only one of these points (both will produce equiv distance to the threshold*/
	
	*create a numerical variable with the grade at the threshold (mod2pert is an A B C D E string) and at the original mod score
	foreach M in mod2pert mod2 {
		g `M'_num=.
		replace `M'_num=5 if `M'=="A"
		replace `M'_num=4 if `M'=="B"
		replace `M'_num=3 if `M'=="C"
		replace `M'_num=2 if `M'=="D"
		replace `M'_num=1 if `M'=="E"
		drop `M'
	}

	rename p1 p1_ 	
	rename p2 p2_
	capture rename p3 p3_
	
	reshape wide d_ $points $submodA_ $submodB_ $submodC_, i(corps-date ham mod2_num) j(mod2pert_num) 
end

**Check that appropriate # of observations are missing
capture program drop check_missing
program define check_missing

	save data2, replace
	
	use proj2, clear
	keep corps-date ham $submodAnum $submodBnum $submodCnum
	merge 1:1 corps-date ham using data2
	keep if _merge==3
	drop _merge
		
	g mod1_miss=0
	foreach M in $submodA $submodB $submodC {
		replace mod1_miss=1 if `M'_num==.
	}
	
	bys mod1_miss: summ m_mod*
	bys mod1_miss: tab mod2
end

	
***Rename final output

capture program drop rename_final_out
program define rename_final_out
	args modin
	
	foreach V in d_5 d_4 d_3 d_2 d_1 {
		rename `V' `modin'_`V'
	}
	
	rename mod2_num `modin'_num
	
	drop p1* p2*  test* min_dist mod1* 
	capture drop p3*
end

capture program drop conflict
program define conflict

	*check how different movements are
	foreach M in mod1g mod1f mod1j mod1m {
		di "`M'"
		g diff_nums`M'=0
		replace diff_nums`M'=1 if m_`M'1_!=m_`M'2_
		summ diff_nums`M', detail
	}	

	*make sure scores do not move in opposite directions - this shouldn't happen given the nature of the space; if it did it would be indicative of an error
	foreach M in mod1g mod1f mod1j mod1m {
		g diff_sign`M'=0
		replace diff_sign`M'=1 if m_`M'1>0 & m_`M'2<0
		replace diff_sign`M'=1 if m_`M'1<0 & m_`M'2>0
		tab diff_sign`M'
		drop diff_sign*
	}
	
	*create a variable with the max movement in the mod1g/f/j/m direction, in absolute value
	foreach M in mod1g mod1f mod1j mod1m {
		g temp21=abs(m_`M'1)
		g temp22=abs(m_`M'2)
		egen m_`M'_=rowmax(temp21 temp22)
		replace m_`M'_=-m_`M'_ if m_`M'1<0 /*assign the correct sign*/
		drop temp21 temp22
	}

	****now need to re-calculate to see if moving both the sub-model num scores the max one changes the HES score relative to moving each one separately. If so, drop the observation
	
	*first merge in with original mod1 scores
	tempfile mod1g
	save `mod1g', replace
	
	use proj2, clear
	keep corps-date ham mod1*_num
	merge 1:n corps-date ham using `mod1g'
	keep if _merge==3
	drop _merge mod2
	rename mod2pert mod8_threshold
	
	*create perturbed mod1 num scores - using the max mod1g/j/f/m movement
	foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
		recode m_`M'_ (.=0)
		quietly g `M'_pert=`M'_num+m_`M'_
	}
	
	**create perturbed mod1 letter scores - using the max mod1g movement
	foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
		quietly g `M'=""
		quietly replace `M'="A" if (`M'_pert>=4.5 & `M'_pert!=.)
		quietly replace `M'="B" if (`M'_pert>=3.5 & `M'_pert<4.5)
		quietly replace `M'="C" if (`M'_pert>=2.5 & `M'_pert<3.5)
		quietly replace `M'="D" if (`M'_pert>=1.5 & `M'_pert<2.5)
		quietly replace `M'="E" if (`M'_pert<1.5)
		quietly replace `M'="N" if (`M'_pert==.)	
		tab `M'
	}
	
	*calculate the hes70 mod8 score for the perturbed value, where mod1g has been constrained to be perturbed the same amount in both mod7a and mod7b
	do hes71_mod8_compute
	
	*create a dummy if using the max mod1g movement leads to a different HES score than perturbing mod1g in mod3a and mod1g in mod3b independently
	g diff_mod8=0
	replace diff_mod8=1 if mod8_pert!=mod8_thresh

	*check that diff_mod8 is 0 when diff_nums is zero /*the two mod1g movements are the same*/
	tab diff_mod8 if (diff_numsmod1g==0 & diff_numsmod1f==0 & diff_numsmod1j==0 & diff_numsmod1m==0)

	*this creates a list of perturbations to drop from the list of possible movements to the threshold, as well as the max g/f/j/m movements
	keep id m_mod1g_ m_mod1f_ m_mod1j_ m_mod1m_ diff_mod8
end

********************************************************************************
****PREP data2
********************************************************************************

use hes_all_models, clear /*only need to calculate for quarterly data2, 1971-72*/
keep corps-date ham mod* mth yr 
keep if yr>1970
drop if (mod8=="V") /*VC controlled*/
drop if (mod8=="N")
save proj2, replace

********************************************************************************
****SHORTEST DISTANCE TO MOD5A THRESHOLD ("MOD5A", "MOD1A", "MOD1B")
********************************************************************************

use proj2, clear
keep mod1a* mod1b* mod5a corps-date ham

*set global vars for this sub-model
global points p1 p2
global submodA mod1a
global submodB mod1b
global submodC 
global submodA_ m_mod1a_
global submodB_ m_mod1b_
global submodC_ 
global submodAnum mod1a_num
global submodBnum mod1b_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1a
dist_mod1 mod1b

*calculate distance that first and second scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1a
dist_thresh1 B mod1b

*rename vars
rename_2vars mod1a mod1b mod5a
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1a_^2+ m_mod1b^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1a_^2+ m_mod1b^2)
summ test d_
drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod5a

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1a_`S')^2+(m_mod1b_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5a

**Save output
tempfile mod5a
save `mod5a', replace

********************************************************************************
***SHORTEST DISTANCE TO MOD5B THRESHOLD ("MOD5B", "MOD1E", "MOD1D", "MOD1G") 
********************************************************************************

use proj2, clear
keep mod1e* mod1d* mod1g* mod5b corps-date ham

*set global vars for this sub-model
global points p1 p2 p3
global submodA mod1e
global submodB mod1d
global submodC mod1g
global submodA_ m_mod1e_
global submodB_ m_mod1d_
global submodC_ m_mod1g_
global submodAnum mod1e_num
global submodBnum mod1d_num
global submodCnum mod1g_num

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1e
dist_mod1 mod1d
dist_mod1 mod1g

*calculate distance that first, second, and third scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1e
dist_thresh1 B mod1d
dist_thresh1 C mod1g

*rename vars
rename_3vars mod1e mod1d mod1g mod5b
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_3way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1e_^2+ m_mod1d^2+ m_mod1g^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_3way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1e_^2+ m_mod1d^2+ m_mod1g^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
rename p3_ p3
letter_grade p1 score
letter_grade p2 score
letter_grade p3 score
save temp2, replace

***merge with grade at the near point
merge_3way p1_score p2_score p3_score mod2pert

***Calculate the min distance to each threshold
min_dist mod5b

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1e_`S')^2+(m_mod1d_`S')^2+(m_mod1g_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5b

**Save output
tempfile mod5b
save `mod5b', replace


********************************************************************************
***SHORTEST DISTANCE TO THE MOD6B THRESHOLD: ("MOD6B","MOD5A","MOD5B","MOD1C")
********************************************************************************

use proj2, clear
keep corps-date ham mod1c* mod6b
merge 1:1 corps-date ham using `mod5a'
drop _merge
merge 1:1 corps-date ham using `mod5b'
drop _merge

*set global vars for this sub-model
global points p1 p2 p3
global submodA mod1a mod1b
global submodB mod1d mod1e mod1g
global submodC mod1c
global submodA_ m_mod1a_ m_mod1b_
global submodB_ m_mod1d_ m_mod1e_ m_mod1g_
global submodC_ m_mod1c_
global submodAnum mod1a_num mod1b_num
global submodBnum mod1d_num mod1e_num mod1g_num
global submodCnum mod1c_num

*calculate distance that move individually to reach higher level threshold; mod1c only, as it is already calculate for the others
dist_mod1 mod1c

*calculate distance that first, second, and third scores move to reach the higher level threshold 
dist_thresh1 C mod1c
foreach S of num 1/5 {
	rename mod5a_d_`S' modA_d_`S'
	rename mod5b_d_`S' modB_d_`S'
}

*rename vars
rename_3vars mod5a mod5b mod1c mod6b
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_3way 2 3 4 5 2 3 4 5 1.5001 2.5001 3.5001 4.5001 1 <= up
g test=sqrt(m_mod1a_^2+ m_mod1b^2+ m_mod1c^2+m_mod1e_^2+ m_mod1d^2+ m_mod1g^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_3way 1 2 3 4 1 2 3 4 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1a_^2+ m_mod1b^2+ m_mod1c^2+m_mod1e_^2+ m_mod1d^2+ m_mod1g^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
rename p3_ p3
letter_grade p1 score
letter_grade p2 score
letter_grade p3 score
save temp2, replace

***merge with grade at the near point
merge_3way p1_score p2_score p3_score mod2pert

***Calculate the min distance to each threshold
min_dist mod6b

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1e_`S')^2+(m_mod1d_`S')^2+(m_mod1g_`S')^2+(m_mod1a_`S')^2+(m_mod1b_`S')^2+(m_mod1c_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod6b

**Save output
tempfile mod6b
save `mod6b', replace


********************************************************************************
****SHORTEST DISTANCE TO MOD5c THRESHOLD ("MOD5c", "mod1h", "mod1i")
********************************************************************************

use proj2, clear
keep mod1h* mod1i* mod5c corps-date ham

*set global vars for this sub-model
global points p1 p2
global submodA mod1h
global submodB mod1i
global submodC 
global submodA_ m_mod1h_
global submodB_ m_mod1i_
global submodC_ 
global submodAnum mod1h_num
global submodBnum mod1i_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1h
dist_mod1 mod1i

*calculate distance that first and second scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1h
dist_thresh1 B mod1i

*rename vars
rename_2vars mod1h mod1i mod5c
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1h_^2+ m_mod1i^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1h_^2+ m_mod1i^2)
summ test d_
drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod5c

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1h_`S')^2+(m_mod1i_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5c

**Save output
tempfile mod5c
save `mod5c', replace

********************************************************************************
****SHORTEST DISTANCE TO MOD5D THRESHOLD - ("MOD5D", ("MOD1J", MOD1F), "MOD1M")
********************************************************************************
use proj2, clear
keep mod1j* mod1f* mod1m* corps-date ham mod5d
save temp2, replace

******first put together mod1j and mod1f

*set global vars for this sub-model
global points p1 p2
global submodA mod1j
global submodB mod1f
global submodC 
global submodA_ m_mod1j_
global submodB_ m_mod1f_
global submodC_ 
global submodAnum mod1j_num
global submodBnum mod1f_num
global submodCnum 

*calculate the grade tha results from combining the original mod1j and mod1f num scores
merge_2way mod1j mod1f mod2mid

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1j
dist_mod1 mod1f

*calculate distance that first and second scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1j
dist_thresh1 B mod1f

*rename vars
rename_2vars mod1j mod1f mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1j_^2+ m_mod1f^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1j_^2+ m_mod1f^2)
summ test d_
drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1j_`S')^2+(m_mod1f_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod2mid

**Save output
tempfile mod2mid
save `mod2mid', replace

*****Now combine with mod1m
use proj2, clear
keep corps-date ham mod1m* mod5d
merge 1:1 corps-date ham using `mod2mid'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1j mod1f
global submodB mod1m
global submodC 
global submodA_ m_mod1j_ m_mod1f_
global submodB_ m_mod1m_
global submodC_ 
global submodAnum mod1j_num mod1f_num
global submodBnum mod1m_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1m

*calculate distance that first, second, scores move to reach the higher level threshold 
foreach S of num 1/5 {
	rename mod2mid_d_`S' modA_d_`S'
}
dist_thresh1 B mod1m

*rename vars
rename_2vars mod2mid mod1m mod5d
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1j_^2+m_mod1f_^2+ m_mod1m^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1j_^2+m_mod1f_^2+ m_mod1m^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod1d

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'=sqrt((m_mod1j_`S')^2+(m_mod1m_`S')^2+(m_mod1f_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5d

**Save output
tempfile mod5d
save `mod5d', replace

********************************************************************************
***SHORTEST DISTANCE TO MOD6A THRESHOLD ("MOD6A","MOD5C","MOD5D")
********************************************************************************
use proj2, clear
keep corps-date ham mod6a
merge 1:1 corps-date ham using `mod5c'
drop _merge
merge 1:1 corps-date ham using `mod5d'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1h mod1i
global submodB mod1j mod1f mod1m
global submodC 
global submodA_ m_mod1h_ m_mod1i_
global submodB_ m_mod1j_ m_mod1f_ m_mod1m_
global submodC_ 
global submodAnum mod1h_num mod1i_num
global submodBnum mod1j_num mod1f_num mod1m_num
global submodCnum 

*calculate distance that first, second, scores move to reach the higher level threshold 
foreach S of num 1/5 {
	rename mod5c_d_`S' modA_d_`S'
	rename mod5d_d_`S' modB_d_`S'
}

*rename vars
rename_2vars mod5c mod5d mod6a
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 2 3 4 5 1 <= up
g test=sqrt((m_mod1h)^2+(m_mod1i)^2+(m_mod1j)^2+(m_mod1f)^2+(m_mod1m)^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1 2 3 4 0 >= down
g test=sqrt((m_mod1h)^2+(m_mod1i)^2+(m_mod1j)^2+(m_mod1f)^2+(m_mod1m)^2)
summ test d_
drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod6a

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt((m_mod1h_`S')^2+(m_mod1i_`S')^2+(m_mod1j_`S')^2+(m_mod1f_`S')^2+(m_mod1m_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod6a

**Save output
tempfile mod6a
save `mod6a', replace

********************************************************************************
***SHORTEST DISTANCE TO THE MOD7A THRESHOLD (MOD7A, mod6A, MOD6B)
********************************************************************************
use proj2, clear
keep corps-date ham mod7a
merge 1:1 corps-date ham using `mod6a'
drop _merge
merge 1:1 corps-date ham using `mod6b'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1h mod1i mod1j mod1f mod1m
global submodB mod1a mod1b mod1c mod1d mod1e mod1g
global submodC 
global submodA_ m_mod1h_ m_mod1i_ m_mod1j_ m_mod1f_ m_mod1m_
global submodB_ m_mod1a_ m_mod1b_ m_mod1c_ m_mod1d_ m_mod1e_ m_mod1g_
global submodC_ 
global submodAnum mod1h_num mod1i_num mod1j_num mod1f_num mod1m_num
global submodBnum mod1a_num mod1b_num mod1c_num mod1d_num mod1e_num mod1g_num
global submodCnum 

*calculate distance that first, second, scores move to reach the higher level threshold 
foreach S of num 1/5 {
	rename mod6a_d_`S' modA_d_`S'
	rename mod6b_d_`S' modB_d_`S'
}

*rename vars
rename_2vars mod6a mod6b mod7a
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 2 3 4 5 1 <= up
g test=sqrt((m_mod1h)^2+(m_mod1i)^2+(m_mod1j)^2+(m_mod1f)^2+(m_mod1m)^2+m_mod1a_^2+ m_mod1b^2+ m_mod1c^2+m_mod1e_^2+ m_mod1d^2+ m_mod1g^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1 2 3 4 0 >= down
g test=sqrt((m_mod1h)^2+(m_mod1i)^2+(m_mod1j)^2+(m_mod1f)^2+(m_mod1m)^2+m_mod1a_^2+ m_mod1b^2+ m_mod1c^2+m_mod1e_^2+ m_mod1d^2+ m_mod1g^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod7a

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt((m_mod1h_`S')^2+(m_mod1i_`S')^2+(m_mod1j_`S')^2+(m_mod1f_`S')^2+(m_mod1m_`S')^2+(m_mod1e_`S')^2+(m_mod1d_`S')^2+(m_mod1g_`S')^2+(m_mod1a_`S')^2+(m_mod1b_`S')^2+(m_mod1c_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod7a

*Rename mod1g, which also appears in the economic model
foreach S in 5 4 3 2 1 {
	rename m_mod1g_`S' m_mod1g1_`S' 
	rename m_mod1j_`S' m_mod1j1_`S' 
	rename m_mod1f_`S' m_mod1f1_`S' 
	rename m_mod1m_`S' m_mod1m1_`S' 
}

**Save output
tempfile mod7a
save `mod7a', replace

********************************************************************************
***SHORTEST DISTANCE TO MOD5F THRESHOLD ("MOD5F", "MOD1O", "MOD1N","MOD1P") 
********************************************************************************

use proj2, clear
keep mod1o* mod1n* mod1p* mod5f corps-date ham

*set global vars for this sub-model
global points p1 p2 p3
global submodA mod1o
global submodB mod1n
global submodC mod1p
global submodA_ m_mod1o_
global submodB_ m_mod1n_
global submodC_ m_mod1p_
global submodAnum mod1o_num
global submodBnum mod1n_num
global submodCnum mod1p_num

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1o
dist_mod1 mod1n
dist_mod1 mod1p

*calculate distance that first, second, and third scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1o
dist_thresh1 B mod1n
dist_thresh1 C mod1p

*rename vars
rename_3vars mod1o mod1n mod1p mod5f
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_3way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1o_^2+ m_mod1n^2+ m_mod1p^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_3way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1o_^2+ m_mod1n^2+ m_mod1p^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
rename p3_ p3
letter_grade p1 score
letter_grade p2 score
letter_grade p3 score
save temp2, replace

***merge with grade at the near point
merge_3way p1_score p2_score p3_score mod2pert

***Calculate the min distance to each threshold
min_dist mod5f

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1o_`S')^2+(m_mod1n_`S')^2+(m_mod1p_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5f

**Save output
tempfile mod5f
save `mod5f', replace

********************************************************************************
*****SHORTEST DISTANCE TO MOD5E THRESHOLD ("MOD5E", ("MOD1Q", "MOD1S"), ("MOD1G", "MOD1L", "MOD1K"))
*MOD5E: CASE I, MOD1K AND MOD1S NON-MISSING
********************************************************************************
****Start out by comining mod1q and mod1s
use proj2, clear
keep mod1q* mod1s* mod1g* mod1l* mod1k* corps-date ham
drop if mod1s=="N"
drop if mod1k=="N"
save temp2, replace 

*calculate the grade tha results from combining the original mod1j and mod1f num scores
merge_2way mod1q mod1s mod2mid

*set global vars for this sub-model
global points p1 p2
global submodA mod1q
global submodB mod1s
global submodC 
global submodA_ m_mod1q_
global submodB_ m_mod1s_
global submodC_ 
global submodAnum mod1q_num
global submodBnum mod1s_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1q
dist_mod1 mod1s

*calculate distance that first and second scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1q
dist_thresh1 B mod1s

*rename vars
rename_2vars mod1q mod1s mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1q_^2+ m_mod1s^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1q_^2+ m_mod1s^2)
summ test d_
drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1q_`S')^2+(m_mod1s_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out modA

**Save output
tempfile modA
save `modA', replace

****Next combine mod1g mod1l and mod1k
use proj2, clear
keep mod1q* mod1s* mod1g* mod1l* mod1k* corps-date ham
drop if mod1s=="N"
drop if mod1k=="N"
save temp2, replace 

*set global vars for this sub-model
global points p1 p2 p3
global submodA mod1g
global submodB mod1l
global submodC mod1k
global submodA_ m_mod1g_
global submodB_ m_mod1l_
global submodC_ m_mod1k_
global submodAnum mod1g_num
global submodBnum mod1l_num
global submodCnum mod1k_num

*calculate the grade tha results from combining the original mod1j and mod1f num scores
merge_3way mod1g mod1l mod1k mod2mid

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1g
dist_mod1 mod1l
dist_mod1 mod1k

*calculate distance that first, second, and third scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1g
dist_thresh1 B mod1l
dist_thresh1 C mod1k

*rename vars
rename_3vars mod1g mod1l mod1k mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_3way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1g_^2+ m_mod1l^2+ m_mod1k^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_3way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1g_^2+ m_mod1l^2+ m_mod1k^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
rename p3_ p3
letter_grade p1 score
letter_grade p2 score
letter_grade p3 score
save temp2, replace

***merge with grade at the near point
merge_3way p1_score p2_score p3_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1g_`S')^2+(m_mod1l_`S')^2+(m_mod1k_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out modB

**Save output
tempfile modB
save `modB', replace

*****Now combine the above two outputs

use proj2, clear
drop if mod1s=="N"
drop if mod1k=="N"
keep corps-date ham mod5e
merge 1:1 corps-date ham using `modA'
drop _merge
merge 1:1 corps-date ham using `modB'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1q mod1s
global submodB mod1g mod1l mod1k
global submodC 
global submodA_ m_mod1q_ m_mod1s_
global submodB_ m_mod1g_ m_mod1l_ m_mod1k_
global submodC_ 
global submodAnum mod1q_num mod1s_num
global submodBnum mod1g_num mod1l_num mod1k_num
global submodCnum 

*rename vars
rename_2vars modA modB mod5e
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 2 3 4 5 1 <= up
g test=sqrt((m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g)^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1 2 3 4 0 >= down
g test=sqrt((m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g)^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod5e1

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt((m_mod1q_`S')^2+(m_mod1s_`S')^2+(m_mod1l_`S')^2+(m_mod1k_`S')^2+(m_mod1g_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5e

**Save output
tempfile mod5e1
save `mod5e1', replace

********************************************************************************
*****SHORTEST DISTANCE TO MOD5E THRESHOLD ("MOD5E", ("MOD1Q", "MOD1S"), ("MOD1G", "MOD1L", "MOD1K"))
**MOD5E: CASE 2, MOD1K MISSING, MOD1S NON-MISSING
********************************************************************************
****Start out by comining mod1q and mod1s
use proj2, clear
keep mod1q* mod1s* mod1g* mod1l* mod1k* corps-date ham
drop if mod1s=="N"
drop if mod1k!="N"
save temp2, replace 

*calculate the grade tha results from combining the original mod1j and mod1f num scores
merge_2way mod1q mod1s mod2mid

*set global vars for this sub-model
global points p1 p2
global submodA mod1q
global submodB mod1s
global submodC 
global submodA_ m_mod1q_
global submodB_ m_mod1s_
global submodC_ 
global submodAnum mod1q_num
global submodBnum mod1s_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1q
dist_mod1 mod1s

*calculate distance that first and second scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1q
dist_thresh1 B mod1s

*rename vars
rename_2vars mod1q mod1s mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1q_^2+ m_mod1s^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1q_^2+ m_mod1s^2)
summ test d_
drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1q_`S')^2+(m_mod1s_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out modA

**Save output
tempfile modA
save `modA', replace

****Combine mod1g and mod1l
use proj2, clear
keep mod1q* mod1s* mod1g* mod1l* mod1k* corps-date ham
drop if mod1s=="N"
drop if mod1k!="N"
save temp2, replace 

*calculate the grade tha results from combining the original mod1g and mod1l num scores
merge_2way mod1g mod1l mod2mid

*set global vars for this sub-model
global points p1 p2
global submodA mod1g
global submodB mod1l
global submodC 
global submodA_ m_mod1g_
global submodB_ m_mod1l_
global submodC_ 
global submodAnum mod1g_num
global submodBnum mod1l_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1g
dist_mod1 mod1l

*calculate distance that first and second scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1g
dist_thresh1 B mod1l

*rename vars
rename_2vars mod1g mod1l mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1g_^2+ m_mod1l^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1g_^2+ m_mod1l^2)
summ test d_
drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1g_`S')^2+(m_mod1l_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out modB

**Save output
tempfile modB
save `modB', replace

*****Now combine the above two outputs

use proj2, clear
drop if mod1s=="N"
drop if mod1k!="N"
keep corps-date ham mod5e
merge 1:1 corps-date ham using `modA'
drop _merge
merge 1:1 corps-date ham using `modB'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1q mod1s
global submodB mod1g mod1l
global submodC 
global submodA_ m_mod1q_ m_mod1s_
global submodB_ m_mod1g_ m_mod1l_ 
global submodC_ 
global submodAnum mod1q_num mod1s_num
global submodBnum mod1g_num mod1l_num 
global submodCnum 

*rename vars
rename_2vars modA modB mod5e
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 2 3 4 5 1 <= up
g test=sqrt((m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1g)^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1 2 3 4 0 >= down
g test=sqrt((m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1g)^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod5e2

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt((m_mod1q_`S')^2+(m_mod1s_`S')^2+(m_mod1l_`S')^2+(m_mod1g_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5e

**Save output
tempfile mod5e2
save `mod5e2', replace


********************************************************************************
*****SHORTEST DISTANCE TO MOD5E THRESHOLD ("MOD5E", ("MOD1Q", "MOD1S"), ("MOD1G", "MOD1L", "MOD1K"))
**MOD5E: CASE 3, MOD1K NON-MISSING, MOD1S MISSING
********************************************************************************

****Combine mod1g mod1l and mod1k
use proj2, clear
keep mod1q* mod1s* mod1g* mod1l* mod1k* corps-date ham
drop if mod1s!="N"
drop if mod1k=="N"
save temp2, replace 

*set global vars for this sub-model
global points p1 p2 p3
global submodA mod1g
global submodB mod1l
global submodC mod1k
global submodA_ m_mod1g_
global submodB_ m_mod1l_
global submodC_ m_mod1k_
global submodAnum mod1g_num
global submodBnum mod1l_num
global submodCnum mod1k_num

*calculate the grade tha results from combining the original mod1j and mod1f num scores
merge_3way mod1g mod1l mod1k mod2mid

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1g
dist_mod1 mod1l
dist_mod1 mod1k

*calculate distance that first, second, and third scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1g
dist_thresh1 B mod1l
dist_thresh1 C mod1k

*rename vars
rename_3vars mod1g mod1l mod1k mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_3way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1g_^2+ m_mod1l^2+ m_mod1k^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_3way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1g_^2+ m_mod1l^2+ m_mod1k^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
rename p3_ p3
letter_grade p1 score
letter_grade p2 score
letter_grade p3 score
save temp2, replace

***merge with grade at the near point
merge_3way p1_score p2_score p3_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1g_`S')^2+(m_mod1l_`S')^2+(m_mod1k_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out modB

**Save output
tempfile modB
save `modB', replace

*****Now combine mod1q and the above output

use proj2, clear
drop if mod1s!="N"
drop if mod1k=="N"
keep corps-date ham mod5e mod1q*
merge 1:1 corps-date ham using `modB'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1q
global submodB mod1g mod1l mod1k
global submodC 
global submodA_ m_mod1q_
global submodB_ m_mod1g_ m_mod1l_ m_mod1k_
global submodC_ 
global submodAnum mod1q_num
global submodBnum mod1g_num mod1l_num mod1k_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1q

*calculate distance that first, second, and third scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1q

*rename vars
rename_2vars mod1q modB mod5e
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 2 3 4 5 1 <= up
g test=sqrt((m_mod1q)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g)^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1 2 3 4 0 >= down
g test=sqrt((m_mod1q)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g)^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod5e3

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt((m_mod1q_`S')^2+(m_mod1l_`S')^2+(m_mod1k_`S')^2+(m_mod1g_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5e

**Save output
tempfile mod5e3
save `mod5e3', replace

********************************************************************************
*****SHORTEST DISTANCE TO MOD5E THRESHOLD ("MOD5E", ("MOD1Q", "MOD1S"), ("MOD1G", "MOD1L", "MOD1K"))
**MOD5E: CASE 4, MOD1K MISSING, MOD1S MISSING
********************************************************************************

****Combine mod1g and mod1l
use proj2, clear
keep mod1q* mod1s* mod1g* mod1l* mod1k* corps-date ham
drop if mod1s!="N"
drop if mod1k!="N"
save temp2, replace 

*calculate the grade tha results from combining the original mod1g and mod1l num scores
merge_2way mod1g mod1l mod2mid

*set global vars for this sub-model
global points p1 p2
global submodA mod1g
global submodB mod1l
global submodC 
global submodA_ m_mod1g_
global submodB_ m_mod1l_
global submodC_ 
global submodAnum mod1g_num
global submodBnum mod1l_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1g
dist_mod1 mod1l

*calculate distance that first and second scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1g
dist_thresh1 B mod1l

*rename vars
rename_2vars mod1g mod1l mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 1.5001 2.5001 3.5001 4.5001 1 <= up

g test=sqrt(m_mod1g_^2+ m_mod1l^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt(m_mod1g_^2+ m_mod1l^2)
summ test d_
drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1{
	g test`S'=sqrt((m_mod1g_`S')^2+(m_mod1l_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out modB

**Save output
tempfile modB
save `modB', replace

*****Now combine mod1q and the above output

use proj2, clear
drop if mod1s!="N"
drop if mod1k!="N"
keep corps-date ham mod5e mod1q*
merge 1:1 corps-date ham using `modB'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1q
global submodB mod1g mod1l
global submodC 
global submodA_ m_mod1q_
global submodB_ m_mod1g_ m_mod1l_
global submodC_ 
global submodAnum mod1q_num
global submodBnum mod1g_num mod1l_num
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1q

*calculate distance that first, second, and third scores move to reach the higher level threshold - same as above since this model incorporates only level one models
dist_thresh1 A mod1q

*rename vars
rename_2vars mod1q modB mod5e
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 1.5001 2.5001 3.5001 4.5001 2 3 4 5 1 <= up
g test=sqrt((m_mod1q)^2+(m_mod1l)^2+(m_mod1g)^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1.4999 2.4999 3.4999 4.4999 1 2 3 4 0 >= down
g test=sqrt((m_mod1q)^2+(m_mod1l)^2+(m_mod1g)^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod5e4

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt((m_mod1q_`S')^2+(m_mod1l_`S')^2+(m_mod1g_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod5e

**Save output
tempfile mod5e4
save `mod5e4', replace

****Combine
append using `mod5e3'
append using `mod5e2'
append using `mod5e1'

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt((m_mod1q_`S')^2+(m_mod1s_`S')^2+(m_mod1l_`S')^2+(m_mod1g_`S')^2+(m_mod1k_`S')^2)
	replace test`S'=test`S'-mod5e_d_`S'
	summ test`S'
}
drop test*

**Save output
tempfile mod5e
save `mod5e', replace

********************************************************************************
***MOD7B - ECONOMC MODEL (MO7B, (MOD5D, MOD5E), (MOD5F, MOD1R))
********************************************************************************
use proj2, clear
keep corps-date ham mod5d mod5e 
merge 1:1 corps-date ham using `mod5d'
drop _merge
merge 1:1 corps-date ham using `mod5e'
drop _merge
save temp2, replace

*****First combine mod5d and mod5e
merge_2way mod5d mod5e mod2mid

*set global vars for this sub-model
global points p1 p2
global submodA mod1j mod1f mod1m  
global submodB mod1q mod1s mod1g mod1l mod1k
global submodC 
global submodA_  m_mod1j_ m_mod1f_ m_mod1m_
global submodB_ m_mod1q_ m_mod1s_ m_mod1g_ m_mod1l_ m_mod1k_    
global submodC_ 
global submodAnum mod1j_num mod1f_num mod1m_num
global submodBnum mod1q_num mod1s_num mod1g_num mod1l_num mod1k_num   
global submodCnum 

di "$submodA"
di "$submodB"

*calculate distance that first, second, scores move to reach the higher level threshold 
foreach S of num 1/5 {
	rename mod5d_d_`S' modA_d_`S'
	rename mod5e_d_`S' modB_d_`S'
}

*account for mode special cases
foreach S of num 1/5 {
	foreach M in mod1s mod1k {
		recode m_`M'_`S' (.=0)
	}
}

*rename vars
rename_2vars mod5d mod5e mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 2 3 4 5 1 <= up
g test=sqrt(m_mod1j_^2+m_mod1f_^2+ m_mod1m^2+(m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g)^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1 2 3 4 0 >= down
g test=sqrt(m_mod1j_^2+m_mod1f_^2+ m_mod1m^2+(m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g)^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt(m_mod1j_`S'^2+m_mod1f_`S'^2+ m_mod1m_`S'^2+(m_mod1q_`S')^2+(m_mod1s_`S')^2+(m_mod1l_`S')^2+(m_mod1k_`S')^2+(m_mod1g_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out modA

**Save output
tempfile modA
save `modA', replace

***Next combine mod5f and mod1r
use proj2, clear
keep corps-date ham mod1r mod1r_num mod5f
merge 1:1 corps-date ham using `mod5f'
drop _merge
save temp2, replace

*****First combine mod5f and mod1r
merge_2way mod5f mod1r mod2mid

*set global vars for this sub-model
global points p1 p2
global submodA mod1o mod1n mod1p
global submodB mod1r
global submodC 
global submodA_ m_mod1o_ m_mod1n_ m_mod1p_
global submodB_ m_mod1r_ 
global submodC_ 
global submodAnum mod1o_num mod1n_num mod1p_num
global submodBnum mod1r_num 
global submodCnum 

*calculate distance that move individually to reach higher level threshold
dist_mod1 mod1r

*calculate distance that first, second, scores move to reach the higher level threshold 
foreach S of num 1/5 {
	rename mod5f_d_`S' modA_d_`S'
}

dist_thresh1 B mod1r

*rename vars
rename_2vars mod5f mod1r mod2mid
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 1.5001 2.5001 3.5001 4.5001 1 <= up
g test=sqrt((m_mod1o)^2+(m_mod1n)^2+(m_mod1p)^2+(m_mod1r)^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1.4999 2.4999 3.4999 4.4999 0 >= down
g test=sqrt((m_mod1o)^2+(m_mod1n)^2+(m_mod1p)^2+(m_mod1r)^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod2mid

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt((m_mod1o_`S')^2+(m_mod1n_`S')^2+(m_mod1p_`S')^2+(m_mod1r_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out modB

**Save output
tempfile modB
save `modB', replace

***Combine above 2 models
use proj2, clear
keep corps-date ham mod7b
merge 1:1 corps-date ham using `modA'
drop _merge
merge 1:1 corps-date ham using `modB'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1q mod1s mod1g mod1l mod1k mod1j mod1f mod1m
global submodB mod1o mod1n mod1p mod1r
global submodC 
global submodA_  m_mod1q_ m_mod1s_ m_mod1g_ m_mod1l_ m_mod1k_ m_mod1j_ m_mod1f_ m_mod1m_
global submodB_ m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_
global submodC_ 
global submodAnum mod1q_num mod1s_num mod1g_num mod1l_num mod1k_num mod1j_num mod1f_num mod1m_num
global submodBnum mod1o_num mod1n_num mod1p_num mod1r_num
global submodCnum 

*rename vars
rename_2vars modA modB mod7b
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 2 3 4 5 1 <= up
g test=sqrt(m_mod1j_^2+m_mod1f_^2+ m_mod1m^2+(m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g)^2+(m_mod1o)^2+(m_mod1n)^2+(m_mod1p)^2+(m_mod1r)^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1 2 3 4 0 >= down
g test=sqrt(m_mod1j_^2+m_mod1f_^2+ m_mod1m^2+(m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g)^2+(m_mod1o)^2+(m_mod1n)^2+(m_mod1p)^2+(m_mod1r)^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

***merge with grade at the near point
merge_2way p1_score p2_score mod2pert

***Calculate the min distance to each threshold
min_dist mod7b

***Checks on calculations
egen min_dist=rowmin(d_5 d_4 d_3 d_2 d_1) 

*make sure dropped if same score
foreach X in 5 4 3 2 1 {
	summ d_`X' if mod2_num==`X'
}	

*check that distances in individual directions match with overall distance
foreach S in 5 4 3 2 1 {
	g test`S'= sqrt(m_mod1j_`S'^2+m_mod1f_`S'^2+ m_mod1m_`S'^2+(m_mod1q_`S')^2+(m_mod1s_`S')^2+(m_mod1l_`S')^2+(m_mod1k_`S')^2+(m_mod1g_`S')^2+(m_mod1o_`S')^2+(m_mod1n_`S')^2+(m_mod1p_`S')^2+(m_mod1r_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

**Check that appropriate # of observations are missing
check_missing

**Rename the final output
rename_final_out mod7b

*Rename mod1g, which also appears in the security model
foreach S in 5 4 3 2 1 {
	rename m_mod1g_`S' m_mod1g2_`S' 
	rename m_mod1j_`S' m_mod1j2_`S' 
	rename m_mod1f_`S' m_mod1f2_`S' 
	rename m_mod1m_`S' m_mod1m2_`S' 
}

**Save output
tempfile mod7b
save `mod7b', replace

********************************************************************************
***MOD8 HES SCORE (MOD8, MOD7A, MOD7B)
********************************************************************************
use proj2, clear
keep corps-date ham mod8
merge 1:1 corps-date ham using `mod7a'
drop _merge
merge 1:1 corps-date ham using `mod7b'
drop _merge

*set global vars for this sub-model
global points p1 p2
global submodA mod1h mod1i mod1j1 mod1f1 mod1m1 mod1a mod1b mod1c mod1d mod1e mod1g1
global submodB mod1q mod1s mod1g2 mod1l mod1k mod1j2 mod1f2 mod1m2 mod1o mod1n mod1p mod1r 
global submodC 
global submodA_ m_mod1h_ m_mod1i_ m_mod1j1_ m_mod1f1_ m_mod1m1_ m_mod1a_ m_mod1b_ m_mod1c_ m_mod1d_ m_mod1e_ m_mod1g1_
global submodB_ m_mod1q_ m_mod1s_ m_mod1g2_ m_mod1l_ m_mod1k_ m_mod1j2_ m_mod1f2_ m_mod1m2_ m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ 
global submodC_ 
global submodAnum mod1h_num mod1i_num mod1j1_num mod1f1_num mod1m1_num mod1a_num mod1b_num mod1c_num mod1d_num mod1e_num mod1g_num
global submodBnum mod1q_num mod1s_num mod1g_num mod1l_num mod1k_num mod1j2_num mod1f2_num mod1m2_num mod1o_num mod1n_num mod1p_num mod1r_num 
global submodCnum

*calculate distance that first, second, scores move to reach the higher level threshold 
foreach S of num 1/5 {
	rename mod7a_d_`S' modA_d_`S'
	rename mod7b_d_`S' modB_d_`S'
}

*rename vars
rename_2vars mod7a mod7b mod8
save data2, replace

**calculate distance to each possible point on a higher threshold
combine_2way 2 3 4 5 2 3 4 5 1 <= up
g test=sqrt(m_mod1j1_^2+m_mod1f1_^2+ m_mod1m1^2+m_mod1j2_^2+m_mod1f2_^2+ m_mod1m2^2+(m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g1)^2+(m_mod1o)^2+(m_mod1n)^2+(m_mod1p)^2+(m_mod1r)^2+(m_mod1h)^2+(m_mod1i)^2+m_mod1a_^2+ m_mod1b^2+ m_mod1c^2+m_mod1e_^2+ m_mod1d^2+ m_mod1g2^2)
summ test d_

***Calculate distance to each possible point on a lower threshold
combine_2way 1 2 3 4 1 2 3 4 0 >= down
g test=sqrt(m_mod1j1_^2+m_mod1f1_^2+ m_mod1m1^2+m_mod1j2_^2+m_mod1f2_^2+ m_mod1m2^2+(m_mod1q)^2+(m_mod1s)^2+(m_mod1l)^2+(m_mod1k)^2+(m_mod1g1)^2+(m_mod1o)^2+(m_mod1n)^2+(m_mod1p)^2+(m_mod1r)^2+(m_mod1h)^2+(m_mod1i)^2+m_mod1a_^2+ m_mod1b^2+ m_mod1c^2+m_mod1e_^2+ m_mod1d^2+ m_mod1g2^2)
summ test d_

drop test
append using up
save temp2, replace

***caclulate the mod1 letter grades of each perturbed point
rename p1_ p1
rename p2_ p2
letter_grade p1 score
letter_grade p2 score
save temp2, replace

*Calculate HES score at the near point
g mod2pert=p1_score
replace mod2pert="D" if (p1_score=="E" & p2_score=="B")
replace mod2pert="D" if (p1_score=="E" & p2_score=="A")
replace mod2pert="C" if (p1_score=="D" & p2_score=="A")
replace mod2pert="B" if (p1_score=="A" & p2_score=="D")
replace mod2pert="B" if (p1_score=="A" & p2_score=="E")
replace mod2pert="C" if (p1_score=="B" & p2_score=="E")
replace mod2pert="D" if (p1_score=="C" & p2_score=="N")

***drop if grade at near point is the same as grade at the original point
drop if mod2==mod2pert

***The distance measure is potentially incorrect because it double counts mod1g, mod1j, mod1f, and mod1m, which contribute to both mod7a and mod7b. Moreoever, some movements to the threshold may be invalid because the two different movements of mod1g/j/f/m in the models 7a and 7b are inconsistent with each other - that is, when mod1g/j/f/m is forced to move the same amount in both higher level models, the appropriate threshold is no longer reached in one of the models

***drop cases where these movements are inconsistent and then calculate distance counting the mod1g movement only once

*save output
g id=_n
tempfile mod8
save `mod8', replace

*calculate the maximum distance movement required to reach a threshold, across the mod7a and mod7b movements, and also calculate whether applying this movement to both mod7a and mod7b means that one of the thresholds will no longer be reached
conflict

*merge calculations back in with the main data2
merge 1:1 id using `mod8' /*merging with list of inconsistent movements*/
drop _merge

*drop if there is an inconsistency
drop if diff_mod8==1
drop diff_mod8 id

***calculate the corrected distance, which counts movements in the mod1g direction only once

*need to set missing values that arise from mod1 Ns to 0
foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
	recode m_`M'_ (.=0)
}

g d_construct= sqrt((m_mod1h_)^2+(m_mod1i_)^2+(m_mod1m_)^2+(m_mod1j_)^2+(m_mod1l_)^2+(m_mod1k_)^2+(m_mod1a_)^2+(m_mod1b_)^2+(m_mod1c_)^2+(m_mod1d_)^2+(m_mod1e_)^2+(m_mod1f_)^2+(m_mod1g_)^2+(m_mod1o_)^2+(m_mod1n_)^2+(m_mod1p_)^2+(m_mod1r_)^2+(m_mod1q_)^2+(m_mod1s_)^2)

drop d_

***Calculate the min distance to each threshold
egen min_dist=min(d_construct), by(corps-date ham)
keep if min_dist==d_construct

keep corps-date ham mod2 mod2pert d_ p1 p2 m_mod1a_ m_mod1b_ m_mod1d_ m_mod1e_ m_mod1f_ m_mod1g_  m_mod1c_ m_mod1j_ m_mod1l_ m_mod1k_ m_mod1h_ m_mod1i_ m_mod1m_ m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ m_mod1q_ m_mod1s_
*some obs have equal distance to multiple thresholds because of differences in the mod1g2, mod1f2, etc that don't end up being used (d_ would be different; d_construct isn't... Drop duplicates)
duplicates drop d_construct corps-date ham mod2 mod2pert, force 
rename d_construct min_dist
rename mod2pert near_thresh
rename mod2 mod8

****checks
tab near_thresh mod8

**calculate how many scores change at once to reach the nearest threshold
g mod1_move=0
foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
	quietly replace mod1_move=mod1_move+1 if (m_`M'!=0)
}
tab mod1_move

keep mod8 near_thresh min_dist m_mod1* mod1_move corps-date ham
save hes71_dist, replace

				
