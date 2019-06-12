tempfile data
save `data', replace

**One very useful thing to note is that you never move up in one direction and down in another to reach the threshold. This simplies the computation considerably

**Calculate distance to each possible point on a higher threshold

local a=0
local b=0
foreach A in 1.5001 2.5001 3.5001 4.5001 {
	local a=`a'+1
	local b=0
	foreach B in 1.5001 2.5001 3.5001 4.5001 {
		local b=`b'+1
		
		di "`a' `b'"
		di "`A' `B'"
		
		**Changing 1 score at a time
		capture g p1_`a'9=`A'
		capture g p2_`a'9=mod12_num
		capture g d_`a'9=abs(`A'-mod11_num)
		
		foreach V in p1_`a'9 p2_`a'9 d_`a'9 {
			replace `V'=. if (`A'<mod11_num | mod11_num==.)
		}

		capture g p1_9`b'=mod11_num
		capture g p2_9`b'=`B'
		capture g d_9`b'=abs(`B'-mod12_num)

		foreach V in p1_9`b' p2_9`b' d_9`b' {
			replace `V'=. if (`B'<mod12_num | mod12_num==.)
		}
		summ mod11_n mod12_n				
					
		**Changing 2 scores at a time
		capture g p1_`a'`b'=`A'
		capture g p2_`a'`b'=`B'
		capture g d_`a'`b'=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2)

		foreach V in p1_`a'`b' p2_`a'`b' d_`a'`b' {
			replace `V'=. if (`A'<mod11_num | `B'<mod12_num | mod11_num==. | mod12_num==.)
		}		
	}
}

keep mod2 corps-date ham p1_* p2_* d_* mod11_n mod12_n
reshape long p1_ p2_ d_, i(mod2 mod11_n mod12_n corps-date ham) j(pert)
drop if d_==.
save temp, replace

***Calculate distance to each possible point on a lower threshold
use `data', clear
local a=4
local b=4
foreach A in 1.4999 2.4999 3.4999 4.4999 {
	local a=`a'+1
	local b=4
	foreach B in 1.4999 2.4999 3.4999 4.4999 {
		local b=`b'+1
		
		di "`a' `b'"
		di "`A' `B'"
		
		**Changing 1 score at a time
		capture g p1_`a'9=`A'
		capture g p2_`a'9=mod12_num
		capture g d_`a'9=abs(`A'-mod11_num)
		
		foreach V in p1_`a'9 p2_`a'9 d_`a'9 {
			replace `V'=. if (`A'>mod11_num | mod11_num==.)
		}
					
		capture g p1_9`b'=mod11_num
		capture g p2_9`b'=`B'
		capture g d_9`b'=abs(`B'-mod12_num)

		foreach V in p1_9`b' p2_9`b' d_9`b' {
			replace `V'=. if (`B'>mod12_num | mod12_num==.)
		}
					
		**Changing 2 scores at a time
		capture g p1_`a'`b'=`A'
		capture g p2_`a'`b'=`B'
		capture g d_`a'`b'=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2)

		foreach V in p1_`a'`b' p2_`a'`b' d_`a'`b' {
			replace `V'=. if (`A'>mod11_num | `B'>mod12_num | mod11_num==. | mod12_num==.)
		}
	}
}

keep mod2 corps-date ham p1_* p2_* d_* mod11_n mod12_n

reshape long p1_ p2_ d_, i(mod2 corps-date ham mod11_n mod12_n) j(pert)
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
rename output mod2pert
merge 1:n p1_score p2_score using `grades'
drop if _merge==1
drop _merge

***drop if grade at near point is the same as grade at the original point
drop if mod2==mod2pert

***Calculate the min distance to each threshold
egen min_dist=min(d_), by(corps-date ham mod2pert)
keep if min_dist==d_
tab mod2pert if mod12_n==.

keep corps-date ham mod2 mod2pert d_ p1 p2
duplicates drop d_ corps-date ham mod2  mod2pert, force /*there are a very small # of observations that are equidistant from two different points on the same threshold; keep only one of these points (both will produce equiv distance to the threshold*/

reshape wide d_ p1 p2, i(corps-date ham mod2) j(mod2pert) str

egen min_dist=rowmin(d_A d_B d_C d_D d_E) /*just a check on calculations*/

*make sure dropped if same score
foreach X in A B C D E {
	summ d_`X' if mod2=="`X'"
}
drop min_dist		
				
				