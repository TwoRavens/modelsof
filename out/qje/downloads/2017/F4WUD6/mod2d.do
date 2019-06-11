*("MOD2D", "MOD1J", c("MOD1L", "MOD1K"), "MOD1G")
*generate the "mod2" score for the first combination

tempfile data
save `data', replace

**Case 1: mod1k!=N
keep if mod1k!="N"
tempfile data_noN
save `data_noN', replace

insheet using hes70_dectab_2way.csv, comma clear names
rename input1 mod1l
rename input2 mod1k
rename output mod2mid
merge 1:n mod1l mod1k using `data_noN'
drop if _merge==1
drop _merge mod2d /*for first step, don't need to worry about overall mod2 score*/

*rename variables as needed
rename mod2mid mod2 /*mod1l-mod1k combination*/
rename mod1l mod11
rename mod1k mod12
rename mod1l_num mod11_num
rename mod1k_num mod12_num

*first combination of mod1l and mod1k, using the 2way
keep mod11* mod12* mod2 corps-date ham

do 2way

merge 1:1 corps-date ham using `data_noN'
drop _merge

*how much does each point move
foreach S in A B C D E {
	g mod1l_diff_`S'=p1`S'-mod1l_n
	g mod1k_diff_`S'=p2`S'-mod1k_n
}
drop p1* p2* 

*check that distances in individual directions match with overall distance
foreach S in A B C D E {
	g test`S'=sqrt((mod1l_diff_`S')^2+(mod1k_diff_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

drop test*

g mod1_miss=0
foreach M in mod1l mod1k {
	replace mod1_miss=1 if `M'_num==.
}

bys mod1_miss: summ *_diff*
bys mod1_miss: tab mod2
drop mod1_miss

tempfile index2
save `index2', replace


**Case 2: mod1k==N
use `data', clear
keep if mod1k=="N"
g mod2=mod1l

append using `index2'
save `index2', replace

**********************************
**now combine mod1j mod1g and this outcome using the three way
**Calculate distance to each possible point on a higher threshold
**********************************

use `index2', clear

*rename vars
rename mod1j mod11
rename mod1g mod13
rename mod1j_num mod11_num
rename mod1g_num mod13_num
rename mod2 mod12
g mod12_num=. /*create "combined" mod12 score*/
replace mod12_num=1 if mod12=="E"
replace mod12_num=2 if mod12=="D"
replace mod12_num=3 if mod12=="C"
replace mod12_num=4 if mod12=="B"
replace mod12_num=5 if mod12=="A"
rename mod2d mod2

rename d_A d5
rename d_B d4
rename d_C d3 
rename d_D d2
rename d_E d1

foreach M in mod1l mod1k {
	rename `M'_diff_A `M'_diff_5
	rename `M'_diff_B `M'_diff_4
	rename `M'_diff_C `M'_diff_3 
	rename `M'_diff_D `M'_diff_2
	rename `M'_diff_E `M'_diff_1
}

tempfile m1
save `m1', replace

***prepare a file with how much mod1l and mod1k have to move to reach each threhsold
keep corps-date ham mod12_n mod1l_n mod1k_n
tempfile modlk
save `modlk', replace

****combine with mod1j and mod1g

use `m1', clear

***perturb the grade up
*the a, b, c labels for the variables matter - they avoid the creation of duplicate variables, as not all the elements of the list interact with each other (the A, B, C lists only fully interact when changing three scores at a time)
local a=0
local b=0
local c=0
foreach A in 1.5001 2.5001 3.5001 4.5001 {
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
			di "Changing 1 score at a time - 1a"
			capture quietly g p1_`a'99=`A'
			capture quietly g p2_`a'99=mod12_num 
			capture quietly g p3_`a'99=mod13_num
			capture quietly g d_`a'99=abs(`A'-mod11_num)
			capture quietly g ml2_`a'99=0 
			capture quietly g mk2_`a'99=0

			di "convert to missing if not moving up"			
			foreach V of varlist p1_`a'99 p3_`a'99 p2_`a'99 d_`a'99 m*2_`a'99 {
				replace `V'=. if (`A'<=mod11_num | mod11_num==.)
			}

			di "Changing 1 score at a time - 1b"					
			capture quietly g p1_9`b'9=mod11_num
			capture quietly g p2_9`b'9=`B'
			capture quietly g p3_9`b'9=mod13_num
			capture quietly g d_9`b'9=d`B'
			capture quietly g ml2_9`b'9=mod1l_diff_`B' 
			capture quietly g mk2_9`b'9=mod1k_diff_`B'
			di "convert to missing if not moving up"
			foreach V of varlist p1_9`b'9 p3_9`b'9 p2_9`b'9 d_9`b'9 m*2_9`b'9 {
				replace `V'=. if (`B'<=mod12_num | mod12_num==.)
			}
						
			di "Changing 1 score at a time - 1c"						
			capture quietly g p1_99`c'=mod11_num
			capture quietly g p2_99`c'=mod12_num
			capture quietly g p3_99`c'=`C'
			capture quietly g d_99`c'=abs(`C'-mod13_num)
			capture quietly g ml2_99`c'=0 
			capture quietly g mk2_99`c'=0
			
			foreach V of varlist p1_99`c' p3_99`c' p2_99`c' d_99`c' m*2_99`c' {
				replace `V'=. if (`C'<=mod13_num | mod13_num==.)
			}
								
			**Changing 2 scores at a time
			di "change A and B"
			capture quietly g p1_`a'`b'9=`A'
			capture quietly g p2_`a'`b'9=`B'
			capture quietly g p3_`a'`b'9=mod13_num
			capture quietly g d_`a'`b'9=sqrt((`A'-mod11_num)^2+(d`B')^2)
			capture quietly g ml2_`a'`b'9=mod1l_diff_`B' 
			capture quietly g mk2_`a'`b'9=mod1k_diff_`B'
			
			foreach V of varlist p1_`a'`b'9 p3_`a'`b'9 p2_`a'`b'9 d_`a'`b'9 m*2_`a'`b'9 {
				replace `V'=. if (`A'<=mod11_num | `B'<=mod12_num | mod11_num==. | mod12_num==.)
			}
			
			di "Change A and C"
			capture quietly g p1_`a'9`c'=`A'
			capture quietly g p2_`a'9`c'=mod12_num
			capture quietly g p3_`a'9`c'=`C'
			capture quietly g d_`a'9`c'=sqrt((`A'-mod11_num)^2+(`C'-mod13_num)^2)
			capture quietly g ml2_`a'9`c'=0 
			capture quietly g mk2_`a'9`c'=0
			
			foreach V of varlist p1_`a'9`c' p3_`a'9`c' p2_`a'9`c' d_`a'9`c' m*2_`a'9`c' {
				replace `V'=. if (`A'<=mod11_num | `C'<=mod13_num | mod11_num==. | mod13_num==.)
			}
					
			di "change B and C"				
			capture quietly g p1_9`b'`c'=mod11_num
			capture quietly g p2_9`b'`c'=`B'
			capture quietly g p3_9`b'`c'=`C'
			capture quietly g d_9`b'`c'=sqrt((`C'-mod13_num)^2+(d`B')^2)
			capture quietly g ml2_9`b'`c'=mod1l_diff_`B' 
			capture quietly g mk2_9`b'`c'=mod1k_diff_`B'
			
			foreach V of varlist p1_9`b'`c' p3_9`b'`c' p2_9`b'`c' d_9`b'`c' m*2_9`b'`c' {
				replace `V'=. if (`B'<=mod12_num | `C'<=mod13_num | mod12_num==. | mod13_num==.)
			}
						
			**Changing 3 scores at a time
			capture quietly g p1_`a'`b'`c'=`A'
			capture quietly g p2_`a'`b'`c'=`B'
			capture quietly g p3_`a'`b'`c'=`C'
			capture quietly g d_`a'`b'`c'=sqrt((`A'-mod11_num)^2+(`C'-mod13_num)^2 +(d`B')^2)
			capture quietly g ml2_`a'`b'`c'=mod1l_diff_`B' 
			capture quietly g mk2_`a'`b'`c'=mod1k_diff_`B'
						
			foreach V of varlist p1_`a'`b'`c' p3_`a'`b'`c' p2_`a'`b'`c' d_`a'`b'`c' m*2_`a'`b'`c' {
				replace `V'=. if (`A'<=mod11_num | `B'<=mod12_num | `C'<=mod13_num | mod11_num==. | mod12_num==. | mod13_num==.)
			}			
		}
	}
}

keep mod2 corps-date ham p1_* p2_* p3_* d_* ml2_* mk2_*
reshape long p1_ p2_ p3_ d_ ml2_ mk2_, i(mod2 corps-date ham) j(pert)

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
	foreach B in 1 2 3 4 {
		local b=`b'+1
		local c=4
		foreach C in 1.4999 2.4999 3.4999 4.4999 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			di "Changing 1 score at a time - 1a"
			capture quietly g p1_`a'99=`A'
			capture quietly g p2_`a'99=mod12_num 
			capture quietly g p3_`a'99=mod13_num
			capture quietly g d_`a'99=abs(`A'-mod11_num)
			capture quietly g ml2_`a'99=0 
			capture quietly g mk2_`a'99=0

			di "convert to missing if not moving up"			
			foreach V of varlist p1_`a'99 p3_`a'99 p2_`a'99 d_`a'99 m*2_`a'99 {
				replace `V'=. if (`A'>=mod11_num | mod11_num==.)
			}

			di "Changing 1 score at a time - 1b"					
			capture quietly g p1_9`b'9=mod11_num
			capture quietly g p2_9`b'9=`B'
			capture quietly g p3_9`b'9=mod13_num
			capture quietly g d_9`b'9=d`B'
			capture quietly g ml2_9`b'9=mod1l_diff_`B' 
			capture quietly g mk2_9`b'9=mod1k_diff_`B'
			di "convert to missing if not moving up"
			foreach V of varlist p1_9`b'9 p3_9`b'9 p2_9`b'9 d_9`b'9 m*2_9`b'9 {
				replace `V'=. if (`B'>=mod12_num | mod12_num==.)
			}
						
			di "Changing 1 score at a time - 1c"						
			capture quietly g p1_99`c'=mod11_num
			capture quietly g p2_99`c'=mod12_num
			capture quietly g p3_99`c'=`C'
			capture quietly g d_99`c'=abs(`C'-mod13_num)
			capture quietly g ml2_99`c'=0 
			capture quietly g mk2_99`c'=0
			
			foreach V of varlist p1_99`c' p3_99`c' p2_99`c' d_99`c' m*2_99`c' {
				replace `V'=. if (`C'>=mod13_num | mod13_num==.)
			}
								
			**Changing 2 scores at a time
			di "change A and B"
			capture quietly g p1_`a'`b'9=`A'
			capture quietly g p2_`a'`b'9=`B'
			capture quietly g p3_`a'`b'9=mod13_num
			capture quietly g d_`a'`b'9=sqrt((`A'-mod11_num)^2+(d`B')^2)
			capture quietly g ml2_`a'`b'9=mod1l_diff_`B' 
			capture quietly g mk2_`a'`b'9=mod1k_diff_`B'
			
			foreach V of varlist p1_`a'`b'9 p3_`a'`b'9 p2_`a'`b'9 d_`a'`b'9 m*2_`a'`b'9 {
				replace `V'=. if (`A'>=mod11_num | `B'>=mod12_num | mod11_num==. | mod12_num==.)
			}
			
			di "Change A and C"
			capture quietly g p1_`a'9`c'=`A'
			capture quietly g p2_`a'9`c'=mod12_num
			capture quietly g p3_`a'9`c'=`C'
			capture quietly g d_`a'9`c'=sqrt((`A'-mod11_num)^2+(`C'-mod13_num)^2)
			capture quietly g ml2_`a'9`c'=0 
			capture quietly g mk2_`a'9`c'=0
			
			foreach V of varlist p1_`a'9`c' p3_`a'9`c' p2_`a'9`c' d_`a'9`c' m*2_`a'9`c' {
				replace `V'=. if (`A'>=mod11_num | `C'>=mod13_num | mod11_num==. | mod13_num==.)
			}
					
			di "change B and C"				
			capture quietly g p1_9`b'`c'=mod11_num
			capture quietly g p2_9`b'`c'=`B'
			capture quietly g p3_9`b'`c'=`C'
			capture quietly g d_9`b'`c'=sqrt((`C'-mod13_num)^2+(d`B')^2)
			capture quietly g ml2_9`b'`c'=mod1l_diff_`B' 
			capture quietly g mk2_9`b'`c'=mod1k_diff_`B'
			
			foreach V of varlist p1_9`b'`c' p3_9`b'`c' p2_9`b'`c' d_9`b'`c' m*2_9`b'`c' {
				replace `V'=. if (`B'>=mod12_num | `C'>=mod13_num | mod12_num==. | mod13_num==.)
			}
						
			**Changing 3 scores at a time
			capture quietly g p1_`a'`b'`c'=`A'
			capture quietly g p2_`a'`b'`c'=`B'
			capture quietly g p3_`a'`b'`c'=`C'
			capture quietly g d_`a'`b'`c'=sqrt((`A'-mod11_num)^2+(`C'-mod13_num)^2 +(d`B')^2)
			capture quietly g ml2_`a'`b'`c'=mod1l_diff_`B' 
			capture quietly g mk2_`a'`b'`c'=mod1k_diff_`B'
						
			foreach V of varlist p1_`a'`b'`c' p3_`a'`b'`c' p2_`a'`b'`c' d_`a'`b'`c' m*2_`a'`b'`c' {
				replace `V'=. if (`A'>=mod11_num | `B'>=mod12_num | `C'>=mod13_num | mod11_num==. | mod12_num==. | mod13_num==.)
			}		
		}
	}
}

keep mod2 corps-date ham p1_* p2_* p3_* d_* ml2_* mk2_*
reshape long p1_ p2_ p3_ d_ ml2_ mk2_, i(mod2 corps-date ham) j(pert)
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

keep corps-date ham mod2 mod2pert d_ p1 p2 p3 ml2_ mk2_
duplicates drop corps-date ham mod2 mod2pert d_, force /*there are a very small # of observations that are equidistant from two different points on the same threshold; keep only one of these points (both will produce equiv distance to the threshold*/

reshape wide d_ p1 p2 p3 ml2_ mk2_, i(corps-date ham mod2) j(mod2pert) str

*merge with model score for the combination of mod1l and mod1k (mod12)
merge 1:1 corps-date ham using `modlk'
drop _merge
tempfile data
save `data', replace

*merge with mod11 and mod13 scores (mod1j_num and mod1g_num) - need for calculating how far moved in each dimension to reach mod2d threshold
use  proj, clear
keep corps-date ham mod1j_n mod1g_n 
merge 1:1 corps-date ham using `data'
keep if _merge==3
drop _merge


*how much does each point move
foreach S in A B C D E {
	g mod1j_diff_`S'=p1`S'-mod1j_n
	g mod1g_diff_`S'=p3`S'-mod1g_n
	rename ml2_`S' mod1l_diff_`S'
	rename mk2_`S' mod1k_diff_`S'
}

*check to see that distances traveled in individual directions aggregate into total distance to threshold

foreach S in A B C D E {
	g test`S'=sqrt((mod1l_diff_`S')^2+(mod1k_diff_`S')^2+(mod1g_diff_`S')^2+(mod1j_diff_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

foreach X in A B C D E {
	summ d_`X' if mod2=="`X'"
}

egen min_dist=rowmin(d_A d_B d_C d_D d_E) /*just a check on calculations*/

g mod1_miss=0
foreach M in mod1l mod1k mod1j mod1g {
	replace mod1_miss=1 if `M'_num==.
}

bys mod1_miss: summ *_diff*
bys mod1_miss: tab mod2

drop p1* p3* p2* test* mod1*_num min_dist mod1_miss

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod2d_`V'
}
rename mod2 mod2d

