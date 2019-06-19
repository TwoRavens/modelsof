* *SURVIVAL ANALYSIS

****************************************************************************
***transform to daily***********
display "Starting ${sales}_${database}"
use "${dir_temp}\temp_${sales}_${database}.dta", clear
set more off
* *******************************


*re-construct price change (careful, sometimes not sorted, check output)
tsset id date
gen d_mprice=d.mprice

drop date
ren daydate date
tsset id date


*countchanges
bysort id: egen countchanges=sum(c_mprice)
bysort id: egen freq_id=mean(c_mprice)


*first try. I will delete missing values in between.  
drop if miss==1

*keep only variables  to make it more manageable.
keep id date c_mprice inc_mprice dec_mprice bppcat d_mprice cat_url countchanges freq_id
*****
*For efficiency: I want to delete records where no price changed. In some cases, only first and last records where price is not changed remain. NOTE: this throws away data on sales that change and I'm not considering. It is only affecting efficiency, not the results (checked it).  

*mark initial and last records per id (allows to control how to treat censored)
bysort id: egen maxdate=max(date)
bysort id: egen mindate=min(date)
drop first
drop last
gen first=1 if mindate==date
gen last=1 if maxdate==date
drop maxdate mindate


*Drops left truncated spells (those at the beginning). 
keep if c_mprice==1 | last==1


*convert to duration format
snapspan id date c_mprice , gen(date0) replace
ren date date1
order id date0 date1

* **duration spells statistics
gen duration=date1-date0
sum duration, detail
local meandur=string(r(mean),"%9.2f")
local mediandur=string(r(p50),"%9.2f")
local sddur=string(r(sd),"%9.2f")
local obsdur=string(r(N),"%9.0f")
histogram duration if duration<=36, width(1) percent xlabel(0(1)36) xscale(range(0 36))  title(Duration Spells) note(Notes: 1-day bins. Observations = `obsdur' | Mean = `meandur' | Median = `mediandur' | Stdev=`sddur' )


*Make each spell like a different id. Note that short spells influence the results a lot.
stset date1,  time0(date0) origin(time date0) exit(time .) failure(c_mprice) 
stdes
stvary

sts graph , hazard noboundary kernel(gaussian) legend(off) ci level(99) outfile(${dir_results}\\sh_${sales}_${database}, replace)
graph export ${dir_graphs}\survival_hazard_a4_${sales}_${database}.png, replace

sts graph , hazard noboundary kernel(gaussian) legend(off) ci  width(1) 
graph export ${dir_graphs}\survival_hazard_a4_DAILY_${sales}_${database}.png , replace 

sts graph , hazard noboundary kernel(gaussian) legend(off) ci level(99) tmax(180) width(1) 
graph export ${dir_graphs}\survival_hazard_a4_DAILY_180_${sales}_${database}.png , replace 

sts graph , hazard noboundary kernel(gaussian) legend(off) ci level(99) tmax(360) width(1) 
graph export ${dir_graphs}\survival_hazard_a4_DAILY_360_${sales}_${database}.png , replace 


sts generate hazard = h
egen tag=tag(_t)
keep if tag==1
keep hazard _t
gen id="${sales}_${database}"
sort _t
save ${dir_results}\hazard_${sales}_${database}.dta, replace






