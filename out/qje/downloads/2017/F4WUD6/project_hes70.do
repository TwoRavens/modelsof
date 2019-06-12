clear
set more off

*****************************
*****************************
***HES70
*****************************
*****************************

********************************************************
**CALCULATE SHORTEST DISTANCE TO MOD2 THRESHOLDS
******************************************************** 
******Prepare data

use hes_all_models, clear /*only need to calculate for quarterly data, 1970*/
keep corps-date ham mod* mth yr 
keep if yr<=1970
drop if (mod4=="V") /*VC controlled*/
drop if (mod4=="N")
save proj, replace

****SHORTEST DISTANCE TO MOD2A THRESHOLD (2-WAY LOGIC)
use proj, clear
keep mod1a* mod1b* mod2a corps-date ham
rename mod1a mod11
rename mod1b mod12
rename mod1a_num mod11_num
rename mod1b_num mod12_num
rename mod2a mod2
drop if (mod2=="N")
tempfile mod2a
save `mod2a', replace

do 2way

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod2a_`V'
}
drop mod2

*gen diff in each score to reach each threshold
merge 1:1 corps-date ham using `mod2a'
drop _merge

foreach S in A B C D E {
	g mod1a_diff_`S'=p1`S'-mod11_n
	g mod1b_diff_`S'=p2`S'-mod12_n
}

*check that distances in individual directions match with overall distance
foreach S in A B C D E {
	g test`S'=sqrt((mod1a_diff_`S')^2+(mod1b_diff_`S')^2)
	replace test`S'=test`S'-mod2a_d_`S'
	summ test`S'
}

rename mod2 mod2a
drop p1* p2*  test* mod11* mod12*
save `mod2a', replace

***SHORTEST DISTANCE TO MOD2B THRESHOLD ("MOD2B", "MOD1E", "MOD1D", c("MOD1F", "MOD1G"))
use proj, clear
keep mod1e* mod1d* mod1f* mod1g* corps-date ham mod2b
drop if (mod2b=="N")
do mod2b

tempfile mod2b
save `mod2b', replace

***SHORTEST DISTANCE TO THE MOD3A THRESHOLD: ("MOD3A","MOD2A_gen","MOD2B_gen","MOD1C") 
use proj, clear
merge 1:1 corps-date ham using `mod2a'
drop _merge
merge 1:1 corps-date ham using `mod2b'
drop _merge
drop if mod3a=="N"
do mod3a

foreach S in A B C D E {
	rename m_mod1g_`S' m_mod1g1_`S' 
}

tempfile mod3a
save `mod3a', replace

***SHORTEST DISTANCE TO MOD2C THRESHOLD (MOD2C, MOD1H, MOD1I)
use proj, clear
keep mod1h* mod1i* mod2c corps-date ham
rename mod1h mod11
rename mod1i mod12
rename mod1h_num mod11_num
rename mod1i_num mod12_num
rename mod2c mod2
drop if (mod2=="N")
tempfile mod2c
save `mod2c', replace

do 2way

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod2c_`V'
}
drop mod2

*gen diff in each score to reach each threshold
merge 1:1 corps-date ham using `mod2c'
drop _merge

foreach S in A B C D E {
	g mod1h_diff_`S'=p1`S'-mod11_n
	g mod1i_diff_`S'=p2`S'-mod12_n
}

*check that distances in individual directions match with overall distance
foreach S in A B C D E {
	g test`S'=sqrt((mod1h_diff_`S')^2+(mod1i_diff_`S')^2)
	replace test`S'=test`S'-mod2c_d_`S'
	summ test`S'
}

rename mod2 mod2c
drop p1* p2*  test* mod11* mod12*
save `mod2c', replace

***SHORTEST DISTANCE TO MOD2D THRESHOLD - ("MOD2D", "MOD1J", c("MOD1L", "MOD1K"), "MOD1G")
use proj, clear
keep mod1j* mod1l* mod1k* mod1g* corps-date ham mod2d
drop if (mod2d=="N")
do mod2d
tempfile mod2d
save `mod2d', replace

***SHORTEST DISTANCE TO MOD3B THRESHOLD - ("MOD3B","MOD2D_gen","MOD2C_gen","MOD1M")
use proj, clear
merge 1:1 corps-date ham using `mod2c'
drop _merge
merge 1:1 corps-date ham using `mod2d'
drop _merge
drop if mod3b=="N"
do mod3b

foreach S in A B C D E {
	rename m_mod1g_`S' m_mod1g2_`S' 
}

tempfile mod3b
save `mod3b', replace

***SHORTEST DISTANCE TO MOD2E THRESHOLD ("MOD2E", "MOD1O", "MOD1N","MOD1P")
use proj, clear
keep mod1o* mod1n* mod1p* mod2e corps-date ham
rename mod1o mod11
rename mod1n mod12
rename mod1p mod13
rename mod1o_num mod11_num
rename mod1n_num mod12_num
rename mod1p_num mod13_num
rename mod2e mod2
drop if mod2=="N"
do 3way

*merge with mod11, mod12, mod13 scores (mod1o_num, mod1n_num, mod1p_num) - need for calculating how far moved in each dimension to reach mod2e threshold
tempfile data
save `data', replace

use  proj, clear
keep corps-date ham mod1o_num mod1n_num mod1p_num
merge 1:1 corps-date ham using `data'
keep if _merge==3
drop _merge

*how much does each point move
foreach S in A B C D E {
	g mod1o_diff_`S'=p1`S'-mod1o_n
	g mod1n_diff_`S'=p2`S'-mod1n_n
	g mod1p_diff_`S'=p3`S'-mod1p_n
}

*check to see that distances traveled in individual directions aggregate into total distance to threshold

foreach S in A B C D E {
	g test`S'=sqrt((mod1o_diff_`S')^2+(mod1n_diff_`S')^2+(mod1p_diff_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

foreach X in A B C D E {
	summ d_`X' if mod2=="`X'"
}

egen min_dist=rowmin(d_A d_B d_C d_D d_E) /*just a check on calculations*/

g mod1_miss=0
foreach M in mod1o mod1n mod1p {
	replace mod1_miss=1 if `M'_num==.
}

bys mod1_miss: summ *_diff*
bys mod1_miss: tab mod2

drop p1* p2* p3* test* mod*_num min_dist mod1_miss

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod2e_`V'
}
rename mod2 mod2e
tempfile mod2e
save `mod2e', replace

***SHORTEST DISTANCE TO MOD2F THRESHOLD ("MOD2F", "MOD1R", "MOD1Q","MOD1S")
**case 1 mod1s!="N"
use proj, clear
keep if mod1s!="N"
keep mod1r* mod1q* mod1s* mod2f corps-date ham
rename mod1r mod11
rename mod1q mod12
rename mod1s mod13
rename mod1r_num mod11_num
rename mod1q_num mod12_num
rename mod1s_num mod13_num
rename mod2f mod2
drop if mod2=="N"
do 3way

*merge with mod11, mod12, mod13 scores (mod1r_num, mod1q_num, mod1s_num) - need for calculating how far moved in each dimension to reach mod2f threshold
tempfile data
save `data', replace

use  proj, clear
keep corps-date ham mod1r_num mod1q_num mod1s_num
merge 1:1 corps-date ham using `data'
keep if _merge==3
drop _merge

*how much does each point move
foreach S in A B C D E {
	g mod1r_diff_`S'=p1`S'-mod1r_n
	g mod1q_diff_`S'=p2`S'-mod1q_n
	g mod1s_diff_`S'=p3`S'-mod1s_n
}

*check to see that distances traveled in individual directions aggregate into total distance to threshold

foreach S in A B C D E {
	g test`S'=sqrt((mod1r_diff_`S')^2+(mod1q_diff_`S')^2+(mod1s_diff_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

foreach X in A B C D E {
	summ d_`X' if mod2=="`X'"
}

egen min_dist=rowmin(d_A d_B d_C d_D d_E) /*just a check on calculations*/

g mod1_miss=0
foreach M in mod1r mod1q mod1s {
	replace mod1_miss=1 if `M'_num==.
}

bys mod1_miss: summ *_diff*
bys mod1_miss: tab mod2

drop p1* p2* p3* test* mod*_num min_dist mod1_miss

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod2f_`V'
}
rename mod2 mod2f
tempfile mod2f
save `mod2f', replace


**case 1 mod1s=="N"
use proj, clear
keep if mod1s=="N"
keep mod1r* mod1q* mod2f corps-date ham
rename mod1r mod11
rename mod1q mod12
rename mod1r_num mod11_num
rename mod1q_num mod12_num
rename mod2f mod2
drop if mod2=="N"
do 2way

*merge with mod11, mod12, mod13 scores (mod1r_num, mod1q_num, mod1s_num) - need for calculating how far moved in each dimension to reach mod2f threshold
tempfile data
save `data', replace

use  proj, clear
keep corps-date ham mod1r_num mod1q_num 
merge 1:1 corps-date ham using `data'
keep if _merge==3
drop _merge

*how much does each point move
foreach S in A B C D E {
	g mod1r_diff_`S'=p1`S'-mod1r_n
	g mod1q_diff_`S'=p2`S'-mod1q_n
}

*check to see that distances traveled in individual directions aggregate into total distance to threshold

foreach S in A B C D E {
	g test`S'=sqrt((mod1r_diff_`S')^2+(mod1q_diff_`S')^2)
	replace test`S'=test`S'-d_`S'
	summ test`S'
}

foreach X in A B C D E {
	summ d_`X' if mod2=="`X'"
}

egen min_dist=rowmin(d_A d_B d_C d_D d_E) /*just a check on calculations*/

g mod1_miss=0
foreach M in mod1r mod1q {
	replace mod1_miss=1 if `M'_num==.
}

bys mod1_miss: summ *_diff*
bys mod1_miss: tab mod2

drop p1* p2* test* mod*_num min_dist mod1_miss

foreach V in d_A d_B d_C d_D d_E {
	rename `V' mod2f_`V'
}
rename mod2 mod2f
append using `mod2f'
save `mod2f', replace

***MOD3C ("MOD3C", "MOD2E_gen","MOD2F_gen")
use proj, clear
keep corps-date ham mod3c
merge 1:1 corps-date ham using `mod2e'
drop _merge
merge 1:1 corps-date ham using `mod2f'
drop _merge
drop if mod3c=="N"
do mod3c
tempfile mod3c
save `mod3c', replace



***MOD4 = mod3a, mod3b, mod3c
use proj, clear
keep corps-date ham mod4
merge 1:1 corps-date ham using `mod3a'
drop _merge
merge 1:1 corps-date ham using `mod3b'
drop _merge
merge 1:1 corps-date ham using `mod3c'
drop _merge
drop if mod4=="N"
do mod4

drop if min_dist==.
save hes70_dist, replace

