**now combine mod1e mod1d and this outcome using the three way
**Calculate distance to each possible point on a higher threshold

*rename vars
rename mod1m mod13
rename mod1m_num mod13_num
rename mod3b mod3

foreach M in mod2d mod2c {
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

foreach M in mod1j mod1l mod1k mod1g mod1h mod1i {
	rename `M'_diff_A `M'_d5
	rename `M'_diff_B `M'_d4
	rename `M'_diff_C `M'_d3
	rename `M'_diff_D `M'_d2
	rename `M'_diff_E `M'_d1
}

tempfile m1
save `m1', replace

***prepare a file with mod2s and mod1_num scores, for checking accuracy later
keep corps-date ham mod2d mod2c mod1j_n mod1k_n mod1l_n mod1g_n mod13_n mod1h_n mod1i_n
tempfile mod3
save `mod3', replace


use `m1', clear

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
		foreach C in 1.5001 2.5001 3.5001 4.5001 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			capture quietly g p1_`a'99=`A'
			capture quietly g p2_`a'99=mod2c_num
			capture quietly g p3_`a'99=mod13_num 
			capture quietly g d_`a'99=mod2d_d_`A'
			*how much you move in the individual mod directions, need this because mod1a_diff_A, for example, is how much you move to reach the A mod2d threshold, not how much you move to reach the A threshold of mod3b. Thus, you cannot merge this in later but rather need to include it in the reshape
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_`a'99=`M'_d`A'
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_`a'99=0
			}
						
			foreach V of varlist p1_`a'99 p2_`a'99 p3_`a'99 d_`a'99 m_*_`a'99 {
				replace `V'=. if (`A'<=mod2d_num | mod2d_num==.)
			}
						
			capture quietly g p1_9`b'9=mod2d_num
			capture quietly g p2_9`b'9=`B'
			capture quietly g p3_9`b'9=mod13_num
			capture quietly g d_9`b'9=mod2c_d_`B'
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_9`b'9=0
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_9`b'9=`M'_d`B'
			}
			
			foreach V of varlist p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 m_*_9`b'9 {
				replace `V'=. if (`B'<=mod2c_num | mod2c_num==.)
			}
						
			capture quietly g p1_99`c'=mod2d_num
			capture quietly g p2_99`c'=mod2c_num
			capture quietly g p3_99`c'=`C'
			capture quietly g d_99`c'=abs(`C'-mod13_num)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_99`c'=0
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_99`c'=0
			}
			
			foreach V of varlist p1_99`c' p2_99`c' p3_99`c' d_99`c' m_*_99`c' {
				replace `V'=. if (`C'<=mod13_num | mod13_num==.)
			}
					
			**Changing 2 scores at a time
			capture quietly g p1_`a'`b'9=`A'
			capture quietly g p2_`a'`b'9=`B'
			capture quietly g p3_`a'`b'9=mod13_num
			capture quietly g d_`a'`b'9=sqrt((mod2d_d_`A')^2+(mod2c_d_`B')^2)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_`a'`b'9=`M'_d`A'
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_`a'`b'9=`M'_d`B'
			}
			
			foreach V of varlist p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 m_*_`a'`b'9 {
				replace `V'=. if (`A'<=mod2d_num | `B'<=mod2c_num | mod2d_num==. | mod2c_num==.)
			}
						
			capture quietly g p1_`a'9`c'=`A'
			capture quietly g p2_`a'9`c'=mod2c_num
			capture quietly g p3_`a'9`c'=`C'
			capture quietly g d_`a'9`c'=sqrt((mod2d_d_`A')^2+(abs(`C'-mod13_num))^2)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_`a'9`c'=`M'_d`A'
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_`a'9`c'=0
			}
			
			foreach V of varlist p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' m_*_`a'9`c' {
				replace `V'=. if (`A'<=mod2d_num | `C'<=mod13_num | mod2d_num==. | mod13_num==.)
			}
						
			capture quietly g p1_9`b'`c'=mod2d_num
			capture quietly g p2_9`b'`c'=`B'
			capture quietly g p3_9`b'`c'=`C'
			capture quietly g d_9`b'`c'=sqrt((mod2c_d_`B')^2+(abs(`C'-mod13_num))^2)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_9`b'`c'=0
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_9`b'`c'=`M'_d`B'
			}
			
			foreach V of varlist p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' m_*_9`b'`c' {
				replace `V'=. if (`B'<=mod2c_num | `C'<=mod13_num | mod2c_num==. | mod13_num==.)
			}
						
			**Changing 3 scores at a time
			capture quietly g p1_`a'`b'`c'=`A'
			capture quietly g p2_`a'`b'`c'=`B'
			capture quietly g p3_`a'`b'`c'=`C'
			capture quietly g d_`a'`b'`c'=sqrt((mod2d_d_`A')^2+(mod2c_d_`B')^2 +(abs(`C'-mod13_num))^2)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`A'
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`B'
			}
						
			foreach V of varlist p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' m_*_`a'`b'`c' {
				replace `V'=. if (`A'<=mod2d_num | `B'<=mod2c_num | `C'<=mod13_num | mod2d_num==. | mod2c_num==. | mod13_num==.)
			}			
		}
	}
}

keep mod3 corps-date ham p1_* p2_* p3_* d_* m_mod1*
reshape long p1_ p2_ p3_ d_ m_mod1h_ m_mod1i_ m_mod1j_ m_mod1l_ m_mod1k_ m_mod1g_, i(mod3 corps-date ham) j(pert)
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
		foreach C in 1.4999 2.4999 3.4999 4.4999 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			capture quietly g p1_`a'99=`A'
			capture quietly g p2_`a'99=mod2c_num
			capture quietly g p3_`a'99=mod13_num 
			capture quietly g d_`a'99=mod2d_d_`A'
			*how much you move in the individual mod directions, need this because mod1a_diff_A, for example, is how much you move to reach the A mod2d threshold, not how much you move to reach the A threshold of mod3b. Thus, you cannot merge this in later but rather need to include it in the reshape
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_`a'99=`M'_d`A'
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_`a'99=0
			}
						
			foreach V of varlist p1_`a'99 p2_`a'99 p3_`a'99 d_`a'99 m_*_`a'99 {
				replace `V'=. if (`A'>=mod2d_num | mod2d_num==.)
			}
						
			capture quietly g p1_9`b'9=mod2d_num
			capture quietly g p2_9`b'9=`B'
			capture quietly g p3_9`b'9=mod13_num
			capture quietly g d_9`b'9=mod2c_d_`B'
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_9`b'9=0
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_9`b'9=`M'_d`B'
			}
			
			foreach V of varlist p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 m_*_9`b'9 {
				replace `V'=. if (`B'>=mod2c_num | mod2c_num==.)
			}
						
			capture quietly g p1_99`c'=mod2d_num
			capture quietly g p2_99`c'=mod2c_num
			capture quietly g p3_99`c'=`C'
			capture quietly g d_99`c'=abs(`C'-mod13_num)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_99`c'=0
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_99`c'=0
			}
			
			foreach V of varlist p1_99`c' p2_99`c' p3_99`c' d_99`c' m_*_99`c' {
				replace `V'=. if (`C'>=mod13_num | mod13_num==.)
			}
					
			**Changing 2 scores at a time
			capture quietly g p1_`a'`b'9=`A'
			capture quietly g p2_`a'`b'9=`B'
			capture quietly g p3_`a'`b'9=mod13_num
			capture quietly g d_`a'`b'9=sqrt((mod2d_d_`A')^2+(mod2c_d_`B')^2)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_`a'`b'9=`M'_d`A'
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_`a'`b'9=`M'_d`B'
			}
			
			foreach V of varlist p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 m_*_`a'`b'9 {
				replace `V'=. if (`A'>=mod2d_num | `B'>=mod2c_num | mod2d_num==. | mod2c_num==.)
			}
						
			capture quietly g p1_`a'9`c'=`A'
			capture quietly g p2_`a'9`c'=mod2c_num
			capture quietly g p3_`a'9`c'=`C'
			capture quietly g d_`a'9`c'=sqrt((mod2d_d_`A')^2+(abs(`C'-mod13_num))^2)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_`a'9`c'=`M'_d`A'
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_`a'9`c'=0
			}
			
			foreach V of varlist p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' m_*_`a'9`c' {
				replace `V'=. if (`A'>=mod2d_num | `C'>=mod13_num | mod2d_num==. | mod13_num==.)
			}
						
			capture quietly g p1_9`b'`c'=mod2d_num
			capture quietly g p2_9`b'`c'=`B'
			capture quietly g p3_9`b'`c'=`C'
			capture quietly g d_9`b'`c'=sqrt((mod2c_d_`B')^2+(abs(`C'-mod13_num))^2)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_9`b'`c'=0
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_9`b'`c'=`M'_d`B'
			}
			
			foreach V of varlist p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' m_*_9`b'`c' {
				replace `V'=. if (`B'>=mod2c_num | `C'>=mod13_num | mod2c_num==. | mod13_num==.)
			}
						
			**Changing 3 scores at a time
			capture quietly g p1_`a'`b'`c'=`A'
			capture quietly g p2_`a'`b'`c'=`B'
			capture quietly g p3_`a'`b'`c'=`C'
			capture quietly g d_`a'`b'`c'=sqrt((mod2d_d_`A')^2+(mod2c_d_`B')^2 +(abs(`C'-mod13_num))^2)
			
			foreach M in mod1j mod1l mod1k mod1g {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`A'
			}

			foreach M in mod1h mod1i {
				capture quietly g m_`M'_`a'`b'`c'=`M'_d`B'
			}
						
			foreach V of varlist p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' m_*_`a'`b'`c' {
				replace `V'=. if (`A'>=mod2d_num | `B'>=mod2c_num | `C'>=mod13_num | mod2d_num==. | mod2c_num==. | mod13_num==.)
			}			
		}
	}
}

keep mod3 corps-date ham p1_* p2_* p3_* d_*  m_mod1*
reshape long p1_ p2_ p3_ d_ m_mod1h_ m_mod1i_ m_mod1j_ m_mod1l_ m_mod1k_ m_mod1g_, i(mod3 corps-date ham) j(pert)
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
rename output mod3pert
merge 1:n p1_score p2_score p3_score using `grades'
drop if _merge==1
drop _merge

***drop if grade at near point is the same as grade at the original point
drop if mod3==mod3pert

***Calculate the min distance to each threshold
egen min_dist=min(d_), by(corps-date ham mod3pert)
keep if min_dist==d_

keep corps-date ham mod3 mod3pert d_ p1 p2 p3 m_mod1h_ m_mod1i_ m_mod1j_ m_mod1l_ m_mod1k_ m_mod1g_
duplicates drop corps-date ham mod3 mod3pert d_, force /*there are a very small # of observations that are equidistant from two different points on the same threshold; keep only one of these points (both will produce equiv distance to the threshold*/

reshape wide d_ p1 p2 p3 m_mod1h_ m_mod1i_ m_mod1j_ m_mod1l_ m_mod1k_ m_mod1g_, i(corps-date ham mod3) j(mod3pert) str

*merge with mod2d and mod2c scores
merge 1:1 corps-date ham using `mod3'
rename mod13_n mod1m_num
drop _merge

*how much does each point move
foreach S in A B C D E {
	g m_mod1m_`S'=p3`S'-mod1m_n
}

*check to see that distances traveled in individual directions aggregate into total distance to threshold

foreach S in A B C D E {
	g test`S'= sqrt((m_mod1h_`S')^2+(m_mod1i_`S')^2+(m_mod1m_`S')^2+(m_mod1j_`S')^2+(m_mod1l_`S')^2+(m_mod1k_`S')^2+(m_mod1g_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

foreach X in A B C D E {
	summ d_`X' if mod3=="`X'"
}

egen min_dist=rowmin(d_A d_B d_C d_D d_E) /*just a check on calculations*/

g mod1_miss=0
foreach M in mod1j mod1l mod1k mod1g mod1m mod1h mod1i {
	replace mod1_miss=1 if `M'_num==.
}

bys mod1_miss: summ m_mod1*
bys mod1_miss: tab mod3

drop p1* p2* p3* test* mod*_num min_dist mod1_miss mod2d mod2c

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod3b_`V'
}

rename mod3 mod3b
