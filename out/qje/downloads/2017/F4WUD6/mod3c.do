*rename vars
rename mod3c mod3

foreach M in mod2e mod2f {
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

foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
	rename `M'_diff_A `M'_d5
	rename `M'_diff_B `M'_d4
	rename `M'_diff_C `M'_d3
	rename `M'_diff_D `M'_d2
	rename `M'_diff_E `M'_d1
}

tempfile m1
save `m1', replace

use `m1', clear

**One very useful thing to note is that you never move up in one direction and down in another to reach the threshold. This simplies the computation considerably

**Calculate distance to each possible point on a higher threshold

local a=0
local b=0
foreach A in 2 3 4 5 {
	local a=`a'+1
	local b=0
	foreach B in 2 3 4 5 {
		local b=`b'+1
		
		di "`a' `b'"
		di "`A' `B'"
		
		**Changing 1 score at a time
		di "changing mod11"
		capture g p1_`a'9=`A'
		capture g p2_`a'9=mod2f_num
		capture g d_`a'9=mod2e_d_`A'

		foreach M in mod1o mod1n mod1p {
			capture quietly g m_`M'_`a'9=`M'_d`A'
		}

		foreach M in mod1r mod1q mod1s {
			capture quietly g m_`M'_`a'9=0
		}
				
		foreach V of varlist p1_`a'9 p2_`a'9 d_`a'9 m_*_`a'9 {
			replace `V'=. if (`A'<=mod2e_num | mod2e_num==.)
		}

		di "changing mod12"
		capture g p1_9`b'=mod2e_num
		capture g p2_9`b'=`B'
		capture g d_9`b'=mod2f_d_`B'

		foreach M in mod1o mod1n mod1p {
			capture quietly g m_`M'_9`b'=0
		}

		foreach M in mod1r mod1q mod1s {
			capture quietly g m_`M'_9`b'=`M'_d`B'
		}
		
		foreach V of varlist p1_9`b' p2_9`b' d_9`b' m_*_9`b' {
			replace `V'=. if (`B'<=mod2f_num | mod2f_num==.)
		}
					
		**Changing 2 scores at a time
		di "changing both mods"
		capture g p1_`a'`b'=`A'
		capture g p2_`a'`b'=`B'
		capture g d_`a'`b'=sqrt((mod2e_d_`A')^2+(mod2f_d_`B')^2)

		foreach M in mod1o mod1n mod1p {
			capture quietly g m_`M'_`a'`b'=`M'_d`A'
		}

		foreach M in mod1r mod1q mod1s {
			capture quietly g m_`M'_`a'`b'=`M'_d`B'
		}
		
		foreach V of varlist p1_`a'`b' p2_`a'`b' d_`a'`b' m_*_`a'`b' {
			replace `V'=. if (`A'<=mod2e_num | `B'<=mod2f_num | mod2e_num==. | mod2f_num==.)
		}		
	}
}
keep mod3 corps-date ham p1_* p2_* d_* m_mod1*
reshape long p1_ p2_ d_ m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ m_mod1q_ m_mod1s_, i(mod3 corps-date ham) j(pert)
drop if d_==.
save temp, replace

***Calculate distance to each possible point on a lower threshold
use `m1', clear
local a=4
local b=4
foreach A in 1 2 3 4 {
	local a=`a'+1
	local b=4
	foreach B in 1 2 3 4 {
		local b=`b'+1
		
		**Changing 1 score at a time
		di "changing mod11"
		capture g p1_`a'9=`A'
		capture g p2_`a'9=mod2f_num
		capture g d_`a'9=mod2e_d_`A'

		foreach M in mod1o mod1n mod1p {
			capture quietly g m_`M'_`a'9=`M'_d`A'
		}

		foreach M in mod1r mod1q mod1s {
			capture quietly g m_`M'_`a'9=0
		}
				
		foreach V of varlist p1_`a'9 p2_`a'9 d_`a'9 m_*_`a'9 {
			replace `V'=. if (`A'>=mod2e_num | mod2e_num==.)
		}

		di "changing mod12"
		capture g p1_9`b'=mod2e_num
		capture g p2_9`b'=`B'
		capture g d_9`b'=mod2f_d_`B'

		foreach M in mod1o mod1n mod1p {
			capture quietly g m_`M'_9`b'=0
		}

		foreach M in mod1r mod1q mod1s {
			capture quietly g m_`M'_9`b'=`M'_d`B'
		}
		
		foreach V of varlist p1_9`b' p2_9`b' d_9`b' m_*_9`b' {
			replace `V'=. if (`B'>=mod2f_num | mod2f_num==.)
		}
					
		**Changing 2 scores at a time
		di "changing both mods"
		capture g p1_`a'`b'=`A'
		capture g p2_`a'`b'=`B'
		capture g d_`a'`b'=sqrt((mod2e_d_`A')^2+(mod2f_d_`B')^2)

		foreach M in mod1o mod1n mod1p {
			capture quietly g m_`M'_`a'`b'=`M'_d`A'
		}

		foreach M in mod1r mod1q mod1s {
			capture quietly g m_`M'_`a'`b'=`M'_d`B'
		}
		
		foreach V of varlist p1_`a'`b' p2_`a'`b' d_`a'`b' m_*_`a'`b' {
			replace `V'=. if (`A'>=mod2e_num | `B'>=mod2f_num | mod2e_num==. | mod2f_num==.)
		}
	}
}

keep mod3 corps-date ham p1_* p2_* d_* m_mod1*

reshape long p1_ p2_ d_ m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ m_mod1q_ m_mod1s_, i(mod3 corps-date ham) j(pert)
drop if d_==.
append using temp
save temp, replace

***caclulate the mod1 letter grades of each perturbed point
use temp, clear
foreach M in p1 p2 {
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
insheet using hes70_dectab_2way.csv, comma clear names
rename input1 p1_score
rename input2 p2_score
rename output mod3pert
merge 1:n p1_score p2_score using `grades'
drop if _merge==1
drop _merge

***drop if grade at near point is the same as grade at the original point
drop if mod3==mod3pert

***Calculate the min distance to each threshold
egen min_dist=min(d_), by(corps-date ham mod3pert)
keep if min_dist==d_

keep corps-date ham mod3 mod3pert d_ p1 p2 m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ m_mod1q_ m_mod1s_
duplicates drop d_ corps-date ham mod3 mod3pert, force /*there are a very small # of observations that are equidistant from two different points on the same threshold; keep only one of these points (both will produce equiv distance to the threshold*/

reshape wide d_ p1 p2 m_mod1o_ m_mod1n_ m_mod1p_ m_mod1r_ m_mod1q_ m_mod1s_, i(corps-date ham mod3) j(mod3pert) str
tempfile temp
save `temp', replace

*merge with mod1 scores
use proj, clear
drop if mod3c=="N"
keep corps-date ham mod1o_n mod1n_n mod1p_n mod1r_n mod1q_n mod1s_n
merge 1:1 corps-date ham using `temp'
drop _merge

*check to see that distances traveled in individual directions aggregate into total distance to threshold

foreach S in A B C D E {
	g test`S'= sqrt((m_mod1o_`S')^2+(m_mod1n_`S')^2+(m_mod1p_`S')^2+(m_mod1r_`S')^2+(m_mod1q_`S')^2+(m_mod1s_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

foreach X in A B C D E {
	summ d_`X' if mod3=="`X'"
}

egen min_dist=rowmin(d_A d_B d_C d_D d_E) /*just a check on calculations*/

g mod1_miss=0
foreach M in mod1o mod1n mod1p mod1r mod1q mod1s {
	replace mod1_miss=1 if `M'_num==.
}

bys mod1_miss: summ m_mod1*
bys mod1_miss: tab mod3

drop p1* p2* test* mod*_num min_dist mod1_miss

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod3c_`V'
}

rename mod3 mod3c

				