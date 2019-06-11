clear
set more off

********************************************************
*****MOD1A (=MODEL-12 enemy military presence)
********************************************************

insheet using mod1a_numscore.csv, comma clear

foreach var of varlist v1-v6 {
	replace `var'=`var'-1 if `var'!=999
}

rename v1 vmb2
rename v2 vb2
rename v3 vb3
rename v4 vb4
rename v5 hmb1
rename v6 hc4
rename v7 mod1a_num

tempfile data
save `data', replace

use hes71.dta, clear 

gen temp = dofm(date) /*generate a year variable*/
gen yr=year(temp)
g mth=month(temp)
drop temp

g mod_num=.
replace mod_num=1 if mod1a=="E"
replace mod_num=2 if mod1a=="D"
replace mod_num=3 if mod1a=="C"
replace mod_num=4 if mod1a=="B"
replace mod_num=5 if mod1a=="A"
replace mod_num=6 if mod1a=="N"

foreach X in vmb2 vb2 vb3 vb4 hmb1 hc4 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 vmb2 vb2 vb3 vb4 hmb1 hc4 using `data'
drop _merge

replace mod1a_num=. if mod1a=="N"
replace mod1a_num=. if mod1a==""

tempfile mergedata
save `mergedata', replace

********************************************************
*****mod1b (=MODEL-12 enemy military presence)
********************************************************

insheet using mod1b_numscore.csv, comma clear

foreach var of varlist v1-v8 {
	replace `var'=`var'-1 if `var'!=999
}

*hmb1 hmb2 hmb3 hmb4 hmd1 hmd2 hmd5 vmb1
rename v1 hmb1
rename v2 hmb2
rename v3 hmb3
rename v4 hmb4
rename v5 hmd1
rename v6 hmd2
rename v7 hmd5
rename v8 vmb1
rename v9 mod1b_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hmb1 hmb2 hmb3 hmb4 hmd1 hmd2 hmd5 vmb1 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hmb1 hmb2 hmb3 hmb4 hmd1 hmd2 hmd5 vmb1 using `data'
drop _merge

replace mod1b_num=. if mod1b=="N"
replace mod1b_num=. if mod1b==""
bys mod1b: summ mod1b_num

tempfile mergedata
save `mergedata', replace


********************************************************
*****MOD1C (=MODEL-13 enemy military presence)
********************************************************

insheet using mod1c_numscore.csv, comma clear

foreach var of varlist v1-v13 {
	replace `var'=`var'-1 if `var'!=999
}

*hmc1 hmc2 hmd1 hmd2 hmd3 hmd4 hmd6 hmd7 hd5 hr5 vmb2 vmc2 vt6
rename v1 hmc1 
rename v2 hmc2
rename v3 hmd1
rename v4 hmd2
rename v5 hmd3
rename v6 hmd4
rename v7 hmd6
rename v8 hmd7
rename v9 hd5
rename v10 hr5
rename v11 vmb2
rename v12 vmc2
rename v13 vt6
rename v14 mod1c_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hmc1 hmc2 hmd1 hmd2 hmd3 hmd4 hmd6 hmd7 hd5 hr5 vmb2 vmc2 vt6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hmc1 hmc2 hmd1 hmd2 hmd3 hmd4 hmd6 hmd7 hd5 hr5 vmb2 vmc2 vt6 using `data'
drop _merge

replace mod1c_num=. if mod1c=="N"
replace mod1c_num=. if mod1c==""
bys mod1c: summ mod1c_num

tempfile mergedata
save `mergedata', replace

********************************************************
*****MOD1D (=MODEL-15 friendly military presence)
********************************************************

insheet using mod1d_numscore.csv, comma clear

foreach var of varlist v1-v13 {
	replace `var'=`var'-1 if `var'!=999
}

*hmd7 hc1 hc2 hc3 hc4 hc5 he2 vc1 vc2 vc3 vc4 vc5 vc6
rename v1 hmd7
rename v2 hc1
rename v3 hc2
rename v4 hc3
rename v5 hc4
rename v6 hc5
rename v7 he2
rename v8 vc1
rename v9 vc2
rename v10 vc3
rename v11 vc4
rename v12 vc5
rename v13 vc6
rename v14 mod1d_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hmd7 hc1 hc2 hc3 hc4 hc5 he2 vc1 vc2 vc3 vc4 vc5 vc6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hmd7 hc1 hc2 hc3 hc4 hc5 he2 vc1 vc2 vc3 vc4 vc5 vc6 using `data'
drop _merge

replace mod1d_num=. if mod1d=="N"
replace mod1d_num=. if mod1d==""
bys mod1d: summ mod1d_num

tempfile mergedata
save `mergedata', replace


********************************************************
*****MOD1E (=MODEL-16 friendly military activity)
********************************************************


insheet using mod1e_numscore.csv, comma clear

foreach var of varlist v1-v8 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hmc3 
rename v2 hmd3 
rename v3 hmd4 
rename v4 hmd5 
rename v5 hc2 
rename v6 hc3 
rename v7 vmc1 
rename v8 vmc2 
rename v9 mod1e_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hmc3 hmd3 hmd4 hmd5 hc2 hc3 vmc1 vmc2 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hmc3 hmd3 hmd4 hmd5 hc2 hc3 vmc1 vmc2  using `data'
drop _merge

replace mod1e_num=. if mod1e=="N"
replace mod1e_num=. if mod1e==""
bys mod1e: summ mod1e_num

tempfile mergedata
save `mergedata', replace

********************************************************
*****MOD1F (=MODEL-17 law enforcement)
********************************************************

*1971
insheet using mod1f71_numscore.csv, comma clear

foreach var of varlist v1-v9 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hd1  
rename v2 hd2 
rename v3 hd3 
rename v4 hd4 
rename v5 vd1 
rename v6 vd2 
rename v7 vd4 
rename v8 vd5 
rename v9 vd6 
rename v10 mod1f_num

tempfile data
save `data', replace

use `mergedata', clear
keep if yr>1970

foreach X in hd1 hd2 hd3 hd4 vd1 vd2 vd4 vd5 vd6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hd1 hd2 hd3 hd4 vd1 vd2 vd4 vd5 vd6  using `data'
drop _merge

tempfile data71
save `data71', replace


*1970
insheet using mod1f70_numscore.csv, comma clear

foreach var of varlist v1-v10 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hd1  
rename v2 hd2 
rename v3 hd3 
rename v4 hd4 
rename v5 he3
rename v6 vd1 
rename v7 vd2 
rename v8 vd4 
rename v9 vd5 
rename v10 vd6 
rename v11 mod1f_num

tempfile data
save `data', replace

use `mergedata', clear
keep if yr<=1970

foreach X in hd1 hd2 hd3 hd4 he3 vd1 vd2 vd4 vd5 vd6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hd1 hd2 hd3 hd4 he3 vd1 vd2 vd4 vd5 vd6  using `data'
drop _merge

quietly append using `data71'

replace mod1f_num=. if mod1f=="N"
replace mod1f_num=. if mod1f==""
bys mod1f: summ mod1f_num

save `mergedata', replace

********************************************************
*****MOD1G (=MODEL-18 psdf activity)
********************************************************

insheet using mod1g_numscore.csv, comma clear

foreach var of varlist v1-v3 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hmc4 
rename v2 hc6 
rename v3 hc7 
rename v4 mod1g_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hmc4 hc6 hc7 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hmc4 hc6 hc7  using `data'
drop _merge

replace mod1g_num=. if mod1g=="N"
replace mod1g_num=. if mod1g==""
bys mod1g: summ mod1g_num

tempfile mergedata
save `mergedata', replace

********************************************************
*****MOD1H (=MODEL-19 enemy political presence)
********************************************************

*1971
insheet using mod1h71_numscore.csv, comma clear

foreach var of varlist v1-v7 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hb1 
rename v2 hb2 
rename v3 hb3 
rename v4 hf1 
rename v5 hf2 
rename v6 vb1
rename v7  vb5 
rename v8 mod1h_num

tempfile data
save `data', replace

use `mergedata', clear
keep if yr>1970

foreach X in hb1 hb2 hb3 hf1 hf2 vb1 vb5 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hb1 hb2 hb3 hf1 hf2 vb1 vb5  using `data'
drop _merge

tempfile data71
save `data71', replace

*1970
insheet using mod1h70_numscore.csv, comma clear

foreach var of varlist v1-v8 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hb1 
rename v2 hb2 
rename v3 hb3 
rename v4 he3
rename v5 hf1 
rename v6 hf2 
rename v7 vb1
rename v8  vb5 
rename v9 mod1h_num

tempfile data
save `data', replace

use `mergedata', clear
keep if yr<=1970
foreach X in hb1 hb2 hb3 he3 hf1 hf2 vb1 vb5 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hb1 hb2 hb3 he3 hf1 hf2 vb1 vb5  using `data'
drop _merge

quietly append using `data71'

replace mod1h_num=. if mod1h=="N"
replace mod1h_num=. if mod1h==""
bys mod1h: summ mod1h_num

tempfile mergedata
save `mergedata', replace

********************************************************
*****MOD1I (=MODEL-20 enemy political activity)
********************************************************

insheet using mod1i_numscore.csv, comma clear

foreach var of varlist v1-v6 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hmb5 
rename v2 hmb6 
rename v3 hmb7 
rename v4 hmb8 
rename v5 hb1 
rename v6 vb1 
rename v7 mod1i_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hmb5 hmb6 hmb7 hmb8 hb1 vb1 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hmb5 hmb6 hmb7 hmb8 hb1 vb1  using `data'
drop _merge

replace mod1i_num=. if mod1i=="N"
replace mod1i_num=. if mod1i==""
bys mod1i: summ mod1i_num

tempfile mergedata
save `mergedata', replace

********************************************************
*****MOD1J (=MODEL-21 administration)
********************************************************

*71
insheet using mod1j_numscore71.csv, comma clear

foreach var of varlist v1-v15 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 he1 
rename v2 he2 
rename v3 he4 
rename v4 hf5 
rename v5 vc5 
rename v6 vc6 
rename v7 vd2 
rename v8 ve1 
rename v9 ve2 
rename v10 ve3 
rename v11 ve4 
rename v12 ve5 
rename v13 ve7 
rename v14 vf5 
rename v15 vf6 
rename v16 mod1j_num

tempfile data
save `data', replace

use `mergedata', clear

keep if yr>1970
foreach X in he1 he2 he4 hf5 vc5 vc6 vd2 ve1 ve2 ve3 ve4 ve5 ve7 vf5 vf6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 he1 he2 he4 hf5 vc5 vc6 vd2 ve1 ve2 ve3 ve4 ve5 ve7 vf5 vf6  using `data'
drop _merge

tempfile data70
save `data70', replace

insheet using mod1j_numscore70.csv, comma clear

foreach var of varlist v1-v17 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 he1 
rename v2 he2 
rename v3 he3
rename v4 he4 
rename v5 hf5 
rename v6 vc5 
rename v7 vc6 
rename v8 vd2 
rename v9 ve1 
rename v10 ve2 
rename v11 ve3 
rename v12 ve4 
rename v13 ve5 
rename v14 ve7 
rename v15 vf5 
rename v16 vf6 
rename v17 he5
rename v18 mod1j_num

tempfile data
save `data', replace

use `mergedata', clear
keep if yr<=1970
foreach X in he1 he2 he3 he4 he5 hf5 vc5 vc6 vd2 ve1 ve2 ve3 ve4 ve5 ve7 vf5 vf6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 he1 he2 he3 he4 he5 hf5 vc5 vc6 vd2 ve1 ve2 ve3 ve4 ve5 ve7 vf5 vf6  using `data'
drop _merge

quietly append using `data70'

replace mod1j_num=. if mod1j=="N"
replace mod1j_num=. if mod1j==""
bys mod1j: summ mod1j_num

tempfile mergedata
save `mergedata', replace

********************************************************
*****MOD1K (=MODEL-22 RD cadre)
********************************************************

insheet using mod1k_numscore.csv, comma clear

foreach var of varlist v1-v8 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hc6 
rename v2 hf4 
rename v3 hf5 
rename v4 hf6 
rename v5 hn2 
rename v6 vf5 
rename v7 vf6 
rename v8 vf7 
rename v9 mod1k_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hc6 hf4 hf5 hf6 hn2 vf5 vf6 vf7 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hc6 hf4 hf5 hf6 hn2 vf5 vf6 vf7 using `data'
drop _merge

replace mod1k_num=. if mod1k=="N"
replace mod1k_num=. if mod1k==""
bys mod1k: summ mod1k_num

tempfile mergedata
save `mergedata', replace

********************************************************
*****MOD1L (=MODEL-23 information)
********************************************************

insheet using mod1l_numscore.csv, comma clear

foreach var of varlist v1-v7 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hg1 
rename v2 hg2 
rename v3 hg3 
rename v4 hg4 
rename v5 vg1 
rename v6 vg2 
rename v7 vg3 
rename v8 mod1l_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hg1 hg2 hg3 hg4 vg1 vg2 vg3 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hg1 hg2 hg3 hg4 vg1 vg2 vg3 using `data'
drop _merge

replace mod1l_num=. if mod1l=="N"
replace mod1l_num=. if mod1l==""
bys mod1l: summ mod1l_num

tempfile mergedata
save `mergedata', replace

********************************************************
*****MOD1M (=MODEL-24 political mobilization)
********************************************************

insheet using mod1m_numscore.csv, comma clear

foreach var of varlist v1-v14 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hb1 
rename v2 hb3 
rename v3 hc6 
rename v4 hf1 
rename v5 hf2 
rename v6 hf3 
rename v7 hf6 
rename v8 hg4 
rename v9 hn2 
rename v10 vb1 
rename v11 vf1 
rename v12 vf2 
rename v13 vf3 
rename v14 vf4 
rename v15 mod1m_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hb1 hb3 hc6 hf1 hf2 hf3 hf6 hg4 hn2 vb1 vf1 vf2 vf3 vf4 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hb1 hb3 hc6 hf1 hf2 hf3 hf6 hg4 hn2 vb1 vf1 vf2 vf3 vf4 using `data'
drop _merge

replace mod1m_num=. if mod1m=="N"
replace mod1m_num=. if mod1m==""
bys mod1m: summ mod1m_num

tempfile mergedata
save `mergedata', replace 

********************************************************
*****MOD1N (=MODEL-25 public health)
********************************************************

insheet using mod1n_numscore.csv, comma clear

foreach var of varlist v1-v6 {
	replace `var'=`var'-1 if `var'!=999
}

rename v1 hp1 
rename v2 hp2 
rename v3 vp1 
rename v4 vp2 
rename v5 vp3 
rename v6 vp4 
rename v7 mod1n_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hp1 hp2 vp1 vp2 vp3 vp4 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hp1 hp2 vp1 vp2 vp3 vp4 using `data'
drop _merge

replace mod1n_num=. if mod1n=="N"
replace mod1n_num=. if mod1n==""
bys mod1n: summ mod1n_num

tempfile mergedata
save `mergedata', replace 

********************************************************
*****MOD1O (=MODEL-26 education)
********************************************************

insheet using mod1o_numscore.csv, comma clear

foreach var of varlist v1-v8 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hr1 
rename v2 hr2 
rename v3 hr3 
rename v4 hr4 
rename v5 hr5 
rename v6 vr1 
rename v7 vr2 
rename v8 vr3 
rename v9 mod1o_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hr1 hr2 hr3 hr4 hr5 vr1 vr2 vr3 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hr1 hr2 hr3 hr4 hr5 vr1 vr2 vr3 using `data'
drop _merge

replace mod1o_num=. if mod1o=="N"
replace mod1o_num=. if mod1o==""
bys mod1o: summ mod1o_num

tempfile mergedata
save `mergedata', replace 

********************************************************
*****MOD1P (=MODEL- 27 social welfare)
********************************************************

insheet using mod1p_numscore.csv, comma clear

foreach var of varlist v1-v5 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hs1 
rename v2 hs2 
rename v3 hs3 
rename v4 hs4 
rename v5 hs5 
rename v6 mod1p_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hs1 hs2 hs3 hs4 hs5 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hs1 hs2 hs3 hs4 hs5 using `data'
drop _merge

replace mod1p_num=. if mod1p=="N"
replace mod1p_num=. if mod1p==""
bys mod1p: summ mod1p_num

tempfile mergedata
save `mergedata', replace 

********************************************************
*****MOD1Q (=MODEL- 28 development assistance)
********************************************************

*71
insheet using mod1q_numscore71.csv, comma clear

foreach var of varlist v1-v7 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hn1 
rename v2 hn2 
rename v3 vn1 
rename v4 vn2 
rename v5 vn3 
rename v6 vn4 
rename v7 vn5 
rename v8 mod1q_num

tempfile data
save `data', replace

use `mergedata', clear

keep if yr>1970

foreach X in hn1 hn2 vn1 vn2 vn3 vn4 vn5 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hn1 hn2 vn1 vn2 vn3 vn4 vn5 using `data'
drop _merge

tempfile data71
save `data71', replace


*70
insheet using mod1q_numscore70.csv, comma clear

foreach var of varlist v1-v8 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hn1 
rename v2 hn2 
rename v3 ve6
rename v4 vn1 
rename v5 vn2 
rename v6 vn3 
rename v7 vn4 
rename v8 vn5 
rename v9 mod1q_num

tempfile data
save `data', replace

use `mergedata', clear

keep if yr<=1970

foreach X in hn1 hn2 vn1 vn2 vn3 vn4 vn5 ve6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hn1 hn2 vn1 vn2 vn3 vn4 vn5 ve6 using `data'
drop _merge

quietly append using `data71'

replace mod1q_num=. if mod1q=="N"
replace mod1q_num=. if mod1q==""
bys mod1q: summ mod1q_num

tempfile mergedata
save `mergedata', replace 

********************************************************
*****MOD1R (=MODEL- 29 economic activity)
********************************************************

insheet using mod1r_numscore.csv, comma clear

foreach var of varlist v1-v12 {
	replace `var'=`var'-1 if `var'!=999
}
rename v1 hb2 
rename v2 hg3 
rename v3  hl1 
rename v4  hl2 
rename v5  hl3 
rename v6  hs1 
rename v7  vb5 
rename v8  ve7 
rename v9  vl1 
rename v10  vl2 
rename v11  vl3 
rename v12  vt6 
rename v13 mod1r_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in hb2 hg3 hl1 hl2 hl3 hs1 vb5 ve7 vl1 vl2 vl3 vt6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 hb2 hg3 hl1 hl2 hl3 hs1 vb5 ve7 vl1 vl2 vl3 vt6 using `data'
drop _merge

replace mod1r_num=. if mod1r=="N"
replace mod1r_num=. if mod1r==""
bys mod1r: summ mod1r_num

tempfile mergedata
save `mergedata', replace 
*/
********************************************************
*****MOD1S (=MODEL- 30 land tenure)
********************************************************

insheet using mod1s_numscore.csv, comma clear

foreach var of varlist v1-v6 {
	replace `var'=`var'-1 if `var'!=999
}

rename v1 vt1 
rename v2 vt2 
rename v3 vt3 
rename v4 vt4 
rename v5 vt5 
rename v6 vt6
rename v7 mod1s_num

tempfile data
save `data', replace

use `mergedata', clear

foreach X in vt1 vt2 vt3 vt4 vt5 vt6 {
	recode `X' (8=.)
	recode `X' (9=.) 
	recode `X' (.=999)
}

merge n:1 vt1 vt2 vt3 vt4 vt5 vt6 using `data'
drop _merge

replace mod1s_num=. if mod1s=="N"
replace mod1s_num=. if mod1s==""
bys mod1s: summ mod1s_num

foreach X in a b c d e f g h i j k l m n o p q r s {
		bys mod1`X': summ mod1`X'_num
	}
	
foreach X of varlist hma1-hz6 vmb1-vz3 {
	recode `X' (999=.)
	recode `X' (8=.)
	recode `X' (9=.)
}

************************************************************************************************************  
*In one of the record groups, scores for 1970 were computed retroactively using the HES71 decision logic. 
*This file constructs mod scores for 1970 using the 1970 decision logic. 
************************************************************************************************************  

*generate an HES70 dummy
g hes70=0
replace hes70=1 if yr<1971

tempfile data
save `data', replace

***construct scores in cases where they are missing

**insheet decision tables
insheet using hes70_dectab_2way.csv, comma clear names
tempfile t2
save `t2', replace

insheet using hes70_dectab_3way.csv, comma clear names
tempfile t3
save `t3', replace

**mod 2a
*mod2a <- list("MOD2A", "MOD1A", "MOD1B")
use `data', clear
rename mod1a input1 
rename mod1b input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1a
rename input2 mod1b
rename output mod2a
save `data', replace

**mod2b
*mod2b <- list("MOD2B", "MOD1E", "MOD1D", c("MOD1F", "MOD1G"))
use `data', clear
rename mod1f input1 
rename mod1g input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1f
rename input2 mod1g
rename output input3
rename mod1e input1 
rename mod1d input2
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1e
rename input2 mod1d
drop input3
rename output mod2b
save `data', replace

**mod2c
*mod2c <- list("MOD2C", "MOD1H","MOD1I")
use `data', clear
rename mod1h input1 
rename mod1i input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1h
rename input2 mod1i
rename output mod2c
save `data', replace

**mod2d
*mod2d <- list("MOD2D", "MOD1J", c("MOD1L", "MOD1K"), "MOD1G")
*RD cadre !="N"
use `data', clear
keep if mod1k!="N"
rename mod1l input1 
rename mod1k input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1l
rename input2 mod1k
rename output input2
rename mod1j input1 
rename mod1g input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1j
rename input3 mod1g
drop input2
rename output mod2d
tempfile d1
save `d1', replace

*RD cadre=="N"
use `data', clear
keep if mod1k=="N"
rename mod1j input1 
rename mod1l input2
rename mod1g input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1j
rename input2 mod1l
rename input3 mod1g
rename output mod2d
append using `d1'
save `data', replace

**mod2e
*mod2e <- list("MOD2E", "MOD1O", "MOD1N","MOD1P")
use `data', clear
rename mod1o input1 
rename mod1n input2
rename mod1p input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1o
rename input2 mod1n
rename input3 mod1p
rename output mod2e
save `data', replace

**mod2f
*mod2f <- list("MOD2F", "MOD1R", "MOD1Q","MOD1S")

*mod1s!="N"
use `data', clear
keep if mod1s!="N"
rename mod1r input1 
rename mod1q input2
rename mod1s input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1r
rename input2 mod1q
rename input3 mod1s
rename output mod2f
tempfile d1
save `d1', replace

*mod1s=="N"
use `data', clear
keep if mod1s=="N"
rename mod1r input1 
rename mod1q input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1r
rename input2 mod1q
rename output mod2f
append using `d1'
save `data', replace


**mod3a
*mod3a <- list("MOD3A","MOD2A_gen","MOD2B_gen","MOD1C")

use `data', clear
rename mod2a input1 
rename mod2b input2
rename mod1c input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod2a
rename input2 mod2b
rename input3 mod1c
rename output mod3a
save `data', replace

**mod3b
*mod3b <- list("MOD3B","MOD2D_gen","MOD2C_gen","MOD1M")

use `data', clear
rename mod2d input1 
rename mod2c input2
rename mod1m input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod2d
rename input2 mod2c
rename input3 mod1m
rename output mod3b
save `data', replace

**mod3c
*mod3c <- list("MOD3C", "MOD2E_gen","MOD2F_gen")
use `data', clear
rename mod2e input1 
rename mod2f input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod2e
rename input2 mod2f
rename output mod3c
save `data', replace

**mod4
*mod4 <- list("MOD4", "MOD3A_gen","MOD3B_gen","MOD3C_gen") 
use `data', clear
rename mod3a input1 
rename mod3b input2
rename mod3c input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod3a
rename input2 mod3b
rename input3 mod3c
rename output mod4
replace mod4="V" if (hmb1==1 | hmb1==2)

g obs_num=_n

save hes_all_models, replace




