*****************************
* DOES PLANNING REGULATION PROTECT INDEPENDENT RETAILERS?
* Do file to prepare retail panel at the firm and local authority level
* Created by Raffaella Sadun (rsadun@hbs.edu)
*****************************
clear
set mem 1000m
adopath ++"t:\ceriba\stata_files\ado\stb\"



/*
* First run with files in ard2 (last version of ard)
/* 1. Put all retail local units together */
forvalues x=1997(1)2004 {
foreach ru in snul {
use "U:\ARD2\\`ru'`x'reg.dta", clear
keep ruref luref year empment region sic92 district county  postcode
destring  ruref, replace
gen luref_n = (substr(luref,1,1))
gen luref_n2 = (substr(luref,2,.))
replace luref = luref_n2 if luref_n=="X"
destring  luref, replace
gen local=1
rename empment emp_lu
rename sic92 sic_lu
destring sic_lu, replace
so ruref year
save "H:\Raffaella\Retail\Data\\`ru'`x'_reg_ard2", replace
}
}


clear
set mem 500m
ge temp=.
forvalues x=1997(1)2004 {
foreach ru in snul {
append using "H:\Raffaella\Retail\Data\\snul`x'_reg_ard2
}
}
so luref year
drop if luref==luref[_n-1] & year==year[_n-1]
drop if luref==luref[_n+1] & year==year[_n+1]
save "H:\Raffaella\Retail\Data\\snul_all_years_reg_ard2", replace


******************************
* ENTRY AND EXIT
******************************
clear
set mem 1000m
use "H:\Raffaella\Retail\Data\\snul_all_years_reg_ard2", clear
bys luref: egen mode_r=mode(region), minmode
* Note: assigning lurefs to modal region
replace region=mode_r
so region
merge region using "H:\Raffaella\Retail\Data\reg_code.dta" 
drop if _m==2
drop _m
save "H:\Raffaella\Retail\Data\\snul_all_years_reg1_ard2", replace

use "H:\Raffaella\Retail\Data\\snul_all_years_reg1_ard2", replace
* Some local units change postcode over time, fix it
bys luref: egen m_postcode=mode(postcode), maxmode
replace postcode=m_postcode

* Just before identifiying entry, correct for spurious changes in luref code where possible
* Count lurefs per ruref and postcode
bys ruref year postcode: egen ru_pcode_year=count(luref)

* Note: some lurefs belong to more than one ruref in their history
egen g_r=group(ruref)
bys luref: egen m_ru=mean(g_r)
ge change_ruref=(ruref~=m_ru)
cap drop p1 m_p1 m_luref luref2

* Note: this problem of changing luref, same postcode is linked to lurefs that at some point change the reporting unit
so ruref postcode year
bys ruref postcode: ge p1=(ru_pcode==1 & postc==postc[_n-1]&luref~=luref[_n-1] & ruref==ruref[_n-1] & year~=1997)
bys ruref postcode: egen m_p1=max(p1) if ru_pcode==1
bys ruref postcode: egen double m_luref=mode(luref) if m_p1==1, minmode

cap drop luref2
ge double luref2=luref
replace luref2=m_luref if m_p1==1 & ru_pcode==1
save "H:\Raffaella\Retail\Data\\snul_all_years_reg2_ard2", replace


use "H:\Raffaella\Retail\Data\\snul_all_years_reg2_ard2", replace
* This generates some duplicates. If that is the case, drop the shop beacuse its coding is dodgy
so luref2 year
ge p0=(luref2==luref2[_n-1] & year==year[_n-1])
bys luref2 year: egen m_p0=max(p0)
bys luref2: egen double m_ruref=mode(g_r), maxmode
drop if m_p0==1 & g_r~=m_ruref
replace luref=luref2 if m_p1==1


bysort luref (year): gen yd = year[_n+1] - year
expand yd
sort luref year

* Note: code imputed values as missings
ge imputed=(year==year[_n-1] & luref==luref[_n-1])
bysort luref year: replace year=year + _n-1

* Example of what I want to do
*so ruref postcode year
*li ruref luref* postcode year  m_luref p1 if ru_pcode==1 & ruref==50000035288
drop luref_n luref_n2  m_luref luref2


so luref year
by luref: gen exit=2 if year~=year[_n-1]+1 
* Exitors
by luref: replace exit=3 if year~=year[_n+1]-1 
* 1 Year: Note, not possible to distinguish for 2003 and 1997
by luref: replace exit=4 if year~=year[_n-1]+1 & year~=year[_n+1]-1 
* Stayers
replace exit =1 if exit==.
replace exit=. if (year==1997 |  year==2004) 
*ta year imputed
replace emp_lu=. if imputed==1


/* Foreign Ownership
replace ultfoc="783" if ultfoc=="000" | ultfoc=="AAA" | ultfoc=="826" 
replace ultfoc="805" if ultfoc=="840"
destring ultfoc, replace
replace ultfoc=783 if ultfoc==.
gen for=(ultfoc~=783)
ge usa = (ultfoc==805)
*/

* Introduce 2003 changes in sic codes
replace sic_lu= 27350 if year>=2003 & sic_lu[_n-1]==27350 & sic_lu==27100
replace sic_lu= 40200 if year>=2003 & (sic_lu==40210 |sic_lu==40220)
replace sic_lu= 51650 if year>=2003 & (sic_lu==51860 |sic_lu==51870)
replace sic_lu= 52482 if year>=2003 & sic_lu==52487 
replace sic_lu= 63120 if year>=2003 & (sic_lu==63121 |sic_lu==63122 | sic_lu==63123 | sic_lu==63129)
replace sic_lu= 66010 if year>=2003 & (sic_lu==66011 |sic_lu==66012)
replace sic_lu= 66030 if year>=2003 & (sic_lu==66031 |sic_lu==66032)
replace sic_lu= 72200 if year>=2003 & (sic_lu==72210 |sic_lu==72220)
replace sic_lu= 74119 if year>=2003 & (sic_lu==74112 |sic_lu==74113 | sic_lu==74119)
ge sic3=int(sic_lu/100)
*ge sic3_ru=int(sic_ru/100)

** Keep only if Local Unit is in Retail
** Record if local unit in wholesale
ge sic2=int(sic_lu/1000)
ge wholesale=sic2==51
bys ruref year: egen m_wholesale=max(whole)
keep if sic2==52
drop wholesale

* Structure of retailer from LU file
** Identify chains
cap drop y
ge y=1
bys ruref year: egen count_luref=count(y)
ge chain=(count_luref>1)

cap drop type
gen type_shop=.
replace type_shop =0 if chain==0
replace type_shop =1 if chain==1 & (count_luref<100)
replace type_shop =2 if chain==1 & count_luref>=100 & count_luref~=.

** Note: a second definition of chains
* Identify local, regional, national reporting units
ta ssr, ge(du_reg)
forvalues y=1(1)11{
bys ruref year: egen sum_du_reg`y'=sum(du_reg`y')
replace sum_du_reg`y'=1 if sum_du_reg`y'>0 & sum_du_reg`y'~=.
}
egen count_reg=rowtotal(sum_du_reg*)

gen type_nat=.
replace type_nat =0 if chain==0
replace type_nat =1 if chain==1 & (count_reg<9)
replace type_nat =2 if chain==1 & count_reg>=9 & count_reg~=.

* Adjust problematic cases
replace type_nat=. if type_nat==0 & emp_lu>100 
replace type_shop=. if type_shop==0 & emp_lu>100 
drop y sum_du* du_reg*

* Too many shops per ruref postcode
ge not_for_analysis=(ru_pcode_year>4 & ru_pcode_year~=.)

* Jumps on emp growth of shop
tsset luref year
ge emp_gro= (emp_lu-L1.emp_lu)/(0.5*(emp_lu+L1.emp_lu))
cap drop outlier
su emp_gro,d
ge outlier=((emp_gro<=r(p1) | emp_gro>=r(p99)) & emp_lu~=. & emp_gro~=.)

label var outlier "Jump in shops employment"
label var not_          "To drop in market by market analysis - too many shops in one postcode"
label var type_nat      "0=Indep, 1=2-8 regions, 2=9-10 regions"  
label var type_shop     "0=Indep, 1=2-99 shops, 2=100 more shops"  
label var count_luref   "Number of shops per ruref year"  
label var imputed       "Jumps in luref across years"
label var ru_pcode_year "Number of shops per ruref postcode year"
label var change_ru     "Dummy=1 if the local unit has change the reporting unit at some point of its history"
drop  m_postcode p1 m_p1 p0 m_p0 m_ruref
save "H:\Raffaella\Retail\Data\luref_reg_ard2", replace

******************************
* Prepare for merge with regulation data
******************************
clear 
set mem 1000m
use "H:\Raffaella\Retail\Data\luref_reg_ard2", replace

local i=1 
while `i'<=8{
cap drop s`i'
gen s`i'=substr(postcode,`i',1)
ta s`i', mis
local i=`i'+1
}

gen t3=s3==" "
gen t4=s4==" "
gen t5=s5==" "

cap drop upos7
gen upos7=s1+s2+s3+" "+s4+s5+s6 if t3==1
replace upos7=s1+s2+s3+" "+s5+s6+s7 if t4==1
replace upos7=s1+s2+s3+s4+s6+s7+s8 if t5==1


local i=1 
while `i'<=7{
cap drop s`i'
gen s`i'=substr(upos7,`i',1)
ta s`i', mis
local i=`i'+1
}

* 372 only have sector postcode information

drop s1-s7 s8
rename county lucounty
save "H:\Raffaella\Retail\Data\luref_reg1_ard2", replace

compress
drop mode_r yd  t3 t4 t5 sic2

sort upos7
merge upos7 using "H:\Raffaella\Retail\Data\afpd05_reduced.dta"
ta _merge

* Impute location for missing values
gen po4=substr(upos7,1,4)

tostring county, gen(nc)
replace nc="09" if county==9
replace nc="00" if county==0
cap drop myladua
gen myladua=nc+ladua
egen mfmyladua=mode(myladua), by(po4) 

* 2 missing values generated
egen mnorth=mean(north), by(po4)
egen meast=mean(east), by(po4)

replace east=meast if east==.
replace north=mnorth if north==.
replace myladua=mfmyladua if myladua=="."

drop if _merge==2
count if myladua=="."

* don't know with 549 remaining cases - drop for now
drop if myladua=="."
rename myladua la_code
drop _m
cap drop v
drop  mnorth meast po4 mfmy 

* Merge with ONS file to get la_names
so la_code
merge la_code using  "H:\Raffaella\Retail\Data\la_code2.dta"
ta _m
* Drop 205: Northern Ireland
keep if _m==3
drop _m
save "H:\Raffaella\Retail\Data\merge_new_pcodes_a_ard2", replace

**********************
* BUILD RAW DATA 
**********************
/* Just recode to then get la aggregates*/
clear
set mem 1000m
use "H:\Raffaella\Retail\Data\merge_new_pcodes_a_ard2", clear
* Replace zero emp with miss, then interpolate
replace emp_lu=. if emp_lu==0

* Replace missing employment with linear interpolation 
so luref year
bys luref: ipolate emp_lu year, ge (emp2)
replace emp_lu=emp2 if emp_lu==. & emp2~=.

* These are shops that could not be interpolated, drop?
ge miss=(emp_lu==.)
bys luref: egen m=max(miss)
ta m

drop if m==1
drop m
drop  temp nc ladua  var1
save "H:\Raffaella\Retail\Data\data_nov_ard2", replace


* Collapse all info at the ruref level
* Look at rurefs that have implausible changes in their stores
use "H:\Raffaella\Retail\Data\data_nov_ard2", clear
gen n_stay   =1    if  exit==1
gen n_entry  =1    if  exit==2
gen n_exit   =1    if  exit==3
gen n_oney   =1    if  exit==4
ge g=1
collapse (sum) n_* g, by(ruref year)
tsset ruref year
save "H:\Raffaella\Retail\Data\ruref_year_ard2", replace


u "H:\Raffaella\Retail\Data\ruref_year_ard2", replace
foreach var in entry exit oney stay{
replace n_`var' =. if year==1997 | year==2004
cap drop delta_`var'
ge delta_`var' =(n_`var'-L1.n_`var')/L1.n_`var'
}
ge delta_s = (g-L1.g)/L1.g
*su delta_s,d

* Nor mark just firms that have jump in stores
* By inspection this seems to be a reporting omission
* Now mark firms that have significant changes in the deltas (>100)
gen prob=(delta_s>100 & delta_s~=.)
bys ruref : egen m_prob=max(prob)

* 271 firms jumping in number of stores (probably stores not recorded before) 
* Recode entry as missing when record starts (or all fake entry otherwise)
so ruref year
li ruref year g delta* n_* if m_prob==1
keep ruref year m_prob  
label var m_prob "Jumps in number of stores per firm"
so ruref year
save "H:\Raffaella\Retail\Data\ruref_year_probs_ard2",replace


* Merge back into main data file the dummies to identify problems
* Note: here I am cleaning only for single stores with excessive employment
* Arbitrary set to 100

use "H:\Raffaella\Retail\Data\data_nov_ard2", clear
so ruref year
mmerge ruref year using "H:\Raffaella\Retail\Data\ruref_year_probs_ard2"
ta _m
drop _m

* Generate marker to clean level dataset
bys luref : egen m_not=max(not_)
ge drop_lev=(m_not==1 | m_prob==1)
bys luref: egen m_drop_lev=max(drop_lev)
ta m_drop_l
drop if m_drop_l==1
drop m_drop_l

* Problems for non realistic independent stores (more than a 100 people now)
bys luref: egen m_cha=max(chain)
ge pro=(m_cha==0 & emp_lu>100 & emp_lu~=.)

* Drop them if they fall in this category (location is ambiguous)
bys luref: egen g=max(pro)
drop if g==1

* Recode as chains others (but remember to include then=m below)
replace chain=1 if (m_cha==1 & emp_lu>100 & emp_lu~=.)
save "H:\Raffaella\Retail\Data\data_nov1_ard2", replace


* This is to build definition of firm according to median firm level employment
clear
set mem 800m
use "H:\Raffaella\Retail\Data\data_nov1_ard2", clear
bys ruref year: egen ruref_emp=sum(emp_lu)
bys ruref year: egen n_shop=count(luref)
so ruref year
drop if ruref==ruref[_n-1] & year==year[_n-1]
keep sic3 ruref year ruref_emp n_shop chain
ge type_alt=.
replace type_alt=0 if chain==0
replace type_alt=1 if (chain==1 & n_shop<=100)
replace type_alt=2 if (chain==1 & n_shop>100 & n_shop~=.)

* Define position on firm in emp distrbution
bys sic3 type_alt: egen m_emp=median(ruref_emp)
* Define shops according to firm charact
ge d_1=(type_alt==0 & ruref_emp<=m_emp)
ge d_2=(type_alt==0 & ruref_emp>m_emp & ruref_emp~=.)
ge d_3=(type_alt==1 & ruref_emp<=m_emp)
ge d_4=(type_alt==1 & ruref_emp>m_emp & ruref_emp~=.)
ge d_5=(type_alt==2 & ruref_emp<=m_emp)
ge d_6=(type_alt==2 & ruref_emp>m_emp & ruref_emp~=.)
so ruref year sic3
save "H:\Raffaella\Retail\Data\data_nov1_ruref_ard2", replace


*  MERGE BACK AGAIN INTO STORES DATA
clear
set mem 800m
use "H:\Raffaella\Retail\Data\data_nov1_ard2", clear
compress
keep type_nat gor m_not luref ruref year outlier not_ imputed emp_lu chain count_reg sic3 la_code count_luref
mmerge ruref year using "H:\Raffaella\Retail\Data\data_nov1_ruref_ard2"
keep if _m==3
drop _m

ge ok=sic3==521
bys luref: egen m=max(ok)
keep if m==1
replace sic3=521

* Generate types
gen type=.
replace type=1 if d_1==1 | d_2==1
replace type=2 if d_3==1 | d_4==1
replace type=3 if d_5==1 | d_6==1

gen type2=.
replace type2=1 if d_1==1 
replace type2=2 if d_2==1
replace type2=3 if d_3==1 | d_4==1
replace type2=4 if d_5==1 | d_6==1
save "H:\Raffaella\Retail\Data\prel", replace
*/


**** Note: file prel.dta manually copied over into this directory
cd "T:\LSE\Raffaella_Sadun\_Papers Replication\Retail\data"

***************
** CHAINS DEFINITIONS
***************
u "prel", replace
keep emp_lu ruref luref year sic3 not_ la_code type*  gor count_reg
gen x=1

* This is to identify types of chains
bys ruref year: egen a=sum(emp_lu)
bys ruref: egen am=mean(a)
bys year: egen a1=sum(emp)
bys ruref year: egen b=sum(x)
bys ruref: egen bm=mean(b)
bys year: egen b1=sum(x)
drop x

* Identify very large stores
bys luref: egen max_e=max(emp_lu)
drop type_alt* type
rename type2 type
ta type, ge (type_)

* These are stores that remain independent
cap drop pro
ge pro=(type==1 | type==2)
replace pro=2 if type==3
replace pro=3 if type==4

* Here need to fix type of stores over time
cap drop m2 m3
bys luref: egen m2=max(pro)
bys luref: egen m3=min(pro)
cap drop indep
ge indep=((m2==m3) & (pro==1))

* These are indep that become parts of chains
ge switch=(m3==1 & m2~=1)
ge chain=(m2~=1 & m3~=1)

* count regions
so ruref gor 
bys ruref: ge n_gor=gor!=gor[_n-1]
bys ruref: egen count_reg2=sum(n_gor)
save  "chains_sept12", replace

u  "chains_sept12", replace
bys ruref year: egen c_max=max(count_reg)
gen check=.
replace check=1 if indep==1
replace check=2 if switch==1
replace check=3 if indep==0 & switch==0
gen very_large=emp_lu>1000 if emp_lu!=.

* Step 1: Define store size based on employment
* 28 is median emp of national chain stores in before 2000 (excluded) - use this as benchmark for all
ge small_all=28
ge size=.
replace size = 1 if emp_lu<small_all  & check==3
replace size = 2 if emp_lu>=small_all & emp_lu~=.  & check==3

* Step 2: Define national retail chains
* Employment cutoff
gen firm1=.
replace firm1=1 if  a<=10000 & check==3
replace firm1=2 if  a>10000 & check==3

* Number of regions
gen firm3=.
replace firm3=1 if  count_reg<10 &check==3
replace firm3=2 if  count_reg>=10 &check==3

* This defines which cutoff is used
ge firm=1 if (firm1==1 | firm1==1) & check==3
replace firm=2 if (firm1==2 & firm1==2) & check==3

/* 
* run to create file to be merged with other store types info
keep luref year firm size emp_lu la_code 
so luref year
save luref_type, replace
*/

drop type*
ge t_new=.
replace t_new=1 if firm==1 & size==1 & check==3
replace t_new=2 if firm==1 & size==2 & check==3
replace t_new=3 if firm==2 & size==1 & check==3
replace t_new=4 if firm==2 & size==2 & check==3
gen aa1=1
ta t_new, ge(tt)
ta firm, ge(ff)
ta size, ge(ss)
tab check, gen(cc)
so luref year
sa  "chains_sept12_precollapse", replace

**************
* FROM NOW ON TO CREATE LOCAL AUTHORITY AGGREGATES
*************
u  "chains_sept12_precollapse", replace
* Keep only chain and independent stores (exclude switchers for simplicity)
drop if check==2

foreach var of varlist aa1 tt* ff* ss* cc*{
cap drop agg_shop_`var'
cap drop emp`var'0 
cap drop agg_emp_`var'
bys la_code year: egen agg_shop_`var'=sum(`var')
gen emp`var'0 = emp_lu if `var'==1
bys la_code year: egen agg_emp_`var'=sum(emp`var'0)
cap drop emp`var'0 
}

* LA wide stats
bys la_code year: egen m_very_large=max(very_large)
so la_code year
drop if la_code==la_code[_n-1]& year==year[_n-1] 
keep la_code year agg_*   m_very*
foreach var in aa1 tt1 tt2 tt3 tt4  ff1 ff2 ss1 ss2 cc1 cc3{
so la_code year
bys la_code: gen delta_emp_`var'=ln(1+agg_emp_`var')-ln(1+agg_emp_`var'[_n-1])
}
so la_code year 
save  "datachains_sept12_v1", replace
