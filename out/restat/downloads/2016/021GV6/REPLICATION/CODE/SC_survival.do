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

*Delete missing values in between.  
drop if miss==1

*keep only some variables to make it more manageable.
keep id date c_mprice inc_mprice dec_mprice bppcat  d_mprice cat_url countchanges freq_id
*****
*For efficiency: I want to delete records where no price changed. In some cases, only first and last records where price is not changed remain. NOTE: this throws away data on sales that change and I'm not considering. It is only affecting efficiency, not the results (checked it).  

*mark initial and last records per id (allows to control how to treat censored)
bysort id: egen maxdate=max(date)
bysort id: egen mindate=min(date)
gen first=1 if mindate==date
gen last=1 if maxdate==date
drop maxdate mindate

*Drops left truncated spells (those at the beginning). 
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
histogram duration if duration<=360, width(15) percent xlabel(0(60)360) xscale(range(0 360))  title(Duration Spells) note(Notes: 15-day bins. Observations = `obsdur' | Mean = `meandur' | Median = `mediandur' | Stdev=`sddur' )
graph export ${dir_graphs}\survival_histogramspells_${sales}_${database}.png, replace

*averageduration
bysort id: egen averageduration=mean(duration)
gen avdur=1 if averageduration>100
replace avdur=2 if averageduration<=100 & averageduration>50
replace avdur=3 if averageduration<=50

*Treat each spell like a different id. Note that short spells influence the results a lot.
stset date1,  time0(date0) origin(time date0) exit(time .) failure(c_mprice) 
stdes
stvary

*Graph many alternatives
sts graph , hazard noboundary kernel(gaussian) legend(off) ci level(99) outfile(${dir_results}\\sh_${sales}_${database}, replace)
graph export ${dir_graphs}\survival_hazard_a4_${sales}_${database}.png, replace

sts graph , hazard noboundary kernel(gaussian) legend(off) ci level(99) tmax(180)  xlabel(0(10)180) xscale(range(0 180)) 
graph export ${dir_graphs}\survival_hazard_a4_180_${sales}_${database}.png, replace

sts graph , hazard noboundary kernel(gaussian) legend(off) ci level(99) tmax(180) ylabel(0.006(0.002)0.014) yscale(range(0.006 0.014))  xlabel(0(10)180) xscale(range(0 180)) 
graph export ${dir_graphs}\survival_hazard_a4_180_scale_${sales}_${database}.png, replace

sts graph , hazard noboundary kernel(gaussian) legend(off) tmax(180) ci level(99) width(1)  xlabel(0(10)180) xscale(range(0 180)) 
graph export ${dir_graphs}\survival_hazard_a4_s1_180_${sales}_${database}.png, replace

sts graph , hazard noboundary kernel(gaussian) legend(off) tmax(180) ci level(99) width(15)  xlabel(0(10)180) xscale(range(0 180)) 
graph export ${dir_graphs}\survival_hazard_a4_s15_180_${sales}_${database}.png, replace

sts graph, hazard noboundary kernel(gaussian) legend(off) ci level(99) by(avdur)
graph export ${dir_graphs}\survival_hazard_a4_admany_${sales}_${database}.png, replace

sts graph, hazard noboundary kernel(gaussian) tmax(180) legend(off) ci level(99) ylabel(0(0.009)0.027) yscale(range(0 0.027))  xlabel(0(10)180) xscale(range(0 180)) by(avdur)
graph export ${dir_graphs}\survival_hazard_a4_180_admany_${sales}_${database}.png, replace

sts graph, hazard noboundary kernel(gaussian) tmax(360)legend(off) ci  level(99)  xscale(range(0 360))  by(avdur) 
graph export ${dir_graphs}\survival_hazard_a4_360_admany_${sales}_${database}.png, replace


sts generate hazard = h
egen tag=tag(_t)
keep if tag==1
keep hazard _t
gen id="${sales}_${database}"
sort _t
save ${dir_results}\hazard_${sales}_${database}.dta, replace


* qui log close
