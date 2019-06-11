*generate the "mod2" score for the first combination
tempfile data
save `data', replace

insheet using hes70_dectab_2way.csv, comma clear names
rename input1 mod1f
rename input2 mod1g
rename output mod2mid
merge 1:n mod1f mod1g using `data'
drop if _merge==1
drop _merge mod2b /*for first step, don't need to worry about overall mod2 score*/

*rename variables as needed
rename mod2mid mod2 /*mod1f-mod1g combination*/
rename mod1f mod11
rename mod1g mod12
rename mod1f_num mod11_num
rename mod1g_num mod12_num

*first combination of mod1f and mod1g, using the 2way
keep mod11* mod12* mod2 corps-date ham

do 2way

merge 1:1 corps-date ham using `data'
drop _merge

*how much does each point move
foreach S in A B C D E {
	g mod1f_diff_`S'=p1`S'-mod1f_n
	g mod1g_diff_`S'=p2`S'-mod1g_n
}
drop p1* p2* 

*check that distances in individual directions match with overall distance
foreach S in A B C D E {
	g test`S'=sqrt((mod1f_diff_`S')^2+(mod1g_diff_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

drop test*

**now combine mod1e mod1d and this outcome using the three way
**Calculate distance to each possible point on a higher threshold

*rename vars
rename mod1e mod11
rename mod1d mod12
rename mod1e_num mod11_num
rename mod1d_num mod12_num
rename mod2 mod13
rename mod2b mod2

*create "combined" mod13 score
g mod13_num=.
replace mod13_num=1 if mod13=="E"
replace mod13_num=2 if mod13=="D"
replace mod13_num=3 if mod13=="C"
replace mod13_num=4 if mod13=="B"
replace mod13_num=5 if mod13=="A"

rename d_A d5
rename d_B d4
rename d_C d3 
rename d_D d2
rename d_E d1

foreach M in mod1f mod1g {
	rename `M'_diff_A `M'_diff_5
	rename `M'_diff_B `M'_diff_4
	rename `M'_diff_C `M'_diff_3 
	rename `M'_diff_D `M'_diff_2
	rename `M'_diff_E `M'_diff_1
}

tempfile m1
save `m1', replace

***prepare a file with how much mod1f and mod1g have to move to reach each threhsold
keep corps-date ham mod13_n mod1f_n mod1g_n
tempfile modfg
save `modfg', replace

****combine with mod1e and mod1d

use `m1', clear

***perturb the grade up
*the a, b, c labels for the variables matter - they avoid the creation of duplicate variables, as not all the elements of the list interact with each other (the A, B, C lists only fully interact when changing three scores at a time)
local a=0
local b=0
local c=0
foreach A in 1.5001 2.5001 3.5001 4.5001 {
	local a=`a'+1
	local b=0
	foreach B in 1.5001 2.5001 3.5001 4.5001 {
		local b=`b'+1
		local c=0
		foreach C in 2 3 4 5 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			capture quietly g p1_`a'99=`A'
			capture quietly g p2_`a'99=mod12_num
			capture quietly g p3_`a'99=mod13_num 
			capture quietly g d_`a'99=abs(`A'-mod11_num)
			capture quietly g m3_`a'99=0 /*how much you move in the mod13 direction, need this to check the accuracy of the code later*/
			capture quietly g mf3_`a'99=0 /*how much you move in the mod1f direction to move in the mod13 direction, need this because mod1fA, for example, is how much you move to reach the A threshold from the combination of mod1f and mod1g, not how much you move to reach the A threshold of mod2b. Thus, you cannot merge this in later but rather need to include it in the reshape*/
			capture quietly g mg3_`a'99=0
			
			foreach V of varlist p1_`a'99 p2_`a'99 p3_`a'99 d_`a'99 m*3_`a'99 {
				replace `V'=. if (`A'<mod11_num | mod11_num==.)
			}
						
			capture quietly g p1_9`b'9=mod11_num
			capture quietly g p2_9`b'9=`B'
			capture quietly g p3_9`b'9=mod13_num
			capture quietly g d_9`b'9=abs(`B'-mod12_num)
			capture quietly g m3_9`b'9=0
			capture quietly g mf3_9`b'9=0 
			capture quietly g mg3_9`b'9=0
			
			foreach V of varlist p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 m*3_9`b'9 {
				replace `V'=. if (`B'<mod12_num | mod12_num==.)
			}
						
			capture quietly g p1_99`c'=mod11_num
			capture quietly g p2_99`c'=mod12_num
			capture quietly g p3_99`c'=`C'
			capture quietly g d_99`c'=d`C'
			capture quietly g m3_99`c'=d`C'
			capture quietly g mf3_99`c'=mod1f_diff_`C' 
			capture quietly g mg3_99`c'=mod1g_diff_`C'
			
			foreach V of varlist p1_99`c' p2_99`c' p3_99`c' d_99`c' m*3_99`c' {
				replace `V'=. if (`C'<=mod13_num | mod13_num==.)
			}
					
			**Changing 2 scores at a time
			capture quietly g p1_`a'`b'9=`A'
			capture quietly g p2_`a'`b'9=`B'
			capture quietly g p3_`a'`b'9=mod13_num
			capture quietly g d_`a'`b'9=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2)
			capture quietly g m3_`a'`b'9=0
			capture quietly g mf3_`a'`b'9=0 
			capture quietly g mg3_`a'`b'9=0
			
			foreach V of varlist p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 m*3_`a'`b'9 {
				replace `V'=. if (`A'<mod11_num | `B'<mod12_num | mod11_num==. | mod12_num==.)
			}
						
			capture quietly g p1_`a'9`c'=`A'
			capture quietly g p2_`a'9`c'=mod12_num
			capture quietly g p3_`a'9`c'=`C'
			capture quietly g d_`a'9`c'=sqrt((`A'-mod11_num)^2+(d`C')^2)
			capture quietly g m3_`a'9`c'=d`C'
			capture quietly g mf3_`a'9`c'=mod1f_diff_`C' 
			capture quietly g mg3_`a'9`c'=mod1g_diff_`C'
			
			foreach V of varlist p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' m*3_`a'9`c' {
				replace `V'=. if (`A'<mod11_num | `C'<=mod13_num | mod11_num==. | mod13_num==.)
			}
						
			capture quietly g p1_9`b'`c'=mod11_num
			capture quietly g p2_9`b'`c'=`B'
			capture quietly g p3_9`b'`c'=`C'
			capture quietly g d_9`b'`c'=sqrt((`B'-mod12_num)^2+(d`C')^2)
			capture quietly g m3_9`b'`c'=d`C'
			capture quietly g mf3_9`b'`c'=mod1f_diff_`C' 
			capture quietly g mg3_9`b'`c'=mod1g_diff_`C'
			
			foreach V of varlist p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' m*3_9`b'`c' {
				replace `V'=. if (`B'<mod12_num | `C'<=mod13_num | mod12_num==. | mod13_num==.)
			}
						
			**Changing 3 scores at a time
			capture quietly g p1_`a'`b'`c'=`A'
			capture quietly g p2_`a'`b'`c'=`B'
			capture quietly g p3_`a'`b'`c'=`C'
			capture quietly g d_`a'`b'`c'=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2 +(d`C')^2)
			capture quietly g m3_`a'`b'`c'=d`C'
			capture quietly g mf3_`a'`b'`c'=mod1f_diff_`C' 
			capture quietly g mg3_`a'`b'`c'=mod1g_diff_`C'
						
			foreach V of varlist p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' m*3_`a'`b'`c' {
				replace `V'=. if (`A'<mod11_num | `B'<mod12_num | `C'<=mod13_num | mod11_num==. | mod12_num==. | mod13_num==.)
			}			
		}
	}
}

keep mod2 corps-date ham p1_* p2_* p3_* d_* m3_* mf3_* mg3_*
reshape long p1_ p2_ p3_ d_ m3_ mf3_ mg3_, i(mod2 corps-date ham) j(pert)
drop if d_==.
save temp, replace

***Calculate distance to each possible point on a lower threshold
use `m1', clear
local a=4
local b=4
local c=4
foreach A in 1.4999 2.4999 3.4999 4.4999 {
	local a=`a'+1
	local b=4
	foreach B in 1.4999 2.4999 3.4999 4.4999 {
		local b=`b'+1
		local c=4
		foreach C in 1 2 3 4 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			capture quietly g p1_`a'99=`A'
			capture quietly g p2_`a'99=mod12_num
			capture quietly g p3_`a'99=mod13_num 
			capture quietly g d_`a'99=abs(`A'-mod11_num)
			capture quietly g m3_`a'99=0
			capture quietly g mf3_`a'99=0 
			capture quietly g mg3_`a'99=0
						
			foreach V of varlist p1_`a'99 p2_`a'99 p3_`a'99 d_`a'99 m*3_`a'99 {
				replace `V'=. if (`A'>mod11_num | mod11_num==.)
			}
						
			capture quietly g p1_9`b'9=mod11_num
			capture quietly g p2_9`b'9=`B'
			capture quietly g p3_9`b'9=mod13_num
			capture quietly g d_9`b'9=abs(`B'-mod12_num)
			capture quietly g m3_9`b'9=0
			capture quietly g mf3_9`b'9=0 
			capture quietly g mg3_9`b'9=0
			
			foreach V of varlist p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 m*3_9`b'9 {
				replace `V'=. if (`B'>mod12_num | mod12_num==.)
			}
						
			capture quietly g p1_99`c'=mod11_num
			capture quietly g p2_99`c'=mod12_num
			capture quietly g p3_99`c'=`C'
			capture quietly g d_99`c'=d`C'
			capture quietly g m3_99`c'=d`C'
			capture quietly g mf3_99`c'=mod1f_diff_`C' 
			capture quietly g mg3_99`c'=mod1g_diff_`C'
			
			foreach V of varlist p1_99`c' p2_99`c' p3_99`c' d_99`c' m*3_99`c' {
				replace `V'=. if (`C'>=mod13_num | mod13_num==.)
			}
						
			**Changing 2 scores at a time
			capture quietly g p1_`a'`b'9=`A'
			capture quietly g p2_`a'`b'9=`B'
			capture quietly g p3_`a'`b'9=mod13_num
			capture quietly g d_`a'`b'9=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2)
			capture quietly g m3_`a'`b'9=0
			capture quietly g mf3_`a'`b'9=0 
			capture quietly g mg3_`a'`b'9=0
			
			foreach V of varlist p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 m*3_`a'`b'9 {
				replace `V'=. if (`A'>mod11_num | `B'>mod12_num | mod11_num==. | mod12_num==.)
			}
						
			capture quietly g p1_`a'9`c'=`A'
			capture quietly g p2_`a'9`c'=mod12_num
			capture quietly g p3_`a'9`c'=`C'
			capture quietly g d_`a'9`c'=sqrt((`A'-mod11_num)^2+(d`C')^2)
			capture quietly g m3_`a'9`c'=d`C'
			capture quietly g mf3_`a'9`c'=mod1f_diff_`C' 
			capture quietly g mg3_`a'9`c'=mod1g_diff_`C'
			
			foreach V of varlist p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' m*3_`a'9`c' {
				replace `V'=. if (`A'>mod11_num | `C'>=mod13_num | mod11_num==. | mod13_num==.)
			}
						
			capture quietly g p1_9`b'`c'=mod11_num
			capture quietly g p2_9`b'`c'=`B'
			capture quietly g p3_9`b'`c'=`C'
			capture quietly g d_9`b'`c'=sqrt((`B'-mod12_num)^2+(d`C')^2)
			capture quietly g m3_9`b'`c'=d`C'
			capture quietly g mf3_9`b'`c'=mod1f_diff_`C' 
			capture quietly g mg3_9`b'`c'=mod1g_diff_`C'
			
			foreach V of varlist p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' m*3_9`b'`c' {
				replace `V'=. if (`B'>mod12_num | `C'>=mod13_num | mod12_num==. | mod13_num==.)
			}
						
			**Changing 3 scores at a time
			capture quietly g p1_`a'`b'`c'=`A'
			capture quietly g p2_`a'`b'`c'=`B'
			capture quietly g p3_`a'`b'`c'=`C'
			capture quietly g d_`a'`b'`c'=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2+(d`C')^2)
			capture quietly g m3_`a'`b'`c'=d`C'
			capture quietly g mf3_`a'`b'`c'=mod1f_diff_`C' 
			capture quietly g mg3_`a'`b'`c'=mod1g_diff_`C'
						
			foreach V of varlist p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' m*3_`a'`b'`c' {
				replace `V'=. if (`A'>mod11_num | `B'>mod12_num | `C'>=mod13_num | mod11_num==. | mod12_num==. | mod13_num==.)
			}			
		}
	}
}

keep mod2 corps-date ham p1_* p2_* p3_* d_*  m3_* mf3_* mg3_*
reshape long p1_ p2_ p3_ d_ m3_ mf3_ mg3_, i(mod2 corps-date ham) j(pert)
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
rename output mod2pert
merge 1:n p1_score p2_score p3_score using `grades'
drop if _merge==1
drop _merge

***drop if grade at near point is the same as grade at the original point
drop if mod2==mod2pert

***Calculate the min distance to each threshold
egen min_dist=min(d_), by(corps-date ham mod2pert)
keep if min_dist==d_

keep corps-date ham mod2 mod2pert d_ p1 p2 p3 m3_ mf3_ mg3_
duplicates drop corps-date ham mod2 mod2pert d_, force /*there are a very small # of observations that are equidistant from two different points on the same threshold; keep only one of these points (both will produce equiv distance to the threshold*/

reshape wide d_ p1 p2 p3 m3_ mf3_ mg3_, i(corps-date ham mod2) j(mod2pert) str

*merge with model score for the combination of mod1f and mod1g (mod13)
merge 1:1 corps-date ham using `modfg'
drop _merge
tempfile data
save `data', replace

*merge with mod11 and mod12 scores (mod1e_num and mod1d_num) - need for calculating how far moved in each dimension to reach mod2b threshold
use  proj, clear
keep corps-date ham mod1e_n mod1d_n
merge 1:1 corps-date ham using `data'
keep if _merge==3
drop _merge


*how much does each point move
foreach S in A B C D E {
	g mod1e_diff_`S'=p1`S'-mod1e_n
	g mod1d_diff_`S'=p2`S'-mod1d_n
	rename mf3_`S' mod1f_diff_`S'
	rename mg3_`S' mod1g_diff_`S'
}

*check to see that distances traveled in individual directions aggregate into total distance to threshold

foreach S in A B C D E {
	g test`S'=sqrt((mod1f_diff_`S')^2+(mod1g_diff_`S')^2+(mod1d_diff_`S')^2+(mod1e_diff_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
	summ test`S' if (p3`S'==mod13_num)
	summ test`S' if (mod1d_diff_`S'==0 & mod1e_diff_`S'==0)
}

foreach X in A B C D E {
	summ d_`X' if mod2=="`X'"
}

egen min_dist=rowmin(d_A d_B d_C d_D d_E) /*just a check on calculations*/

g mod1_miss=0
foreach M in mod1f mod1g mod1e mod1d {
	replace mod1_miss=1 if `M'_num==.
}

bys mod1_miss: summ *_diff*
bys mod1_miss: tab mod2

drop p1* p2* p3* test* mod13_num m3_* mod1d_n mod1e_n min_dist mod1_miss

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod2b_`V'
}
rename mod2 mod2b
