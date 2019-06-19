* *SURVIVAL ANALYSIS

* **SETUP*************************
* *use this database
use "${dir_temp}\temp_${sales}_${database}.dta", clear
*cd "/var/grads/acavallo/prices/"
set more off
* *******************************

display "Starting ${sales}_${database}"


*countchanges
bysort id: egen countchanges=sum(c_mprice)
bysort id: egen freq_id=mean(c_mprice)


*re-construct price change (careful, sometimes not sorted, check output)
tsset id date
gen d_mprice=d.mprice

*first try. I will delete missing values in between.  
drop if miss==1

*keep only variables that I think I will use, to make it more manageable.
keep id date c_mprice inc_mprice dec_mprice bppcat  d_mprice cat_url countchanges freq_id
*****
*For efficiency: I want to delete records where no price changed. In some cases, only first and last records where price is not changed remain. NOTE: this throws away data on ofertas that change and I'm not considering. It is only affecting efficiency, not the results (checked it).  

*mark initial and last records per id (allows to control how to treat censored)
bysort id: egen maxdate=max(date)
bysort id: egen mindate=min(date)
gen first=1 if mindate==date
gen last=1 if maxdate==date
drop maxdate mindate


*this version drops left truncated spells (those at the beginning). 
keep if c_mprice==1 | last==1

*convert to duration format
snapspan id date c_mprice, gen(date0) replace
ren date date1
order id date0 date1


* **duration spells statistics
gen duration=date1-date0
sum duration, detail
local meandur=string(r(mean),"%9.2f")
local mediandur=string(r(p50),"%9.2f")
local sddur=string(r(sd),"%9.2f")
local obsdur=string(r(N),"%9.0f")

*4) If I were to make each spell like a different id.
save temp.dta, replace
use temp.dta, clear
gen pscode=bppcat
levelsof pscode, clean
global listpscode `r(levels)'
capture noisily rm  ${dir_temp}\temp_h_${sales}_${database}.dta
foreach ps in $listpscode {
preserve
keep if pscode==`ps'
stset date1,  time0(date0) origin(time date0) exit(time .) failure(c_mprice) 
stdes
stvary
sts graph , hazard noboundary kernel(gaussian) legend(off) ci level(99) outfile(${dir_results}\\sh_${sales}_${database}, replace)

use "${dir_results}\\sh_${sales}_${database}.dta", clear
keep if _t<360
gsort -hazard 
keep if _n==1
global peak_sh=round(_t,1)
display ${peak_sh}
gen pscode=`ps'
capture append using ${dir_temp}\temp_h_${sales}_${database}.dta
duplicates drop
save ${dir_temp}\temp_h_${sales}_${database}.dta, replace
restore
}

use ${dir_temp}\temp_h_${sales}_${database}.dta, clear
sum _t, detail
global meanpeak_sh=r(mean)
global medianpeak_sh=r(p50)
display ${meanpeak_sh}
display ${medianpeak_sh}
