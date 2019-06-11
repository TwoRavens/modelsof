tempfile data
save `data', replace

**One very useful thing to note is that you never move up in one direction and down in another to reach the threshold. This simplies the computation considerably

**Calculate distance to each possible point on a higher threshold

local a=0
local b=0
local c=0
foreach A in 1.5001 2.5001 3.5001 4.5001 {
	local a=`a'+1
	local b=0
	foreach B in 1.5001 2.5001 3.5001 4.5001 {
		local b=`b'+1
		local c=0
		foreach C in 1.5001 2.5001 3.5001 4.5001 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			capture g p1_`a'99=`A'
			capture g p2_`a'99=mod12_num
			capture g p3_`a'99=mod13_num 
			capture g d_`a'99=abs(`A'-mod11_num)
			
			foreach V in p1_`a'99 p2_`a'99 p3_`a'99 d_`a'99 {
				replace `V'=. if (`A'<=mod11_num | mod11_num==.)
			}
						
			capture g p1_9`b'9=mod11_num
			capture g p2_9`b'9=`B'
			capture g p3_9`b'9=mod13_num
			capture g d_9`b'9=abs(`B'-mod12_num)

			foreach V in p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 {
				replace `V'=. if (`B'<=mod12_num | mod12_num==.)
			}
						
			capture g p1_99`c'=mod11_num
			capture g p2_99`c'=mod12_num
			capture g p3_99`c'=`C'
			capture g d_99`c'=abs(`C'-mod13_num)

			foreach V in p1_99`c' p2_99`c' p3_99`c' d_99`c' {
				replace `V'=. if (`C'<=mod13_num | mod13_num==.)
			}
						
			**Changing 2 scores at a time
			capture g p1_`a'`b'9=`A'
			capture g p2_`a'`b'9=`B'
			capture g p3_`a'`b'9=mod13_num
			capture g d_`a'`b'9=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2)

			foreach V in p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 {
				replace `V'=. if (`A'<=mod11_num | `B'<=mod12_num | mod11_num==. | mod12_num==.)
			}
						
			capture g p1_`a'9`c'=`A'
			capture g p2_`a'9`c'=mod12_num
			capture g p3_`a'9`c'=`C'
			capture g d_`a'9`c'=sqrt((`A'-mod11_num)^2+(`C'-mod13_num)^2)

			foreach V in p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' {
				replace `V'=. if (`A'<=mod11_num | `C'<=mod13_num | mod11_num==. | mod13_num==.)
			}
						
			capture g p1_9`b'`c'=mod11_num
			capture g p2_9`b'`c'=`B'
			capture g p3_9`b'`c'=`C'
			capture g d_9`b'`c'=sqrt((`B'-mod12_num)^2+(`C'-mod13_num)^2)

			foreach V in p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' {
				replace `V'=. if (`B'<=mod12_num | `C'<=mod13_num | mod12_num==. | mod13_num==.)
			}
						
			**Changing 3 scores at a time
			capture g p1_`a'`b'`c'=`A'
			capture g p2_`a'`b'`c'=`B'
			capture g p3_`a'`b'`c'=`C'
			capture g d_`a'`b'`c'=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2+(`C'-mod13_num)^2)
			
			foreach V in p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' {
				replace `V'=. if (`A'<=mod11_num | `B'<=mod12_num | `C'<=mod13_num | mod11_num==. | mod12_num==. | mod13_num==.)
			}			
		}
	}
}

keep mod2 corps-date ham p1_* p2_* p3_* d_*
reshape long p1_ p2_ p3_ d_, i(mod2 corps-date ham) j(pert)
drop if d_==.
save temp, replace

***Calculate distance to each possible point on a lower threshold
use `data', clear
local a=4
local b=4
local c=4
foreach A in 1.4999 2.4999 3.4999 4.4999 {
	local a=`a'+1
	local b=4
	foreach B in 1.4999 2.4999 3.4999 4.4999 {
		local b=`b'+1
		local c=4
		foreach C in 1.4999 2.4999 3.4999 4.4999 {
			local c=`c'+1	
			
			di "`a' `b' `c'"
			di "`A' `B' `C'"
			
			**Changing 1 score at a time
			capture g p1_`a'99=`A'
			capture g p2_`a'99=mod12_num
			capture g p3_`a'99=mod13_num 
			capture g d_`a'99=abs(`A'-mod11_num)
			
			foreach V in p1_`a'99 p2_`a'99 p3_`a'99 d_`a'99 {
				replace `V'=. if (`A'>=mod11_num | mod11_num==.)
			}
						
			capture g p1_9`b'9=mod11_num
			capture g p2_9`b'9=`B'
			capture g p3_9`b'9=mod13_num
			capture g d_9`b'9=abs(`B'-mod12_num)

			foreach V in p1_9`b'9 p2_9`b'9 p3_9`b'9 d_9`b'9 {
				replace `V'=. if (`B'>=mod12_num | mod12_num==.)
			}
						
			capture g p1_99`c'=mod11_num
			capture g p2_99`c'=mod12_num
			capture g p3_99`c'=`C'
			capture g d_99`c'=abs(`C'-mod13_num)

			foreach V in p1_99`c' p2_99`c' p3_99`c' d_99`c' {
				replace `V'=. if (`C'>=mod13_num | mod13_num==.)
			}
						
			**Changing 2 scores at a time
			capture g p1_`a'`b'9=`A'
			capture g p2_`a'`b'9=`B'
			capture g p3_`a'`b'9=mod13_num
			capture g d_`a'`b'9=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2)

			foreach V in p1_`a'`b'9 p2_`a'`b'9 p3_`a'`b'9 d_`a'`b'9 {
				replace `V'=. if (`A'>=mod11_num | `B'>=mod12_num | mod11_num==. | mod12_num==.)
			}
						
			capture g p1_`a'9`c'=`A'
			capture g p2_`a'9`c'=mod12_num
			capture g p3_`a'9`c'=`C'
			capture g d_`a'9`c'=sqrt((`A'-mod11_num)^2+(`C'-mod13_num)^2)

			foreach V in p1_`a'9`c' p2_`a'9`c' p3_`a'9`c' d_`a'9`c' {
				replace `V'=. if (`A'>=mod11_num | `C'>=mod13_num | mod11_num==. | mod13_num==.)
			}
						
			capture g p1_9`b'`c'=mod11_num
			capture g p2_9`b'`c'=`B'
			capture g p3_9`b'`c'=`C'
			capture g d_9`b'`c'=sqrt((`B'-mod12_num)^2+(`C'-mod13_num)^2)

			foreach V in p1_9`b'`c' p2_9`b'`c' p3_9`b'`c' d_9`b'`c' {
				replace `V'=. if (`B'>=mod12_num | `C'>=mod13_num | mod12_num==. | mod13_num==.)
			}
						
			**Changing 3 scores at a time
			capture g p1_`a'`b'`c'=`A'
			capture g p2_`a'`b'`c'=`B'
			capture g p3_`a'`b'`c'=`C'
			capture g d_`a'`b'`c'=sqrt((`A'-mod11_num)^2+(`B'-mod12_num)^2+(`C'-mod13_num)^2)
			
			foreach V in p1_`a'`b'`c' p2_`a'`b'`c' p3_`a'`b'`c' d_`a'`b'`c' {
				replace `V'=. if (`A'>=mod11_num | `B'>=mod12_num | `C'>=mod13_num | mod11_num==. | mod12_num==. | mod13_num==.)
			}			
		}
	}
}

keep mod2 corps-date ham p1_* p2_* p3_* d_*
reshape long p1_ p2_ p3_ d_, i(mod2 corps-date ham) j(pert)
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

keep corps-date ham mod2 mod2pert d_ p1 p2 p3
duplicates drop corps-date ham mod2 mod2pert d_, force /*there are a very small # of observations that are equidistant from two different points on the same threshold; keep only one of these points (both will produce equiv distance to the threshold*/

reshape wide d_ p1 p2 p3, i(corps-date ham mod2) j(mod2pert) str

