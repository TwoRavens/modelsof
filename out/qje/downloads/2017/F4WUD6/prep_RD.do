clear
set more off

*import distance to the nearest threshold 
use hes70_dist, clear 
rename mod4pert near_thresh
tempfile data
save `data', replace

use hes_all_models, clear
keep corps-date ham mod4 mth yr mod1a_num-mod1s_num
keep if yr<=1970
drop if (mod4=="V") /*VC controlled*/
drop if (mod4=="N")
merge 1:1 corps-date ham using `data'
keep if _merge==3
drop _merge

foreach V in mod4 near_thresh {
	g `V'_num=.
	replace `V'_num=1 if `V'=="E"
	replace `V'_num=2 if `V'=="D"
	replace `V'_num=3 if `V'=="C"
	replace `V'_num=4 if `V'=="B"
	replace `V'_num=5 if `V'=="A"
}

tab mod4_num near_thresh_num

*the sign was coded in the other file and is negative when above the threshold because I used the string mod scores; switch
replace min_dist=-min_dist

keep corps-date ham near_thresh min_dist mod4 mod1a_num-mod1s_num mth yr

save `data', replace

use hes71_dist, clear
tempfile hes71
save `hes71', replace

use hes_all_models, clear
keep if yr>=1971
drop if mod8=="N"
drop if mod8=="V"
drop if mod8==""
keep corps-date ham mth yr mod1a_num-mod1s_num
merge 1:1 corps-date ham using `hes71'
keep if _merge==3
drop _merge

*** make distance negative if you move down to the threshold
g mod8_num=.
g near_thresh_num=.
foreach V in mod8 near_thresh {
	replace `V'_num=1 if `V'=="E"
	replace `V'_num=2 if `V'=="D"
	replace `V'_num=3 if `V'=="C"
	replace `V'_num=4 if `V'=="B"
	replace `V'_num=5 if `V'=="A"
}

replace min_dist=-min_dist if (near_thresh_num>mod8_num)

keep corps-date ham near_thresh min_dist mod8 mod1a_num-mod1s_num mth yr 
rename mod8 mod4
append using `data'
g long usid=ham+100*vilg+10000*dist+1000000*prov+100000000*corp
g long villageid=100*vilg+10000*dist+1000000*prov+100000000*corp
save `data', replace

*quarters
g q=.
replace q=1 if (mth==1 | mth==2 | mth==3)
replace q=2 if (mth==4 | mth==5 | mth==6)
replace q=3 if (mth==7 | mth==8 | mth==9)
replace q=4 if (mth==10 | mth==11 | mth==12)

g qdate=yq(yr, q)
format qdate %tq

*gen discontinuity dummies for above threshold
g above=0

*A-B
g ab=0 
replace ab=1 if (near_thres=="B" & mod4=="A")
replace ab=1 if (near_thres=="A" & mod4=="B")
replace above=1 if (near_thres=="B" & mod4=="A")

*B-C
g bc=0
replace bc=1 if (near_thres=="C" & mod4=="B")
replace bc=1 if (near_thres=="B" & mod4=="C")
replace above=1 if (near_thres=="C" & mod4=="B")

*C-D
g cd=0
replace cd=1 if (near_thres=="D" & mod4=="C")
replace cd=1 if (near_thres=="C" & mod4=="D")
replace above=1 if (near_thres=="D" & mod4=="C")
replace above=1 if (near_thres=="D" & mod4=="B")

*D-E
g de=0
replace de=1 if (near_thres=="E" & mod4=="D")
replace de=1 if (near_thres=="D" & mod4=="E")
replace above=1 if (near_thres=="E" & mod4=="D")

bys above: summ min_dist, detail
summ if (min_dist>0 & above==0) /*something wrong with 2 obs that will figure out later*/

foreach T in ab bc cd de { 
	summ min_dist if `T'==1
}

*above*dist interaction
g above_dist=above*min_dist

***optimal weights
g abs_dist=abs(min_dist)
gen oweight20=.
egen MaxDist=max(abs_dist) if abs_dist<=.20
replace oweight20=(1-(abs(min_dist)/MaxDist)) /*weights for local regression */
replace oweight20=0 if oweight20<0
drop MaxDist 

*drop non-hamlet population; this is scattered population that do not live in hamlets (i.e. clusters of dwellings). All hamlet level questions used in the security score are missing for non-hamlet population. They are assigned village level question responses of the nearest village. 
drop if ham==0

save min_dist, replace

 