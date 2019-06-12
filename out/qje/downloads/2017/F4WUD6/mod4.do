*mod3a: mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c 
*mod3b: mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m 
*mod3c: mod1o mod1n mod1p mod1r mod1q mod1s   
***mod1g contributes to two models, hence it is imporant to keep track of distance moved in each dimension so as not to double count it (i.e. when mod1g is moved, it moves both mod3a and mod3b)   

*rename vars
foreach M in mod3a mod3b mod3c {
	rename `M'_d_A `M'_d_5
	rename `M'_d_B `M'_d_4
	rename `M'_d_C `M'_d_3 
	rename `M'_d_D `M'_d_2
	rename `M'_d_E `M'_d_1
	
	g `M'_num=.
	replace `M'_num=1 if `M'=="E"
	replace `M'_num=2 if `M'=="D"
	replace `M'_num=3 if `M'=="C"
	replace `M'_num=4 if `M'=="B"
	replace `M'_num=5 if `M'=="A"	
}

foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
	rename m_`M'_A `M'_d5
	rename m_`M'_B `M'_d4
	rename m_`M'_C `M'_d3
	rename m_`M'_D `M'_d2
	rename m_`M'_E `M'_d1
}

tempfile m1
save `m1', replace

***perturb the grade up
*the a, b, c labels for the variables matter - they avoid the creation of duplicate variables, as not all the elements of the list interact with each other (the A, B, C lists only fully interact when changing three scores at a time)
local a=0
local b=0
local c=0
foreach A in 2 3 4 5 {
	local a=`a'+1
	local b=0
	foreach B in 2 3 4 5 {
		local b=`b'+1
		local c=0
		foreach C in 2 3 4 5 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			capture quietly g p1_`a'99=`A'
			capture quietly g p2_`a'99=mod3b_num
			capture quietly g p3_`a'99=mod3c_num 
			capture quietly g d_`a'99=mod3a_d_`A'
			*how much you move in the individual mod directions, need this because mod1a_diff_A, for example, is how much you move to reach the A mod3a threshold, not how much you move to reach the A threshold of mod4. Thus, you cannot merge this in later but rather need to include it in the reshape
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_`a'99=`M'_d`A'
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_`a'99=0
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_`a'99=0
			}
									
			foreach V of varlist p1_`a'99 p2_`a'99 p3_`a'99 d_`a'99 m_*_`a'99 {
				quietly replace `V'=. if (`A'<=mod3a_num | mod3a_num==.)
			}
						
			capture quietly g p1_9`b'9=mod3a_num
			capture quietly g p2_9`b'9=`B'
			capture quietly g p3_9`b'9=mod3c_num
			capture quietly g d_9`b'9=mod3b_d_`B'
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_9`b'9=0
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_9`b'9=`M'_d`B'
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_9`b'9=0
			}
			
			foreach V of varlist p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 m_*_9`b'9 {
				quietly replace `V'=. if (`B'<=mod3b_num | mod3b_num==.)
			}
						
			capture quietly g p1_99`c'=mod3a_num
			capture quietly g p2_99`c'=mod3b_num
			capture quietly g p3_99`c'=`C'
			capture quietly g d_99`c'=mod3c_d_`C'
		
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_99`c'=0
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_99`c'=0
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_99`c'=`M'_d`C'
			}
			
			foreach V of varlist p1_99`c' p2_99`c' p3_99`c' d_99`c' m_*_99`c' {
				quietly replace `V'=. if (`C'<=mod3c_num | mod3c_num==.)
			}
					
			**Changing 2 scores at a time
			capture quietly g p1_`a'`b'9=`A'
			capture quietly g p2_`a'`b'9=`B'
			capture quietly g p3_`a'`b'9=mod3c_num
			capture quietly g d_`a'`b'9=sqrt((mod3a_d_`A')^2+(mod3b_d_`B')^2)
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_`a'`b'9=`M'_d`A'
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_`a'`b'9=`M'_d`B'
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_`a'`b'9=0
			}
			
			foreach V of varlist p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 m_*_`a'`b'9 {
				quietly replace `V'=. if (`A'<=mod3a_num | `B'<=mod3b_num | mod3a_num==. | mod3b_num==.)
			}
						
			capture quietly g p1_`a'9`c'=`A'
			capture quietly g p2_`a'9`c'=mod3b_num
			capture quietly g p3_`a'9`c'=`C'
			capture quietly g d_`a'9`c'=sqrt((mod3a_d_`A')^2+(mod3c_d_`C')^2)
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_`a'9`c'=`M'_d`A'
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_`a'9`c'=0
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_`a'9`c'=`M'_d`C'
			}
			
			foreach V of varlist p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' m_*_`a'9`c' {
				quietly replace `V'=. if (`A'<=mod3a_num | `C'<=mod3c_num | mod3a_num==. | mod3c_num==.)
			}
						
			capture quietly g p1_9`b'`c'=mod3a_num
			capture quietly g p2_9`b'`c'=`B'
			capture quietly g p3_9`b'`c'=`C'
			capture quietly g d_9`b'`c'=sqrt((mod3b_d_`B')^2+(mod3c_d_`C')^2)
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_9`b'`c'=0
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_9`b'`c'=`M'_d`B'
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_9`b'`c'=`M'_d`C'
			}
			
			foreach V of varlist p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' m_*_9`b'`c' {
				quietly replace `V'=. if (`B'<=mod3b_num | `C'<=mod3c_num | mod3b_num==. | mod3c_num==.)
			}
						
			**Changing 3 scores at a time
			capture quietly g p1_`a'`b'`c'=`A'
			capture quietly g p2_`a'`b'`c'=`B'
			capture quietly g p3_`a'`b'`c'=`C'
			capture quietly g d_`a'`b'`c'=sqrt((mod3a_d_`A')^2+(mod3b_d_`B')^2 +(mod3c_d_`C')^2)
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`A'
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`B'
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`C'
			}
						
			foreach V of varlist p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' m_*_`a'`b'`c' {
				quietly replace `V'=. if (`A'<=mod3a_num | `B'<=mod3b_num | `C'<=mod3c_num | mod3a_num==. | mod3b_num==. | mod3c_num==.)
			}			
		}
	}
}

keep mod4 corps-date ham p1_* p2_* p3_* d_* m_mod1*
quietly reshape long p1_ p2_ p3_ d_ m_mod1a_ m_mod1b_ m_mod1d_ m_mod1e_ m_mod1f_ m_mod1g1_  m_mod1c_ m_mod1j_ m_mod1l_ m_mod1k_ m_mod1g2_ m_mod1h_ m_mod1i_ m_mod1m_ m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ m_mod1q_ m_mod1s_, i(mod4 corps-date ham) j(pert)
drop if d_==.
save temp, replace

***Calculate distance to each possible point on a lower threshold
use `m1', clear
local a=4
local b=4
local c=4
foreach A in 1 2 3 4 {
	local a=`a'+1
	local b=4
	foreach B in 1 2 3 4 {
		local b=`b'+1
		local c=4
		foreach C in 1 2 3 4 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			capture quietly g p1_`a'99=`A'
			capture quietly g p2_`a'99=mod3b_num
			capture quietly g p3_`a'99=mod3c_num 
			capture quietly g d_`a'99=mod3a_d_`A'
			*how much you move in the individual mod directions, need this because mod1a_diff_A, for example, is how much you move to reach the A mod3a threshold, not how much you move to reach the A threshold of mod4. Thus, you cannot merge this in later but rather need to include it in the reshape
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_`a'99=`M'_d`A'
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_`a'99=0
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_`a'99=0
			}
									
			foreach V of varlist p1_`a'99 p2_`a'99 p3_`a'99 d_`a'99 m_*_`a'99 {
				quietly replace `V'=. if (`A'>=mod3a_num | mod3a_num==.)
			}
						
			capture quietly g p1_9`b'9=mod3a_num
			capture quietly g p2_9`b'9=`B'
			capture quietly g p3_9`b'9=mod3c_num
			capture quietly g d_9`b'9=mod3b_d_`B'
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_9`b'9=0
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_9`b'9=`M'_d`B'
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_9`b'9=0
			}
			
			foreach V of varlist p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 m_*_9`b'9 {
				quietly replace `V'=. if (`B'>=mod3b_num | mod3b_num==.)
			}
						
			capture quietly g p1_99`c'=mod3a_num
			capture quietly g p2_99`c'=mod3b_num
			capture quietly g p3_99`c'=`C'
			capture quietly g d_99`c'=mod3c_d_`C'
		
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_99`c'=0
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_99`c'=0
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_99`c'=`M'_d`C'
			}
			
			foreach V of varlist p1_99`c' p2_99`c' p3_99`c' d_99`c' m_*_99`c' {
				quietly replace `V'=. if (`C'>=mod3c_num | mod3c_num==.)
			}
					
			**Changing 2 scores at a time
			capture quietly g p1_`a'`b'9=`A'
			capture quietly g p2_`a'`b'9=`B'
			capture quietly g p3_`a'`b'9=mod3c_num
			capture quietly g d_`a'`b'9=sqrt((mod3a_d_`A')^2+(mod3b_d_`B')^2)
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_`a'`b'9=`M'_d`A'
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_`a'`b'9=`M'_d`B'
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_`a'`b'9=0
			}
			
			foreach V of varlist p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 m_*_`a'`b'9 {
				quietly replace `V'=. if (`A'>=mod3a_num | `B'>=mod3b_num | mod3a_num==. | mod3b_num==.)
			}
						
			capture quietly g p1_`a'9`c'=`A'
			capture quietly g p2_`a'9`c'=mod3b_num
			capture quietly g p3_`a'9`c'=`C'
			capture quietly g d_`a'9`c'=sqrt((mod3a_d_`A')^2+(mod3c_d_`C')^2)
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_`a'9`c'=`M'_d`A'
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_`a'9`c'=0
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_`a'9`c'=`M'_d`C'
			}
			
			foreach V of varlist p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' m_*_`a'9`c' {
				quietly replace `V'=. if (`A'>=mod3a_num | `C'>=mod3c_num | mod3a_num==. | mod3c_num==.)
			}
						
			capture quietly g p1_9`b'`c'=mod3a_num
			capture quietly g p2_9`b'`c'=`B'
			capture quietly g p3_9`b'`c'=`C'
			capture quietly g d_9`b'`c'=sqrt((mod3b_d_`B')^2+(mod3c_d_`C')^2)
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_9`b'`c'=0
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_9`b'`c'=`M'_d`B'
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_9`b'`c'=`M'_d`C'
			}
			
			foreach V of varlist p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' m_*_9`b'`c' {
				quietly replace `V'=. if (`B'>=mod3b_num | `C'>=mod3c_num | mod3b_num==. | mod3c_num==.)
			}
						
			**Changing 3 scores at a time
			capture quietly g p1_`a'`b'`c'=`A'
			capture quietly g p2_`a'`b'`c'=`B'
			capture quietly g p3_`a'`b'`c'=`C'
			capture quietly g d_`a'`b'`c'=sqrt((mod3a_d_`A')^2+(mod3b_d_`B')^2 +(mod3c_d_`C')^2)
			
			foreach M in mod1a mod1b mod1d mod1e mod1f mod1g1 mod1c {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`A'
			}

			foreach M in mod1j mod1l mod1k mod1g2 mod1h mod1i mod1m {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`B'
			}

			foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`C'
			}
						
			foreach V of varlist p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' m_*_`a'`b'`c' {
				quietly replace `V'=. if (`A'>=mod3a_num | `B'>=mod3b_num | `C'>=mod3c_num | mod3a_num==. | mod3b_num==. | mod3c_num==.)
			}	
		}
	}
}

keep mod4 corps-date ham p1_* p2_* p3_* d_*  m_mod1*
quietly reshape long p1_ p2_ p3_ d_ m_mod1a_ m_mod1b_ m_mod1d_ m_mod1e_ m_mod1f_ m_mod1g1_  m_mod1c_ m_mod1j_ m_mod1l_ m_mod1k_ m_mod1g2_ m_mod1h_ m_mod1i_ m_mod1m_ m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ m_mod1q_ m_mod1s_, i(mod4 corps-date ham) j(pert)
drop if d_==.
append using temp
save temp, replace

***caclulate the mod1 letter grades of each perturbed point
use temp, clear
foreach M in p1 p2 p3 {
	di "`M'"
	rename `M'_ `M'
	quietly g `M'_score=""
	replace `M'_score="A" if (`M'>=4.5 & `M'!=.)
	replace `M'_score="B" if (`M'>=3.5 & `M'<4.5)
	replace `M'_score="C" if (`M'>=2.5 & `M'<3.5)
	replace `M'_score="D" if (`M'>=1.5 & `M'<2.5)
	replace `M'_score="E" if (`M'<1.5)
	replace `M'_score="N" if (`M'==.)	
}
tempfile grades
save `grades', replace

***merge with grade at the near point
insheet using hes70_dectab_3way.csv, comma clear names
rename input1 p1_score
rename input2 p2_score
rename input3 p3_score
rename output mod4pert
merge 1:n p1_score p2_score p3_score using `grades'
drop if _merge==1
drop _merge

***drop if grade at near point is the same as grade at the original point
drop if mod4==mod4pert

***The distance measure is potentially incorrect because it double counts mod1g, which contributes to both mod3a and mod3b. Moreoever, some movements to the threshold may be invalid because the two different movements of mod1g in the models 3a and 3b are inconsistent with each other - that is, when mod1g is forced to move the same amount in both level 3 models, the appropriate threshold is no longer reached in one of the models

***drop cases where these movements are inconsistent and then calculate distance counting the mod1g movement only once

*save output
g id=_n
tempfile mod4
save `mod4', replace

*calculate the maximum mod1g distance movement required to reach a threshold, across the mod3a and mod3b movements, and also calculate whether applying this movement to both mod3a and mod3b means that one of the thresholds will no longer be reached
do conflict_mod1g

*merge calculations back in with the main data
merge 1:1 id using `mod4' /*merging with list of inconsistent movements*/
drop _merge

*drop if there is an inconsistency
drop if diff_mod4==1
drop diff_mod4 id

***calculate the corrected distance, which counts movements in the mod1g direction only once

*need to set missing values that arise from mod1 Ns to 0
foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
	recode m_`M'_ (.=0)
}

g d_construct= sqrt((m_mod1h_)^2+(m_mod1i_)^2+(m_mod1m_)^2+(m_mod1j_)^2+(m_mod1l_)^2+(m_mod1k_)^2+(m_mod1a_)^2+(m_mod1b_)^2+(m_mod1c_)^2+(m_mod1d_)^2+(m_mod1e_)^2+(m_mod1f_)^2+(m_mod1g_)^2+(m_mod1o_)^2+(m_mod1n_)^2+(m_mod1p_)^2+(m_mod1r_)^2+(m_mod1q_)^2+(m_mod1s_)^2)

***Calculate the min distance to each threshold
egen min_dist=min(d_construct), by(corps-date ham mod4pert)
keep if min_dist==d_construct

keep corps-date ham mod4 mod4pert d_cons p1 p2 p3 m_mod1a_ m_mod1b_ m_mod1d_ m_mod1e_ m_mod1f_ m_mod1g_  m_mod1c_ m_mod1j_ m_mod1l_ m_mod1k_ m_mod1h_ m_mod1i_ m_mod1m_ m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ m_mod1q_ m_mod1s_
duplicates drop corps-date ham mod4 mod4pert d_, force /*there are a very small # of observations that are equidistant from two different points on the same threshold; keep only one of these points (both will produce equiv distance to the threshold*/

*** calculate movement to minimum distance threshold (across all possible thresholds)
egen min_dist=min(d_construct), by(corps-date ham)
keep if min_dist==d_construct

*** make distance negative if you move down to the threshold
g mod4_num=.
g mod4pert_num=.
foreach V in mod4 mod4pert {
	replace `V'_num=1 if `V'=="E"
	replace `V'_num=2 if `V'=="D"
	replace `V'_num=3 if `V'=="C"
	replace `V'_num=4 if `V'=="B"
	replace `V'_num=5 if `V'=="A"
}

replace min_dist=-min_dist if (mod4pert_num<mod4_num)

tempfile temp
save `temp', replace

*merge with mod1 scores
use proj, clear
drop if mod4=="N"
keep corps-date ham mod1a_n mod1b_n mod1d_n mod1e_n mod1f_n mod1g_n mod1c_n mod1j_n mod1l_n mod1k_n mod1h_n mod1i_n mod1m_n mod1o_n mod1n_n mod1p_n mod1r_n mod1q_n mod1s_n 
merge 1:1 corps-date ham using `temp'
drop _merge

****checks
bys mod4: tab mod4pert

**calculate how many scores change at once to reach the nearest threshold
g mod1_move=0
foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
	quietly replace mod1_move=mod1_move+1 if (m_`M'!=0)
}
tab mod1_move

**create a dummy if there is at least one missing mod1 score
g mod1_miss=0
foreach M in mod1a mod1b mod1d mod1e mod1f mod1g mod1c mod1j mod1l mod1k mod1h mod1i mod1m mod1o mod1n mod1p mod1r mod1q mod1s {
	quietly replace mod1_miss=1 if (`M'_num==.)
}
tab mod1_miss

keep mod4pert min_dist m_mod1* mod1_miss mod1_move corps-date ham

